@testset "testing abstract domains" verbose = true begin
  @testset "Testing functions taking AbstractDomain type $T" for T in (Int, Float32, Float64)
    struct MockDomain{T} <: AbstractDomain{T}
      lower::T
      upper::T
    end
    mock_domain = MockDomain(T(0), T(1))
    @test (T(0) ∈ mock_domain) == false
    @test (T(0) in mock_domain) == false
    @test_throws DomainError lower(mock_domain)
    @test_throws DomainError upper(mock_domain)
  end
end

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
  @test rand(d) ∈ d

  d = CategoricalSet()
  @test d.categories == Vector{String}()
end

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
      @test rand(d_closed) ∈ d_closed
      @test rand(d_lopen) ∈ d_lopen
      @test rand(d_ropen) ∈ d_ropen
      @test rand(d_open) ∈ d_open
      @testset "enum" verbose = true for d in [d_closed, d_lopen, d_ropen, d_open]
        i = 0
        for elt in enum(d)
          @test eltype(elt) == T
          i += 1
          if i == 3
            break
          end
        end
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
    @test rand(d) ∈ d
    @test enum(d) == typemin(T):1:typemax(T)
    @test enum(d, step = 2) == typemin(T):2:typemax(T)
  end
  @testset "Binary range" begin
    b = BinaryRange()
    @test lower(b) == false
    @test upper(b) == true
    @test rand(b) ∈ b
    for elt in enum(b)
      @test eltype(elt) == Bool
    end
  end
  @testset "IntegerSet" verbose = true begin
    vecset = [2, 4, 5, 1, 3, 7]
    d = IntegerSet(vecset)
    @test lower(d) == 1
    @test upper(d) == 7
    @test (4 ∈ d) == true
    @test (6 ∈ d) == false
    @test rand(d) ∈ d
    enum(d) == Set(vecset)
  end
end
