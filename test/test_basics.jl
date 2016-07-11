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

hd8 = hyper(1//2, 1, 1, 0)

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
@test isnan(hdNaN) == isnan(hyper(NaN, 0.0, 0.0, 0.0))
hdNaN128 = hyper128(NaN, 4.0, 3.0, 4.0)
@test isnan(hdNaN + hd4) == isnan(hdNaN128) && eps1eps2(hdNaN128) == 4.0

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
println("\nTesting includes Tim Holy's division performance improvement.")
@test 1/(1/hd2) == hd2
@test hd2/hd2 == hd1

# Power of
@test 1/hd2 == hd2^(-1)
@test hd3^3 == hd3 * hd3 * hd3
@test (hd3^3)^(1/3) == hd3

# Transcedentals
@test asin(sin(hd8)) == hd8
@test atan(tan(hd8)) == hd8
@test eps1(acos(hd8)) == -eps1(asin(hd8)) && eps1eps2(acos(hd8)) == -eps1eps2(asin(hd8))

# Mixing types
@test hd5*hd7 == hd7^2
@test 1/hd5 == hd7^-1
@test (hd2^(1//8)^8)^16777216 == hd2
