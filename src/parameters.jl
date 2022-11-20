import Base.length
import Base.values
export AbstractParameterSet, AbstractParameter, Parameter

export value, domain, name, set_value!, lower_bounds, upper_bounds, set_names!

""" `AbstractParameterSet`
An abstract type that represents a set of multiple parameters. 
  Ex:
  ```
  mutable struct MySolverParameterSet <: AbstractParameterSet
    η₁::Parameter(1.0e-5, RealInterval(0, 1; lower_open=true, upper_open=false))
  end
  ```
"""

abstract type AbstractParameterSet end

"""Returns the number of parameters in a parameter set."""
function length(::T) where {T <: AbstractParameterSet}
  return length(fieldnames(T))
end

"""Set names of parameters to their fieldnames."""
function set_names!(parameter_set::T) where {T <: AbstractParameterSet}
  for param_name in fieldnames(T)
    p = getfield(parameter_set, param_name)
    p.name = string(param_name)
  end
end

"""Returns current values of each parameter in a parameter set."""
function values(parameter_set::T) where {T <: AbstractParameterSet}
  values = Vector{Any}(undef, length(parameter_set))
  for (i, param_name) in enumerate(fieldnames(T))
    p = getfield(parameter_set, param_name)
    values[i] = value(p)
  end
  return values
end

"""Returns lower bounds of each parameter in a parameter set."""
function lower_bounds(parameter_set::T) where {T <: AbstractParameterSet}
  lower_bounds = Vector{Any}(undef, length(parameter_set))
  return lower_bounds!(parameter_set, lower_bounds)
end

"""Returns lower bounds of each parameter in a parameter set in place."""
function lower_bounds!(parameter_set::T, vals::AbstractVector) where {T <: AbstractParameterSet}
  length(parameter_set) == length(vals) || error("Error: 'vals' should have length $(length(parameter_set)), but has length $(length(vals)).")
  for (i,param_name) in enumerate(fieldnames(T))
    p = getfield(parameter_set, param_name)
    d = domain(p)
    vals[i] = lower(d)
  end
  return vals
end

"""Function that returns upper bounds of each parameter in a parameter set."""
function upper_bounds(parameter_set::T) where {T <: AbstractParameterSet}
  upper_bounds = Vector{Any}(undef, length(parameter_set))
  return upper_bounds!(parameter_set, upper_bounds)
end

"""Returns upper bounds of each parameter in a parameter set in place."""
function upper_bounds!(parameter_set::T, vals::AbstractVector) where {T <: AbstractParameterSet}
  length(parameter_set) == length(vals) || error("Error: 'vals' should have length $(length(parameter_set)), but has length $(length(vals)).")
  for (i, param_name) in enumerate(fieldnames(T))
    p = getfield(parameter_set, param_name)
    d = domain(p)
    vals[i] = upper(d)
  end
  return vals
end

"""`AbstractParameter`

An Abstract type that superseeds the other parameter types.
"""
abstract type AbstractParameter{T} end

"""`Parameter`

Child type of `AbstractParameter` that exposes a specific parameter.
"""
mutable struct Parameter{T, D <: AbstractDomain{T}} <: AbstractParameter{T}
  value::T
  domain::D
  name::String
  function Parameter(value::T, domain::AbstractDomain{T}, name::String) where {T}
    check_value(domain, value)
    new{T, typeof(domain)}(value, domain, name)
  end
end

function Parameter(value::T, name::String) where {T <: Real}
  domain = RealInterval(T(-Inf), T(Inf); lower_open=true, upper_open=true)
  Parameter(value, domain, name)
end

function Parameter(value::T, name::String) where {T <: Integer}
  domain = IntegerRange(typemin(T), typemax(T))
  Parameter(value, domain, name)
end

"""Returns the current value of a parameter."""
value(parameter::Parameter{T}) where {T} = parameter.value

"""Returns the domain of a parameter."""
domain(parameter::Parameter{T}) where {T} = parameter.domain

"""Returns the name of a parameter."""
name(parameter::Parameter{T}) where {T} = parameter.name

function check_value(domain::AbstractDomain{T}, new_value::T) where T
  new_value ∈ domain || throw(DomainError("value $(new_value) should be in domain"))
end

"""Set value of a parameter."""
function set_value!(parameter::Parameter{T}, new_value::T) where T
  check_value(domain(parameter), new_value)
  parameter.value = new_value
end
