export AbstractParameterSet, fieldnames_num
export value, domain, name, names!, set_value!, set_values!, set_names!
export lower_bounds, upper_bounds, lower_bounds!, upper_bounds!
export length_num, values_num, values_num!, set_values_num!

"""
    AbstractParameterSet
  
An abstract type that represents a set of parameters.

Example:
```julia
  struct MySolverParameterSet <: AbstractParameterSet
    η₁::Parameter(1.0e-5, RealInterval(0, 1; lower_open=true, upper_open=false))
  end
```
"""
abstract type AbstractParameterSet end

"""
    length(::AbstractParameterSet)

Return the number of parameters in an `AbstractParameterSet`.
"""
function length(::T) where {T <: AbstractParameterSet}
  return length(fieldnames(T))
end

"""
    length_num(parameter_set::AbstractParameterSet)

Return the number of numerical parameters in an `AbstractParameterSet`.
"""
function length_num(parameter_set::T) where {T <: AbstractParameterSet}
  k = 0
  for param_name in fieldnames(T)
    p = getfield(parameter_set, param_name)
    if !(typeof(p.domain) <: CategoricalDomain)
      k += 1
    end
  end
  return k
end

function ∈(x::AbstractVector, parameter_set::T) where {T <: AbstractParameterSet}
  for (i, param_name) in enumerate(fieldnames(T))
    p = getfield(parameter_set, param_name)
    converted_value = convert(p, x[i])
    ∈(converted_value, p) || return false
  end
  return true
end

function Base.rand(subset::NTuple{N, Symbol}, param_set::AbstractParameterSet) where {T, N}
  return rand(MersenneTwister(0), subset, param_set)
end
Base.rand(param_set::AbstractParameterSet) = rand(MersenneTwister(0), param_set)

function Base.rand(rng::Random.AbstractRNG, param_set::P) where {P <: AbstractParameterSet}
  return rand(rng, fieldnames(P), param_set)
end

function Base.rand(
  rng::Random.AbstractRNG,
  subset::NTuple{N, Symbol},
  param_set::AbstractParameterSet,
) where {N}
  values = Vector{Any}(undef, length(subset))
  for (i, field) in enumerate(subset)
    param = getfield(param_set, field)
    values[i] = rand(rng, param.domain)
  end
  return values
end

function fieldnames_num(parameter_set::T) where {T <: AbstractParameterSet}
  nn = collect(fieldnames(T))
  for (i, param_name) in enumerate(nn)
    p = getfield(parameter_set, param_name)
    if typeof(p.domain) <: CategoricalDomain
      deleteat!(nn, i)
    end
  end
  return Tuple(nn)
end

"""
    names(parameter_set::AbstractParameterSet)

Return the name of the parameters in an `AbstractParameterSet`.
"""
function names(parameter_set::T) where {T <: AbstractParameterSet}
  n = Vector{String}(undef, length(parameter_set))
  return names!(parameter_set, n)
end

"""
    names!(parameter_set::AbstractParameterSet, vals::Vector{String})

Return the name of the parameters in an `AbstractParameterSet` in place.
"""
function names!(parameter_set::T, vals::Vector{String}) where {T <: AbstractParameterSet}
  length(parameter_set) == length(vals) || error(
    "Error: 'vals' should have length $(length(parameter_set)), but has length $(length(vals)).",
  )
  for (i, param_name) in enumerate(fieldnames(T))
    p = getfield(parameter_set, param_name)
    vals[i] = name(p)
  end
  return vals
end

"""
    set_names!(parameter_set::AbstractParameterSet)

Set the names of parameters in the `AbstractParameterSet` to their fieldnames.
"""
function set_names!(parameter_set::T) where {T <: AbstractParameterSet}
  for param_name in fieldnames(T)
    p = getfield(parameter_set, param_name)
    p.name = string(param_name)
  end
end

"""
    values(parameter_set::AbstractParameterSet)
    values(subset::NTuple{N, Symbol}, parameter_set::AbstractParameterSet)

Return a vector with the current values of each parameter in an `AbstractParameterSet`.
Only a `subset` is returned if an `NTuple` is given.
"""
function values(parameter_set::T) where {T <: AbstractParameterSet}
  vals = Vector{Any}(undef, length(parameter_set))
  return values!(parameter_set, vals)
end

function values(subset::NTuple{N, Symbol}, parameter_set::T) where {T <: AbstractParameterSet, N}
  vals = Vector{Any}(undef, N)
  return values!(subset, parameter_set, vals)
end

"""
    values!(parameter_set::AbstractParameterSet, vals::AbstractVector)
    values!(subset::NTuple{N, Symbol}, parameter_set::AbstractParameterSet, vals::AbstractVector)

Return the current values of each parameter in an `AbstractParameterSet` in place.
Only a `subset` is returned if an `NTuple` is given.
"""
function values!(parameter_set::T, vals::AbstractVector) where {T <: AbstractParameterSet}
  return values!(fieldnames(T), parameter_set, vals)
end

function values!(
  subset::NTuple{N, Symbol},
  parameter_set::T,
  vals::AbstractVector,
) where {T <: AbstractParameterSet, N}
  N == length(vals) ||
    error("Error: 'vals' should have length $(N), but has length $(length(vals)).")
  for (i, param_name) in enumerate(subset)
    p = getfield(parameter_set, param_name)
    vals[i] = value(p)
  end
  return vals
end

"""
    values_num(parameter_set::AbstractParameterSet)
    values_num(subset::NTuple{N, Symbol}, parameter_set::AbstractParameterSet)

Return a vector with the current values of each numerical parameter in an `AbstractParameterSet`.
Only a `subset` is returned if an `NTuple` is given.
"""
function values_num(parameter_set::T) where {T <: AbstractParameterSet}
  vals = Vector{Float64}(undef, length_num(parameter_set))
  return values_num!(parameter_set, vals)
end

function values_num(
  subset::NTuple{N, Symbol},
  parameter_set::T,
) where {T <: AbstractParameterSet, N}
  fields = intersect(subset, fieldnames_num(parameter_set))
  vals = Vector{Float64}(undef, length(fields))
  return values_num!(Tuple(fields), parameter_set, vals)
end

"""
    values_num!(parameter_set::AbstractParameterSet, vals::AbstractVector)
    values_num!(subset::NTuple{N, Symbol}, parameter_set::AbstractParameterSet, vals::AbstractVector)

Return the current values of each numerical parameter in an `AbstractParameterSet` in place.
Only a `subset` is returned if an `NTuple` is given.
"""
function values_num!(parameter_set::T, vals::AbstractVector) where {T <: AbstractParameterSet}
  return values_num!(fieldnames_num(parameter_set), parameter_set, vals)
end

function values_num!(
  subset::NTuple{N, Symbol},
  parameter_set::T,
  vals::AbstractVector{S},
) where {T <: AbstractParameterSet, N, S}
  i = 0
  for param_name in subset
    p = getfield(parameter_set, param_name)
    if !(typeof(p.domain) <: CategoricalDomain)
      i += 1
      vals[i] = S(value(p))
    end
  end
  return vals
end

"""
    set_values!(parameter_set::AbstractParameterSet, new_values::AbstractVector)
    set_values!(subset::NTuple{N, Symbol}, parameter_set::AbstractParameterSet, new_values::AbstractVector)

Update the values of an `AbstractParameterSet` with the values given in the vector `new_values`.
Only a `subset` is updated if an `NTuple` is given.
"""
function set_values!(parameter_set::T, new_values::AbstractVector) where {T <: AbstractParameterSet}
  return set_values!(fieldnames(T), parameter_set, new_values)
end

function set_values!(
  subset::NTuple{N, Symbol},
  parameter_set::T,
  new_values::AbstractVector,
) where {T <: AbstractParameterSet, N}
  N == length(new_values) ||
    error("Error: 'new_values' should have length $(N), but has length $(length(new_values)).")
  for (i, param_name) in enumerate(subset)
    p = getfield(parameter_set, param_name)
    converted_value = convert(p, new_values[i])
    set_value!(p, converted_value)
  end
end

"""
    set_values_num!(parameter_set::AbstractParameterSet, new_values::AbstractVector)
    set_values_num!(subset::NTuple{N, Symbol}, parameter_set::AbstractParameterSet, new_values::AbstractVector)

Update the numerical values of an `AbstractParameterSet` with the values given in the vector `new_values`.
Only a `subset` is updated if an `NTuple` is given.
"""
function set_values_num!(
  parameter_set::T,
  new_values::AbstractVector,
) where {T <: AbstractParameterSet}
  return set_values_num!(fieldnames_num(parameter_set), parameter_set, new_values)
end

function set_values_num!(
  subset::NTuple{N, Symbol},
  parameter_set::T,
  new_values::AbstractVector,
) where {T <: AbstractParameterSet, N}
  i = 0
  for param_name in subset
    p = getfield(parameter_set, param_name)
    if !(typeof(p.domain) <: CategoricalDomain)
      i += 1
      converted_value = convert(p, new_values[i])
      set_value!(p, converted_value)
    end
  end
  return new_values
end

"""
    lower_bounds(parameter_set::AbstractParameterSet)
    lower_bounds(subset::NTuple{N, Symbol}, parameter_set::AbstractParameterSet)

Return a vector with the lower bounds of each numerical parameter in an `AbstractParameterSet`.
"""
function lower_bounds(parameter_set::T) where {T <: AbstractParameterSet}
  lower_bounds = Vector{Any}(undef, length_num(parameter_set))
  return lower_bounds!(parameter_set, lower_bounds)
end

function lower_bounds(
  subset::NTuple{N, Symbol},
  parameter_set::T,
) where {T <: AbstractParameterSet, N}
  fields = intersect(subset, fieldnames_num(parameter_set))
  lower_bounds = Vector{Any}(undef, length(fields))
  return lower_bounds!(Tuple(fields), parameter_set, lower_bounds)
end

"""
    lower_bounds!(parameter_set::AbstractParameterSet, vals::AbstractVector)
    lower_bounds!(subset::NTuple{N, Symbol}, parameter_set::AbstractParameterSet, vals::AbstractVector)

Return the lower bounds of each numerical parameter in an `AbstractParameterSet` in place.
"""
function lower_bounds!(parameter_set::T, vals::AbstractVector) where {T <: AbstractParameterSet}
  return lower_bounds!(fieldnames_num(parameter_set), parameter_set, vals)
end

function lower_bounds!(
  subset::NTuple{N, Symbol},
  parameter_set::T,
  vals::AbstractVector,
) where {T <: AbstractParameterSet, N}
  i = 0
  for param_name in subset
    p = getfield(parameter_set, param_name)
    if !(typeof(p.domain) <: CategoricalDomain)
      i += 1
      d = domain(p)
      vals[i] = lower(d)
    end
  end
  return vals
end

"""
    upper_bounds(parameter_set::AbstractParameterSet)
    upper_bounds(subset::NTuple{N, Symbol}, parameter_set::AbstractParameterSet)

Return a vector with the upper bounds of each numerical parameter in an `AbstractParameterSet`.
"""
function upper_bounds(parameter_set::T) where {T <: AbstractParameterSet}
  upper_bounds = Vector{Any}(undef, length_num(parameter_set))
  return upper_bounds!(parameter_set, upper_bounds)
end

function upper_bounds(
  subset::NTuple{N, Symbol},
  parameter_set::T,
) where {T <: AbstractParameterSet, N}
  fields = intersect(subset, fieldnames_num(parameter_set))
  upper_bounds = Vector{Any}(undef, length(fields))
  return upper_bounds!(Tuple(subset), parameter_set, upper_bounds)
end

"""
    upper_bounds!(parameter_set::T, vals::AbstractVector)
    upper_bounds!(subset::NTuple{N, Symbol}, parameter_set::T, vals::AbstractVector)

Return the lower bounds of each numerical parameter in an `AbstractParameterSet` in place.
"""
function upper_bounds!(parameter_set::T, vals::AbstractVector) where {T <: AbstractParameterSet}
  return upper_bounds!(fieldnames_num(parameter_set), parameter_set, vals)
end

function upper_bounds!(
  subset::NTuple{N, Symbol},
  parameter_set::T,
  vals::AbstractVector,
) where {T <: AbstractParameterSet, N}
  i = 0
  for param_name in subset
    p = getfield(parameter_set, param_name)
    if !(typeof(p.domain) <: CategoricalDomain)
      i += 1
      d = domain(p)
      vals[i] = upper(d)
    end
  end
  return vals
end
