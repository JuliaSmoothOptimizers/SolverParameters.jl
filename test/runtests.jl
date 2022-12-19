using Base: Float64, Int32
using Test
using SolverParameters

const TYPES = (Int, Float32, Float64)

check_allocations = (v"1.7" <= VERSION)

include("test_domains.jl")
include("test_parameters.jl")
