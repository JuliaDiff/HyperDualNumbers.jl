module HyperDualNumbers

  import Base: <=, >=, +, -, *, /, ^, ==, <, >, isnan, convert,
    promote_rule, promote_type, one, sin, cos, tan, acos, asin, atan,
    sqrt, exp, abs, abs2, real, log

  import SpecialFunctions: erf

  using Compat

  include("hyperdual.jl")
  
  export
    Hyper,
    Hyper256,
    Hyper128,
    hyper,
    hyper256,
    hyper128,
    ishyper,
    hyper_show,
    realpart,
    eps1,
    eps2,
    eps1eps2,
    conjhyper,
    erf

end # module
