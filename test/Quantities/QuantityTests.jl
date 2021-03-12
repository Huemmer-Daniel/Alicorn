module QuantityTests

using Alicorn
using Test
using ..TestingTools

const ucat = UnitCatalogue()

function run()
    @testset "Quantity" begin
        # initialization
        @test canInstanciateQuantityWithRealValue()
    end
end

function canInstanciateQuantityWithRealValue()
    value = 9
    dimension = Dimension(L=1)
    internalUnits = InternalUnits()
    pass = false
    try
        Quantity(value, dimension, internalUnits)
        pass = true
    catch
    end
    return pass
end

end # module
