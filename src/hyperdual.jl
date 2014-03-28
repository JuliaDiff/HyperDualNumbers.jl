immutable Hyper{T<:Real} <: Number
  re::T
  eps1::T
  eps2::T
  eps1eps2::T
end

Hyper(x::Real, eps1::Real, eps2::Real, eps1eps2::Real) =
  Hyper(promote(x, eps1, eps2, eps1eps2)...)

Hyper(x::Real) = Hyper(x, zero(eps1, zero(eps2), zero(eps1eps2)))

typealias Hyper256 Hyper{Float64}
typealias Hyper128 Hyper{Float32}

real(z::Hyper) = z.re
eps1(z::Hyper) = z.eps1
eps2(z::Hyper) = z.eps2
eps1eps2(z::Hyper) = z.eps1eps2

eps(z::Hyper) = eps(real(z))
eps{T}(::Type{Hyper{T}}) = eps(T)
one(z::Hyper) = Hyper(one(real(z)))
one{T}(::Type{Hyper{T}}) = Hyper(one(T))
nan{T}(::Type{Hyper{T}}) = nan(one(T))
isnan(z::Hyper) = isnan(real(z))

convert{T<:Real}(::Type{Hyper{T}}, x::Real) =
  Hyper{T}(convert(T, x), convert(T, 0), convert(T, 0), convert(T, 0))

convert{T<:Real}(::Type{Hyper{T}}, z::Hyper{T}) = z

convert{T<:Real}(::Type{Hyper{T}}, z::Hyper) =
  Hyper{T}(convert(T, real(z)), convert(T, eps1(z)), convert(T, eps2(z)),
    convert(T, eps1eps2(z)))

# Need to better understand what this means
convert{T<:Real}(::Type{T}, z::Hyper) =
  ((eps1(z) == 0 && eps2(z) == 0) ? convert(T, real(z)) : throw(InexactError()))

# Again, need better grasp 
promote_rule{T<:Real, S<:Real, Q<:Real, P<:Real}
  (::Type{Hyper{T}}, ::Type{Hyper{S}}, ::Type{Hyper{Q}}, ::Type{Hyper{P}}) =
    Hyper{promote_type(T, S, Q, P)}

promote_rule{T<:Real}(::Type{Hyper{T}}, ::Type{T}, ::Type{T}, ::Type{T}) = Hyper{T}

promote_rule{T<:Real, S<:Real, Q<:Real, P<:Real}
  (::Type{Hyper{T}}, ::Type{S}, ::Type{Q}, ::Type{P}) =
    Hyper{promote_type(T, S, Q, P)}

hyper(x, y, z, yz) = Hyper(x, y, z, yz)
hyper(x) = Hyper(x)

@vectorize_1arg Real hyper

hyper256(s::Float64, t::Float64, q::Float64, p::Float64) = Hyper{Float64}(s, t, q, p)
hyper256(s::Real, t::Real, q::Real, p::Real) =
  hyper256(float64(s), float64(t), float64(q), float64(p))
hyper256(z) = hyper256(real(z), eps1(z), eps2(z), eps1eps2(z))

hyper128(s::Float32, t::Float32, q::Float32, p::Float32) = Hyper{Float32}(s, t, q, p)
hyper128(s::Real, t::Real, q::Real, p::Real) =
  hyper128(float32(s), float32(t), float32(q), float32(p))
hyper128(z) = hyper128(real(z), eps1(z), eps2(z), eps1eps2(z))

ishyper(x::Hyper) = true
ishyper(x::Number) = false

real_valued{T<:Real}(z::Hyper{T}) = (eps1 == 0 && eps2 == 0 && eps1eps2 == 0)
integer_valued(z::Hyper) = real_valued(z) && integer_valued(real(z))

isfinite(z::Hyper) = isfinite(real(z))
reim(z::Hyper) = (real(z), eps1(z), eps2(z), eps1eps2(z))


