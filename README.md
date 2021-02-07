# JuliaDiff/HyperDualNumbers


| **Documentation**                                                               | **Build Status**                                                                                |
|:-------------------------------------------------------------------------------:|:-----------------------------------------------------------------------------------------------:|
| [![][docs-stable-img]][docs-stable-url] [![][docs-dev-img]][docs-dev-url] | [![][travis-img]][travis-url] [![][appveyor-img]][appveyor-url] [![][codecov-img]][codecov-url] |


Hyper-dual numbers can be used to compute first and second derivatives numerically without the cancellation errors of finite-differencing schemes. 

The initial Julia implementation (up to v3.0.1) is directly based on the C++ implementation by Jeffrey Fike and Juan J Alonso, both of Stanford University, department of Aeronautics and Astronautics as described in the paper:

[The Development of Hyper-Dual Numbers for Exact Second Derivative Calculations](https://adl.stanford.edu/hyperdual/Fike_AIAA-2011-886.pdf)

Up to v3.0.1 the Julia versions have been derived/written by Rob J Goedman (goedman@icloud.com).

HyperDualNumbers.jl v4.0.0 has been completely redone by Benoit Pasquier and follows the structure of the [JuliaDiff/DualNumbers](https://github.com/JuliaDiff/DualNumbers.jl) package.

For a quick intro, see [STEPBYSTEP.md](https://github.com/JuliaDiff/HyperDualNumbers.jl/blob/master/STEPBYSTEP.md)

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
* `ishyper`,y2
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

## Documentation

- [**STABLE**][docs-stable-url] &mdash; **documentation of the most recently tagged version.**
- [**DEVEL**][docs-dev-url] &mdash; *documentation of the in-development version.*

## Questions and issues

Question and contributions are very welcome, as are feature requests and suggestions. Please open an [issue][issues-url] if you encounter any problems or have a question. 

[docs-dev-img]: https://img.shields.io/badge/docs-dev-blue.svg
[docs-dev-url]: https://juliadiff.org/HyperDualNumbers.jl/latest

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: https://juliadiff.org/HyperDualNumbers.jl/stable

[travis-img]: https://travis-ci.com/JuliaDiff/HyperDualNumbers.jl.svg?branch=master
[travis-url]: https://travis-ci.com/JuliaDiff/HyperDualNumbers.jl

[appveyor-img]: https://ci.appveyor.com/api/projects/status/gkwh4md2fq4c29hy?svg=true
[appveyor-url]: https://ci.appveyor.com/project/JuliaDiff/HyperDualNumbers-jl

[codecov-img]: https://codecov.io/gh/JuliaDiff/HyperDualNumbers.jl/branch/master/graph/badge.svg
[codecov-url]: https://codecov.io/gh/JuliaDiff/HyperDualNumbers.jl

[issues-url]: https://github.com/JuliaDiff/HyperDualNumbers.jl/issues

