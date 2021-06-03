module SimpleQuantityTests

using Alicorn
using Test
using ..TestingTools

const ucat = UnitCatalogue()

function run()
    @testset "SimpleQuantity" begin

        # Constructors
        @test canInstanciateSimpleQuantityWithRealValue()
        @test canInstanciateSimpleQuantityWithComplexValue()
        @test canInstanciateSimpleQuantityWithBaseUnit()
        @test canInstanciateSimpleQuantityWithUnitFactor()
        @test canInstanciateSimpleQuantityWithoutUnit()
        @test canInstanciateSimpleQuantityWithoutValue()
        @test fieldsCorrectlyInitialized()

        # Methods for constructing a SimpleQuantity
        @test Number_AbstractUnit_multiplication()
        @test Number_AbstractUnit_division()

        # 1. Unit conversion
        @test inUnitsOf_implemented()
        test_inUnitsOf_ErrorsForMismatchedUnits()
        @test inUnitsOf_implemented_forSimpleQuantityAsTargetUnit()
        @test inBasicSIUnits_implemented()
        @test SimpleQuantity_AbstractUnit_multiplication()
        @test AbstractUnit_SimpleQuantity_multiplication()
        @test SimpleQuantity_AbstractUnit_division()
        @test AbstractUnit_SimpleQuantity_division()

        # 2. Arithemtic unary and binary operators
        @test unaryPlus_implemented()
        @test unaryMinus_implemented()
        @test addition_implemented()
        @test subtraction_implemented()

        # TODO below

        @test valueOfDimensionless_implemented()
        test_valueOfDimensionless_ErrorsIfNotUnitless()

        # arithmetics
        @test equality_implemented()

        test_addition_ErrorsForMismatchedDimensions()
        test_subtraction_ErrorsForMismatchedDimensions()

        @test multiplication_implemented()
        @test multiplicationWithDimensionless_implemented()
        @test division_implemented()
        @test divisionByDimensionless_implemented()

        @test inv_implemented()
        @test exponentiation_implemented()
        @test sqrt_implemented()

        # array methods
        @test length_implemented()
        @test size_implemented()
    end
end

## Constructors

function canInstanciateSimpleQuantityWithRealValue()
    value = TestingTools.generateRandomReal()
    unit = TestingTools.generateRandomUnit()
    simpleQuantity = SimpleQuantity(value, unit)
    correctFields = Dict([
        ("value", value),
        ("unit", unit)
    ])
    return _verifyHasCorrectFields(simpleQuantity, correctFields)
end

function _verifyHasCorrectFields(simpleQuantity::SimpleQuantity, correctFields::Dict{String,Any})
    correctValue = (simpleQuantity.value == correctFields["value"])
    correctUnit = (simpleQuantity.unit == correctFields["unit"])
    correct = correctValue && correctUnit
    return correct
end

function canInstanciateSimpleQuantityWithComplexValue()
    value = TestingTools.generateRandomComplex()
    unit = TestingTools.generateRandomUnit()
    simpleQuantity = SimpleQuantity(value, unit)
    correctFields = Dict([
        ("value", value),
        ("unit", unit)
    ])
    return _verifyHasCorrectFields(simpleQuantity, correctFields)
end

function canInstanciateSimpleQuantityWithBaseUnit()
    value = TestingTools.generateRandomReal()
    baseUnit = TestingTools.generateRandomBaseUnit()
    simpleQuantity = SimpleQuantity(value, baseUnit)
    correctFields = Dict([
        ("value", value),
        ("unit", Unit(baseUnit))
    ])
    return _verifyHasCorrectFields(simpleQuantity, correctFields)
end

function canInstanciateSimpleQuantityWithUnitFactor()
    value = TestingTools.generateRandomReal()
    unitFactor = TestingTools.generateRandomUnitFactor()
    simpleQuantity = SimpleQuantity(value, unitFactor)
    correctFields = Dict([
        ("value", value),
        ("unit", Unit(unitFactor))
    ])
    return _verifyHasCorrectFields(simpleQuantity, correctFields)
end

function canInstanciateSimpleQuantityWithoutUnit()
    value = TestingTools.generateRandomReal()
    simpleQuantity = SimpleQuantity(value)
    correctFields = Dict([
        ("value", value),
        ("unit", Alicorn.unitlessUnit)
    ])
    return _verifyHasCorrectFields(simpleQuantity, correctFields)
end

function canInstanciateSimpleQuantityWithoutValue()
    unit = TestingTools.generateRandomUnit()
    simpleQuantity = SimpleQuantity(unit)
    correctFields = Dict([
        ("value", 1),
        ("unit", unit)
    ])
    return _verifyHasCorrectFields(simpleQuantity, correctFields)
end

function fieldsCorrectlyInitialized()
    (randomSimpleQuantity, randomSimpleQuantityFields) = TestingTools.generateRandomSimpleQuantityWithFields()
    return _verifyHasCorrectFields(randomSimpleQuantity, randomSimpleQuantityFields)
end

## Methods for constructing a SimpleQuantity

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


## 1. Unit conversion

function inUnitsOf_implemented()
    examples = _getExamplesFor_inUnitsOf()
    return TestingTools.testDyadicFunction(inUnitsOf, examples)
end

function _getExamplesFor_inUnitsOf()
    electronvoltInBasicSI = ucat.electronvolt.prefactor

    # format: SimpleQuantity, Unit, SimpleQuantity expressed in units of Unit
    examples = [
        ( 1 * Alicorn.unitlessUnit, Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit ),
        ( 7 * ucat.meter, ucat.milli*ucat.meter, 7000 * (ucat.milli*ucat.meter) ),
        ( 2 * (ucat.milli * ucat.second)^2, ucat.second^2, 2e-6 * ucat.second^2 ),
        ( 1 * ucat.joule, ucat.electronvolt, (1/electronvoltInBasicSI) * ucat.electronvolt ),
        ( 5 * Alicorn.unitlessUnit, Alicorn.unitlessUnit, 5 * Alicorn.unitlessUnit)
    ]
end

function test_inUnitsOf_ErrorsForMismatchedUnits()
    simpleQuantity = 7 * Alicorn.meter
    mismatchedUnit = Alicorn.second
    expectedError = Alicorn.Exceptions.DimensionMismatchError("dimensions of the quantity and the desired unit do not agree")
    @test_throws expectedError inUnitsOf(simpleQuantity, mismatchedUnit)
end

function inUnitsOf_implemented_forSimpleQuantityAsTargetUnit()
    examples = _getExamplesFor_inUnitsOf_forSimpleQuantityAsTargetUnit()
    return TestingTools.testDyadicFunction(inUnitsOf, examples)
end

function _getExamplesFor_inUnitsOf_forSimpleQuantityAsTargetUnit()
    electronvoltInBasicSI = ucat.electronvolt.prefactor

    # format: SimpleQuantity1, SimpleQuantity2, SimpleQuantity1 expressed in units of SimpleQuantity2
    examples = [
        ( 1 * Alicorn.unitlessUnit, 3 * Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit ),
        ( 7 * ucat.meter, 8.9 * (ucat.milli*ucat.meter), 7000 * (ucat.milli*ucat.meter) ),
        ( 2 * (ucat.milli * ucat.second)^2, pi * ucat.second^2, 2e-6 * ucat.second^2 ),
        ( 1 * ucat.joule, -8.0 * ucat.electronvolt, (1/electronvoltInBasicSI) * ucat.electronvolt ),
        ( 5 * Alicorn.unitlessUnit, -9 * Alicorn.unitlessUnit, 5 * Alicorn.unitlessUnit)
    ]
end

function inBasicSIUnits_implemented()
    examples = _getExamplesFor_inBasicSIUnits()
    return TestingTools.testMonadicFunction(inBasicSIUnits, examples)
end

function _getExamplesFor_inBasicSIUnits()
    # format: SimpleQuantity, SimpleQuantity expressed in terms of basic SI units
    examples = [
        ( 1 * Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit ),
        ( 1 * Alicorn.meter, 1 * Alicorn.meter ),
        ( 4.2 * ucat.joule, 4.2 * Alicorn.kilogram * Alicorn.meter^2 / Alicorn.second^2 ),
        ( -4.5 * (ucat.mega * ucat.henry)^2, -4.5e12 * Alicorn.kilogram^2 * Alicorn.meter^4 * Alicorn.second^-4 * Alicorn.ampere^-4 ),
        ( 1 * ucat.hour, 3600 * Alicorn.second )
    ]
    return examples
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

function AbstractUnit_SimpleQuantity_multiplication()
    examples = _getExamplesFor_AbstractUnit_SimpleQuantity_multiplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_AbstractUnit_SimpleQuantity_multiplication()
    value = TestingTools.generateRandomReal()
    unit1 = TestingTools.generateRandomUnit()
    baseUnit = TestingTools.generateRandomBaseUnit()
    unitFactor = TestingTools.generateRandomUnitFactor()
    unit2 = TestingTools.generateRandomUnit()

    # format: factor1, factor2, correct result for factor1 * factor2
    # where factor1 is an AbstractUnit and factor2 is a SimpleQuanity
    examples = [
        ( baseUnit, SimpleQuantity(value, unit1), SimpleQuantity( value, baseUnit * unit1 ) ),
        ( unitFactor, SimpleQuantity(value, unit1), SimpleQuantity( value, unitFactor * unit1 ) ),
        ( unit2, SimpleQuantity(value, unit1), SimpleQuantity( value, unit2 * unit1 ) )
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

function AbstractUnit_SimpleQuantity_division()
    examples = _getExamplesFor_AbstractUnit_SimpleQuantity_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_AbstractUnit_SimpleQuantity_division()
    value = TestingTools.generateRandomReal()
    unit1 = TestingTools.generateRandomUnit()
    baseUnit = TestingTools.generateRandomBaseUnit()
    unitFactor = TestingTools.generateRandomUnitFactor()
    unit2 = TestingTools.generateRandomUnit()

    # format: dividend, divisor, correct result for dividend / divisor
    # where dividend is an AbstractUnit and divisor is a SimpleQuanity
    examples = [
        ( baseUnit, SimpleQuantity(value, unit1), SimpleQuantity( 1/value, baseUnit / unit1  ) ),
        ( unitFactor, SimpleQuantity(value, unit1), SimpleQuantity( 1/value, unitFactor / unit1  ) ),
        ( unit2, SimpleQuantity(value, unit1), SimpleQuantity( 1/value, unit2 / unit1  ) )
    ]
    return examples
end

## 2. Arithemtic unary and binary operators

function unaryPlus_implemented()
    randomSimpleQuantity = TestingTools.generateRandomSimpleQuantity()
    correct = (randomSimpleQuantity == +randomSimpleQuantity)
    return correct
end

function unaryMinus_implemented()
    examples = _getExamplesFor_unaryMinus()
    return TestingTools.testMonadicFunction(Base.:-, examples)
end

function _getExamplesFor_unaryMinus()
    # format: quantity, correct result for -quantity
    examples = [
        ( 7.5 * ucat.meter, -7.5 * ucat.meter),
        ( (-3.4 + 8.7im) * ucat.ampere, (3.4 - 8.7im) * ucat.ampere)
    ]
    return examples
end

function addition_implemented()
    examples = _getExamplesFor_addition()
    return TestingTools.testDyadicFunction(Base.:+, examples)
end

function _getExamplesFor_addition()
    # format: addend1, addend2, correct sum
    examples = [
        ( 2 * Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit, 3 * Alicorn.unitlessUnit ),
        ( 7 * ucat.meter, 2 * (ucat.milli * ucat.meter), 7.002 * ucat.meter ),
        ( 2 * (ucat.milli * ucat.meter), 7 * ucat.meter , 7.002e3 * (ucat.milli * ucat.meter) )
    ]
    return examples
end

function subtraction_implemented()
    examples = _getExamplesFor_subtraction()
    return TestingTools.testDyadicFunction(Base.:-, examples)
end

function _getExamplesFor_subtraction()
    # format: addend1, addend2, correct sum
    examples = [
        ( 2 * Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit ),
        ( 7 * ucat.meter, 2 * (ucat.milli * ucat.meter), 6.998 * ucat.meter ),
        ( 2 * (ucat.milli * ucat.meter), 7 * ucat.meter , -6.998e3 * (ucat.milli * ucat.meter) )
    ]
    return examples
end


## TODO below

function valueOfDimensionless_implemented()
    examples = _getExamplesFor_valueOfDimensionless()
    return TestingTools.testMonadicFunction(valueOfDimensionless, examples)
end

function _getExamplesFor_valueOfDimensionless()
    # format: quantity, correct result for valueOfDimensionless(quantity)
    examples = [
        (SimpleQuantity(7), 7),
        (SimpleQuantity(7, ucat.meter * (ucat.centi * ucat.meter)^-1 ), 700)
    ]
    return examples
end

function test_valueOfDimensionless_ErrorsIfNotUnitless()
    simpleQuantity = 7 * Alicorn.meter
    expectedError = Alicorn.Exceptions.DimensionMismatchError("quantity is not dimensionless")
    @test_throws expectedError valueOfDimensionless(simpleQuantity)
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


function test_addition_ErrorsForMismatchedDimensions()
    (mismatchedAddend1, mismatchedAddend2) = _generateMismatchedAddends()
    expectedError = Alicorn.Exceptions.DimensionMismatchError("summands are not of the same physical dimension")
    @test_throws expectedError (mismatchedAddend1 + mismatchedAddend2)
end

function _generateMismatchedAddends()
    unit = TestingTools.generateRandomUnit()
    mismatchedUnit = unit * Alicorn.meter

    value = TestingTools.generateRandomReal()
    mismatchedAddend1 = value * unit
    mismatchedAddend2 = (2*value) * mismatchedUnit

    return (mismatchedAddend1, mismatchedAddend2)
end

function test_subtraction_ErrorsForMismatchedDimensions()
    (mismatchedAddend1, mismatchedAddend2) = _generateMismatchedAddends()
    expectedError = Alicorn.Exceptions.DimensionMismatchError("summands are not of the same physical dimension")
    @test_throws expectedError (mismatchedAddend1 - mismatchedAddend2)
end

function multiplication_implemented()
    examples = _getExamplesFor_multiplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_multiplication()
    # format: factor1, factor2, correct product factor1 * factor2
    examples = [
        ( 1 * Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit ),
        ( 1 * Alicorn.unitlessUnit, 2 * ucat.second, 2 * ucat.second ),
        ( 2 * ucat.second, 1 * Alicorn.unitlessUnit, 2 * ucat.second ),
        ( 2.5 * ucat.meter,  2 * ucat.second, 5 * ucat.meter * ucat.second ),
        (2 * ucat.second, 2.5 * ucat.meter, 5 * ucat.second * ucat.meter ),
        ( -7 * ucat.lumen * (ucat.nano * ucat.second),  2.5 * (ucat.pico * ucat.second) , -17.5 * ucat.lumen * (ucat.nano * ucat.second) * (ucat.pico * ucat.second) ),
        ( 2 * (ucat.milli * ucat.candela)^-4, 4 * (ucat.milli * ucat.candela)^2, 8 * (ucat.milli * ucat.candela)^-2 )
    ]
    return examples
end

function _getMixedExamplesFor_multiplication()
    # format: factor1, factor2, correct product factor1 * factor2
    examples = [
        ( [1 1] * Alicorn.unitlessUnit, 2 * Alicorn.unitlessUnit, [2 2] * Alicorn.unitlessUnit ),
        ( [1 0; 2 0] * Alicorn.unitlessUnit, 3 * ucat.second, [3 0; 6 0] * ucat.second ),
        ( 3 * ucat.second, [1 0; 2 0] * Alicorn.unitlessUnit, [3 0; 6 0] * ucat.second ),
        ( 2.5 * ucat.meter, [2 3] * ucat.second, [5 7.5] * ucat.meter * ucat.second ),
        ( [2 3] * ucat.second, 2.5 * ucat.meter, [5 7.5] * ucat.second * ucat.meter )
    ]
    return examples
end

function multiplicationWithDimensionless_implemented()
    examples = _getExamplesFor_multiplicationWithDimensionless()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_multiplicationWithDimensionless()
    # format: factor1, factor2, correct product factor1 * factor2
    examples = [
        ( 1 * Alicorn.unitlessUnit, 1, 1 * Alicorn.unitlessUnit ),
        ( 1, 1 * Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit ),
        ( 2 * ucat.second, 2.5, 5 * ucat.second ),
        ( 2.5, 2 * ucat.second, 5 * ucat.second ),
        ( -7 * ucat.lumen * (ucat.nano * ucat.second),  2.5 , -17.5 * ucat.lumen * (ucat.nano * ucat.second) ),
        ( 2 * (ucat.milli * ucat.candela)^-4, 4, 8 * (ucat.milli * ucat.candela)^-4 )
    ]
    return examples
end

function division_implemented()
    examples = _getExamplesFor_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_division()
    # format: factor1, factor2, correct product factor1 * factor2
    examples = [
        ( 1 * Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit ),
        ( 1 * Alicorn.unitlessUnit, 2 * ucat.second, 0.5 / ucat.second ),
        ( 2 * ucat.second, 1 * Alicorn.unitlessUnit, 2 * ucat.second ),
        ( 2.5 * ucat.meter,  2 * ucat.second, 1.25 * ucat.meter / ucat.second ),
        ( 5 * ucat.second, 2 * ucat.meter, 2.5 * ucat.second / ucat.meter ),
        ( -7 * ucat.lumen * (ucat.nano * ucat.second),  2 * (ucat.pico * ucat.second) , -3.5 * ucat.lumen * (ucat.nano * ucat.second) / (ucat.pico * ucat.second) ),
        ( 2 * (ucat.milli * ucat.candela)^-4, 4 * (ucat.milli * ucat.candela)^2, 0.5 * (ucat.milli * ucat.candela)^-6 )
    ]
    return examples
end

function divisionByDimensionless_implemented()
    examples = _getExamplesFor_divisionByDimensionless()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end


function _getExamplesFor_divisionByDimensionless()
    # format: factor1, factor2, correct product factor1 * factor2
    examples = [
        ( 1 * Alicorn.unitlessUnit, 2 , 1/2 * Alicorn.unitlessUnit ),
        ( 2, 1 * Alicorn.unitlessUnit , 2 * Alicorn.unitlessUnit ),
        ( 4, 2 * ucat.second, 2 / ucat.second ),
        ( 2 * ucat.second, 4, 1/2 * ucat.second ),
        ( -7 * ucat.lumen * (ucat.nano * ucat.second), 2, -3.5 * ucat.lumen * (ucat.nano * ucat.second) ),
        ( 2, -4 * (ucat.milli * ucat.candela)^2, -0.5 * (ucat.milli * ucat.candela)^-2 )
    ]
    return examples
end

function inv_implemented()
    examples = _getExamplesFor_inv()
    return TestingTools.testMonadicFunction(Base.inv, examples)
end

function _getExamplesFor_inv()
    # format: SimpleQuantity, correct result for SimpleQuantity^-1
    examples = [
        ( 1 * Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit),
        ( 2 * ucat.meter, 0.5 * ucat.meter^-1),
        ( -5 * (ucat.femto * ucat.meter)^-1 * ucat.joule, -0.2 * (ucat.femto * ucat.meter) * ucat.joule^-1 )
    ]
    return examples
end

function exponentiation_implemented()
    examples = _getExamplesFor_exponentiation()
    return TestingTools.testDyadicFunction(Base.:^, examples)
end

function _getExamplesFor_exponentiation()
    # format: SimpleQuantity, exponent, correct result for SimpleQuantity^exponent
    examples = [
        ( 1 * Alicorn.unitlessUnit, 1, 1 * Alicorn.unitlessUnit ),
        ( 2 * ucat.meter, 0, 1 * Alicorn.unitlessUnit),
        ( 2 * ucat.meter, 1, 2 * ucat.meter ),
        ( 2.0 * ucat.meter, -1, 0.5 / ucat.meter),
        ( 2.0 * (ucat.pico * ucat.meter)^2 * (ucat.tera * ucat.siemens)^-3, -2, 0.25 * (ucat.pico * ucat.meter)^-4 * (ucat.tera * ucat.siemens)^6 )
    ]
    return examples
end

function sqrt_implemented()
    examples = _getExamplesFor_sqrt()
    return TestingTools.testMonadicFunction(Base.sqrt, examples)
end

function _getExamplesFor_sqrt()
    # format: SimpleQuantity, correct result for sqrt(SimpleQuantity)
    examples = [
        ( 1 * Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit ),
        ( 4 * (ucat.pico * ucat.meter)^-3, 2 * (ucat.pico * ucat.meter)^-1.5 )
    ]
    return examples
end

# other methods
function length_implemented()
    examples = _getExamplesFor_length()
    return TestingTools.testMonadicFunction(Base.length, examples)
end

function _getExamplesFor_length()
    # format: SimpleQuantity, correct result for length(SimpleQuantity)
    examples = [
        ( 1123 * ucat.meter, 1 )
    ]
    return examples
end

function size_implemented()
    examples = _getExamplesFor_size()
    return TestingTools.testMonadicFunction(Base.size, examples)
end

function _getExamplesFor_size()
    # format: SimpleQuantity, correct result for size(SimpleQuantity)
    examples = [
        ( 1123 * ucat.meter, () )
    ]
    return examples
end

end # module
