using HyperDualNumbers, Test

my_tests = [
    "test_basics.jl",
    "test_TimHoly_example.jl",
    "test_Paper_example.jl",
	"test_Erf_example.jl",
    #"test_power.jl",
    "tests_for_coverage.jl",
    "test_function_list.jl"
]

println("Running tests:")

@testset "HyperDualNumbers.jl" begin
    @testset "$my_test" for my_test in my_tests
        println("  * $(my_test) *")
        include(my_test)
        println("\n\n")
    end
end

println("Tests finished")
