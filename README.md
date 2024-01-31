# SolverParameters

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://JuliaSmoothOptimizers.github.io/SolverParameters.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://JuliaSmoothOptimizers.github.io/SolverParameters.jl/dev)
[![Build Status](https://github.com/JuliaSmoothOptimizers/SolverParameters.jl/workflows/CI/badge.svg)](https://github.com/JuliaSmoothOptimizers/SolverParameters.jl/actions)
[![Build Status](https://api.cirrus-ci.com/github/JuliaSmoothOptimizers/SolverParameters.jl.svg)](https://cirrus-ci.com/github/JuliaSmoothOptimizers/SolverParameters.jl)
[![Docs workflow Status](https://github.com/JuliaSmoothOptimizers/SolverParameters.jl/actions/workflows/Docs.yml/badge.svg?branch=main)](https://github.com/JuliaSmoothOptimizers/SolverParameters.jl/actions/workflows/Docs.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/JuliaSmoothOptimizers/SolverParameters.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaSmoothOptimizers/SolverParameters.jl)

Tools to manage set of parameters.
Our primary target is to provide an abstract interface to handle parameters in solvers.

## How to Cite

If you use SolverParameters.jl in your work, please cite using the format given in [CITATION.cff](https://github.com/JuliaSmoothOptimizers/SolverParameters.jl/blob/main/CITATION.cff).

## Installation

<p>
SolverParameters is a &nbsp;
    <a href="https://julialang.org">
        <img src="https://raw.githubusercontent.com/JuliaLang/julia-logo-graphics/master/images/julia.ico" width="16em">
        Julia Language
    </a>
    &nbsp; package. To install SolverParameters,
    please <a href="https://docs.julialang.org/en/v1/manual/getting-started/">open
    Julia's interactive session (known as REPL)</a> and press <kbd>]</kbd> key in the REPL to use the package mode, then type the following command
</p>

```julia
pkg> add SolverParameters
```

## Example

The main feature of this package is to define a Julia type to handle set of parameters.
The following example is a brief illustration showing how to define a new set of parameters.

```julia
using SolverParameters

struct CatMockSolverParamSet{I, F} <: AbstractParameterSet
  real_inf::Parameter{F, RealInterval{F}}
  real::Parameter{String, CategoricalSet{String}}
  int_r::Parameter{I, IntegerRange{I}}
end

function CatMockSolverParamSet() # add a default constructor
  CatMockSolverParamSet(
    Parameter(Float64(42)),
    Parameter("A", CategoricalSet(["A", "B", "C", "D"])),
    Parameter(Int32(5), IntegerRange(Int32(5), Int32(20))),
  )
end

param_set = CatMockSolverParamSet()
```

It is then possible to use all the API defined in this package and described in the documentation on `param_set`.

## Bug reports and discussions

If you think you found a bug, feel free to open an [issue](https://github.com/JuliaSmoothOptimizers/SolverParameters.jl/issues).
Focused suggestions and requests can also be opened as issues. Before opening a pull request, start an issue or a discussion on the topic, please.

If you want to ask a question not suited for a bug report, feel free to start a discussion [here](https://github.com/JuliaSmoothOptimizers/Organization/discussions). This forum is for general discussion about this repository and the [JuliaSmoothOptimizers](https://github.com/JuliaSmoothOptimizers) organization, so questions about any of our packages are welcome.
