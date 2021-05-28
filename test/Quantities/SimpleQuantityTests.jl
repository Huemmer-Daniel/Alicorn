module SimpleQuantityTests

using Alicorn
using Test
using ..TestingTools

const ucat = UnitCatalogue()

function run()
    @testset "SimpleQuantity" begin
        # initialization
        @test canInstanciateSimpleQuantityWithRealValue()
        @test canInstanciateSimpleQuantityWithComplexValue()
        @test canInstanciateSimpleQuantityWithRealValuedArray()
        @test canInstanciateSimpleQuantityWithComplexValuedArray()
        @test canInstanciateSimpleQuantityWithBaseUnit()
        @test canInstanciateSimpleQuantityWithUnitFactor()
        @test canInstanciateSimpleQuantityWithoutUnit()

        @test fieldsCorrectlyInitialized()

        @test_skip canInstanciateSimpleQuantityFromAbstractUnit()

        # initialization by multiplication and division
        @test Any_AbstractUnit_multiplication()
        @test Any_AbstractUnit_division()

        @test SimpleQuantity_AbstractUnit_multiplication()
        @test SimpleQuantity_AbstractUnit_division()

        # unit conversion
        @test inUnitsOf_implemented()
        test_inUnitsOf_ErrorsForMismatchedUnits()
        @test inBasicSIUnits_implemented()
        @test valueOfDimensionless_implemented()
        test_valueOfDimensionless_ErrorsIfNotUnitless()

        # arithmetics
        @test equality_implemented()

        @test addition_implemented()
        test_addition_ErrorsForMismatchedDimensions()
        @test subtraction_implemented()
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
        @test getindex_implemented()
        @test setindex!_implemented()
        test_setindex!_errorsForIncompatibleTypes()
        test_setindex!_errorsForIncompatibleUnits()
        @test repeat_implemented()
        @test ndims_implemented()
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

function canInstanciateSimpleQuantityWithComplexValue()
    value = TestingTools.generateRandomComplex()
    unit = TestingTools.generateRandomUnit()
    return _testInstanciation(value, unit)
end

function canInstanciateSimpleQuantityWithRealValuedArray()
    value = TestingTools.generateRandomReal(dim=(2,3))
    unit = TestingTools.generateRandomUnit()
    return _testInstanciation(value, unit)
end

function canInstanciateSimpleQuantityWithComplexValuedArray()
    value = TestingTools.generateRandomComplex(dim=(2,3))
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

function canInstanciateSimpleQuantityWithoutUnit()
    value = TestingTools.generateRandomReal()
    returnedSimpleQuantity = SimpleQuantity(value)
    correctSimpleQuantity = SimpleQuantity(value, Alicorn.unitlessUnit)
    pass = (returnedSimpleQuantity == correctSimpleQuantity)
    return pass
end

function fieldsCorrectlyInitialized()
    (randomSimpleQuantity, randomSimpleQuantityFields) = TestingTools.generateRandomSimpleQuantityWithFields()
    return _verifyHasCorrectFields(randomSimpleQuantity, randomSimpleQuantityFields)
end

function _verifyHasCorrectFields(simpleQuantity::SimpleQuantity, randomFields::Dict{String,Any})
    correctValue = (simpleQuantity.value == randomFields["value"])
    correctUnit = (simpleQuantity.unit == randomFields["unit"])
    correct = correctValue && correctUnit
    return correct
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
    electronvoltInBasicSI = ucat.electronvolt.prefactor

    # format: SimpleQuantity, Unit, SimpleQuantity expressed in units of Unit
    examples = [
        ( 1 * Alicorn.unitlessUnit, Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit ),
        ( 7 * ucat.meter, ucat.milli*ucat.meter, 7000 * (ucat.milli*ucat.meter) ),
        ( 2 * (ucat.milli * ucat.second)^2, ucat.second^2, 2e-6 * ucat.second^2 ),
        ( 1 * ucat.joule, ucat.electronvolt, (1/electronvoltInBasicSI) * ucat.electronvolt ),
        ( 5 * Alicorn.unitlessUnit, Alicorn.unitlessUnit, 5 * Alicorn.unitlessUnit),
        ( [7, 2] * ucat.meter, ucat.milli*ucat.meter, [7000, 2000] * (ucat.milli*ucat.meter) )
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

function addition_implemented()
    scalarExamples = _getScalarExamplesFor_addition()
    worksForScalars = TestingTools.testDyadicFunction(Base.:+, scalarExamples)

    matrixExamples = _getMatrixExamplesFor_addition()
    worksForMatrices = TestingTools.testDyadicFunction(Base.:+, matrixExamples)

    return (worksForScalars && worksForMatrices)
end

function _getScalarExamplesFor_addition()
    # format: addend1, addend2, correct sum
    examples = [
        ( 2 * Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit, 3 * Alicorn.unitlessUnit ),
        ( 7 * ucat.meter, 2 * (ucat.milli * ucat.meter), 7.002 * ucat.meter ),
        ( 2 * (ucat.milli * ucat.meter), 7 * ucat.meter , 7.002e3 * (ucat.milli * ucat.meter) )
    ]
    return examples
end

function _getMatrixExamplesFor_addition()
    # format: addend1, addend2, correct sum
    examples = [
        ( [2, 1] * Alicorn.unitlessUnit, [1, 2] * Alicorn.unitlessUnit, [3, 3] * Alicorn.unitlessUnit ),
        ( [7; 2] * ucat.siemens, [2; 7] * (ucat.milli * ucat.siemens), [7.002; 2.007] * ucat.siemens ),
        ( [2; 7] * (ucat.milli * ucat.second), [7; 2] * ucat.second , [7.002e3; 2.007e3] * (ucat.milli * ucat.second) )
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

function subtraction_implemented()
    scalarExamples = _getScalarExamplesFor_subtraction()
    worksForScalars = TestingTools.testDyadicFunction(Base.:-, scalarExamples)

    matrixExamples = _getMatrixExamplesFor_subtraction()
    worksForMatrices = TestingTools.testDyadicFunction(Base.:-, matrixExamples)

    return (worksForScalars && worksForMatrices)
end


function _getScalarExamplesFor_subtraction()
    # format: addend1, addend2, correct sum
    examples = [
        ( 2 * Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit ),
        ( 7 * ucat.meter, 2 * (ucat.milli * ucat.meter), 6.998 * ucat.meter ),
        ( 2 * (ucat.milli * ucat.meter), 7 * ucat.meter , -6.998e3 * (ucat.milli * ucat.meter) )
    ]
    return examples
end

function _getMatrixExamplesFor_subtraction()
    # format: addend1, addend2, correct sum
    examples = [
        ( [2, 1] * Alicorn.unitlessUnit, [1, 2] * Alicorn.unitlessUnit, [1, -1] * Alicorn.unitlessUnit ),
        ( [7; 2] * ucat.siemens, [2; 7] * (ucat.milli * ucat.siemens), [6.998; 1.993] * ucat.siemens ),
        ( [2; 7] * (ucat.milli * ucat.second), [7; 2] * ucat.second , [-6.998e3; -1.993e3] * (ucat.milli * ucat.second) )
    ]
    return examples
end

function test_subtraction_ErrorsForMismatchedDimensions()
    (mismatchedAddend1, mismatchedAddend2) = _generateMismatchedAddends()
    expectedError = Alicorn.Exceptions.DimensionMismatchError("summands are not of the same physical dimension")
    @test_throws expectedError (mismatchedAddend1 - mismatchedAddend2)
end

function multiplication_implemented()
    scalarExamples = _getScalarExamplesFor_multiplication()
    worksForScalars = TestingTools.testDyadicFunction(Base.:*, scalarExamples)

    matrixExamples = _getMatrixExamplesFor_multiplication()
    worksForMatrices = TestingTools.testDyadicFunction(Base.:*, matrixExamples)

    mixedExamples = _getMixedExamplesFor_multiplication()
    worksForMixed = TestingTools.testDyadicFunction(Base.:*, mixedExamples)

    return (worksForScalars && worksForMatrices && worksForMixed)
end

function _getScalarExamplesFor_multiplication()
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

function _getMatrixExamplesFor_multiplication()
    # format: factor1, factor2, correct product factor1 * factor2
    examples = [
        ( [1 1] * Alicorn.unitlessUnit, [1; 1] * Alicorn.unitlessUnit, [2] * Alicorn.unitlessUnit ),
        ( [1 0; 2 0] * Alicorn.unitlessUnit, [2 3; 4 5] * ucat.second, [2 3; 4 6] * ucat.second ),
        ( [2 3; 4 5] * ucat.second, [1 0; 2 0] * Alicorn.unitlessUnit, [8 0; 14 0] * ucat.second ),
        ( [2.5] * ucat.meter, [2 3] * ucat.second, [5 7.5] * ucat.meter * ucat.second ),
        ( [2.5] * ucat.second, [2 3] * ucat.meter, [5 7.5] * ucat.second * ucat.meter )
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
    scalarExamples = _getScalarExamplesFor_multiplicationWithDimensionless()
    worksForScalars = TestingTools.testDyadicFunction(Base.:*, scalarExamples)

    matrixExamples = _getMatrixExamplesFor_multiplicationWithDimensionless()
    worksForMatrices = TestingTools.testDyadicFunction(Base.:*, matrixExamples)

    mixedExamples = _getMixedExamplesFor_multiplicationWithDimensionless()
    worksForMixed = TestingTools.testDyadicFunction(Base.:*, mixedExamples)

    return (worksForScalars && worksForMatrices && worksForMixed)
end

function _getScalarExamplesFor_multiplicationWithDimensionless()
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

function _getMatrixExamplesFor_multiplicationWithDimensionless()
    # format: factor1, factor2, correct product factor1 * factor2
    examples = [
        ( [1 1] * Alicorn.unitlessUnit, [1; 1], [2] * Alicorn.unitlessUnit ),
        ( [1 1], [1; 1] * Alicorn.unitlessUnit, [2] * Alicorn.unitlessUnit ),
        ( [1 0; 2 0] * ucat.second, [2 3; 4 5] , [2 3; 4 6] * ucat.second ),
        ( [2 3; 4 5], [1 0; 2 0] * ucat.second, [8 0; 14 0] * ucat.second )
    ]
    return examples
end

function _getMixedExamplesFor_multiplicationWithDimensionless()
    # format: factor1, factor2, correct product factor1 * factor2
    examples = [
        ( [1 1] * Alicorn.unitlessUnit, 2, [2 2] * Alicorn.unitlessUnit ),
        ( 2, [1 1] * Alicorn.unitlessUnit, [2 2] * Alicorn.unitlessUnit ),
        ( [1 0; 2 0] * ucat.second, 3, [3 0; 6 0] * ucat.second ),
        ( 3, [1 0; 2 0] * ucat.second, [3 0; 6 0] * ucat.second ),
        ( 2.5 * ucat.meter, [2 3] , [5 7.5] * ucat.meter  ),
        ( [2 3], 2.5 * ucat.meter, [5 7.5] * ucat.meter  )
    ]
    return examples
end

function division_implemented()
    scalarExamples = _getScalarExamplesFor_division()
    worksForScalars = TestingTools.testDyadicFunction(Base.:/, scalarExamples)

    mixedExamples = _getMixedExamplesFor_division()
    worksForMixed = TestingTools.testDyadicFunction(Base.:/, mixedExamples)

    return (worksForScalars && worksForMixed)
end

function _getScalarExamplesFor_division()
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

function _getMixedExamplesFor_division()
    # format: factor1, factor2, correct product factor1 * factor2
    examples = [
        ( [1 1] * Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit, [1 1] * Alicorn.unitlessUnit ),
        ( [2, 3] * Alicorn.unitlessUnit, 2 * ucat.second, [1, 1.5] * ucat.second^-1 ),
        ( [2; 10] * ucat.second, 5 * Alicorn.unitlessUnit, [0.4; 2] * ucat.second ),
        ( [4 4] * ucat.meter,  2 * ucat.second, [2 2] * ucat.meter / ucat.second ),
        ( [4 4] * ucat.second, 2 * ucat.meter, [2 2] * ucat.second / ucat.meter ),
        ( [-7 -7] * ucat.lumen * (ucat.nano * ucat.second),  2 * (ucat.pico * ucat.second) , [-3.5 -3.5] * ucat.lumen * (ucat.nano * ucat.second) / (ucat.pico * ucat.second) ),
        ( [2 2; 2 2] * (ucat.milli * ucat.candela)^-4, 4 * (ucat.milli * ucat.candela)^2, [0.5 0.5; 0.5 0.5] * (ucat.milli * ucat.candela)^-6 )
    ]
    return examples
end

function divisionByDimensionless_implemented()
    scalarExamples = _getScalarExamplesFor_divisionByDimensionless()
    worksForScalars = TestingTools.testDyadicFunction(Base.:/, scalarExamples)

    mixedExamples = _getMixedExamplesFor_divisionByDimensionless()
    worksForMixed = TestingTools.testDyadicFunction(Base.:/, mixedExamples)

    return (worksForScalars && worksForMixed)
end


function _getScalarExamplesFor_divisionByDimensionless()
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

function _getMixedExamplesFor_divisionByDimensionless()
    # format: factor1, factor2, correct product factor1 * factor2
    examples = [
        ( [1 1] * Alicorn.unitlessUnit, 1, [1 1] * Alicorn.unitlessUnit ),
        ( [1 1], 1 * Alicorn.unitlessUnit, [1 1] * Alicorn.unitlessUnit ),
        ( [2, 3] * ucat.second, 2 , [1, 1.5] * ucat.second ),
        ( [2, 3] , 2 * ucat.second , [1, 1.5] / ucat.second ),
    ]
    return examples
end

function inv_implemented()
    scalarExamples = _getScalarExamplesFor_inv()
    worksForScalars = TestingTools.testMonadicFunction(Base.inv, scalarExamples)

    matrixExamples = _getMatrixExamplesFor_inv()
    worksForMatrices = TestingTools.testMonadicFunction(Base.inv, matrixExamples)

    return worksForScalars && worksForMatrices
end

function _getScalarExamplesFor_inv()
    # format: SimpleQuantity, correct result for SimpleQuantity^-1
    examples = [
        ( 1 * Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit),
        ( 2 * ucat.meter, 0.5 * ucat.meter^-1),
        ( -5 * (ucat.femto * ucat.meter)^-1 * ucat.joule, -0.2 * (ucat.femto * ucat.meter) * ucat.joule^-1 )
    ]
    return examples
end

function _getMatrixExamplesFor_inv()
    # format: SimpleQuantity, correct result for SimpleQuantity^-1
    examples = [
        ( [1 0 ; 0 1] * Alicorn.unitlessUnit, [1 0 ; 0 1] * Alicorn.unitlessUnit),
        ( [2 4; 2 8] * ucat.meter, [1 -0.5; -0.25 0.25] * ucat.meter^-1),
        ( -[2 4; 2 8] * (ucat.femto * ucat.meter)^-1 * ucat.joule, -[1 -0.5; -0.25 0.25] * (ucat.femto * ucat.meter) * ucat.joule^-1 )
    ]
    return examples
end

function exponentiation_implemented()
    scalarExamples = _getScalarExamplesFor_exponentiation()
    worksForScalars = TestingTools.testDyadicFunction(Base.:^, scalarExamples)

    matrixExamples = _getMatrixExamplesFor_exponentiation()
    worksForMatrices = TestingTools.testDyadicFunction(Base.:^, matrixExamples)

    return worksForScalars && worksForMatrices
end

function _getScalarExamplesFor_exponentiation()
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

function _getMatrixExamplesFor_exponentiation()
    # format: SimpleQuantity, exponent, correct result for SimpleQuantity^exponent
    examples = [
        ( [1 0; 0 1] * Alicorn.unitlessUnit, 1, [1 0; 0 1] * Alicorn.unitlessUnit ),
        ( [1 0; 0 1] * Alicorn.unitlessUnit, 2, [1 0; 0 1] * Alicorn.unitlessUnit ),
        ( [1 2; 3 4] * ucat.meter, 0, [1 0; 0 1] * Alicorn.unitlessUnit ),
    ]
    return examples
end

function sqrt_implemented()
    scalarExamples = _getScalarExamplesFor_sqrt()
    worksForScalars = TestingTools.testMonadicFunction(Base.sqrt, scalarExamples)

    matrixExamples = _getMatrixExamplesFor_sqrt()
    worksForMatrices = TestingTools.testMonadicFunction(Base.sqrt, matrixExamples)

    return worksForScalars && worksForMatrices
end

function _getScalarExamplesFor_sqrt()
    # format: SimpleQuantity, correct result for sqrt(SimpleQuantity)
    examples = [
        ( 1 * Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit ),
        ( 4 * (ucat.pico * ucat.meter)^-3, 2 * (ucat.pico * ucat.meter)^-1.5 )
    ]
    return examples
end

function _getMatrixExamplesFor_sqrt()
    # format: SimpleQuantity, correct result for sqrt(SimpleQuantity)
    examples = [
        ( [1 0; 0 1] * Alicorn.unitlessUnit, [1 0; 0 1] * Alicorn.unitlessUnit),
        ( [4 0; 0 4] * (ucat.pico * ucat.meter)^-3, [2 0; 0 2] * (ucat.pico * ucat.meter)^-1.5 )
    ]
    return examples
end

# other methods
function length_implemented()
    scalarExamples = _getScalarExamplesFor_length()
    worksForScalars = TestingTools.testMonadicFunction(Base.length, scalarExamples)

    matrixExamples = _getMatrixExamplesFor_length()
    worksForMatrices = TestingTools.testMonadicFunction(Base.length, matrixExamples)

    works = (worksForScalars && worksForMatrices)
    return works
end

function _getScalarExamplesFor_length()
    # format: SimpleQuantity, correct result for length(SimpleQuantity)
    examples = [
        ( 1123 * ucat.meter, 1 )
    ]
    return examples
end

function _getMatrixExamplesFor_length()
    # format: SimpleQuantity, correct result for sqrt(SimpleQuantity)
    examples = [
        ( [1 0; 0 1; 2 3] * (ucat.pico * ucat.meter)^-3, 6)
    ]
    return examples
end

function size_implemented()
    scalarExamples = _getScalarExamplesFor_size()
    worksForScalars = TestingTools.testMonadicFunction(Base.size, scalarExamples)

    matrixExamples = _getMatrixExamplesFor_size()
    worksForMatrices = TestingTools.testMonadicFunction(Base.size, matrixExamples)

    works = (worksForScalars && worksForMatrices)
    return works
end

function _getScalarExamplesFor_size()
    # format: SimpleQuantity, correct result for size(SimpleQuantity)
    examples = [
        ( 1123 * ucat.meter, () )
    ]
    return examples
end

function _getMatrixExamplesFor_size()
    # format: SimpleQuantity, correct result for size(SimpleQuantity)
    examples = [
        ( [1 0; 0 1; 2 3] * (ucat.pico * ucat.meter)^-3, (3, 2) ),
        ( [1 0 2; 0 1 3] * (ucat.pico * ucat.meter)^-3, (2, 3) )
    ]
    return examples
end

function getindex_implemented()
    scalarExamples = _getScalarExamplesFor_getindex()
    worksForScalars = true
    for (simpleQuantity, index, correctOutput) in scalarExamples
        returnedOutput = Base.getindex(simpleQuantity, index...)
        worksForScalars &= (returnedOutput == correctOutput)
    end

    matrixExamples = _getMatrixExamplesFor_getindex()
    worksForMatrices = true
    for (simpleQuantity, index, correctOutput) in matrixExamples
        returnedOutput = Base.getindex(simpleQuantity, index...)
        worksForMatrices &= (returnedOutput == correctOutput)
    end

    works = (worksForScalars && worksForMatrices)
    return works
end

function _getScalarExamplesFor_getindex()
    # format: SimpleQuantity, index, correct result for getindex(SimpleQuantity, index)
    examples = [
        ( 1123 * ucat.meter, 1, 1123 * ucat.meter )
    ]
    return examples
end

function _getMatrixExamplesFor_getindex()
    # format: SimpleQuantity, index, correct result for getindex(SimpleQuantity, index)
    examples = [
        ( [1 7; 0 1; 2 3] * (ucat.pico * ucat.meter)^-3, (3,1), 2 * (ucat.pico * ucat.meter)^-3 ),
        ( [1 7; 0 1; 2 3] * (ucat.pico * ucat.meter)^-3, 4, 7 * (ucat.pico * ucat.meter)^-3 ),
        ( [1 7; 0 1; 2 3] * (ucat.pico * ucat.meter)^-3, 6, 3 * (ucat.pico * ucat.meter)^-3 )
    ]
    return examples
end

function setindex!_implemented()
    matrixExamples = _getMatrixExamplesFor_setindex!()
    worksForMatrices = true
    for (simpleQuantityArray, simpleQuantity, index, correctOutput) in matrixExamples
        returnedOutput = Base.setindex!(simpleQuantityArray, simpleQuantity, index...)
        worksForMatrices &= (returnedOutput == correctOutput)
    end

    return worksForMatrices
end

function _getMatrixExamplesFor_setindex!()
    # format: SimpleQuantityArray, SimpleQuantity, index, correct result for getindex(SimpleQuantity, index)
    examples = [
        (
            [1.0 7; 0 1; 2 3] * (ucat.pico * ucat.meter)^-3,
            2.3 * (ucat.pico * ucat.meter)^-3,
            (3,1),
            [1 7; 0 1; 2.3 3] * (ucat.pico * ucat.meter)^-3
        )
    ]
    return examples
end

function test_setindex!_errorsForIncompatibleTypes()
    array = Array{Int64}([1 2; 3 4]) * ucat.meter
    element = Float64(2.5) * ucat.meter
    expectedError = InexactError(:Int64, Int64, 2.5)
    @test_throws expectedError (array[1] = element)
end

function test_setindex!_errorsForIncompatibleUnits()
    array = Array{Float64}([1 2; 3 4]) * ucat.meter
    element = Float64(2.5) * ucat.second
    expectedError = Alicorn.Exceptions.DimensionMismatchError("dimensions of the quantity and the desired unit do not agree")
    @test_throws expectedError (array[1] = element)
end

function repeat_implemented()
    matrixExamples = _getMatrixExamplesFor_repeat()

    worksForMatrices = true
    for (simpleQuantityArray, counts, correctOutput) in matrixExamples
        returnedOutput = Base.repeat(simpleQuantityArray, counts...)
        worksForMatrices &= (returnedOutput == correctOutput)
    end

    return worksForMatrices
end

function _getMatrixExamplesFor_repeat()
    # format: A::SimpleQuantity{A} where A <: AbstractArray, counts, correct output for repeat(A, counts...)
    array = [1 2; 3 4]
    examples = [
        ( array * ucat.meter, (2, 3), repeat(array, 2, 3) * ucat.meter )
    ]
    return examples
end

function ndims_implemented()
    scalarExamples = _getScalarExamplesFor_ndims()
    worksForScalars = TestingTools.testMonadicFunction(Base.ndims, scalarExamples)

    matrixExamples = _getMatrixExamplesFor_ndims()
    worksForMatrices = TestingTools.testMonadicFunction(Base.ndims, matrixExamples)

    works = (worksForScalars && worksForMatrices)
    return works
end

function _getScalarExamplesFor_ndims()
    # format: SimpleQuantity{<:Number}, correct result for ndims(SimpleQuantity{<:Number})
    examples = [
        ( SimpleQuantity(7, ucat.meter), 0 ),
        ( SimpleQuantity(7.5im, ucat.second), 0 )
    ]
end

function _getMatrixExamplesFor_ndims()
    # format: SimpleQuantity{<:AbstractArray}, correct result for ndims(SimpleQuantity{<:AbstractArray})
    examples = [
        ( SimpleQuantity([1 2; 3 4; 5 6], ucat.meter), 2 ),
        ( SimpleQuantity([1 2 3], ucat.second), 2 ),
        ( SimpleQuantity([1, 2, 3], ucat.second), 1 )
    ]
end

end # module
