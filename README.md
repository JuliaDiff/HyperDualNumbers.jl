# JuliaDiff/HyperDualNumbers

[![HyperDualNumbers](http://pkg.julialang.org/badges/HyperDualNumbers_0.7.svg)](http://pkg.julialang.org/?pkg=HyperDualNumbers&ver=0.7) 

[![HyperDualNumbers](http://pkg.julialang.org/badges/HyperDualNumbers_1.0.svg)](http://pkg.julialang.org/?pkg=HyperDualNumbers&ver=1.0)


[![Coverage Status](https://coveralls.io/repos/JuliaDiff/HyperDualNumbers.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/JuliaDiff/HyperDualNumbers.jl?branch=master)
[![codecov](https://codecov.io/gh/JuliaDiff/HyperDualNumbers.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaDiff/HyperDualNumbers.jl?branch=master)

Unix/OSX:  [![Travis Build Status](https://travis-ci.org/JuliaDiff/HyperDualNumbers.jl.svg?branch=master)](https://travis-ci.org/JuliaDiff/HyperDualNumbers.jl)

Windows(64bit):  [![Build status](https://ci.appveyor.com/api/projects/status/github/JuliaDiff/HyperDualNumbers.jl?branch=master)](https://ci.appveyor.com/project/JuliaDiff/HyperDualNumbers-jl)

Hyper-dual numbers can be used to compute first and second derivatives numerically without the cancellation errors of finite-differencing schemes. This Julia implementation is directly based on the C++ implementation by Jeffrey Fike and Juan J Alonso, both of Stanford University, department of Aeronautics and Astronautics and is described in the paper:

[The Development of Hyper-Dual Numbers for Exact Second Derivative Calculations](https://adl.stanford.edu/hyperdual/Fike_AIAA-2011-886.pdf)

The initial Julia-ish version was derived/written by Rob J Goedman (goedman@icloud.com).

HyperDualNumbers.jl v4.0.0 has been completely redone by Benoit Pasquier to make it `Julia` and much better follows the structure of the [JuliaDiff/DualNumbers](https://github.com/JuliaDiff/DualNumbers.jl) package.]()

For a quick into, see [STEPBYSTEP.md](https://github.com/JuliaDiff/HyperDualNumbers.jl/blob/master/STEPBYSTEP.md)

Latest tagged versions:

*  v1.1.0 (Julia 0.5 & 0.6, Oct 2017)
*  v2.0.0 (Julia v0.7-, Oct 2017)
*  v3.0.1 (Julia v0.7 & Julia v1.0), Aug 2018, Pkg(3))
*  v4.0.0 (Julia v1.0, Nov 2018)

For details see [VERSION.md](https://github.com/JuliaDiff/HyperDualNumbers.jl/blob/master/VERSIONS.md)


The following functions are specific to hyperdual numbers:

* `Hyper`,
* `Hyper256`,
* `Hyper128`,
* `ishyper`,
* `hyper_show`
* `realpart`,
* `ε₁part()`, replaces eps1,
* `ε₂part()`, replaces eps2,
* `ε₁ε₂part()`, replaces eps1eps2

In the future it is my intention to deprecate:

* `hyper`,
* `hyper256`,
* `hyper128`,
* `eps1`,
* `eps2`,
* `eps1eps2`

