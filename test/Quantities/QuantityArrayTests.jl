module QuantityArrayTests

using Alicorn
using Test
using ..TestingTools

const ucat = UnitCatalogue()
const intu = InternalUnits()

function run()
    @testset "QuantityArray" begin
        # Instanciation
        @test canInstanciateQuantityArrayWithRealValues()
        @test canInstanciateQuantityWithComplexValues()
        @test canInstanciateQuantityArrayFromSimpleQuantityArray()
        @test InstanciationTriesToPreservesValueType()

        # Arithmetics
        @test equality_implemented()
    end
end

# Instanciation

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

function InstanciationTriesToPreservesValueType()
    examples = _getExamplesFor_InstanciationTriesToPreservesValueType()

    correct = true
    for (value, unit, intu, correctType) in examples
        returnedType = typeof( QuantityArray(value, unit, intu).value )
        correct &= returnedType==correctType
    end
    return correct
end

function _getExamplesFor_InstanciationTriesToPreservesValueType()
    intu2 = InternalUnits(length = 2 * ucat.meter )
    intu3 = InternalUnits(length = 0.5 * ucat.meter )

    # format: n::Array, u::AbstractUnit, intu::InternalUnits, typeof(QuantityArray(n, u, intu).value)
    examples = [
        ( Array{Int32}([7, 14]), ucat.meter, intu, Array{Int32, 1} ),
        ( Array{Int32}([7, 14]), ucat.meter, intu2, Array{Float64, 1} ),
        ( Array{Float32}([3.5]), ucat.meter, intu3, Array{Float32, 1} )
    ]
    return examples
end

## Arithmetics

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
