module QuantityTests

using Alicorn
using Test
using ..TestingTools

const ucat = UnitCatalogue()
const intu = InternalUnits()

function run()
    @testset "Quantity" begin
        # instanciation
        @test canInstanciateQuantityWithRealValue()
        @test canInstanciateQuantityWithComplexValue()
        @test canInstanciateQuantityFromSimpleQuantity()
        @test canInstanciateQuantityFromAbstractUnit()
        @test InstanciationTriesToPreservesValueType()

        # arithmetics
        @test equality_implemented()
    end
end

## Instanciation

function canInstanciateQuantityWithRealValue()
    value = TestingTools.generateRandomReal()
    dimension = TestingTools.generateRandomDimension()
    internalUnits = TestingTools.generateRandomInternalUnits()
    return _testInstanciation(value, dimension, internalUnits)
end

function _testInstanciation(value::Number, dimension::Dimension, internalUnits::InternalUnits)
    pass = true
    quantity = Quantity(value, dimension, internalUnits)
    pass &= quantity.value == value
    pass &= quantity.dimension == dimension
    pass &= quantity.internalUnits == internalUnits
    return pass
end

function canInstanciateQuantityWithComplexValue()
    value = TestingTools.generateRandomComplex()
    dimension = TestingTools.generateRandomDimension()
    internalUnits = TestingTools.generateRandomInternalUnits()
    return _testInstanciation(value, dimension, internalUnits)
end

function canInstanciateQuantityFromSimpleQuantity()
    simpleQuantity = 7 * ucat.meter
    intU = InternalUnits(length = 2 * ucat.meter )
    returnedQuantity = Quantity(simpleQuantity, intU)
    correctQuantity = Quantity(3.5, Dimension(L=1), intU)
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

function InstanciationTriesToPreservesValueType()
    examples = _getExamplesFor_InstanciationTriesToPreservesValueType()

    correct = true
    for (value, unit, intu, correctType) in examples
        returnedType = typeof( Quantity(value, unit, intu).value )
        correct &= returnedType==correctType
    end
    return correct
end

function _getExamplesFor_InstanciationTriesToPreservesValueType()
    intu2 = InternalUnits(length = 2 * ucat.meter )
    intu3 = InternalUnits(length = 0.5 * ucat.meter )

    # format: n::Number, u::AbstractUnit, intu::InternalUnits, typeof(Quantity(n, u, intu).value)
    examples = [
        ( Int32(7), ucat.meter, intu, Int32 ),
        ( Int32(7), ucat.meter, intu2, Float64 ),
        ( Float32(3.5), ucat.meter, intu3, Float32 )
    ]
    return examples
end

## Arithmetics

function equality_implemented()
    examples = _getExamplesFor_equality()
    return TestingTools.testDyadicFunction(Base.:(==), examples)
end

function _getExamplesFor_equality()
    value = TestingTools.generateRandomReal()
    dimension = TestingTools.generateRandomDimension()
    internalUnits1 = TestingTools.generateRandomInternalUnits()
    internalUnits2 = TestingTools.generateRandomInternalUnits()

    q1 = Quantity(value, dimension, internalUnits1)
    q1Copy = deepcopy(q1)

    q2 = Quantity(value, 2*dimension, internalUnits1)
    q3 = Quantity(2*value, dimension, internalUnits1)
    q4 = Quantity(value, dimension, internalUnits2)

    # format: quantity1, quantity2, correct result for quantity1 == quantity2
    examples = [
        ( q1, q1Copy, true ),
        ( q1, q2, false ),
        ( q1, q3, false ),
        ( q1, q4, false )
    ]
    return examples
end

end # module
