module SimpleQuantityTests

using Alicorn
using Test
using ..TestingTools

const ucat = UnitCatalogue()

function run()
    @testset "SimpleQuantity" begin
        # Constructors
        @test canConstructFromNumberAndUnit()
        @test canConstructFromNumberAndAbstractUnit()
        @test canConstructFromNumber()
        @test canConstructFromAbstractUnit()
        @test canConstructFromSimpleQuantity()
        @test canConstructFromSimpleQuantity_TypeSpecified()
        @test canConstructFromNumberAndAbstractUnit_TypeSpecified()
        @test canConstructFromNumber_TypeSpecified()
        @test canConstructFromAbstractUnit_TypeSpecified()

        # Type conversion
        @test canConvertTypeParameter()

        #- Methods for constructing a SimpleQuantity
        @test Number_AbstractUnit_multiplication()
        @test Number_AbstractUnit_division()

        #- AbstractQuantity interface
        # 1. Unit conversion
        @test inUnitsOf_implemented()
        test_inUnitsOf_ErrorsForMismatchedUnits()
        @test valueInUnitsOf_implemented()
        test_valueInUnitsOf_ErrorsForMismatchedUnits()
        @test valueInUnitsOf_implemented_forSimpleQuantityAsTargetUnit()
        @test inBasicSIUnits_implemented()
        @test valueOfDimensionless_implemented()
        test_valueOfDimensionless_ErrorsIfNotUnitless()
        @test SimpleQuantity_AbstractUnit_multiplication()
        @test AbstractUnit_SimpleQuantity_multiplication()
        @test SimpleQuantity_AbstractUnit_division()
        @test AbstractUnit_SimpleQuantity_division()

        # 2. Arithemtic unary and binary operators
        @test unaryPlus_implemented()
        @test unaryMinus_implemented()
        @test addition_implemented()
        test_addition_ErrorsForMismatchedDimensions()
        @test subtraction_implemented()
        test_subtraction_ErrorsForMismatchedDimensions()
        @test multiplication_implemented()
        @test SimpleQuantity_Number_mutliplication_implemented()
        @test Number_SimpleQuantity_mutliplication_implemented()
        @test SimpleQuantity_Array_mutliplication_implemented()
        @test Array_SimpleQuantity_mutliplication_implemented()
        @test division_implemented()
        @test SimpleQuantity_Array_division_implemented()
        @test Array_SimpleQuantity_division_implemented()
        @test SimpleQuantity_Number_division_implemented()
        @test Number_SimpleQuantity_division_implemented()
        @test inverseDivision_implemented()
        @test SimpleQuantity_Array_inverseDivision_implemented()
        @test SimpleQuantity_Number_inverseDivision_implemented()
        @test Number_SimpleQuantity_inverseDivision_implemented()
        @test exponentiation_implemented()
        @test inv_implemented()

        # 3. Numeric comparison
        @test equality_implemented()
        test_equality_ErrorsForMismatchedDimensions()
        @test isless_implemented()
        test_isless_ErrorsForMismatchedDimensions()
        @test isfinite_implemented()
        @test isinf_implemented()
        @test isnan_implemented()
        @test isapprox_implemented()
        test_isapprox_ErrorsForMismatchedDimensions()

        # 4. Rounding
        @test mod2pi_implemented()

        # 5. Sign and absolute value
        @test abs_implemented()
        @test abs2_implemented()
        @test sign_implemented()
        @test signbit_implemented()
        @test copysign_implemented()
        @test flipsign_implemented()

        # 6. Roots
        @test sqrt_implemented()
        @test cbrt_implemented()

        # 7. Literal zero
        @test zero_implemented()
        @test zero_dyadicImplemented()
        test_zero_dyadic_errorsOnNonnumberType()

        # 8. Complex numbers
        @test real_implemented()
        @test imag_implemented()
        @test conj_implemented()
        @test angle_implemented()

        # 9. Compatibility with array functions
        @test length_implemented()
        @test size_implemented()
        @test ndims_implemented()
        @test getindex_implemented()
        test_getindex_errorsForIndexGreaterOne()
    end
end

## ## Constructors

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

function canConstructFromSimpleQuantity()
    sq1 = TestingTools.generateRandomSimpleQuantity()
    sq2 = SimpleQuantity(sq1)
    return sq1==sq2
end

function canConstructFromSimpleQuantity_TypeSpecified()
    value = 6.7
    unit = TestingTools.generateRandomUnit()
    sq_64 = SimpleQuantity(Float64(value), unit)
    sq_32 = SimpleQuantity{Float32}( sq_64 )

    correctFields = Dict([
        ("value", Float32(value)),
        ("unit", unit),
        ("value type", Float32)
    ])
    return _verifyHasCorrectFieldsAndType(sq_32, correctFields)
end

function _verifyHasCorrectFieldsAndType(simpleQuantity::SimpleQuantity, correctFields::Dict{String,Any})
    correctValue = (simpleQuantity.value == correctFields["value"])
    correctUnit = (simpleQuantity.unit == correctFields["unit"])
    correctType = isa(simpleQuantity.value, correctFields["value type"])
    return correctValue && correctUnit && correctType
end

function canConstructFromNumberAndAbstractUnit_TypeSpecified()
    examples = _getExamplesFor_canConstructFromNumberAndAbstractUnit_TypeSpecified()
    return _checkConstructorExamplesIncludingType(examples)
end

function _getExamplesFor_canConstructFromNumberAndAbstractUnit_TypeSpecified()
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

## ## Type conversion

function canConvertTypeParameter()
    examples = _getExamplesFor_canConvertTypeParameter()
    return TestingTools.testDyadicFunction(Base.convert, examples)
end

function _getExamplesFor_canConvertTypeParameter()
    examples = [
        ( SimpleQuantity{Float32}, SimpleQuantity{Float64}(7.1, ucat.meter), SimpleQuantity{Float32}(7.1, ucat.meter) ),
        ( SimpleQuantity{UInt16}, SimpleQuantity{Float64}(16, ucat.meter), SimpleQuantity{UInt16}(16, ucat.meter) ),
        ( SimpleQuantity{Float16}, SimpleQuantity{Int64}(16, ucat.meter), SimpleQuantity{Float16}(16, ucat.meter) )
    ]
end

## #- Methods for constructing a SimpleQuantity

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

## #- AbstractQuantity interface
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

function valueInUnitsOf_implemented()
    examples = _getExamplesFor_valueInUnitsOf()
    return TestingTools.testDyadicFunction(valueInUnitsOf, examples)
end

function _getExamplesFor_valueInUnitsOf()
    # format: SimpleQuantity, Unit, value of SimpleQuantity expressed in units of Unit
    examples = [
        ( 1 * Alicorn.unitlessUnit, Alicorn.unitlessUnit, 1),
        ( 7 * ucat.meter, ucat.milli*ucat.meter, 7000 ),
        ( 2 * (ucat.milli * ucat.second)^2, ucat.second^2, 2e-6 ),
        ( 5 * Alicorn.unitlessUnit, Alicorn.unitlessUnit, 5 )
    ]
end

function test_valueInUnitsOf_ErrorsForMismatchedUnits()
    simpleQuantity = 7 * Alicorn.meter
    mismatchedUnit = Alicorn.second
    expectedError = Alicorn.Exceptions.DimensionMismatchError("dimensions of the quantity and the desired unit do not agree")
    @test_throws expectedError valueInUnitsOf(simpleQuantity, mismatchedUnit)
end

function valueInUnitsOf_implemented_forSimpleQuantityAsTargetUnit()
    examples = _getExamplesFor_valueInUnitsOf_forSimpleQuantityAsTargetUnit()
    return TestingTools.testDyadicFunction(valueInUnitsOf, examples)
end

function _getExamplesFor_valueInUnitsOf_forSimpleQuantityAsTargetUnit()
    # format: SimpleQuantity1, SimpleQuantity2, SimpleQuantity1 expressed in units of SimpleQuantity2
    examples = [
        ( 1 * Alicorn.unitlessUnit, 3 * Alicorn.unitlessUnit, 1/3  ),
        ( 7 * ucat.meter, 2 * (ucat.milli*ucat.meter), 3500  ),
        ( 2 * (ucat.milli * ucat.second)^2, 2 * ucat.second^2, 1e-6  ),
        ( 6 * Alicorn.unitlessUnit, -3 * Alicorn.unitlessUnit, -2 )
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

function test_addition_ErrorsForMismatchedDimensions()
    (mismatchedAddend1, mismatchedAddend2) = _generateDimensionMismatchedQuantities()
    expectedError = Alicorn.Exceptions.DimensionMismatchError("summands are not of the same physical dimension")
    @test_throws expectedError (mismatchedAddend1 + mismatchedAddend2)
end

function _generateDimensionMismatchedQuantities()
    unit = TestingTools.generateRandomUnit()
    mismatchedUnit = unit * Alicorn.meter

    value = TestingTools.generateRandomReal()
    mismatchedAddend1 = value * unit
    mismatchedAddend2 = (2*value) * mismatchedUnit

    return (mismatchedAddend1, mismatchedAddend2)
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

function test_subtraction_ErrorsForMismatchedDimensions()
    (mismatchedAddend1, mismatchedAddend2) = _generateDimensionMismatchedQuantities()
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


function SimpleQuantity_Number_mutliplication_implemented()
    examples = _getExamplesFor_SimpleQuantity_Number_mutliplication_()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_SimpleQuantity_Number_mutliplication_()
    # format: factor1, factor2, correct product factor1 * factor2
    examples = [
        ( 1 * Alicorn.unitlessUnit, 1, 1 * Alicorn.unitlessUnit ),
        ( 2 * ucat.second, 2.5, 5 * ucat.second ),
        ( -7 * ucat.lumen * (ucat.nano * ucat.second),  2.5 , -17.5 * ucat.lumen * (ucat.nano * ucat.second) ),
        ( 2 * (ucat.milli * ucat.candela)^-4, 4, 8 * (ucat.milli * ucat.candela)^-4 )
    ]
    return examples
end

function Number_SimpleQuantity_mutliplication_implemented()
    examples = _getExamplesFor_Number_SimpleQuantity_mutliplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_Number_SimpleQuantity_mutliplication()
    # format: factor1, factor2, correct product factor1 * factor2
    examples = [
        ( 1, 1 * Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit ),
        ( 2.5, 2 * ucat.second, 5 * ucat.second ),
        ( 2.5, -7 * ucat.lumen * (ucat.nano * ucat.second),   -17.5 * ucat.lumen * (ucat.nano * ucat.second) ),
        ( 4, 2 * (ucat.milli * ucat.candela)^-4, 8 * (ucat.milli * ucat.candela)^-4 )
    ]
    return examples
end

function SimpleQuantity_Array_mutliplication_implemented()
    examples = _getExamplesFor_SimpleQuantity_Array_mutliplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_SimpleQuantity_Array_mutliplication()
    # format: factor1, factor2, correct product factor1 * factor2
    examples = [
        ( 1 * Alicorn.unitlessUnit, ones(2,2), ones(2,2) * Alicorn.unitlessUnit ),
        ( 3 * ucat.second, [2, 2], [6, 6] * ucat.second ),
        ( 2 * ucat.meter, [1 1], [2 2] * ucat.meter ),
        ( 3.5 * ucat.meter, [2, 2], [7, 7] * ucat.meter ),
        ( 2 * ucat.second, [2.5; 2.5], [5.0; 5.0] * ucat.second ),
        ( -7 * ucat.lumen * (ucat.nano * ucat.second), [2.5 2.5] , [-17.5 -17.5] * ucat.lumen * (ucat.nano * ucat.second) ),
        ( 2 * (ucat.milli * ucat.candela)^-4, [4; 4], [8; 8] * (ucat.milli * ucat.candela)^-4 )
    ]
    return examples
end

function Array_SimpleQuantity_mutliplication_implemented()
    examples = _getExamplesFor_Array_SimpleQuantity_mutliplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_Array_SimpleQuantity_mutliplication()
    # format: factor1, factor2, correct product factor1 * factor2
    examples = [
        ( ones(2,2), 1 * Alicorn.unitlessUnit, ones(2,2) * Alicorn.unitlessUnit ),
        ( ones(2,2), 1 * Alicorn.unitlessUnit, ones(2,2) * Alicorn.unitlessUnit ),
        ( [2, 2], 3 * ucat.second, [6, 6] * ucat.second ),
        ( [1 1], 2 * ucat.meter, [2 2] * ucat.meter ),
        ( [2, 2], 3.5 * ucat.meter, [7, 7] * ucat.meter ),
        ( [2.5; 2.5], 2 * ucat.second, [5.0; 5.0] * ucat.second ),
        ( [2.5 2.5] , -7 * ucat.lumen * (ucat.nano * ucat.second), [-17.5 -17.5] * ucat.lumen * (ucat.nano * ucat.second) ),
        ( [4; 4], 2 * (ucat.milli * ucat.candela)^-4, [8; 8] * (ucat.milli * ucat.candela)^-4 )
    ]
    return examples
end

function division_implemented()
    examples = _getExamplesFor_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_division()
    # format: factor1, factor2, correct result for factor1 / factor2
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

function SimpleQuantity_Number_division_implemented()
    examples = _getExamplesFor_SimpleQuantity_Number_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_SimpleQuantity_Number_division()
    # format: factor1, factor2, correct result for factor1 / factor2
    examples = [
        ( 1 * Alicorn.unitlessUnit, 2 , 1/2 * Alicorn.unitlessUnit ),
        ( 2 * ucat.second, 4, 1/2 * ucat.second ),
        ( -7 * ucat.lumen * (ucat.nano * ucat.second), 2, -3.5 * ucat.lumen * (ucat.nano * ucat.second) )
    ]
    return examples
end

function Number_SimpleQuantity_division_implemented()
    examples = _getExamplesFor_Number_SimpleQuantity_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_Number_SimpleQuantity_division()
    # format: factor1, factor2, correct result for factor1 / factor2
    examples = [
        ( 2, 1 * Alicorn.unitlessUnit , 2 * Alicorn.unitlessUnit ),
        ( 4, 2 * ucat.second, 2 / ucat.second ),
        ( 2, -4 * (ucat.milli * ucat.candela)^2, -0.5 * (ucat.milli * ucat.candela)^-2 )
    ]
    return examples
end

function SimpleQuantity_Array_division_implemented()
    examples = _getExamplesFor_SimpleQuantity_Array_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_SimpleQuantity_Array_division()
    # format: factor1, factor2, correct result for factor1 / factor2
    examples = [
        ( 2 * Alicorn.unitlessUnit , [1; 2], (2 / [1; 2]) * Alicorn.unitlessUnit ),
        ( 8 * ucat.second, [2; 2], (8 / [2; 2]) * ucat.second ),
        ( 2 * (ucat.milli * ucat.candela)^2, [-4] , (2/[-4]) * (ucat.milli * ucat.candela)^2 )
    ]
    return examples
end

function Array_SimpleQuantity_division_implemented()
    examples = _getExamplesFor_Array_SimpleQuantity_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_Array_SimpleQuantity_division()
    # format: factor1, factor2, correct result for factor1 / factor2
    examples = [
        ( [1; 2], 2 * Alicorn.unitlessUnit, ([1; 2] / 2) * Alicorn.unitlessUnit ),
        ( [2; 2], 8 * ucat.second, ([2; 2] / 8) / ucat.second ),
        ( [-4], 2 * (ucat.milli * ucat.candela)^2, ([-4]/2) * (ucat.milli * ucat.candela)^-2 )
    ]
    return examples
end

function inverseDivision_implemented()
    examples = _getExamplesFor_inverseDivision()
    return TestingTools.testDyadicFunction(Base.:\, examples)
end

function _getExamplesFor_inverseDivision()
    # format: factor1, factor2, correct result for factor1 / factor2
    examples = [
        ( 1 * Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit ),
        ( 2 * ucat.second, 1 * Alicorn.unitlessUnit, 0.5 / ucat.second ),
        ( 1 * Alicorn.unitlessUnit, 2 * ucat.second, 2 * ucat.second ),
        ( 2 * ucat.second, 2.5 * ucat.meter, 1.25 * ucat.meter / ucat.second ),
        ( 2 * ucat.meter, 5 * ucat.second, 2.5 * ucat.second / ucat.meter ),
        ( 2 * (ucat.pico * ucat.second), -7 * ucat.lumen * (ucat.nano * ucat.second),  -3.5 * ucat.lumen * (ucat.nano * ucat.second) / (ucat.pico * ucat.second) ),
        ( 4 * (ucat.milli * ucat.candela)^2, 2 * (ucat.milli * ucat.candela)^-4, 0.5 * (ucat.milli * ucat.candela)^-6 )
    ]
    return examples
end

function SimpleQuantity_Number_inverseDivision_implemented()
    examples = _getExamplesFor_SimpleQuantity_Number_inverseDivision()
    return TestingTools.testDyadicFunction(Base.:\, examples)
end

function _getExamplesFor_SimpleQuantity_Number_inverseDivision()
    # format: factor1, factor2, correct result factor1 \ factor2
    examples = [
        ( 1 * Alicorn.unitlessUnit, 2, 2 * Alicorn.unitlessUnit ),
        ( 2 * ucat.second, 4, 2 / ucat.second ),
        ( -4 * (ucat.milli * ucat.candela)^2, 2, -0.5 * (ucat.milli * ucat.candela)^-2 )
    ]
    return examples
end

function Number_SimpleQuantity_inverseDivision_implemented()
    examples = _getExamplesFor_Number_SimpleQuantity_inverseDivision()
    return TestingTools.testDyadicFunction(Base.:\, examples)
end

function _getExamplesFor_Number_SimpleQuantity_inverseDivision()
    # format: factor1, factor2, correct result factor1 \ factor2
    examples = [
        ( 2 , 1 * Alicorn.unitlessUnit, 1/2 * Alicorn.unitlessUnit ),
        ( 4, 2 * ucat.second, 1/2 * ucat.second ),
        ( 2, -7 * ucat.lumen * (ucat.nano * ucat.second), -3.5 * ucat.lumen * (ucat.nano * ucat.second) )
    ]
    return examples
end

function SimpleQuantity_Array_inverseDivision_implemented()
    examples = _getExamplesFor_SimpleQuantity_Array_inverseDivision()
    return TestingTools.testDyadicFunction(Base.:\, examples)
end

function _getExamplesFor_SimpleQuantity_Array_inverseDivision()
    # format: factor1, factor2, correct result factor1 \ factor2
    examples = [
        ( 2 * Alicorn.unitlessUnit, [1; 2], (2 \ [1; 2] ) * Alicorn.unitlessUnit ),
        ( 8 * ucat.second, [2; 2], (8 \ [2; 2] ) / ucat.second ),
        ( 2 * (ucat.milli * ucat.candela)^2, [-4], (2 \ [-4]) * (ucat.milli * ucat.candela)^-2 )
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

## 3. Numeric comparison

function equality_implemented()
    examples = _getExamplesFor_equality()
    return TestingTools.testDyadicFunction(Base.:(==), examples)
end

function _getExamplesFor_equality()
    baseUnit = ucat.ampere

    sQuantity1 = SimpleQuantity(7, baseUnit)
    sQuantity1Copy = SimpleQuantity(7, baseUnit)

    sQuantity2 = SimpleQuantity(0.7, ucat.deca * baseUnit)
    sQuantity3 = SimpleQuantity(pi, baseUnit)
    sQuantity4 = SimpleQuantity(7, ucat.deca * baseUnit)

    # format: quantity1, quantity2, correct result for quantity1 == quantity2
    examples = [
        ( sQuantity1, sQuantity1Copy, true ),
        ( sQuantity1, sQuantity2, true ),
        ( sQuantity1, sQuantity3, false ),
        ( sQuantity1, sQuantity4, false )
    ]
    return examples
end

function test_equality_ErrorsForMismatchedDimensions()
    (mismatchedSQ1, mismatchedSQ2) = _generateDimensionMismatchedQuantities()
    expectedError = Alicorn.Exceptions.DimensionMismatchError("compared quantities are not of the same physical dimension")
    @test_throws expectedError (mismatchedSQ1 == mismatchedSQ2)
end

function isless_implemented()
    examples = _getExamplesFor_isless()
    return TestingTools.testDyadicFunction(Base.isless, examples)
end

function _getExamplesFor_isless()
    value = abs(TestingTools.generateRandomReal())
    baseUnit = TestingTools.generateRandomBaseUnit()

    sQuantity1 = SimpleQuantity(value, baseUnit)
    sQuantity2 = SimpleQuantity(-value, baseUnit)
    sQuantity3 = SimpleQuantity(2*value, baseUnit)
    sQuantity4 = SimpleQuantity(value, ucat.deci * baseUnit)

    # format: quantity1, quantity2, correct result for isless(quantity1, quantity2)
    examples = [
        ( sQuantity1, sQuantity2, false ),
        ( sQuantity2, sQuantity1, true ),
        ( sQuantity1, sQuantity3, true ),
        ( sQuantity1, sQuantity4, false )
    ]
    return examples
end

function test_isless_ErrorsForMismatchedDimensions()
    (mismatchedSQ1, mismatchedSQ2) = _generateDimensionMismatchedQuantities()
    expectedError = Alicorn.Exceptions.DimensionMismatchError("compared quantities are not of the same physical dimension")
    @test_throws expectedError isless(mismatchedSQ1, mismatchedSQ2)
end

function isfinite_implemented()
    examples = _getExamplesFor_isfinite()
    return TestingTools.testMonadicFunction(Base.isfinite, examples)
end

function _getExamplesFor_isfinite()
    unit = TestingTools.generateRandomUnit()

    sQuantity1 = SimpleQuantity(Inf, unit)
    sQuantity2 = SimpleQuantity(-Inf, unit)
    sQuantity3 = SimpleQuantity(NaN, unit)
    sQuantity4 = SimpleQuantity(pi, unit)

    # format: quantity1, quantity2, correct result for isless(quantity1, quantity2)
    examples = [
        ( sQuantity1, false ),
        ( sQuantity2, false ),
        ( sQuantity3, false ),
        ( sQuantity4, true )
    ]
    return examples
end

function isinf_implemented()
    examples = _getExamplesFor_isinf()
    return TestingTools.testMonadicFunction(Base.isinf, examples)
end

function _getExamplesFor_isinf()
    unit = TestingTools.generateRandomUnit()

    sQuantity1 = SimpleQuantity(Inf, unit)
    sQuantity2 = SimpleQuantity(-Inf, unit)
    sQuantity3 = SimpleQuantity(NaN, unit)
    sQuantity4 = SimpleQuantity(pi, unit)

    # format: quantity1, quantity2, correct result for isless(quantity1, quantity2)
    examples = [
        ( sQuantity1, true ),
        ( sQuantity2, true ),
        ( sQuantity3, false ),
        ( sQuantity4, false )
    ]
    return examples
end

function isnan_implemented()
    examples = _getExamplesFor_isnan()
    return TestingTools.testMonadicFunction(Base.isnan, examples)
end

function _getExamplesFor_isnan()
    unit = TestingTools.generateRandomUnit()

    sQuantity1 = SimpleQuantity(Inf, unit)
    sQuantity2 = SimpleQuantity(NaN, unit)
    sQuantity3 = SimpleQuantity(-NaN, unit)
    sQuantity4 = SimpleQuantity(pi, unit)

    # format: quantity1, quantity2, correct result for isless(quantity1, quantity2)
    examples = [
        ( sQuantity1, false ),
        ( sQuantity2, true ),
        ( sQuantity3, true ),
        ( sQuantity4, false )
    ]
    return examples
end

function isapprox_implemented()
    examples = _getExamplesFor_isapprox()
    return _test_isapprox_examples(examples)
end

function _getExamplesFor_isapprox()
    examples = [
        ( 7 * ucat.meter, 71 * (ucat.deci * ucat.meter), 0.01, false ),
        ( 7 * ucat.meter, 71 * (ucat.deci * ucat.meter), 0.015, true )
    ]
    return examples
end

function _test_isapprox_examples(examples::Array)
    pass = true
    for (sq1, sq2, rtol, correctResult) in examples
        pass &= ( isapprox(sq1, sq2, rtol=rtol) == correctResult )
    end
    return pass
end

function test_isapprox_ErrorsForMismatchedDimensions()
    (mismatchedSQ1, mismatchedSQ2) = _generateDimensionMismatchedQuantities()
    expectedError = Alicorn.Exceptions.DimensionMismatchError("compared quantities are not of the same physical dimension")
    @test_throws expectedError isapprox(mismatchedSQ1, mismatchedSQ2)
end

## 4. Rounding

function mod2pi_implemented()
    examples = _getExamplesFor_mod2pi()
    return TestingTools.testMonadicFunction(Base.mod2pi, examples)
end

function _getExamplesFor_mod2pi()
    # format: SimpleQuantity, correct result for mod2pi(SimpleQuantity)
    examples = [
        ( 6*pi * Alicorn.unitlessUnit, mod2pi(6*pi) * Alicorn.unitlessUnit ),
        ( -7.1*pi * Alicorn.ampere, mod2pi(-7.1*pi) * Alicorn.ampere )
    ]
    return examples
end

## 5. Sign and absolute value

function abs_implemented()
    examples = _getExamplesFor_abs()
    return TestingTools.testMonadicFunction(Base.abs, examples)
end

function _getExamplesFor_abs()
    # format: SimpleQuantity, correct result for abs(SimpleQuantity)
    examples = [
        ( 5.2 * ucat.joule, 5.2 * ucat.joule ),
        ( -7.1 * ucat.ampere, 7.1 * ucat.ampere ),
        ( (4 + 2im) * ucat.meter , sqrt(4^2 + 2^2) * ucat.meter )
    ]
    return examples
end

function abs2_implemented()
    examples = _getExamplesFor_abs2()
    return TestingTools.testMonadicFunction(Base.abs2, examples)
end

function _getExamplesFor_abs2()
    # format: SimpleQuantity, correct result for abs2(SimpleQuantity)
    examples = [
        ( 5.2 * ucat.joule, (5.2)^2 * (ucat.joule)^2 ),
        ( -7.1 * ucat.ampere, (7.1)^2 * (ucat.ampere)^2 ),
        ( (4 + 2im) * ucat.meter , (4^2 + 2^2) * (ucat.meter)^2 )
    ]
    return examples
end

function sign_implemented()
    examples = _getExamplesFor_sign()
    return TestingTools.testMonadicFunction(Base.sign, examples)
end

function _getExamplesFor_sign()
    # format: SimpleQuantity, correct result for sign(SimpleQuantity)
    examples = [
        ( 5.2 * ucat.joule, 1 ),
        ( -7.1 * ucat.ampere, -1 ),
        ( (4 + 2im) * ucat.meter , sign(4 + 2im) )
    ]
    return examples
end

function signbit_implemented()
    examples = _getExamplesFor_signbit()
    return TestingTools.testMonadicFunction(Base.signbit, examples)
end

function _getExamplesFor_signbit()
    # format: SimpleQuantity, correct result for signbit(SimpleQuantity)
    examples = [
        ( 5.2 * ucat.joule, false ),
        ( -7.1 * ucat.ampere, true )
    ]
    return examples
end

function copysign_implemented()
    examples = _getExamplesFor_copysign()
    return TestingTools.testDyadicFunction(Base.copysign, examples)
end

function _getExamplesFor_copysign()
    # format: SimpleQuantity, object, correct result for copysign(SimpleQuantity, object)
    examples = [
        ( 5.2 * ucat.joule, -3.5, -5.2 * ucat.joule ),
        ( 5.2 * ucat.joule, 3.5, 5.2 * ucat.joule ),
        ( 3.5, 5.2 * ucat.joule, 3.5 ),
        ( 3.5, -5.2 * ucat.joule, -3.5 ),
        ( -3.5, 5.2 * ucat.joule, 3.5 ),
        ( -3.5, -5.2 * ucat.joule, -3.5 ),
        ( -7.1 * ucat.ampere, 5.2 * ucat.joule, 7.1 * ucat.ampere),
        ( -7.1 * ucat.ampere, -5.2 * ucat.joule, -7.1 * ucat.ampere ),
        ( 7.1 * ucat.ampere, 5.2 * ucat.joule, 7.1 * ucat.ampere ),
        ( 7.1 * ucat.ampere, -5.2 * ucat.joule, -7.1 * ucat.ampere )
    ]
    return examples
end

function flipsign_implemented()
    examples = _getExamplesFor_flipsign()
    return TestingTools.testDyadicFunction(Base.flipsign, examples)
end

function _getExamplesFor_flipsign()
    # format: SimpleQuantity, correct result for flipsign(SimpleQuantity, object)
    examples = [
        ( 5.2 * ucat.joule, -5.2 * ucat.joule, -5.2 * ucat.joule ),
        ( -5.2 * ucat.joule, -5.2 * ucat.joule, 5.2 * ucat.joule ),
        ( 5.2 * ucat.joule, 5.2 * ucat.joule, 5.2 * ucat.joule ),
        ( -5.2 * ucat.joule, -5.2 * ucat.joule, 5.2 * ucat.joule ),
        ( 3.5, -5.2 * ucat.joule, -3.5 ),
        ( -3.5, -5.2 * ucat.joule, 3.5 ),
        ( 3.5, 5.2 * ucat.joule, 3.5 ),
        ( 3.5, -5.2 * ucat.joule, -3.5 ),
        ( 5.2 * ucat.joule, -3.5, -5.2 * ucat.joule ),
        ( -5.2 * ucat.joule, -3.5, 5.2 * ucat.joule ),
        ( 5.2 * ucat.joule, 3.5, 5.2 * ucat.joule ),
        ( -5.2 * ucat.joule, 3.5, -5.2 * ucat.joule )
    ]
    return examples
end


## 6. Roots

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

function cbrt_implemented()
    examples = _getExamplesFor_cbrt()
    return TestingTools.testMonadicFunction(Base.cbrt, examples)
end

function _getExamplesFor_cbrt()
    # format: SimpleQuantity, correct result for cbrt(SimpleQuantity)
    examples = [
        ( 1 * Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit ),
        ( 4 * (ucat.pico * ucat.meter)^-3, cbrt(4) * (ucat.pico * ucat.meter)^-1 )
    ]
    return examples
end

## 7. Literal zero

function zero_implemented()
    examples = _getExamplesFor_zero()
    return TestingTools.testMonadicFunction(Base.zero, examples)
end

function _getExamplesFor_zero()
    # format: SimpleQuantity, correct result for zero(SimpleQuantity)
    examples = [
        ( 1 * Alicorn.unitlessUnit, zero(Int64) * Alicorn.unitlessUnit ),
        ( 4.0 * (ucat.pico * ucat.meter)^-3, zero(Float64) * (ucat.pico * ucat.meter)^-3 )
    ]
    return examples
end

function zero_dyadicImplemented()
    examples = _getExamplesFor_zero_dyadic()
    return TestingTools.testDyadicFunction(Base.zero, examples)
end

function _getExamplesFor_zero_dyadic()
    # format: numberType, unit, correct result for zero(numberType, unit)
    examples = [
        ( UInt32, Alicorn.unitlessUnit, zero(UInt32) * Alicorn.unitlessUnit ),
        ( Float64, (ucat.pico * ucat.meter)^-3, zero(Float64) * (ucat.pico * ucat.meter)^-3 )
    ]
    return examples
end

function test_zero_dyadic_errorsOnNonnumberType()
    type = String
    expectedError = Core.DomainError(type, "type $type is not a subtype of Number")
    @test_throws expectedError zero(type, ucat.meter)
end

## 8. Complex numbers

function real_implemented()
    examples = _getExamplesFor_real()
    return TestingTools.testMonadicFunction(Base.real, examples)
end

function _getExamplesFor_real()
    # format: SimpleQuantity, correct result for real(SimpleQuantity)
    examples = [
        ( 1 * Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit ),
        ( 1im * Alicorn.unitlessUnit, 0 * Alicorn.unitlessUnit ),
        ( (4.0 + 2im) * (ucat.pico * ucat.meter)^-3, 4.0 * (ucat.pico * ucat.meter)^-3 )
    ]
    return examples
end

function imag_implemented()
    examples = _getExamplesFor_imag()
    return TestingTools.testMonadicFunction(Base.imag, examples)
end

function _getExamplesFor_imag()
    # format: SimpleQuantity, correct result for imag(SimpleQuantity)
    examples = [
        ( 1 * Alicorn.unitlessUnit, 0 * Alicorn.unitlessUnit ),
        ( 1im * Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit ),
        ( (4.0 + 2im) * (ucat.pico * ucat.meter)^-3, 2.0 * (ucat.pico * ucat.meter)^-3 )
    ]
    return examples
end

function conj_implemented()
    examples = _getExamplesFor_conj()
    return TestingTools.testMonadicFunction(Base.conj, examples)
end

function _getExamplesFor_conj()
    # format: SimpleQuantity, correct result for conj(SimpleQuantity)
    examples = [
        ( 1 * Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit ),
        ( 1im * Alicorn.unitlessUnit, -1im * Alicorn.unitlessUnit ),
        ( (4.0 + 2im) * (ucat.pico * ucat.meter)^-3, (4.0 - 2im) * (ucat.pico * ucat.meter)^-3 )
    ]
    return examples
end

function angle_implemented()
    examples = _getExamplesFor_angle()
    return TestingTools.testMonadicFunction(Base.angle, examples)
end

function _getExamplesFor_angle()
    # format: SimpleQuantity, correct result for angle(SimpleQuantity)
    examples = [
        ( 1 * Alicorn.unitlessUnit, 0 ),
        ( 1im * Alicorn.unitlessUnit, pi/2 ),
        ( (4.0 + 2im) * (ucat.pico * ucat.meter)^-3, angle(4.0 + 2im) )
    ]
    return examples
end


## 9. Compatibility with array functions

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

function ndims_implemented()
    examples = _getExamplesFor_ndims()
    return TestingTools.testMonadicFunction(Base.ndims, examples)
end

function _getExamplesFor_ndims()
    # format: SimpleQuantity, correct result for ndims(SimpleQuantity)
    examples = [
        ( 1123 * ucat.meter, 0 )
    ]
    return examples
end

function getindex_implemented()
    example = 7.6 * ucat.ampere
    returnedResult = getindex(example,1)
    expectedResult = 7.6 * ucat.ampere
    return (returnedResult == expectedResult)
end

function test_getindex_errorsForIndexGreaterOne()
    example = 7.6 * ucat.ampere
    expectedError = Core.BoundsError
    @test_throws expectedError getindex(example, 2)
end

end # module
