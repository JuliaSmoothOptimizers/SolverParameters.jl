@testset "CategoricalSet" verbose=true begin
    d = CategoricalSet(["A", "B", "C", "D"])
    @test ("A" ∈ d) == true
    @test ("B" ∈ d) == true
    @test ("E" ∈ d) == false
end