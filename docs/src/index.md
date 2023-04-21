```@meta
CurrentModule = SolverParameters
```

# SolverParameters

Documentation for [SolverParameters](https://github.com/JuliaSmoothOptimizers/SolverParameters.jl).

# Example

This example describes a simple parameter set with a real, a categorical and an integer parameter.

```@example ex1
using SolverParameters

struct CatMockSolverParamSet{I, F} <: AbstractParameterSet
  real_inf::Parameter{F, RealInterval{F}}
  real::Parameter{String, CategoricalSet{String}}
  int_r::Parameter{I, IntegerRange{I}}
end

function CatMockSolverParamSet()
  CatMockSolverParamSet(
    Parameter(Float64(42)),
    Parameter("A", CategoricalSet(["A", "B", "C", "D"])),
    Parameter(Int32(5), IntegerRange(Int32(5), Int32(20))),
  )
end

param_set = CatMockSolverParamSet()
```

It is straightforward to access the default values of each parameter

```@example ex1
values(param_set)
```

or only the numerical parameters

```@example ex1
values_num(param_set)
```

The default value can be replaced, for instance with values randomly chosen in the domain of each parameter.

```@example ex1
nw = rand(param_set)
nw ∈ param_set
```

```@example ex1
set_values(param_set, nw)
```

The number of parameters or numerical parameters is accessible with `length`.

```@example ex1
(length(param_set), length_num(param_set))
```

Lower and upper bounds on the domains can be accessed as well:

```@example ex1
(lower_bounds(param_set), upper_bounds(param_set))
```

Most of the functionalities described above can be used for only a subset of parameters by defining an `NTuple`.

```@example ex1
subset = (:real_inf, :real)
values(subset, param_set)
```

The getter are also available in place, which allows to pre-allocate the type of vector.

```@example ex1
subset = (:real_inf,)
tmp = zeros(1)
values_num!(subset, param_set, tmp)
```
