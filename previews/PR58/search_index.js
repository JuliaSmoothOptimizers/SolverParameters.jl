var documenterSearchIndex = {"docs":
[{"location":"reference/#Reference","page":"Reference","title":"Reference","text":"","category":"section"},{"location":"reference/","page":"Reference","title":"Reference","text":"​","category":"page"},{"location":"reference/#Contents","page":"Reference","title":"Contents","text":"","category":"section"},{"location":"reference/","page":"Reference","title":"Reference","text":"​","category":"page"},{"location":"reference/","page":"Reference","title":"Reference","text":"Pages = [\"reference.md\"]","category":"page"},{"location":"reference/","page":"Reference","title":"Reference","text":"​","category":"page"},{"location":"reference/#Index","page":"Reference","title":"Index","text":"","category":"section"},{"location":"reference/","page":"Reference","title":"Reference","text":"​","category":"page"},{"location":"reference/","page":"Reference","title":"Reference","text":"Pages = [\"reference.md\"]","category":"page"},{"location":"reference/","page":"Reference","title":"Reference","text":"​","category":"page"},{"location":"reference/","page":"Reference","title":"Reference","text":"Modules = [SolverParameters]","category":"page"},{"location":"reference/#SolverParameters.AbstractDomain","page":"Reference","title":"SolverParameters.AbstractDomain","text":"AbstractDomain{T}\n\nAn abstract domain type that superseeds any specific domain implementation.\n\nlower(d::AbstractDomain{T}): return the lower bound of the domain;\nupper(d::AbstractDomain{T}): return the upper bound of the domain;\n∈(x::T, D::AbstractDomain{T}): return true if a value x is in the domain and false otherwise.\n\nSee RealInterval, IntegerRange, IntegerSet, BinaryRange, CategoricalSet for concrete implementations.\n\nlower and upper are not implemented for categorical domains.\n\n\n\n\n\n","category":"type"},{"location":"reference/#SolverParameters.AbstractParameter","page":"Reference","title":"SolverParameters.AbstractParameter","text":"AbstractParameter{T}\n\nAn abstract type for parameters of value type T.\n\n\n\n\n\n","category":"type"},{"location":"reference/#SolverParameters.AbstractParameterSet","page":"Reference","title":"SolverParameters.AbstractParameterSet","text":"AbstractParameterSet\n\nAn abstract type that represents a set of parameters.\n\nExample:\n\n  struct MySolverParameterSet <: AbstractParameterSet\n    η₁::Parameter(1.0e-5, RealInterval(0, 1; lower_open=true, upper_open=false))\n  end\n\n\n\n\n\n","category":"type"},{"location":"reference/#SolverParameters.BinaryRange","page":"Reference","title":"SolverParameters.BinaryRange","text":"BinaryRange{T <: Bool} <: IntegerDomain{T}\n\nBinaryRange()\n\nBinary range for boolean parameters. Note: This concrete type is not mutable as it would break the purpose of a binary range.\n\nExamples:\n\nBinaryRange()\n\n\n\n\n\n","category":"type"},{"location":"reference/#SolverParameters.CategoricalDomain","page":"Reference","title":"SolverParameters.CategoricalDomain","text":"Categorical domain for categorical variables.\n\n\n\n\n\n","category":"type"},{"location":"reference/#SolverParameters.CategoricalSet","page":"Reference","title":"SolverParameters.CategoricalSet","text":"CategoricalSet{T} <: CategoricalDomain{T}\n\nCategoricalSet(Vector{T})\nCategoricalSet()\n\nSet of possible values for a categorical variable.\n\nExamples:\n\nCategoricalSet()\n\nCategoricalSet(\"A\", \"B\")\n\nCategoricalSet(:A, :B)\n\n\n\n\n\n","category":"type"},{"location":"reference/#SolverParameters.IntegerDomain","page":"Reference","title":"SolverParameters.IntegerDomain","text":"Integer domain for discrete variables:\n\nInteger range;\nInteger set;\nBinary range.\n\n\n\n\n\n","category":"type"},{"location":"reference/#SolverParameters.IntegerRange","page":"Reference","title":"SolverParameters.IntegerRange","text":"IntegerRange{T <: Integer} <: IntegerDomain{T}\n\nIntegerRange(lower::T, upper::T)\n\nInterval of possible values for an integer variable.\n\nExamples:\n\nIntegerRange(1, 4)\n\n\n\n\n\n","category":"type"},{"location":"reference/#SolverParameters.IntegerSet","page":"Reference","title":"SolverParameters.IntegerSet","text":"IntegerSet{T} <: IntegerDomain{T}\n\nIntegerSet(values::Vector{T <: Integer})\n\nSet of possible values for an integer variable.\n\nExamples:\n\nIntegerSet(1, 3, 4)\n\n\n\n\n\n","category":"type"},{"location":"reference/#SolverParameters.Parameter","page":"Reference","title":"SolverParameters.Parameter","text":"Parameter{T, AbstractDomain{T}} <: AbstractParameter{T}\n\nParameter(value::T; name::String = \"\")\nParameter(value::T, domain::AbstractDomain{T}; name::String = \"\")\nParameter(value::T, domain::AbstractDomain{T}, name::String)\n\nA Parameter structure handles the following attributes describing one parameter:\n\nvalue::T: default value of the parameter;\ndomain::AbstractDomain{T}: domain of the possible values of the parameter;\nname::String: name of the parameter.\n\nIf no domain is specified, the constructor uses (-typemin(x), typemax(x)) as domain.\n\nExamples:\n\n  Parameter(Float64(42))\n\n  Parameter(\"A\", CategoricalSet([\"A\", \"B\", \"C\", \"D\"]))\n\n  Parameter(Int32(5), IntegerRange(Int32(5), Int32(20)))\n\n\n\n\n\n","category":"type"},{"location":"reference/#SolverParameters.RealDomain","page":"Reference","title":"SolverParameters.RealDomain","text":"Real domain for continuous variables\n\n\n\n\n\n","category":"type"},{"location":"reference/#SolverParameters.RealInterval","page":"Reference","title":"SolverParameters.RealInterval","text":"RealInterval{T <: Real} <: RealDomain{T}\n\nRealInterval(lower::T, upper::T; lower_open::Bool = false, upper_open::Bool = false)\n\nInterval of possible values for a real variable.\n\nExamples:\n\nRealInterval(1.3, 4.9)\n\n\n\n\n\n","category":"type"},{"location":"reference/#Base.convert-Union{Tuple{T}, Tuple{Parameter{T, D} where D<:AbstractDomain{T}, Any}} where T<:AbstractFloat","page":"Reference","title":"Base.convert","text":"convert(::Parameter{T}, value)\n\nConverts a value to the corresponding type of a giver parameter. If T is an integer, this function will first round the value.\n\nExamples:\n\nreal_param = Parameter(1.5, RealInterval(0.0, 2.0), \"real_param\");\na = 1;\nconvert(real_param, a)\n\n# output\n\n1.0\n\nint_param = Parameter(1, IntegerRange(1, 4), \"int_param\");\na = 1.6;\nconvert(int_param, a)\n\n# output\n\n2\n\n\n\n\n\n","category":"method"},{"location":"reference/#Base.length-Tuple{T} where T<:AbstractParameterSet","page":"Reference","title":"Base.length","text":"length(::AbstractParameterSet)\n\nReturn the number of parameters in an AbstractParameterSet.\n\n\n\n\n\n","category":"method"},{"location":"reference/#Base.names-Tuple{T} where T<:AbstractParameterSet","page":"Reference","title":"Base.names","text":"names(parameter_set::AbstractParameterSet)\n\nReturn the name of the parameters in an AbstractParameterSet.\n\n\n\n\n\n","category":"method"},{"location":"reference/#Base.values-Tuple{T} where T<:AbstractParameterSet","page":"Reference","title":"Base.values","text":"values(parameter_set::AbstractParameterSet)\nvalues(subset::NTuple{N, Symbol}, parameter_set::AbstractParameterSet)\n\nReturn a vector with the current values of each parameter in an AbstractParameterSet. Only a subset is returned if an NTuple is given.\n\n\n\n\n\n","category":"method"},{"location":"reference/#SolverParameters.check_value-Union{Tuple{T}, Tuple{AbstractDomain{T}, T}} where T","page":"Reference","title":"SolverParameters.check_value","text":"check_value(domain::AbstractDomain{T}, new_value::T)\n\nThrow a DomainError if new_value is not in the domain.\n\n\n\n\n\n","category":"method"},{"location":"reference/#SolverParameters.domain-Union{Tuple{Parameter{T, D} where D<:AbstractDomain{T}}, Tuple{T}} where T","page":"Reference","title":"SolverParameters.domain","text":"domain(parameter::Parameter{T})\n\nReturns the domain of a parameter.\n\n\n\n\n\n","category":"method"},{"location":"reference/#SolverParameters.length_num-Tuple{T} where T<:AbstractParameterSet","page":"Reference","title":"SolverParameters.length_num","text":"length_num(parameter_set::AbstractParameterSet)\n\nReturn the number of numerical parameters in an AbstractParameterSet.\n\n\n\n\n\n","category":"method"},{"location":"reference/#SolverParameters.lower_bounds!-Union{Tuple{T}, Tuple{T, AbstractVector}} where T<:AbstractParameterSet","page":"Reference","title":"SolverParameters.lower_bounds!","text":"lower_bounds!(parameter_set::AbstractParameterSet, vals::AbstractVector)\nlower_bounds!(subset::NTuple{N, Symbol}, parameter_set::AbstractParameterSet, vals::AbstractVector)\n\nReturn the lower bounds of each numerical parameter in an AbstractParameterSet in place.\n\n\n\n\n\n","category":"method"},{"location":"reference/#SolverParameters.lower_bounds-Tuple{T} where T<:AbstractParameterSet","page":"Reference","title":"SolverParameters.lower_bounds","text":"lower_bounds(parameter_set::AbstractParameterSet)\nlower_bounds(subset::NTuple{N, Symbol}, parameter_set::AbstractParameterSet)\n\nReturn a vector with the lower bounds of each numerical parameter in an AbstractParameterSet.\n\n\n\n\n\n","category":"method"},{"location":"reference/#SolverParameters.name-Union{Tuple{Parameter{T, D} where D<:AbstractDomain{T}}, Tuple{T}} where T","page":"Reference","title":"SolverParameters.name","text":"name(parameter::Parameter{T})\n\nReturns the name of a parameter.\n\n\n\n\n\n","category":"method"},{"location":"reference/#SolverParameters.names!-Union{Tuple{T}, Tuple{T, Vector{String}}} where T<:AbstractParameterSet","page":"Reference","title":"SolverParameters.names!","text":"names!(parameter_set::AbstractParameterSet, vals::Vector{String})\n\nReturn the name of the parameters in an AbstractParameterSet in place.\n\n\n\n\n\n","category":"method"},{"location":"reference/#SolverParameters.set_names!-Tuple{T} where T<:AbstractParameterSet","page":"Reference","title":"SolverParameters.set_names!","text":"set_names!(parameter_set::AbstractParameterSet)\n\nSet the names of parameters in the AbstractParameterSet to their fieldnames.\n\n\n\n\n\n","category":"method"},{"location":"reference/#SolverParameters.set_value!-Union{Tuple{T}, Tuple{Parameter{T, D} where D<:AbstractDomain{T}, T}} where T","page":"Reference","title":"SolverParameters.set_value!","text":"set_value!(parameter::Parameter{T}, new_value::T)\n\nSet value of a parameter. It throws a DomainError if new_value is not in the domain of the parameter.\n\n\n\n\n\n","category":"method"},{"location":"reference/#SolverParameters.set_values!-Union{Tuple{T}, Tuple{T, AbstractVector}} where T<:AbstractParameterSet","page":"Reference","title":"SolverParameters.set_values!","text":"set_values!(parameter_set::AbstractParameterSet, new_values::AbstractVector)\nset_values!(subset::NTuple{N, Symbol}, parameter_set::AbstractParameterSet, new_values::AbstractVector)\n\nUpdate the values of an AbstractParameterSet with the values given in the vector new_values. Only a subset is updated if an NTuple is given.\n\n\n\n\n\n","category":"method"},{"location":"reference/#SolverParameters.set_values_num!-Union{Tuple{T}, Tuple{T, AbstractVector}} where T<:AbstractParameterSet","page":"Reference","title":"SolverParameters.set_values_num!","text":"set_values_num!(parameter_set::AbstractParameterSet, new_values::AbstractVector)\nset_values_num!(subset::NTuple{N, Symbol}, parameter_set::AbstractParameterSet, new_values::AbstractVector)\n\nUpdate the numerical values of an AbstractParameterSet with the values given in the vector new_values. Only a subset is updated if an NTuple is given.\n\n\n\n\n\n","category":"method"},{"location":"reference/#SolverParameters.upper_bounds!-Union{Tuple{T}, Tuple{T, AbstractVector}} where T<:AbstractParameterSet","page":"Reference","title":"SolverParameters.upper_bounds!","text":"upper_bounds!(parameter_set::T, vals::AbstractVector)\nupper_bounds!(subset::NTuple{N, Symbol}, parameter_set::T, vals::AbstractVector)\n\nReturn the lower bounds of each numerical parameter in an AbstractParameterSet in place.\n\n\n\n\n\n","category":"method"},{"location":"reference/#SolverParameters.upper_bounds-Tuple{T} where T<:AbstractParameterSet","page":"Reference","title":"SolverParameters.upper_bounds","text":"upper_bounds(parameter_set::AbstractParameterSet)\nupper_bounds(subset::NTuple{N, Symbol}, parameter_set::AbstractParameterSet)\n\nReturn a vector with the upper bounds of each numerical parameter in an AbstractParameterSet.\n\n\n\n\n\n","category":"method"},{"location":"reference/#SolverParameters.value-Union{Tuple{Parameter{T, D} where D<:AbstractDomain{T}}, Tuple{T}} where T","page":"Reference","title":"SolverParameters.value","text":"value(parameter::Parameter{T})\n\nReturns the current value of a parameter.\n\n\n\n\n\n","category":"method"},{"location":"reference/#SolverParameters.values!-Union{Tuple{T}, Tuple{T, AbstractVector}} where T<:AbstractParameterSet","page":"Reference","title":"SolverParameters.values!","text":"values!(parameter_set::AbstractParameterSet, vals::AbstractVector)\nvalues!(subset::NTuple{N, Symbol}, parameter_set::AbstractParameterSet, vals::AbstractVector)\n\nReturn the current values of each parameter in an AbstractParameterSet in place. Only a subset is returned if an NTuple is given.\n\n\n\n\n\n","category":"method"},{"location":"reference/#SolverParameters.values_num!-Union{Tuple{T}, Tuple{T, AbstractVector}} where T<:AbstractParameterSet","page":"Reference","title":"SolverParameters.values_num!","text":"values_num!(parameter_set::AbstractParameterSet, vals::AbstractVector)\nvalues_num!(subset::NTuple{N, Symbol}, parameter_set::AbstractParameterSet, vals::AbstractVector)\n\nReturn the current values of each numerical parameter in an AbstractParameterSet in place. Only a subset is returned if an NTuple is given.\n\n\n\n\n\n","category":"method"},{"location":"reference/#SolverParameters.values_num-Tuple{T} where T<:AbstractParameterSet","page":"Reference","title":"SolverParameters.values_num","text":"values_num(parameter_set::AbstractParameterSet)\nvalues_num(subset::NTuple{N, Symbol}, parameter_set::AbstractParameterSet)\n\nReturn a vector with the current values of each numerical parameter in an AbstractParameterSet. Only a subset is returned if an NTuple is given.\n\n\n\n\n\n","category":"method"},{"location":"","page":"Home","title":"Home","text":"CurrentModule = SolverParameters","category":"page"},{"location":"#SolverParameters","page":"Home","title":"SolverParameters","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Documentation for SolverParameters.","category":"page"},{"location":"tutorial/#Tutorial-SolverParameters.jl","page":"Tutorial SolverParameters.jl","title":"Tutorial SolverParameters.jl","text":"","category":"section"},{"location":"tutorial/#Contents","page":"Tutorial SolverParameters.jl","title":"Contents","text":"","category":"section"},{"location":"tutorial/","page":"Tutorial SolverParameters.jl","title":"Tutorial SolverParameters.jl","text":"Pages = [\"tutorial.md\"]","category":"page"},{"location":"tutorial/#Example","page":"Tutorial SolverParameters.jl","title":"Example","text":"","category":"section"},{"location":"tutorial/","page":"Tutorial SolverParameters.jl","title":"Tutorial SolverParameters.jl","text":"This example describes a simple parameter set with a real, a categorical and an integer parameter.","category":"page"},{"location":"tutorial/","page":"Tutorial SolverParameters.jl","title":"Tutorial SolverParameters.jl","text":"using SolverParameters\n\nstruct CatMockSolverParamSet{I, F} <: AbstractParameterSet\n  real_inf::Parameter{F, RealInterval{F}}\n  real::Parameter{String, CategoricalSet{String}}\n  int_r::Parameter{I, IntegerRange{I}}\nend\n\nfunction CatMockSolverParamSet()\n  CatMockSolverParamSet(\n    Parameter(Float64(42)),\n    Parameter(\"A\", CategoricalSet([\"A\", \"B\", \"C\", \"D\"])),\n    Parameter(Int32(5), IntegerRange(Int32(5), Int32(20))),\n  )\nend\n\nparam_set = CatMockSolverParamSet()","category":"page"},{"location":"tutorial/#Access-values","page":"Tutorial SolverParameters.jl","title":"Access values","text":"","category":"section"},{"location":"tutorial/","page":"Tutorial SolverParameters.jl","title":"Tutorial SolverParameters.jl","text":"It is straightforward to access the default values of each parameter","category":"page"},{"location":"tutorial/","page":"Tutorial SolverParameters.jl","title":"Tutorial SolverParameters.jl","text":"values(param_set)","category":"page"},{"location":"tutorial/","page":"Tutorial SolverParameters.jl","title":"Tutorial SolverParameters.jl","text":"or only the numerical parameters","category":"page"},{"location":"tutorial/","page":"Tutorial SolverParameters.jl","title":"Tutorial SolverParameters.jl","text":"values_num(param_set)","category":"page"},{"location":"tutorial/","page":"Tutorial SolverParameters.jl","title":"Tutorial SolverParameters.jl","text":"val = zeros(Float32, 2)\nvalues_num!(param_set, val)","category":"page"},{"location":"tutorial/#Getter","page":"Tutorial SolverParameters.jl","title":"Getter","text":"","category":"section"},{"location":"tutorial/","page":"Tutorial SolverParameters.jl","title":"Tutorial SolverParameters.jl","text":"The default value can be replaced, for instance with values randomly chosen in the domain of each parameter.","category":"page"},{"location":"tutorial/","page":"Tutorial SolverParameters.jl","title":"Tutorial SolverParameters.jl","text":"nw = rand(param_set)\nnw ∈ param_set","category":"page"},{"location":"tutorial/","page":"Tutorial SolverParameters.jl","title":"Tutorial SolverParameters.jl","text":"set_values!(param_set, nw)","category":"page"},{"location":"tutorial/","page":"Tutorial SolverParameters.jl","title":"Tutorial SolverParameters.jl","text":"The number of parameters or numerical parameters is accessible with length.","category":"page"},{"location":"tutorial/","page":"Tutorial SolverParameters.jl","title":"Tutorial SolverParameters.jl","text":"(length(param_set), length_num(param_set))","category":"page"},{"location":"tutorial/","page":"Tutorial SolverParameters.jl","title":"Tutorial SolverParameters.jl","text":"Lower and upper bounds on the domains can be accessed as well:","category":"page"},{"location":"tutorial/","page":"Tutorial SolverParameters.jl","title":"Tutorial SolverParameters.jl","text":"(lower_bounds(param_set), upper_bounds(param_set))","category":"page"},{"location":"tutorial/#Access-subset-of-parameters","page":"Tutorial SolverParameters.jl","title":"Access subset of parameters","text":"","category":"section"},{"location":"tutorial/","page":"Tutorial SolverParameters.jl","title":"Tutorial SolverParameters.jl","text":"Most of the functionalities described above can be used for only a subset of parameters by defining an NTuple.","category":"page"},{"location":"tutorial/","page":"Tutorial SolverParameters.jl","title":"Tutorial SolverParameters.jl","text":"subset = (:real_inf, :real)\nvalues(subset, param_set)","category":"page"},{"location":"tutorial/","page":"Tutorial SolverParameters.jl","title":"Tutorial SolverParameters.jl","text":"The getter are also available in place, which allows to pre-allocate the type of vector.","category":"page"},{"location":"tutorial/","page":"Tutorial SolverParameters.jl","title":"Tutorial SolverParameters.jl","text":"subset = (:real_inf,)\ntmp = zeros(1)\nvalues_num!(subset, param_set, tmp)","category":"page"}]
}
