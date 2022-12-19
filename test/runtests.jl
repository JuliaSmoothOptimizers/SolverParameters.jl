using Base: Float64, Int32
using Test
using SolverParameters

const TYPES = (Int, Float32, Float64)

check_allocations = (v"1.7" <= VERSION)

include(joinpath("domains", "test_abstract_domains.jl"))
include(joinpath("domains", "test_real_domains.jl"))
include(joinpath("domains", "test_categorical_domains.jl"))

include("test_parameters.jl")
