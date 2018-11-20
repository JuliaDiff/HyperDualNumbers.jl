# Test functions on real and complex numbers
function nums(str)
    if str == "ℕ"
        return (-1, 0, 1)
    elseif str == "ℝ"
        return (-1.0, 0.0, 1.0)
    elseif str == "ℂ"
        return (r₁ + im * r₂ for r₁ in nums("ℝ"), r₂ in nums("ℝ"))
    elseif str == "Infs"
        return (-Inf, +Inf)
    elseif str == "InfsNaN"
        return (-Inf, NaN, +Inf)
    elseif str == "ℝInfs"
        return (nums("ℝ")..., nums("Infs")...)
    elseif str == "ℂInfs"
        return (nums("ℂ")..., nums("Infs")...)
    elseif str == "ℝInfsNaN"
        return (nums("ℝ")..., nums("InfsNaN")...)
    elseif str == "ℂInfsNaN"
        return (nums("ℂ")..., nums("InfsNaN")...)
    elseif str == "bool"
        return (false, true)
    elseif str == "ℂbool"
        return (b₁ + im * b₂ for b₁ in nums("bool"), b₂ in nums("bool"))
    else
        return nothing
    end
end

@testset "$ftest(x)" for ftest in (realpart, identity)
    @testset "for $str" for str in ("ℝ", "ℂ", "ℝInfs", "ℂInfs")
        @testset "for x = $x" for x in nums(str)
            @test ftest(x) == x
        end
    end
end
@testset "$ftest(x)" for ftest in (ε₁part, eps1, ε₂part, eps2, ε₁ε₂part, eps1eps2)
    @testset "for $str" for str in ("ℝ", "ℂ", "ℝInfs", "ℂInfs", "ℝInfsNaN", "ℂInfsNaN")
        @testset "for x = $x" for x in nums(str)
            @test ftest(x) == zero(x)
        end
    end
end
@testset "$ftest(x)" for ftest in (isinf, isnan)
    @testset "for $str" for str in ("ℕ", "ℝ", "ℂ", "ℝInfsNaN", "ℂInfsNaN")
        @testset "for x = $x" for x in nums(str)
            @test ftest(hyper(x)) == ftest(x)
        end
    end
end

@testset "for x = $x" for x in nums("ℝ")
    @test eps(hyper(x)) == eps(x)
end

println("\nRandom examples of show() for hyperdual numbers:\n")
for nums in (ℝnums2, ℂnums, ℂbools)
    for i in 1:10
        a, b, c, d = rand([nums...], 4)
        println("h = $(hyper(a, b, c, d))")
    end
end
println("\nExamples of show() for special printing for boolean hyperdual numbers:\n")
for h in (hyper(true), ε₁, ε₂, ε₁ε₂, hyper(complex(false, true)), imε₁, imε₂, imε₁ε₂)
    println("h = $h")
end


@testset "for x = $x" for x in nums("ℝ")
    @test convert(Hyper, x) == x
end

@testset "for $str" for str in ("ℕ", "ℝ", "ℂ", "ℝInfsNaN", "ℂInfsNaN")
    @testset "h = $(hyper(a, b, c, d))" for a in nums(str), b in nums(str), c in nums(str), d in nums(str)
        h = hyper(a, b, c, d)
        @test (realpart(h) == h) || isnan(h)
    end
    @testset "h = $(hyper(a))" for a in nums(str)
        @test isequal(realpart(h), h) || isnan(h)
    end
end


