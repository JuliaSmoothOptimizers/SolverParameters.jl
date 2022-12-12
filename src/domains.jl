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

"""`AbstractDomain`

An abstract domain type that superseeds any specific domain implementation.
Child types don't need any specific field, but they should implement the following functions:

- `lower(d::ChildDomain{T})`
- `upper(d::ChildDomain{T})`
- `∈(x::T, D::ChildDomain{T})`

- `lower` should return the lower bound of the domain.
- `upper` should return the upper bound of the domain.
- `∈` should return `true` if a value `x` is in the domain and `false` otherwise.
"""
abstract type AbstractDomain{T} end

∈(::T, ::AbstractDomain{T}) where {T} = false
lower(::AbstractDomain{T}) where {T} =
  throw(DomainError("Lower bound is undefined for this domain."))
upper(::AbstractDomain{T}) where {T} =
  throw(DomainError("Upper bound is undefined for this domain."))
"""
Real Domain for continuous variables
"""
abstract type RealDomain{T <: Real} <: AbstractDomain{T} end
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

"""
Integer Domain for discrete variables.
    1. Integer range
    2. Integer Set
    """
abstract type IntegerDomain{T <: Integer} <: AbstractDomain{T} end
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
"""
Binary range for boolean parameters.
Note: This concrete type is not mutable as it would break the purpose of a binary range.
e.g:
b = BinaryRange()
"""
struct BinaryRange{T <: Bool} <: IntegerDomain{T}
  BinaryRange() = new{Bool}()
end
lower(D::BinaryRange{Bool}) = false
upper(D::BinaryRange{Bool}) = true
∈(x::T, D::BinaryRange{T}) where {T <: Bool} = true

mutable struct IntegerSet{T <: Integer} <: IntegerDomain{T}
  set::Set{T}

  function IntegerSet(values::Vector{T}) where {T <: Integer}
    new{T}(Set{T}(values))
  end
end
∈(x::T, D::IntegerSet{T}) where {T <: Integer} = in(x, D.set)

lower(D::IntegerSet{T}) where {T <: Integer} = min(D.set...)
upper(D::IntegerSet{T}) where {T <: Integer} = max(D.set...)

"""
Categorical Domain for categorical variables.
"""
abstract type CategoricalDomain{T <: AbstractString} <: AbstractDomain{T} end
mutable struct CategoricalSet{T <: AbstractString} <: CategoricalDomain{T}
  categories::Vector{T}
end
CategoricalSet() = CategoricalSet(Vector{AbstractString}())
∈(x::T, D::CategoricalSet{T}) where {T <: AbstractString} = x in D.categories
