export Parameter, AbstractParameter, value, domain, name, check_value, set_value!

"""
    AbstractParameter{T}

An Abstract type for parameters of value type `T`.
"""
abstract type AbstractParameter{T} end

"""
    Parameter{T, AbstractDomain{T}} <: AbstractParameter{T}

    Parameter(value::T; name::String = "")
    Parameter(value::T, domain::AbstractDomain{T}; name::String = "")
    Parameter(value::T, domain::AbstractDomain{T}, name::String)

A `Parameter` structure handles the following attributes describing one parameter:
  - `value::T`: default value of the parameter;
  - `domain::AbstractDomain{T}`: domain of the possible values of the parameter;
  - `name::String`: name of the parameter.

If no domain is specified, the constructor uses (-`typemin(x)`, `typemax(x)`) as domain.

Examples:
```julia
  Parameter(Float64(42))
  Parameter("A", CategoricalSet(["A", "B", "C", "D"]))
  Parameter(Int32(5), IntegerRange(Int32(5), Int32(20)))
```
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

function Parameter(value::T; name::String = "") where {T <: AbstractFloat}
  domain = RealInterval(T(-Inf), T(Inf); lower_open = true, upper_open = true)
  Parameter(value, domain, name)
end

function Parameter(value::T; name::String = "") where {T <: Integer}
  domain = IntegerRange(typemin(T), typemax(T))
  Parameter(value, domain, name)
end

function Parameter(value::T, domain::AbstractDomain{T}; name::String = "") where {T}
  Parameter(value, domain, name)
end

"""Returns the current value of a parameter."""
value(parameter::Parameter{T}) where {T} = parameter.value

"""Returns the domain of a parameter."""
domain(parameter::Parameter{T}) where {T} = parameter.domain

"""Returns the name of a parameter."""
name(parameter::Parameter{T}) where {T} = parameter.name

"""
    convert(::Parameter{T}, value)

Converts a `value` to the corresponding type of a giver parameter.
If `T` is integer, this function will first round the `value`.

Examples:
```julia
  real_param = Parameter(1.5, RealInterval(0.0, 2.0), "real_param")
  a = 1
  convert(real_param, a)
  1.0
```

```julia
  int_param = Parameter(1, IntegerRange(1, 4), "int_param")
  a = 1.6
  convert(int_param, a)
  2
```
"""
function convert(::Parameter{T}, value) where {T <: AbstractFloat}
  return convert(T, value)
end

function convert(::Parameter{T}, value) where {T <: Integer}
  return round(T, value)
end

function convert(::Parameter{Bool}, value)
  return round(Int, value) != 0
end

function convert(::Parameter, value) # Symbol, String, Function ...
  return value
end

∈(a, p::Parameter) = ∈(a, domain(p))

"""
    check_value(domain::AbstractDomain{T}, new_value::T)

Throw a `DomainError` if `new_value` is not in the `domain`.
"""
function check_value(domain::AbstractDomain{T}, new_value::T) where {T}
  new_value ∈ domain || throw(DomainError("value $(new_value) should be in domain"))
end

"""
    set_value!(parameter::Parameter{T}, new_value::T)

Set value of a parameter.
It throws a `DomainError` if `new_value` is not in the `domain` of the `parameter`.
"""
function set_value!(parameter::Parameter{T}, new_value::T) where {T}
  check_value(domain(parameter), new_value)
  parameter.value = new_value
end
