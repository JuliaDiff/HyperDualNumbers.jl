# HyperDualNumbers

Hyper-dual numbers can be used to compute first and second derivatives numerically without the cancellation errors of finite-differencing schemes.

The initial Julia implementation (and up to v3.0.1) is directly based on the C++ implementation by Jeffrey Fike and Juan J Alonso, both of Stanford University, department of Aeronautics and Astronautics and is described in the paper:

[The Development of Hyper-Dual Numbers for Exact Second Derivative Calculations](https://adl.stanford.edu/hyperdual/Fike_AIAA-2011-886.pdf)

Those initial versions have been derived/written by Rob J Goedman (goedman@icloud.com).

HyperDualNumbers.jl v4.0.0 has been completely redone by Benoit Pasquier and follows the structure of the [JuliaDiff/DualNumbers](https://github.com/JuliaDiff/DualNumbers.jl) package.]


```@meta
CurrentModule = HyperDualNumbers
```

## Creation of a HyperDualNumber
```@docs
HyperDualNumbers.Hyper()
```

## Symbolic derivative list
```@docs
HyperDualNumbers.symbolic_derivative_list
```

## Fields of a HyperDualNumber
```@docs
HyperDualNumbers.ɛ₁
HyperDualNumbers.ɛ₂
HyperDualNumbers.ε₁ɛ₂
```

## Index
```@index
```
