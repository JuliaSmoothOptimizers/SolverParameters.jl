@testset "testing abstract domains" verbose=true begin
    @testset "Testing functions taking AbstractDomain type $T" for T in (Int, Float32, Float64)
        struct MockDomain{T} <: AbstractDomain{T}
            lower::T
            upper::T
        end
        mock_domain = MockDomain(T(0), T(1))
        @test  (T(0) ∈ mock_domain) == false
        @test (T(0) in mock_domain) == false
        @test_throws DomainError lower(mock_domain)
        @test_throws DomainError upper(mock_domain)
    end
end
