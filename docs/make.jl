using SolverParameters
using Documenter

DocMeta.setdocmeta!(SolverParameters, :DocTestSetup, :(using SolverParameters); recursive = true)

makedocs(;
  modules = [SolverParameters],
  doctest = true,
  linkcheck = false,
  strict = false,
  authors = "Abel Soares Siqueira <abel.s.siqueira@gmail.com> and contributors",
  repo = "https://github.com/JuliaSmoothOptimizers/SolverParameters.jl/blob/{commit}{path}#{line}",
  sitename = "SolverParameters.jl",
  format = Documenter.HTML(;
    prettyurls = get(ENV, "CI", "false") == "true",
    canonical = "https://JuliaSmoothOptimizers.github.io/SolverParameters.jl",
    assets = ["assets/style.css"],
  ),
  pages = ["Home" => "index.md", "Reference" => "reference.md"],
)

deploydocs(;
  repo = "github.com/JuliaSmoothOptimizers/SolverParameters.jl",
  push_preview = true,
  devbranch = "main",
)
