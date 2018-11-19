module HyperDualNumbers

using SpecialFunctions
import NaNMath
import Calculus

include("hyperdual.jl")

export
    Hyper,
    Hyper256,
    Hyper128,
    Hyper64,
    HyperComplex512,
    HyperComplex256,
    HyperComplex128,
    hyper,
    realpart,
    ɛ₁part,
    ɛ₂part,
    ɛ₁ε₂part,
    eps1,
    eps2,
    eps1eps2,
    ishyper,
    hyper_show,
    conjhyper,
    abshyper,
    abs2hyper,
    ɛ₁,
    ɛ₂,
    ɛ₁ε₂,
    imɛ₁,
    imɛ₂,
    imɛ₁ε₂

end # module
