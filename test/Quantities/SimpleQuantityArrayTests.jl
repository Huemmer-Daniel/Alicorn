module SimpleQuantityArrayTests

using Alicorn
using Test
using ..TestingTools

const ucat = UnitCatalogue()

function run()
    @testset "SimpleQuantityArray" begin

        #- Constructors
        @test canInstanciateSQArrayWithRealArray()
        @test canInstanciateSQArrayWithComplexArray()
        @test canInstanciateSQArraWithBaseUnit()
        @test canInstanciateSQArraWithUnitFactor()
        @test canInstanciateSQArraWithoutUnit()

        #- Methods for constructing a SimpleQuantityArray
        @test AbstractArray_AbstractUnit_multiplication()
        @test AbstractArray_AbstractUnit_division()

        #- AbstractArray interface
        @test size_implemented()
        @test size_withDim_implemented()
        @test getindex_implemented()
        @test setindex!_implemented()
        test_setindex!_ErrorsForMismatchedUnits()
        @test setindex!_canSetToDimensionlessZero()

        #- AbstractQuantity interface
        # 1. Unit conversion
        @test inUnitsOf_implemented()
        test_inUnitsOf_ErrorsForMismatchedUnits()
        @test inUnitsOf_implemented_forSimpleQuantityAsTargetUnit()
        @test inBasicSIUnits_implemented()
        @test SimpleQuantityArray_AbstractUnit_multiplication()
        @test AbstractUnit_SimpleQuantityArray_multiplication()
        @test SimpleQuantityArray_AbstractUnit_division()
        @test AbstractUnit_SimpleQuantityArray_division()

        # 2. Arithemtic unary and binary operators
        @test unaryPlus_implemented()
        @test unaryMinus_implemented()
        @test addition_implemented()
        test_addition_ErrorsForMismatchedDimensions()
        @test subtraction_implemented()
        test_subtraction_ErrorsForMismatchedDimensions()
        # multiplication
        @test multiplication_implemented()
        @test SimpleQuantityArray_Array_multiplication_implemented()
        @test Array_SimpleQuantityArray_multiplication_implemented()
        @test SimpleQuantityArray_SimpleQuantity_multiplication_implemented()
        @test SimpleQuantity_SimpleQuantityArray_multiplication_implemented()
        @test SimpleQuantityArray_Number_multiplication_implemented()
        @test Number_SimpleQuantityArray_multiplication_implemented()
        # division
        @test division_implemented()
        @test SimpleQuantityArray_Array_division_implemented()
        @test Array_SimpleQuantityArray_division_implemented()
        @test SimpleQuantityArray_SimpleQuantity_division_implemented()
        @test SimpleQuantity_SimpleQuantityArray_division_implemented()
        @test SimpleQuantityArray_Number_division_implemented()
        @test Number_SimpleQuantityArray_division_implemented()
        # # inverse division
        # @test inverseDivision_implemented()
        # @test SimpleQuantityArray_Array_inverseDivision_implemented()
        # @test Array_SimpleQuantityArray_inverseDivision_implemented()
        # @test SimpleQuantityArray_SimpleQuantity_inverseDivision_implemented()
        # @test SimpleQuantity_SimpleQuantityArray_inverseDivision_implemented()
        # @test SimpleQuantityArray_Number_inverseDivision_implemented()
        # @test Number_SimpleQuantityArray_inverseDivision_implemented()

        #- additional array methods
        @test transpose_implemented()
        @test repeat_implemented()
        @test repeat_withInnerOuter_implemented()

        #- additional methods
        @test valueOfDimensionless_implemented()
        test_valueOfDimensionless_ErrorsIfNotUnitless()
    end
end

## #- Constructors

function canInstanciateSQArrayWithRealArray()
    value = TestingTools.generateRandomReal(dim = (2,2))
    unit = TestingTools.generateRandomUnit()
    sqArray = SimpleQuantityArray(value, unit)
    correctFields = Dict([
        ("value", value),
        ("unit", unit)
    ])
    return _verifyHasCorrectFields(sqArray, correctFields)
end

function _verifyHasCorrectFields(sqArray::SimpleQuantityArray, correctFields::Dict{String,Any})
    correctValue = (sqArray.value == correctFields["value"])
    correctUnit = (sqArray.unit == correctFields["unit"])
    correct = correctValue && correctUnit
    return correct
end

function canInstanciateSQArrayWithComplexArray()
    value = TestingTools.generateRandomComplex(dim = (2,2))
    unit = TestingTools.generateRandomUnit()
    sqArray = SimpleQuantityArray(value, unit)
    correctFields = Dict([
        ("value", value),
        ("unit", unit)
    ])
    return _verifyHasCorrectFields(sqArray, correctFields)
end

function canInstanciateSQArraWithBaseUnit()
    value = TestingTools.generateRandomReal(dim = (2,2))
    baseUnit = TestingTools.generateRandomBaseUnit()
    unit = convertToUnit(baseUnit)

    sqArray = SimpleQuantityArray(value, baseUnit)
    correctFields = Dict([
        ("value", value),
        ("unit", unit)
    ])
    return _verifyHasCorrectFields(sqArray, correctFields)
end

function canInstanciateSQArraWithUnitFactor()
    value = TestingTools.generateRandomComplex(dim = (2,2))
    unitFactor = TestingTools.generateRandomUnitFactor()
    unit = convertToUnit(unitFactor)

    sqArray = SimpleQuantityArray(value, unitFactor)
    correctFields = Dict([
        ("value", value),
        ("unit", unit)
    ])
    return _verifyHasCorrectFields(sqArray, correctFields)
end

function canInstanciateSQArraWithoutUnit()
    value = TestingTools.generateRandomComplex(dim = (2,2))
    sqArray = SimpleQuantityArray(value)
    correctFields = Dict([
        ("value", value),
        ("unit", Alicorn.unitlessUnit)
    ])
    return _verifyHasCorrectFields(sqArray, correctFields)
end

## #- Methods for constructing a SimpleQuantityArray

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

## #- AbstractArray interface

function size_implemented()
    examples = _getExamplesFor_size()
    return TestingTools.testMonadicFunction(Base.size, examples)
end

function _getExamplesFor_size()
    unit = TestingTools.generateRandomUnit()

    array1 = TestingTools.generateRandomReal(dim=(3,4))
    array2 = TestingTools.generateRandomComplex(dim=(2))
    array3 = TestingTools.generateRandomReal(dim=(1,4))

    # format: ::SimpleQuantityArray, correct result for size(::SimpleQuantityArray)
    examples = [
        ( SimpleQuantityArray(array1, unit ), (3,4) ),
        ( SimpleQuantityArray(array2, unit ), (2, ) ),
        ( SimpleQuantityArray(array3, unit), (1,4) )
    ]
end

function size_withDim_implemented()
    examples = _getExamplesFor_size_withDim()
    return TestingTools.testDyadicFunction(Base.size, examples)
end

function _getExamplesFor_size_withDim()
    unit = TestingTools.generateRandomUnit()

    array1 = TestingTools.generateRandomReal(dim=(3,4))
    array2 = TestingTools.generateRandomComplex(dim=(2))
    array3 = TestingTools.generateRandomReal(dim=(1,4))

    # format: ::SimpleQuantityArray, dimension::Int, correct result for size(::SimpleQuantityArray, dimension)
    examples = [
        ( SimpleQuantityArray(array1, unit ), 1, 3 ),
        ( SimpleQuantityArray(array2, unit ), 2, 1 ),
        ( SimpleQuantityArray(array3, unit), 2, 4 ),
        ( SimpleQuantityArray(array3, unit), 10, 1 )
    ]
end

function getindex_implemented()
    examples = _getExamplesFor_getindex()
    return TestingTools.testDyadicFunction_Splat2ndArgs(Base.getindex, examples)
end

function _getExamplesFor_getindex()
    unit = TestingTools.generateRandomUnit()
    array = TestingTools.generateRandomReal(dim=(3,4))
    sqArray = SimpleQuantityArray(array, unit )

    # format: ::SimpleQuantityArray, indices, correct result for getindex(::SimpleQuantityArray, indices)
    examples = [
        ( sqArray, 1, SimpleQuantity(array[1], unit) ),
        ( sqArray, 6, SimpleQuantity(array[6], unit) ),
        ( sqArray, (2,3), SimpleQuantity(array[2,3], unit) ),
        ( sqArray, (1:3,4), SimpleQuantityArray(array[1:3,4], unit) )
    ]
end

function setindex!_implemented()
    examples = _getExamplesFor_setindex!()
    return _test_setindex!(examples)
end

function _getExamplesFor_setindex!()
    array = zeros(3,4)
    unit =  ucat.second
    sqArray = SimpleQuantityArray(array, unit)

    array1 = deepcopy(array)
    vector1 = 7
    unit1 = ucat.second
    array1[1] = 7

    array2 = deepcopy(array)
    vector2 = 9
    unit2 = (ucat.deci * ucat.second )
    array2[2,3] = 0.9

    array3 = deepcopy(array)
    vector3 = [7, 8, 9]
    unit3 = ucat.second
    array3[1:3] = [7, 8, 9]

    # format: ::SimpleQuantityArray, vector, indices, correct result for setindex!(::SimpleQuantityArray, vector, indices)
    examples = [
        ( deepcopy(sqArray), vector1*unit1, 1, SimpleQuantityArray(array1, unit) ),
        ( deepcopy(sqArray), vector2*unit2, (2,3), SimpleQuantityArray(array2, unit) ),
        ( deepcopy(sqArray), vector3*unit3, 1:3, SimpleQuantityArray(array3, unit) )
    ]
end

function _test_setindex!(examples::Array)
    correct = true
    for (sqArray, vector, indices, correctOutput) in examples
        if isa(indices, Tuple)
            returnedOutput = Base.setindex!(sqArray, vector, indices...)
        else
            returnedOutput = Base.setindex!(sqArray, vector, indices)
        end
        correct &= (returnedOutput == correctOutput)
    end
    return correct
end

function test_setindex!_ErrorsForMismatchedUnits()
    sqArray = [7, 2] * Alicorn.meter
    mismatchedUnit = Alicorn.second
    expectedError = Alicorn.Exceptions.DimensionMismatchError("dimensions of the quantity and the desired unit do not agree")
    @test_throws expectedError setindex!(sqArray, 2*mismatchedUnit, 1)
    @test_throws expectedError setindex!(sqArray, 2, 1)
end

function setindex!_canSetToDimensionlessZero()
    examples = _getExamplesFor_setindex!_canSetToDimensionlessZero()
    return _test_setindex!(examples)
end

function _getExamplesFor_setindex!_canSetToDimensionlessZero()
    array = ones(3,4)
    unit =  ucat.second
    sqArray = SimpleQuantityArray(array, unit)

    array1 = deepcopy(array)
    vector1 = 0
    array1[1] = 0

    array2 = deepcopy(array)
    vector2 = [0, 0, 0]
    array2[1:3] =  [0, 0, 0]

    # format: ::SimpleQuantityArray, vector, indices, correct result for setindex!(::SimpleQuantityArray, vector, indices)
    examples = [
        ( deepcopy(sqArray), vector1, 1, SimpleQuantityArray(array1, unit) ),
        ( deepcopy(sqArray), vector2, (1:3), SimpleQuantityArray(array2, unit) )
    ]
end

## #- AbstractQuantityArray interface
## 1. Unit conversion

function inUnitsOf_implemented()
    examples = _getExamplesFor_inUnitsOf()
    return TestingTools.testDyadicFunction(inUnitsOf, examples)
end

function _getExamplesFor_inUnitsOf()
    electronvoltInBasicSI = ucat.electronvolt.prefactor

    # format: SimpleQuantityArray, Unit, SimpleQuantityArray expressed in units of Unit
    examples = [
        ( ones(2,2) * Alicorn.unitlessUnit, Alicorn.unitlessUnit, ones(2,2) * Alicorn.unitlessUnit ),
        ( [7; 3] * ucat.meter, ucat.milli*ucat.meter, [7000; 3000] * (ucat.milli*ucat.meter) ),
        ( [2] * (ucat.milli * ucat.second)^2, ucat.second^2, [2e-6] * ucat.second^2 ),
        ( ones(2,2) * ucat.joule, ucat.electronvolt, ( (1/electronvoltInBasicSI) * ones(2,2) ) * ucat.electronvolt ),
        ( [5 2] * Alicorn.unitlessUnit, Alicorn.unitlessUnit, [5 2] * Alicorn.unitlessUnit)
    ]
end

function test_inUnitsOf_ErrorsForMismatchedUnits()
    sqArray = [7, 2] * Alicorn.meter
    mismatchedUnit = Alicorn.second
    expectedError = Alicorn.Exceptions.DimensionMismatchError("dimensions of the quantity and the desired unit do not agree")
    @test_throws expectedError inUnitsOf(sqArray, mismatchedUnit)
end

function inUnitsOf_implemented_forSimpleQuantityAsTargetUnit()
    examples = _getExamplesFor_inUnitsOf_forSimpleQuantityAsTargetUnit()
    return TestingTools.testDyadicFunction(inUnitsOf, examples)
end

function _getExamplesFor_inUnitsOf_forSimpleQuantityAsTargetUnit()
    electronvoltInBasicSI = ucat.electronvolt.prefactor

    # format: SimpleQuantity1, SimpleQuantity2, SimpleQuantity1 expressed in units of SimpleQuantity2
    examples = [
        ( [1] * Alicorn.unitlessUnit, 3 * Alicorn.unitlessUnit, [1] * Alicorn.unitlessUnit ),
        ( [7] * ucat.meter, 8.9 * (ucat.milli*ucat.meter), [7000] * (ucat.milli*ucat.meter) ),
        ( [2] * (ucat.milli * ucat.second)^2, pi * ucat.second^2, [2e-6] * ucat.second^2 ),
        ( [1] * ucat.joule, -8.0 * ucat.electronvolt, [(1/electronvoltInBasicSI)] * ucat.electronvolt ),
        ( [5; 5] * Alicorn.unitlessUnit, -9 * Alicorn.unitlessUnit, [5; 5] * Alicorn.unitlessUnit)
    ]
end

function inBasicSIUnits_implemented()
    examples = _getExamplesFor_inBasicSIUnits()
    return TestingTools.testMonadicFunction(inBasicSIUnits, examples)
end

function _getExamplesFor_inBasicSIUnits()
    # format: SimpleQuantityArray, SimpleQuantityArray expressed in terms of basic SI units
    examples = [
        ( ones(2,2) * Alicorn.unitlessUnit, ones(2,2) * Alicorn.unitlessUnit ),
        ( ones(2,2) * Alicorn.meter, ones(2,2) * Alicorn.meter ),
        ( [4.2] * ucat.joule, [4.2] * (Alicorn.kilogram * Alicorn.meter^2 / Alicorn.second^2) ),
        ( [-4.5, 2] * (ucat.mega * ucat.henry)^2, [-4.5e12, 2e12] * ( Alicorn.kilogram^2 * Alicorn.meter^4 * Alicorn.second^-4 * Alicorn.ampere^-4) ),
        ( [1 2] * ucat.hour, [3600 7200]* Alicorn.second )
    ]
    return examples
end

function SimpleQuantityArray_AbstractUnit_multiplication()
    examples = _getExamplesFor_SimpleQuantityArray_AbstractUnit_multiplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_SimpleQuantityArray_AbstractUnit_multiplication()
    value = TestingTools.generateRandomReal(dim=(2,3))
    unit1 = TestingTools.generateRandomUnit()
    baseUnit = TestingTools.generateRandomBaseUnit()
    unitFactor = TestingTools.generateRandomUnitFactor()
    unit2 = TestingTools.generateRandomUnit()

    # format: factor1, factor2, correct result for factor1 * factor2
    # where factor1 is a SimpleQuanity and factor2 is an AbstractUnit
    examples = [
        ( SimpleQuantityArray(value, unit1), baseUnit, SimpleQuantityArray( value, unit1 * baseUnit ) ),
        ( SimpleQuantityArray(value, unit1), unitFactor, SimpleQuantityArray( value, unit1 * unitFactor ) ),
        ( SimpleQuantityArray(value, unit1), unit2, SimpleQuantityArray( value, unit1 * unit2 ) )
    ]
    return examples
end

function AbstractUnit_SimpleQuantityArray_multiplication()
    examples = _getExamplesFor_AbstractUnit_SimpleQuantityArray_multiplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_AbstractUnit_SimpleQuantityArray_multiplication()
    value = TestingTools.generateRandomReal(dim=(2,3))
    unit1 = TestingTools.generateRandomUnit()
    baseUnit = TestingTools.generateRandomBaseUnit()
    unitFactor = TestingTools.generateRandomUnitFactor()
    unit2 = TestingTools.generateRandomUnit()

    # format: factor1, factor2, correct result for factor1 * factor2
    # where factor1 is an AbstractUnit and factor2 is a SimpleQuanity
    examples = [
        ( baseUnit, SimpleQuantityArray(value, unit1), SimpleQuantityArray( value, baseUnit * unit1 ) ),
        ( unitFactor, SimpleQuantityArray(value, unit1), SimpleQuantityArray( value, unitFactor * unit1 ) ),
        ( unit2, SimpleQuantityArray(value, unit1), SimpleQuantityArray( value, unit2 * unit1 ) )
    ]
    return examples
end

function SimpleQuantityArray_AbstractUnit_division()
    examples = _getExamplesFor_SimpleQuantityArray_AbstractUnit_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_SimpleQuantityArray_AbstractUnit_division()
    value = TestingTools.generateRandomReal(dim=(2,3))
    unit1 = TestingTools.generateRandomUnit()
    baseUnit = TestingTools.generateRandomBaseUnit()
    unitFactor = TestingTools.generateRandomUnitFactor()
    unit2 = TestingTools.generateRandomUnit()

    # format: dividend, divisor, correct result for dividend / divisor
    # where dividend is a SimpleQuanity and divisor is an AbstractUnit
    examples = [
        ( SimpleQuantityArray(value, unit1), baseUnit, SimpleQuantityArray( value, unit1 / baseUnit ) ),
        ( SimpleQuantityArray(value, unit1), unitFactor, SimpleQuantityArray( value, unit1 / unitFactor ) ),
        ( SimpleQuantityArray(value, unit1), unit2, SimpleQuantityArray( value, unit1 / unit2 ) )
    ]
    return examples
end


function AbstractUnit_SimpleQuantityArray_division()
    examples = _getExamplesFor_AbstractUnit_SimpleQuantityArray_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_AbstractUnit_SimpleQuantityArray_division()
    # we invert a random matrix:
    # almost all square matrices are invertible,
    # the subset of singular matrices is of zero measure, so we are mostly fine
    value = TestingTools.generateRandomReal(dim=(2,2))
    unit1 = TestingTools.generateRandomUnit()
    baseUnit = TestingTools.generateRandomBaseUnit()
    unitFactor = TestingTools.generateRandomUnitFactor()
    unit2 = TestingTools.generateRandomUnit()

    # format: dividend, divisor, correct result for dividend / divisor
    # where dividend is an AbstractUnit and divisor is a SimpleQuanity
    examples = [
        ( baseUnit, SimpleQuantityArray(value, unit1), SimpleQuantityArray( inv(value), baseUnit / unit1  ) ),
        ( unitFactor, SimpleQuantityArray(value, unit1), SimpleQuantityArray( inv(value), unitFactor / unit1  ) ),
        ( unit2, SimpleQuantityArray(value, unit1), SimpleQuantityArray( inv(value), unit2 / unit1  ) )
    ]
    return examples
end

## 2. Arithemtic unary and binary operators

function unaryPlus_implemented()
    randomSimpleQuantityArray = TestingTools.generateRandomSimpleQuantityArray()
    correct = (randomSimpleQuantityArray == +randomSimpleQuantityArray)
    return correct
end

function unaryMinus_implemented()
    examples = _getExamplesFor_unaryMinus()
    return TestingTools.testMonadicFunction(Base.:-, examples)
end

function _getExamplesFor_unaryMinus()
    # format: ::simpleQuantityArray, correct result for -simpleQuantityArray
    examples = [
        ( [7.5] * ucat.meter, [-7.5] * ucat.meter),
        ( [(-3.4 + 8.7im)] * ucat.ampere, [(3.4 - 8.7im)] * ucat.ampere)
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
        ( [2] * Alicorn.unitlessUnit, [1] * Alicorn.unitlessUnit, [3] * Alicorn.unitlessUnit ),
        ( [7; 3] * ucat.meter, [2; 1] * (ucat.milli * ucat.meter), [7.002; 3.001] * ucat.meter ),
        ( [2] * (ucat.milli * ucat.meter), [7] * ucat.meter , [7.002e3] * (ucat.milli * ucat.meter) )
    ]
    return examples
end

function test_addition_ErrorsForMismatchedDimensions()
    (mismatchedAddend1, mismatchedAddend2) = _generateDimensionMismatchedQuantityArrays()
    expectedError = Alicorn.Exceptions.DimensionMismatchError("summands are not of the same physical dimension")
    @test_throws expectedError (mismatchedAddend1 + mismatchedAddend2)
end

function _generateDimensionMismatchedQuantityArrays()
    unit = TestingTools.generateRandomUnit()
    mismatchedUnit = unit * Alicorn.meter

    value = TestingTools.generateRandomReal(dim=(3,2))
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
        ( [2] * Alicorn.unitlessUnit, [1] * Alicorn.unitlessUnit, [1]* Alicorn.unitlessUnit ),
        ( [7 3] * ucat.meter, [2 1] * (ucat.milli * ucat.meter), [6.998 2.999] * ucat.meter ),
        ( [2] * (ucat.milli * ucat.meter), [7] * ucat.meter , [-6.998e3] * (ucat.milli * ucat.meter) )
    ]
    return examples
end

function test_subtraction_ErrorsForMismatchedDimensions()
    (mismatchedAddend1, mismatchedAddend2) = _generateDimensionMismatchedQuantityArrays()
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
        ( ones(2,2) * Alicorn.unitlessUnit, ones(2,2)  * Alicorn.unitlessUnit, ( 2 * ones(2,2) ) * Alicorn.unitlessUnit ),
        ( [1 1] * Alicorn.unitlessUnit, [2, 2] * ucat.second, [4] * ucat.second ),
        ( [2, 2] * ucat.second, [1 1] * Alicorn.unitlessUnit, ( 2 * ones(2,2) ) * ucat.second ),
        ( [2.5 3.5] * ucat.meter,  [2, 2] * ucat.second, [12.0] * ucat.meter * ucat.second ),
        ( [2] * ucat.second, [2.5 2.5]* ucat.meter, [5.0 5.0] * ucat.second * ucat.meter ),
        ( [-7; 1] * ucat.lumen * (ucat.nano * ucat.second),  [2.5 2.5] * (ucat.pico * ucat.second) , [-17.5 -17.5; 2.5 2.5] * ucat.lumen * (ucat.nano * ucat.second) * (ucat.pico * ucat.second) ),
        ( [2 2] * (ucat.milli * ucat.candela)^-4, [4; 4] * (ucat.milli * ucat.candela)^2, [16] * (ucat.milli * ucat.candela)^-2 )
    ]
    return examples
end

function SimpleQuantityArray_Array_multiplication_implemented()
    examples = _getExamplesFor_SimpleQuantityArray_Array_multiplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_SimpleQuantityArray_Array_multiplication()
    # format: factor1, factor2, correct product factor1 * factor2
    examples = [
        ( ones(2,2) * Alicorn.unitlessUnit, ones(2,2), ( 2 * ones(2,2) ) * Alicorn.unitlessUnit ),
        ( [1 1] * ucat.second, [2, 2], [4] * ucat.second ),
        ( [2, 2] * ucat.meter, [1 1], ( 2 * ones(2,2) ) * ucat.meter ),
        ( [2.5 3.5] * ucat.meter,  [2, 2], [12.0] * ucat.meter ),
        ( [2] * ucat.second, [2.5 2.5], [5.0 5.0] * ucat.second ),
        ( [-7; 1] * ucat.lumen * (ucat.nano * ucat.second),  [2.5 2.5] , [-17.5 -17.5; 2.5 2.5] * ucat.lumen * (ucat.nano * ucat.second) ),
        ( [2 2] * (ucat.milli * ucat.candela)^-4, [4; 4], [16] * (ucat.milli * ucat.candela)^-4 )
    ]
    return examples
end

function Array_SimpleQuantityArray_multiplication_implemented()
    examples = _getExamplesFor_Array_SimpleQuantityArray_multiplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_Array_SimpleQuantityArray_multiplication()
    # format: factor1, factor2, correct product factor1 * factor2
    examples = [
        (  ones(2,2), ones(2,2) * Alicorn.unitlessUnit, ( 2 * ones(2,2) ) * Alicorn.unitlessUnit ),
        ( [1 1] , [2, 2] * ucat.second, [4] * ucat.second ),
        ( [2, 2] , [1 1] * ucat.meter, ( 2 * ones(2,2) ) * ucat.meter ),
        ( [2.5 3.5],  [2, 2] * ucat.meter, [12.0] * ucat.meter ),
        ( [2], [2.5 2.5] * ucat.second, [5.0 5.0] * ucat.second ),
        ( [-7; 1],  [2.5 2.5] * ucat.lumen * (ucat.nano * ucat.second), [-17.5 -17.5; 2.5 2.5] * ucat.lumen * (ucat.nano * ucat.second) ),
        ( [2 2] , [4; 4] * (ucat.milli * ucat.candela)^-4, [16] * (ucat.milli * ucat.candela)^-4 )
    ]
    return examples
end

function SimpleQuantityArray_SimpleQuantity_multiplication_implemented()
    examples = _getExamplesFor_SimpleQuantityArray_SimpleQuantity_multiplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_SimpleQuantityArray_SimpleQuantity_multiplication()
    # format: factor1, factor2, correct product factor1 * factor2
    examples = [
        ( ones(2,2) * Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit, ones(2,2) * Alicorn.unitlessUnit ),
        ( [1 1] * Alicorn.unitlessUnit, 2 * ucat.second, [2 2] * ucat.second ),
        ( [2, 2] * ucat.second, 1 * Alicorn.unitlessUnit, [2, 2] * ucat.second ),
        ( [2.5 3.5] * ucat.meter,  2 * ucat.second, [5 7] * ucat.meter * ucat.second ),
        ( [2] * ucat.second, 2.5 * ucat.meter, [5.0] * ucat.second * ucat.meter ),
        ( [-7; 1] * ucat.lumen * (ucat.nano * ucat.second),  2.5 * (ucat.pico * ucat.second) , [-17.5 ; 2.5 ] * ucat.lumen * (ucat.nano * ucat.second) * (ucat.pico * ucat.second) ),
        ( [2 2] * (ucat.milli * ucat.candela)^-4, 4 * (ucat.milli * ucat.candela)^2, [8 8] * (ucat.milli * ucat.candela)^-2 )
    ]
    return examples
end

function SimpleQuantity_SimpleQuantityArray_multiplication_implemented()
    examples = _getExamplesFor_SimpleQuantity_SimpleQuantityArray_multiplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_SimpleQuantity_SimpleQuantityArray_multiplication()
    # format: factor1, factor2, correct product factor1 * factor2
    examples = [
        ( 1 * Alicorn.unitlessUnit, ones(2,2) * Alicorn.unitlessUnit, ones(2,2) * Alicorn.unitlessUnit ),
        ( 2 * ucat.second, [1 1] * Alicorn.unitlessUnit, [2 2] * ucat.second ),
        ( 1 * Alicorn.unitlessUnit, [2, 2] * ucat.second, [2, 2] * ucat.second ),
        ( 2 * ucat.second, [2.5 3.5] * ucat.meter, [5 7] * ucat.meter * ucat.second ),
        ( 2.5 * ucat.meter, [2] * ucat.second, [5.0] * ucat.second * ucat.meter ),
        ( 2.5 * (ucat.pico * ucat.second), [-7; 1] * ucat.lumen * (ucat.nano * ucat.second), [-17.5 ; 2.5 ] * ucat.lumen * (ucat.nano * ucat.second) * (ucat.pico * ucat.second) ),
        ( 4 * (ucat.milli * ucat.candela)^2, [2 2] * (ucat.milli * ucat.candela)^-4, [8 8] * (ucat.milli * ucat.candela)^-2 )
    ]
    return examples
end

function SimpleQuantityArray_Number_multiplication_implemented()
    examples = _getExamplesFor_SimpleQuantityArray_Number_multiplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_SimpleQuantityArray_Number_multiplication()
    # format: factor1, factor2, correct product factor1 * factor2
    examples = [
        ( ones(2,2) * Alicorn.unitlessUnit, 1, ones(2,2) * Alicorn.unitlessUnit ),
        ( [1 1] * Alicorn.unitlessUnit, 2, [2 2] * Alicorn.unitlessUnit ),
        ( [2, 2] * ucat.second, 1, [2, 2] * ucat.second ),
        ( [2.5 3.5] * ucat.meter,  2, [5 7] * ucat.meter ),
        ( [2] * ucat.second, 2.5, [5.0] * ucat.second ),
        ( [-7; 1] * ucat.lumen * (ucat.nano * ucat.second), 2.5 , [-17.5 ; 2.5 ] * ucat.lumen * (ucat.nano * ucat.second) ),
        ( [2 2] * (ucat.milli * ucat.candela)^-4, 4, [8 8] * (ucat.milli * ucat.candela)^-4 )
    ]
    return examples
end

function Number_SimpleQuantityArray_multiplication_implemented()
    examples = _getExamplesFor_Number_SimpleQuantityArray_multiplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_Number_SimpleQuantityArray_multiplication()
    # format: factor1, factor2, correct product factor1 * factor2
    examples = [
        ( 1, ones(2,2) * Alicorn.unitlessUnit, ones(2,2) * Alicorn.unitlessUnit ),
        ( 2, [1 1] * Alicorn.unitlessUnit, [2 2] * Alicorn.unitlessUnit ),
        ( 1, [2, 2] * ucat.second, [2, 2] * ucat.second ),
        ( 2, [2.5 3.5] * ucat.meter, [5 7] * ucat.meter ),
        ( 2.5, [2] * ucat.second, [5.0] * ucat.second ),
        ( 2.5 , [-7; 1] * ucat.lumen * (ucat.nano * ucat.second), [-17.5 ; 2.5 ] * ucat.lumen * (ucat.nano * ucat.second) ),
        ( 4, [2 2] * (ucat.milli * ucat.candela)^-4, [8 8] * (ucat.milli * ucat.candela)^-4 )
    ]
    return examples
end

function division_implemented()
    examples = _getExamplesFor_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_division()
    # format: factor1, factor2, correct quotient factor1 / factor2
    examples = [
        ( [1; 2] * Alicorn.unitlessUnit, [1; 1]  * Alicorn.unitlessUnit, [ 0.5 0.5; 1.0 1.0 ]* Alicorn.unitlessUnit ),
        ( [1, 1] * Alicorn.unitlessUnit, [2, 2] * ucat.second, 0.25 * ones(2,2) / ucat.second ),
        ( [2] * ucat.second, [1] * Alicorn.unitlessUnit, ([2] / [1]) * ucat.second ),
        ( [12] * ucat.meter,  [2, 2] * ucat.second, [3.0 3.0] * ucat.meter / ucat.second ),
        ( [5, 2] * ucat.second, [2]* ucat.meter, ([5, 2] / [2]) * ucat.second / ucat.meter ),
        ( [-7; 1] * ucat.lumen * (ucat.nano * ucat.second), [2] * (ucat.pico * ucat.second) , ([-7; 1]/[2]) * ucat.lumen * (ucat.nano * ucat.second) / (ucat.pico * ucat.second) ),
        ( [2] * (ucat.milli * ucat.candela)^-4, [4] * (ucat.milli * ucat.candela)^2, ([2]/[4]) * (ucat.milli * ucat.candela)^-6 )
    ]
    return examples
end

function SimpleQuantityArray_Array_division_implemented()
    examples = _getExamplesFor_SimpleQuantityArray_Array_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_SimpleQuantityArray_Array_division()
    # format: factor1, factor2, correct quotient factor1 / factor2
    examples = [
        ( [1; 2] * Alicorn.unitlessUnit, [1; 1], [ 0.5 0.5; 1.0 1.0 ]* Alicorn.unitlessUnit ),
        ( [1, 1] * ucat.second, [2, 2] , 0.25 * ones(2,2) * ucat.second ),
        ( [12] * ucat.meter,  [2, 2] , [3.0 3.0] * ucat.meter ),
        ( [5, 2] * ucat.second, [2], ([5, 2] / [2]) * ucat.second ),
        ( [-7; 1] * ucat.lumen * (ucat.nano * ucat.second), [2] , ([-7; 1]/[2]) * ucat.lumen * (ucat.nano * ucat.second) ),
        ( [2] * (ucat.milli * ucat.candela)^-4, [4], ([2]/[4]) * (ucat.milli * ucat.candela)^-4 )
    ]
    return examples
end

function Array_SimpleQuantityArray_division_implemented()
    examples = _getExamplesFor_Array_SimpleQuantityArray_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_Array_SimpleQuantityArray_division()
    # format: factor1, factor2, correct quotient factor1 / factor2
    examples = [
        ( [1; 2], [1; 1] * Alicorn.unitlessUnit, [ 0.5 0.5; 1.0 1.0 ] * Alicorn.unitlessUnit ),
        ( [1, 1], [2, 2] * ucat.second, 0.25 * ones(2,2) / ucat.second ),
        ( [12],  [2, 2] * ucat.meter, [3.0 3.0] / ucat.meter ),
        ( [5, 2], [2] * ucat.second, ([5, 2] / [2]) / ucat.second ),
        ( [-7; 1], [2]  * ucat.lumen * (ucat.nano * ucat.second), ([-7; 1]/[2]) / ( ucat.lumen * (ucat.nano * ucat.second) ) ),
        ( [2], [4] * (ucat.milli * ucat.candela)^-4, ([2]/[4]) * (ucat.milli * ucat.candela)^4 )
    ]
    return examples
end

function SimpleQuantityArray_SimpleQuantity_division_implemented()
    examples = _getExamplesFor_SimpleQuantityArray_SimpleQuantity_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_SimpleQuantityArray_SimpleQuantity_division()
    # format: factor1, factor2, correct quotient factor1 / factor2
    examples = [
        ( [1; 2] * Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit, [1; 2] * Alicorn.unitlessUnit ),
        ( [1, 1] * Alicorn.unitlessUnit, 2 * ucat.second, [0.5, 0.5] / ucat.second ),
        ( [2] * ucat.second, 4 * Alicorn.unitlessUnit, [0.5]  * ucat.second ),
        ( [12] * ucat.meter,  2 * ucat.second, [6] * ucat.meter / ucat.second ),
        ( [5, 2] * ucat.second, 2 * ucat.meter, [2.5, 1] * ucat.second / ucat.meter ),
        ( [-7; 1] * ucat.lumen * (ucat.nano * ucat.second),  2 * (ucat.pico * ucat.second) , [-3.5; 0.5] * ucat.lumen * (ucat.nano * ucat.second) / (ucat.pico * ucat.second) ),
        ( [2] * (ucat.milli * ucat.candela)^-4, 4 * (ucat.milli * ucat.candela)^2, [0.5] * (ucat.milli * ucat.candela)^-6 )
    ]
    return examples
end

function SimpleQuantity_SimpleQuantityArray_division_implemented()
    examples = _getExamplesFor_SimpleQuantity_SimpleQuantityArray_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_SimpleQuantity_SimpleQuantityArray_division()
    # format: factor1, factor2, correct quotient factor1 / factor2
    examples = [
        ( 1 * Alicorn.unitlessUnit, [1; 2] * Alicorn.unitlessUnit, (1/[1; 2]) * Alicorn.unitlessUnit ),
        ( 2 * ucat.second, [1, 1] * Alicorn.unitlessUnit, (2/[1,1]) * ucat.second ),
        ( 4 * Alicorn.unitlessUnit, [2] * ucat.second, (4/[2]) / ucat.second ),
        ( 2 * ucat.second, [12] * ucat.meter, (2/[12]) * ucat.second / ucat.meter ),
        ( 2 * ucat.meter, [5, 2] * ucat.second, ( 2/[5, 2] ) * ucat.meter / ucat.second ),
        ( 2 * (ucat.pico * ucat.second), [-7; 1] * ucat.lumen * (ucat.nano * ucat.second), ( 2 / [-7; 1]) * (ucat.pico * ucat.second) / ( ucat.lumen * (ucat.nano * ucat.second) ) ),
        ( 4 * (ucat.milli * ucat.candela)^2, [2] * (ucat.milli * ucat.candela)^-4, (4/[2]) * (ucat.milli * ucat.candela)^6 )
    ]
    return examples
end

function SimpleQuantityArray_Number_division_implemented()
    examples = _getExamplesFor_SimpleQuantityArray_Number_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_SimpleQuantityArray_Number_division()
    # format: factor1, factor2, correct quotient factor1 / factor2
    examples = [
        ( [1; 2] * Alicorn.unitlessUnit, 1, [1; 2] * Alicorn.unitlessUnit ),
        ( [1, 1] * ucat.second, 2, [0.5, 0.5] * ucat.second ),
        ( [2] * ucat.second, 4, [0.5]  * ucat.second ),
        ( [12] * ucat.meter,  2, [6] * ucat.meter ),
        ( [5, 2] * ucat.second, 2, [2.5, 1] * ucat.second ),
        ( [-7; 1] * ucat.lumen * (ucat.nano * ucat.second),  2, [-3.5; 0.5] * ucat.lumen * (ucat.nano * ucat.second) ),
        ( [2] * (ucat.milli * ucat.candela)^-4, 4, [0.5] * (ucat.milli * ucat.candela)^-4 )
    ]
    return examples
end

function Number_SimpleQuantityArray_division_implemented()
    examples = _getExamplesFor_Number_SimpleQuantityArray_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_Number_SimpleQuantityArray_division()
    # format: factor1, factor2, correct quotient factor1 / factor2
    examples = [
        ( 1, [1; 2] * Alicorn.unitlessUnit, (1/[1; 2]) * Alicorn.unitlessUnit ),
        ( 2, [1, 1] * ucat.second, (2/[1,1]) / ucat.second ),
        ( 4, [2] * ucat.second, (4/[2]) / ucat.second ),
        ( 2, [12] * ucat.meter, (2/[12]) / ucat.meter ),
        ( 2, [5, 2] * ucat.second, ( 2/[5, 2] ) / ucat.second ),
        ( 2 , [-7; 1] * ucat.lumen * (ucat.nano * ucat.second), ( 2 / [-7; 1]) / ( ucat.lumen * (ucat.nano * ucat.second) ) ),
        ( 4, [2] * (ucat.milli * ucat.candela)^-4, (4/[2]) * (ucat.milli * ucat.candela)^4 )
    ]
    return examples
end

function inverseDivision_implemented()
    return false
end

function SimpleQuantityArray_Array_inverseDivision_implemented()
    return false
end

function Array_SimpleQuantityArray_inverseDivision_implemented()
    return false
end

function SimpleQuantityArray_SimpleQuantity_inverseDivision_implemented()
    return false
end

function SimpleQuantity_SimpleQuantityArray_inverseDivision_implemented()
    return false
end

function SimpleQuantityArray_Number_inverseDivision_implemented()
    return false
end

function Number_SimpleQuantityArray_inverseDivision_implemented()
    return false
end

## Additional array methods

function transpose_implemented()
    examples = _getExamplesFor_transpose()
    return TestingTools.testMonadicFunction(Base.transpose, examples)
end

function _getExamplesFor_transpose()
    # format: sqArray::SimpleQuantityArray, correct result for transpose(sqArray)

    sqArray1 = [2, 3] * ucat.second
    sqArray2 = [2.0 3.0; 1.0 5.7] * ucat.meter

    examples = [
        (sqArray1, [2 3] * ucat.second),
        (sqArray2, [2.0 1.0; 3.0 5.7 ] * ucat.meter)
    ]
    return examples
end

function repeat_implemented()
    examples = _getExamplesFor_repeat()
    return _test_repeat(examples)
end

function _getExamplesFor_repeat()
    # format: sqArray::SimpleQuantityArray, counts, correct result for repeat(sqArray, counts)

    sqArray = [1, 2] * ucat.second

    examples = [
        (sqArray, 2, [1, 2, 1, 2] * ucat.second),
        (sqArray, (2 ,3), repeat([1, 2], 2, 3) * ucat.second)
    ]
    return examples
end

function _test_repeat(examples)
    correct = true
    for (sqArray, counts, correctResult) in examples
        returnedResult = repeat(sqArray, counts...)
        correct &= (returnedResult == correctResult)
    end
    return true
end

function repeat_withInnerOuter_implemented()
    examples = _getExamplesFor_repeat_withInnerOuter()
    return _test_repeat_withInnerOuter(examples)
end

function _getExamplesFor_repeat_withInnerOuter()
    # format: sqArray::SimpleQuantityArray, tuple1, tuple2, correct result for repeat(sqArray, tuple1, tuple2)

    sqArray = [2, 3] * ucat.second

    examples = [
        (sqArray, 2, nothing, [2, 2, 3, 3] * ucat.second),
        (sqArray, nothing, 3, [2, 3, 2, 3, 2, 3] * ucat.second),
        (sqArray, 2, 3, [2, 2, 3, 3, 2, 2, 3, 3, 2, 2, 3, 3] * ucat.second),
    ]
    return examples
end

function _test_repeat_withInnerOuter(examples)
    correct = true
    for (sqArray, inner, outer, correctResult) in examples
        returnedResult = repeat(sqArray, inner=inner, outer=outer)
        correct &= (returnedResult == correctResult)
    end
    return true
end

## Additional methods

function valueOfDimensionless_implemented()
    examples = _getExamplesFor_valueOfDimensionless()
    return TestingTools.testMonadicFunction(valueOfDimensionless, examples)
end

function _getExamplesFor_valueOfDimensionless()
    # format: quantity, correct result for valueOfDimensionless(quantity)
    examples = [
        (SimpleQuantityArray([2, 3]), [2, 3]),
        (SimpleQuantityArray([2, 3], ucat.meter * (ucat.centi * ucat.meter)^-1 ), [200, 300])
    ]
    return examples
end

function test_valueOfDimensionless_ErrorsIfNotUnitless()
    sqArray = [2, 3] * Alicorn.meter
    expectedError = Alicorn.Exceptions.DimensionMismatchError("quantity array is not dimensionless")
    @test_throws expectedError valueOfDimensionless(sqArray)
end

end # module

# # TODO: Examples copied from SimpleQuantityTests
#
# function _getMatrixExamplesFor_addition()
#     # format: addend1, addend2, correct sum
#     examples = [
#         ( [2, 1] * Alicorn.unitlessUnit, [1, 2] * Alicorn.unitlessUnit, [3, 3] * Alicorn.unitlessUnit ),
#         ( [7; 2] * ucat.siemens, [2; 7] * (ucat.milli * ucat.siemens), [7.002; 2.007] * ucat.siemens ),
#         ( [2; 7] * (ucat.milli * ucat.second), [7; 2] * ucat.second , [7.002e3; 2.007e3] * (ucat.milli * ucat.second) )
#     ]
#     return examples
# end
#
# function _getMatrixExamplesFor_subtraction()
#     # format: addend1, addend2, correct sum
#     examples = [
#         ( [2, 1] * Alicorn.unitlessUnit, [1, 2] * Alicorn.unitlessUnit, [1, -1] * Alicorn.unitlessUnit ),
#         ( [7; 2] * ucat.siemens, [2; 7] * (ucat.milli * ucat.siemens), [6.998; 1.993] * ucat.siemens ),
#         ( [2; 7] * (ucat.milli * ucat.second), [7; 2] * ucat.second , [-6.998e3; -1.993e3] * (ucat.milli * ucat.second) )
#     ]
#     return examples
# end
#
# function _getMatrixExamplesFor_multiplication()
#     # format: factor1, factor2, correct product factor1 * factor2
#     examples = [
#         ( [1 1] * Alicorn.unitlessUnit, [1; 1] * Alicorn.unitlessUnit, [2] * Alicorn.unitlessUnit ),
#         ( [1 0; 2 0] * Alicorn.unitlessUnit, [2 3; 4 5] * ucat.second, [2 3; 4 6] * ucat.second ),
#         ( [2 3; 4 5] * ucat.second, [1 0; 2 0] * Alicorn.unitlessUnit, [8 0; 14 0] * ucat.second ),
#         ( [2.5] * ucat.meter, [2 3] * ucat.second, [5 7.5] * ucat.meter * ucat.second ),
#         ( [2.5] * ucat.second, [2 3] * ucat.meter, [5 7.5] * ucat.second * ucat.meter )
#     ]
#     return examples
# end
#
#
# function _getMatrixExamplesFor_multiplicationWithDimensionless()
#     # format: factor1, factor2, correct product factor1 * factor2
#     examples = [
#         ( [1 1] * Alicorn.unitlessUnit, [1; 1], [2] * Alicorn.unitlessUnit ),
#         ( [1 1], [1; 1] * Alicorn.unitlessUnit, [2] * Alicorn.unitlessUnit ),
#         ( [1 0; 2 0] * ucat.second, [2 3; 4 5] , [2 3; 4 6] * ucat.second ),
#         ( [2 3; 4 5], [1 0; 2 0] * ucat.second, [8 0; 14 0] * ucat.second )
#     ]
#     return examples
# end
#
# function _getMixedExamplesFor_multiplicationWithDimensionless()
#     # format: factor1, factor2, correct product factor1 * factor2
#     examples = [
#         ( [1 1] * Alicorn.unitlessUnit, 2, [2 2] * Alicorn.unitlessUnit ),
#         ( 2, [1 1] * Alicorn.unitlessUnit, [2 2] * Alicorn.unitlessUnit ),
#         ( [1 0; 2 0] * ucat.second, 3, [3 0; 6 0] * ucat.second ),
#         ( 3, [1 0; 2 0] * ucat.second, [3 0; 6 0] * ucat.second ),
#         ( 2.5 * ucat.meter, [2 3] , [5 7.5] * ucat.meter  ),
#         ( [2 3], 2.5 * ucat.meter, [5 7.5] * ucat.meter  )
#     ]
#     return examples
# end
#
# function _getMixedExamplesFor_division()
#     # format: factor1, factor2, correct product factor1 * factor2
#     examples = [
#         ( [1 1] * Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit, [1 1] * Alicorn.unitlessUnit ),
#         ( [2, 3] * Alicorn.unitlessUnit, 2 * ucat.second, [1, 1.5] * ucat.second^-1 ),
#         ( [2; 10] * ucat.second, 5 * Alicorn.unitlessUnit, [0.4; 2] * ucat.second ),
#         ( [4 4] * ucat.meter,  2 * ucat.second, [2 2] * ucat.meter / ucat.second ),
#         ( [4 4] * ucat.second, 2 * ucat.meter, [2 2] * ucat.second / ucat.meter ),
#         ( [-7 -7] * ucat.lumen * (ucat.nano * ucat.second),  2 * (ucat.pico * ucat.second) , [-3.5 -3.5] * ucat.lumen * (ucat.nano * ucat.second) / (ucat.pico * ucat.second) ),
#         ( [2 2; 2 2] * (ucat.milli * ucat.candela)^-4, 4 * (ucat.milli * ucat.candela)^2, [0.5 0.5; 0.5 0.5] * (ucat.milli * ucat.candela)^-6 )
#     ]
#     return examples
# end
#
# function _getMixedExamplesFor_divisionByDimensionless()
#     # format: factor1, factor2, correct product factor1 * factor2
#     examples = [
#         ( [1 1] * Alicorn.unitlessUnit, 1, [1 1] * Alicorn.unitlessUnit ),
#         ( [1 1], 1 * Alicorn.unitlessUnit, [1 1] * Alicorn.unitlessUnit ),
#         ( [2, 3] * ucat.second, 2 , [1, 1.5] * ucat.second ),
#         ( [2, 3] , 2 * ucat.second , [1, 1.5] / ucat.second ),
#     ]
#     return examples
# end
#
# function _getMatrixExamplesFor_inv()
#     # format: SimpleQuantity, correct result for SimpleQuantity^-1
#     examples = [
#         ( [1 0 ; 0 1] * Alicorn.unitlessUnit, [1 0 ; 0 1] * Alicorn.unitlessUnit),
#         ( [2 4; 2 8] * ucat.meter, [1 -0.5; -0.25 0.25] * ucat.meter^-1),
#         ( -[2 4; 2 8] * (ucat.femto * ucat.meter)^-1 * ucat.joule, -[1 -0.5; -0.25 0.25] * (ucat.femto * ucat.meter) * ucat.joule^-1 )
#     ]
#     return examples
# end
#
# function _getMatrixExamplesFor_exponentiation()
#     # format: SimpleQuantity, exponent, correct result for SimpleQuantity^exponent
#     examples = [
#         ( [1 0; 0 1] * Alicorn.unitlessUnit, 1, [1 0; 0 1] * Alicorn.unitlessUnit ),
#         ( [1 0; 0 1] * Alicorn.unitlessUnit, 2, [1 0; 0 1] * Alicorn.unitlessUnit ),
#         ( [1 2; 3 4] * ucat.meter, 0, [1 0; 0 1] * Alicorn.unitlessUnit ),
#     ]
#     return examples
# end
#
#
# function _getMatrixExamplesFor_sqrt()
#     # format: SimpleQuantity, correct result for sqrt(SimpleQuantity)
#     examples = [
#         ( [1 0; 0 1] * Alicorn.unitlessUnit, [1 0; 0 1] * Alicorn.unitlessUnit),
#         ( [4 0; 0 4] * (ucat.pico * ucat.meter)^-3, [2 0; 0 2] * (ucat.pico * ucat.meter)^-1.5 )
#     ]
#     return examples
# end
#
# function _getMatrixExamplesFor_size()
#     # format: SimpleQuantity, correct result for size(SimpleQuantity)
#     examples = [
#         ( [1 0; 0 1; 2 3] * (ucat.pico * ucat.meter)^-3, (3, 2) ),
#         ( [1 0 2; 0 1 3] * (ucat.pico * ucat.meter)^-3, (2, 3) )
#     ]
#     return examples
# end
#
#
# function _getMatrixExamplesFor_length()
#     # format: SimpleQuantity, correct result for sqrt(SimpleQuantity)
#     examples = [
#         ( [1 0; 0 1; 2 3] * (ucat.pico * ucat.meter)^-3, 6)
#     ]
#     return examples
# end
