module SolverParameters

using Random
import Base.rand

import Base.∈
import Base.length
import Base.values
import Base.names
import Base.convert

export enum

include("default-parameter.jl")
include("domains.jl")
include("parameters.jl")
include("parameterset.jl")

end
