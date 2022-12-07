export AbstractParameterSet, AbstractParameter, Parameter

export value, domain, name, names!, set_value!, update!, lower_bounds, upper_bounds, set_names!

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

"""Returns the name of the parameters in a parameter set."""
function names(parameter_set::T) where {T <: AbstractParameterSet}
  n = Vector{String}(undef, length(parameter_set))
  return names!(parameter_set, n)
end

"""Returns the name of the parameters in a parameter set in place."""
function names!(parameter_set::T, vals::Vector{String}) where {T <: AbstractParameterSet}
  length(parameter_set) == length(vals) || error("Error: 'vals' should have length $(length(parameter_set)), but has length $(length(vals)).")
  for (i, param_name) in enumerate(fieldnames(T))
    p = getfield(parameter_set, param_name)
    vals[i] = name(p)
  end
  return vals
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
  vals = Vector{Any}(undef, length(parameter_set))
  return values!(parameter_set, vals)
end

"""Returns current values of each parameter in a parameter set in place."""
function values!(parameter_set::T, vals::AbstractVector) where {T <: AbstractParameterSet}
  length(parameter_set) == length(vals) || error("Error: 'vals' should have length $(length(parameter_set)), but has length $(length(vals)).")
  for (i, param_name) in enumerate(fieldnames(T))
    p = getfield(parameter_set, param_name)
    vals[i] = value(p)
  end
  return vals
 end

"""Updates the values of a parameter set by the values given in a vector of values."""
function update!(parameter_set::T, new_values::AbstractVector) where {T <: AbstractParameterSet}
  length(parameter_set) == length(new_values) || error("Error: 'new_values' should have length $(length(parameter_set)), but has length $(length(new_values)).")
  for (i, param_name) in enumerate(fieldnames(T))
    p = getfield(parameter_set, param_name)
    converted_value = convert(p, new_values[i])
    set_value!(p, converted_value)
  end
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

"""Constructor of a continuous parameter x ∈ R bounded by (-∞, ∞)."""
function Parameter(value::T, name::String) where {T <: AbstractFloat}
  domain = RealInterval(T(-Inf), T(Inf); lower_open=true, upper_open=true)
  Parameter(value, domain, name)
end

"""Constructor of a discrete parameter x ∈ Z bounded by (-`typemin(x)`, `typemax(x)`)."""
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

"""Converts a Float to the corresponding type of a giver parameter.
Ex:
```julia
  real_param = Parameter(1.5, RealInterval(0.0, 2.0), "real_param")
  a = 1
  convert(real_param, a)
  1.0
```
"""
function convert(::Parameter{T}, value::P) where {T, P <: AbstractFloat}
  if T <: Union{Integer}
    return round(T, value)
  end
  return convert(T, value)
end

function check_value(domain::AbstractDomain{T}, new_value::T) where T
  new_value ∈ domain || throw(DomainError("value $(new_value) should be in domain"))
end

"""Set value of a parameter."""
function set_value!(parameter::Parameter{T}, new_value::T) where T
  check_value(domain(parameter), new_value)
  parameter.value = new_value
end
