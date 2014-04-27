# HyperDualNumbers

[![Build Status](https://travis-ci.org/goedman/HyperDualNumbers.jl.svg)](https://travis-ci.org/goedman/HyperDualNumbers.jl)

This Julia implementation is directly based on the C++ implementation by Jeffrey Fike and Juan J Alonso, both of Stanford University, department of Aeronautics and Astronautics and is described in the paper:

[The Development of Hyper-Dual Numbers for Exact Second Derivative Calculations](https://adl.stanford.edu/hyperdual/Fike_AIAA-2011-886.pdf)

The Julia version was derived/written by Rob J Goedman (goedman@icloud.com).
Tagged as v0.1.2 on 4/21/2014

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

Many other Julia packages related to Automatic Differentiation are available, e.g. PowerSeries.jl, TaylorSeries.jl and DualNumbers.jl. More are under development.

### A walk-through example

The example below demonstrates basic usage of hyperdual numbers by employing them to 
perform automatic differentiation. The code for this example can be found in 
`test/runtests.jl`.

First install the package by using the Julia package manager:

    Pkg.add("HyperDualNumbers")
    
Then make the package available via

    using HyperDualNumbers

Use the `hyper()` function to define a hyperual number, e.g.:

    hd0 = hyper()
    hd1 = hyper(1.0)
    hd2 = hyper(3.0, 1.0, 1.0, 0.0)
    hd3 = hyper(3//2, 1//1, 1//1,0//1)

HyperDual to compute first & second derivative at 1.5:

    t0 = hyper(1.5, 1.0, 1.0, 0.0)

Define a function that will be differentiated, say

    f(x) = e^x / (sqrt(sin(x)^3 + cos(x)^3))

Perform automatic differentiation by passing the hyperdual number `t0` as argument to `f`:

    y = f(t0)

Use the functions `real()`, `eps1()` or `eps2()` and `eps1eps2()` to get the function evaluation, the first derivative and the second derivative, e.g.:

    println("f(1.5) = ", f(1.5))
    println("f(t0) = ", real(f(t0)))
    println("f'(t0) = ", eps1(f(t0)))
    println("f'(t0) = ", eps2(f(t0)))
    println("f''(t0) = ", eps1eps2(f(t0)))

### TBD

Wish list:

1) A generic hyper-number package to support multiple types (Complex, Double & Dual)
   and variable order (e.g. order 1 is dual, order 2 is as in this package, etc.)
2) Graphs (as in Jeffrey Fike's paper)
3) Profiling
4) Compare with Standard Library
5) Cross-validate with other relevant Julia packages
6) Make it a proper package, e.g. dependencies. etc.