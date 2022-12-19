export Parameter, AbstractParameter, value, domain, name, check_value, set_value!

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
function Parameter(value::T; name::String = "") where {T <: AbstractFloat}
  domain = RealInterval(T(-Inf), T(Inf); lower_open = true, upper_open = true)
  Parameter(value, domain, name)
end

"""Constructor of a discrete parameter x ∈ Z bounded by (-`typemin(x)`, `typemax(x)`)."""
function Parameter(value::T; name::String = "") where {T <: Integer}
  domain = IntegerRange(typemin(T), typemax(T))
  Parameter(value, domain, name)
end

"""Constructor of an arbitrary parameter whose default name is an empty string."""
function Parameter(value::T, domain::AbstractDomain{T}; name::String = "") where {T}
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

function check_value(domain::AbstractDomain{T}, new_value::T) where {T}
  new_value ∈ domain || throw(DomainError("value $(new_value) should be in domain"))
end

"""Set value of a parameter."""
function set_value!(parameter::Parameter{T}, new_value::T) where {T}
  check_value(domain(parameter), new_value)
  parameter.value = new_value
end
