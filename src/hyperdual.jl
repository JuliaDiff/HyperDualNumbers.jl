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
const hyperpart1 = epsilon1
const hyperpart2 = epsilon2
const hyperpart12 = epsilon12

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
    x, y, z, w = value(h), epsilon1(h), epsilon2(h), epsilon12(h)
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
    x, y, z, w = value(h), epsilon1(h), epsilon2(h), epsilon12(h)
    compact ? show(IOContext(io, :compact=>true), x) : show(io, x)
    hyperpart_show(io, y, compact, "ε₁")
    hyperpart_show(io, z, compact, "ε₂")
    hyperpart_show(io, w, compact, "ε₁ε₂")
end

function hyper_show(io::IO, h::Hyper{T}, compact::Bool) where T<:Bool
    x, y, z, w = value(h), epsilon1(h), epsilon2(h), epsilon12(h)
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
    x, y, z, w = value(h), epsilon1(h), epsilon2(h), epsilon12(h)
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
    write(s, epsilon1(h))
    write(s, epsilon2(h))
    write(s, epsilon12(h))
end


## Generic functions of dual numbers ##

Base.convert(::Type{Hyper}, h::Hyper) = h
Base.convert(::Type{Hyper}, x::Number) = Hyper(x)

Base.:(==)(h₁::Hyper, h₂::Hyper) = value(h₁) == value(h₂)
Base.:(==)(h::Hyper, x::Number) = value(h) == x
Base.:(==)(x::Number, h::Hyper) = h == x

Base.isequal(h₁::Hyper, h₂::Hyper) = isequal(value(h₁),value(h₂)) && isequal(epsilon1(h₁), epsilon1(h₂)) && isequal(epsilon2(h₁), epsilon2(h₂))&& isequal(epsilon12(h₁), epsilon12(h₂))
Base.isequal(h::Hyper, x::Number) = isequal(value(h), x) && isequal(epsilon1(h), zero(x)) && isequal(epsilon2(h), zero(x)) && isequal(epsilon12(h), zero(x))
Base.isequal(x::Number, h::Hyper) = isequal(h, x)

Base.isless(h₁::Hyper{T}, h₂::Hyper{T}) where {T<:Real} = value(h₁) < value(h₂)
Base.isless(h₁::Real, h₂::Hyper{<:Real}) = h₁ < value(h₂)
Base.isless(h₁::Hyper{<:Real}, h₂::Real) = value(h₁) < h₂

function Base.hash(h::Hyper) # Not sure thtis works
    x = hash(value(h))
    if isequal(h, value(h))
        return x
    else
        y = hash(epsilon1(h))
        z = hash(epsilon2(h))
        w = hash(epsilon12(h))
        return hash(x, hash(y, hash(z, hash(w))))
    end
end

Base.float(z::Union{Dual{T}, Dual{Complex{T}}}) where {T<:AbstractFloat} = z
Base.complex(z::Dual{<:Complex}) = z

Base.floor(z::Dual) = floor(value(z))
Base.ceil(z::Dual)  = ceil(value(z))
Base.trunc(z::Dual) = trunc(value(z))
Base.round(z::Dual) = round(value(z))
Base.floor(::Type{T}, z::Dual) where {T<:Real} = floor(T, value(z))
Base.ceil( ::Type{T}, z::Dual) where {T<:Real} = ceil( T, value(z))
Base.trunc(::Type{T}, z::Dual) where {T<:Real} = trunc(T, value(z))
Base.round(::Type{T}, z::Dual) where {T<:Real} = round(T, value(z))

for op in (:real, :imag, :conj, :float, :complex)
    @eval Base.$op(z::Dual) = Dual($op(value(z)), $op(epsilon(z)))
end

Base.abs(z::Dual) = sqrt(abs2(z))
Base.abs2(z::Dual) = real(conj(z)*z)

Base.real(z::Dual{<:Real}) = z
Base.abs(z::Dual{<:Real}) = z ≥ 0 ? z : -z

Base.angle(z::Dual{<:Real}) = z ≥ 0 ? zero(z) : one(z)*π
function Base.angle(z::Dual{Complex{T}}) where T<:Real
    if z == 0
        if imag(epsilon(z)) == 0
            Dual(zero(T), zero(T))
        else
            Dual(zero(T), convert(T, Inf))
        end
    else
        real(log(sign(z)) / im)
    end
end

Base.flipsign(x::Dual,y::Dual) = y == 0 ? flipsign(x, epsilon(y)) : flipsign(x, value(y))
Base.flipsign(x, y::Dual) = y == 0 ? flipsign(x, epsilon(y)) : flipsign(x, value(y))
Base.flipsign(x::Dual, y) = dual(flipsign(value(x), y), flipsign(epsilon(x), y))

# algebraic definitions
conjdual(z::Dual) = Dual(value(z),-epsilon(z))
absdual(z::Dual) = abs(value(z))
abs2dual(z::Dual) = abs2(value(z))

# algebra

Base.:+(z::Dual, w::Dual) = Dual(value(z)+value(w), epsilon(z)+epsilon(w))
Base.:+(z::Number, w::Dual) = Dual(z+value(w), epsilon(w))
Base.:+(z::Dual, w::Number) = Dual(value(z)+w, epsilon(z))

Base.:-(z::Dual) = Dual(-value(z), -epsilon(z))
Base.:-(z::Dual, w::Dual) = Dual(value(z)-value(w), epsilon(z)-epsilon(w))
Base.:-(z::Number, w::Dual) = Dual(z-value(w), -epsilon(w))
Base.:-(z::Dual, w::Number) = Dual(value(z)-w, epsilon(z))

# avoid ambiguous definition with Bool*Number
Base.:*(x::Bool, z::Dual) = ifelse(x, z, ifelse(signbit(real(value(z)))==0, zero(z), -zero(z)))
Base.:*(x::Dual, z::Bool) = z*x

Base.:*(z::Dual, w::Dual) = Dual(value(z)*value(w), epsilon(z)*value(w)+value(z)*epsilon(w))
Base.:*(x::Number, z::Dual) = Dual(x*value(z), x*epsilon(z))
Base.:*(z::Dual, x::Number) = Dual(x*value(z), x*epsilon(z))

Base.:/(z::Dual, w::Dual) = Dual(value(z)/value(w), (epsilon(z)*value(w)-value(z)*epsilon(w))/(value(w)*value(w)))
Base.:/(z::Number, w::Dual) = Dual(z/value(w), -z*epsilon(w)/value(w)^2)
Base.:/(z::Dual, x::Number) = Dual(value(z)/x, epsilon(z)/x)

for f in [:(Base.:^), :(NaNMath.pow)]
    @eval function ($f)(z::Dual, w::Dual)
        if epsilon(w) == 0.0
            return $f(z, value(w))
        end
        val = $f(value(z), value(w))

        du = epsilon(z) * value(w) * $f(value(z), value(w) - 1) +
             epsilon(w) * $f(value(z), value(w)) * log(value(z))

        Dual(val, du)
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
