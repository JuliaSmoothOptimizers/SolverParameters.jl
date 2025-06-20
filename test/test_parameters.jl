struct MockSolverParamSet{I, F} <: AbstractParameterSet
  real_inf::Parameter{F, RealInterval{F}}
  real::Parameter{F, RealInterval{F}}
  int_inf::Parameter{I, IntegerRange{I}}
  int_r::Parameter{I, IntegerRange{I}}
  int_s::Parameter{I, IntegerSet{I}}
  boolean::Parameter{Bool, BinaryRange{Bool}}
end

const real_inf = DefaultParameter(F -> F(42), "42")
@test "$real_inf" == "42"
const real = DefaultParameter(F -> F(1.5e-10), "1.5e-10")
@test "$real" == "1.5e-10"
const int_inf = DefaultParameter(I -> I(5), "5")
@test "$int_inf" == "5"
const int_r = DefaultParameter(I -> I(5), "5")
@test "$int_r" == "5"
const int_s = DefaultParameter(I -> I(5), "5")
@test "$int_s" == "5"
const boolean = DefaultParameter(true)
@test "$boolean" == "true"

show(real_inf)

function MockSolverParamSet(I::DataType, F::DataType)
  MockSolverParamSet(
    Parameter(get(real_inf, F)),
    Parameter(get(real, F), RealInterval(F(0.0), F(1.0))),
    Parameter(get(int_inf, I)),
    Parameter(get(int_r, I), IntegerRange(I(5), I(20))),
    Parameter(get(int_s, I), IntegerSet(I[2, 4, 5, 1, 3, 7])),
    Parameter(get(boolean), BinaryRange()),
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

  @test lower_bounds(param_set) == Any[-Inf, 0.0, typemin(I), 5, 1, false]
  @test upper_bounds(param_set) == Any[Inf, 1.0, typemax(I), 20, 7, true]
  @test values(param_set) == [F(42), F(1.5e-10), I(5), I(5), I(5), true]
  @test rand(param_set) != rand(param_set)

  @test rand(param_set) ∈ param_set
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
  @testset "BinaryRange" begin
    param = param_set.boolean
    @testset "Testing getters" begin
      @test value(param) == true
      param_domain = domain(param)
      @test (param_domain isa BinaryRange{Bool}) == true
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

  @test names(param_set) ==
        Vector{String}(["real_inf", "real", "int_inf", "int_r", "int_s", "boolean"])
  @test length(param_set) == 6
  if check_allocations
    a = @allocated length(param_set)
    @test a == 0
  end
  @test values(param_set) == Vector{Any}([42, 1.5e-10, 5, 5, 5, true])
  set_values!(param_set, Vector{Any}([1000.1, 2 / 3, 3, 20, 1, false]))
  @test values(param_set) == Vector{Any}([1000.1, 2 / 3, 3, 20, 1, false])
  @test rand(param_set) ∈ param_set
end

struct CatMockSolverParamSet{I, F} <: AbstractParameterSet
  real_inf::Parameter{F, RealInterval{F}}
  real::Parameter{String, CategoricalSet{String}}
  int_r::Parameter{I, IntegerRange{I}}
end

function CatMockSolverParamSet()
  CatMockSolverParamSet(
    Parameter(Float64(42)),
    Parameter("A", CategoricalSet(["A", "B", "C", "D"])),
    Parameter(Int32(5), IntegerRange(Int32(5), Int32(20))),
  )
end

@testset "Numerical/Categorical parameters in ParameterSet" begin
  param_set = CatMockSolverParamSet()

  @test rand(param_set) ∈ param_set

  @test length_num(param_set) == 2
  @test length(param_set) == 3

  @test values(param_set) == [42.0, "A", 5]
  @test values_num(param_set) == [42.0, 5]
  b = zeros(Float64, 2)
  @test values_num!(param_set, b) == [42.0, 5.0]
  b = zeros(Float32, 2)
  @test values_num!(param_set, b) == Float32[42.0, 5.0]
  b = zeros(Int32, 2)
  @test values_num!(param_set, b) == Int32[42.0, 5.0]

  set_values_num!(param_set, [42.5, 5.6])
  @test values(param_set) == [42.5, "A", 6]

  b = zeros(Float32, 2)
  @test values_num!(param_set, b) == Float32[42.5, 6.0]
  b = zeros(Int32, 2)
  @test_throws InexactError values_num!(param_set, b) # because it cannot convert 42.5 as integer

  @test [42.0, "A", 5] in param_set
  @test [42.0, "A", 5.2] in param_set
  @test !([42.0, "E", 5] in param_set)

  @test lower_bounds(param_set) == [-Inf, 5] # the eltype is Any
  b = zeros(2)
  @test lower_bounds!(param_set, b) == [-Inf, 5]
  @test eltype(b) == Float64

  @test upper_bounds(param_set) == [Inf, 20] # the eltype is Any
  b = zeros(2)
  @test upper_bounds!(param_set, b) == [Inf, 20]
  @test eltype(b) == Float64
end

@testset "Subset parameters in ParameterSet" begin
  param_set = CatMockSolverParamSet()
  subset = (:real_inf, :real)

  r = rand(subset, param_set)
  @test r[1] ∈ param_set.real_inf.domain
  @test r[2] ∈ param_set.real.domain

  @test length(subset) == 2

  @test values(subset, param_set) == [42.0, "A"]
  @test values_num(subset, param_set) == [42.0]
  b = zeros(Float64, 1)
  @test values_num!(subset, param_set, b) == [42.0]
  b = zeros(Float32, 1)
  @test values_num!(subset, param_set, b) == Float32[42.0]
  b = zeros(Int32, 1)
  @test values_num!(subset, param_set, b) == Int32[42.0]

  set_values_num!(subset, param_set, [42.5])
  @test values(subset, param_set) == [42.5, "A"]

  b = zeros(Float32, 1)
  @test values_num!(subset, param_set, b) == Float32[42.5]
  b = zeros(Int32, 1)
  @test_throws InexactError values_num!(subset, param_set, b) # because it cannot convert 42.5 as integer

  @test lower_bounds(subset, param_set) == [-Inf] # the eltype is Any
  b = zeros(1)
  @test lower_bounds!(subset, param_set, b) == [-Inf]
  @test eltype(b) == Float64

  @test upper_bounds(subset, param_set) == [Inf] # the eltype is Any
  b = zeros(1)
  @test upper_bounds!(subset, param_set, b) == [Inf]
  @test eltype(b) == Float64
end

@testset "Enum parameters in ParameterSet" begin
  param_set = CatMockSolverParamSet()
  enum(param_set) == [
    (:real_inf, -6.7108864e7:1.4901161193847656e-8:6.7108864e7),
    (:real, ["A", "B", "C", "D"]),
    (:int_r, 5:1:20),
  ]
end
