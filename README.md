# HyperDualNumbers

This Julia implementation is directly based on the C++ implementation by Jeffrey Fike
of Stanford University, department of Aeronautics and Astronautics. See also: 

[The Development of Hyper-Dual Numbers for Exact Second Derivative Calculations](https://adl.stanford.edu/hyperdual/Fike_AIAA-2011-886.pdf)

The Julia package is structured similar to the DualNumbers package, which aims for complete support for `HyperDual` types for numerical functions within Julia's `Base`. Currently, basic mathematical operations and trigonometric functions are supported.

The following functions are specific to hyperdual numbers:
* `hyper`,
* `hyper256`,
* `hyper128`,
* `eps1`,
* `eps2`,
* `eps1eps2`,
* `ishyper`,
* `hyper_show`,
* `conjhyper`,  (?)
* `abshyper`,
* `abs2hyper`.

In some cases the mathematical definition of functions of ``Hyper`` numbers
is in conflict with their use as a drop-in replacement for calculating
numerical derivatives, for example, ``conj``, ``abs`` and ``abs2``. In these
cases, we choose to follow the rule ``f(x::Dual) = Dual(f(real(x)),epsilon(x)*f'(real(x)))``,
where ``f'`` is the derivative of ``f``. The mathematical definitions are
available using the functions with the suffix ``dual``.


### A walk-through example

The example below demonstrates basic usage of dual numbers by employing them to 
perform automatic differentiation. The code for this example can be found in 
`test/automatic_differentiation_test.jl`.

First install the package by using the Julia package manager:

    Pkg.update()
    Pkg.clone("https://github.com/goedman.HyperDualNumbers.jl.git")
    
Then make the package available via

    using HyperDualNumbers

Use the `dual()` function to define the dual number `2+1*du`:

    hd0 = hyper()
    hd1 = hyper(1.0)
    hd2 = hyper(1.0, 2.0, 3.0, 4.0)

Define a function that will be differentiated, say

    f(x) = x^3

Perform automatic differentiation by passing the dual number `x` as argument to 
`f`:

    y = f(x)

Use the functions `real()` and `epsilon()` to get the real and imaginary (dual) 
parts of `x`, respectively:

    println("f(x) = x^3")
    println("f(2) = ", real(y))
    println("f'(2) = ", epsilon(y))

