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
        @test multiplication_implemented()
        @test SimpleQuantityArray_SimpleQuantity_multiplication_implemented()
        @test SimpleQuantity_SimpleQuantityArray_multiplication_implemented()
        @test SimpleQuantityArray_Number_multiplication_implemented()
        @test Number_SimpleQuantityArray_multiplication_implemented()

    end
end

## #- Constructors

function canInstanciateSQArrayWithRealArray()
    values = TestingTools.generateRandomReal(dim = (2,2))
    unit = TestingTools.generateRandomUnit()
    sqArray = SimpleQuantityArray(values, unit)
    correctFields = Dict([
        ("values", values),
        ("unit", unit)
    ])
    return _verifyHasCorrectFields(sqArray, correctFields)
end

function _verifyHasCorrectFields(sqArray::SimpleQuantityArray, correctFields::Dict{String,Any})
    correctValue = (sqArray.values == correctFields["values"])
    correctUnit = (sqArray.unit == correctFields["unit"])
    correct = correctValue && correctUnit
    return correct
end

function canInstanciateSQArrayWithComplexArray()
    values = TestingTools.generateRandomComplex(dim = (2,2))
    unit = TestingTools.generateRandomUnit()
    sqArray = SimpleQuantityArray(values, unit)
    correctFields = Dict([
        ("values", values),
        ("unit", unit)
    ])
    return _verifyHasCorrectFields(sqArray, correctFields)
end

function canInstanciateSQArraWithBaseUnit()
    values = TestingTools.generateRandomReal(dim = (2,2))
    baseUnit = TestingTools.generateRandomBaseUnit()
    unit = convertToUnit(baseUnit)

    sqArray = SimpleQuantityArray(values, baseUnit)
    correctFields = Dict([
        ("values", values),
        ("unit", unit)
    ])
    return _verifyHasCorrectFields(sqArray, correctFields)
end

function canInstanciateSQArraWithUnitFactor()
    values = TestingTools.generateRandomComplex(dim = (2,2))
    unitFactor = TestingTools.generateRandomUnitFactor()
    unit = convertToUnit(unitFactor)

    sqArray = SimpleQuantityArray(values, unitFactor)
    correctFields = Dict([
        ("values", values),
        ("unit", unit)
    ])
    return _verifyHasCorrectFields(sqArray, correctFields)
end

function canInstanciateSQArraWithoutUnit()
    values = TestingTools.generateRandomComplex(dim = (2,2))
    sqArray = SimpleQuantityArray(values)
    correctFields = Dict([
        ("values", values),
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
        ( sqArray, 1, array[1] ),
        ( sqArray, 6, array[6] ),
        ( sqArray, (2,3), array[2,3] )
    ]
end

function setindex!_implemented()
    examples = _getExamplesFor_setindex!()
    return _test_setindex!(examples)
end

function _getExamplesFor_setindex!()
    unit = TestingTools.generateRandomUnit()

    array = zeros(3,4)
    sqArray = SimpleQuantityArray(array, unit )

    array1 = deepcopy(array)
    array1[1] = 7

    array2 = deepcopy(array)
    array2[2,3] = 9

    array3 = deepcopy(array)
    array3[1:3] = [7, 8, 9]

    # format: ::SimpleQuantityArray, vector, indices, correct result for setindex!(::SimpleQuantityArray, vector, indices)
    examples = [
        ( deepcopy(sqArray), 7, 1, SimpleQuantityArray(array1, unit ) ),
        ( deepcopy(sqArray), 9, (2,3), SimpleQuantityArray(array2, unit ) ),
        ( deepcopy(sqArray), [7, 8, 9], 1:3, SimpleQuantityArray(array3, unit ) )
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
    values = TestingTools.generateRandomReal(dim=(2,3))
    unit1 = TestingTools.generateRandomUnit()
    baseUnit = TestingTools.generateRandomBaseUnit()
    unitFactor = TestingTools.generateRandomUnitFactor()
    unit2 = TestingTools.generateRandomUnit()

    # format: factor1, factor2, correct result for factor1 * factor2
    # where factor1 is a SimpleQuanity and factor2 is an AbstractUnit
    examples = [
        ( SimpleQuantityArray(values, unit1), baseUnit, SimpleQuantityArray( values, unit1 * baseUnit ) ),
        ( SimpleQuantityArray(values, unit1), unitFactor, SimpleQuantityArray( values, unit1 * unitFactor ) ),
        ( SimpleQuantityArray(values, unit1), unit2, SimpleQuantityArray( values, unit1 * unit2 ) )
    ]
    return examples
end

function AbstractUnit_SimpleQuantityArray_multiplication()
    examples = _getExamplesFor_AbstractUnit_SimpleQuantityArray_multiplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_AbstractUnit_SimpleQuantityArray_multiplication()
    values = TestingTools.generateRandomReal(dim=(2,3))
    unit1 = TestingTools.generateRandomUnit()
    baseUnit = TestingTools.generateRandomBaseUnit()
    unitFactor = TestingTools.generateRandomUnitFactor()
    unit2 = TestingTools.generateRandomUnit()

    # format: factor1, factor2, correct result for factor1 * factor2
    # where factor1 is an AbstractUnit and factor2 is a SimpleQuanity
    examples = [
        ( baseUnit, SimpleQuantityArray(values, unit1), SimpleQuantityArray( values, baseUnit * unit1 ) ),
        ( unitFactor, SimpleQuantityArray(values, unit1), SimpleQuantityArray( values, unitFactor * unit1 ) ),
        ( unit2, SimpleQuantityArray(values, unit1), SimpleQuantityArray( values, unit2 * unit1 ) )
    ]
    return examples
end

function SimpleQuantityArray_AbstractUnit_division()
    examples = _getExamplesFor_SimpleQuantityArray_AbstractUnit_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_SimpleQuantityArray_AbstractUnit_division()
    values = TestingTools.generateRandomReal(dim=(2,3))
    unit1 = TestingTools.generateRandomUnit()
    baseUnit = TestingTools.generateRandomBaseUnit()
    unitFactor = TestingTools.generateRandomUnitFactor()
    unit2 = TestingTools.generateRandomUnit()

    # format: dividend, divisor, correct result for dividend / divisor
    # where dividend is a SimpleQuanity and divisor is an AbstractUnit
    examples = [
        ( SimpleQuantityArray(values, unit1), baseUnit, SimpleQuantityArray( values, unit1 / baseUnit ) ),
        ( SimpleQuantityArray(values, unit1), unitFactor, SimpleQuantityArray( values, unit1 / unitFactor ) ),
        ( SimpleQuantityArray(values, unit1), unit2, SimpleQuantityArray( values, unit1 / unit2 ) )
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
    values = TestingTools.generateRandomReal(dim=(2,2))
    unit1 = TestingTools.generateRandomUnit()
    baseUnit = TestingTools.generateRandomBaseUnit()
    unitFactor = TestingTools.generateRandomUnitFactor()
    unit2 = TestingTools.generateRandomUnit()

    # format: dividend, divisor, correct result for dividend / divisor
    # where dividend is an AbstractUnit and divisor is a SimpleQuanity
    examples = [
        ( baseUnit, SimpleQuantityArray(values, unit1), SimpleQuantityArray( inv(values), baseUnit / unit1  ) ),
        ( unitFactor, SimpleQuantityArray(values, unit1), SimpleQuantityArray( inv(values), unitFactor / unit1  ) ),
        ( unit2, SimpleQuantityArray(values, unit1), SimpleQuantityArray( inv(values), unit2 / unit1  ) )
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

    values = TestingTools.generateRandomReal(dim=(3,2))
    mismatchedAddend1 = values * unit
    mismatchedAddend2 = (2*values) * mismatchedUnit

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

function SimpleQuantityArray_SimpleQuantity_multiplication_implemented()
    return false
end
function SimpleQuantity_SimpleQuantityArray_multiplication_implemented()
    return false
end
function SimpleQuantityArray_Number_multiplication_implemented()
    return false
end
function Number_SimpleQuantityArray_multiplication_implemented()
    return false
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
