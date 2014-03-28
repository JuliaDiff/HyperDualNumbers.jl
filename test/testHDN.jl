#include("/Users/rob/.julia/v0.3/HyperDualNumbers/src/hyperdual.jl")
using HyperDualNumbers

hd1 = Hyper(1.0)
hd2 = Hyper(1.0, 2.0, 3.0, 4.0)

eps1(hd1)

hd3 = hyper(1.0, 3.0, 3.0, 4.0)
hd4 = hyper256(1.0, 4.0, 3.0, 4.0)
hd5 = Hyper256(1.0, 5.0, 3.0, 4.0)
#hd6 = hyper128(1.0, 6.0, 3.0, 4.0)
#hd7 = Hyper128(1.0, 7.0, 3.0, 4.0)

hd1 + hd2
-hd2
+hd3
hd1-hd3
2+hd2
hd4-5
