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
hd9 = hyper(-1.0, -2.0, -3.0, -4.0)

hdNaN = hyper(0/0)

# Addition and subtraction
@test ε₁part(hd1) == 0.0
@test isequal(hd1 + hd2, hyper(2.0, 2.0, 3.0, 4.0))
@test isequal(-hd2, hyper(-1.0, -2.0, -3.0, -4.0))
@test isequal(+hd3, hd2 + hyper(0.0, 1.0, 0.0, 0.0))
@test isequal(hd1-hd3, hyper(0.0, -3.0, -3.0, -4.0))
@test isequal(2+hd2, hyper256(3.0, 2.0, 3.0, 4.0))
@test isequal(hd4-5, hyper256(-4.0, 4.0, 3.0, 4.0))
@test isequal(abs(hd9), sqrt(abs2(hd9)))
@test isequal(abs2(hd2), hd2*hd2)

# NaN tests
@test isnan(hdNaN) == isnan(hyper(NaN, 0.0, 0.0, 0.0))
hdNaN128 = hyper128(NaN, 4.0, 3.0, 4.0)
@test isnan(hdNaN + hd4) == isnan(hdNaN128) && ε₁ε₂part(hdNaN128) == 4.0

println("\nExamples of show() for hyperdual numbers with NaN:\n")
println("hdNaN = $(hdNaN)")
println("hdNaN + hd4 = $(hdNaN + hd4)")

@test isnan(hdNaN) == true
@test isnan(hdNaN+hd4) == true
@test ε₁ε₂part(hdNaN+hd4) == 4.0

# Using and mixing 64 & 32 bits
@test isequal(hd6+hd7, hyper(2.0, 11.0, 6.0, 8.0))
@test isequal(hd7+hd5, 2//1 * hd7)

# Multiplication
@test isequal(hd1 * hd2, hyper128(1, 2, 3, 4))
@test isequal(hd0*hd2, hyper())

# Division
println("\nTesting includes Tim Holy's division performance improvement.")
@test isequal(1/(1/hd2), hd2)
@test isequal(hd2/hd2, hd1)

# Power of
@test isequal(1/hd2, hd2^(-1))
@test isequal(hd3^3, hd3 * hd3 * hd3)
@test isequal((hd3^3)^(1/3), hd3)

# Transcedentals
println("Testing includes ngedwin98's fixes for asin, acos and atan.")
@test isequal(asin(sin(hd8)), hd8)
@test isequal(atan(tan(hd8)), hd8)
@test ε₁part(acos(hd8)) == -ε₁part(asin(hd8)) && ε₁ε₂part(acos(hd8)) == -ε₁ε₂part(asin(hd8))

# Mixing types
@test isequal(hd5*hd7, hd7^2)
@test isequal(1/hd5, hd7^-1)
println("Drooped test isequal((hd2^(1//8)^8)^16777216, hd2).")
#@test isequal((hd2^(1//8)^8)^16777216, hd2)
