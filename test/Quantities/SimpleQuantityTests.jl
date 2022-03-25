module SimpleQuantityTests

using Alicorn
using Test
using ..TestingTools

function run()
    @testset "SimpleQuantity" begin
        # Constructors
        @test canConstructFromNumberAndUnit()
        @test canConstructFromNumberAndAbstractUnit()
        @test canConstructFromNumber()
        @test canConstructFromAbstractUnit()
        @test canConstructFromNumberAndUnit_TypeSpecified()
        @test canConstructFromNumber_TypeSpecified()
        @test canConstructFromAbstractUnit_TypeSpecified()

        # Methods for creating a SimpleQuantity
        @test Number_AbstractUnit_multiplication()
        @test Number_AbstractUnit_division()

        @test Number_UnitPrefix_BaseUnit__multiplication_implemented()
        @test Number_UnitPrefix_UnitFactor__multiplication_implemented()
        @test Number_UnitPrefix_BaseUnit__division_implemented()
        @test Number_UnitPrefix_UnitFactor__division_implemented()
    end
end

## Constructors

function canConstructFromNumberAndUnit()
    examples = _getExamplesFor_canConstructFromNumberAndUnit()
    return _checkConstructorExamples(examples)
end

function _getExamplesFor_canConstructFromNumberAndUnit()
    realValue = TestingTools.generateRandomReal()
    unit1 = TestingTools.generateRandomUnit()
    sq1 = SimpleQuantity(realValue, unit1)
    correctFields1 = Dict([
        ("value", realValue),
        ("unit", unit1)
    ])

    complexValue = TestingTools.generateRandomComplex()
    unit2 = TestingTools.generateRandomUnit()
    sq2 = SimpleQuantity(complexValue, unit2)
    correctFields2 = Dict([
        ("value", complexValue),
        ("unit", unit2)
    ])

    examples = [
        (sq1, correctFields1),
        (sq2, correctFields2)
    ]
    return examples
end

function _checkConstructorExamples(examples::Array)
    correct = true
    for (simpleQuantity, correctFields) in examples
        correct &= _verifyHasCorrectFields(simpleQuantity, correctFields)
    end
    return correct
end

function _verifyHasCorrectFields(simpleQuantity::SimpleQuantity, correctFields::Dict{String,Any})
    correctValue = (simpleQuantity.value == correctFields["value"])
    correctUnit = (simpleQuantity.unit == correctFields["unit"])
    correct = correctValue && correctUnit
    return correct
end

function canConstructFromNumberAndAbstractUnit()
    examples = _getExamplesFor_canConstructFromNumberAndAbstractUnit()
    return _checkConstructorExamples(examples)
end

function _getExamplesFor_canConstructFromNumberAndAbstractUnit()
    realValue = TestingTools.generateRandomReal()
    unitFactor = TestingTools.generateRandomUnitFactor()
    sq1 = SimpleQuantity(realValue, unitFactor)
    correctFields1 = Dict([
        ("value", realValue),
        ("unit", Unit(unitFactor))
    ])

    complexValue = TestingTools.generateRandomComplex()
    baseUnit = TestingTools.generateRandomBaseUnit()
    sq2 = SimpleQuantity(complexValue, baseUnit)
    correctFields2 = Dict([
        ("value", complexValue),
        ("unit", Unit(baseUnit))
    ])

    unit = TestingTools.generateRandomUnit()
    sq3 = SimpleQuantity(complexValue, unit)
    correctFields3 = Dict([
        ("value", complexValue),
        ("unit", unit)
    ])

    examples = [
        (sq1, correctFields1),
        (sq2, correctFields2),
        (sq3, correctFields3)
    ]
    return examples
end

function canConstructFromNumber()
    examples = _getExamplesFor_canConstructFromNumber()
    return _checkConstructorExamples(examples)
end

function _getExamplesFor_canConstructFromNumber()
    realValue = TestingTools.generateRandomReal()
    sq1 = SimpleQuantity(realValue)
    correctFields1 = Dict([
        ("value", realValue),
        ("unit", Alicorn.unitlessUnit)
    ])

    complexValue = TestingTools.generateRandomComplex()
    sq2 = SimpleQuantity(complexValue)
    correctFields2 = Dict([
        ("value", complexValue),
        ("unit", Alicorn.unitlessUnit)
    ])

    examples = [
        (sq1, correctFields1),
        (sq2, correctFields2)
    ]
    return examples
end

function canConstructFromAbstractUnit()
    examples = _getExamplesFor_canConstructFromAbstractUnit()
    return _checkConstructorExamples(examples)
end

function _getExamplesFor_canConstructFromAbstractUnit()
    unitFactor = TestingTools.generateRandomUnitFactor()
    sq1 = SimpleQuantity(unitFactor)
    correctFields1 = Dict([
        ("value", 1),
        ("unit", Unit(unitFactor))
    ])

    baseUnit = TestingTools.generateRandomBaseUnit()
    sq2 = SimpleQuantity(baseUnit)
    correctFields2 = Dict([
        ("value", 1),
        ("unit", Unit(baseUnit))
    ])

    unit = TestingTools.generateRandomUnit()
    sq3 = SimpleQuantity(unit)
    correctFields3 = Dict([
        ("value", 1),
        ("unit", unit)
    ])

    examples = [
        (sq1, correctFields1),
        (sq2, correctFields2),
        (sq3, correctFields3)
    ]
    return examples
end

function canConstructFromNumberAndUnit_TypeSpecified()
    examples = _getExamplesFor_canConstructFromNumberAndUnit_TypeSpecified()
    return _checkConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructFromNumberAndUnit_TypeSpecified()
    realValue = TestingTools.generateRandomReal()
    unitFactor = TestingTools.generateRandomUnitFactor()
    sq1 = SimpleQuantity{Float32}(realValue, unitFactor)
    correctFields1 = Dict([
        ("value", Float32(realValue)),
        ("unit", Unit(unitFactor)),
        ("value type", Float32)
    ])

    value2 = 1.0
    baseUnit = TestingTools.generateRandomBaseUnit()
    sq2 = SimpleQuantity{Complex{Int32}}(value2, baseUnit)
    correctFields2 = Dict([
        ("value", Complex{Int32}(value2)),
        ("unit", Unit(baseUnit)),
        ("value type", Complex{Int32})
    ])

    value3 = 2
    unit = TestingTools.generateRandomUnit()
    sq3 = SimpleQuantity{Float16}(value3, unit)
    correctFields3 = Dict([
        ("value", Float16(value3)),
        ("unit", unit),
        ("value type", Float16)
    ])

    examples = [
        (sq1, correctFields1),
        (sq2, correctFields2),
        (sq3, correctFields3)
    ]
    return examples
end

function _checkConstructorExamplesIncludingType(examples::Array)
    correct = true
    for (simpleQuantity, correctFields) in examples
        correct &= _verifyHasCorrectFieldsAndType(simpleQuantity, correctFields)
    end
    return correct
end

function _verifyHasCorrectFieldsAndType(simpleQuantity::SimpleQuantity, correctFields::Dict{String,Any})
    correctValue = (simpleQuantity.value == correctFields["value"])
    correctUnit = (simpleQuantity.unit == correctFields["unit"])
    correctType = isa(simpleQuantity.value, correctFields["value type"])
    return correctValue && correctUnit && correctType
end

function canConstructFromNumber_TypeSpecified()
    examples = _getExamplesFor_canConstructFromNumber_TypeSpecified()
    return _checkConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructFromNumber_TypeSpecified()
    realValue = TestingTools.generateRandomReal()
    sq1 = SimpleQuantity{Float32}(realValue)
    correctFields1 = Dict([
        ("value", Float32(realValue)),
        ("unit", Alicorn.unitlessUnit),
        ("value type", Float32)
    ])

    value2 = 1.0
    sq2 = SimpleQuantity{Complex{Int32}}(value2)
    correctFields2 = Dict([
        ("value", Complex{Int32}(value2)),
        ("unit", Alicorn.unitlessUnit),
        ("value type", Complex{Int32})
    ])

    value3 = 2
    sq3 = SimpleQuantity{Float16}(value3)
    correctFields3 = Dict([
        ("value", Float16(2)),
        ("unit", Alicorn.unitlessUnit),
        ("value type", Float16)
    ])

    examples = [
        (sq1, correctFields1),
        (sq2, correctFields2),
        (sq3, correctFields3)
    ]
    return examples
end

function canConstructFromAbstractUnit_TypeSpecified()
    examples = _getExamplesFor_canConstructFromAbstractUnit_TypeSpecified()
    return _checkConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructFromAbstractUnit_TypeSpecified()
    unitFactor = TestingTools.generateRandomUnitFactor()
    sq1 = SimpleQuantity{Float32}(unitFactor)
    correctFields1 = Dict([
        ("value", Float32(1)),
        ("unit", Unit(unitFactor)),
        ("value type", Float32)
    ])

    baseUnit = TestingTools.generateRandomBaseUnit()
    sq2 = SimpleQuantity{Complex{Int32}}(baseUnit)
    correctFields2 = Dict([
        ("value", Complex{Int32}(1)),
        ("unit", Unit(baseUnit)),
        ("value type", Complex{Int32})
    ])

    unit = TestingTools.generateRandomUnit()
    sq3 = SimpleQuantity{Float16}(unit)
    correctFields3 = Dict([
        ("value", Float16(1)),
        ("unit", unit),
        ("value type", Float16)
    ])

    examples = [
        (sq1, correctFields1),
        (sq2, correctFields2),
        (sq3, correctFields3)
    ]
    return examples
end


## Methods for creating a SimpleQuantity

function Number_AbstractUnit_multiplication()
    examples = _getExamplesFor_Number_AbstractUnit_multiplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_Number_AbstractUnit_multiplication()
    baseUnit = TestingTools.generateRandomBaseUnit()
    unitFactor = TestingTools.generateRandomUnitFactor()
    unit = TestingTools.generateRandomUnit()

    scalar = TestingTools.generateRandomReal()

    # format: factor1, factor2, correct result for factor1 * factor2
    # where factor1 is of Number type and factor2 is a subtype of AbstractUnit
    examples = [
        # factor1 is a real number
        ( scalar, baseUnit, SimpleQuantity(scalar, baseUnit) ),
        ( scalar, unitFactor, SimpleQuantity(scalar, unitFactor) ),
        ( scalar, unit, SimpleQuantity(scalar, unit) ),
    ]
end

function Number_AbstractUnit_division()
    examples = _getExamplesFor_Number_AbstractUnit_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_Number_AbstractUnit_division()
    baseUnit = TestingTools.generateRandomBaseUnit()
    unitFactor = TestingTools.generateRandomUnitFactor()
    unit = TestingTools.generateRandomUnit()

    scalar = TestingTools.generateRandomReal()

    # format: dividend, divisor, correct result for dividend / divisor
    # where dividend is of Number type and divisor is an AbstractUnit
    examples = [
        ( scalar, baseUnit, SimpleQuantity(scalar, inv(baseUnit) ) ),
        ( scalar, unitFactor, SimpleQuantity(scalar, inv(unitFactor) ) ),
        ( scalar, unit, SimpleQuantity(scalar, inv(unit)) ),
    ]
end

function Number_UnitPrefix_BaseUnit__multiplication_implemented()
    number = TestingTools.generateRandomReal()
    unitPrefix = TestingTools.generateRandomUnitPrefix()
    baseUnit = TestingTools.generateRandomBaseUnit()
    returnedResult = number * unitPrefix * baseUnit
    correctResult = number * (unitPrefix * baseUnit)
    return returnedResult == correctResult
end

function Number_UnitPrefix_UnitFactor__multiplication_implemented()
    number = TestingTools.generateRandomReal()
    unitPrefix = TestingTools.generateRandomUnitPrefix()
    unitFactor = UnitFactor(TestingTools.generateRandomBaseUnit())
    returnedResult = number * unitPrefix * unitFactor
    correctResult = number * (unitPrefix * unitFactor)
    return returnedResult == correctResult
end

function Number_UnitPrefix_BaseUnit__division_implemented()
    number = TestingTools.generateRandomReal()
    unitPrefix = TestingTools.generateRandomUnitPrefix()
    baseUnit = TestingTools.generateRandomBaseUnit()
    returnedResult = number / unitPrefix * baseUnit
    correctResult = number / (unitPrefix * baseUnit)
    return returnedResult == correctResult
end

function Number_UnitPrefix_UnitFactor__division_implemented()
    number = TestingTools.generateRandomReal()
    unitPrefix = TestingTools.generateRandomUnitPrefix()
    unitFactor = UnitFactor(TestingTools.generateRandomBaseUnit())
    returnedResult = number / unitPrefix * unitFactor
    correctResult = number / (unitPrefix * unitFactor)
    return returnedResult == correctResult
end

end # module
