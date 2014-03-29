#include("/Users/rob/.julia/v0.3/HyperDualNumbers/src/hyperdual.jl")
using HyperDualNumbers

hd0 = Hyper()
hd1 = Hyper(1.0)
hd2 = Hyper(1.0, 2.0, 3.0, 4.0)

println("eps1(hd1) = ", eps1(hd1))

hd3 = hyper(1.0, 3.0, 3.0, 4.0)
hd4 = hyper256(1.0, 4.0, 3.0, 4.0)
hd5 = Hyper256(1.0, 5.0, 3.0, 4.0)
#hd6 = hyper128(1.0, 6.0, 3.0, 4.0)
#hd7 = Hyper128(1.0, 7.0, 3.0, 4.0)

println("hd1 + hd2 = ", hd1 + hd2)
println("-hd2 = ", -hd2)
println("+hd3 = ", +hd3)
println("hd1 - hd3 = ", hd1-hd3)
println("2 + hd2 = ", 2+hd2)
println("hd4-5 = ", hd4-5)

hdNaN = hyper(0/0)
println("NaN example: hdNaN = ", hdNaN)
println("hdNaN + hd4 = ", hdNaN + hd4)

println("hd1 * hd2 = ", hd1*hd2)
println("hd0 * hd2 = ", hd0*hd2)

println("1/(1/hd2) = ", 1/(1/hd2))
println("hd3^3 = ", hd3^3)
println("(hd3^3)^(1/3) = ", (hd3^3)^(1/3))
println("(hd3^3)^1/3 = ", (hd3^3)^1/3)
