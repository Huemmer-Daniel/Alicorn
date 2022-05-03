module SimpleQuantityArrayTests

using Alicorn
using Test
using ..TestingTools

const ucat = UnitCatalogue()

function run()
    @testset "SimpleQuantityArray" begin
        # Constructors
        @test canConstructFromArrayAndUnit()
        @test canConstructFromArrayAndAbstractUnit()
        @test canConstructFromArray()
        @test canConstructFromArrayAndUnit_TypeSpecified()
        @test canConstructFromArray_TypeSpecified()

        # Methods for creating a SimpleQuantityArray
        @test AbstractArray_AbstractUnit_multiplication()
        @test AbstractArray_AbstractUnit_division()

        @test Array_UnitPrefix_BaseUnit__multiplication_implemented()
        @test Array_UnitPrefix_UnitFactor__multiplication_implemented()
        @test Array_UnitPrefix_BaseUnit__division_implemented()
        @test Array_UnitPrefix_UnitFactor__division_implemented()
    end
end

## Constructors

function canConstructFromArrayAndUnit()
    examples = _getExamplesFor_canConstructFromArrayAndUnit()
    return _checkConstructorExamples(examples)
end

function _getExamplesFor_canConstructFromArrayAndUnit()
    realValue = TestingTools.generateRandomReal(dim=2)
    unit1 = TestingTools.generateRandomUnit()
    sqArray1 = SimpleQuantityArray(realValue, unit1)
    correctFields1 = Dict([
        ("value", realValue),
        ("unit", unit1)
    ])

    complexValue = TestingTools.generateRandomComplex(dim=2)
    unit2 = TestingTools.generateRandomUnit()
    sqArray2 = SimpleQuantityArray(complexValue, unit2)
    correctFields2 = Dict([
        ("value", complexValue),
        ("unit", unit2)
    ])

    examples = [
        (sqArray1, correctFields1),
        (sqArray2, correctFields2)
    ]
    return examples
end

function _checkConstructorExamples(examples::Array)
    correct = true
    for (sqArray, correctFields) in examples
        correct &= _verifyHasCorrectFields(sqArray, correctFields)
    end
    return correct
end

function _verifyHasCorrectFields(sqArray::SimpleQuantityArray, correctFields::Dict{String,Any})
    correctValue = (sqArray.value == correctFields["value"])
    correctUnit = (sqArray.unit == correctFields["unit"])
    correct = correctValue && correctUnit
    return correct
end

function canConstructFromArrayAndAbstractUnit()
    examples = _getExamplesFor_canConstructFromArrayAndAbstractUnit()
    return _checkConstructorExamples(examples)
end

function _getExamplesFor_canConstructFromArrayAndAbstractUnit()
    realValue = TestingTools.generateRandomReal(dim=2)
    unitFactor = TestingTools.generateRandomUnitFactor()
    sqArray1 = SimpleQuantityArray(realValue, unitFactor)
    correctFields1 = Dict([
        ("value", realValue),
        ("unit", Unit(unitFactor))
    ])

    complexValue = TestingTools.generateRandomComplex(dim=2)
    baseUnit = TestingTools.generateRandomBaseUnit()
    sqArray2 = SimpleQuantityArray(complexValue, baseUnit)
    correctFields2 = Dict([
        ("value", complexValue),
        ("unit", Unit(baseUnit))
    ])

    unit = TestingTools.generateRandomUnit()
    sqArray3 = SimpleQuantityArray(complexValue, unit)
    correctFields3 = Dict([
        ("value", complexValue),
        ("unit", unit)
    ])

    examples = [
        (sqArray1, correctFields1),
        (sqArray2, correctFields2),
        (sqArray3, correctFields3)
    ]
    return examples
end

function canConstructFromArray()
    examples = _getExamplesFor_canConstructFromArray()
    return _checkConstructorExamples(examples)
end

function _getExamplesFor_canConstructFromArray()
    realValue = TestingTools.generateRandomReal(dim=2)
    sqArray1 = SimpleQuantityArray(realValue)
    correctFields1 = Dict([
        ("value", realValue),
        ("unit", Alicorn.unitlessUnit)
    ])

    complexValue = TestingTools.generateRandomComplex(dim=2)
    sqArray2 = SimpleQuantityArray(complexValue)
    correctFields2 = Dict([
        ("value", complexValue),
        ("unit", Alicorn.unitlessUnit)
    ])

    examples = [
        (sqArray1, correctFields1),
        (sqArray2, correctFields2)
    ]
    return examples
end

function _verifyHasCorrectFieldsAndType(sqArray::SimpleQuantityArray, correctFields::Dict{String,Any})
    correctValue = (sqArray.value == correctFields["value"])
    correctUnit = (sqArray.unit == correctFields["unit"])
    correctType = isa(sqArray.value, correctFields["value type"])
    return correctValue && correctUnit && correctType
end

function canConstructFromArrayAndUnit_TypeSpecified()
    examples = _getExamplesFor_canConstructFromArrayAndUnit_TypeSpecified()
    return _checkConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructFromArrayAndUnit_TypeSpecified()
    realValue = TestingTools.generateRandomReal(dim=(2,3))
    unitFactor = TestingTools.generateRandomUnitFactor()
    sqArray1 = SimpleQuantityArray{Float32}(realValue, unitFactor)
    correctFields1 = Dict([
        ("value", Array{Float32}(realValue)),
        ("unit", Unit(unitFactor)),
        ("value type", Array{Float32})
    ])

    value2 = [1.0, 2.0]
    baseUnit = TestingTools.generateRandomBaseUnit()
    sqArray2 = SimpleQuantityArray{Complex{Int32}}(value2, baseUnit)
    correctFields2 = Dict([
        ("value", Array{Complex{Int32}}(value2)),
        ("unit", Unit(baseUnit)),
        ("value type", Array{Complex{Int32}})
    ])

    value3 = [2, 3]
    unit = TestingTools.generateRandomUnit()
    sqArray3 = SimpleQuantityArray{Float16}(value3, unit)
    correctFields3 = Dict([
        ("value", Array{Float16}(value3)),
        ("unit", unit),
        ("value type", Array{Float16})
    ])

    examples = [
        (sqArray1, correctFields1),
        (sqArray2, correctFields2),
        (sqArray3, correctFields3)
    ]
    return examples
end

function _checkConstructorExamplesIncludingType(examples::Array)
    correct = true
    for (sqArray, correctFields) in examples
        correct &= _verifyHasCorrectFieldsAndType(sqArray, correctFields)
    end
    return correct
end

function canConstructFromArray_TypeSpecified()
    examples = _getExamplesFor_canConstructFromArray_TypeSpecified()
    return _checkConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructFromArray_TypeSpecified()
    realValue = TestingTools.generateRandomReal(dim=(2,3))
    sqArray1 = SimpleQuantityArray{Float32}(realValue)
    correctFields1 = Dict([
        ("value", Array{Float32}(realValue)),
        ("unit", Alicorn.unitlessUnit),
        ("value type", Array{Float32})
    ])

    value2 = [1.0, 2.0]
    sqArray2 = SimpleQuantityArray{Complex{Int32}}(value2)
    correctFields2 = Dict([
        ("value", Array{Complex{Int32}}(value2)),
        ("unit", Alicorn.unitlessUnit),
        ("value type", Array{Complex{Int32}})
    ])

    value3 = [2, 3]
    sqArray3 = SimpleQuantityArray{Float16}(value3)
    correctFields3 = Dict([
        ("value", Array{Float16}(value3)),
        ("unit", Alicorn.unitlessUnit),
        ("value type", Array{Float16})
    ])

    examples = [
        (sqArray1, correctFields1),
        (sqArray2, correctFields2),
        (sqArray3, correctFields3)
    ]
    return examples
end

## Methods for creating a SimpleQuantityArray

function AbstractArray_AbstractUnit_multiplication()
    examples = _getExamplesFor_AbstractArray_AbstractUnit_multiplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_AbstractArray_AbstractUnit_multiplication()
    baseUnit = TestingTools.generateRandomBaseUnit()
    unitFactor = TestingTools.generateRandomUnitFactor()
    unit = TestingTools.generateRandomUnit()

    array1 = TestingTools.generateRandomReal(dim=(3,4))
    array2 = TestingTools.generateRandomComplex(dim=(3,4))
    array3 = TestingTools.generateRandomReal(dim=(1,4))

    # format: factor1, factor2, correct result for factor1 * factor2
    # where factor1 is a subtype of AbstractArray and factor2 is a subtype of AbstractUnit
    examples = [
        # factor1 is a real number
        ( array1, baseUnit, SimpleQuantityArray(array1, baseUnit) ),
        ( array2, unitFactor, SimpleQuantityArray(array2, unitFactor) ),
        ( array3, unit, SimpleQuantityArray(array3, unit) )
    ]
end

function AbstractArray_AbstractUnit_division()
    examples = _getExamplesFor_AbstractArray_AbstractUnit_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_AbstractArray_AbstractUnit_division()
    baseUnit = TestingTools.generateRandomBaseUnit()
    unitFactor = TestingTools.generateRandomUnitFactor()
    unit = TestingTools.generateRandomUnit()

    array1 = TestingTools.generateRandomReal(dim=(3,4))
    array2 = TestingTools.generateRandomComplex(dim=(3,4))
    array3 = TestingTools.generateRandomReal(dim=(1,4))

    # format: dividend, divisor, correct result for dividend / divisor
    # where dividend is a subtype of AbstractArray and divisor is an AbstractUnit
    examples = [
        ( array1, baseUnit, SimpleQuantityArray(array1, inv(baseUnit) ) ),
        ( array2, unitFactor, SimpleQuantityArray(array2, inv(unitFactor) ) ),
        ( array3, unit, SimpleQuantityArray(array3, inv(unit)) ),
    ]
end

function Array_UnitPrefix_BaseUnit__multiplication_implemented()
    array = TestingTools.generateRandomReal(dim=(2,3))
    unitPrefix = TestingTools.generateRandomUnitPrefix()
    baseUnit = TestingTools.generateRandomBaseUnit()
    returnedResult = array * unitPrefix * baseUnit
    correctResult = array * (unitPrefix * baseUnit)
    return returnedResult == correctResult
end

function Array_UnitPrefix_UnitFactor__multiplication_implemented()
    array = TestingTools.generateRandomReal(dim=(2,3))
    unitPrefix = TestingTools.generateRandomUnitPrefix()
    unitFactor = UnitFactor(TestingTools.generateRandomBaseUnit())
    returnedResult = array * unitPrefix * unitFactor
    correctResult = array * (unitPrefix * unitFactor)
    return returnedResult == correctResult
end

function Array_UnitPrefix_BaseUnit__division_implemented()
    array = TestingTools.generateRandomReal(dim=(2,3))
    unitPrefix = TestingTools.generateRandomUnitPrefix()
    baseUnit = TestingTools.generateRandomBaseUnit()
    returnedResult = array / unitPrefix * baseUnit
    correctResult = array / (unitPrefix * baseUnit)
    return returnedResult == correctResult
end

function Array_UnitPrefix_UnitFactor__division_implemented()
    array = TestingTools.generateRandomReal(dim=(2,3))
    number = TestingTools.generateRandomReal()
    unitPrefix = TestingTools.generateRandomUnitPrefix()
    unitFactor = UnitFactor(TestingTools.generateRandomBaseUnit())
    returnedResult = array / unitPrefix * unitFactor
    correctResult = array / (unitPrefix * unitFactor)
    return returnedResult == correctResult
end

end # module
