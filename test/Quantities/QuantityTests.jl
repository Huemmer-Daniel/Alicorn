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

        @test_skip canInstanciateQuantityFromSimpleQuantity()
        @test_skip canInstanciateQuantityFromAbstractUnit()

        # arithmetics
        @test equality_implemented()
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

function canInstanciateQuantityFromSimpleQuantity()
    simpleQuantity = 7 * Alicorn.meter
    intU = InternalUnits(length = 2 * Alicorn.meter )
    returnedQuantity = Quantity(simpleQuantity, intU)
    correctQuantity = Quantity(3.5, Dimension(L=2), intU)
    correct = (returnedQuantity == correctQuantity)
    return correct
end

function canInstanciateQuantityFromAbstractUnit()
    # TODO: verify result
    pass = false
    ucat = UnitCatalogue()
    mockAbstractUnit = MockAbstractUnit(ucat.nano * ucat.meter)
    intU = InternalUnits()
    try
        Quantity(mockAbstractUnit, intU)
        pass = true
    catch
    end
    return pass
end

struct MockAbstractUnit <: AbstractUnit
    unitFactor::UnitFactor
end

function Alicorn.Units.convertToUnit(mockAbstractUnit::MockAbstractUnit)
    unitFactor = mockAbstractUnit.unitFactor
    unit = Unit(unitFactor)
    return unit
end

function equality_implemented()
    examples = _getExamplesFor_equality()
    return TestingTools.testDyadicFunction(Base.:(==), examples)
end

function _getExamplesFor_equality()
    value = TestingTools.generateRandomReal()
    dimension = TestingTools.generateRandomDimension()
    internalUnits1 = TestingTools.generateRandomInternalUnits()
    internalUnits2 = TestingTools.generateRandomInternalUnits()

    randomQuantity1 = Quantity(value, dimension, internalUnits1)
    randomQuantity1Copy = deepcopy(randomQuantity1)

    randomQuantity2 = Quantity(value, 2*dimension, internalUnits1)
    randomQuantity3 = Quantity(2*value, dimension, internalUnits1)
    randomQuantity4 = Quantity(value, dimension, internalUnits2)

    # format: quantity1, quantity2, correct result for quantity1 == quantity2
    examples = [
        ( randomQuantity1, randomQuantity1Copy, true ),
        # ( randomQuantity1, randomQuantity2, false ),
        # ( randomQuantity1, randomQuantity3, false ),
        # ( randomQuantity1, randomQuantity4, false )
    ]
    return examples
end

end # module
