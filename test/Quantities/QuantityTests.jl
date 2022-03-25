module QuantityTests

using Alicorn
using Test
using ..TestingTools

const ucat = UnitCatalogue()
const defaultInternalUnits = InternalUnits()

function run()
    @testset "Quantity" begin
        @test canConstructFromNumberAndDimensionAndIntU()
        @test canConstructFromNumberAndDimension()
        @test canConstructFromNumberAndIntU()
        @test canConstructFromNumber()
        @test canConstructFromNumberAndDimensionAndIntU_TypeSpecified()
        @test canConstructFromNumberAndDimension_TypeSpecified()
        @test canConstructFromNumberAndIntU_TypeSpecified()
        @test canConstructFromNumber_TypeSpecified()
    end
end

function canConstructFromNumberAndDimensionAndIntU()
    examples = _getExamplesFor_canConstructFromNumberAndDimensionAndIntU()
    return _checkConstructorExamples(examples)
end

function _getExamplesFor_canConstructFromNumberAndDimensionAndIntU()
    realValue = Float32(TestingTools.generateRandomReal())
    dim1 = TestingTools.generateRandomDimension()
    q1 = Quantity(realValue, dim1, defaultInternalUnits)
    correctFields1 = Dict([
        ("value", realValue),
        ("dimension", dim1),
        ("internal units", defaultInternalUnits)
    ])

    complexValue = TestingTools.generateRandomComplex()
    dim2 = TestingTools.generateRandomDimension()
    q2 = Quantity(complexValue, dim2, defaultInternalUnits)
    correctFields2 = Dict([
        ("value", complexValue),
        ("dimension", dim2),
        ("internal units", defaultInternalUnits)
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
        ("internal units", defaultInternalUnits)
    ])

    complexValue = TestingTools.generateRandomComplex()
    dim2 = TestingTools.generateRandomDimension()
    q2 = Quantity(complexValue, dim2)
    correctFields2 = Dict([
        ("value", complexValue),
        ("dimension", dim2),
        ("internal units", defaultInternalUnits)
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
    q1 = Quantity(realValue, defaultInternalUnits)
    correctFields1 = Dict([
        ("value", realValue),
        ("dimension", Dimension()),
        ("internal units", defaultInternalUnits)
    ])

    complexValue = TestingTools.generateRandomComplex()
    q2 = Quantity(complexValue, defaultInternalUnits)
    correctFields2 = Dict([
        ("value", complexValue),
        ("dimension", Dimension()),
        ("internal units", defaultInternalUnits)
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
        ("internal units", defaultInternalUnits)
    ])

    complexValue = TestingTools.generateRandomComplex()
    q2 = Quantity(complexValue)
    correctFields2 = Dict([
        ("value", complexValue),
        ("dimension", Dimension()),
        ("internal units", defaultInternalUnits)
    ])

    examples = [
        (q1, correctFields1),
        (q2, correctFields2)
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
    q1 = Quantity(realValue, baseUnit, defaultInternalUnits)
    correctFields1 = Dict([
        ("value", value1),
        ("dimension", dim1),
        ("internal units", defaultInternalUnits)
    ])

    complexValue = TestingTools.generateRandomComplex()
    unitFactor = TestingTools.generateRandomUnitFactor()
    value2 = inBasicSIUnits(complexValue*unitFactor).value
    dim2 = dimensionOf(unitFactor)
    q2 = Quantity(complexValue, unitFactor, defaultInternalUnits)
    correctFields2 = Dict([
        ("value", value2),
        ("dimension", dim2),
        ("internal units", defaultInternalUnits)
    ])

    complexValue = TestingTools.generateRandomComplex()
    unit = TestingTools.generateRandomUnit()
    value3 = inBasicSIUnits(complexValue*unit).value
    dim3 = dimensionOf(unit)
    q3 = Quantity(complexValue, unit, defaultInternalUnits)
    correctFields3 = Dict([
        ("value", value3),
        ("dimension", dim3),
        ("internal units", defaultInternalUnits)
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
        ("internal units", defaultInternalUnits)
    ])

    complexValue = TestingTools.generateRandomComplex()
    unitFactor = TestingTools.generateRandomUnitFactor()
    value2 = inBasicSIUnits(complexValue*unitFactor).value
    dim2 = dimensionOf(unitFactor)
    q2 = Quantity(complexValue, unitFactor)
    correctFields2 = Dict([
        ("value", value2),
        ("dimension", dim2),
        ("internal units", defaultInternalUnits)
    ])

    complexValue = TestingTools.generateRandomComplex()
    unit = TestingTools.generateRandomUnit()
    value3 = inBasicSIUnits(complexValue*unit).value
    dim3 = dimensionOf(unit)
    q3 = Quantity(complexValue, unit)
    correctFields3 = Dict([
        ("value", value3),
        ("dimension", dim3),
        ("internal units", defaultInternalUnits)
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
    q1 = Quantity(baseUnit, defaultInternalUnits)
    correctFields1 = Dict([
        ("value", value1),
        ("dimension", dim1),
        ("internal units", defaultInternalUnits)
    ])

    unitFactor = TestingTools.generateRandomUnitFactor()
    value2 = inBasicSIUnits(1*unitFactor).value
    dim2 = dimensionOf(unitFactor)
    q2 = Quantity(unitFactor, defaultInternalUnits)
    correctFields2 = Dict([
        ("value", value2),
        ("dimension", dim2),
        ("internal units", defaultInternalUnits)
    ])

    unit = TestingTools.generateRandomUnit()
    value3 = inBasicSIUnits(1*unit).value
    dim3 = dimensionOf(unit)
    q3 = Quantity(unit, defaultInternalUnits)
    correctFields3 = Dict([
        ("value", value3),
        ("dimension", dim3),
        ("internal units", defaultInternalUnits)
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
        ("internal units", defaultInternalUnits)
    ])

    unitFactor = TestingTools.generateRandomUnitFactor()
    value2 = inBasicSIUnits(1*unitFactor).value
    dim2 = dimensionOf(unitFactor)
    q2 = Quantity(unitFactor)
    correctFields2 = Dict([
        ("value", value2),
        ("dimension", dim2),
        ("internal units", defaultInternalUnits)
    ])

    unit = TestingTools.generateRandomUnit()
    value3 = inBasicSIUnits(1*unit).value
    dim3 = dimensionOf(unit)
    q3 = Quantity(unit)
    correctFields3 = Dict([
        ("value", value3),
        ("dimension", dim3),
        ("internal units", defaultInternalUnits)
    ])

    examples = [
        (q1, correctFields1),
        (q2, correctFields2),
        (q3, correctFields3)
    ]
    return examples
end

function canConstructFromNumberAndDimensionAndIntU_TypeSpecified()
    examples = _getExamplesFor_canConstructFromNumberAndDimensionAndIntU_TypeSpecified()
    return _checkConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructFromNumberAndDimensionAndIntU_TypeSpecified()
    realValue = -9.8
    dim1 = TestingTools.generateRandomDimension()
    q1 = Quantity{Float16}(realValue, dim1, defaultInternalUnits)
    correctFields1 = Dict([
        ("value", Float16(realValue)),
        ("dimension", dim1),
        ("internal units", defaultInternalUnits),
        ("value type", Float16)
    ])

    complexValue = 2.0 - 4im
    dim2 = TestingTools.generateRandomDimension()
    q2 = Quantity{Complex{Int32}}(complexValue, dim2, defaultInternalUnits)
    correctFields2 = Dict([
        ("value", Complex{Int32}(complexValue)),
        ("dimension", dim2),
        ("internal units", defaultInternalUnits),
        ("value type", Complex{Int32})
    ])

    examples = [
        (q1, correctFields1),
        (q2, correctFields2)
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
        ("internal units", defaultInternalUnits),
        ("value type", Float16)
    ])

    complexValue = 2.0 - 4im
    dim2 = TestingTools.generateRandomDimension()
    q2 = Quantity{Complex{Int32}}(complexValue, dim2)
    correctFields2 = Dict([
        ("value", Complex{Int32}(complexValue)),
        ("dimension", dim2),
        ("internal units", defaultInternalUnits),
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
    q1 = Quantity{Float16}(realValue, defaultInternalUnits)
    correctFields1 = Dict([
        ("value", Float16(realValue)),
        ("dimension", Dimension()),
        ("internal units", defaultInternalUnits),
        ("value type", Float16)
    ])

    complexValue = 2.0 - 4im
    dim2 = TestingTools.generateRandomDimension()
    q2 = Quantity{Complex{Int32}}(complexValue, defaultInternalUnits)
    correctFields2 = Dict([
        ("value", Complex{Int32}(complexValue)),
        ("dimension", Dimension()),
        ("internal units", defaultInternalUnits),
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
        ("internal units", defaultInternalUnits),
        ("value type", Float16)
    ])

    complexValue = 2.0 - 4im
    dim2 = TestingTools.generateRandomDimension()
    q2 = Quantity{Complex{Int32}}(complexValue)
    correctFields2 = Dict([
        ("value", Complex{Int32}(complexValue)),
        ("dimension", Dimension()),
        ("internal units", defaultInternalUnits),
        ("value type", Complex{Int32})
    ])

    examples = [
        (q1, correctFields1),
        (q2, correctFields2)
    ]
    return examples
end

end # module
