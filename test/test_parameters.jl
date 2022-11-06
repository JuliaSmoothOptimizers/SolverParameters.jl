@testset "Parameters" verbose=true begin
    param = Parameter(1.5e-10, RealInterval(0.0,1.0;lower_open=true), "param")
    @test_throws r"should be in domain" set_value!(param, 0)
    set_value!(param, 2/3)
    @test value(param) == 2/3
end