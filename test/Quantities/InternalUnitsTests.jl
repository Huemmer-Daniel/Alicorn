module InternalUnitsTests

using Alicorn
using Test
using ..TestingTools

function run()
    @testset "InternalUnits" begin
        @test canInstanciateInternalUnitsWithoutArguments()
    end
end

function canInstanciateInternalUnitsWithoutArguments()
    # pass = false
    # try
        InternalUnits()
        pass = true
    # catch
    # end
    return pass
end

end # module
