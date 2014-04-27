my_tests = ["test/test_basics.jl",
            "test/test_TimHoly_example.jl",
            "test/test_Paper_example.jl"]

println("Running tests:")

for my_test in my_tests
    println("  * $(my_test) *")
    include(my_test)
    println("\n\n")
end
