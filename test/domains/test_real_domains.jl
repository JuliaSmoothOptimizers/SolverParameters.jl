
@testset "Testing Real domains" verbose = true begin
  @testset "RealIntervals{$T}" verbose = true for T in TYPES
    @testset "Test max-min of types" verbose = true begin
      min = typemin(T)
      max = typemax(T)
      d_closed = RealInterval(min, max)
      d_lopen = RealInterval(min, max; lower_open = true, upper_open = false)
      d_ropen = RealInterval(min, max, lower_open = false, upper_open = true)
      d_open = RealInterval(min, max, lower_open = true, upper_open = true)
      @testset "∈" verbose = true begin
        @test (min ∈ d_closed) == true
        @test (max ∈ d_closed) == true
        @test (min ∈ d_lopen) == false
        @test (max ∈ d_lopen) == true
        @test (min ∈ d_ropen) == true
        @test (max ∈ d_ropen) == false
        @test (min ∈ d_open || max ∈ d_open) == false
      end
      @testset "constructor" verbose = true begin
        @test_throws ErrorException RealInterval(max, min)
      end
    end
  end
  @testset "IntegerRange $T" verbose = true for T in (Int32, Int64)
    min = typemin(T)
    max = typemax(T)
    d = IntegerRange(min, max)
    @testset "∈" verbose = true begin
      @test (min ∈ d) == true
      @test (max ∈ d) == true
    end
    @testset "constructor" verbose = true begin
      @test_throws ErrorException IntegerRange(max, min)
    end
  end
  @testset "Binary range" begin
    b = BinaryRange()
    @test b.lower == false
    @test b.upper == true
  end
  @testset "IntegerSet" verbose = true begin
    d = IntegerSet([2, 4, 5, 1, 3, 7])
    @test lower(d) == 1
    @test upper(d) == 7
    @test (4 ∈ d) == true
    @test (6 ∈ d) == false
  end
end
