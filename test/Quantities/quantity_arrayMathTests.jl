module quantity_arrayMathTests

using Alicorn
using Test
using ..TestingTools

const ucat = UnitCatalogue()

function run()
    @testset "quantity_arrayMathTests" begin
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
        @test inverseDivision_implemented()
        @test SimpleQuantityArray_Array_inverseDivision_implemented()
        @test Array_SimpleQuantityArray_inverseDivision_implemented()
        # SimpleQuantityArray \ SimpleQuantity not required, since there is no function Base.\(::Array, ::Number)
        @test SimpleQuantity_SimpleQuantityArray_inverseDivision_implemented()
        # SimpleQuantityArray \ Number not required, since there is no function Base.\(::Array, ::Number)
        @test Number_SimpleQuantityArray_inverseDivision_implemented()
        @test exponentiation_implemented()
        @test inv_implemented()

        # 3. Numeric comparison
        @test equality_implemented()
        test_equality_ErrorsForMismatchedDimensions()
        @test isapprox_implemented()
        test_isapprox_ErrorsForMismatchedDimensions()

        # 4. Complex numbers
        @test real_implemented()
        @test imag_implemented()
        @test conj_implemented()

        # 5. Array methods
        @test eltype_implemented()
        @test length_implemented()
        @test ndims_implemented()
        @test axes_implemented()
        @test axes_withDims_implemented()
        @test findmax_implemented()
        @test findmax_withDims_implemented()
        @test findmin_implemented()
        @test findmin_withDims_implemented()

        @test transpose_implemented()
        @test repeat_implemented()
        @test repeat_withInnerOuter_implemented()
    end
end

## #- AbstractArray interface

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
    examples = _getExamplesFor_inverseDivision()
    return TestingTools.testDyadicFunction(Base.:\, examples)
end

function _getExamplesFor_inverseDivision()
    # format: factor1, factor2, correct quotient factor1 \ factor2
    examples = [
        ( [4 3; 2 1] * Alicorn.unitlessUnit, [5, 6] * Alicorn.unitlessUnit, [6.5; -7] * Alicorn.unitlessUnit ),
        ( [4 3; 2 1] * ucat.second, [5, 6] * Alicorn.unitlessUnit, [6.5; -7] / ucat.second ),
        ( [4 3; 2 1] * Alicorn.unitlessUnit, [5, 6] * ucat.second, [6.5; -7] * ucat.second ),
        ( [4 3; 2 1] * ucat.second, [5, 6] * ucat.meter, [6.5; -7] * ucat.meter / ucat.second )
    ]
    return examples
end

function SimpleQuantityArray_Array_inverseDivision_implemented()
    examples = _getExamplesFor_SimpleQuantityArray_Array_inverseDivision()
    return TestingTools.testDyadicFunction(Base.:\, examples)
end

function _getExamplesFor_SimpleQuantityArray_Array_inverseDivision()
    # format: factor1, factor2, correct quotient factor1 \ factor2
    examples = [
        ( [4 3; 2 1] * Alicorn.unitlessUnit, [5, 6], [6.5; -7] * Alicorn.unitlessUnit ),
        ( [4 3; 2 1] * ucat.second, [5, 6], [6.5; -7] / ucat.second )
    ]
    return examples
end

function Array_SimpleQuantityArray_inverseDivision_implemented()
    examples = _getExamplesFor_Array_SimpleQuantityArray_inverseDivision()
    return TestingTools.testDyadicFunction(Base.:\, examples)
end

function _getExamplesFor_Array_SimpleQuantityArray_inverseDivision()
    # format: factor1, factor2, correct quotient factor1 \ factor2
    examples = [
        ( [4 3; 2 1], [5, 6] * Alicorn.unitlessUnit, [6.5; -7] / Alicorn.unitlessUnit ),
        ( [4 3; 2 1], [5, 6] * ucat.second, [6.5; -7] * ucat.second )
    ]
    return examples
end

function SimpleQuantity_SimpleQuantityArray_inverseDivision_implemented()
    examples = _getExamplesFor_SimpleQuantity_SimpleQuantityArray_inverseDivision()
    return TestingTools.testDyadicFunction(Base.:\, examples)
end

function _getExamplesFor_SimpleQuantity_SimpleQuantityArray_inverseDivision()
    # format: factor1, factor2, correct quotient factor1 \ factor2
    examples = [
        ( 2 * Alicorn.unitlessUnit, [1; 2] * Alicorn.unitlessUnit, (2 \ [1; 2]) * Alicorn.unitlessUnit ),
        ( 8 * ucat.second, [2; 2] * Alicorn.unitlessUnit, (8 \ [2; 2]) / ucat.second ),
        ( 2 * (ucat.milli * ucat.candela)^2, [-4] * ucat.meter, (2\[-4]) * (ucat.meter * (ucat.milli * ucat.candela)^-2) )
    ]
    return examples
end

function Number_SimpleQuantityArray_inverseDivision_implemented()
    examples = _getExamplesFor_Number_SimpleQuantityArray_inverseDivision()
    return TestingTools.testDyadicFunction(Base.:\, examples)
end

function _getExamplesFor_Number_SimpleQuantityArray_inverseDivision()
    # format: factor1, factor2, correct quotient factor1 \ factor2
    examples = [
        ( 2, [1; 2] * Alicorn.unitlessUnit, (2 \ [1; 2]) * Alicorn.unitlessUnit ),
        ( 8, [2; 2] * ucat.second, (8 \ [2; 2]) * ucat.second ),
        ( 2, [-4] * (ucat.milli * ucat.candela)^2, (2\[-4]) * (ucat.milli * ucat.candela)^2 )
    ]
    return examples
end

function exponentiation_implemented()
    examples = _getExamplesFor_exponentiation()
    return TestingTools.testDyadicFunction(Base.:^, examples)
end

function _getExamplesFor_exponentiation()
    # format: ::SimpleQuantityArray, exponent, correct result for ::SimpleQuantityArray^exponent
    examples = [
        ( [1 0;0 1] * Alicorn.unitlessUnit, 1, [1 0;0 1] * Alicorn.unitlessUnit ),
        ( [2 0;0 2] * ucat.meter, 0, [1 0;0 1] * Alicorn.unitlessUnit),
        ( [2 0;0 2] * ucat.meter, 2.0, [4 0;0 4] * (ucat.meter^2) ),
        ( [2 0;0 2.0] * ucat.meter, -1, [0.5 0; 0 0.5] / ucat.meter)
    ]
    return examples
end

function inv_implemented()
    examples = _getExamplesFor_inv()
    return TestingTools.testMonadicFunction(Base.inv, examples)
end

function _getExamplesFor_inv()
    # format: ::SimpleQuantityArray, correct result for inv(::SimpleQuantityArray)
    examples = [
        ( [1 0 ; 0 1] * Alicorn.unitlessUnit, [1 0 ; 0 1]* Alicorn.unitlessUnit),
        ( [2 4; 8 12] * ucat.meter, [-1.5 0.5; 1 -0.25] * ucat.meter^-1)
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

    sqArray1 = SimpleQuantityArray([2], baseUnit)
    sqArray1Copy = SimpleQuantityArray([2], baseUnit)

    sqArray2 = SimpleQuantityArray([0.2], ucat.deca * baseUnit)
    sqArray3 = SimpleQuantityArray([7.1 6; 2.0 3], baseUnit)
    sqArray4 = SimpleQuantityArray([7 6; 2.0 3], ucat.deca * baseUnit)
    sqArray5 = SimpleQuantityArray([7 6; 2.0 3], baseUnit)

    # format: sqArray1::SimpleQuantityArray, sqArray2::SimpleQuantityArray, correct result for sqArray1 == sqArray2
    examples = [
        ( sqArray1, sqArray1Copy, true ),
        ( sqArray1, sqArray2, true ),
        ( sqArray5, sqArray3, false ),
        ( sqArray5, sqArray4, false )
    ]
    return examples
end

function test_equality_ErrorsForMismatchedDimensions()
    (mismatchedSQArray1, mismatchedSQArray2) = _generateDimensionMismatchedQuantityArrays()
    expectedError = Alicorn.Exceptions.DimensionMismatchError("compared quantities are not of the same physical dimension")
    @test_throws expectedError (mismatchedSQArray1 == mismatchedSQArray2)
end

function isapprox_implemented()
    examples = _getExamplesFor_isapprox()
    return _test_isapprox_examples(examples)
end

function _getExamplesFor_isapprox()
    examples = [
        ( [7, 2] * ucat.meter, [71, 21] * (ucat.deci * ucat.meter), 0.01, false ),
        ( [7, 2] * ucat.meter, [71, 21] * (ucat.deci * ucat.meter), 0.02, true )
    ]
    return examples
end

function _test_isapprox_examples(examples::Array)
    pass = true
    for (sqArray1, sqArray2, rtol, correctResult) in examples
        pass &= ( isapprox(sqArray1, sqArray2, rtol=rtol) == correctResult )
    end
    return pass
end

function test_isapprox_ErrorsForMismatchedDimensions()
    (mismatchedSQArray1, mismatchedSQArray2) = _generateDimensionMismatchedQuantityArrays()
    expectedError = Alicorn.Exceptions.DimensionMismatchError("compared quantities are not of the same physical dimension")
    @test_throws expectedError isapprox(mismatchedSQArray1, mismatchedSQArray2)
end

## 4. Complex numbers

function real_implemented()
    examples = _getExamplesFor_real()
    return TestingTools.testMonadicFunction(Base.real, examples)
end

function _getExamplesFor_real()
    # format: sqArray::SimpleQuantityArray, correct result for real(sqArray)
    examples = [
        ( [1] * Alicorn.unitlessUnit, [1] * Alicorn.unitlessUnit ),
        ( [1im] * Alicorn.unitlessUnit, [0] * Alicorn.unitlessUnit ),
        ( [4.0+2im 3+7im; -5-6im 12-6im] * (ucat.pico * ucat.meter)^-3, [4.0 3; -5 12] * (ucat.pico * ucat.meter)^-3 )
    ]
    return examples
end

function imag_implemented()
    examples = _getExamplesFor_imag()
    return TestingTools.testMonadicFunction(Base.imag, examples)
end

function _getExamplesFor_imag()
    # format: sqArray::SimpleQuantityArray, correct result for imag(sqArray)
    examples = [
        ( [1] * Alicorn.unitlessUnit, [0] * Alicorn.unitlessUnit ),
        ( [1im] * Alicorn.unitlessUnit, [1] * Alicorn.unitlessUnit ),
        ( [4.0+2im 3+7im; -5-6im 12-6im] * (ucat.pico * ucat.meter)^-3, [2 7; -6 -6] * (ucat.pico * ucat.meter)^-3 )
    ]
    return examples
end

function conj_implemented()
    examples = _getExamplesFor_conj()
    return TestingTools.testMonadicFunction(Base.conj, examples)
end

function _getExamplesFor_conj()
    # format: sqArray::SimpleQuantityArray, correct result for conj(sqArray)
    examples = [
        ( [1] * Alicorn.unitlessUnit, [1] * Alicorn.unitlessUnit ),
        ( [1im] * Alicorn.unitlessUnit, [-1im] * Alicorn.unitlessUnit ),
        ( [4.0+2im 3+7im; -5-6im 12-6im] * (ucat.pico * ucat.meter)^-3, [4.0-2im 3-7im; -5+6im 12+6im]  * (ucat.pico * ucat.meter)^-3 )
    ]
    return examples
end

## 5. Array methods

function eltype_implemented()
    examples = _getExamplesFor_eltype()
    return TestingTools.testMonadicFunction(Base.eltype, examples)
end

function _getExamplesFor_eltype()
    # format: sqArray::SimpleQuantityArray, correct result for eltype(sqArray)
    A = SimpleQuantityArray([1,2], ucat.meter)
    examples = [
        (A, typeof(A[1]))
    ]
    return examples
end

function length_implemented()
    examples = _getExamplesFor_length()
    return TestingTools.testMonadicFunction(Base.length, examples)
end

function _getExamplesFor_length()
    # format: sqArray::SimpleQuantityArray, correct result for length(sqArray)
    examples = [
        ([1, 2, 7] * ucat.meter, 3),
        ([1 2 7; 5 6 -0.3] * ucat.meter / ucat.second, 6)
    ]
    return examples
end

function ndims_implemented()
    examples = _getExamplesFor_ndims()
    return TestingTools.testMonadicFunction(Base.ndims, examples)
end

function _getExamplesFor_ndims()
    # format: sqArray::SimpleQuantityArray, correct result for ndims(sqArray)
    examples = [
        ([1, 2, 7] * ucat.meter, 1),
        ([1 2 7; 5 6 -0.3] * ucat.meter / ucat.second, 2),
        (fill(1, (2,3,4))  * ucat.meter , 3)
    ]
    return examples
end

function axes_implemented()
    examples = _getExamplesFor_axes()
    return TestingTools.testMonadicFunction(Base.axes, examples)
end

function _getExamplesFor_axes()
    # format: sqArray::SimpleQuantityArray, correct result for axes(sqArray)
    examples = [
        ([1, 2, 7] * ucat.meter, axes([1, 2, 7])),
        ([1 2 7; 5 6 -0.3] * ucat.meter / ucat.second, axes([1 2 7; 5 6 -0.3])),
        (fill(1, (2,3,4))  * ucat.meter , axes(fill(1, (2,3,4))))
    ]
    return examples
end

function axes_withDims_implemented()
    examples = _getExamplesFor_axes_withDims()
    return TestingTools.testDyadicFunction(Base.axes, examples)
end

function _getExamplesFor_axes_withDims()
    # format: sqArray::SimpleQuantityArray, d::Integer, correct result for axes(sqArray,d)
    examples = [
        ([1, 2, 7] * ucat.meter, 1, axes([1, 2, 7],1) ),
        ([1, 2, 7] * ucat.meter, 3, axes([1, 2, 7],3) ),
        ([1 2 7; 5 6 -0.3] * ucat.meter / ucat.second, 1, axes([1 2 7; 5 6 -0.3],1) ),
        ([1 2 7; 5 6 -0.3] * ucat.meter / ucat.second, 2, axes([1 2 7; 5 6 -0.3],2) ),
        (fill(1, (2,3,4))  * ucat.meter , 1, axes(fill(1, (2,3,4)),1) ),
        (fill(1, (2,3,4))  * ucat.meter , 2, axes(fill(1, (2,3,4)),2) ),
        (fill(1, (2,3,4))  * ucat.meter , 3, axes(fill(1, (2,3,4)),3) ),
    ]
    return examples
end

function findmax_implemented()
    examples = _getExamplesFor_findmax()
    return TestingTools.testMonadicFunction(Base.findmax, examples)
end

function _getExamplesFor_findmax()
    # format: sqArray::SimpleQuantityArray, correct result for findmax(sqArray)
    examples = [
        ( [3 2.1 2.0 4.5] * ucat.unitless, ( 4.5 * ucat.unitless, CartesianIndex(1, 4) ) ),
        ( [3 2.1 2.0 4.5] * ucat.ampere, ( 4.5 * ucat.ampere, CartesianIndex(1, 4) ) ),
        ( [3 2.1 2.0 4.5; 1 -1 7 -2] * ucat.ampere, ( 7 * ucat.ampere, CartesianIndex(2, 3) ) )
    ]
    return examples
end

function findmax_withDims_implemented()
    examples = _getExamplesFor_findmax_withDims()
    return _test_findmax_findmin_withDims(findmax, examples)
end

function _getExamplesFor_findmax_withDims()
    # format: sqArray::SimpleQuantityArray, dims::Integer, correct result for findmax(sqArray, dims=dims)

    dimlessA = [3 2.1 2.0 4.5]
    dimlessB = [3 2.1 2.0 4.5; 1 -1 7 -2]

    maxA1 = findmax(dimlessA, dims=1)
    maxA2 = findmax(dimlessA, dims=2)
    maxB1 = findmax(dimlessB, dims=1)
    maxB2 = findmax(dimlessB, dims=2)

    examples = [
        ( dimlessA * ucat.unitless, 1, ( maxA1[1] * ucat.unitless, CartesianIndex{2}[CartesianIndex(1, 1) CartesianIndex(1, 2) CartesianIndex(1, 3) CartesianIndex(1, 4)] ) ),
        ( dimlessA * ucat.unitless, 2, ( maxA2[1] * ucat.unitless,  maxA2[2] ) ),
        ( dimlessB * ucat.ampere, 1, ( maxB1[1] * ucat.ampere, CartesianIndex{2}[CartesianIndex(1, 1) CartesianIndex(1, 2) CartesianIndex(2, 3) CartesianIndex(1, 4)] ) ),
        ( dimlessB * ucat.ampere, 2, ( maxB2[1] * ucat.ampere, maxB2[2] ) )
    ]
    return examples
end

function _test_findmax_findmin_withDims(func, examples)
    correct = true
    for (sqArray, dims, correctResult) in examples
        returnedResult = func(sqArray, dims=dims)
        correct &= (returnedResult == correctResult)
    end
    return correct
end

function findmin_implemented()
    examples = _getExamplesFor_findmin()
    return TestingTools.testMonadicFunction(Base.findmin, examples)
end

function _getExamplesFor_findmin()
    # format: sqArray::SimpleQuantityArray, correct result for findmin(sqArray)
    examples = [
        ( [3 2.1 2.0 4.5] * ucat.unitless, ( 2.0 * ucat.unitless, CartesianIndex(1, 3) ) ),
        ( [3 2.1 2.0 4.5] * ucat.ampere, ( 2.0 * ucat.ampere, CartesianIndex(1, 3) ) ),
        ( [3 2.1 2.0 4.5; 1 -1 7 -2] * ucat.ampere, ( -2 * ucat.ampere, CartesianIndex(2, 4) ) )
    ]
    return examples
end

function findmin_withDims_implemented()
    examples = _getExamplesFor_findmin_withDims()
    return _test_findmax_findmin_withDims(findmin, examples)
end

function _getExamplesFor_findmin_withDims()
    # format: sqArray::SimpleQuantityArray, dims::Integer, correct result for findmax(sqArray, dims=dims)

    dimlessA = [3 2.1 2.0 4.5]
    dimlessB = [3 2.1 2.0 4.5; 1 -1 7 -2]

    minA1 = findmin(dimlessA, dims=1)
    minA2 = findmin(dimlessA, dims=2)
    minB1 = findmin(dimlessB, dims=1)
    minB2 = findmin(dimlessB, dims=2)

    examples = [
        ( dimlessA * ucat.unitless, 1, ( minA1[1] * ucat.unitless, CartesianIndex{2}[CartesianIndex(1, 1) CartesianIndex(1, 2) CartesianIndex(1, 3) CartesianIndex(1, 4)] ) ),
        ( dimlessA * ucat.unitless, 2, ( minA2[1] * ucat.unitless,  minA2[2] ) ),
        ( dimlessB * ucat.ampere, 1, ( minB1[1] * ucat.ampere, CartesianIndex{2}[CartesianIndex(2, 1) CartesianIndex(2, 2) CartesianIndex(1, 3) CartesianIndex(2, 4)] ) ),
        ( dimlessB * ucat.ampere, 2, ( minB2[1] * ucat.ampere, minB2[2] ) )
    ]
    return examples
end

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

end # module
