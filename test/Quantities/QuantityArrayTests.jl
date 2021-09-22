module QuantityArrayTests

using Alicorn
using Test
using ..TestingTools

const ucat = UnitCatalogue()

function run()
    @testset "QuantityArray" begin
        # initialization
        @test canInstanciateQuantityArrayWithRealValues()
        @test canInstanciateQuantityWithComplexValues()
        @test canInstanciateQuantityArrayFromSimpleQuantityArray()

        # arithmetics
        @test equality_implemented()
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

function canInstanciateQuantityWithComplexValues()
    value = TestingTools.generateRandomComplex(dim=(2,3))
    dimension = TestingTools.generateRandomDimension()
    internalUnits = TestingTools.generateRandomInternalUnits()
    return _testInstanciation(value, dimension, internalUnits)
end

function canInstanciateQuantityArrayFromSimpleQuantityArray()
    sqArray = [7 6; 7 1.2] * ucat.meter
    intU = InternalUnits(length = 2 * ucat.meter )
    returnedQArray = QuantityArray(sqArray, intU)
    correctQArray = QuantityArray([3.5 3; 3.5 0.6], Dimension(L=1), intU)
    correct = (returnedQArray == correctQArray)
    return correct
end

function equality_implemented()
    examples = _getExamplesFor_equality()
    return TestingTools.testDyadicFunction(Base.:(==), examples)
end

function _getExamplesFor_equality()
    value = TestingTools.generateRandomReal(dim=(2,3))
    dimension = TestingTools.generateRandomDimension()
    internalUnits1 = TestingTools.generateRandomInternalUnits()
    internalUnits2 = TestingTools.generateRandomInternalUnits()

    q1 = QuantityArray(value, dimension, internalUnits1)
    q1Copy = deepcopy(q1)

    q2 = QuantityArray(value, 2*dimension, internalUnits1)
    q3 = QuantityArray(2*value, dimension, internalUnits1)
    q4 = QuantityArray(value, dimension, internalUnits2)

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
