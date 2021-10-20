module QuantityArrayTests

using Alicorn
using Test
using ..TestingTools

const ucat = UnitCatalogue()
const intu = InternalUnits()

function run()
    @testset "QuantityArray" begin
        # Constructors
        @test canConstructFromArrayAndDimensionAndIntU()
        @test canConstructFromArrayAndDimension()
        @test canConstructFromArrayAndIntU()
        @test canConstructFromArray()
        @test canConstructFromQuantityArray()
        @test canConstructFromQuantity()
        @test canConstructFromSimpleQuantityArrayAndIntU()
        @test canConstructFromSimpleQuantityArray()
        @test canConstructFromArrayAndAbstractUnitAndIntU()
        @test canConstructFromArrayAndAbstractUnit()
        @test canConstructFromArrayAndDimensionAndIntU_TypeSpecified()
        @test canConstructFromArrayAndDimension_TypeSpecified()
        @test canConstructFromArrayAndIntU_TypeSpecified()
        @test canConstructFromArray_TypeSpecified()
        @test canConstructFromQuantityArray_TypeSpecified()
        @test canConstructFromQuantity_TypeSpecified()
        @test InstanciationTriesToPreservesValueType()

        # Type conversion
        @test canConvertTypeParameter()

        # Arithmetics
        @test equality_implemented()
    end
end

# Constructors

function canConstructFromArrayAndDimensionAndIntU()
    examples = _getExamplesFor_canConstructFromArrayAndDimensionAndIntU()
    return _checkConstructorExamples(examples)
end

function _getExamplesFor_canConstructFromArrayAndDimensionAndIntU()
    realValue = TestingTools.generateRandomReal(dim=(2,3))
    dim1 = TestingTools.generateRandomDimension()
    q1 = QuantityArray(realValue, dim1, intu)
    correctFields1 = Dict([
        ("value", realValue),
        ("dimension", dim1),
        ("internal units", intu)
    ])

    complexValue = TestingTools.generateRandomComplex(dim=(2,3))
    dim2 = TestingTools.generateRandomDimension()
    q2 = QuantityArray(complexValue, dim2, intu)
    correctFields2 = Dict([
        ("value", complexValue),
        ("dimension", dim2),
        ("internal units", intu)
    ])

    examples = [
        (q1, correctFields1),
        (q2, correctFields2)
    ]
    return examples
end

function _checkConstructorExamples(examples::Array)
    correct = true
    for (qArray, correctFields) in examples
        correct &= _verifyHasCorrectFields(qArray, correctFields)
    end
    return correct
end

function _verifyHasCorrectFields(qArray::QuantityArray, correctFields::Dict{String,Any})
    correctValue = (qArray.value == correctFields["value"])
    correctDimension = (qArray.dimension == correctFields["dimension"])
    correctIntU = (qArray.internalUnits == correctFields["internal units"])
    correct = correctValue && correctDimension && correctIntU
    return correct
end

function canConstructFromArrayAndDimension()
    examples = _getExamplesFor_canConstructFromArrayAndDimension()
    return _checkConstructorExamples(examples)
end

function _getExamplesFor_canConstructFromArrayAndDimension()
    realValue = TestingTools.generateRandomReal(dim=(2,3))
    dim1 = TestingTools.generateRandomDimension()
    q1 = QuantityArray(realValue, dim1)
    correctFields1 = Dict([
        ("value", realValue),
        ("dimension", dim1),
        ("internal units", InternalUnits())
    ])

    complexValue = TestingTools.generateRandomComplex(dim=(2,3))
    dim2 = TestingTools.generateRandomDimension()
    q2 = QuantityArray(complexValue, dim2)
    correctFields2 = Dict([
        ("value", complexValue),
        ("dimension", dim2),
        ("internal units", InternalUnits())
    ])

    examples = [
        (q1, correctFields1),
        (q2, correctFields2)
    ]
    return examples
end

function canConstructFromArrayAndIntU()
    examples = _getExamplesFor_canConstructFromArrayAndIntU()
    return _checkConstructorExamples(examples)
end

function _getExamplesFor_canConstructFromArrayAndIntU()
    realValue = TestingTools.generateRandomReal(dim=(2,3))
    q1 = QuantityArray(realValue, intu)
    correctFields1 = Dict([
        ("value", realValue),
        ("dimension", Dimension()),
        ("internal units", intu)
    ])

    complexValue = TestingTools.generateRandomComplex(dim=(2,3))
    q2 = QuantityArray(complexValue, intu)
    correctFields2 = Dict([
        ("value", complexValue),
        ("dimension", Dimension()),
        ("internal units", intu)
    ])

    examples = [
        (q1, correctFields1),
        (q2, correctFields2)
    ]
    return examples
end

function canConstructFromArray()
    examples = _getExamplesFor_canConstructFromArray()
    return _checkConstructorExamples(examples)
end

function _getExamplesFor_canConstructFromArray()
    realValue = TestingTools.generateRandomReal(dim=(2,3))
    q1 = QuantityArray(realValue)
    correctFields1 = Dict([
        ("value", realValue),
        ("dimension", Dimension()),
        ("internal units", InternalUnits())
    ])

    complexValue = TestingTools.generateRandomComplex(dim=(2,3))
    q2 = QuantityArray(complexValue)
    correctFields2 = Dict([
        ("value", complexValue),
        ("dimension", Dimension()),
        ("internal units", InternalUnits())
    ])

    examples = [
        (q1, correctFields1),
        (q2, correctFields2)
    ]
    return examples
end

function canConstructFromQuantityArray()
    qArray1 = TestingTools.generateRandomQuantityArray()
    qArray2 = QuantityArray(qArray1)
    return qArray1==qArray2
end

function canConstructFromQuantity()
    examples = _getExamplesFor_canConstructFromQuantity()
    return _checkConstructorExamples(examples)
end

function _getExamplesFor_canConstructFromQuantity()
    quantity = TestingTools.generateRandomQuantity()
    qArray = QuantityArray(quantity)
    correctFields = Dict([
        ("value", [quantity.value]),
        ("dimension", quantity.dimension),
        ("internal units", quantity.internalUnits)
    ])

    examples = [
        (qArray, correctFields)
    ]
    return examples
end

function canConstructFromSimpleQuantityArrayAndIntU()
    examples = _getExamplesFor_canConstructFromSimpleQuantityArrayAndIntU()
    return _checkConstructorExamples(examples)
end

function _getExamplesFor_canConstructFromSimpleQuantityArrayAndIntU()
    sqArray = TestingTools.generateRandomSimpleQuantityArray()
    sqArrayBaseSI = inBasicSIUnits(sqArray)
    qArray = QuantityArray(sqArray, intu)
    correctFields = Dict([
        ("value", sqArrayBaseSI.value),
        ("dimension", dimensionOf(sqArrayBaseSI)),
        ("internal units", intu)
    ])

    examples = [
        (qArray, correctFields)
    ]
    return examples
end

function canConstructFromSimpleQuantityArray()
    examples = _getExamplesFor_canConstructFromSimpleQuantityArray()
    return _checkConstructorExamples(examples)
end

function _getExamplesFor_canConstructFromSimpleQuantityArray()
    sqArray = TestingTools.generateRandomSimpleQuantityArray()
    sqArrayBaseSI = inBasicSIUnits(sqArray)
    qArray = QuantityArray(sqArray)
    correctFields = Dict([
        ("value", sqArrayBaseSI.value),
        ("dimension", dimensionOf(sqArrayBaseSI)),
        ("internal units", InternalUnits())
    ])

    examples = [
        (qArray, correctFields)
    ]
    return examples
end

function canConstructFromArrayAndAbstractUnitAndIntU()
    examples = _getExamplesFor_canConstructFromArrayAndAbstractUnitAndIntU()
    return _checkConstructorExamples(examples)
end

function _getExamplesFor_canConstructFromArrayAndAbstractUnitAndIntU()
    realValue = TestingTools.generateRandomReal(dim=(2,3))
    baseUnit = TestingTools.generateRandomBaseUnit()
    value1 = inBasicSIUnits(realValue*baseUnit).value
    dim1 = dimensionOf(baseUnit)
    q1 = QuantityArray(realValue, baseUnit, intu)
    correctFields1 = Dict([
        ("value", value1),
        ("dimension", dim1),
        ("internal units", intu)
    ])

    complexValue = TestingTools.generateRandomComplex(dim=(2,3))
    unitFactor = TestingTools.generateRandomUnitFactor()
    value2 = inBasicSIUnits(complexValue*unitFactor).value
    dim2 = dimensionOf(unitFactor)
    q2 = QuantityArray(complexValue, unitFactor, intu)
    correctFields2 = Dict([
        ("value", value2),
        ("dimension", dim2),
        ("internal units", intu)
    ])

    complexValue = TestingTools.generateRandomComplex(dim=(2,3))
    unit = TestingTools.generateRandomUnit()
    value3 = inBasicSIUnits(complexValue*unit).value
    dim3 = dimensionOf(unit)
    q3 = QuantityArray(complexValue, unit, intu)
    correctFields3 = Dict([
        ("value", value3),
        ("dimension", dim3),
        ("internal units", intu)
    ])

    examples = [
        (q1, correctFields1),
        (q2, correctFields2),
        (q3, correctFields3)
    ]
    return examples
end

function canConstructFromArrayAndAbstractUnit()
    examples = _getExamplesFor_canConstructFromArrayAndAbstractUnit()
    return _checkConstructorExamples(examples)
end

function _getExamplesFor_canConstructFromArrayAndAbstractUnit()
    realValue = TestingTools.generateRandomReal(dim=(2,3))
    baseUnit = TestingTools.generateRandomBaseUnit()
    value1 = inBasicSIUnits(realValue*baseUnit).value
    dim1 = dimensionOf(baseUnit)
    q1 = QuantityArray(realValue, baseUnit)
    correctFields1 = Dict([
        ("value", value1),
        ("dimension", dim1),
        ("internal units", InternalUnits())
    ])

    complexValue = TestingTools.generateRandomComplex(dim=(2,3))
    unitFactor = TestingTools.generateRandomUnitFactor()
    value2 = inBasicSIUnits(complexValue*unitFactor).value
    dim2 = dimensionOf(unitFactor)
    q2 = QuantityArray(complexValue, unitFactor)
    correctFields2 = Dict([
        ("value", value2),
        ("dimension", dim2),
        ("internal units", InternalUnits())
    ])

    complexValue = TestingTools.generateRandomComplex(dim=(2,3))
    unit = TestingTools.generateRandomUnit()
    value3 = inBasicSIUnits(complexValue*unit).value
    dim3 = dimensionOf(unit)
    q3 = QuantityArray(complexValue, unit)
    correctFields3 = Dict([
        ("value", value3),
        ("dimension", dim3),
        ("internal units", InternalUnits())
    ])

    examples = [
        (q1, correctFields1),
        (q2, correctFields2),
        (q3, correctFields3)
    ]
    return examples
end

function _checkConstructorExamplesIncludingType(examples::Array)
    correct = true
    for (qArray, correctFields) in examples
        correct &= _verifyHasCorrectFieldsAndType(qArray, correctFields)
    end
    return correct
end

function _verifyHasCorrectFieldsAndType(qArray::QuantityArray, correctFields::Dict{String,Any})
    correctValue = (qArray.value == correctFields["value"])
    correctDimension = (qArray.dimension == correctFields["dimension"])
    correctIntU = (qArray.internalUnits == correctFields["internal units"])
    correctType = isa(qArray.value, correctFields["value type"])
    correct = correctValue && correctDimension && correctIntU && correctType
    return correct
end

function canConstructFromArrayAndDimensionAndIntU_TypeSpecified()
    examples = _getExamplesFor_canConstructFromArrayAndDimensionAndIntU_TypeSpecified()
    return _checkConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructFromArrayAndDimensionAndIntU_TypeSpecified()
    realValue = [-9.8, 7.6]
    dim1 = TestingTools.generateRandomDimension()
    qArray1 = QuantityArray{Float16}(realValue, dim1, intu)
    correctFields1 = Dict([
        ("value", Array{Float16}(realValue)),
        ("dimension", dim1),
        ("internal units", intu),
        ("value type", Array{Float16})
    ])

    complexValue = [2.0 - 4im  5.0]
    dim2 = TestingTools.generateRandomDimension()
    qArray2 = QuantityArray{Complex{Int32}}(complexValue, dim2, intu)
    correctFields2 = Dict([
        ("value", Array{Complex{Int32}}(complexValue)),
        ("dimension", dim2),
        ("internal units", intu),
        ("value type", Array{Complex{Int32}})
    ])

    examples = [
        (qArray1, correctFields1),
        (qArray2, correctFields2)
    ]
    return examples
end

function canConstructFromArrayAndDimension_TypeSpecified()
    examples = _getExamplesFor_canConstructFromArrayAndDimension_TypeSpecified()
    return _checkConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructFromArrayAndDimension_TypeSpecified()
    realValue = [-9.8, 7.6]
    dim1 = TestingTools.generateRandomDimension()
    qArray1 = QuantityArray{Float16}(realValue, dim1)
    correctFields1 = Dict([
        ("value", Array{Float16}(realValue)),
        ("dimension", dim1),
        ("internal units", InternalUnits()),
        ("value type", Array{Float16})
    ])

    complexValue = [2.0 - 4im  5.0]
    dim2 = TestingTools.generateRandomDimension()
    qArray2 = QuantityArray{Complex{Int32}}(complexValue, dim2)
    correctFields2 = Dict([
        ("value", Array{Complex{Int32}}(complexValue)),
        ("dimension", dim2),
        ("internal units", InternalUnits()),
        ("value type", Array{Complex{Int32}})
    ])

    examples = [
        (qArray1, correctFields1),
        (qArray2, correctFields2)
    ]
    return examples
end

function canConstructFromArrayAndIntU_TypeSpecified()
    examples = _getExamplesFor_canConstructFromArrayAndIntU_TypeSpecified()
    return _checkConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructFromArrayAndIntU_TypeSpecified()
    realValue = [-9.8, 7.6]
    qArray1 = QuantityArray{Float16}(realValue, intu)
    correctFields1 = Dict([
        ("value", Array{Float16}(realValue)),
        ("dimension", Dimension()),
        ("internal units", intu),
        ("value type", Array{Float16})
    ])

    complexValue = [2.0 - 4im  5.0]
    qArray2 = QuantityArray{Complex{Int32}}(complexValue, intu)
    correctFields2 = Dict([
        ("value", Array{Complex{Int32}}(complexValue)),
        ("dimension", Dimension()),
        ("internal units", intu),
        ("value type", Array{Complex{Int32}})
    ])

    examples = [
        (qArray1, correctFields1),
        (qArray2, correctFields2)
    ]
    return examples
end

function canConstructFromArray_TypeSpecified()
    examples = _getExamplesFor_canConstructFromArray_TypeSpecified()
    return _checkConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructFromArray_TypeSpecified()
    realValue = [-9.8, 7.6]
    qArray1 = QuantityArray{Float16}(realValue)
    correctFields1 = Dict([
        ("value", Array{Float16}(realValue)),
        ("dimension", Dimension()),
        ("internal units", InternalUnits()),
        ("value type", Array{Float16})
    ])

    complexValue = [2.0 - 4im  5.0]
    qArray2 = QuantityArray{Complex{Int32}}(complexValue)
    correctFields2 = Dict([
        ("value", Array{Complex{Int32}}(complexValue)),
        ("dimension", Dimension()),
        ("internal units", InternalUnits()),
        ("value type", Array{Complex{Int32}})
    ])

    examples = [
        (qArray1, correctFields1),
        (qArray2, correctFields2)
    ]
    return examples
end

function canConstructFromQuantityArray_TypeSpecified()
    examples = _getExamplesFor_canConstructFromQuantityArray_TypeSpecified()
    return _checkConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructFromQuantityArray_TypeSpecified()
    value = Array{Float64}([6.7, 9.3])
    dim = TestingTools.generateRandomDimension()
    qArray_64 = QuantityArray(value, dim, intu)
    qArray_32 = QuantityArray{Float32}( qArray_64 )

    correctFields = Dict([
        ("value", Array{Float32}(value)),
        ("dimension", dim),
        ("internal units", intu),
        ("value type", Array{Float32})
    ])

    examples = [
        (qArray_32, correctFields)
    ]
    return examples
end

function canConstructFromQuantity_TypeSpecified()
    examples = _getExamplesFor_canConstructFromQuantity_TypeSpecified()
    return _checkConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructFromQuantity_TypeSpecified()
    value = Float64(6.7)
    dim = TestingTools.generateRandomDimension()
    quantity_64 = Quantity(value, dim, intu)
    qArray_32 = QuantityArray{Float32}( quantity_64 )

    correctFields = Dict([
        ("value", Array{Float32}([value])),
        ("dimension", dim),
        ("internal units", intu),
        ("value type", Array{Float32})
    ])

    examples = [
        (qArray_32, correctFields)
    ]
    return examples
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

    # format: a::Array, u::AbstractUnit, intu::InternalUnits, typeof(QuantityArray(a, u, intu).value)
    examples = [
        ( Array{Int32}([7, 6]), ucat.meter, intu, Vector{Int32} ),
        ( Array{Int32}([7 5]), ucat.meter, intu2, Matrix{Float64} ),
        ( Array{Float32}([3.5; 4.6]), ucat.meter, intu3, Vector{Float32} )
    ]
    return examples
end


## ## Type conversion

function canConvertTypeParameter()
    examples = _getExamplesFor_canConvertTypeParameter()
    return TestingTools.testDyadicFunction(Base.convert, examples)
end

function _getExamplesFor_canConvertTypeParameter()
    dim = Dimension(L=-1)
    examples = [
        ( QuantityArray{Float32}, QuantityArray{Float64}([7.1], dim, intu), QuantityArray(Array{Float32}([7.1]), dim, intu) ),
        ( QuantityArray{UInt16}, QuantityArray{Float64}([16], dim, intu), QuantityArray(Array{UInt16}([16]), dim, intu) ),
        ( QuantityArray{Float16}, QuantityArray{Int64}([16], dim, intu), QuantityArray(Array{Float16}([16]), dim, intu) )
    ]
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
