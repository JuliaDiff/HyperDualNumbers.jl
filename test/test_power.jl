using HyperDualNumbers, Test

t0 = Hyper(2.0, 1.0, 1.0, 0.0)

# test 1
f1(x) = x - x^3 + 4x^2
f2(x)  = x^2 - x
f3(x) = f1(x) ^ f2(x)
r1 = f3(t0)
@test realpart(r1) == 100.0
@test round(ε₁part(r1), digits=4) == 790.7755
@test round(ε₂part(r1), digits=4) == 790.7755
@test round(ε₁ε₂part(r1), digits=10) == 6883.7763738258
r1 |> display

# test 2
f4(x) = -4x^2 + 18
f5(x) = x^3 - 7
f6(x) = f4(x) ^ f5(x)
r2 = f6(t0)
@test realpart(r2) == 2.0
@test round(ε₁part(r2), digits=4) == 0.6355
@test round(ε₂part(r2), digits=4) == 0.6355
@test round(ε₁ε₂part(r2), digits=10) == -503.1625169931
r2 |> display