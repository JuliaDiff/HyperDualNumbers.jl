using HyperDualNumbers, Test

t0 = Hyper(1.5, 1.0, 1.0, 0.0)

f(x) = ℯ^x / (sqrt(sin(x)^3 + cos(x)^3))

f(t0)

realpart(f(t0))

ε₁part(f(t0))

ε₂part(f(t0))

ε₁ε₂part(f(t0))