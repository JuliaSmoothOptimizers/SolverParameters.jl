struct MockSolverParamSet64 <: AbstractParameterSet
  real::Parameter{Float64, RealInterval{Float64}}
  int_r::Parameter{Int64, IntegerRange{Int64}}
  int_s::Parameter{Int64, IntegerSet{Int64}}
end

struct MockSolverParamSet32 <: AbstractParameterSet
  real::Parameter{Float32, RealInterval{Float32}}
  int_r::Parameter{Int32, IntegerRange{Int32}}
  int_s::Parameter{Int32, IntegerSet{Int32}}
end

function MockSolverParamSet32()
  I = Int32
  R = Float32
  MockSolverParamSet32(
    Parameter(R(1.5e-10), RealInterval(R(0.0), R(1.0)), "real"),
    Parameter(I(5), IntegerRange(I(5), I(20)), "int_r"),
    Parameter(I(5), IntegerSet(I[2, 4, 5, 1, 3, 7]), "int_s"),
  )
end
function MockSolverParamSet64()
  I = Int64
  MockSolverParamSet64(
    Parameter(1.5e-10, RealInterval(0.0, 1.0), "real"),
    Parameter(I(5), IntegerRange(I(5), I(20)), "int_r"),
    Parameter(I(5), IntegerSet(I[2, 4, 5, 1, 3, 7]), "int_s"),
  )
end

@testset "Parameter set for $(PRECISION)" for (PRECISION) in
                                              ["single precision", "double precision"]
  param_set = (PRECISION == "single precision") ? MockSolverParamSet32() : MockSolverParamSet64()
  R = (PRECISION == "single precision") ? Float32 : Float64
  I = (PRECISION == "single precision") ? Int32 : Int64
  @testset "Real Parameter" verbose = true begin
    param = param_set.real
    @test_throws DomainError set_value!(param, -1)
    set_value!(param, 2 / 3)
    @testset "Testing getters" begin
      @test value(param) == R(2 / 3)
      param_domain = domain(param)
      @test (param_domain isa RealInterval{R}) == true
      @test name(param) == "real"
    end
  end
  @testset "IntegerRange" begin
    param = param_set.int_r
    @test_throws DomainError set_value!(param, 0)
    set_value!(param, 20)
    @testset "Testing getters" begin
      @test value(param) == 20
      param_domain = domain(param)
      @test (param_domain isa IntegerRange{I}) == true
      @test name(param) == "int_r"
    end
  end
  @testset "IntegerSet parameter" begin
    param = param_set.int_s
    @test_throws DomainError set_value!(param, 0)
    set_value!(param, 2)
    @testset "Testing getters" begin
      @test value(param) == 2
      param_domain = domain(param)
      @test (param_domain isa IntegerSet{I}) == true
      @test name(param) == "int_s"
    end
  end
end

@testset "Categorical parameters" verbose = true begin
  param = Parameter("A", CategoricalSet(["A", "B", "C"]), "categorical_param")
  @test_throws DomainError set_value!(param, "D")
  set_value!(param, "B")
  @testset "Testing getters" begin
    @test value(param) == "B"
    param_domain = domain(param)
    @test (param_domain isa CategoricalSet{String}) == true
    @test name(param) == "categorical_param"
  end
end
