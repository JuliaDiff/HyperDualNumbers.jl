# HyperDualNumbers

This Julia implementation is directly based on the C++ implementation by Jeffrey Fike and Juan Alonso, both of Stanford University, department of Aeronautics and Astronautics and is described in the paper:

[The Development of Hyper-Dual Numbers for Exact Second Derivative Calculations](https://adl.stanford.edu/hyperdual/Fike_AIAA-2011-886.pdf)

The Julia package is structured similar to the DualNumbers package, which aims for complete support for `HyperDual` types for numerical functions within Julia's `Base`. Currently, basic mathematical operations and trigonometric functions are supported.

The following functions are specific to hyperdual numbers:
* `Hyper`,
* `Hyper256`,
* `Hyper128`,
* `hyper`,
* `hyper256`,
* `hyper128`,
* `eps1`,
* `eps2`,
* `eps1eps2`,
* `ishyper`,
* `hyper_show`

### A walk-through example

The example below demonstrates basic usage of dual numbers by employing them to 
perform automatic differentiation. The code for this example can be found in 
`test/automatic_differentiation_test.jl`.

First install the package by using the Julia package manager:

    Pkg.update()
    Pkg.clone("https://github.com/goedman/HyperDualNumbers.jl.git")
    
Then make the package available via

    using HyperDualNumbers

Use the `dual()` function to define the dual number `2+1*du`:

    hd0 = hyper()
    hd1 = hyper(1.0)
    t0 = hyper(1.5, 1.0, 1.0, 0.0)

Define a function that will be differentiated, say

    f(x) = e^x / (sqrt(sin(x)^3 + cos(x)^3))

Perform automatic differentiation by passing the dual number `x` as argument to 
`f`:

    y = f(hd2)

Use the functions `real()`, `eps1()` to get the real and imaginary (dual) 
parts of `x`, respectively:

    println("f(1.5) = ", f(1.5))
    println("f(t0) = ", real(f(t0)))
    println("f'(t0) = ", eps1(f(t0)))
    println("f'(t0) = ", eps2(f(t0)))
    println("f''(t0) = ", eps1eps2(f(t0)))

### TBD

1) Graphs (as in Jeffrey Fike's paper)
2) Profiling
3) Compare with Standard Library
4) Cross-validate with other relevant Julia packages
5) Make it a proper package, e.g. dependencies. etc.