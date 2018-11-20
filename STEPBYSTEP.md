### A walk-through example

The example below demonstrates basic usage of hyperdual numbers by employing them to perform automatic differentiation. The code for this example can be found in 
`test/runtests.jl`.

First install the package by using the Julia package manager:

    Pkg.add("HyperDualNumbers")
    
Then make the package available via

    using HyperDualNumbers

Use the `Hyper()` function to define a hyperdual number, e.g.:

    hd0 = Hyper()
    hd1 = Hyper(1.0)
    hd2 = Hyper(3.0, 1.0, 1.0, 0.0)
    hd3 = Hyper(3//2, 1//1, 1//1,0//1)

Let's say we want to calculate the first and second derivative of

    f(x) = ℯ^x / (sqrt(sin(x)^3 + cos(x)^3))

To calculate these derivatives at a location `x`, evaluate your function at `hyper(x, 1.0, 1.0, 0.0)`. For example:

    t0 = Hyper(1.5, 1.0, 1.0, 0.0)
    y = f(t0)

For this example, you'll get the result

    4.497780053946162 + 4.053427893898621ϵ1 + 4.053427893898621ϵ2 + 9.463073681596601ϵ1ϵ2

The first term is the function value, the coefficients of both `ϵ1` and `ϵ2` (which correspond to the second and third arguments of `hyper`) are equal to the first derivative, and the coefficient of `ϵ1ϵ2` is the second derivative.

You can extract these coefficients from the hyperdual number using the functions `realpart()`, `ε₁part()` or `ε₂part()` and `ε₁ε₂part()`:

    println("f(1.5) = ", f(1.5))
    println("f(t0) = ", realpart(f(t0)))
    println("f'(t0) = ", ε₁part(f(t0)))
    println("f'(t0) = ", ε₂part(f(t0)))
    println("f''(t0) = ", ε₁ε₂part(f(t0)))
