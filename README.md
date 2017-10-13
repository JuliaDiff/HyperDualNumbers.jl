# HyperDualNumbers

[![HyperDualNumbers](http://pkg.julialang.org/badges/HyperDualNumbers_0.4.svg)](http://pkg.julialang.org/?pkg=HyperDualNumbers&ver=0.4) [![HyperDualNumbers](http://pkg.julialang.org/badges/HyperDualNumbers_0.5.svg)](http://pkg.julialang.org/?pkg=HyperDualNumbers&ver=0.5)
[![HyperDualNumbers](http://pkg.julialang.org/badges/HyperDualNumbers_0.6.svg)](http://pkg.julialang.org/?pkg=HyperDualNumbers&ver=0.6)

[![Coverage Status](https://coveralls.io/repos/JuliaDiff/HyperDualNumbers.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/JuliaDiff/HyperDualNumbers.jl?branch=master)
[![codecov](https://codecov.io/gh/JuliaDiff/HyperDualNumbers.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaDiff/HyperDualNumbers.jl?branch=master)

Unix/OSX:  [![Travis Build Status](https://travis-ci.org/JuliaDiff/HyperDualNumbers.jl.svg?branch=master)](https://travis-ci.org/JuliaDiff/HyperDualNumbers.jl)

Hyper-dual numbers can be used to compute first and second derivatives numerically without the cancellation errors of finite-differencing schemes. This Julia implementation is directly based on the C++ implementation by Jeffrey Fike and Juan J Alonso, both of Stanford University, department of Aeronautics and Astronautics and is described in the paper:

[The Development of Hyper-Dual Numbers for Exact Second Derivative Calculations](https://adl.stanford.edu/hyperdual/Fike_AIAA-2011-886.pdf)

The Julia version was derived/written by Rob J Goedman (goedman@icloud.com).
Latest version tagged as v1.0.0 (7/12/2016)

The Julia package is structured similar to the DualNumbers package, which aims for complete support for `HyperDual` types for numerical functions within Julia's `Base`. Currently, basic mathematical operations and trigonometric functions are supported.

The following functions are specific to hyperdual numbers:
* `Hyper`,
* `Hyper256`,2
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

Use the `hyper()` function to define a hyperdual number, e.g.:

    hd0 = hyper()
    hd1 = hyper(1.0)
    hd2 = hyper(3.0, 1.0, 1.0, 0.0)
    hd3 = hyper(3//2, 1//1, 1//1,0//1)

Let's say we want to calculate the first and second derivative of

    f(x) = e^x / (sqrt(sin(x)^3 + cos(x)^3))

To calculate these derivatives at a location `x`, evaluate your function at `hyper(x, 1.0, 1.0, 0.0)`. For example:

    t0 = hyper(1.5, 1.0, 1.0, 0.0)
    y = f(t0)

For this example, you'll get the result

    4.497780053946162 + 4.053427893898621ϵ1 + 4.053427893898621ϵ2 + 9.463073681596601ϵ1ϵ2

The first term is the function value, the coefficients of both `ϵ1` and `ϵ2` (which correspond to the second and third arguments of `hyper`) are equal to the first derivative, and the coefficient of `ϵ1ϵ2` is the second derivative.

You can extract these coefficients from the hyperdual number using the functions `real()`, `eps1()` or `eps2()` and `eps1eps2()`:

    println("f(1.5) = ", f(1.5))
    println("f(t0) = ", real(f(t0)))
    println("f'(t0) = ", eps1(f(t0)))
    println("f'(t0) = ", eps2(f(t0)))
    println("f''(t0) = ", eps1eps2(f(t0)))
