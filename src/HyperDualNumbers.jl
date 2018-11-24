module HyperDualNumbers

using SpecialFunctions, LinearAlgebra
import NaNMath
import Calculus

include("derivatives_list.jl")
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
    hyper256,
    hyper128,
    hyper64,
    hyperComplex512,
    hyperComplex256,
    hyperComplex128,
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
    imɛ₁ε₂,
    symbolic_derivative_list

end # module
