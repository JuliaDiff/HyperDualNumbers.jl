using HyperDualNumbers
using Documenter

const src_path = @__DIR__

"Relative path using the HypoerDualNumbers src/ directory."
rel_path(parts...) = normpath(joinpath(src_path, parts...))

DOCROOT = rel_path("../docs")

makedocs(root = DOCROOT,
    modules = Module[],
    sitename = "HyperDualNumbers.jl",
    pages = Any["index.md"]
)

deploydocs(root = DOCROOT,
    repo = "github.com/JuliaDiff/HyperDualNumbers.jl.git"
 )
 