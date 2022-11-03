
@testset "Testing Real domains" begin
    @testset "RealIntervals{$T}" for T in TYPES
        @testset "Test max-min of types" begin
            min = typemin(T)
            max = typemax(T)
            d_closed = RealInterval(min, max)
            d_lopen = RealInterval(min, max, true, false)
            d_ropen = RealInterval(min, max, false, true)
            d_open = RealInterval(min, max, true, true)
            @testset "∈" begin
                @test (min ∈ d_closed) == true
                @test (min ∈ d_lopen) == false
                @test (min ∈ d_ropen) == true
                @test (min ∈ d_open || max ∈ d_open) == false
            end
        end
    end
end