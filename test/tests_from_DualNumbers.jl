using HyperDualNumbers, SpecialFunctions
using Test
using LinearAlgebra
import NaNMath

@test isequal(1.0, Hyper(1.0))

Base.eps(x::Int) = eps(float(x)) # overload eps to work on integers

@testset "f : ℝ → ℝ" begin

    x₀s = (-2.5:0.1:2.5)
    function_list = [
        (:( x^3 ), :( 3x^2 ), :( 6x ))
        (:( x^3.0 ), :( 3.0x^2 ), :( 6.0x ))
        (:( sin(x) + exp(x) ), :( cos(x) + exp(x) ), :( -sin(x) + exp(x) ))
        (:( abs(-x^2) ), :( 2x ), :( 2 ))
        (:( 1/x ), :( -1/x^2 ), :( 2/x^3 ))
        (:( exp(1)^x ), :( exp(1)^x ), :( exp(1)^x ))
        (:( NaNMath.pow(exp(1),x) ), :( NaNMath.pow(exp(1),x) ), :( NaNMath.pow(exp(1),x) ))
        (:( NaNMath.sin(x) ), :( NaNMath.cos(x) ), :( -NaNMath.sin(x) ))
    ]

    @testset "for f(x) = $fexp" for (fexp, Dfexp, D²fexp) in function_list
        @eval f(x) = $fexp
        @eval Df(x) = $Dfexp
        @eval D²f(x) = $D²fexp
        @testset "for x = $x₀" for x₀ in x₀s
            (isnan(f(x₀)) || isnan(Df(x₀)) || isnan(D²f(x₀))) && continue
            (isinf(f(x₀)) || isinf(Df(x₀)) || isinf(D²f(x₀))) && continue
            t₀ = Hyper(x₀, 1, 1, 0)
            @test realpart(f(t₀)) ≈ f(x₀) rtol = 5eps()
            @test ε₁part(f(t₀)) ≈ Df(x₀) rtol = 5eps()
            @test ε₂part(f(t₀)) ≈ Df(x₀) rtol = 5eps()
            @test ε₁ε₂part(f(t₀)) ≈ D²f(x₀) rtol = 5eps()
        end
    end

end


@testset "f : ℝ² → ℝ" begin

    xrange = -2.0:0.1:2.0
    e₁, e₂ = [1, 0], [0, 1] # base vectors
    xs = (x₁ * e₁ + x₂ * e₂ for x₁ in xrange, x₂ in xrange)
    global Q = [1.0 0.1; 0.1 1.0]
    function_list = [
        (:( 0.5x'Q*x ), :( Q*x ), :( Q ))
        (:( x[1]^2+x[2] ), :( [2x[1], 1] ), :( [2 0;0 0] ))
        (:( x[1]^x[2] ), :( [x[1]^(x[2] - 1)*x[2], x[1]^x[2]*log(x[1])] ), :( [x[1]^(x[2] - 2)*(x[2] - 1)*x[2] x[1]^(x[2] - 1)*x[2]*log(x[1]) + x[1]^x[2]/x[1]; x[1]^(x[2] - 1)*x[2]*log(x[1]) + x[1]^x[2]/x[1] x[1]^x[2]*log(x[1])^2] ))
    ]

    @testset "for f(x) = $fexp" for (fexp, Dfexp, D²fexp) in function_list
        @eval f(x) = $fexp
        @eval Df(x) = $Dfexp
        @eval D²f(x) = $D²fexp

        @testset "for x = $x" for x in xs
            try # Necessary to avoid cases where the functions are not defined (e.g., (-1)^0.5)
                f(x), Df(x), D²f(x)
            catch
                continue
            end

            if (any(isnan.(f(x))) || any(isnan.(Df(x))) || any(isnan.(D²f(x)))) ||
               (any(isinf.(f(x))) || any(isinf.(Df(x))) || any(isinf.(D²f(x))))
                continue
            end

            @testset "realpart(f(x + ε₁ b + ε₂ c + ε₁ε₂ d)) = f(x)" begin
                t₀ = x + randn(2, 3) * [ε₁, ε₂, ε₁ε₂]
                @test realpart(f(t₀)) ≈ f(x) rtol = 1e1eps()
            end

            @testset "ε₁part(f(x + ε₁ e₁ + ε₂ c + ε₁ε₂ d)) = ∂f/∂x₁(x)" begin
                t₀ = x + ε₁ * e₁ + randn(2, 2) * [ε₂, ε₁ε₂]
                @test ε₁part(f(t₀)) ≈ Df(x)[1] rtol = 1e2eps()
            end
            @testset "ε₂part(f(x + ε₁ b + ε₂ e₁ + ε₁ε₂ d)) = ∂f/∂x₁(x)" begin
                t₀ = x + ε₂ * e₁ + randn(2, 2) * [ε₁, ε₁ε₂]
                @test ε₂part(f(t₀)) ≈ Df(x)[1] rtol = 1e2eps()
            end

            @testset "ε₁part(f(x + ε₁ e₂ + ε₂ c + ε₁ε₂ d)) = ∂f/∂x₂(x)" begin
                t₀ = x + ε₁ * e₂ + randn(2, 2) * [ε₂, ε₁ε₂]
                @test ε₁part(f(t₀)) ≈ Df(x)[2] rtol = 1e2eps()
            end
            @testset "ε₂part(f(x + ε₂ b + ε₂ e₂ + ε₁ε₂ d)) = ∂f/∂x₂(x)" begin
                t₀ = x + ε₂ * e₂ + randn(2, 2) * [ε₁, ε₁ε₂]
                @test ε₂part(f(t₀)) ≈ Df(x)[2] rtol = 1e2eps()
            end

            @testset "ε₁ε₂part(f(x + ε₁ e₁ + ε₂ e₁)) = ∂²f/∂x₁²(x)" begin
                t₀ = x + ε₁ * e₁ + ε₂ * e₁
                @test ε₁ε₂part(f(t₀)) ≈ D²f(x)[1, 1] rtol = 1e4eps()
            end
            @testset "ε₁ε₂part(f(x + ε₁ e₁ + ε₂ e₂)) = ∂²f/∂x₁∂x₂(x)" begin
                t₀ = x + ε₁ * e₁ + ε₂ * e₂
                @test ε₁ε₂part(f(t₀)) ≈ D²f(x)[1, 2] rtol = 1e4eps()
            end
            @testset "ε₁ε₂part(f(x + ε₁ e₂ + ε₂ e₁)) = ∂²f/∂x₂∂x₁(x)" begin
                t₀ = x + ε₁ * e₂ + ε₂ * e₁
                @test ε₁ε₂part(f(t₀)) ≈ D²f(x)[2, 1] rtol = 1e4eps()
            end
            @testset "ε₁ε₂part(f(x + ε₁ e₂ + ε₂ e₂)) = ∂²f/∂x₂²(x)" begin
                t₀ = x + ε₁ * e₂ + ε₂ * e₂
                @test ε₁ε₂part(f(t₀)) ≈ D²f(x)[2, 2] rtol = 1e4eps()
            end
        end
    end

end

@testset "squareroot function" begin
    function squareroot(x)
        it = x
        while abs(it*it - x) > 1e-13
            it = (it+x/it)/2
        end
        return it
    end
    x = 10000.0
    Dsquareroot(x) = 0.5 / squareroot(x)
    D²squareroot(x) = -0.25 / squareroot(x)^3
    t₀ = x + ε₁ + ε₂

    @test ε₁part(squareroot(t₀)) ≈ Dsquareroot(x) rtol = 5eps()
    @test ε₂part(squareroot(t₀)) ≈ Dsquareroot(x) rtol = 5eps()
    @test ε₁ε₂part(squareroot(t₀)) ≈ D²squareroot(x) rtol = 1e2eps()
end


@testset "Test `eps`, `one`, `convert`, and `isnan`" begin
    @test Hyper(1.0, 3, 0, 0) == Hyper(1.0, 3.0, 0.0, 0.0)
    x = Hyper(1.0, 2.0, 3.0, 4.0)
    @test eps(x) == eps(1.0)
    @test eps(Hyper{Float64}) == eps(Float64)
    @test one(x) == Hyper(1.0, 0.0, 0.0, 0.0)
    @test one(Hyper{Float64}) == Hyper(1.0, 0.0, 0.0, 0.0)
    @test convert(Hyper{Float64}, Inf) == convert(Float64, Inf)
    @test isnan(convert(Hyper{Float64}, NaN))
    @test convert(Hyper{Float64},Hyper(1, 2, 3, 4)) == Hyper(1.0, 2.0, 3.0, 4.0)
    @test convert(Float64, Hyper(10.0, 0.0, 0.0, 0.0)) == 10.0
    @test convert(Hyper{Int}, Hyper(10.0, 0.0, 0.0, 0.0)) == Hyper(10, 0, 0, 0)
end

@testset "Test `floor`, `ceil`, etc." begin
    x = Hyper(1.2, 2.0, 3.0, 4.0)
    @test floor(x) === 1.0
    @test ceil(x)  === 2.0
    @test trunc(x) === 1.0
    @test round(x) === 1.0
    @test floor(Int, x) === 1
    @test ceil(Int, x)  === 2
    @test trunc(Int, x) === 1
    @test round(Int, x) === 1
end

# test Hyper{Complex}

@testset "Test Hyper dual complex" begin

    arange = -2.5:0.5:2.5
    brange = arange
    z₀s = (a + im * b for a in arange, b in brange)
    function_list = [
        (:( exp(z) ), :( exp(z) ), :( exp(z) ))
        (:( sinpi(z) ), :( π * cospi(z) ), :(  -π^2 * sinpi(z) ))
        (:( z^4 ), :( 4z^3 ), :(  12z^2 ))
        (:( log(z) ), :( 1/z ), :( -1/z^2 ))
    ]
    # Removed `abs2`, `sign`, and `angle` because not ℂ-differentiable

    @testset "for f(z) = $fexp" for (fexp, Dfexp, D²fexp) in function_list
        @eval f(z) = $fexp
        @eval Df(z) = $Dfexp
        @eval D²f(z) = $D²fexp
        @testset "for z = $z₀" for z₀ in z₀s
            (isnan(f(z₀)) || isnan(Df(z₀)) || isnan(D²f(z₀))) && continue
            (isinf(f(z₀)) || isinf(Df(z₀)) || isinf(D²f(z₀))) && continue
            t₀ = Hyper(z₀, 1, 1, 0)
            @test realpart(f(t₀)) ≈ f(z₀) rtol = 5eps()
            @test ε₁part(f(t₀)) ≈ Df(z₀) rtol = 5eps()
            @test ε₂part(f(t₀)) ≈ Df(z₀) rtol = 5eps()
            @test ε₁ε₂part(f(t₀)) ≈ D²f(z₀) rtol = 5eps()
        end
    end

    @testset "complex type conversion" begin
        for T in [Float16, Float32, Float64, BigFloat, Int8, Int16, Int32, Int64, Int128, BigInt, Bool]
            D = Hyper{T}
            @test typeof(complex(zero(D))) == complex(D)
            D = Hyper{Complex{T}}
            @test typeof(complex(zero(D))) == complex(D)
        end
    end
end

@testset "Check bug in `inv`" begin
    @test inv(hyper(1.0 + 1.0im, 1.0, 1.0, 0.0)) == 1 / hyper(1.0 + 1.0im, 1.0, 1.0, 1.0) == hyper(1.0 + 1.0im, 1.0, 1.0, 0.0)^(-1)
end


# Removed "Tests limit definition"
# . Let z = a + b ɛ, where a and b ∈ C.
#
# The dual of |z| is lim_{h→0} (|a + bɛh| - |a|)/h
#
# and it depends on the direction (i.e. the complex value of epsilon(z)).


@testset "Test vectorized methods" begin
    z₀ = collect(1.0:10.0)
    t₀ = hyper.(z₀, ones(10), ones(10), zeros(10))

    f(z) = exp(z)
    Df(z) = exp(z)
    D²f(z) = exp(z)
    @test realpart.(f.(t₀)) ≈ f.(z₀) rtol = 5eps()
    @test ε₁part.(f.(t₀)) ≈ Df.(z₀) rtol = 5eps()
    @test ε₂part.(f.(t₀)) ≈ Df.(z₀) rtol = 5eps()
    @test ε₁ε₂part.(f.(t₀)) ≈ D²f.(z₀) rtol = 5eps()
end


@testset "Test norms and inequalities" begin
    z₀ = collect(1.0:10.0)
    t₀ = hyper.(z₀, ones(10), ones(10), zeros(10))
    @test norm(f.(t₀), Inf) ≤ norm(f.(t₀)) ≤ norm(f.(t₀), 1)
end

# tests for constants ɛ
@testset "Test constants ɛ₁, ε₂, etc." begin
    @test ε₁part(1 + ɛ₁) == 1
    @test ε₂part(1 + ɛ₂) == 1
    @test ε₁ε₂part(1 + ɛ₁ε₂) == 1

    @test ε₁part(1 + 0ɛ₁) == 0
    @test ε₂part(1 + 0ɛ₂) == 0
    @test ε₁ε₂part(1 + 0ɛ₁ε₂) == 0

    @test imε₁ == Hyper(0,im,0,0)
    @test imε₂ == Hyper(0,0,im,0)
    @test imε₁ε₂ == Hyper(0,0,0,im)
end


@testset "Test `mod`" begin
    x₀ = 15.23
    t₀ = Hyper(x₀, 1, 2, 3)
    q = 10
    y₀ = mod(x₀, q)

    @test realpart(mod(t₀, q)) == y₀
    @test ε₁part(mod(t₀, q)) == 1
    @test ε₂part(mod(t₀, q)) == 2
    @test ε₁ε₂part(mod(t₀, q)) == 3

end


# `flipsign` tests are commented outt for now until I figure out why
# DualNumbers.jl and ForwardDiff.jl do not follow this rule
#@testset "Test for `flipsign`" begin
#    t₀ = Hyper(1, 2, 3, 4)
#    @test isequal(flipsign(t₀, +1                 ),  t₀)
#    @test isequal(flipsign(t₀, -1                 ), -t₀)
#    @test isequal(flipsign(t₀,     +ε₁            ),  t₀)
#    @test isequal(flipsign(t₀,     -ε₁            ), -t₀)
#    @test isequal(flipsign(t₀,          +ε₂       ),  t₀)
#    @test isequal(flipsign(t₀,          -ε₂       ), -t₀)
#    @test isequal(flipsign(t₀,               +ε₁ε₂),  t₀)
#    @test isequal(flipsign(t₀,               -ε₁ε₂), -t₀)
#    @test isequal(flipsign(t₀,     +ε₁ - ε₂       ),  t₀)
#    @test isequal(flipsign(t₀,     +ε₁ - ε₂ - ε₁ε₂), -t₀)
#    @test isequal(flipsign(t₀,     +ε₁ - ε₂ + ε₁ε₂), t₀)
#    @test isequal(flipsign(t₀,     -ε₁ + ε₂       ),  t₀)
#    @test isequal(flipsign(t₀,     -ε₁ + ε₂ - ε₁ε₂), -t₀)
#    @test isequal(flipsign(t₀,     -ε₁ + ε₂ + ε₁ε₂), t₀)
#end


# TODO: test SpecialFunctions
#@test erf(dual(1.0,1.0)) == dual(erf(1.0), 2exp(-1.0^2)/sqrt(π))
#@test gamma(dual(1.,1)) == dual(gamma(1.0),polygamma(0,1.0))

