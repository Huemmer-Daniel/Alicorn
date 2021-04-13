module QuantityTests

using Alicorn
using Test
using ..TestingTools

const ucat = UnitCatalogue()

function run()
    @testset "Quantity" begin
        # initialization
        @test canInstanciateQuantityWithRealValue()
        @test canInstanciateQuantityWithComplexValue()
        @test canInstanciateQuantityWithRealValuedArray()
        @test canInstanciateQuantityWithComplexValuedArray()

        @test fieldsCorrectlyInitialized()

        @test canInstanciateQuantityWithSimpleQuantity()
    end
end

function canInstanciateQuantityWithRealValue()
    value = TestingTools.generateRandomReal()
    dimension = TestingTools.generateRandomDimension()
    internalUnits = TestingTools.generateRandomInternalUnits()
    return _testInstanciation(value, dimension, internalUnits)
end

function _testInstanciation(value, dimension, internalUnits)
    pass = false
    try
        Quantity(value, dimension, internalUnits)
        pass = true
    catch
    end
    return pass
end

function canInstanciateQuantityWithComplexValue()
    value = TestingTools.generateRandomComplex()
    dimension = TestingTools.generateRandomDimension()
    internalUnits = TestingTools.generateRandomInternalUnits()
    return _testInstanciation(value, dimension, internalUnits)
end

function canInstanciateQuantityWithRealValuedArray()
    value = TestingTools.generateRandomReal(dim=(2,3))
    dimension = TestingTools.generateRandomDimension()
    internalUnits = TestingTools.generateRandomInternalUnits()
    return _testInstanciation(value, dimension, internalUnits)
end

function canInstanciateQuantityWithComplexValuedArray()
    value = TestingTools.generateRandomComplex(dim=(2,3))
    dimension = TestingTools.generateRandomDimension()
    internalUnits = TestingTools.generateRandomInternalUnits()
    return _testInstanciation(value, dimension, internalUnits)
end

function fieldsCorrectlyInitialized()
    (randomQuantity, randomQuantityFields) = TestingTools.generateRandomQuantityWithFields()
    return _verifyHasCorrectFields(randomQuantity, randomQuantityFields)
end

function _verifyHasCorrectFields(quantity::Quantity, randomFields::Dict{String,Any})
    correctValue = (quantity.value == randomFields["value"])
    correctDimension = (quantity.dimension == randomFields["dimension"])
    correctInternalUnits = (quantity.internalUnits == randomFields["internalUnits"])
    correct = correctValue && correctDimension && correctInternalUnits
    return correct
end

function canInstanciateQuantityWithSimpleQuantity()
    pass = false
    simpleQuantity = 7 * Alicorn.meter
    intU = InternalUnits(length = 2 * Alicorn.meter )
    try
        Quantity(simpleQuantity, intU)
        pass = true
    catch
    end
    return pass
end

end # module
