module quantity_typeConversionTests

using Alicorn
using Test
using ..TestingTools

const ucat = UnitCatalogue()
const defaultInternalUnits = InternalUnits()
const intu2 = InternalUnits(length=2*ucat.meter)
const lengthDim = Dimension(L=1)

function run()
    @testset "quantity_typeConversion" begin

        # SimpleQuantity
        @test canConstructSimpleQuantityFromSimpleQuantity()
        @test canConstructSimpleQuantityFromQuantity()
        @test canConstructSimpleQuantityFromSimpleQuantity_TypeSpecified()
        @test canConstructSimpleQuantityFromQuantity_TypeSpecified()
        @test canConvertSimpleQuantityTypeParameter()

        # Quantity
        @test canConstructQuantityFromQuantityAndIntU()
        @test canConstructQuantityFromQuantity()
        @test canConstructQuantityFromSimpleQuantityAndIntU()
        @test canConstructQuantityFromSimpleQuantity()
        @test canConstructQuantityFromQuantityAndIntU_TypeSpecified()
        @test canConstructQuantityFromQuantity_TypeSpecified()
        @test canConstructQuantityFromSimpleQuantityAndIntU_TypeSpecified()
        @test canConstructQuantityFromSimpleQuantity_TypeSpecified()
        @test canConvertQuantityTypeParameter()

        # SimpleQuantityArray
        @test canConstructSimpleQuantityArrayFromSimpleQuantityArray()
        @test canConstructSimpleQuantityArrayFromQuantityArray()
        @test canConstructSimpleQuantityArrayFromSimpleQuantity()
        @test canConstructSimpleQuantityArrayFromQuantity()
        @test canConstructSimpleQuantityArrayFromSimpleQuantityArray_TypeSpecified()
        @test canConstructSimpleQuantityArrayFromQuantityArray_TypeSpecified()
        @test canConstructSimpleQuantityArrayFromSimpleQuantity_TypeSpecified()
        @test canConstructSimpleQuantityArrayFromQuantity_TypeSpecified()
        @test canConvertSimpleQuantityArrayTypeParameter()

        # QuantityArray
        @test canConstructQuantityArrayFromQuantityArrayAndIntU()
        @test canConstructQuantityArrayFromQuantityArray()
        @test canConstructQuantityArrayFromSimpleQuantityArrayAndIntU()
        @test canConstructQuantityArrayFromSimpleQuantityArray()
        @test canConstructQuantityArrayFromQuantityAndIntU()
        @test canConstructQuantityArrayFromQuantity()
        @test canConstructQuantityArrayFromSimpleQuantityAndIntU()
        @test canConstructQuantityArrayFromSimpleQuantity()
        @test canConstructQuantityArrayFromQuantityArrayAndIntU_TypeSpecified()
        @test canConstructQuantityArrayFromQuantityArray_TypeSpecified()
        @test canConstructQuantityArrayFromSimpleQuantityArrayAndIntU_TypeSpecified()
        @test canConstructQuantityArrayFromSimpleQuantityArray_TypeSpecified()
        @test canConstructQuantityArrayFromQuantityAndIntU_TypeSpecified()
        @test canConstructQuantityArrayFromQuantity_TypeSpecified()
        @test canConstructQuantityArrayFromSimpleQuantityAndIntU_TypeSpecified()
        @test canConstructQuantityArrayFromSimpleQuantity_TypeSpecified()
        @test canConvertQuantityArrayTypeParameter()
    end
end


## SimpleQuantity

function _checkSimpleQuantityConstructorExamplesIncludingType(examples::Array)
    correct = true
    for (simpleQuantity, correctFields) in examples
        correct &= _verifySimpleQuantityHasCorrectFieldsAndType(simpleQuantity, correctFields)
    end
    return correct
end

function _verifySimpleQuantityHasCorrectFieldsAndType(simpleQuantity::SimpleQuantity, correctFields::Dict{String,Any})
    correctValue = (simpleQuantity.value == correctFields["value"])
    correctUnit = (simpleQuantity.unit == correctFields["unit"])
    correctType = isa(simpleQuantity.value, correctFields["value type"])
    return correctValue && correctUnit && correctType
end

function canConstructSimpleQuantityFromSimpleQuantity()
    examples = _getExamplesFor_canConstructSimpleQuantityFromSimpleQuantity()
    return _checkSimpleQuantityConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructSimpleQuantityFromSimpleQuantity()
    sq = SimpleQuantity{Float32}( -6.7, ucat.meter )
    returnedSq = SimpleQuantity(sq)
    correctFields = Dict([
        ("value", Float32(-6.7)),
        ("unit", Unit(ucat.meter)),
        ("value type", Float32)
    ])

    examples = [
        (returnedSq, correctFields)
    ]
    return examples
end

function canConstructSimpleQuantityFromQuantity()
    examples = _getExamplesFor_canConstructSimpleQuantityFromQuantity()
    return _checkSimpleQuantityConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructSimpleQuantityFromQuantity()
    quantity = Quantity{Int32}(5, lengthDim, intu2)
    returnedSq = SimpleQuantity(quantity)
    correctFields = Dict([
        ("value", Int32(10) ),
        ("unit", Unit(ucat.meter)),
        ("value type", Int32)
    ])

    examples = [
        (returnedSq, correctFields)
    ]
    return examples
end

function canConstructSimpleQuantityFromSimpleQuantity_TypeSpecified()
    examples = _getExamplesFor_canConstructSimpleQuantityFromSimpleQuantity_TypeSpecified()
    return _checkSimpleQuantityConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructSimpleQuantityFromSimpleQuantity_TypeSpecified()
    sq = SimpleQuantity{Float64}( -6.7, ucat.meter )
    returnedSq = SimpleQuantity{Float32}(sq)
    correctFields = Dict([
        ("value", Float32(-6.7)),
        ("unit", Unit(ucat.meter)),
        ("value type", Float32)
    ])

    examples = [
        (returnedSq, correctFields)
    ]
    return examples
end

function canConstructSimpleQuantityFromQuantity_TypeSpecified()
    examples = _getExamplesFor_canConstructSimpleQuantityFromQuantity_TypeSpecified()
    return _checkSimpleQuantityConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructSimpleQuantityFromQuantity_TypeSpecified()
    quantity = Quantity{Int64}(5, lengthDim, intu2)
    returnedSq = SimpleQuantity{Int32}(quantity)
    correctFields = Dict([
        ("value", Int32(10) ),
        ("unit", Unit(ucat.meter)),
        ("value type", Int32)
    ])

    examples = [
        (returnedSq, correctFields)
    ]
    return examples
end

function canConvertSimpleQuantityTypeParameter()
    examples = _getExamplesFor_canConvertSimpleQuantityTypeParameter()
    return TestingTools.testDyadicFunction(Base.convert, examples)
end

function _getExamplesFor_canConvertSimpleQuantityTypeParameter()
    examples = [
        ( SimpleQuantity{Float32}, SimpleQuantity{Float64}(-7.1, ucat.meter), SimpleQuantity{Float32}(-7.1, ucat.meter) ),
        ( SimpleQuantity{UInt16}, SimpleQuantity{Float64}(16, ucat.meter), SimpleQuantity{UInt16}(16, ucat.meter) ),
        ( SimpleQuantity{Float16}, SimpleQuantity{Int64}(16, ucat.meter), SimpleQuantity{Float16}(16, ucat.meter) )
    ]
end

## Quantity

function _checkQuantityConstructorExamplesIncludingType(examples::Array)
    correct = true
    for (quantity, correctFields) in examples
        correct &= _verifyQuantityHasCorrectFieldsAndType(quantity, correctFields)
    end
    return correct
end

function _verifyQuantityHasCorrectFieldsAndType(quantity::Quantity, correctFields::Dict{String,Any})
    correctValue = (quantity.value == correctFields["value"])
    correctDimension = (quantity.dimension == correctFields["dimension"])
    correctIntU = (quantity.internalUnits == correctFields["internal units"])
    correctType = isa(quantity.value, correctFields["value type"])
    correct = correctValue && correctDimension && correctIntU && correctType
    return correct
end

function canConstructQuantityFromQuantityAndIntU()
    examples = _getExamplesFor_canConstructQuantityFromQuantityAndIntU()
    return _checkQuantityConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructQuantityFromQuantityAndIntU()
    quantity = Quantity{Int32}(10, lengthDim, defaultInternalUnits)
    returnedQuantity = Quantity(quantity, intu2)
    correctFields = Dict([
        ("value", Int32(5) ),
        ("dimension", lengthDim),
        ("internal units", intu2),
        ("value type", Int32)
    ])

    examples = [
        (returnedQuantity, correctFields)
    ]
    return examples
end

function canConstructQuantityFromQuantity()
    examples = _getExamplesFor_canConstructQuantityFromQuantity()
    return _checkQuantityConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructQuantityFromQuantity()
    quantity = Quantity{Int32}(10, lengthDim, intu2)
    returnedQuantity = Quantity(quantity)
    correctFields = Dict([
        ("value", Int32(10) ),
        ("dimension", lengthDim),
        ("internal units", intu2),
        ("value type", Int32)
    ])

    examples = [
        (returnedQuantity, correctFields)
    ]
    return examples
end


function canConstructQuantityFromSimpleQuantityAndIntU()
    examples = _getExamplesFor_canConstructQuantityFromSimpleQuantityAndIntU()
    return _checkQuantityConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructQuantityFromSimpleQuantityAndIntU()
    sQuantity = SimpleQuantity{Int32}(-10, ucat.meter)
    returnedQuantity = Quantity(sQuantity, intu2)
    correctFields = Dict([
        ("value", Int32(-5) ),
        ("dimension", lengthDim),
        ("internal units", intu2),
        ("value type", Int32)
    ])

    examples = [
        (returnedQuantity, correctFields)
    ]
    return examples
end

function canConstructQuantityFromSimpleQuantity()
    examples = _getExamplesFor_canConstructQuantityFromSimpleQuantity()
    return _checkQuantityConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructQuantityFromSimpleQuantity()
    sQuantity = SimpleQuantity{Int32}(-10, ucat.meter)
    returnedQuantity = Quantity(sQuantity)
    correctFields = Dict([
        ("value", Int32(-10) ),
        ("dimension", lengthDim),
        ("internal units", defaultInternalUnits),
        ("value type", Int32)
    ])

    examples = [
        (returnedQuantity, correctFields)
    ]
    return examples
end

function canConstructQuantityFromQuantityAndIntU_TypeSpecified()
    examples = _getExamplesFor_canConstructQuantityFromQuantityAndIntU_TypeSpecified()
    return _checkQuantityConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructQuantityFromQuantityAndIntU_TypeSpecified()
    quantity = Quantity{Int64}(10, lengthDim, defaultInternalUnits)
    returnedQuantity = Quantity{Int32}(quantity, intu2)
    correctFields = Dict([
        ("value", Int32(5) ),
        ("dimension", lengthDim),
        ("internal units", intu2),
        ("value type", Int32)
    ])

    examples = [
        (returnedQuantity, correctFields)
    ]
    return examples
end

function canConstructQuantityFromQuantity_TypeSpecified()
    examples = _getExamplesFor_canConstructQuantityFromQuantity_TypeSpecified()
    return _checkQuantityConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructQuantityFromQuantity_TypeSpecified()
    quantity = Quantity{Float64}(-9.2, lengthDim, intu2)
    returnedQuantity = Quantity{Float32}(quantity)
    correctFields = Dict([
        ("value", Float32(-9.2) ),
        ("dimension", lengthDim),
        ("internal units", intu2),
        ("value type", Float32)
    ])

    examples = [
        (returnedQuantity, correctFields)
    ]
    return examples
end

function canConstructQuantityFromSimpleQuantityAndIntU_TypeSpecified()
    examples = _getExamplesFor_canConstructQuantityFromSimpleQuantityAndIntU_TypeSpecified()
    return _checkQuantityConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructQuantityFromSimpleQuantityAndIntU_TypeSpecified()
    sQuantity = SimpleQuantity{Int64}(-10, ucat.meter)
    returnedQuantity = Quantity{Int32}(sQuantity, intu2)
    correctFields = Dict([
        ("value", Int32(-5) ),
        ("dimension", lengthDim),
        ("internal units", intu2),
        ("value type", Int32)
    ])

    examples = [
        (returnedQuantity, correctFields)
    ]
    return examples
end

function canConstructQuantityFromSimpleQuantity_TypeSpecified()
    examples = _getExamplesFor_canConstructQuantityFromSimpleQuantity_TypeSpecified()
    return _checkQuantityConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructQuantityFromSimpleQuantity_TypeSpecified()
    sQuantity = SimpleQuantity{Int64}(-10, ucat.meter)
    returnedQuantity = Quantity{Int32}(sQuantity)
    correctFields = Dict([
        ("value", Int32(-10) ),
        ("dimension", lengthDim),
        ("internal units", defaultInternalUnits),
        ("value type", Int32)
    ])

    examples = [
        (returnedQuantity, correctFields)
    ]
    return examples
end

function canConvertQuantityTypeParameter()
    examples = _getExamplesFor_canConvertQuantityTypeParameter()
    return TestingTools.testDyadicFunction(Base.convert, examples)
end

function _getExamplesFor_canConvertQuantityTypeParameter()
    dim = Dimension(L=-1)
    examples = [
        ( Quantity{Float32}, Quantity{Float64}(7.1, dim, defaultInternalUnits), Quantity(Float32(7.1), dim, defaultInternalUnits) ),
        ( Quantity{UInt16}, Quantity{Float64}(16, dim, defaultInternalUnits), Quantity(UInt16(16), dim, defaultInternalUnits) ),
        ( Quantity{Float16}, Quantity{Int64}(16, dim, defaultInternalUnits), Quantity(Float16(16), dim, defaultInternalUnits) )
    ]
end


## SimpleQuantityArray

function _checkSimpleQuantityArrayConstructorExamplesIncludingType(examples::Array)
    correct = true
    for (sqArray, correctFields) in examples
        correct &= _verifySimpleQuantityArrayHasCorrectFieldsAndType(sqArray, correctFields)
    end
    return correct
end

function _verifySimpleQuantityArrayHasCorrectFieldsAndType(sqArray::SimpleQuantityArray, correctFields::Dict{String,Any})
    correctValue = (sqArray.value == correctFields["value"])
    correctUnit = (sqArray.unit == correctFields["unit"])
    correctType = isa(sqArray.value, correctFields["value type"])
    return correctValue && correctUnit && correctType
end

function canConstructSimpleQuantityArrayFromSimpleQuantityArray()
    examples = _getExamplesFor_canConstructSimpleQuantityArrayFromSimpleQuantityArray()
    return _checkSimpleQuantityArrayConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructSimpleQuantityArrayFromSimpleQuantityArray()
    sqArray = SimpleQuantityArray{Float32}( [-6.7 7.6], ucat.meter )
    returnedSqArray = SimpleQuantityArray(sqArray)
    correctFields = Dict([
        ("value", Array{Float32}([-6.7 7.6])),
        ("unit", Unit(ucat.meter)),
        ("value type", Array{Float32})
    ])

    examples = [
        (returnedSqArray, correctFields)
    ]
    return examples
end

function canConstructSimpleQuantityArrayFromQuantityArray()
    examples = _getExamplesFor_canConstructSimpleQuantityArrayFromQuantityArray()
    return _checkSimpleQuantityArrayConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructSimpleQuantityArrayFromQuantityArray()
    qArray = QuantityArray{Int32}([2500, -3500], lengthDim, intu2)
    sqArray = SimpleQuantityArray(qArray)
    correctFields = Dict([
        ("value", Array{Int32}([5000, -7000])),
        ("unit", Unit(ucat.meter)),
        ("value type", Array{Int32})
    ])

    examples = [
        (sqArray, correctFields)
    ]
    return examples
end

function canConstructSimpleQuantityArrayFromSimpleQuantity()
    examples = _getExamplesFor_canConstructSimpleQuantityArrayFromSimpleQuantity()
    return _checkSimpleQuantityArrayConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructSimpleQuantityArrayFromSimpleQuantity()
    sQuantity = SimpleQuantity{Int32}(-350, ucat.meter)
    sqArray = SimpleQuantityArray(sQuantity)
    correctFields = Dict([
        ("value", Array{Int32}([-350])),
        ("unit", Unit(ucat.meter)),
        ("value type", Array{Int32})
    ])

    examples = [
        (sqArray, correctFields)
    ]
    return examples
end

function canConstructSimpleQuantityArrayFromQuantity()
    examples = _getExamplesFor_canConstructSimpleQuantityArrayFromQuantity()
    return _checkSimpleQuantityArrayConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructSimpleQuantityArrayFromQuantity()
    quantity = Quantity{Int32}(-350, lengthDim, intu2)
    sqArray = SimpleQuantityArray(quantity)
    correctFields = Dict([
        ("value", Array{Int32}([-700])),
        ("unit", Unit(ucat.meter)),
        ("value type", Array{Int32})
    ])

    examples = [
        (sqArray, correctFields)
    ]
    return examples
end

function canConstructSimpleQuantityArrayFromSimpleQuantityArray_TypeSpecified()
    examples = _getExamplesFor_canConstructSimpleQuantityArrayFromSimpleQuantityArray_TypeSpecified()
    return _checkSimpleQuantityArrayConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructSimpleQuantityArrayFromSimpleQuantityArray_TypeSpecified()
    sqArray = SimpleQuantityArray{Float64}( [-6 7], ucat.meter )
    returnedSqArray = SimpleQuantityArray{Int32}(sqArray)
    correctFields = Dict([
        ("value", Array{Int32}([-6 7])),
        ("unit", Unit(ucat.meter)),
        ("value type", Array{Int32})
    ])

    examples = [
        (returnedSqArray, correctFields)
    ]
    return examples
end

function canConstructSimpleQuantityArrayFromQuantityArray_TypeSpecified()
    examples = _getExamplesFor_canConstructSimpleQuantityArrayFromQuantityArray_TypeSpecified()
    return _checkSimpleQuantityArrayConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructSimpleQuantityArrayFromQuantityArray_TypeSpecified()
    qArray = QuantityArray{Float64}([2500, -3500], lengthDim, intu2)
    sqArray = SimpleQuantityArray{Int32}(qArray)
    correctFields = Dict([
        ("value", Array{Int32}([5000, -7000])),
        ("unit", Unit(ucat.meter)),
        ("value type", Array{Int32})
    ])

    examples = [
        (sqArray, correctFields)
    ]
    return examples
end

function canConstructSimpleQuantityArrayFromSimpleQuantity_TypeSpecified()
    examples = _getExamplesFor_canConstructSimpleQuantityArrayFromSimpleQuantity_TypeSpecified()
    return _checkSimpleQuantityArrayConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructSimpleQuantityArrayFromSimpleQuantity_TypeSpecified()
    sQuantity = SimpleQuantity{Float64}(350, ucat.meter)
    sqArray = SimpleQuantityArray{UInt32}(sQuantity)
    correctFields = Dict([
        ("value", Array{UInt32}([350])),
        ("unit", Unit(ucat.meter)),
        ("value type", Array{UInt32})
    ])

    examples = [
        (sqArray, correctFields)
    ]
    return examples
end
function canConstructSimpleQuantityArrayFromQuantity_TypeSpecified()
    examples = _getExamplesFor_canConstructSimpleQuantityArrayFromQuantity_TypeSpecified()
    return _checkSimpleQuantityArrayConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructSimpleQuantityArrayFromQuantity_TypeSpecified()
    quantity = Quantity{Float64}(-350, lengthDim, intu2)
    sqArray = SimpleQuantityArray{Int32}(quantity)
    correctFields = Dict([
        ("value", Array{Int32}([-700])),
        ("unit", Unit(ucat.meter)),
        ("value type", Array{Int32})
    ])

    examples = [
        (sqArray, correctFields)
    ]
    return examples
end

function canConvertSimpleQuantityArrayTypeParameter()
    examples = _getExamplesFor_canConvertSimpleQuantityArrayTypeParameter()
    return TestingTools.testDyadicFunction(Base.convert, examples)
end

function _getExamplesFor_canConvertSimpleQuantityArrayTypeParameter()
    examples = [
        ( SimpleQuantityArray{Float32}, SimpleQuantityArray{Float64}([7.1], ucat.meter), SimpleQuantityArray{Float32}([7.1], ucat.meter) ),
        ( SimpleQuantityArray{UInt16}, SimpleQuantityArray{Float64}([16], ucat.meter), SimpleQuantityArray{UInt16}([16], ucat.meter) ),
        ( SimpleQuantityArray{Float16}, SimpleQuantityArray{Int64}([16], ucat.meter), SimpleQuantityArray{Float16}([16], ucat.meter) )
    ]
end


## QuantityArray

function _checkQuantityArrayConstructorExamplesIncludingType(examples::Array)
    correct = true
    for (sqArray, correctFields) in examples
        correct &= _verifyQuantityArrayHasCorrectFieldsandType(sqArray, correctFields)
    end
    return correct
end

function _verifyQuantityArrayHasCorrectFieldsandType(qArray::QuantityArray, correctFields::Dict{String,Any})
    correctValue = (qArray.value == correctFields["value"])
    correctDimension = (qArray.dimension == correctFields["dimension"])
    correctIntU = (qArray.internalUnits == correctFields["internal units"])
    correctType = isa(qArray.value, correctFields["value type"])
    correct = correctValue && correctDimension && correctIntU && correctType
    return correct
end

function canConstructQuantityArrayFromQuantityArrayAndIntU()
    examples = _getExamplesFor_canConstructQuantityArrayFromQuantityArrayAndIntU()
    return _checkQuantityArrayConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructQuantityArrayFromQuantityArrayAndIntU()
    quantityArray = QuantityArray(Array{Int32}([4, 8]), lengthDim, defaultInternalUnits)
    returnedArray = QuantityArray(quantityArray, intu2)
    correctFields = Dict([
        ("value", [2, 4]),
        ("dimension", lengthDim),
        ("internal units", intu2),
        ("value type", Array{Int32})
    ])

    examples = [
        (returnedArray, correctFields)
    ]
    return examples
end

function canConstructQuantityArrayFromQuantityArray()
    examples = _getExamplesFor_canConstructQuantityArrayFromQuantityArray()
    return _checkQuantityArrayConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructQuantityArrayFromQuantityArray()
    quantityArray = QuantityArray(Array{Int32}([4, 8]), lengthDim, intu2)
    returnedArray = QuantityArray(quantityArray)
    correctFields = Dict([
        ("value", [4, 8]),
        ("dimension", lengthDim),
        ("internal units", intu2),
        ("value type", Array{Int32})
    ])

    examples = [
        (returnedArray, correctFields)
    ]
    return examples
end

function canConstructQuantityArrayFromSimpleQuantityArrayAndIntU()
    examples = _getExamplesFor_canConstructQuantityArrayFromSimpleQuantityArrayAndIntU()
    return _checkQuantityArrayConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructQuantityArrayFromSimpleQuantityArrayAndIntU()
    sqArray = Array{Int32}([4, 2]) * ucat.meter
    returnedArray1 = QuantityArray(sqArray, intu2)
    correctFields1 = Dict([
        ("value", [2, 1]),
        ("dimension", dimensionOf(sqArray)),
        ("internal units", intu2),
        ("value type", Array{Int32})
    ])

    examples = [
        (returnedArray1, correctFields1)
    ]
    return examples
end

function canConstructQuantityArrayFromSimpleQuantityArray()
    examples = _getExamplesFor_canConstructQuantityArrayFromSimpleQuantityArray()
    return _checkQuantityArrayConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructQuantityArrayFromSimpleQuantityArray()
    sqArray = Array{Int32}([4, 2]) * ucat.meter
    returnedArray1 = QuantityArray(sqArray)
    correctFields1 = Dict([
        ("value", [4, 2]),
        ("dimension", dimensionOf(sqArray)),
        ("internal units", defaultInternalUnits),
        ("value type", Array{Int32})
    ])

    examples = [
        (returnedArray1, correctFields1)
    ]
    return examples
end

function canConstructQuantityArrayFromQuantityAndIntU()
    examples = _getExamplesFor_canConstructQuantityArrayFromQuantityAndIntU()
    return _checkQuantityArrayConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructQuantityArrayFromQuantityAndIntU()
    quantity = Quantity(Int32(4), lengthDim, defaultInternalUnits)
    returnedArray = QuantityArray(quantity, intu2)
    correctFields = Dict([
        ("value", [2]),
        ("dimension", lengthDim),
        ("internal units", intu2),
        ("value type", Array{Int32})
    ])

    examples = [
        (returnedArray, correctFields)
    ]
    return examples
end

function canConstructQuantityArrayFromQuantity()
    examples = _getExamplesFor_canConstructQuantityArrayFromQuantity()
    return _checkQuantityArrayConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructQuantityArrayFromQuantity()
    quantity = Quantity(Int32(4), lengthDim, intu2)
    returnedArray = QuantityArray(quantity)
    correctFields = Dict([
        ("value", [4]),
        ("dimension", lengthDim),
        ("internal units", intu2),
        ("value type", Array{Int32})
    ])

    examples = [
        (returnedArray, correctFields)
    ]
    return examples
end

function canConstructQuantityArrayFromSimpleQuantityAndIntU()
    examples = _getExamplesFor_canConstructQuantityArrayFromSimpleQuantityAndIntU()
    return _checkQuantityArrayConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructQuantityArrayFromSimpleQuantityAndIntU()
    sQuantity = Int32(4) * ucat.meter
    returnedArray = QuantityArray(sQuantity, intu2)
    correctFields = Dict([
        ("value", [2]),
        ("dimension", lengthDim),
        ("internal units", intu2),
        ("value type", Array{Int32})
    ])

    examples = [
        (returnedArray, correctFields)
    ]
    return examples
end

function canConstructQuantityArrayFromSimpleQuantity()
    examples = _getExamplesFor_canConstructQuantityArrayFromSimpleQuantity()
    return _checkQuantityArrayConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructQuantityArrayFromSimpleQuantity()
    sQuantity = Int32(4) * ucat.meter
    returnedArray = QuantityArray(sQuantity)
    correctFields = Dict([
        ("value", [4]),
        ("dimension", lengthDim),
        ("internal units", defaultInternalUnits),
        ("value type", Array{Int32})
    ])

    examples = [
        (returnedArray, correctFields)
    ]
    return examples
end

function canConstructQuantityArrayFromQuantityArrayAndIntU_TypeSpecified()
    examples = _getExamplesFor_canConstructQuantityArrayFromQuantityArrayAndIntU_TypeSpecified()
    return _checkQuantityArrayConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructQuantityArrayFromQuantityArrayAndIntU_TypeSpecified()
    quantityArray = QuantityArray(Array{Float32}([4, 8]), lengthDim, defaultInternalUnits)
    returnedArray = QuantityArray{Int32}(quantityArray, intu2)
    correctFields = Dict([
        ("value", [2, 4]),
        ("dimension", lengthDim),
        ("internal units", intu2),
        ("value type", Array{Int32})
    ])

    examples = [
        (returnedArray, correctFields)
    ]
    return examples
end

function canConstructQuantityArrayFromQuantityArray_TypeSpecified()
    examples = _getExamplesFor_canConstructQuantityArrayFromQuantityArray_TypeSpecified()
    return _checkQuantityArrayConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructQuantityArrayFromQuantityArray_TypeSpecified()
    quantityArray = QuantityArray(Array{Float32}([-4, 8]), lengthDim, intu2)
    returnedArray = QuantityArray{Int32}(quantityArray)
    correctFields = Dict([
        ("value", [-4, 8]),
        ("dimension", lengthDim),
        ("internal units", intu2),
        ("value type", Array{Int32})
    ])

    examples = [
        (returnedArray, correctFields)
    ]
    return examples
end

function canConstructQuantityArrayFromSimpleQuantityArrayAndIntU_TypeSpecified()
    examples = _getExamplesFor_canConstructQuantityArrayFromSimpleQuantityArrayAndIntU_TypeSpecified()
    return _checkQuantityArrayConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructQuantityArrayFromSimpleQuantityArrayAndIntU_TypeSpecified()
    sqArray = Array{Float64}([-2.2, 4.6]) * ucat.meter
    returnedArray = QuantityArray{Float32}(sqArray, intu2)
    correctFields = Dict([
        ("value", Array{Float32}([-1.1, 2.3])),
        ("dimension", lengthDim),
        ("internal units", intu2),
        ("value type", Array{Float32})
    ])

    examples = [
        (returnedArray, correctFields)
    ]
    return examples
end

function canConstructQuantityArrayFromSimpleQuantityArray_TypeSpecified()
    examples = _getExamplesFor_canConstructQuantityArrayFromSimpleQuantityArray_TypeSpecified()
    return _checkQuantityArrayConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructQuantityArrayFromSimpleQuantityArray_TypeSpecified()
    sqArray = Array{Float64}([-2.2, 4.6]) * ucat.meter
    returnedArray = QuantityArray{Float32}(sqArray)
    correctFields = Dict([
        ("value", Array{Float32}([-2.2, 4.6])),
        ("dimension", lengthDim),
        ("internal units", defaultInternalUnits),
        ("value type", Array{Float32})
    ])

    examples = [
        (returnedArray, correctFields)
    ]
    return examples
end

function canConstructQuantityArrayFromQuantityAndIntU_TypeSpecified()
    examples = _getExamplesFor_canConstructQuantityArrayFromQuantityAndIntU_TypeSpecified()
    return _checkQuantityArrayConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructQuantityArrayFromQuantityAndIntU_TypeSpecified()
    quantity = Quantity{Float64}(-4.4, lengthDim, defaultInternalUnits)
    returnedArray = QuantityArray{Float32}(quantity, intu2)
    correctFields = Dict([
        ("value", Array{Float32}([-2.2])),
        ("dimension", lengthDim),
        ("internal units", intu2),
        ("value type", Array{Float32})
    ])

    examples = [
        (returnedArray, correctFields)
    ]
    return examples
end

function canConstructQuantityArrayFromQuantity_TypeSpecified()
    examples = _getExamplesFor_canConstructQuantityArrayFromQuantity_TypeSpecified()
    return _checkQuantityArrayConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructQuantityArrayFromQuantity_TypeSpecified()
    quantity = Quantity{Float64}(-4.4, lengthDim, intu2)
    returnedArray = QuantityArray{Float32}(quantity)
    correctFields = Dict([
        ("value", Array{Float32}([-4.4])),
        ("dimension", lengthDim),
        ("internal units", intu2),
        ("value type", Array{Float32})
    ])

    examples = [
        (returnedArray, correctFields)
    ]
    return examples
end

function canConstructQuantityArrayFromSimpleQuantityAndIntU_TypeSpecified()
    examples = _getExamplesFor_canConstructQuantityArrayFromSimpleQuantityAndIntU_TypeSpecified()
    return _checkQuantityArrayConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructQuantityArrayFromSimpleQuantityAndIntU_TypeSpecified()
    simpleQuantity = Int64(-7) * ucat.meter
    returnedArray = QuantityArray{Float32}(simpleQuantity, intu2)
    correctFields = Dict([
        ("value", Array{Float32}([-3.5])),
        ("dimension", lengthDim),
        ("internal units", intu2),
        ("value type", Array{Float32})
    ])

    examples = [
        (returnedArray, correctFields)
    ]
    return examples
end

function canConstructQuantityArrayFromSimpleQuantity_TypeSpecified()
    examples = _getExamplesFor_canConstructQuantityArrayFromSimpleQuantity_TypeSpecified()
    return _checkQuantityArrayConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructQuantityArrayFromSimpleQuantity_TypeSpecified()
    simpleQuantity = Int64(-7) * ucat.meter
    returnedArray = QuantityArray{Float32}(simpleQuantity)
    correctFields = Dict([
        ("value", Array{Float32}([-7.0])),
        ("dimension", lengthDim),
        ("internal units", defaultInternalUnits),
        ("value type", Array{Float32})
    ])

    examples = [
        (returnedArray, correctFields)
    ]
    return examples
end

function canConvertQuantityArrayTypeParameter()
    examples = _getExamplesFor_canConvertQuantityArrayTypeParameter()
    return TestingTools.testDyadicFunction(Base.convert, examples)
end

function _getExamplesFor_canConvertQuantityArrayTypeParameter()
    examples = [
        ( QuantityArray{Float32}, QuantityArray{Float64}([7.1], lengthDim, intu2), QuantityArray{Float32}([7.1], lengthDim, intu2) ),
        ( QuantityArray{UInt16}, QuantityArray{Float64}([16], lengthDim, intu2), QuantityArray{UInt16}([16],lengthDim, intu2) ),
        ( QuantityArray{Float16}, QuantityArray{Int64}([16], lengthDim, intu2), QuantityArray{Float16}([16], lengthDim, intu2) )
    ]
end

end # module
