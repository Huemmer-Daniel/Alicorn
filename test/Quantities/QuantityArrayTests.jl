module QuantityArrayTests

using Alicorn
using Test
using ..TestingTools

const ucat = UnitCatalogue()

function run()
    @testset "QuantityArray" begin
        # initialization
        @test canInstanciateQuantityArrayWithRealValues()
    end
end

function canInstanciateQuantityArrayWithRealValues()
    value = TestingTools.generateRandomReal(dim=(2,3))
    dimension = TestingTools.generateRandomDimension()
    internalUnits = TestingTools.generateRandomInternalUnits()
    return _testInstanciation(value, dimension, internalUnits)
end

function _testInstanciation(value::Array, dimension::Dimension, internalUnits::InternalUnits)
    pass = true
    quantityArray = QuantityArray(value, dimension, internalUnits)
    pass &= quantityArray.value == value
    pass &= quantityArray.dimension == dimension
    pass &= quantityArray.internalUnits == internalUnits
    return pass
end

end # module
