module HyperDualNumbers

  importall Base
  
  include("hyperdual.jl")
  
  export
    Hyper,
    Hyper64,
    Hyper32,
    hyper,
    hyper64,
    hyper32,
    ishyper,
    hyper_show,
    eps1,
    eps2,
    eps1eps2,
    abshyper,
    abs2hyper

end # module
