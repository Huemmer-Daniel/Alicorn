module BaseUnitTests

using Alicorn
using Test

function run()
    @testset "BaseUnit" begin
        @test_skip canInstantiateBaseUnit()
    end
end

function canInstantiateBaseUnit()
    try
        BaseUnit(
            name="gram",
            symbol="g",
            prefactor=1e-3,
            exponents=Dict( [ ("kilogram", 1) ] )
        )
        return true
    catch
        return false
    end
end

end # module
