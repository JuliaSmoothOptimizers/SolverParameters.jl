@testset "CategoricalSet" verbose = true begin
  d = CategoricalSet(["A", "B", "C", "D"])
  @test ("A" ∈ d) == true
  @test ("B" ∈ d) == true
  @test ("E" ∈ d) == false
  @test_throws DomainError lower(d)
  @test_throws DomainError upper(d)

  d = CategoricalSet([:france, :argentine])
  @test (:france ∈ d) == true
  @test (:argentine ∈ d) == true
  @test (:canada ∈ d) == false
  @test_throws DomainError lower(d)
  @test_throws DomainError upper(d)
end
