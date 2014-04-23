using HyperDualNumbers
using Base.Test  

# Define a few hyperdual numbers for testing purposes
hd0 = Hyper()
hd1 = Hyper(1.0)

hd2 = Hyper(1.0, 2.0, 3.0, 4.0)
hd3 = hyper(1.0, 3.0, 3.0, 4.0)
hd4 = hyper256(1, 4, 3, 4)
hd5 = Hyper256(1//1, 10//2, 6//2, 20//5)

hd6 = hyper128(1.0, 6.0, 3.0, 4.0)
hd7 = Hyper128(1//1, 10//2, 6//2, 20//5)

hdNaN = hyper(0/0)

# Addition and subtraction
@test eps1(hd1) == 0.0
@test hd1 + hd2 == hyper(2.0, 2.0, 3.0, 4.0)
@test -hd2 == hyper(-1.0, -2.0, -3.0, -4.0)
@test +hd3 == hd2 + hyper(0.0, 1.0, 0.0, 0.0)
@test hd1-hd3 == hyper(0.0, -3.0, -3.0, -4.0)
@test 2+hd2 == hyper256(3.0, 2.0, 3.0, 4.0)
@test hd4-5 == hyper256(-4.0, 4.0, 3.0, 4.0)

# NaN tests
#@test hdNaN == hyper(NaN, 0.0, 0.0, 0.0)
#@test hdNaN + hd4 == hyper128(NaN, 4.0, 3.0, 4.0)

println("\nExamples of show() for hyperdual numbers with NaN:\n")
println("hdNaN = $(hdNaN)")
println("hdNaN + hd4 = $(hdNaN + hd4)")

@test isnan(hdNaN) == true
@test isnan(hdNaN+hd4) == true
@test eps1eps2(hdNaN+hd4) == 4.0

# Using and mixing 64 & 32 bits
@test hd6+hd7 == hyper(2.0, 11.0, 6.0, 8.0)
@test hd7+hd5 == 2//1 * hd7

# Multiplication
@test hd1 * hd2 == hyper128(1, 2, 3, 4)
@test hd0*hd2 == hyper()

# Division
@test 1/(1/hd2) == hd2

# Power of
@test hd3^3 == hd3 * hd3 * hd3
@test (hd3^3)^(1/3) == hd3

# Mixing types
@test hd5*hd7 == hd7^2
@test 1/hd5 == hd7^-1
@test (hd2^(1//8)^8)^16777216 == hd2

# Tim Holy's test example
hd10 = Hyper(1//2, 1, 1, 0)
q1(x) = 1 - (96//25)*x^2 + (112//25)*x^4
q2(x) = 1 - (96//25)*x^2.0 + (112//25)*x^4.0
q3(x) = 1 - (96//25)*x^(2//1) + (112//25)*x^(4//1)

@test q1(hd10) == hyper(8//25, - 8//5, - 8//5, + 144//25)
@test q2(hd10) == hyper(0.32000000000000006, -1.5999999999999996, -1.5999999999999996, 5.760000000000002)
@test q2(hd10) == q3(hd10)

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
