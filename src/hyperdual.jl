#
# Basic definitions
#

struct Hyper{T<:Real} <: Number
  f0::T
  f1::T
  f2::T
  f12::T
end

Hyper(x::Real, eps1::Real, eps2::Real, eps1eps2::Real) =
  Hyper(promote(x, eps1, eps2, eps1eps2)...)

Hyper(x::Real) = Hyper(x, zero(x), zero(x), zero(x))
Hyper() = Hyper(0.0, 0.0, 0.0, 0.0)

const Hyper256 = Hyper{Float64}
Hyper256() = Hyper256(0.0, 0.0, 0.0, 0.0)
const Hyper128 = Hyper{Float32}
Hyper128() = Hyper128(0.0, 0.0, 0.0, 0.0)

realpart(z::Hyper) = z.f0
eps1(z::Hyper) = z.f1
eps2(z::Hyper) = z.f2
eps1eps2(z::Hyper) = z.f12

eps(z::Hyper) = eps(realpart(z))
eps(::Type{Hyper{T}}) where T = eps(T)
one(z::Hyper) = Hyper(one(realpart(z)))
one(::Type{Hyper{T}}) where T = Hyper(one(T))
nan(::Type{Hyper{T}}) where T = nan(one(T))
isnan(z::Hyper) = isnan(realpart(z))

convert(::Type{Hyper{T}}, x::Real) where T<:Real =
  Hyper{T}(convert(T, x), convert(T, 0), convert(T, 0), convert(T, 0))

convert(::Type{Hyper{T}}, z::Hyper{T}) where T<:Real = z

convert(::Type{Hyper{T}}, z::Hyper) where T<:Real =
  Hyper(convert(T, realpart(z)), convert(T, eps1(z)), convert(T, eps2(z)),
    convert(T, eps1eps2(z)))

convert(::Type{T}, z::Hyper) where T<:Real =
  ((eps1(z) == 0 && eps2(z) == 0 && eps1eps2(z)) ? convert(T, realpart(z)) : throw(InexactError()))

promote_rule(::Type{Hyper{T}}, ::Type{Hyper{S}}, ::Type{Hyper{Q}},
  ::Type{Hyper{P}}) where {T<:Real, S<:Real, Q<:Real, P<:Real} =
    Hyper{promote_type(T, S, Q, P)}

promote_rule(::Type{Hyper{T}}, ::Type{T}, ::Type{T}, ::Type{T}) where T<:Real = Hyper{T}

promote_rule(::Type{Hyper{T}}, ::Type{S}, ::Type{Q}, ::Type{P}) where {T<:Real, S<:Real, Q<:Real, P<:Real} =
    Hyper{promote_type(T, S, Q, P)}

promote_rule(::Type{Hyper{T}}, ::Type{S}) where {T<:Real, S<:Real} = Hyper{promote_type(T, S)}

hyper(x, y, z, yz) = Hyper(x, y, z, yz)
hyper(x) = Hyper(x)
hyper() = Hyper()

#@vectorize_1arg Real hyper

hyper256(s::Float64, t::Float64, q::Float64, p::Float64) = Hyper{Float64}(s, t, q, p)
hyper256(s::Real, t::Real, q::Real, p::Real) =
  hyper256(Float64(s), Float64(t), Float64(q), Float64(p))
hyper256(z) = hyper256(realpart(z), eps1(z), eps2(z), eps1eps2(z))

hyper128(s::Float32, t::Float32, q::Float32, p::Float32) = Hyper{Float32}(s, t, q, p)
hyper128(s::Real, t::Real, q::Real, p::Real) =
  hyper128(Float32(s), Float32(t), Float32(q), Float32(p))
hyper128(z) = hyper128(realpart(z), eps1(z), eps2(z), eps1eps2(z))

ishyper(x::Hyper) = true
ishyper(x::Number) = false

real_valued(z::Hyper{T}) where T <:Real = (eps1(z) == 0 && eps2(z) == 0 && eps1eps2(z) == 0)
integer_valued(z::Hyper) = real_valued(z) && integer_valued(real(z))

isfinite(z::Hyper) = isfinite(realpart(z))
reim(z::Hyper) = (realpart(z), eps1(z), eps2(z), eps1eps2(z))

# No-op?
conjhyper(z::Hyper) = z

#
# IO definitions
#

function hyper_show(io::IO, z::Hyper, compact::Bool)
  f0, f1, f2, f12 = reim(z)
  if isnan(f0) || (isfinite(f1) || isfinite(f2) || isfinite(f12))
    compact ? showcompact(io, f0) : show(io, f0)
    if isfinite(f1)
      if signbit(f1) == 1 && !isnan(f1)
        f1 = -f1
        print(io, compact ? "-" : " - ")
      else
        print(io, compact ? "+" : " + ")
      end  
      compact ? showcompact(io, f1) : show(io, f1)
      if !(isa(f1, Integer) || isa(f1, Rational) ||
           isa(f1, AbstractFloat) || isfinite(f1))
           print(io, "*")
      end
      print(io, "\u03F51")
    end
    if isfinite(f2)
      if signbit(f2) == 1 && !isnan(f2)
        f2 = -f2
        print(io, compact ? "-" : " - ")
      else
        print(io, compact ? "+" : " + ")
      end  
      compact ? showcompact(io, f2) : show(io, f2)
      if !(isa(f2, Integer) || isa(f2, Rational) ||
           isa(f2, AbstractFloat) || isfinite(f2))
           print(io, "*")
      end
      print(io, "\u03F52")
    end
    if isfinite(f12)
      if signbit(f12) == 1 && !isnan(f12)
        f12 = -f12
        print(io, compact ? "-" : " - ")
      else
        print(io, compact ? "+" : " + ")
      end  
      compact ? showcompact(io, f12) : show(io, f12)
      if !(isa(f12, Integer) || isa(f12, Rational) ||
           isa(f12, AbstractFloat) || isfinite(f12))
           print(io, "*")
      end
      print(io, "\u03F51\u03F52")
    end
  else
    print(io, "Hyper(", f0, ",", f1, ",", f2, ",", f12, ")")
  end
end

show(io::IO, z::Hyper) = hyper_show(io, z, false)
showcompact(io::IO, z::Hyper) = hyper_show(io, z, true)

function read(s::IO, ::Type{Hyper{T}}) where {T<:Real}
  f0 = read(s, T)
  f1 = read(s, T)
  f2 = read(s, T)
  f12 = read(s, T)
  Hyper{T}(f0, f1, f2, f12)
end

function write(s::IO, z::Hyper)
  write(s, realpart(z))
  write(s, eps1(z))
  write(s, eps2(z))
  write(s, eps1eps2(z))
end
  
#
# Generic function on hyperdualnumbers
#

convert(::Type{Hyper}, z::Hyper) = z
convert(::Type{Hyper}, x::Real) = hyper(x)

+(z::Hyper, w::Hyper) = hyper(realpart(z) + realpart(w), eps1(z) + eps1(w),
  eps2(z) + eps2(w), eps1eps2(z) + eps1eps2(w))
+(z::Number, w::Hyper) = hyper(z + realpart(w), eps1(w), eps2(w), eps1eps2(w))
+(z::Hyper, w::Number) = hyper(realpart(z) + w, eps1(z), eps2(z), eps1eps2(z))

-(z::Hyper) = hyper(-realpart(z), -eps1(z), -eps2(z), -eps1eps2(z))
-(z::Hyper, w::Hyper) = hyper(realpart(z) - realpart(w), eps1(z) - eps1(w),
  eps2(z) - eps2(w), eps1eps2(z) - eps1eps2(w))
-(z::Number, w::Hyper) = hyper(z - realpart(w), -eps1(w), -eps2(w), -eps1eps2(w))
-(z::Hyper, w::Number) = hyper(realpart(z) - w, eps1(z), eps2(z), eps1eps2(z))

*(x::Bool, z::Hyper) = ifelse(x, z, ifelse(signbit(realpart(z)) == 0, zero(z), -zero(z)))
*(x::Hyper, z::Bool) = z * x

*(z::Hyper, w::Hyper) = hyper(realpart(z) * realpart(w),
  realpart(z)*eps1(w)+eps1(z)*realpart(w), realpart(z)*eps2(w)+eps2(z)*realpart(w),
  realpart(z)*eps1eps2(w)+eps1(z)*eps2(w)+eps2(z)*eps1(w)+realpart(w)*eps1eps2(z))

*(z::Hyper, w::Real) = hyper(realpart(z) * w, eps1(z)*w, eps2(z)*w, w*eps1eps2(z))
*(z::Number, w::Hyper) = w * z

/(z::Hyper, w::Hyper) = z*(one(realpart(z))/w)
function /(z::Number, w::Hyper)
    invrw = one(z)/realpart(w)
    deriv = -z*invrw^2
    hyper(z*invrw, eps1(w)*deriv, eps2(w)*deriv,
          eps1eps2(w)*deriv-2eps1(w)*eps2(w)*deriv*invrw)
end

# Needed to prevent ambiguous warning:
#   /(Number,Complex{T<:Real}) at complex.jl:127

/(z::Hyper, w::Complex) = hyper(realpart(z)/w, eps1(z)/w, eps2(z)/w, eps1eps2(z)/w)
/(z::Hyper, w::Number) = hyper(realpart(z)/w, eps1(z)/w, eps2(z)/w, eps1eps2(z)/w)

abs2(z::Hyper) = z*z
abs(z::Hyper) = sqrt(abs2(z))                    # Is this correct?

for op in (:real, :imag, :conj, :float, :complex)
    @eval Base.$op(z::Hyper) = Hyper($op(realpart(z)), $op(eps1(z)), $op(eps2(z)), $op(eps1eps2(z)))
end

function ^(z::Hyper, w::Rational)
  deriv = w * realpart(z)^(w-1)
  hyper(realpart(z)^w, eps1(z)*deriv, eps2(z)*deriv,
    eps1eps2(z)*deriv+w*(w-1)*eps1(z)*eps2(z)*realpart(z)^(w-2))
end

function ^(z::Hyper, w::Integer)
  deriv = w * realpart(z)^(w-1)
  hyper(realpart(z)^w, eps1(z)*deriv, eps2(z)*deriv,
    eps1eps2(z)*deriv+w*(w-1)*eps1(z)*eps2(z)*realpart(z)^(w-2))
end

function ^(z::Hyper, w::Number)
  xval = realpart(z)
  tol = typeof(xval)==AbstractFloat ? eps(xval) : 10.0^-15
  if abs(float(xval)) < tol
    xval = ifelse(signbit(xval)==0, tol, -tol)
  end
  deriv = w * xval^(w-1)
  # Use actual value for f0, tol for deriv only
  hyper(realpart(z)^w, eps1(z)*deriv, eps2(z)*deriv,
    eps1eps2(z)*deriv+w*(w-1)*eps1(z)*eps2(z)*xval^(w-2))
end

^(z::Hyper, w::Hyper) = exp(w*log(z))

function exp(z::Hyper)
  deriv = exp(realpart(z))
  hyper(deriv, deriv*eps1(z), deriv*eps2(z), deriv*(eps1eps2(z)+eps1(z)*eps2(z)))
end

function log(z::Hyper)
  deriv1 = eps1(z)/realpart(z)
  deriv2 = eps2(z)/realpart(z)
  hyper(log(realpart(z)), deriv1, deriv2, eps1eps2(z)/realpart(z)-(deriv1*deriv2))
end

function sin(z::Hyper)
  funval = sin(realpart(z))
  deriv = cos(realpart(z))
  hyper(funval, deriv*eps1(z),deriv*eps2(z),deriv*eps1eps2(z)-funval*eps1(z)*eps2(z))
end

function cos(z::Hyper)
  funval = cos(realpart(z))
  deriv = -sin(realpart(z))
  hyper(funval, deriv*eps1(z),deriv*eps2(z),deriv*eps1eps2(z)-funval*eps1(z)*eps2(z))
end

function tan(z::Hyper)
  funval = tan(realpart(z))
  deriv = funval*funval+1
  hyper(funval, deriv*eps1(z),deriv*eps2(z),deriv*eps1eps2(z)+eps1(z)*eps2(z)*(2*funval*deriv))
end

function asin(z::Hyper)
  funval = asin(realpart(z))
  deriv1 = 1.0-realpart(z)*realpart(z)
  deriv = 1.0/sqrt(deriv1)
  hyper(funval, deriv*eps1(z),deriv*eps2(z),deriv*eps1eps2(z)+eps1(z)*eps2(z)*(realpart(z)/deriv1^1.5))
end

function acos(z::Hyper)
  funval = acos(realpart(z))
  deriv1 = 1.0-realpart(z)*realpart(z)
  deriv = -1.0/sqrt(deriv1)
  hyper(funval, deriv*eps1(z),deriv*eps2(z),deriv*eps1eps2(z)+eps1(z)*eps2(z)*(-realpart(z)/deriv1^1.5))
end

function erf(z::Hyper)
  funval = erf(realpart(z))
  deriv = 2.0*exp(-1.0*realpart(z)*realpart(z))/(sqrt(pi))
  deriv1 = -2.0*realpart(z)*deriv;
  hyper(funval, deriv*eps1(z),deriv*eps2(z),deriv*eps1eps2(z)+eps1(z)*eps2(z)*deriv1)
end

function atan(z::Hyper)
  funval = atan(realpart(z))
  deriv1 = 1.0+realpart(z)*realpart(z)
  deriv = 1.0/deriv1
  hyper(funval, deriv*eps1(z),deriv*eps2(z),
    deriv*eps1eps2(z)+eps1(z)*eps2(z)*(-2.0*realpart(z)/(deriv1*deriv1)))
end

sqrt(z::Hyper) = z^0.5

maximum(z::Hyper, w::Hyper) = z > w ? z : w
maximum(z::Hyper, w::Number) = z > w ? z : hyper(w)
maximum(z::Number, w::Hyper) = z > w ? hyper(z) : w

minimum(z::Hyper, w::Hyper) = z < w ? z : w
minimum(z::Hyper, w::Number) = z < w ? z : hyper(w)
minimum(z::Number, w::Hyper) = z < w ? hyper(z) : w

>(z::Hyper, w::Hyper) = realpart(z) > realpart(w)
>(z::Hyper, w::Number) = realpart(z) > w
>(z::Number, w::Hyper) = z > realpart(w)
>=(z::Hyper, w::Hyper) = realpart(z) >= realpart(w)
>=(z::Hyper, w::Number) = realpart(z) >= w
>=(z::Number, w::Hyper) = z >= realpart(w)
<(z::Hyper, w::Hyper) = realpart(z) < realpart(w)
<(z::Hyper, w::Number) = realpart(z) < w
<(z::Number, w::Hyper) = z < realpart(w)
<=(z::Hyper, w::Hyper) = realpart(z) <= realpart(w)
<=(z::Hyper, w::Number) = realpart(z) <= w
<=(z::Number, w::Hyper) = z <= realpart(w)


==(z::Hyper, w::Hyper) = realpart(z) == realpart(w) && eps1(z) == eps1(w) &&
  eps2(z) == eps2(w) && eps1eps2(z) == eps1eps2(w)  

==(z::Hyper, x::Real) = real_valued(z) && realpart(z) == x
==(x::Real, z::Hyper) = ==(z, x)

isequal(z::Hyper, w::Hyper) = isequal(realpart(z), realpart(w)) && isequal(eps1(z), eps1(w)) && 
  isequal(eps2(z), eps2(w)) && isequal(eps1eps2(z), eps1eps2(w))

isequal(z::Hyper, x::Real) = 
isequal(x::Real, z::Hyper) = ==(z, x)
