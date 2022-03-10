export AbstractParameter, AbstractSolverParameter, AbstractHyperParameter, AlgorithmicParameter

export default,
  domain,
  name,
  granularity,
  set_default!,
  find,
  lower_bounds,
  upper_bounds,
  current_param_values,
  granularities,
  input_types

"""`AbstractParameter`

An Abstract type that superseeds the other parameter types.
"""
abstract type AbstractParameter{T} end

"""`AbstractSolverParameter`

An abstract solver parameter type that represent any parameter specific to a solver.
It should be a parameter of the solver and not a hyperparameter.

Example of an `AbstractSolverParameter`: 
```julia

mutable struct MySolver{T,V,P<:AbstractSolverParameter}
  x::T
  some_field::V
  atol::P 
  rtol::P
  max_eval::P
  max_time::P
  verbose::P
end
```
"""
abstract type AbstractSolverParameter{T} <: AbstractParameter{T} end

"""`AbstractHyperParameter`
An abstract solver parameter type that represent any hyperparameter of a solver.

Example of an `AbstractHyperParameter`: 
```julia

mutable struct MySolver{T,V,H <:AbstractHyperParameter}
  x::T
  some_field::V
  memory::H
  initial_radius_size::H
end
"""
abstract type AbstractHyperParameter{T} <: AbstractParameter{T} end

"""`AlgorithmicParameter`

Child type of `AbstractHyperParameter` that exposes a specific hyperparameter.
It contains specific fields that can be given to `NOMAD`.

"""
mutable struct AlgorithmicParameter{T, D <: AbstractDomain{T}} <: AbstractHyperParameter{T}
  default::T
  domain::D
  name::String
  granularity::Float64
  function AlgorithmicParameter(default::T, domain::AbstractDomain{T}, name::String) where {T}
    check_default(domain, default)
    granularity = default_granularity(eltype(domain))
    new{T, typeof(domain)}(default, domain, name, granularity)
  end
end

"""Returns the current value of a parameter."""
default(parameter::AlgorithmicParameter{T}) where {T} = parameter.default

domain(parameter::AlgorithmicParameter{T}) where {T} = parameter.domain

"""Returns the name of a parameter."""
name(parameter::AlgorithmicParameter{T}) where {T} = parameter.name

"""
Returns the granularity of a parameter.
This is a field to pass to `NOMAD`.
"""
granularity(parameter::AlgorithmicParameter{T}) where {T} = parameter.granularity

"""
Returns the nomad type.
This is a field to pass to `NOMAD`.
"""
nomad_type(::Type{T}) where {T <: Real} = "R"
nomad_type(::Type{T}) where {T <: Integer} = "I"
nomad_type(::Type{T}) where {T <: Bool} = "B"

function check_default(domain::AbstractDomain{T}, new_value::P) where {T, P <:Real}

  T(new_value) ∈ domain || error("default value should be in domain")
end

"""Set default value of an algorithmic parameter."""
function set_default!(
  parameter::AlgorithmicParameter{T},
  new_value::F,
) where {T, F <: AbstractFloat}
  if nomad_type(eltype(domain(parameter))) == "I"
    new_value = round(Int, new_value)
  end
  if nomad_type(eltype(domain(parameter))) == "B"
    new_value = convert(Bool, round(Int, new_value))
  end
  check_default(parameter.domain, new_value)
  parameter.default = new_value
end

function default_granularity(input_type::T) where {T}
  (nomad_type(input_type) == "R") && return zero(Float64)
  return one(Float64)
end

"""Find a parameter in a list by its name."""
function find(parameters::AbstractVector{P}, param_name) where {P <: AbstractHyperParameter}
  idx = findfirst(p -> p.name == param_name, parameters)
  isnothing(idx) || return parameters[idx]
  return
end

"""Function that returns lower bounds of each parameter."""
function lower_bounds(parameters::AbstractVector{P}) where {P <: AbstractHyperParameter}
  [Float64(lower(domain(p))) for p ∈ parameters]
end

"""Function that returns upper bounds of each parameter."""
function upper_bounds(parameters::AbstractVector{P}) where {P <: AbstractHyperParameter}
  [Float64(upper(domain(p))) for p ∈ parameters]
end

"""Function that returns a vector of current parameter values."""
function current_param_values(parameters::AbstractVector{P}) where {P <: AbstractHyperParameter}
  [Float64(default(p)) for p ∈ parameters]
end

"""Function that returns a vector of granularity for all parameters depending on their type."""
function granularities(parameters::AbstractVector{P}) where {P <: AbstractHyperParameter}
  [p.granularity for p ∈ parameters]
end

"""Function that returns a vector of types understood by `NOMAD`."""
function input_types(parameters::AbstractVector{P}) where {P <: AbstractHyperParameter}
  return [nomad_type(eltype(domain(p))) for p ∈ parameters]
end
