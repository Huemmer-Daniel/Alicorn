module QuantityTests

using Alicorn
using Test
using ..TestingTools

const ucat = UnitCatalogue()
const intu = InternalUnits()

function run()
    @testset "Quantity" begin
        # Constructors
        @test canConstructFromNumberAndDimensionAndIntU()
        @test canConstructFromNumberAndDimension()
        @test canConstructFromNumberAndIntU()
        @test canConstructFromNumber()
        @test canConstructFromQuantity()
        @test canConstructFromSimpleQuantityAndIntU()
        @test canConstructFromSimpleQuantity()
        @test canConstructFromNumberAndAbstractUnitAndIntU()
        @test canConstructFromNumberAndAbstractUnit()
        @test canConstructFromAbstractUnitAndIntU()
        @test canConstructFromAbstractUnit()
        @test canConstructFromQuantity_TypeSpecified()
        @test canConstructFromNumberAndDimensionAndIntU_TypeSpecified()
        @test canConstructFromNumberAndDimension_TypeSpecified()
        @test canConstructFromNumberAndIntU_TypeSpecified()
        @test canConstructFromNumber_TypeSpecified()
        @test InstanciationTriesToPreservesValueType()

        # Type conversion
        @test canConvertTypeParameter()

        # Arithmetics
        @test equality_implemented()
    end
end

## Constructors

function canConstructFromNumberAndDimensionAndIntU()
    examples = _getExamplesFor_canConstructFromNumberAndDimensionAndIntU()
    return _checkConstructorExamples(examples)
end

function _getExamplesFor_canConstructFromNumberAndDimensionAndIntU()
    realValue = TestingTools.generateRandomReal()
    dim1 = TestingTools.generateRandomDimension()
    q1 = Quantity(realValue, dim1, intu)
    correctFields1 = Dict([
        ("value", realValue),
        ("dimension", dim1),
        ("internal units", intu)
    ])

    complexValue = TestingTools.generateRandomComplex()
    dim2 = TestingTools.generateRandomDimension()
    q2 = Quantity(complexValue, dim2, intu)
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
    for (quantity, correctFields) in examples
        correct &= _verifyHasCorrectFields(quantity, correctFields)
    end
    return correct
end

function _verifyHasCorrectFields(quantity::Quantity, correctFields::Dict{String,Any})
    correctValue = (quantity.value == correctFields["value"])
    correctDimension = (quantity.dimension == correctFields["dimension"])
    correctIntU = (quantity.internalUnits == correctFields["internal units"])
    correct = correctValue && correctDimension && correctIntU
    return correct
end

function canConstructFromNumberAndDimension()
    examples = _getExamplesFor_canConstructFromNumberAndDimension()
    return _checkConstructorExamples(examples)
end

function _getExamplesFor_canConstructFromNumberAndDimension()
    realValue = TestingTools.generateRandomReal()
    dim1 = TestingTools.generateRandomDimension()
    q1 = Quantity(realValue, dim1)
    correctFields1 = Dict([
        ("value", realValue),
        ("dimension", dim1),
        ("internal units", InternalUnits())
    ])

    complexValue = TestingTools.generateRandomComplex()
    dim2 = TestingTools.generateRandomDimension()
    q2 = Quantity(complexValue, dim2)
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

function canConstructFromNumberAndIntU()
    examples = _getExamplesFor_canConstructFromNumberAndIntU()
    return _checkConstructorExamples(examples)
end

function _getExamplesFor_canConstructFromNumberAndIntU()
    realValue = TestingTools.generateRandomReal()
    q1 = Quantity(realValue, intu)
    correctFields1 = Dict([
        ("value", realValue),
        ("dimension", Dimension()),
        ("internal units", intu)
    ])

    complexValue = TestingTools.generateRandomComplex()
    q2 = Quantity(complexValue, intu)
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

function canConstructFromNumber()
    examples = _getExamplesFor_canConstructFromNumber()
    return _checkConstructorExamples(examples)
end

function _getExamplesFor_canConstructFromNumber()
    realValue = TestingTools.generateRandomReal()
    q1 = Quantity(realValue)
    correctFields1 = Dict([
        ("value", realValue),
        ("dimension", Dimension()),
        ("internal units", InternalUnits())
    ])

    complexValue = TestingTools.generateRandomComplex()
    q2 = Quantity(complexValue)
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

function canConstructFromSimpleQuantityAndIntU()
    examples = _getExamplesFor_canConstructFromSimpleQuantityAndIntU()
    return _checkConstructorExamples(examples)
end

function _getExamplesFor_canConstructFromSimpleQuantityAndIntU()
    sQuantity = TestingTools.generateRandomSimpleQuantity()
    sQuantityBaseSI = inBasicSIUnits(sQuantity)
    q1 = Quantity(sQuantity, intu)
    correctFields1 = Dict([
        ("value", sQuantityBaseSI.value),
        ("dimension", dimensionOf(sQuantityBaseSI)),
        ("internal units", intu)
    ])

    examples = [
        (q1, correctFields1)
    ]
    return examples
end

function canConstructFromSimpleQuantity()
    examples = _getExamplesFor_canConstructFromSimpleQuantity()
    return _checkConstructorExamples(examples)
end

function _getExamplesFor_canConstructFromSimpleQuantity()
    sQuantity = TestingTools.generateRandomSimpleQuantity()
    sQuantityBaseSI = inBasicSIUnits(sQuantity)
    q1 = Quantity(sQuantity)
    correctFields1 = Dict([
        ("value", sQuantityBaseSI.value),
        ("dimension", dimensionOf(sQuantityBaseSI)),
        ("internal units", InternalUnits())
    ])

    examples = [
        (q1, correctFields1)
    ]
    return examples
end

function canConstructFromNumberAndAbstractUnitAndIntU()
    examples = _getExamplesFor_canConstructFromNumberAndAbstractUnitAndIntU()
    return _checkConstructorExamples(examples)
end

function _getExamplesFor_canConstructFromNumberAndAbstractUnitAndIntU()
    realValue = TestingTools.generateRandomReal()
    baseUnit = TestingTools.generateRandomBaseUnit()
    value1 = inBasicSIUnits(realValue*baseUnit).value
    dim1 = dimensionOf(baseUnit)
    q1 = Quantity(realValue, baseUnit, intu)
    correctFields1 = Dict([
        ("value", value1),
        ("dimension", dim1),
        ("internal units", intu)
    ])

    complexValue = TestingTools.generateRandomComplex()
    unitFactor = TestingTools.generateRandomUnitFactor()
    value2 = inBasicSIUnits(complexValue*unitFactor).value
    dim2 = dimensionOf(unitFactor)
    q2 = Quantity(complexValue, unitFactor, intu)
    correctFields2 = Dict([
        ("value", value2),
        ("dimension", dim2),
        ("internal units", intu)
    ])

    complexValue = TestingTools.generateRandomComplex()
    unit = TestingTools.generateRandomUnit()
    value3 = inBasicSIUnits(complexValue*unit).value
    dim3 = dimensionOf(unit)
    q3 = Quantity(complexValue, unit, intu)
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

function canConstructFromNumberAndAbstractUnit()
    examples = _getExamplesFor_canConstructFromNumberAndAbstractUnit()
    return _checkConstructorExamples(examples)
end

function _getExamplesFor_canConstructFromNumberAndAbstractUnit()
    realValue = TestingTools.generateRandomReal()
    baseUnit = TestingTools.generateRandomBaseUnit()
    value1 = inBasicSIUnits(realValue*baseUnit).value
    dim1 = dimensionOf(baseUnit)
    q1 = Quantity(realValue, baseUnit)
    correctFields1 = Dict([
        ("value", value1),
        ("dimension", dim1),
        ("internal units", InternalUnits())
    ])

    complexValue = TestingTools.generateRandomComplex()
    unitFactor = TestingTools.generateRandomUnitFactor()
    value2 = inBasicSIUnits(complexValue*unitFactor).value
    dim2 = dimensionOf(unitFactor)
    q2 = Quantity(complexValue, unitFactor)
    correctFields2 = Dict([
        ("value", value2),
        ("dimension", dim2),
        ("internal units", InternalUnits())
    ])

    complexValue = TestingTools.generateRandomComplex()
    unit = TestingTools.generateRandomUnit()
    value3 = inBasicSIUnits(complexValue*unit).value
    dim3 = dimensionOf(unit)
    q3 = Quantity(complexValue, unit)
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

function canConstructFromAbstractUnitAndIntU()
    examples = _getExamplesFor_canConstructFromAbstractUnitAndIntU()
    return _checkConstructorExamples(examples)
end

function _getExamplesFor_canConstructFromAbstractUnitAndIntU()
    baseUnit = TestingTools.generateRandomBaseUnit()
    value1 = inBasicSIUnits(1*baseUnit).value
    dim1 = dimensionOf(baseUnit)
    q1 = Quantity(baseUnit, intu)
    correctFields1 = Dict([
        ("value", value1),
        ("dimension", dim1),
        ("internal units", intu)
    ])

    unitFactor = TestingTools.generateRandomUnitFactor()
    value2 = inBasicSIUnits(1*unitFactor).value
    dim2 = dimensionOf(unitFactor)
    q2 = Quantity(unitFactor, intu)
    correctFields2 = Dict([
        ("value", value2),
        ("dimension", dim2),
        ("internal units", intu)
    ])

    unit = TestingTools.generateRandomUnit()
    value3 = inBasicSIUnits(1*unit).value
    dim3 = dimensionOf(unit)
    q3 = Quantity(unit, intu)
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

function canConstructFromAbstractUnit()
    examples = _getExamplesFor_canConstructFromAbstractUnit()
    return _checkConstructorExamples(examples)
end

function _getExamplesFor_canConstructFromAbstractUnit()
    baseUnit = TestingTools.generateRandomBaseUnit()
    value1 = inBasicSIUnits(1*baseUnit).value
    dim1 = dimensionOf(baseUnit)
    q1 = Quantity(baseUnit)
    correctFields1 = Dict([
        ("value", value1),
        ("dimension", dim1),
        ("internal units", InternalUnits())
    ])

    unitFactor = TestingTools.generateRandomUnitFactor()
    value2 = inBasicSIUnits(1*unitFactor).value
    dim2 = dimensionOf(unitFactor)
    q2 = Quantity(unitFactor)
    correctFields2 = Dict([
        ("value", value2),
        ("dimension", dim2),
        ("internal units", InternalUnits())
    ])

    unit = TestingTools.generateRandomUnit()
    value3 = inBasicSIUnits(1*unit).value
    dim3 = dimensionOf(unit)
    q3 = Quantity(unit)
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

function canConstructFromQuantity()
    q1 = TestingTools.generateRandomQuantity()
    q2 = Quantity(q1)
    return q1==q2
end

function canConstructFromQuantity_TypeSpecified()
    examples = _getExamplesFor_canConstructFromQuantity_TypeSpecified()
    return _checkConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructFromQuantity_TypeSpecified()
    value = 6.7
    dim = TestingTools.generateRandomDimension()
    q_64 = Quantity(Float64(value), dim, intu)
    q_32 = Quantity{Float32}( q_64 )

    correctFields = Dict([
        ("value", Float32(value)),
        ("dimension", dim),
        ("internal units", intu),
        ("value type", Float32)
    ])

    examples = [
        (q_32, correctFields)
    ]
    return examples
end

function _checkConstructorExamplesIncludingType(examples::Array)
    correct = true
    for (quantity, correctFields) in examples
        correct &= _verifyHasCorrectFieldsAndType(quantity, correctFields)
    end
    return correct
end

function _verifyHasCorrectFieldsAndType(quantity::Quantity, correctFields::Dict{String,Any})
    correctValue = (quantity.value == correctFields["value"])
    correctDimension = (quantity.dimension == correctFields["dimension"])
    correctIntU = (quantity.internalUnits == correctFields["internal units"])
    correctType = isa(quantity.value, correctFields["value type"])
    correct = correctValue && correctDimension && correctIntU && correctType
    return correct
end

function canConstructFromNumberAndDimensionAndIntU_TypeSpecified()
    examples = _getExamplesFor_canConstructFromNumberAndDimensionAndIntU_TypeSpecified()
    return _checkConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructFromNumberAndDimensionAndIntU_TypeSpecified()
    realValue = -9.8
    dim1 = TestingTools.generateRandomDimension()
    q1 = Quantity{Float16}(realValue, dim1, intu)
    correctFields1 = Dict([
        ("value", Float16(realValue)),
        ("dimension", dim1),
        ("internal units", intu),
        ("value type", Float16)
    ])

    complexValue = 2.0 - 4im
    dim2 = TestingTools.generateRandomDimension()
    q2 = Quantity{Complex{Int32}}(complexValue, dim2, intu)
    correctFields2 = Dict([
        ("value", Complex{Int32}(complexValue)),
        ("dimension", dim2),
        ("internal units", intu),
        ("value type", Complex{Int32})
    ])

    examples = [
        (q1, correctFields1),
        (q2, correctFields2)
    ]
    return examples
end

function canConstructFromNumberAndDimension_TypeSpecified()
    examples = _getExamplesFor_canConstructFromNumberAndDimension_TypeSpecified()
    return _checkConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructFromNumberAndDimension_TypeSpecified()
    realValue = -9.8
    dim1 = TestingTools.generateRandomDimension()
    q1 = Quantity{Float16}(realValue, dim1)
    correctFields1 = Dict([
        ("value", Float16(realValue)),
        ("dimension", dim1),
        ("internal units", InternalUnits()),
        ("value type", Float16)
    ])

    complexValue = 2.0 - 4im
    dim2 = TestingTools.generateRandomDimension()
    q2 = Quantity{Complex{Int32}}(complexValue, dim2)
    correctFields2 = Dict([
        ("value", Complex{Int32}(complexValue)),
        ("dimension", dim2),
        ("internal units", InternalUnits()),
        ("value type", Complex{Int32})
    ])

    examples = [
        (q1, correctFields1),
        (q2, correctFields2)
    ]
    return examples
end

function canConstructFromNumberAndIntU_TypeSpecified()
    examples = _getExamplesFor_canConstructFromNumberAndIntU_TypeSpecified()
    return _checkConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructFromNumberAndIntU_TypeSpecified()
    realValue = -9.8
    dim1 = TestingTools.generateRandomDimension()
    q1 = Quantity{Float16}(realValue, intu)
    correctFields1 = Dict([
        ("value", Float16(realValue)),
        ("dimension", Dimension()),
        ("internal units", intu),
        ("value type", Float16)
    ])

    complexValue = 2.0 - 4im
    dim2 = TestingTools.generateRandomDimension()
    q2 = Quantity{Complex{Int32}}(complexValue, intu)
    correctFields2 = Dict([
        ("value", Complex{Int32}(complexValue)),
        ("dimension", Dimension()),
        ("internal units", intu),
        ("value type", Complex{Int32})
    ])

    examples = [
        (q1, correctFields1),
        (q2, correctFields2)
    ]
    return examples
end

function canConstructFromNumber_TypeSpecified()
    examples = _getExamplesFor_canConstructFromNumber_TypeSpecified()
    return _checkConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructFromNumber_TypeSpecified()
    realValue = -9.8
    dim1 = TestingTools.generateRandomDimension()
    q1 = Quantity{Float16}(realValue)
    correctFields1 = Dict([
        ("value", Float16(realValue)),
        ("dimension", Dimension()),
        ("internal units", InternalUnits()),
        ("value type", Float16)
    ])

    complexValue = 2.0 - 4im
    dim2 = TestingTools.generateRandomDimension()
    q2 = Quantity{Complex{Int32}}(complexValue)
    correctFields2 = Dict([
        ("value", Complex{Int32}(complexValue)),
        ("dimension", Dimension()),
        ("internal units", InternalUnits()),
        ("value type", Complex{Int32})
    ])

    examples = [
        (q1, correctFields1),
        (q2, correctFields2)
    ]
    return examples
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


## ## Type conversion

function canConvertTypeParameter()
    examples = _getExamplesFor_canConvertTypeParameter()
    return TestingTools.testDyadicFunction(Base.convert, examples)
end

function _getExamplesFor_canConvertTypeParameter()
    dim = Dimension(L=-1)
    examples = [
        ( Quantity{Float32}, Quantity{Float64}(7.1, dim, intu), Quantity(Float32(7.1), dim, intu) ),
        ( Quantity{UInt16}, Quantity{Float64}(16, dim, intu), Quantity(UInt16(16), dim, intu) ),
        ( Quantity{Float16}, Quantity{Int64}(16, dim, intu), Quantity(Float16(16), dim, intu) )
    ]
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
