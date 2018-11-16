const ReComp = Union{Real,Complex}

struct Hyper{T<:ReComp} <: Number
    value::T
    epsilon1::T
    epsilon2::T
    epsilon12::T
end
Hyper(x::S, y::T, z::U, w::V) where {S<:ReComp,T<:ReComp,U<:ReComp,V<:ReComp} = Hyper(promote(x,y,z,w)...)
Hyper(x::ReComp) = Hyper(x, zero(x), zero(x), zero(x))

const ɛ₁ = Hyper(false, true, false, false)
const ɛ₂ = Hyper(false, false, true, false)
const ε₁ɛ₂ = Hyper(false, false, false, true)
const imɛ₁ = Hyper(Complex(false, false), Complex(false, true), Complex(false, false), Complex(false, false))
const imɛ₂ = Hyper(Complex(false, false), Complex(false, false), Complex(false, true), Complex(false, false))
const imɛ₁ε₂ = Hyper(Complex(false, false), Complex(false, false), Complex(false, false), Complex(false, true))

const Hyper256  = Hyper{Float64}
const Hyper128 = Hyper{Float32}
const Hyper64  = Hyper{Float16}
const HyperComplex512  = Hyper{ComplexF64}
const HyperComplex256 = Hyper{ComplexF32}
const HyperComplex128 = Hyper{ComplexF16}

Base.convert(::Type{Hyper{T}}, h::Hyper{T}) where {T<:ReComp} = h
Base.convert(::Type{Hyper{T}}, h::Hyper) where {T<:ReComp} = Hyper{T}(convert(T, value(h)), convert(T, epsilon1(h)), convert(T, epsilon2(h)), convert(T, epsilon12(h)))
Base.convert(::Type{Hyper{T}}, x::Number) where {T<:ReComp} = Hyper{T}(convert(T, x), convert(T, 0), convert(T, 0), convert(T, 0))
Base.convert(::Type{T}, h::Hyper) where {T<:ReComp} = (epsilon1(h)==0 && epsilon2(h)==0 && epsilon12(h)==0 ? convert(T, value(h)) : throw(InexactError()))

Base.promote_rule(::Type{Hyper{T}}, ::Type{Hyper{S}}) where {T<:ReComp,S<:ReComp} = Hyper{promote_type(T, S)}
Base.promote_rule(::Type{Hyper{T}}, ::Type{S}) where {T<:ReComp,S<:ReComp} = Hyper{promote_type(T, S)}
Base.promote_rule(::Type{Hyper{T}}, ::Type{T}) where {T<:ReComp} = Hyper{T}

Base.widen(::Type{Hyper{T}}) where {T} = Hyper{widen(T)}

value(h::Hyper) = h.value
epsilon1(h::Hyper) = h.epsilon1
epsilon2(h::Hyper) = h.epsilon2
epsilon12(h::Hyper) = h.epsilon12

value(x::Number) = x
epsilon1(x::Number) = zero(typeof(x))
epsilon2(x::Number) = zero(typeof(x))
epsilon12(x::Number) = zero(typeof(x))

hyper(x::ReComp, y::ReComp, z::Recomp, w::Recomp) = Hyper(x, y, z, w)
hyper(x::ReComp) = Hyper(x)
hyper(h::Hyper) = h

const realpart = value
const ε₁part = epsilon1 # different from `dualpart` but shorter and clearer IMHO?
const ε₂part = epsilon2
const ε₁ε₂part = epsilon12

Base.isnan(h::Hyper) = isnan(value(h))
Base.isinf(h::Hyper) = isinf(value(h))
Base.isfinite(h::Hyper) = isfinite(value(h))
ishyper(x::Hyper) = true
ishyper(x::Number) = false
Base.eps(h::Hyper) = eps(value(h))
Base.eps(::Type{Hyper{T}}) where {T} = eps(T)

function hyperpart_show(io::IO, yzw::T, compact::Bool, str::String) where T<:Real
    if signbit(yzw)
        yzw = -yzw
        print(io, compact ? "-" : " - ")
    else
        print(io, compact ? "+" : " + ")
    end
    compact ? show(IOContext(io, :compact=>true), yzw) : show(io, yzw)
    printtimes(io, yzw)
    print(io, str)
end

function hyper_show(io::IO, h::Hyper{T}, compact::Bool) where T<:Real
    x, y, z, w = value(h), ε₁part(h), ε₂part(h), ε₁ε₂part(h)
    compact ? show(IOContext(io, :compact=>true), x) : show(io, x)
    hyperpart_show(io, y, compact, "ε₁")
    hyperpart_show(io, z, compact, "ε₂")
    hyperpart_show(io, w, compact, "ε₁ε₂")
end

function hyperpart_show(io::IO, yzw::T, compact::Bool, str::String) where T<:Complex
    yzwr, yzwi = reim(yzw)
    if signbit(yzwr)
        yzwr = -yzwr
        print(io, " - ")
    else
        print(io, " + ")
    end
    if compact
        if signbit(yzwi)
            yzwi = -yzwi
            show(IOContext(io, :compact=>true), yzwr)
            printtimes(io, yzwr)
            print(io, str, "-")
            show(IOContext(io, :compact=>true), yzwi)
        else
            show(IOContext(io, :compact=>true), yzwr)
            print(io, str, "+")
            show(IOContext(io, :compact=>true), yzwi)
        end
    else
        if signbit(yzwi)
            yzwi = -yzwi
            show(io, yzwr)
            printtimes(io, yzwr)
            print(io, str, " - ")
            show(io, yzwi)
        else
            show(io, yzwr)
            print(io, str, " + ")
            show(io, yzwi)
        end
    end
    printtimes(io, yzwi)
    print(io, "im", str)
end

function hyper_show(io::IO, h::Hyper{T}, compact::Bool) where T<:Complex
    x, y, z, w = value(h), ε₁part(h), ε₂part(h), ε₁ε₂part(h)
    compact ? show(IOContext(io, :compact=>true), x) : show(io, x)
    hyperpart_show(io, y, compact, "ε₁")
    hyperpart_show(io, z, compact, "ε₂")
    hyperpart_show(io, w, compact, "ε₁ε₂")
end

function hyper_show(io::IO, h::Hyper{T}, compact::Bool) where T<:Bool
    x, y, z, w = value(h), ε₁part(h), ε₂part(h), ε₁ε₂part(h)
    if !x && y && !z && !w
        print(io, "ɛ₁")
    elseif !x && !y && z && !w
        print(io, "ɛ₂")
    elseif !x && !y && !z && w
        print(io, "ɛ₁ε₂")
    else
        print(io, "Hyper{",T,"}(", x, ",", y, ",", z, ",", w, ")")
    end
end

function hyper_show(io::IO, h::Hyper{Complex{T}}, compact::Bool) where T<:Bool
    x, y, z, w = value(h), ε₁part(h), ε₂part(h), ε₁ε₂part(h)
    xr, xi = reim(x)
    yr, yi = reim(y)
    zr, zi = reim(z)
    wr, wi = reim(w)
    if !xr * xi * !yr * !yi * !zr * !zi * !wr * !wi
        print(io, "im")
    elseif !xr * !xi * yr * !yi * !zr * !zi * !wr * !wi
        print(io, "ɛ₁")
    elseif !xr * !xi * !yr * yi * !zr * !zi * !wr * !wi
        print(io, "imɛ₁")
    elseif !xr * !xi * !yr * !yi * zr * !zi * !wr * !wi
        print(io, "ɛ₂")
    elseif !xr * !xi * !yr * !yi * !zr * zi * !wr * !wi
        print(io, "imɛ₂")
    elseif !xr * !xi * !yr * !yi * !zr * !zi * wr * !wi
        print(io, "ε₁ɛ₂")
    elseif !xr * !xi * !yr * !yi * !zr * !zi * !wr * wi
        print(io, "imε₁ɛ₂")
    else
        print(io, "Hyper{",T,"}(", x, ",", y, ",", z, ",", w, ")")
    end
end

function printtimes(io::IO, x::Real)
    if !(isa(x,Integer) || isa(x,Rational) ||
         isa(x,AbstractFloat) && isfinite(x))
        print(io, "*")
    end
end

Base.show(io::IO, h::Hyper) = hyper_show(io, h, get(IOContext(io), :compact, false))

function Base.read(s::IO, ::Type{Hyper{T}}) where T<:ReComp
    x = read(s, T)
    y = read(s, T)
    z = read(s, T)
    w = read(s, T)
    Hyper{T}(x, y, z, w)
end
function Base.write(s::IO, h::Hyper)
    write(s, value(h))
    write(s, ε₁part(h))
    write(s, ε₂part(h))
    write(s, ε₁ε₂part(h))
end


## Generic functions of hyperdual numbers ##

Base.convert(::Type{Hyper}, h::Hyper) = h
Base.convert(::Type{Hyper}, x::Number) = Hyper(x)

Base.:(==)(h₁::Hyper, h₂::Hyper) = value(h₁) == value(h₂)
Base.:(==)(h::Hyper, x::Number) = value(h) == x
Base.:(==)(x::Number, h::Hyper) = h == x

Base.isequal(h₁::Hyper, h₂::Hyper) = isequal(value(h₁),value(h₂)) && isequal(ε₁part(h₁), ε₁part(h₂)) && isequal(ε₂part(h₁), ε₂part(h₂)) && isequal(ε₁ε₂part(h₁), ε₁ε₂part(h₂))
Base.isequal(h::Hyper, x::Number) = isequal(value(h), x) && isequal(ε₁part(h), zero(x)) && isequal(ε₂part(h), zero(x)) && isequal(ε₁ε₂part(h), zero(x))
Base.isequal(x::Number, h::Hyper) = isequal(h, x)

Base.isless(h₁::Hyper{T}, h₂::Hyper{T}) where {T<:Real} = value(h₁) < value(h₂)
Base.isless(h₁::Real, h₂::Hyper{<:Real}) = h₁ < value(h₂)
Base.isless(h₁::Hyper{<:Real}, h₂::Real) = value(h₁) < h₂

function Base.hash(h::Hyper) # Not sure thtis works
    x = hash(value(h))
    if isequal(h, value(h))
        return x
    else
        y = hash(ε₁part(h))
        z = hash(ε₂part(h))
        w = hash(ε₁ε₂part(h))
        return hash(x, hash(y, hash(z, hash(w))))
    end
end

Base.float(h::Union{Hyper{T}, Hyper{Complex{T}}}) where {T<:AbstractFloat} = h
Base.complex(h::Hyper{<:Complex}) = h

Base.floor(h::Hyper) = floor(value(h))
Base.ceil(h::Hyper)  = ceil(value(h))
Base.trunc(h::Hyper) = trunc(value(h))
Base.round(h::Hyper) = round(value(h))
Base.floor(::Type{T}, h::Hyper) where {T<:Real} = floor(T, value(h))
Base.ceil( ::Type{T}, h::Hyper) where {T<:Real} =  ceil(T, value(h))
Base.trunc(::Type{T}, h::Hyper) where {T<:Real} = trunc(T, value(h))
Base.round(::Type{T}, h::Hyper) where {T<:Real} = round(T, value(h))

for op in (:float, :complex)
    @eval Base.$op(z::Hyper) = Hyper($op(value(z)), $op(ε₁part(z)), $op(ε₂part(z)), $op(ε₁ε₂part(z)))
end

for op in (:conj)
    @eval Base.$op(z::Hyper{<:Real}) = Hyper($op(value(z)), $op(ε₁part(z)), $op(ε₂part(z)), $op(ε₁ε₂part(z)))
end

function Base.abs(h::Hyper{<:Real})
    x, y, z, w = value(h), ε₁part(h), ε₂part(h), ε₁ε₂part(h)
    if x > 0
        return h
    elseif x < 0
        return -h
    else
        if y+z > 0
            return h
        elseif y+z < 0
            return -h
        else
            if z ≥ 0
                return h
            else z < 0
                return -h
            end
        end
    end
end

# (Unsure, but) no `abs`, `real`, `conj`, `angle` or `imag`
# for hyperdual complex because differentiable nowhere in ℂ
# (these functions don't satisfy the Cauchy–Riemann equations).
# I guess it might be usable for printing or other checking purposes,
# but then I guess the user should define his own functions,
# at its own risk, rather than having this package suggest a value that
# does not make mathematical sense, right? (I may be completely wrong about this)

# No flipsign so far but maybe I should make it like the `abs` above and
# then have `abs(x) = flipsign(x, x)`?

# No `conjhyper`, `abshyper`, or `abs2hyper` because I don't understand
# their purpose in DualNumbers

# algebra

Base.:+(h₁::Hyper, h₂::Hyper) = Hyper(value(h₁) + value(h₂), ε₁part(h₁) + ε₁part(h₂), ε₂part(h₁) + ε₂part(h₂), ε₁ε₂part(h₁) + ε₁ε₂part(h₂))
Base.:+(n::Number, h::Hyper) = Hyper(n + value(h), ε₁part(h), ε₂part(h), ε₁ε₂part(h))
Base.:+(h::Hyper, n::Number) = n + h

Base.:-(h::Hyper) = Hyper(-value(h), -ε₁part(h), -ε₂part(h), -ε₁ε₂part(h))
Base.:-(h₁::Hyper, h₂::Hyper) = Hyper(value(h₁) - value(h₂), ε₁part(h₁) - ε₁part(h₂), ε₂part(h₁) - ε₂part(h₂), ε₁ε₂part(h₁) - ε₁ε₂part(h₂))
Base.:-(n::Number, h::Hyper) = Hyper(n - value(h), -ε₁part(h), -ε₂part(h), -ε₁ε₂part(h))
Base.:-(h::Hyper, n::Number) = Hyper(value(h) - n, ε₁part(h), ε₂part(h), ε₁ε₂part(h))

# avoid ambiguous definition with Bool*Number
Base.:*(x::Bool, h::Hyper) = ifelse(x, h, ifelse(signbit(real(value(h)))==0, zero(h), -zero(h)))
Base.:*(h::Hyper, x::Bool) = x * h

function Base.:*(h₁::Hyper, h₂::Hyper)
    x, y, z, w = value(h₁), ε₁part(h₁), ε₂part(h₁), ε₁ε₂part(h₁)
    a, b, c, d = value(h₂), ε₁part(h₂), ε₂part(h₂), ε₁ε₂part(h₂)
    return Hyper(a*x, a*y+b*x, a*z+c*x, a*w+d*x+c*y+b*z)
end
Base.:*(n::Number, h::Hyper) = Hyper(n*value(z), n*ε₁part(z), n*ε₂part(z), n*ε₁ε₂part(z))
Base.:*(h::Hyper, n::Number) = n * h

function Base.:/(n::Number, h::Hyper) =
    x, y, z, w = value(h), ε₁part(h), ε₂part(h), ε₁ε₂part(h)
    return Hyper(n/x, -n*y/x^2, -n*z/x^2, -n*(w/x-y*z/x^2-z*y/x^2)/x)
end
Base.one(h::Hyper) = Hyper(one(realpart(z)))
Base.:/(h₁::Hyper, h₂::Hyper) = h₁ * (one(h₂) / h₂)
Base.:/(h::Hyper, n::Number) = Hyper(value(z)/n, ε₁part(z)/n, ε₂part(z)/n, ε₁ε₂part(z)/n)

for f in [:(Base.:^), :(NaNMath.pow)] # not done here :/
    @eval function ($f)(z::Hyper, w::Hyper)
        if epsilon(w) == 0.0
            return $f(z, value(w))
        end
        val = $f(value(z), value(w))

        du = epsilon(z) * value(w) * $f(value(z), value(w) - 1) +
             epsilon(w) * $f(value(z), value(w)) * log(value(z))

        Hyper(val, du)
    end
end

Base.mod(z::Dual, n::Number) = Dual(mod(value(z), n), epsilon(z))

# these two definitions are needed to fix ambiguity warnings
Base.:^(z::Dual, n::Integer) = Dual(value(z)^n, epsilon(z)*n*value(z)^(n-1))
Base.:^(z::Dual, n::Rational) = Dual(value(z)^n, epsilon(z)*n*value(z)^(n-1))

Base.:^(z::Dual, n::Number) = Dual(value(z)^n, epsilon(z)*n*value(z)^(n-1))
NaNMath.pow(z::Dual, n::Number) = Dual(NaNMath.pow(value(z),n), epsilon(z)*n*NaNMath.pow(value(z),n-1))
NaNMath.pow(z::Number, w::Dual) = Dual(NaNMath.pow(z,value(w)), epsilon(w)*NaNMath.pow(z,value(w))*log(z))

Base.inv(z::Dual) = dual(inv(value(z)),-epsilon(z)/value(z)^2)

# force use of NaNMath functions in derivative calculations
function to_nanmath(x::Expr)
    if x.head == :call
        funsym = Expr(:.,:NaNMath,Base.Meta.quot(x.args[1]))
        return Expr(:call,funsym,[to_nanmath(z) for z in x.args[2:end]]...)
    else
        return Expr(:call,[to_nanmath(z) for z in x.args]...)
    end
end
to_nanmath(x) = x




for (funsym, exp) in Calculus.symbolic_derivatives_1arg()
    funsym == :exp && continue
    funsym == :abs2 && continue
    funsym == :inv && continue
    if isdefined(SpecialFunctions, funsym)
        @eval function SpecialFunctions.$(funsym)(z::Dual)
            x = value(z)
            xp = epsilon(z)
            Dual($(funsym)(x),xp*$exp)
        end
    elseif isdefined(Base, funsym)
        @eval function Base.$(funsym)(z::Dual)
            x = value(z)
            xp = epsilon(z)
            Dual($(funsym)(x),xp*$exp)
        end
    end
    # extend corresponding NaNMath methods
    if funsym in (:sin, :cos, :tan, :asin, :acos, :acosh, :atanh, :log, :log2, :log10,
          :lgamma, :log1p)
        funsym = Expr(:.,:NaNMath,Base.Meta.quot(funsym))
        @eval function $(funsym)(z::Dual)
            x = value(z)
            xp = epsilon(z)
            Dual($(funsym)(x),xp*$(to_nanmath(exp)))
        end
    end
end

# only need to compute exp/cis once
Base.exp(z::Dual) = (expval = exp(value(z)); Dual(expval, epsilon(z)*expval))
Base.cis(z::Dual) = (cisval = cis(value(z)); Dual(cisval, im*epsilon(z)*cisval))

Base.exp10(x::Dual) = (y = exp10(value(x)); Dual(y, y * log(10) * epsilon(x)))

## TODO: should be generated in Calculus
Base.sinpi(z::Dual) = Dual(sinpi(value(z)),epsilon(z)*cospi(value(z))*π)
Base.cospi(z::Dual) = Dual(cospi(value(z)),-epsilon(z)*sinpi(value(z))*π)

Base.checkindex(::Type{Bool}, inds::AbstractUnitRange, i::Dual) = checkindex(Bool, inds, value(i))
