export AbstractDomain,
  RealDomain,
  RealInterval,
  IntegerDomain,
  IntegerRange,
  BinaryDomain,
  BinaryRange,
  IntegerSet,
  CategoricalDomain,
  CategoricalSet

export lower, upper

"""`AbstractDomain{T}`

An abstract domain type that superseeds any specific domain implementation.

- `lower(d::AbstractDomain{T})`: return the lower bound of the domain;
- `upper(d::AbstractDomain{T})`: return the upper bound of the domain;
- `∈(x::T, D::AbstractDomain{T})`: return `true` if a value `x` is in the domain and `false` otherwise.

See [`RealInterval`](@ref), [`IntegerRange`](@ref), [`IntegerSet`](@ref), [`BinaryRange`](@ref), [`CategoricalSet`](@ref) for concrete implementations.

`lower` and `upper` are not implemented for categorical domains.
"""
abstract type AbstractDomain{T} end

∈(::T, ::AbstractDomain{T}) where {T} = false
lower(::AbstractDomain{T}) where {T} =
  throw(DomainError("Lower bound is undefined for this domain."))
upper(::AbstractDomain{T}) where {T} =
  throw(DomainError("Upper bound is undefined for this domain."))

"""
Real domain for continuous variables
"""
abstract type RealDomain{T <: Real} <: AbstractDomain{T} end

"""
    RealInterval{T <: Real} <: RealDomain{T}

    RealInterval(lower::T, upper::T; lower_open::Bool = false, upper_open::Bool = false)

Interval of possible values for a real variable.

Examples:
```julia
RealInterval(1.3, 4.9)
```
"""
mutable struct RealInterval{T <: Real} <: RealDomain{T}
  lower::T
  upper::T
  lower_open::Bool
  upper_open::Bool
  function RealInterval(
    lower::T,
    upper::T;
    lower_open::Bool = false,
    upper_open::Bool = false,
  ) where {T <: Real}
    lower ≤ upper || error("lower bound ($lower) must be less than upper bound ($upper)")
    new{T}(lower, upper, lower_open, upper_open)
  end
end
lower(D::RealInterval) = D.lower
upper(D::RealInterval) = D.upper

∈(x::T, D::RealInterval{T}) where {T <: Real} = begin
  (D.lower_open ? lower(D) < x : lower(D) ≤ x) && (D.upper_open ? x < upper(D) : x ≤ upper(D))
end

function Base.rand(rng::Random.AbstractRNG, d::RealInterval)
  r = rand(rng, T)
  low = lower(d)
  upp = upper(d)
  return r * (upp - low) + low
end

function Base.rand(rng::Random.AbstractRNG, d::RealInterval{T}) where {T <: AbstractFloat}
  r = rand(rng, T)
  bnd = 1 / eps(T)
  low = if lower(d) == -Inf || !d.lower_open
    lower(d)
  else
    lower(d) + eps(T)
  end
  low = max(low, -bnd)
  upp = if upper(d) == -Inf || !d.lower_open
    upper(d)
  else
    upper(d) - eps(T)
  end
  upp = min(upp, bnd)
  return r * (upp - low) + low
end

function Base.rand(rng::Random.AbstractRNG, d::RealInterval{T}) where {T <: Integer}
  r = rand(rng, T)
  low = d.lower_open ? lower(d) + 1 : lower(d)
  upp = d.upper_open ? upper(d) - 1 : upper(d)
  return r * (upp - low) + low
end

"""
Integer domain for discrete variables:
  - Integer range;
  - Integer set;
  - Binary range.
"""
abstract type IntegerDomain{T <: Integer} <: AbstractDomain{T} end

"""
    IntegerRange{T <: Integer} <: IntegerDomain{T}

    IntegerRange(lower::T, upper::T)

Interval of possible values for an integer variable.

Examples:
```julia
IntegerRange(1, 4)
```
"""
mutable struct IntegerRange{T <: Integer} <: IntegerDomain{T}
  lower::T
  upper::T

  function IntegerRange(lower::T, upper::T) where {T <: Integer}
    lower ≤ upper || error("lower bound ($lower) must be less than upper bound ($upper)")
    new{T}(lower, upper)
  end
end
lower(D::IntegerRange) = D.lower
upper(D::IntegerRange) = D.upper

∈(x::T, D::IntegerRange{T}) where {T <: Integer} = lower(D) ≤ x ≤ upper(D)

Base.rand(rng::Random.AbstractRNG, d::IntegerRange) = rand(rng, (d.lower):(d.upper))

"""
    BinaryRange{T <: Bool} <: IntegerDomain{T}

    BinaryRange()

Binary range for boolean parameters.
Note: This concrete type is not mutable as it would break the purpose of a binary range.

Examples:
```julia
BinaryRange()
```
"""
struct BinaryRange{T <: Bool} <: IntegerDomain{T}
  BinaryRange() = new{Bool}()
end
lower(D::BinaryRange{Bool}) = false
upper(D::BinaryRange{Bool}) = true
∈(x::T, D::BinaryRange{T}) where {T <: Bool} = true
Base.rand(rng::Random.AbstractRNG, ::BinaryRange) = rand(rng, Bool)

"""
    IntegerSet{T} <: IntegerDomain{T}

    IntegerSet(values::Vector{T <: Integer})

Set of possible values for an integer variable.

Examples:
```julia
IntegerSet(1, 3, 4)
```
"""
mutable struct IntegerSet{T <: Integer} <: IntegerDomain{T}
  set::Set{T}

  function IntegerSet(values::Vector{T}) where {T <: Integer}
    new{T}(Set{T}(values))
  end
end
∈(x::T, D::IntegerSet{T}) where {T <: Integer} = in(x, D.set)

lower(D::IntegerSet{T}) where {T <: Integer} = min(D.set...)
upper(D::IntegerSet{T}) where {T <: Integer} = max(D.set...)

Base.rand(rng::Random.AbstractRNG, d::IntegerSet) = rand(rng, d.set)

"""
Categorical domain for categorical variables.
"""
abstract type CategoricalDomain{T} <: AbstractDomain{T} end

"""
    CategoricalSet{T} <: CategoricalDomain{T}

    CategoricalSet(Vector{T})
    CategoricalSet()

Set of possible values for a categorical variable.

Examples:
```julia
CategoricalSet()
```

```julia
CategoricalSet("A", "B")
```

```julia
CategoricalSet(:A, :B)
```
"""
mutable struct CategoricalSet{T} <: CategoricalDomain{T}
  categories::Vector{T}
end
CategoricalSet() = CategoricalSet(Vector{String}())
∈(x::T, D::CategoricalSet{T}) where {T} = x in D.categories
Base.rand(rng::Random.AbstractRNG, d::CategoricalSet) = rand(rng, Set(d.categories))
