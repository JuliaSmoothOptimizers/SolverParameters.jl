export AbstractParameterSet, AbstractParameter, Parameter

export value,
  domain,
  name,
  set_value!,
  lower_bounds,
  upper_bounds


""" `AbstractParameterSet`
An abstract type that represents a set of multiple parameters. 
  Ex:
  mutable struct MySolverParameterSet <: AbstractParameterSet
    η₁::Parameter(1.0e-5, RealInterval(0, 1; lower_open=true, upper_open=false))
  end
"""  
abstract type AbstractParameterSet end


"""`AbstractParameter`

An Abstract type that superseeds the other parameter types.
"""
abstract type AbstractParameter{T} end

"""`AlgorithmicParameter`

Child type of `Parameter` that exposes a specific hyperparameter.
It contains specific fields that can be given to `NOMAD`.

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


"""Returns the current value of a parameter."""
value(parameter::Parameter{T}) where {T} = parameter.value

domain(parameter::Parameter{T}) where {T} = parameter.domain

"""Returns the name of a parameter."""
name(parameter::Parameter{T}) where {T} = parameter.name

function check_value(domain::AbstractDomain{T}, new_value::P) where {T, P <:Real}
  T(new_value) ∈ domain || throw(DomainError("value $(new_value) should be in domain"))
end

"""Set value of an algorithmic parameter."""
function set_value!(
  parameter::Parameter{T},
  new_value::F,
) where {T, F}
  check_value(domain(parameter), new_value)
  parameter.value = new_value
end

"""Function that returns lower bounds of each parameter."""
function lower_bounds(parameters::AbstractVector{P}) where {P <: Parameter}
  [lower(domain(p)) for p ∈ parameters]
end

"""Function that returns upper bounds of each parameter."""
function upper_bounds(parameters::AbstractVector{P}) where {P <: Parameter}
  [upper(domain(p)) for p ∈ parameters]
end


