using HyperDualNumbers
using Documenter

makedocs(
    modules = [HyperDualNumbers],
    format = :html,
    sitename = "HyperDualNumbers.jl",
    pages = Any[
        "Home" => "index.md",
    ]
)

deploydocs(
    repo = "github.com/JuliaDiff/HyperDualNumbers.jl.git"
 )