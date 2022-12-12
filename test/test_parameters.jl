struct MockSolverParamSet{I, F} <: AbstractParameterSet
  real_inf::Parameter{F, RealInterval{F}}
  real::Parameter{F, RealInterval{F}}
  int_r::Parameter{I, IntegerRange{I}}
  int_s::Parameter{I, IntegerSet{I}}
end

function MockSolverParamSet(I::DataType, F::DataType)
  MockSolverParamSet(
    Parameter(F(42)),
    Parameter(F(1.5e-10), RealInterval(F(0.0), F(1.0))),
    Parameter(I(5), IntegerRange(I(5), I(20))),
    Parameter(I(5), IntegerSet(I[2, 4, 5, 1, 3, 7])),
  )
end

@testset "Parameter set for $(PRECISION)" for (PRECISION) in
                                              ["single precision", "double precision"]
  I, F = (PRECISION == "single precision") ? (Int32, Float32) : (Int64, Float64)
  param_set = MockSolverParamSet(I, F)

  set_names!(param_set)
  @testset "check fieldname is the name of each parameter" for f_name in
                                                               fieldnames(typeof(param_set))
    @test name(getfield(param_set, f_name)) == string(f_name)
  end
  @test lower_bounds(param_set) == [-Inf, 0.0, 5, 1]
  @test upper_bounds(param_set) == [Inf, 1.0, 20, 7]
  @test values(param_set) == [F(42), F(1.5e-10), I(5), I(5)]
  @testset "Real Parameter" verbose = true begin
    params = [param_set.real_inf, param_set.real]
    @testset "testing param $(p.name)" for p in params
      @test_throws DomainError set_value!(p, F(-Inf))
      set_value!(p, F(2 / 3))
      @testset "Testing getters" begin
        @test value(p) == F(2 / 3)
        param_domain = domain(p)
        @test (param_domain isa RealInterval{F}) == true
      end
    end
  end
  @testset "IntegerRange" begin
    param = param_set.int_r
    @test_throws DomainError set_value!(param, I(0))
    set_value!(param, I(20))
    @testset "Testing getters" begin
      @test value(param) == I(20)
      param_domain = domain(param)
      @test (param_domain isa IntegerRange{I}) == true
    end
  end
  @testset "IntegerSet parameter" begin
    param = param_set.int_s
    @test_throws DomainError set_value!(param, I(0))
    set_value!(param, I(2))
    @testset "Testing getters" begin
      @test value(param) == I(2)
      param_domain = domain(param)
      @test (param_domain isa IntegerSet{I}) == true
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

@testset "ParameterSruct methods" verbose = true begin
  I = Int64
  F = Float64
  param_set = MockSolverParamSet(I, F)
  set_names!(param_set)

  @test names(param_set) == Vector{String}(["real_inf", "real", "int_r", "int_s"])
  @test length(param_set) == 4
  @test values(param_set) == Vector{Any}([42, 1.5e-10, 5, 5])
  update!(param_set, Vector{Any}([1000.1, 2 / 3, 20, 1]))
  @test values(param_set) == Vector{Any}([1000.1, 2 / 3, 20, 1])
end
