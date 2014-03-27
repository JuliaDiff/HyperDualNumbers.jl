immutable Hyper{T<:Real} <: Number
  re::T
  eps1::T
  eps2::T
  eps1eps2::T
end

Hyper(x::Real, eps1::Real, eps2::Real, eps1eps2::Real) =
  Hyper(promote(x, eps1, eps2, eps1eps2)...)

Hyper(x::Real) = Hyper(x, zero(eps1, zero(eps2), zero(eps1eps2)))

real(z::Hyper) = z.re
eps1(z::Hyper) = z.eps1
eps2(z::Hyper) = z.eps2
eps1eps2(z::Hyper) = z.eps1eps2

