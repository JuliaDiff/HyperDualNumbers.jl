immutable Hyper{T<:Real} <: Number
  re::T
  eps1::T
  eps2::T
  eps1eps2::T
end

Hyper(x::Real, eps1::Real, eps2::Real, eps1eps2::Real) =
  Hyper(promote(x, eps1, eps2, eps1eps2)...)

Hyper(x::Real) = Hyper(x, zero(eps1, zero(eps2), zero(eps1eps2)))

typealias Hyper64 Hyper{Float64}
typealias Hyper32 Hyper{Float32}

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
  (eps1(z) == 0 && eps2 == 0 ? convert(T, real(z)) : throw(InexactError()))

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