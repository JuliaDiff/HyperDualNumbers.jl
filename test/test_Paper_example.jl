using HyperDualNumbers
using Base.Test  

# THE example
println("\n\"THE\" example")
f(x) = e^x / sqrt(sin(x)^3 + cos(x)^3)
println("f(1.5) = $(f(1.5))")
println()
t0 = hyper(1.5, 1.0, 1.0, 0.0)
t1 = e^t0
t2 = sin(t0)
t3 = t2^3
t4 = cos(t0)
t5 = t4^3
t5a = (cos(t0))^3
t6 = t3 + t5
t7 = t6^-0.5
t8 = t1*t7

println("t0 = ", t0)
println("t1 = ", t1)
println("t2 = ", t2)
println("t3 = ", t3)
println("t4 = ", t4)
println("t5 = ", t5)
println("t5a = ", t5a)
println("t6 = ", t6)
println("t7 = ", t7)
println("t8 = ", t8)

println()
println("f(t0) = ", f(t0))
