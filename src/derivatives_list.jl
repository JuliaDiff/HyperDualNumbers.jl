"""

Symbolic derivative list

The format is a list of (Symbol,Expr,Expr) tuples.

Entries in each tuple:
```julia
* `:f `     : Function symbol
* `:df`    : Symbolic expression for first derivative
* `:d²f`   : Symbolic expression for second derivative
```

The symbol :x is used within deriv_expr for the point at
which the derivative should be evaluated.


### Example of a tuple in the list
```julia
(:sqrt, :(1/2/sqrt(x)), :(-1/4/x^(3/2)))
```
""" 
symbolic_derivative_list = [
    (:sqrt, :(1/2/sqrt(x)), :(-1/4/x^(3/2)))
    (:cbrt, :(1/3/x^(2/3)), :(-2/9/x^(5/3)))
    (:abs2, :(2*x), :(2))
    (:inv, :(-1/x^2), :(2/x^3))
    (:log, :(1/x), :(-1/x^2))
    (:log10, :(1/(log(10)*x)), :(-1/(log(10)*x^2)))
    (:log2, :(1/(log(2)*x)), :(-1/(log(2)*x^2)))
    (:log1p, :(1/(x + 1)), :(-1/(x + 1)^2))
    (:exp2, :(2^x*log(2)), :(2^x*log(2)^2))
    (:exp10, :(10^x*log(10)), :(10^x*log(10)^2))
    (:expm1, :(exp(x)), :(exp(x)))
    (:sin, :(cos(x)), :(-sin(x)))
    (:cos, :(-sin(x)), :(-cos(x)))
    (:tan, :(tan(x)^2 + 1), :(2*(tan(x)^2 + 1)*tan(x)))
    (:sec, :(sec(x)*tan(x)), :(sec(x)*tan(x)^2 + (tan(x)^2 + 1)*sec(x)))
    (:csc, :(-cot(x)*csc(x)), :(cot(x)^2*csc(x) + (cot(x)^2 + 1)*csc(x)))
    (:cot, :(-cot(x)^2 - 1), :(2*(cot(x)^2 + 1)*cot(x)))
    (:sind, :(π*cos(π*x/180)/180), :(-π^2*sin(π*x/180)/180^2))
    (:cosd, :(-π*sin(π*x/180)/180), :(-π^2*cos(π*x/180)/180^2))
    (:tand, :(π*(tan(π*x/180)^2 + 1)/180), :(2*π^2*(tan(π*x/180)^2 + 1)*tan(π*x/180)/180^2))
    (:secd, :(π*sec(π*x/180)*tan(π*x/180)/180), :(π^2*sec(π*x/180)*tan(π*x/180)^2/180^2 + π^2*(tan(π*x/180)^2 + 1)*sec(π*x/180)/180^2))
    (:cscd, :(-π*cot(π*x/180)*csc(π*x/180)/180), :(π^2*cot(π*x/180)^2*csc(π*x/180)/180^2 + π^2*(cot(π*x/180)^2 + 1)*csc(π*x/180)/180^2))
    (:cotd, :(-π*(cot(π*x/180)^2 + 1)/180), :(2*π^2*(cot(π*x/180)^2 + 1)*cot(π*x/180)/180^2))
    (:asin, :(1/sqrt(-x^2 + 1)), :(x/(-x^2 + 1)^(3/2)))
    (:acos, :(-1/sqrt(-x^2 + 1)), :(-x/(-x^2 + 1)^(3/2)))
    (:atan, :(1/(x^2 + 1)), :(-2*x/(x^2 + 1)^2))
    (:asec, :(1/(sqrt(x^2 - 1)*x)), :(-1/(x^2 - 1)^(3/2) - 1/(sqrt(x^2 - 1)*x^2)))
    (:acsc, :(-1/(sqrt(x^2 - 1)*x)), :(1/(x^2 - 1)^(3/2) + 1/(sqrt(x^2 - 1)*x^2)))
    (:acot, :(-1/(x^2 + 1)), :(2*x/(x^2 + 1)^2))
    (:asind, :(π/(sqrt(-π^2*x^2/180^2 + 1)*180)), :(π^3*x/((-π^2*x^2/180^2 + 1)^(3/2)*180^3)))
    (:acosd, :(-π/(sqrt(-π^2*x^2/180^2 + 1)*180)), :(-π^3*x/((-π^2*x^2/180^2 + 1)^(3/2)*180^3)))
    (:atand, :(π/((π^2*x^2/180^2 + 1)*180)), :(-2*π^3*x/((π^2*x^2/180^2 + 1)^2*180^3)))
    (:asecd, :(1/(sqrt(π^2*x^2/180^2 - 1)*x)), :(-π^2/((π^2*x^2/180^2 - 1)^(3/2)*180^2) - 1/(sqrt(π^2*x^2/180^2 - 1)*x^2)))
    (:acscd, :(-1/(sqrt(π^2*x^2/180^2 - 1)*x)), :(π^2/((π^2*x^2/180^2 - 1)^(3/2)*180^2) + 1/(sqrt(π^2*x^2/180^2 - 1)*x^2)))
    (:acotd, :(-π/((π^2*x^2/180^2 + 1)*180)), :(2*π^3*x/((π^2*x^2/180^2 + 1)^2*180^3)))
    (:sinh, :(cosh(x)), :(sinh(x)))
    (:cosh, :(sinh(x)), :(cosh(x)))
    (:tanh, :(-tanh(x)^2 + 1), :(2*(tanh(x)^2 - 1)*tanh(x)))
    (:sech, :(-sech(x)*tanh(x)), :(sech(x)*tanh(x)^2 + (tanh(x)^2 - 1)*sech(x)))
    (:csch, :(-coth(x)*csch(x)), :(coth(x)^2*csch(x) + csch(x)/sinh(x)^2))
    (:coth, :(-1/sinh(x)^2), :(2*cosh(x)/sinh(x)^3))
    (:asinh, :(1/sqrt(x^2 + 1)), :(-x/(x^2 + 1)^(3/2)))
    (:acosh, :(1/(sqrt(x + 1)*sqrt(x - 1))), :(-1/2/(sqrt(x + 1)*(x - 1)^(3/2)) - 1/2/((x + 1)^(3/2)*sqrt(x - 1))))
    (:atanh, :(-1/(x^2 - 1)), :(2*x/(x^2 - 1)^2))
    (:asech, :(-1/(sqrt(-x^2 + 1)*x)), :(-1/(-x^2 + 1)^(3/2) + 1/(sqrt(-x^2 + 1)*x^2)))
    (:acsch, :(-1/(sqrt(x^2 + 1)*x)), :(1/(x^2 + 1)^(3/2) + 1/(sqrt(x^2 + 1)*x^2)))
    (:acoth, :(-1/(x^2 - 1)), :(2*x/(x^2 - 1)^2))
    (:deg2rad, :(π/180), :(0))
    (:rad2deg, :(180/π), :(0))
    (:erf, :(2*exp(-x^2)/sqrt(π)), :(-4*x*exp(-x^2)/sqrt(π)))
    (:erfinv, :(1/2*sqrt(π)*exp(erfinv(x)^2)), :(1/2*π*erfinv(x)*exp(2*erfinv(x)^2)))
    (:erfc, :(-2*exp(-x^2)/sqrt(π)), :(4*x*exp(-x^2)/sqrt(π)))
    (:erfi, :(2*exp(x^2)/sqrt(π)), :(4*x*exp(x^2)/sqrt(π)))
    (:cospi, :(-π*sinpi(x)), :(-π^2*cospi(x)))
    (:sinpi, :(π*cospi(x)), :(-π^2*sinpi(x)))
]

# This is the public interface for accessing the list of symbolic
# derivatives. The format is a list of (Symbol,Expr,Expr) tuples
# (:f, :(df_expr, :(d²f_expr)), :(where df_expr is a symbolic
# expression for the first derivative of the function f,
# and d²f for the second derivative of f.
# The symbol :x is used within deriv_expr for the point at
# which the derivative should be evaluated.
symbolic_derivatives() = symbolic_derivative_list
