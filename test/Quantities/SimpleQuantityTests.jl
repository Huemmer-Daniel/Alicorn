module SimpleQuantityTests

using Alicorn
using Test
using ..TestingTools

function run()
    @testset "SimpleQuantity" begin
        # initialization
        @test canInstanciateSimpleQuantityWithRealValue()
        @test canInstanciateSimpleQuantityWithRealValuedArray()
        @test canInstanciateSimpleQuantityWithBaseUnit()
        @test canInstanciateSimpleQuantityWithUnitFactor()

        @test fieldsCorrectlyInitialized()

        @test equality_implemented()

        @test Any_AbstractUnit_multiplication()
        @test Any_AbstractUnit_division()

        @test SimpleQuantity_AbstractUnit_multiplication()
        @test SimpleQuantity_AbstractUnit_division()

        @test inUnitsOf_implemented()
        test_inUnitsOf_ErrorsForMismatchedUnits()
    end
end

function canInstanciateSimpleQuantityWithRealValue()
    value = TestingTools.generateRandomReal()
    unit = TestingTools.generateRandomUnit()
    return _testInstanciation(value, unit)
end

function _testInstanciation(value, unit::AbstractUnit)
    pass = false
    try
        SimpleQuantity(value, unit)
        pass = true
    catch
    end
    return pass
end

function canInstanciateSimpleQuantityWithRealValuedArray()
    value = TestingTools.generateRandomReal(dim=(2,3))
    unit = TestingTools.generateRandomUnit()
    return _testInstanciation(value, unit)
end

function canInstanciateSimpleQuantityWithBaseUnit()
    value = TestingTools.generateRandomReal()
    baseUnit = TestingTools.generateRandomBaseUnit()
    return _testInstanciation(value, baseUnit)
end

function canInstanciateSimpleQuantityWithUnitFactor()
    value = TestingTools.generateRandomReal()
    unitFactor = TestingTools.generateRandomUnitFactor()
    return _testInstanciation(value, unitFactor)
end

function fieldsCorrectlyInitialized()
    (randomSimpleQuantity, randomSimpleQuantityFields) = TestingTools.generateRandomSimpleQuantityWithFields()
    return _verifyHasCorrectFields(randomSimpleQuantity, randomSimpleQuantityFields)
end

function _verifyHasCorrectFields(simpleQuantity::SimpleQuantity, randomFields::Dict{String,Any})
    correctValue = (simpleQuantity.value == randomFields["value"])
    correctUnit = (simpleQuantity.unit == randomFields["unit"])
    correct = correctValue & correctUnit
    return correct
end

function equality_implemented()
    examples = _getExamplesFor_equality()
    return TestingTools.testDyadicFunction(Base.:(==), examples)
end

function _getExamplesFor_equality()
    value = TestingTools.generateRandomReal()
    unit = TestingTools.generateRandomUnit()

    randomSimpleQuantity1 = SimpleQuantity(value, unit)
    randomSimpleQuantity1Copy = deepcopy(randomSimpleQuantity1)

    randomSimpleQuantity2 = SimpleQuantity(value, unit^2)
    randomSimpleQuantity3 = SimpleQuantity(2*value, unit)

    # format: quantity1, quantity2, correct result for quantity1 == quantity2
    examples = [
        ( randomSimpleQuantity1, randomSimpleQuantity1Copy, true ),
        ( randomSimpleQuantity1, randomSimpleQuantity2, false ),
        ( randomSimpleQuantity1, randomSimpleQuantity3, false )
    ]
    return examples
end

function Any_AbstractUnit_multiplication()
    examples = _getExamplesFor_Any_AbstractUnit_multiplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_Any_AbstractUnit_multiplication()
    baseUnit = TestingTools.generateRandomBaseUnit()
    unitFactor = TestingTools.generateRandomUnitFactor()
    unit = TestingTools.generateRandomUnit()

    scalar = TestingTools.generateRandomReal()
    array = TestingTools.generateRandomReal( dim=(2,3) )

    # format: factor1, factor2, correct result for factor1 * factor2
    # where factor1 is of any type and factor2 is a subtype of AbstractUnit
    examples = [
        # factor1 is a real number
        ( scalar, baseUnit, SimpleQuantity(scalar, baseUnit) ),
        ( scalar, unitFactor, SimpleQuantity(scalar, unitFactor) ),
        ( scalar, unit, SimpleQuantity(scalar, unit) ),
        # factor1 is a real-valued array
        ( array, baseUnit, SimpleQuantity(array, baseUnit) ),
        ( array, unitFactor, SimpleQuantity(array, unitFactor) ),
        ( array, unit, SimpleQuantity(array, unit) )
    ]
end

function Any_AbstractUnit_division()
    examples = _getExamplesFor_Any_AbstractUnit_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_Any_AbstractUnit_division()
    baseUnit = TestingTools.generateRandomBaseUnit()
    unitFactor = TestingTools.generateRandomUnitFactor()
    unit = TestingTools.generateRandomUnit()

    scalar = TestingTools.generateRandomReal()
    array = TestingTools.generateRandomReal( dim=(2,3) )

    # format: dividend, divisor, correct result for dividend / divisor
    # where dividend is of any type and divisor is an AbstractUnit
    examples = [
        # factor1 is a real number
        ( scalar, baseUnit, SimpleQuantity(scalar, inv(baseUnit) ) ),
        ( scalar, unitFactor, SimpleQuantity(scalar, inv(unitFactor) ) ),
        ( scalar, unit, SimpleQuantity(scalar, inv(unit)) ),
        # factor1 is a real-valued array
        ( array, baseUnit, SimpleQuantity(array, inv(baseUnit)) ),
        ( array, unitFactor, SimpleQuantity(array, inv(unitFactor)) ),
        ( array, unit, SimpleQuantity(array, inv(unit)) )
    ]
end

function SimpleQuantity_AbstractUnit_multiplication()
    examples = _getExamplesFor_SimpleQuantity_AbstractUnit_multiplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_SimpleQuantity_AbstractUnit_multiplication()
    value = TestingTools.generateRandomReal()
    unit1 = TestingTools.generateRandomUnit()
    baseUnit = TestingTools.generateRandomBaseUnit()
    unitFactor = TestingTools.generateRandomUnitFactor()
    unit2 = TestingTools.generateRandomUnit()

    # format: factor1, factor2, correct result for factor1 * factor2
    # where factor1 is a SimpleQuanity and factor2 is an AbstractUnit
    examples = [
        ( SimpleQuantity(value, unit1), baseUnit, SimpleQuantity( value, unit1 * baseUnit ) ),
        ( SimpleQuantity(value, unit1), unitFactor, SimpleQuantity( value, unit1 * unitFactor ) ),
        ( SimpleQuantity(value, unit1), unit2, SimpleQuantity( value, unit1 * unit2 ) )
    ]
    return examples
end

function SimpleQuantity_AbstractUnit_division()
    examples = _getExamplesFor_SimpleQuantity_AbstractUnit_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_SimpleQuantity_AbstractUnit_division()
    value = TestingTools.generateRandomReal()
    unit1 = TestingTools.generateRandomUnit()
    baseUnit = TestingTools.generateRandomBaseUnit()
    unitFactor = TestingTools.generateRandomUnitFactor()
    unit2 = TestingTools.generateRandomUnit()

    # format: dividend, divisor, correct result for dividend / divisor
    # where dividend is a SimpleQuanity and divisor is an AbstractUnit
    examples = [
        ( SimpleQuantity(value, unit1), baseUnit, SimpleQuantity( value, unit1 / baseUnit ) ),
        ( SimpleQuantity(value, unit1), unitFactor, SimpleQuantity( value, unit1 / unitFactor ) ),
        ( SimpleQuantity(value, unit1), unit2, SimpleQuantity( value, unit1 / unit2 ) )
    ]
    return examples
end

function inUnitsOf_implemented()
    examples = _getExamplesFor_inUnitsOf()
    return TestingTools.testDyadicFunction(inUnitsOf, examples)
end

function _getExamplesFor_inUnitsOf()
    ucat = UnitCatalogue()

    electronvoltInBasicSI = ucat.electronvolt.prefactor

    # format: SimpleQuantity, Unit, SimpleQuantity expressed in units of Unit
    examples = [
        ( 7 * ucat.meter, ucat.milli*ucat.meter, 7000 * (ucat.milli*ucat.meter) ),
        ( 2 * (ucat.milli * ucat.second)^2, ucat.second^2, 2e-6 * ucat.second^2 ),
        ( 1 * ucat.joule, ucat.electronvolt, (1/electronvoltInBasicSI) * ucat.electronvolt ),
        ( 5 * Alicorn.unitlessUnit, Alicorn.unitlessUnit, 5 * Alicorn.unitlessUnit)
    ]
end

function test_inUnitsOf_ErrorsForMismatchedUnits()
    simpleQuantity = 7 * Alicorn.meter
    mismatchedUnit = Alicorn.second
    @test_throws Alicorn.Exceptions.DimensionMismatchError("dimensions of the quantity and the desired unit do not agree") inUnitsOf(simpleQuantity, mismatchedUnit)
end

end # module
