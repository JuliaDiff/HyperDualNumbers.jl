using HyperDualNumbers
using Literate
using Documenter
using Documenter, CmdStan

makedocs(
    modules = [HyperDualNumbers],
    format = :html,
    sitename = "HyperDualNumbers.jl",
    pages = Any[
        "Home" => "index.md",
    ]
)

deploydocs(
    repo = "github.com/JuliaDiff/HyperDualNumbers.jl.git",
 )