export DefaultParameter

"""
    DefaultParameter{Dflt}

Structure used to simplify declaring default parameters in solvers and docstrings.

- `default::Dflt`: is the default value, it can be a Number, a Symbol or even a function.
- `str::String`: message to be printed or used in docstrings.

Constructors

   DefaultParameter(default)
   DefaultParameter(default, str)
"""
struct DefaultParameter{Dflt}
   default::Dflt
   str::String
end
DefaultParameter(default) = DefaultParameter(default, string(default))

function Base.show(io::IO, default_parameter::DefaultParameter) # Use this instead of [2]
  return print(io, default_parameter.str)
end

function Base.get(default_parameter::DefaultParameter, args...)
  default_parameter.default(args...)
end
function Base.get(default_parameter::DefaultParameter{<:Union{Number,Symbol}}, args...)
  default_parameter.default
end
