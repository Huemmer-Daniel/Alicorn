module quantity_typeConversionTests

using Alicorn
using Test
using ..TestingTools

const ucat = UnitCatalogue()
const intu = InternalUnits()

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
        test_QuantityWithTypeSpecified_errorsIfTypeUnsuitable()
        @test canConvertQuantityTypeParameter()

        # SimpleQuantityArray
        @test canConstructSimpleQuantityArrayFromSimpleQuantityArray()
        @test canConstructSimpleQuantityArrayFromQuantityArray()
        @test canConstructSimpleQuantityArrayFromSimpleQuantity()
        @test canConstructSimpleQuantityArrayFromQuantity()
        # CONTINUE: implement tests
        @test_skip canConstructSimpleQuantityArrayFromSimpleQuantityArray_TypeSpecified()
        @test_skip canConstructSimpleQuantityArrayFromQuantityArray_TypeSpecified()
        @test_skip canConstructSimpleQuantityArrayFromSimpleQuantity_TypeSpecified()
        @test_skip canConstructSimpleQuantityArrayFromQuantity_TypeSpecified()
        @test_skip canConvertSimpleQuantityArrayTypeParameter()


    end
end

## SimpleQuantity

function canConstructSimpleQuantityFromSimpleQuantity()
    sq1 = TestingTools.generateRandomSimpleQuantity()
    sq2 = SimpleQuantity(sq1)
    return sq1==sq2
end

function canConstructSimpleQuantityFromQuantity()
    examples = _getExamplesFor_canConstructSimpleQuantityFromQuantity()
    return _checkSimpleQuantityConstructorExamples(examples)
end

function _getExamplesFor_canConstructSimpleQuantityFromQuantity()
    intu = InternalUnits(length=2*ucat.milli*ucat.meter)
    quantity = Quantity(5 * ucat.meter, intu)
    sq = SimpleQuantity(quantity)
    correctFields = Dict([
        ("value", 5000),
        ("unit", Unit(ucat.milli*ucat.meter))
    ])

    examples = [
        (sq, correctFields)
    ]
    return examples
end

function _checkSimpleQuantityConstructorExamples(examples::Array)
    correct = true
    for (simpleQuantity, correctFields) in examples
        correct &= _verifySimpleQuantityHasCorrectFields(simpleQuantity, correctFields)
    end
    return correct
end

function _verifySimpleQuantityHasCorrectFields(simpleQuantity::SimpleQuantity, correctFields::Dict{String,Any})
    correctValue = (simpleQuantity.value == correctFields["value"])
    correctUnit = (simpleQuantity.unit == correctFields["unit"])
    correct = correctValue && correctUnit
    return correct
end

function canConstructSimpleQuantityFromSimpleQuantity_TypeSpecified()
    value = 6.7
    unit = TestingTools.generateRandomUnit()
    sq_64 = SimpleQuantity(Float64(value), unit)
    sq_32 = SimpleQuantity{Float32}( sq_64 )

    correctFields = Dict([
        ("value", Float32(value)),
        ("unit", unit),
        ("value type", Float32)
    ])
    return _verifySimpleQuantityHasCorrectFieldsAndType(sq_32, correctFields)
end

function _verifySimpleQuantityHasCorrectFieldsAndType(simpleQuantity::SimpleQuantity, correctFields::Dict{String,Any})
    correctValue = (simpleQuantity.value == correctFields["value"])
    correctUnit = (simpleQuantity.unit == correctFields["unit"])
    correctType = isa(simpleQuantity.value, correctFields["value type"])
    return correctValue && correctUnit && correctType
end

function canConstructSimpleQuantityFromQuantity_TypeSpecified()
    examples = _getExamplesFor_canConstructSimpleQuantityFromQuantity_TypeSpecified()
    return _checkSimpleQuantityConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructSimpleQuantityFromQuantity_TypeSpecified()
    intu = InternalUnits(length=2*ucat.milli*ucat.meter)
    quantity = Quantity(5.0 * ucat.meter, intu)
    sq = SimpleQuantity{Int32}(quantity)
    correctFields = Dict([
        ("value", 5000),
        ("unit", Unit(ucat.milli*ucat.meter)),
        ("value type", Int32),
    ])

    examples = [
        (sq, correctFields)
    ]
    return examples
end

function _checkSimpleQuantityConstructorExamplesIncludingType(examples::Array)
    correct = true
    for (simpleQuantity, correctFields) in examples
        correct &= _verifySimpleQuantityHasCorrectFieldsAndType(simpleQuantity, correctFields)
    end
    return correct
end

function canConvertSimpleQuantityTypeParameter()
    examples = _getExamplesFor_canConvertSimpleQuantityTypeParameter()
    return TestingTools.testDyadicFunction(Base.convert, examples)
end

function _getExamplesFor_canConvertSimpleQuantityTypeParameter()
    examples = [
        ( SimpleQuantity{Float32}, SimpleQuantity{Float64}(7.1, ucat.meter), SimpleQuantity{Float32}(7.1, ucat.meter) ),
        ( SimpleQuantity{UInt16}, SimpleQuantity{Float64}(16, ucat.meter), SimpleQuantity{UInt16}(16, ucat.meter) ),
        ( SimpleQuantity{Float16}, SimpleQuantity{Int64}(16, ucat.meter), SimpleQuantity{Float16}(16, ucat.meter) )
    ]
end

## Quantity

function canConstructQuantityFromQuantityAndIntU()
    intu2 = InternalUnits(length=2*ucat.meter)
    q2 = Quantity(4*ucat.meter^2, intu2)
    q1 = Quantity(q2, intu)
    return q1 == Quantity(4*ucat.meter^2, intu)
end

function canConstructQuantityFromQuantity()
    q1 = TestingTools.generateRandomQuantity()
    q2 = Quantity(q1)
    return q1==q2
end

function canConstructQuantityFromSimpleQuantityAndIntU()
    examples = _getExamplesFor_canConstructQuantityFromSimpleQuantityAndIntU()
    return _checkQuantityConstructorExamples(examples)
end

function _checkQuantityConstructorExamples(examples::Array)
    correct = true
    for (quantity, correctFields) in examples
        correct &= _verifyQuantityHasCorrectFields(quantity, correctFields)
    end
    return correct
end

function _verifyQuantityHasCorrectFields(quantity::Quantity, correctFields::Dict{String,Any})
    correctValue = (quantity.value == correctFields["value"])
    correctDimension = (quantity.dimension == correctFields["dimension"])
    correctIntU = (quantity.internalUnits == correctFields["internal units"])
    correct = correctValue && correctDimension && correctIntU
    return correct
end

function _getExamplesFor_canConstructQuantityFromSimpleQuantityAndIntU()
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

function canConstructQuantityFromSimpleQuantity()
    examples = _getExamplesFor_canConstructQuantityFromSimpleQuantity()
    return _checkQuantityConstructorExamples(examples)
end

function _getExamplesFor_canConstructQuantityFromSimpleQuantity()
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

function canConstructQuantityFromQuantityAndIntU_TypeSpecified()
    examples = _getExamplesFor_canConstructQuantityFromQuantityandIntU_TypeSpecified()
    return _checkQuantityConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructQuantityFromQuantityandIntU_TypeSpecified()
    intu2 = InternalUnits(length=2*ucat.meter)
    q_64_intu2 = Quantity(Float64(4)*ucat.meter^2, intu2)
    q_32_intu1 = Quantity{Float32}( q_64_intu2, intu )

    correctFields = Dict([
        ("value", Float32(4)),
        ("dimension", Dimension(L=2)),
        ("internal units", intu),
        ("value type", Float32)
    ])

    examples = [
        (q_32_intu1, correctFields)
    ]
    return examples
end

function canConstructQuantityFromQuantity_TypeSpecified()
    examples = _getExamplesFor_canConstructQuantityFromQuantity_TypeSpecified()
    return _checkQuantityConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructQuantityFromQuantity_TypeSpecified()
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

function canConstructQuantityFromSimpleQuantityAndIntU_TypeSpecified()
    examples = _getExamplesFor_canConstructQuantityFromSimpleQuantityAndIntU_TypeSpecified()
    return _checkQuantityConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructQuantityFromSimpleQuantityAndIntU_TypeSpecified()
    intu2 = InternalUnits(length=0.5*ucat.meter)
    sq_64 = SimpleQuantity(Float64(4)*ucat.meter^2)

    q1_32_intu2 = Quantity{Float32}(sq_64, intu2)
    correctFields1 = Dict([
        ("value", Float32(16) ),
        ("dimension", Dimension(L=2)),
        ("internal units", intu2),
        ("value type", Float32)
    ])

    examples = [
        (q1_32_intu2, correctFields1)
    ]
    return examples
end

function canConstructQuantityFromSimpleQuantity_TypeSpecified()
    examples = _getExamplesFor_canConstructQuantityFromSimpleQuantity_TypeSpecified()
    return _checkQuantityConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructQuantityFromSimpleQuantity_TypeSpecified()
    sq_64 = SimpleQuantity(Float64(4)*ucat.meter^2)

    q1_32 = Quantity{Float32}(sq_64)
    correctFields1 = Dict([
        ("value", Float32(4) ),
        ("dimension", Dimension(L=2)),
        ("internal units", InternalUnits()),
        ("value type", Float32)
    ])

    examples = [
        (q1_32, correctFields1)
    ]
    return examples
end

function test_QuantityWithTypeSpecified_errorsIfTypeUnsuitable()
    intu2 = InternalUnits(length=2*ucat.meter)
    sq_64 = SimpleQuantity(Float64(4.2)*ucat.meter^2)
    q_64 = Quantity(Float64(4.2)*ucat.meter^2, intu)
    expectedError = InexactError
    @test_throws expectedError Quantity{Int64}(q_64, intu2)
    @test_throws expectedError Quantity{Int64}(q_64)
    @test_throws expectedError Quantity{Int64}(sq_64, intu2)
    @test_throws expectedError Quantity{Int64}(sq_64)
end

function canConvertQuantityTypeParameter()
    examples = _getExamplesFor_canConvertQuantityTypeParameter()
    return TestingTools.testDyadicFunction(Base.convert, examples)
end

function _getExamplesFor_canConvertQuantityTypeParameter()
    dim = Dimension(L=-1)
    examples = [
        ( Quantity{Float32}, Quantity{Float64}(7.1, dim, intu), Quantity(Float32(7.1), dim, intu) ),
        ( Quantity{UInt16}, Quantity{Float64}(16, dim, intu), Quantity(UInt16(16), dim, intu) ),
        ( Quantity{Float16}, Quantity{Int64}(16, dim, intu), Quantity(Float16(16), dim, intu) )
    ]
end


## SimpleQuantityArray

function canConstructSimpleQuantityArrayFromSimpleQuantityArray()
    sqArray1 = TestingTools.generateRandomSimpleQuantityArray()
    sqArray2 = SimpleQuantityArray(sqArray1)
    return sqArray1==sqArray2
end

function canConstructSimpleQuantityArrayFromQuantityArray()
    examples = _getExamplesFor_canConstructSimpleQuantityArrayFromQuantityArray()
    return _checkSimpleQuantityArrayConstructorExamples(examples)
end

function _getExamplesFor_canConstructSimpleQuantityArrayFromQuantityArray()
    intu = InternalUnits(length=2*ucat.milli*ucat.meter)
    qArray = QuantityArray([5, 7] * ucat.meter, intu)
    sqArray = SimpleQuantityArray(qArray)
    correctFields = Dict([
        ("value", [5000, 7000]),
        ("unit", Unit(ucat.milli*ucat.meter))
    ])

    examples = [
        (sqArray, correctFields)
    ]
    return examples
end

function _checkSimpleQuantityArrayConstructorExamples(examples::Array)
    correct = true
    for (sqArray, correctFields) in examples
        correct &= _verifySimpleQuantityArrayHasCorrectFields(sqArray, correctFields)
    end
    return correct
end

function _verifySimpleQuantityArrayHasCorrectFields(sqArray::SimpleQuantityArray, correctFields::Dict{String,Any})
    correctValue = (sqArray.value == correctFields["value"])
    correctUnit = (sqArray.unit == correctFields["unit"])
    correct = correctValue && correctUnit
    return correct
end

function canConstructSimpleQuantityArrayFromSimpleQuantity()
    sq = TestingTools.generateRandomSimpleQuantity()
    sqArray1 = SimpleQuantityArray( [sq.value], sq.unit )
    sqArray2 = SimpleQuantityArray(sq)
    return sqArray1==sqArray2
end

function canConstructSimpleQuantityArrayFromQuantity()
    q = TestingTools.generateRandomQuantity()
    sq = SimpleQuantity(q)
    sqArray1 = SimpleQuantityArray( [sq.value], sq.unit )
    sqArray2 = SimpleQuantityArray(q)
    return sqArray1==sqArray2
end

end # module
