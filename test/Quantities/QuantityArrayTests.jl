module QuantityArrayTests

using Alicorn
using Test
using ..TestingTools

const ucat = UnitCatalogue()
const defaultInternalUnits = InternalUnits()

function run()
    @testset "QuantityArray" begin
        @test canConstructFromArrayAndDimensionAndIntU()
        @test canConstructFromArrayAndDimension()
        @test canConstructFromArrayAndIntU()
        @test canConstructFromArray()
        @test canConstructFromArrayAndDimensionAndIntU_TypeSpecified()
        @test canConstructFromArrayAndDimension_TypeSpecified()
        @test canConstructFromArrayAndIntU_TypeSpecified()
        @test canConstructFromArray_TypeSpecified()
    end
end

function canConstructFromArrayAndDimensionAndIntU()
    examples = _getExamplesFor_canConstructFromArrayAndDimensionAndIntU()
    return _checkConstructorExamples(examples)
end

function _getExamplesFor_canConstructFromArrayAndDimensionAndIntU()
    realValue = TestingTools.generateRandomReal(dim=(2,3))
    dim1 = TestingTools.generateRandomDimension()
    q1 = QuantityArray(realValue, dim1, defaultInternalUnits)
    correctFields1 = Dict([
        ("value", realValue),
        ("dimension", dim1),
        ("internal units", defaultInternalUnits)
    ])

    complexValue = TestingTools.generateRandomComplex(dim=(2,3))
    dim2 = TestingTools.generateRandomDimension()
    q2 = QuantityArray(complexValue, dim2, defaultInternalUnits)
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
        ("internal units", defaultInternalUnits)
    ])

    complexValue = TestingTools.generateRandomComplex(dim=(2,3))
    dim2 = TestingTools.generateRandomDimension()
    q2 = QuantityArray(complexValue, dim2)
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

function canConstructFromArrayAndIntU()
    examples = _getExamplesFor_canConstructFromArrayAndIntU()
    return _checkConstructorExamples(examples)
end

function _getExamplesFor_canConstructFromArrayAndIntU()
    realValue = TestingTools.generateRandomReal(dim=(2,3))
    q1 = QuantityArray(realValue, defaultInternalUnits)
    correctFields1 = Dict([
        ("value", realValue),
        ("dimension", Dimension()),
        ("internal units", defaultInternalUnits)
    ])

    complexValue = TestingTools.generateRandomComplex(dim=(2,3))
    q2 = QuantityArray(complexValue, defaultInternalUnits)
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
        ("internal units", defaultInternalUnits)
    ])

    complexValue = TestingTools.generateRandomComplex(dim=(2,3))
    q2 = QuantityArray(complexValue)
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
    qArray1 = QuantityArray{Float16}(realValue, dim1, defaultInternalUnits)
    correctFields1 = Dict([
        ("value", Array{Float16}(realValue)),
        ("dimension", dim1),
        ("internal units", defaultInternalUnits),
        ("value type", Array{Float16})
    ])

    complexValue = [2.0 - 4im  5.0]
    dim2 = TestingTools.generateRandomDimension()
    qArray2 = QuantityArray{Complex{Int32}}(complexValue, dim2, defaultInternalUnits)
    correctFields2 = Dict([
        ("value", Array{Complex{Int32}}(complexValue)),
        ("dimension", dim2),
        ("internal units", defaultInternalUnits),
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
        ("internal units", defaultInternalUnits),
        ("value type", Array{Float16})
    ])

    complexValue = [2.0 - 4im  5.0]
    dim2 = TestingTools.generateRandomDimension()
    qArray2 = QuantityArray{Complex{Int32}}(complexValue, dim2)
    correctFields2 = Dict([
        ("value", Array{Complex{Int32}}(complexValue)),
        ("dimension", dim2),
        ("internal units", defaultInternalUnits),
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
    qArray1 = QuantityArray{Float16}(realValue, defaultInternalUnits)
    correctFields1 = Dict([
        ("value", Array{Float16}(realValue)),
        ("dimension", Dimension()),
        ("internal units", defaultInternalUnits),
        ("value type", Array{Float16})
    ])

    complexValue = [2.0 - 4im  5.0]
    qArray2 = QuantityArray{Complex{Int32}}(complexValue, defaultInternalUnits)
    correctFields2 = Dict([
        ("value", Array{Complex{Int32}}(complexValue)),
        ("dimension", Dimension()),
        ("internal units", defaultInternalUnits),
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
        ("internal units", defaultInternalUnits),
        ("value type", Array{Float16})
    ])

    complexValue = [2.0 - 4im  5.0]
    qArray2 = QuantityArray{Complex{Int32}}(complexValue)
    correctFields2 = Dict([
        ("value", Array{Complex{Int32}}(complexValue)),
        ("dimension", Dimension()),
        ("internal units", defaultInternalUnits),
        ("value type", Array{Complex{Int32}})
    ])

    examples = [
        (qArray1, correctFields1),
        (qArray2, correctFields2)
    ]
    return examples
end

end # module
