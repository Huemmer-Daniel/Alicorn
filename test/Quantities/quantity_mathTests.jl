module quantity_mathTests

using Alicorn
using Test
using ..TestingTools

const ucat = UnitCatalogue()
const dimless = Dimension()
const lengthDim = Dimension(L=1)
const timeDim = Dimension(T=1)
const intu = InternalUnits()
const intu2 = InternalUnits(length=2*ucat.meter)

function run()
    @testset "quantity_mathTests" begin

        ## Arithemtic unary and binary operators
        # unary plus
        @test unaryPlus_implemented_forSimpleQuantity()
        @test unaryPlus_implemented_forSimpleQuantityArray()
        @test unaryPlus_implemented_forQuantity()
        @test unaryPlus_implemented_forQuantityArray()
        # unary minus
        @test unaryMinus_implemented_forSimpleQuantity()
        @test unaryMinus_implemented_forSimpleQuantityArray()
        @test unaryMinus_implemented_forQuantity()
        @test unaryMinus_implemented_forQuantityArray()

        ## Arithmetic binary operators
        # addition
        # SimpleQuantity and SimpleQuantityArray
        @test SimpleQuantity_SimpleQuantity_addition_implemented()
        test_addition_ErrorsForMismatchedDimensions_forSimpleQuantity()
        @test SimpleQuantityArray_SimpleQuantityArray_addition_implemented()
        test_addition_ErrorsForMismatchedDimensions_forSimpleQuantityArray()
        # Quantity and QuantityArray
        @test Quantity_Quantity_addition_implemented()
        test_addition_ErrorsForMismatchedDimensions_forQuantity()
        @test QuantityArray_QuantityArray_addition_implemented()
        test_addition_ErrorsForMismatchedDimensions_forQuantityArray()
        # mixed
        @test SimpleQuantity_Quantity_addition_implemented()
        @test SimpleQuantityArray_QuantityArray_addition_implemented()

        # subtraction
        # SimpleQuantity and SimpleQuantityArray
        @test SimpleQuantity_SimpleQuantity_subtraction_implemented()
        test_subtraction_ErrorsForMismatchedDimensions_forSimpleQuantity()
        @test SimpleQuantityArray_SimpleQuantityArray_subtraction_implemented()
        test_subtraction_ErrorsForMismatchedDimensions_forSimpleQuantityArray()
        # Quantity and QuantityArray
        @test Quantity_Quantity_subtraction_implemented()
        test_subtraction_ErrorsForMismatchedDimensions_forQuantity()
        @test QuantityArray_QuantityArray_subtraction_implemented()
        test_subtraction_ErrorsForMismatchedDimensions_forQuantityArray()
        # mixed
        @test SimpleQuantity_Quantity_subtraction_implemented()
        @test SimpleQuantityArray_QuantityArray_subtraction_implemented()

        # multiplication
        # SimpleQuantity
        @test SimpleQuantity_SimpleQuantity_multiplication_implemented()
        @test SimpleQuantity_Number_multiplication_implemented()
        @test Number_SimpleQuantity_multiplication_implemented()
        @test SimpleQuantity_Array_multiplication_implemented()
        @test Array_SimpleQuantity_multiplication_implemented()
        # SimpleQuantityArray
        @test SimpleQuantityArray_SimpleQuantityArray_multiplication_implemented()
        @test SimpleQuantityArray_Array_multiplication_implemented()
        @test Array_SimpleQuantityArray_multiplication_implemented()
        @test SimpleQuantityArray_SimpleQuantity_multiplication_implemented()
        @test SimpleQuantity_SimpleQuantityArray_multiplication_implemented()
        @test SimpleQuantityArray_Number_multiplication_implemented()
        @test Number_SimpleQuantityArray_multiplication_implemented()
        # Quantity
        @test Quantity_Quantity_multiplication_implemented()
        @test Quantity_Number_multiplication_implemented()
        @test Number_Quantity_multiplication_implemented()
        @test Quantity_Array_multiplication_implemented()
        @test Array_Quantity_multiplication_implemented()
        # QuantityArray
        @test QuantityArray_QuantityArray_multiplication_implemented()
        @test QuantityArray_Array_multiplication_implemented()
        @test Array_QuantityArray_multiplication_implemented()
        @test QuantityArray_Quantity_multiplication_implemented()
        @test Quantity_QuantityArray_multiplication_implemented()
        @test QuantityArray_Number_multiplication_implemented()
        @test Number_QuantityArray_multiplication_implemented()
        # mixed: SimpleQuantity and Quantity
        @test SimpleQuantity_Quantity_multiplication_implemented()
        @test Quantity_SimpleQuantity_multiplication_implemented()
        @test SimpleQuantityArray_QuantityArray_multiplication_implemented()
        @test QuantityArray_SimpleQuantityArray_multiplication_implemented()
        @test SimpleQuantityArray_Quantity_multiplication_implemented()
        @test Quantity_SimpleQuantityArray_multiplication_implemented()
        @test QuantityArray_SimpleQuantity_multiplication_implemented()
        @test SimpleQuantity_QuantityArray_multiplication_implemented()


        # TODO old below
        # @test division_implemented()
        # @test SimpleQuantity_Array_division_implemented()
        # @test Array_SimpleQuantity_division_implemented()
        # @test SimpleQuantity_Number_division_implemented()
        # @test Number_SimpleQuantity_division_implemented()
        # @test inverseDivision_implemented()
        # @test SimpleQuantity_Array_inverseDivision_implemented()
        # @test SimpleQuantity_Number_inverseDivision_implemented()
        # @test Number_SimpleQuantity_inverseDivision_implemented()
        # @test exponentiation_implemented()
        # @test inv_implemented()
        #
        # # 3. Numeric comparison
        # @test equality_implemented()
        # test_equality_ErrorsForMismatchedDimensions()
        # @test isless_implemented()
        # test_isless_ErrorsForMismatchedDimensions()
        # @test isfinite_implemented()
        # @test isinf_implemented()
        # @test isnan_implemented()
        # @test isapprox_implemented()
        # test_isapprox_ErrorsForMismatchedDimensions()
        #
        # # 4. Rounding
        # @test mod2pi_implemented()
        #
        # # 5. Sign and absolute value
        # @test abs_implemented()
        # @test abs2_implemented()
        # @test sign_implemented()
        # @test signbit_implemented()
        # @test copysign_implemented()
        # @test flipsign_implemented()
        #
        # # 6. Roots
        # @test sqrt_implemented()
        # @test cbrt_implemented()
        #
        # # 8. Complex numbers
        # @test real_implemented()
        # @test imag_implemented()
        # @test conj_implemented()
        # @test angle_implemented()
        #
        # # 9. Compatibility with array functions
        # @test length_implemented()
        # @test size_implemented()
        # @test ndims_implemented()
        # @test getindex_implemented()
        # test_getindex_errorsForIndexGreaterOne()
    end
end

#### Arithemtic unary and binary operators

## unary plus
function unaryPlus_implemented_forSimpleQuantity()
    randomSimpleQuantity = TestingTools.generateRandomSimpleQuantity()
    correct = (randomSimpleQuantity == +randomSimpleQuantity)
    return correct
end

function unaryPlus_implemented_forSimpleQuantityArray()
    randomSimpleQuantityArray = TestingTools.generateRandomSimpleQuantityArray()
    correct = (randomSimpleQuantityArray == +randomSimpleQuantityArray)
    return correct
end

function unaryPlus_implemented_forQuantity()
    randomQuantity = TestingTools.generateRandomQuantity()
    correct = (randomQuantity == +randomQuantity)
    return correct
end

function unaryPlus_implemented_forQuantityArray()
    randomQuantityArray = TestingTools.generateRandomQuantityArray()
    correct = (randomQuantityArray == +randomQuantityArray)
    return correct
end

## unary minus
function unaryMinus_implemented_forSimpleQuantity()
    examples = _getExamplesFor_unaryMinus_forSimpleQuantity()
    return TestingTools.testMonadicFunction(Base.:-, examples)
end

function _getExamplesFor_unaryMinus_forSimpleQuantity()
    # format: q::SimpleQuantity, correct result for -q
    examples = [
        ( 7.5 * ucat.meter, -7.5 * ucat.meter),
        ( (-3.4 + 8.7im) * ucat.ampere, (3.4 - 8.7im) * ucat.ampere)
    ]
    return examples
end

function unaryMinus_implemented_forSimpleQuantityArray()
    examples = _getExamplesFor_unaryMinus_forSimpleQuantityArray()
    return TestingTools.testMonadicFunction(Base.:-, examples)
end

function _getExamplesFor_unaryMinus_forSimpleQuantityArray()
    # format: q::SimpleQuantityArray, correct result for -q
    examples = [
        ( [7.5] * ucat.meter, [-7.5] * ucat.meter),
        ( [(-3.4 + 8.7im)] * ucat.ampere, [(3.4 - 8.7im)] * ucat.ampere)
    ]
    return examples
end

function unaryMinus_implemented_forQuantity()
    examples = _getExamplesFor_unaryMinus_forQuantity()
    return TestingTools.testMonadicFunction(Base.:-, examples)
end

function _getExamplesFor_unaryMinus_forQuantity()
    # format: q::Quantity, correct result for -q
    examples = [
        ( Quantity{Int32}(5, lengthDim, intu2), Quantity{Int32}(-5, lengthDim, intu2) ),
        ( Quantity{ComplexF32}(-3.4 + 8.7im, lengthDim, intu2), Quantity{ComplexF32}(3.4 - 8.7im, lengthDim, intu2) )
    ]
    return examples
end

function unaryMinus_implemented_forQuantityArray()
    examples = _getExamplesFor_unaryMinus_forQuantityArray()
    return TestingTools.testMonadicFunction(Base.:-, examples)
end

function _getExamplesFor_unaryMinus_forQuantityArray()
    # format: q::QuantityArray, correct result for -q
    examples = [
        ( QuantityArray{Int32}([5, -2], lengthDim, intu2), QuantityArray{Int32}([-5, 2], lengthDim, intu2) ),
        ( QuantityArray{ComplexF32}([-3.4 + 8.7im], lengthDim, intu2),
            QuantityArray{ComplexF32}([3.4 - 8.7im], lengthDim, intu2) )
    ]
    return examples
end


#### Arithmetic binary operators
## addition
# addition: SimpleQuantity and SimpleQuantityArray
function SimpleQuantity_SimpleQuantity_addition_implemented()
    examples = _getExamplesFor_addition_forSimpleQuantity()
    return TestingTools.testDyadicFunction(Base.:+, examples)
end

function _getExamplesFor_addition_forSimpleQuantity()
    # format: addend1, addend2, correct sum
    examples = [
        ( 2 * Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit, 3 * Alicorn.unitlessUnit ),
        ( 7 * ucat.meter, 2 * (ucat.milli * ucat.meter), 7.002 * ucat.meter ),
        ( 2 * (ucat.milli * ucat.meter), 7 * ucat.meter , 7.002e3 * (ucat.milli * ucat.meter) )
    ]
    return examples
end

function test_addition_ErrorsForMismatchedDimensions_forSimpleQuantity()
    (mismatchedAddend1, mismatchedAddend2) = _generateDimensionMismatchedQuantities_forSimpleQuantity()
    expectedError = Alicorn.Exceptions.DimensionMismatchError("summands are not of the same physical dimension")
    @test_throws expectedError (mismatchedAddend1 + mismatchedAddend2)
end

function _generateDimensionMismatchedQuantities_forSimpleQuantity()
    unit = TestingTools.generateRandomUnit()
    mismatchedUnit = unit * Alicorn.meter

    value = TestingTools.generateRandomReal()
    mismatchedAddend1 = value * unit
    mismatchedAddend2 = (2*value) * mismatchedUnit

    return (mismatchedAddend1, mismatchedAddend2)
end

function SimpleQuantityArray_SimpleQuantityArray_addition_implemented()
    examples = _getExamplesFor_addition_forSimpleQuantityArray()
    return TestingTools.testDyadicFunction(Base.:+, examples)
end

function _getExamplesFor_addition_forSimpleQuantityArray()
    # format: addend1, addend2, correct sum
    examples = [
        ( [2] * Alicorn.unitlessUnit, [1] * Alicorn.unitlessUnit, [3] * Alicorn.unitlessUnit ),
        ( [7; 3] * ucat.meter, [2; 1] * (ucat.milli * ucat.meter), [7.002; 3.001] * ucat.meter ),
        ( [2] * (ucat.milli * ucat.meter), [7] * ucat.meter , [7.002e3] * (ucat.milli * ucat.meter) )
    ]
    return examples
end

function test_addition_ErrorsForMismatchedDimensions_forSimpleQuantityArray()
    (mismatchedAddend1, mismatchedAddend2) = _generateDimensionMismatchedQuantityArrays_forSimpleQuantityArray()
    expectedError = Alicorn.Exceptions.DimensionMismatchError("summands are not of the same physical dimension")
    @test_throws expectedError (mismatchedAddend1 + mismatchedAddend2)
end

function _generateDimensionMismatchedQuantityArrays_forSimpleQuantityArray()
    unit = TestingTools.generateRandomUnit()
    mismatchedUnit = unit * Alicorn.meter

    value = TestingTools.generateRandomReal(dim=(3,2))
    mismatchedAddend1 = value * unit
    mismatchedAddend2 = (2*value) * mismatchedUnit

    return (mismatchedAddend1, mismatchedAddend2)
end

# addition: Quantity and QuantityArray
function Quantity_Quantity_addition_implemented()
    examples = _getExamplesFor_addition_forQuantity()
    return TestingTools.testDyadicFunction(Base.:+, examples)
end

function _getExamplesFor_addition_forQuantity()
    # format: addend1, addend2, correct sum
    examples = [
        ( Quantity(2, dimless, intu), Quantity(1, dimless, intu), Quantity(3, dimless, intu) ),
        ( Quantity{Int32}(7, lengthDim, intu2), Quantity{Int32}(2, lengthDim, intu), Quantity{Int32}(8, lengthDim, intu2 ) ),
        ( Quantity{Int32}(7, lengthDim, intu), Quantity{Int64}(-2, lengthDim, intu2), Quantity{Int64}(3, lengthDim, intu ) )
    ]
    return examples
end

function test_addition_ErrorsForMismatchedDimensions_forQuantity()
    (mismatchedAddend1, mismatchedAddend2) = _generateDimensionMismatchedQuantities_forQuantity()
    expectedError = Alicorn.Exceptions.DimensionMismatchError("summands are not of the same physical dimension")
    @test_throws expectedError (mismatchedAddend1 + mismatchedAddend2)
end

function _generateDimensionMismatchedQuantities_forQuantity()
    mismatchedAddend1 = Quantity{Int32}(7, lengthDim, intu)
    mismatchedAddend2 = Quantity{Int32}(7, Dimension(T=1), intu)
    return (mismatchedAddend1, mismatchedAddend2)
end

function QuantityArray_QuantityArray_addition_implemented()
    examples = _getExamplesFor_addition_forQuantityArray()
    return TestingTools.testDyadicFunction(Base.:+, examples)
end

function _getExamplesFor_addition_forQuantityArray()
    # format: addend1, addend2, correct sum
    examples = [
        ( QuantityArray([2], dimless, intu), QuantityArray([1], dimless, intu), QuantityArray([3], dimless, intu) ),
        ( QuantityArray{Int32}([7, 2], lengthDim, intu2), QuantityArray{Int32}([2, 4], lengthDim, intu), QuantityArray{Int32}([8, 4], lengthDim, intu2 ) ),
        ( QuantityArray{Int32}([7, 2], lengthDim, intu), QuantityArray{Int64}([-2, -4], lengthDim, intu2), QuantityArray{Int64}([3, -6], lengthDim, intu ) ),
    ]
    return examples
end

function test_addition_ErrorsForMismatchedDimensions_forQuantityArray()
    (mismatchedAddend1, mismatchedAddend2) = _generateDimensionMismatchedQuantities_forQuantityArray()
    expectedError = Alicorn.Exceptions.DimensionMismatchError("summands are not of the same physical dimension")
    @test_throws expectedError (mismatchedAddend1 + mismatchedAddend2)
end

function _generateDimensionMismatchedQuantities_forQuantityArray()
    mismatchedAddend1 = QuantityArray{Int32}([7], lengthDim, intu)
    mismatchedAddend2 = QuantityArray{Int32}([7], Dimension(T=1), intu)
    return (mismatchedAddend1, mismatchedAddend2)
end

# addition: mixed
function SimpleQuantity_Quantity_addition_implemented()
    examples = _getExamplesFor_SimpleQuantity_Quantity_addition()
    return TestingTools.testDyadicFunction(Base.:+, examples)
end

function _getExamplesFor_SimpleQuantity_Quantity_addition()
    # format: addend1, addend2, correct sum
    examples = [
        ( SimpleQuantity(1, Alicorn.unitlessUnit), Quantity(2, dimless, intu), Quantity(3, dimless, intu) ),
        ( Quantity(2, dimless, intu), SimpleQuantity(1, Alicorn.unitlessUnit), Quantity(3, dimless, intu) ),
        ( SimpleQuantity{Float32}(7, ucat.meter), Quantity{Float32}(2, lengthDim, intu2), Quantity{Float32}(5.5, lengthDim, intu2) ),
        ( Quantity{Float32}(2, lengthDim, intu2), SimpleQuantity{Float32}(7, ucat.meter), Quantity{Float32}(5.5, lengthDim, intu2) ),
    ]
    return examples
end

function SimpleQuantityArray_QuantityArray_addition_implemented()
    examples = _getExamplesFor_SimpleQuantityArray_QuantityArray_addition()
    return TestingTools.testDyadicFunction(Base.:+, examples)
end

function _getExamplesFor_SimpleQuantityArray_QuantityArray_addition()
    # format: addend1, addend2, correct sum
    examples = [
        ( SimpleQuantityArray([1], Alicorn.unitlessUnit), QuantityArray([2], dimless, intu), QuantityArray([3], dimless, intu) ),
        ( QuantityArray([2], dimless, intu), SimpleQuantityArray([1], Alicorn.unitlessUnit), QuantityArray([3], dimless, intu) ),
        ( SimpleQuantityArray{Float32}([7, 9], ucat.meter), QuantityArray{Float32}([2, 4], lengthDim, intu2), QuantityArray{Float32}([5.5, 8.5], lengthDim, intu2) ),
        ( QuantityArray{Float32}([2, 4], lengthDim, intu2),  SimpleQuantityArray{Float32}([7, 9], ucat.meter), QuantityArray{Float32}([5.5, 8.5], lengthDim, intu2) ),
    ]
    return examples
end


## subtraction
# subtraction: SimpleQuantity and SimpleQuantityArray
function SimpleQuantity_SimpleQuantity_subtraction_implemented()
    examples = _getExamplesFor_subtraction_forSimpleQuantity()
    return TestingTools.testDyadicFunction(Base.:-, examples)
end

function _getExamplesFor_subtraction_forSimpleQuantity()
    # format: addend1, addend2, correct difference
    examples = [
        ( 2 * Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit ),
        ( 7 * ucat.meter, 2 * (ucat.milli * ucat.meter), 6.998 * ucat.meter ),
        ( 2 * (ucat.milli * ucat.meter), 7 * ucat.meter , -6.998e3 * (ucat.milli * ucat.meter) )
    ]
    return examples
end

function test_subtraction_ErrorsForMismatchedDimensions_forSimpleQuantity()
    (mismatchedAddend1, mismatchedAddend2) = _generateDimensionMismatchedQuantities_forSimpleQuantity()
    expectedError = Alicorn.Exceptions.DimensionMismatchError("summands are not of the same physical dimension")
    @test_throws expectedError (mismatchedAddend1 - mismatchedAddend2)
end

function SimpleQuantityArray_SimpleQuantityArray_subtraction_implemented()
    examples = _getExamplesFor_subtraction_forSimpleQuantityArray()
    return TestingTools.testDyadicFunction(Base.:-, examples)
end

function _getExamplesFor_subtraction_forSimpleQuantityArray()
    # format: addend1, addend2, correct difference
    examples = [
        ( [2] * Alicorn.unitlessUnit, [1] * Alicorn.unitlessUnit, [1]* Alicorn.unitlessUnit ),
        ( [7 3] * ucat.meter, [2 1] * (ucat.milli * ucat.meter), [6.998 2.999] * ucat.meter ),
        ( [2] * (ucat.milli * ucat.meter), [7] * ucat.meter , [-6.998e3] * (ucat.milli * ucat.meter) )
    ]
    return examples
end

function test_subtraction_ErrorsForMismatchedDimensions_forSimpleQuantityArray()
    (mismatchedAddend1, mismatchedAddend2) = _generateDimensionMismatchedQuantityArrays_forSimpleQuantityArray()
    expectedError = Alicorn.Exceptions.DimensionMismatchError("summands are not of the same physical dimension")
    @test_throws expectedError (mismatchedAddend1 - mismatchedAddend2)
end

# subtraction: Quantity and QuantityArray
function Quantity_Quantity_subtraction_implemented()
    examples = _getExamplesFor_subtraction_forQuantity()
    return TestingTools.testDyadicFunction(Base.:-, examples)
end

function _getExamplesFor_subtraction_forQuantity()
    # format: addend1, addend2, correct difference
    examples = [
        ( Quantity(2, dimless, intu), Quantity(3, dimless, intu), Quantity(-1, dimless, intu) ),
        ( Quantity{Int32}(7, lengthDim, intu2), Quantity{Int32}(2, lengthDim, intu), Quantity{Int32}(6, lengthDim, intu2 ) ),
        ( Quantity{Int32}(7, lengthDim, intu), Quantity{Int64}(-2, lengthDim, intu2), Quantity{Int64}(11, lengthDim, intu ) )
    ]
    return examples
end

function test_subtraction_ErrorsForMismatchedDimensions_forQuantity()
    (mismatchedAddend1, mismatchedAddend2) = _generateDimensionMismatchedQuantities_forQuantity()
    expectedError = Alicorn.Exceptions.DimensionMismatchError("summands are not of the same physical dimension")
    @test_throws expectedError (mismatchedAddend1 - mismatchedAddend2)
end

function QuantityArray_QuantityArray_subtraction_implemented()
    examples = _getExamplesFor_subtraction_forQuantityArray()
    return TestingTools.testDyadicFunction(Base.:-, examples)
end

function _getExamplesFor_subtraction_forQuantityArray()
    # format: addend1, addend2, correct difference
    examples = [
        ( QuantityArray([2], dimless, intu), QuantityArray([3], dimless, intu), QuantityArray([-1], dimless, intu) ),
        ( QuantityArray{Int32}([7, 2], lengthDim, intu2), QuantityArray{Int32}([2, 4], lengthDim, intu), QuantityArray{Int32}([6, 0], lengthDim, intu2 ) ),
        ( QuantityArray{Int32}([7, 2], lengthDim, intu), QuantityArray{Int64}([-2, -4], lengthDim, intu2), QuantityArray{Int64}([11, 10], lengthDim, intu ) ),
    ]
    return examples
end

function test_subtraction_ErrorsForMismatchedDimensions_forQuantityArray()
    (mismatchedAddend1, mismatchedAddend2) = _generateDimensionMismatchedQuantities_forQuantityArray()
    expectedError = Alicorn.Exceptions.DimensionMismatchError("summands are not of the same physical dimension")
    @test_throws expectedError (mismatchedAddend1 - mismatchedAddend2)
end

# subtraction: mixed
function SimpleQuantity_Quantity_subtraction_implemented()
    examples = _getExamplesFor_SimpleQuantity_Quantity_subtraction()
    return TestingTools.testDyadicFunction(Base.:-, examples)
end

function _getExamplesFor_SimpleQuantity_Quantity_subtraction()
    # format: addend1, addend2, correct sum
    examples = [
        ( SimpleQuantity(1, Alicorn.unitlessUnit), Quantity(2, dimless, intu), Quantity(-1, dimless, intu) ),
        ( Quantity(2, dimless, intu), SimpleQuantity(1, Alicorn.unitlessUnit), Quantity(1, dimless, intu) ),
        ( SimpleQuantity{Float32}(7, ucat.meter), Quantity{Float32}(2, lengthDim, intu2), Quantity{Float32}(1.5, lengthDim, intu2) ),
        ( Quantity{Float32}(2, lengthDim, intu2), SimpleQuantity{Float32}(7, ucat.meter), Quantity{Float32}(-1.5, lengthDim, intu2) ),
    ]
    return examples
end

function SimpleQuantityArray_QuantityArray_subtraction_implemented()
    examples = _getExamplesFor_SimpleQuantityArray_QuantityArray_subtraction()
    return TestingTools.testDyadicFunction(Base.:-, examples)
end

function _getExamplesFor_SimpleQuantityArray_QuantityArray_subtraction()
    # format: addend1, addend2, correct sum
    examples = [
        ( SimpleQuantityArray([1], Alicorn.unitlessUnit), QuantityArray([2], dimless, intu), QuantityArray([-1], dimless, intu) ),
        ( QuantityArray([2], dimless, intu), SimpleQuantityArray([1], Alicorn.unitlessUnit), QuantityArray([1], dimless, intu) ),
        ( SimpleQuantityArray{Float32}([7, 9], ucat.meter), QuantityArray{Float32}([2, 4], lengthDim, intu2), QuantityArray{Float32}([1.5, 0.5], lengthDim, intu2) ),
        ( QuantityArray{Float32}([2, 4], lengthDim, intu2),  SimpleQuantityArray{Float32}([7, 9], ucat.meter), QuantityArray{Float32}([-1.5, -0.5], lengthDim, intu2) ),
    ]
    return examples
end


## multiplication
# multiplication: SimpleQuantity
function SimpleQuantity_SimpleQuantity_multiplication_implemented()
    examples = _getExamplesFor_SimpleQuantity_SimpleQuantity_multiplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_SimpleQuantity_SimpleQuantity_multiplication()
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

function SimpleQuantity_Number_multiplication_implemented()
    examples = _getExamplesFor_SimpleQuantity_Number_multiplication_()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_SimpleQuantity_Number_multiplication_()
    # format: factor1, factor2, correct product factor1 * factor2
    examples = [
        ( 1 * Alicorn.unitlessUnit, 1, 1 * Alicorn.unitlessUnit ),
        ( 2 * ucat.second, 2.5, 5 * ucat.second ),
        ( -7 * ucat.lumen * (ucat.nano * ucat.second),  2.5 , -17.5 * ucat.lumen * (ucat.nano * ucat.second) ),
        ( 2 * (ucat.milli * ucat.candela)^-4, 4, 8 * (ucat.milli * ucat.candela)^-4 )
    ]
    return examples
end

function Number_SimpleQuantity_multiplication_implemented()
    examples = _getExamplesFor_Number_SimpleQuantity_multiplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_Number_SimpleQuantity_multiplication()
    # format: factor1, factor2, correct product factor1 * factor2
    examples = [
        ( 1, 1 * Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit ),
        ( 2.5, 2 * ucat.second, 5 * ucat.second ),
        ( 2.5, -7 * ucat.lumen * (ucat.nano * ucat.second),   -17.5 * ucat.lumen * (ucat.nano * ucat.second) ),
        ( 4, 2 * (ucat.milli * ucat.candela)^-4, 8 * (ucat.milli * ucat.candela)^-4 )
    ]
    return examples
end

function SimpleQuantity_Array_multiplication_implemented()
    examples = _getExamplesFor_SimpleQuantity_Array_multiplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_SimpleQuantity_Array_multiplication()
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

function Array_SimpleQuantity_multiplication_implemented()
    examples = _getExamplesFor_Array_SimpleQuantity_multiplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_Array_SimpleQuantity_multiplication()
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

# multiplication: SimpleQuantityArray
function SimpleQuantityArray_SimpleQuantityArray_multiplication_implemented()
    examples = _getExamplesFor_SimpleQuantityArray_SimpleQuantityArray_multiplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_SimpleQuantityArray_SimpleQuantityArray_multiplication()
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

# multiplication: Quantity
function Quantity_Quantity_multiplication_implemented()
    examples = _getExamplesFor_Quantity_Quantity_multiplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_Quantity_Quantity_multiplication()
    # format: factor1, factor2, correct product factor1 * factor2
    examples = [
        ( Quantity(1, dimless, intu), Quantity(1, dimless, intu), Quantity(1, dimless, intu) ),
        ( Quantity{Int32}(3, dimless, intu), Quantity{Int32}(2, lengthDim, intu), Quantity{Int32}(6, lengthDim, intu) ),
        ( Quantity{Float64}(2.5, lengthDim, intu2),  Quantity{Int32}(2, Dimension(T=1), intu), Quantity{Float64}(5, Dimension(L=1, T=1), intu2) ),
        ( Quantity{Int32}(2, Dimension(T=1), intu), Quantity{Float64}(-2.5, lengthDim, intu2), Quantity{Float64}(-10, Dimension(L=1, T=1), intu ) )
    ]
    return examples
end

function Quantity_Number_multiplication_implemented()
    examples = _getExamplesFor_Quantity_Number_multiplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_Quantity_Number_multiplication()
    # format: factor1, factor2, correct product factor1 * factor2
    examples = [
        ( Quantity(1, dimless, intu), 1, Quantity(1, dimless, intu) ),
        ( Quantity{Int32}(3, lengthDim, intu), 2, Quantity{Int64}(6, lengthDim, intu) ),
        ( Quantity{Float32}(2.5, timeDim, intu2),  Float32(2), Quantity{Float32}(5, timeDim, intu2) ),
        ( Quantity{Int32}(2, lengthDim, intu), -2.5, Quantity{Float64}(-5, lengthDim, intu ) )
    ]
    return examples
end

function Number_Quantity_multiplication_implemented()
    examples = _getExamplesFor_Number_Quantity_multiplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_Number_Quantity_multiplication()
    # format: factor1, factor2, correct product factor1 * factor2
    examples = [
        ( 1, Quantity(1, dimless, intu), Quantity(1, dimless, intu) ),
        ( 2, Quantity{Int32}(3, lengthDim, intu), Quantity{Int64}(6, lengthDim, intu) ),
        ( Float32(2), Quantity{Float32}(2.5, timeDim, intu2), Quantity{Float32}(5, timeDim, intu2) ),
        ( -2.5, Quantity{Int32}(2, lengthDim, intu), Quantity{Float64}(-5, lengthDim, intu ) )
    ]
    return examples
end

function Quantity_Array_multiplication_implemented()
    examples = _getExamplesFor_Quantity_Array_multiplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_Quantity_Array_multiplication()
    # format: factor1, factor2, correct product factor1 * factor2
    examples = [
        ( Quantity(1, dimless, intu), ones(2,2), QuantityArray(ones(2,2), dimless, intu ) ),
        ( Quantity(3, timeDim, intu), [2, 2], QuantityArray([6, 6], timeDim, intu ) ),
        ( Quantity(2, lengthDim, intu2), [3 3], QuantityArray([6 6], lengthDim, intu2) ),
        ( Quantity{Float32}(-3.5, lengthDim, intu), Array{Float32}([2, 2]), QuantityArray{Float32}([-7, -7], lengthDim, intu) )
    ]
    return examples
end

function Array_Quantity_multiplication_implemented()
    examples = _getExamplesFor_Array_Quantity_multiplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_Array_Quantity_multiplication()
    # format: factor1, factor2, correct product factor1 * factor2
    examples = [
        ( ones(2,2), Quantity(1, dimless, intu), QuantityArray(ones(2,2), dimless, intu ) ),
        ( [2, 2], Quantity(3, timeDim, intu), QuantityArray([6, 6], timeDim, intu ) ),
        ( [3 3], Quantity(2, lengthDim, intu2), QuantityArray([6 6], lengthDim, intu2) ),
        ( Array{Float32}([2, 2]), Quantity{Float32}(-3.5, lengthDim, intu), QuantityArray{Float32}([-7, -7], lengthDim, intu) )
    ]
    return examples
end

# multiplication: QuantityArray
function QuantityArray_QuantityArray_multiplication_implemented()
    examples = _getExamplesFor_QuantityArray_QuantityArray_multiplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_QuantityArray_QuantityArray_multiplication()
    # format: factor1, factor2, correct product factor1 * factor2
    examples = [
        ( QuantityArray(ones(2,2), dimless, intu), QuantityArray(ones(2,2), dimless, intu), QuantityArray(2*ones(2,2), dimless, intu) ),
        ( QuantityArray([1 1], lengthDim, intu), QuantityArray([2, 2], lengthDim, intu), QuantityArray([4], Dimension(L=2), intu) ),
        ( QuantityArray([2, 2], lengthDim, intu2), QuantityArray([1 1], lengthDim, intu2), QuantityArray( 2 * ones(2,2), Dimension(L=2), intu2 ) ),
        ( QuantityArray{Int32}([2, 2], lengthDim, intu2), QuantityArray{Int32}([2 2], lengthDim, intu), QuantityArray{Int32}( 2 * ones(2,2), Dimension(L=2), intu2 ) ),
        ( QuantityArray{Int32}([2, 2], lengthDim, intu), QuantityArray{Int32}([2 2], lengthDim, intu2), QuantityArray{Int32}( 8 * ones(2,2), Dimension(L=2), intu ) ),
    ]
    return examples
end

function QuantityArray_Array_multiplication_implemented()
    examples = _getExamplesFor_QuantityArray_Array_multiplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_QuantityArray_Array_multiplication()
    # format: factor1, factor2, correct product factor1 * factor2
    examples = [
        ( QuantityArray(ones(2,2), dimless, intu), ones(2,2), QuantityArray(2*ones(2,2), dimless, intu) ),
        ( QuantityArray([1 1], lengthDim, intu), [2, 2], QuantityArray([4], lengthDim, intu) ),
        ( QuantityArray([2, 2], lengthDim, intu2), [1 1], QuantityArray( 2 * ones(2,2), lengthDim, intu2 ) ),
        ( QuantityArray{Int32}([2, 2], lengthDim, intu2), Array{Int32}([2 2]), QuantityArray{Int32}( 4 * ones(2,2), lengthDim, intu2 ) ),
        ( QuantityArray{Int32}([2, 2], lengthDim, intu), [2 2], QuantityArray{Int64}( 4 * ones(2,2), lengthDim, intu ) )
    ]
    return examples
end

function Array_QuantityArray_multiplication_implemented()
    examples = _getExamplesFor_Array_Quantity_multiplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_Array_Quantity_multiplication()
    # format: factor1, factor2, correct product factor1 * factor2
    examples = [
        ( ones(2,2), QuantityArray(ones(2,2), dimless, intu), QuantityArray(2*ones(2,2), dimless, intu) ),
        ( [1 1], QuantityArray([2, 2], lengthDim, intu), QuantityArray([4], lengthDim, intu) ),
        ( [2, 2], QuantityArray([1 1], lengthDim, intu2), QuantityArray( 2 * ones(2,2), lengthDim, intu2 ) ),
        ( Array{Int32}([2, 2]), QuantityArray{Int32}([2 2], lengthDim, intu2), QuantityArray{Int32}( 4 * ones(2,2), lengthDim, intu2 ) ),
        ( [2, 2], QuantityArray{Int32}([2 2], lengthDim, intu), QuantityArray{Int64}( 4 * ones(2,2), lengthDim, intu ) )
    ]
    return examples
end

function QuantityArray_Quantity_multiplication_implemented()
    examples = _getExamplesFor_QuantityArray_Quantity_multiplication_implemented()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_QuantityArray_Quantity_multiplication_implemented()
    # format: factor1, factor2, correct product factor1 * factor2
    examples = [
        ( QuantityArray(ones(2,2), dimless, intu), Quantity(1, dimless, intu), QuantityArray(ones(2,2), dimless, intu) ),
        ( QuantityArray([1 1], dimless, intu), Quantity(2, lengthDim, intu), QuantityArray([2 2], lengthDim, intu) ),
        ( QuantityArray([2, 2], lengthDim, intu), Quantity(1, dimless, intu), QuantityArray([2, 2], lengthDim, intu) ),
        ( QuantityArray{Float32}([2.5 3.5], lengthDim, intu), Quantity{Float32}(2, lengthDim, intu), QuantityArray{Float32}([5 7], Dimension(L=2), intu) ),
        ( QuantityArray{Int32}([2], lengthDim, intu2), Quantity(5, lengthDim, intu), QuantityArray{Int32}([5], Dimension(L=2), intu2 ) ),
        ( QuantityArray{Int32}([2], lengthDim, intu), Quantity(5, lengthDim, intu2), QuantityArray{Int32}([20], Dimension(L=2), intu ) )
    ]
    return examples
end

function Quantity_QuantityArray_multiplication_implemented()
    examples = _getExamplesFor_Quantity_QuantityArray_multiplication_implemented()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_Quantity_QuantityArray_multiplication_implemented()
    # format: factor1, factor2, correct product factor1 * factor2
    examples = [
        ( Quantity(1, dimless, intu), QuantityArray(ones(2,2), dimless, intu), QuantityArray(ones(2,2), dimless, intu) ),
        ( Quantity(2, lengthDim, intu), QuantityArray([1 1], dimless, intu), QuantityArray([2 2], lengthDim, intu) ),
        ( Quantity(1, dimless, intu), QuantityArray([2, 2], lengthDim, intu), QuantityArray([2, 2], lengthDim, intu) ),
        ( Quantity{Float32}(2, lengthDim, intu), QuantityArray{Float32}([2.5 3.5], lengthDim, intu), QuantityArray{Float32}([5 7], Dimension(L=2), intu) ),
        ( Quantity(5, lengthDim, intu), QuantityArray{Int32}([2], lengthDim, intu2), QuantityArray{Int32}([20], Dimension(L=2), intu ) ),
        ( Quantity(5, lengthDim, intu2), QuantityArray{Int32}([2], lengthDim, intu), QuantityArray{Int32}([5], Dimension(L=2), intu2 ) )
    ]
    return examples
end

function QuantityArray_Number_multiplication_implemented()
    examples = _getExamplesFor_QuantityArray_Number_multiplication_implemented()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_QuantityArray_Number_multiplication_implemented()
    # format: factor1, factor2, correct product factor1 * factor2
    examples = [
        ( QuantityArray(ones(2,2), dimless, intu), 1, QuantityArray(ones(2,2), dimless, intu) ),
        ( QuantityArray([1 1], lengthDim, intu), 2, QuantityArray([2 2], lengthDim, intu) ),
        ( QuantityArray{Float32}([2.5 3.5], lengthDim, intu),Float32(2), QuantityArray{Float32}([5 7], lengthDim, intu) ),
        ( QuantityArray{Int32}([2], lengthDim, intu2), 5, QuantityArray{Int32}([10], lengthDim, intu2 ) )
    ]
    return examples
end

function Number_QuantityArray_multiplication_implemented()
    examples = _getExamplesFor_Number_QuantityArray_multiplication_implemented()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_Number_QuantityArray_multiplication_implemented()
    # format: factor1, factor2, correct product factor1 * factor2
    examples = [
        ( 1, QuantityArray(ones(2,2), dimless, intu), QuantityArray(ones(2,2), dimless, intu) ),
        ( 2, QuantityArray([1 1], lengthDim, intu), QuantityArray([2 2], lengthDim, intu) ),
        ( Float32(2), QuantityArray{Float32}([2.5 3.5], lengthDim, intu), QuantityArray{Float32}([5 7], lengthDim, intu) ),
        ( 5, QuantityArray{Int32}([2], lengthDim, intu2), QuantityArray{Int32}([10], lengthDim, intu2 ) )
    ]
    return examples
end

# multiplication: mixed
function SimpleQuantity_Quantity_multiplication_implemented()
    examples = _getExamplesFor_SimpleQuantity_Quantity_multiplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_SimpleQuantity_Quantity_multiplication()
    # format: factor1, factor2, correct product factor1 * factor2
    examples = [
        ( 1 * Alicorn.unitlessUnit, Quantity(1, dimless, intu), Quantity(1, dimless, intu) ),
        ( SimpleQuantity{Int32}(3, Alicorn.unitlessUnit), Quantity{Int32}(2, lengthDim, intu), Quantity{Int32}(6, lengthDim, intu) ),
        ( SimpleQuantity{Float64}(2.5, ucat.meter),  Quantity{Int32}(2, Dimension(T=1), intu), Quantity{Float64}(5, Dimension(L=1, T=1), intu) ),
        ( SimpleQuantity{Int32}(2, ucat.meter), Quantity{Float64}(-2.5, Dimension(T=1), intu2), Quantity{Float64}(-2.5, Dimension(L=1, T=1), intu2 ) )
    ]
    return examples
end

function Quantity_SimpleQuantity_multiplication_implemented()
    examples = _getExamplesFor_Quantity_SimpleQuantity_multiplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_Quantity_SimpleQuantity_multiplication()
    # format: factor1, factor2, correct product factor1 * factor2
    examples = [
        ( Quantity(1, dimless, intu), 1 * Alicorn.unitlessUnit, Quantity(1, dimless, intu) ),
        ( Quantity{Int32}(2, lengthDim, intu), SimpleQuantity{Int32}(3, Alicorn.unitlessUnit), Quantity{Int32}(6, lengthDim, intu) ),
        ( Quantity{Int32}(2, Dimension(T=1), intu), SimpleQuantity{Float64}(2.5, ucat.meter), Quantity{Float64}(5, Dimension(L=1, T=1), intu) ),
        ( Quantity{Float64}(-2.5, Dimension(T=1), intu2), SimpleQuantity{Int32}(2, ucat.meter), Quantity{Float64}(-2.5, Dimension(L=1, T=1), intu2 ) )
    ]
    return examples
end

function SimpleQuantityArray_QuantityArray_multiplication_implemented()
    examples = _getExamplesFor_SimpleQuantityArray_QuantityArray_multiplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_SimpleQuantityArray_QuantityArray_multiplication()
    # format: factor1, factor2, correct product factor1 * factor2
    examples = [
        ( SimpleQuantityArray(ones(2,2), Alicorn.unitlessUnit), QuantityArray(ones(2,2), dimless, intu), QuantityArray(2*ones(2,2), dimless, intu) ),
        ( SimpleQuantityArray([1 1], ucat.meter), QuantityArray([2, 2], lengthDim, intu), QuantityArray([4], Dimension(L=2), intu) ),
        ( SimpleQuantityArray([2, 2], ucat.meter), QuantityArray([1 1], lengthDim, intu2), QuantityArray( ones(2,2), Dimension(L=2), intu2 ) ),
        ( SimpleQuantityArray{Int32}([2, 2], ucat.meter), QuantityArray{Int32}([2 2], lengthDim, intu), QuantityArray{Int32}( 4 * ones(2,2), Dimension(L=2), intu ) ),
        ( SimpleQuantityArray{Int32}(2 * [2, 2], ucat.meter), QuantityArray{Int32}([2 2], lengthDim, intu2), QuantityArray{Int32}( 4 * ones(2,2), Dimension(L=2), intu2 ) ),
    ]
    return examples
end

function QuantityArray_SimpleQuantityArray_multiplication_implemented()
    examples = _getExamplesFor_QuantityArray_SimpleQuantityArray_multiplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_QuantityArray_SimpleQuantityArray_multiplication()
    # format: factor1, factor2, correct product factor1 * factor2
    examples = [
        ( QuantityArray(ones(2,2), dimless, intu), SimpleQuantityArray(ones(2,2), Alicorn.unitlessUnit), QuantityArray(2*ones(2,2), dimless, intu) ),
        ( QuantityArray([1 1], lengthDim, intu), SimpleQuantityArray([2, 2], ucat.meter), QuantityArray([4], Dimension(L=2), intu) ),
        ( QuantityArray([1, 1], lengthDim, intu2), SimpleQuantityArray(2 * [1 1], ucat.meter), QuantityArray( ones(2,2), Dimension(L=2), intu2 ) ),
        ( QuantityArray{Int32}([2, 2], lengthDim, intu), SimpleQuantityArray{Int32}([2 2], ucat.meter), QuantityArray{Int32}( 4 * ones(2,2), Dimension(L=2), intu ) ),
        ( QuantityArray{Int32}([2, 2], lengthDim, intu2), SimpleQuantityArray{Int32}(2 * [2 2], ucat.meter), QuantityArray{Int32}( 4 * ones(2,2), Dimension(L=2), intu2 ) ),
    ]
    return examples
end

function SimpleQuantityArray_Quantity_multiplication_implemented()
    examples = _getExamplesFor_SimpleQuantityArray_Quantity_multiplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_SimpleQuantityArray_Quantity_multiplication()
    # format: factor1, factor2, correct product factor1 * factor2
    examples = [
        ( ones(2,2) * Alicorn.unitlessUnit, Quantity(1, dimless, intu), QuantityArray(ones(2,2), dimless, intu ) ),
        ( [1 1] * Alicorn.unitlessUnit, Quantity(2, Dimension(T=1), intu), QuantityArray([2 2], Dimension(T=1), intu) ),
        ( [2, 2] * ucat.second, Quantity(1, dimless, intu), QuantityArray([2, 2], Dimension(T=1), intu) ),
        ( [2.5 3.5] * ucat.meter, Quantity(4, Dimension(T=1), intu2), QuantityArray([5 7], Dimension(L=1, T=1), intu2) ),
        ( [2] * ucat.second, Quantity(2.5, lengthDim, intu), QuantityArray([5.0], Dimension(L=1, T=1), intu) )
    ]
    return examples
end

function Quantity_SimpleQuantityArray_multiplication_implemented()
    examples = _getExamplesFor_Quantity_SimpleQuantityArray_multiplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_Quantity_SimpleQuantityArray_multiplication()
    # format: factor1, factor2, correct product factor1 * factor2
    examples = [
        ( Quantity(1, dimless, intu), ones(2,2) * Alicorn.unitlessUnit, QuantityArray(ones(2,2), dimless, intu ) ),
        ( Quantity(2, Dimension(T=1), intu), [1 1] * Alicorn.unitlessUnit, QuantityArray([2 2], Dimension(T=1), intu) ),
        ( Quantity(1, dimless, intu), [2, 2] * ucat.second, QuantityArray([2, 2], Dimension(T=1), intu) ),
        ( Quantity(4, Dimension(T=1), intu2), [2.5 3.5] * ucat.meter, QuantityArray([5 7], Dimension(L=1, T=1), intu2) ),
        ( Quantity(2.5, lengthDim, intu), [2] * ucat.second, QuantityArray([5.0], Dimension(L=1, T=1), intu) )
    ]
    return examples
end

function QuantityArray_SimpleQuantity_multiplication_implemented()
    examples = _getExamplesFor_QuantityArray_SimpleQuantity_multiplication_implemented()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_QuantityArray_SimpleQuantity_multiplication_implemented()
    # format: factor1, factor2, correct product factor1 * factor2
    examples = [
        ( QuantityArray(ones(2,2), dimless, intu), SimpleQuantity(1, Alicorn.unitlessUnit), QuantityArray(ones(2,2), dimless, intu) ),
        ( QuantityArray([1 1], dimless, intu), SimpleQuantity(2, ucat.meter), QuantityArray([2 2], lengthDim, intu) ),
        ( QuantityArray([2, 2], lengthDim, intu), SimpleQuantity(1, Alicorn.unitlessUnit), QuantityArray([2, 2], lengthDim, intu) ),
        ( QuantityArray{Float32}([2.5 3.5], lengthDim, intu), SimpleQuantity{Float32}(2, ucat.meter), QuantityArray{Float32}([5 7], Dimension(L=2), intu) ),
        ( QuantityArray{Int32}([2], lengthDim, intu2), SimpleQuantity(5, ucat.meter), QuantityArray{Int32}([5], Dimension(L=2), intu2 ) ),
        ( QuantityArray{Int32}([2], lengthDim, intu), SimpleQuantity(5, ucat.meter), QuantityArray{Int32}([10], Dimension(L=2), intu ) )
    ]
    return examples
end

function SimpleQuantity_QuantityArray_multiplication_implemented()
    examples = _getExamplesFor_SimpleQuantity_QuantityArray_multiplication_implemented()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_SimpleQuantity_QuantityArray_multiplication_implemented()
    # format: factor1, factor2, correct product factor1 * factor2
    examples = [
        ( SimpleQuantity(1, Alicorn.unitlessUnit), QuantityArray(ones(2,2), dimless, intu), QuantityArray(ones(2,2), dimless, intu) ),
        ( SimpleQuantity(2, ucat.meter), QuantityArray([1 1], dimless, intu), QuantityArray([2 2], lengthDim, intu) ),
        ( SimpleQuantity(1, Alicorn.unitlessUnit), QuantityArray([2, 2], lengthDim, intu), QuantityArray([2, 2], lengthDim, intu) ),
        ( SimpleQuantity{Float32}(2, ucat.meter), QuantityArray{Float32}([2.5 3.5], lengthDim, intu), QuantityArray{Float32}([5 7], Dimension(L=2), intu) ),
        ( SimpleQuantity(5, ucat.meter), QuantityArray{Int32}([2], lengthDim, intu2), QuantityArray{Int32}([5], Dimension(L=2), intu2 ) ),
        ( SimpleQuantity(5, ucat.meter), QuantityArray{Int32}([2], lengthDim, intu), QuantityArray{Int32}([10], Dimension(L=2), intu ) )
    ]
    return examples
end

################ TODO below

#

#
#

#
#
# function division_implemented()
#     examples = _getExamplesFor_division()
#     return TestingTools.testDyadicFunction(Base.:/, examples)
# end
#
# function _getExamplesFor_division()
#     # format: factor1, factor2, correct result for factor1 / factor2
#     examples = [
#         ( 1 * Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit ),
#         ( 1 * Alicorn.unitlessUnit, 2 * ucat.second, 0.5 / ucat.second ),
#         ( 2 * ucat.second, 1 * Alicorn.unitlessUnit, 2 * ucat.second ),
#         ( 2.5 * ucat.meter,  2 * ucat.second, 1.25 * ucat.meter / ucat.second ),
#         ( 5 * ucat.second, 2 * ucat.meter, 2.5 * ucat.second / ucat.meter ),
#         ( -7 * ucat.lumen * (ucat.nano * ucat.second),  2 * (ucat.pico * ucat.second) , -3.5 * ucat.lumen * (ucat.nano * ucat.second) / (ucat.pico * ucat.second) ),
#         ( 2 * (ucat.milli * ucat.candela)^-4, 4 * (ucat.milli * ucat.candela)^2, 0.5 * (ucat.milli * ucat.candela)^-6 )
#     ]
#     return examples
# end
#
# function SimpleQuantity_Number_division_implemented()
#     examples = _getExamplesFor_SimpleQuantity_Number_division()
#     return TestingTools.testDyadicFunction(Base.:/, examples)
# end
#
# function _getExamplesFor_SimpleQuantity_Number_division()
#     # format: factor1, factor2, correct result for factor1 / factor2
#     examples = [
#         ( 1 * Alicorn.unitlessUnit, 2 , 1/2 * Alicorn.unitlessUnit ),
#         ( 2 * ucat.second, 4, 1/2 * ucat.second ),
#         ( -7 * ucat.lumen * (ucat.nano * ucat.second), 2, -3.5 * ucat.lumen * (ucat.nano * ucat.second) )
#     ]
#     return examples
# end
#
# function Number_SimpleQuantity_division_implemented()
#     examples = _getExamplesFor_Number_SimpleQuantity_division()
#     return TestingTools.testDyadicFunction(Base.:/, examples)
# end
#
# function _getExamplesFor_Number_SimpleQuantity_division()
#     # format: factor1, factor2, correct result for factor1 / factor2
#     examples = [
#         ( 2, 1 * Alicorn.unitlessUnit , 2 * Alicorn.unitlessUnit ),
#         ( 4, 2 * ucat.second, 2 / ucat.second ),
#         ( 2, -4 * (ucat.milli * ucat.candela)^2, -0.5 * (ucat.milli * ucat.candela)^-2 )
#     ]
#     return examples
# end
#
# function SimpleQuantity_Array_division_implemented()
#     examples = _getExamplesFor_SimpleQuantity_Array_division()
#     return TestingTools.testDyadicFunction(Base.:/, examples)
# end
#
# function _getExamplesFor_SimpleQuantity_Array_division()
#     # format: factor1, factor2, correct result for factor1 / factor2
#     examples = [
#         ( 2 * Alicorn.unitlessUnit , [1; 2], (2 / [1; 2]) * Alicorn.unitlessUnit ),
#         ( 8 * ucat.second, [2; 2], (8 / [2; 2]) * ucat.second ),
#         ( 2 * (ucat.milli * ucat.candela)^2, [-4] , (2/[-4]) * (ucat.milli * ucat.candela)^2 )
#     ]
#     return examples
# end
#
# function Array_SimpleQuantity_division_implemented()
#     examples = _getExamplesFor_Array_SimpleQuantity_division()
#     return TestingTools.testDyadicFunction(Base.:/, examples)
# end
#
# function _getExamplesFor_Array_SimpleQuantity_division()
#     # format: factor1, factor2, correct result for factor1 / factor2
#     examples = [
#         ( [1; 2], 2 * Alicorn.unitlessUnit, ([1; 2] / 2) * Alicorn.unitlessUnit ),
#         ( [2; 2], 8 * ucat.second, ([2; 2] / 8) / ucat.second ),
#         ( [-4], 2 * (ucat.milli * ucat.candela)^2, ([-4]/2) * (ucat.milli * ucat.candela)^-2 )
#     ]
#     return examples
# end
#
# function inverseDivision_implemented()
#     examples = _getExamplesFor_inverseDivision()
#     return TestingTools.testDyadicFunction(Base.:\, examples)
# end
#
# function _getExamplesFor_inverseDivision()
#     # format: factor1, factor2, correct result for factor1 / factor2
#     examples = [
#         ( 1 * Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit ),
#         ( 2 * ucat.second, 1 * Alicorn.unitlessUnit, 0.5 / ucat.second ),
#         ( 1 * Alicorn.unitlessUnit, 2 * ucat.second, 2 * ucat.second ),
#         ( 2 * ucat.second, 2.5 * ucat.meter, 1.25 * ucat.meter / ucat.second ),
#         ( 2 * ucat.meter, 5 * ucat.second, 2.5 * ucat.second / ucat.meter ),
#         ( 2 * (ucat.pico * ucat.second), -7 * ucat.lumen * (ucat.nano * ucat.second),  -3.5 * ucat.lumen * (ucat.nano * ucat.second) / (ucat.pico * ucat.second) ),
#         ( 4 * (ucat.milli * ucat.candela)^2, 2 * (ucat.milli * ucat.candela)^-4, 0.5 * (ucat.milli * ucat.candela)^-6 )
#     ]
#     return examples
# end
#
# function SimpleQuantity_Number_inverseDivision_implemented()
#     examples = _getExamplesFor_SimpleQuantity_Number_inverseDivision()
#     return TestingTools.testDyadicFunction(Base.:\, examples)
# end
#
# function _getExamplesFor_SimpleQuantity_Number_inverseDivision()
#     # format: factor1, factor2, correct result factor1 \ factor2
#     examples = [
#         ( 1 * Alicorn.unitlessUnit, 2, 2 * Alicorn.unitlessUnit ),
#         ( 2 * ucat.second, 4, 2 / ucat.second ),
#         ( -4 * (ucat.milli * ucat.candela)^2, 2, -0.5 * (ucat.milli * ucat.candela)^-2 )
#     ]
#     return examples
# end
#
# function Number_SimpleQuantity_inverseDivision_implemented()
#     examples = _getExamplesFor_Number_SimpleQuantity_inverseDivision()
#     return TestingTools.testDyadicFunction(Base.:\, examples)
# end
#
# function _getExamplesFor_Number_SimpleQuantity_inverseDivision()
#     # format: factor1, factor2, correct result factor1 \ factor2
#     examples = [
#         ( 2 , 1 * Alicorn.unitlessUnit, 1/2 * Alicorn.unitlessUnit ),
#         ( 4, 2 * ucat.second, 1/2 * ucat.second ),
#         ( 2, -7 * ucat.lumen * (ucat.nano * ucat.second), -3.5 * ucat.lumen * (ucat.nano * ucat.second) )
#     ]
#     return examples
# end
#
# function SimpleQuantity_Array_inverseDivision_implemented()
#     examples = _getExamplesFor_SimpleQuantity_Array_inverseDivision()
#     return TestingTools.testDyadicFunction(Base.:\, examples)
# end
#
# function _getExamplesFor_SimpleQuantity_Array_inverseDivision()
#     # format: factor1, factor2, correct result factor1 \ factor2
#     examples = [
#         ( 2 * Alicorn.unitlessUnit, [1; 2], (2 \ [1; 2] ) * Alicorn.unitlessUnit ),
#         ( 8 * ucat.second, [2; 2], (8 \ [2; 2] ) / ucat.second ),
#         ( 2 * (ucat.milli * ucat.candela)^2, [-4], (2 \ [-4]) * (ucat.milli * ucat.candela)^-2 )
#     ]
#     return examples
# end
#
# function exponentiation_implemented()
#     examples = _getExamplesFor_exponentiation()
#     return TestingTools.testDyadicFunction(Base.:^, examples)
# end
#
# function _getExamplesFor_exponentiation()
#     # format: SimpleQuantity, exponent, correct result for SimpleQuantity^exponent
#     examples = [
#         ( 1 * Alicorn.unitlessUnit, 1, 1 * Alicorn.unitlessUnit ),
#         ( 2 * ucat.meter, 0, 1 * Alicorn.unitlessUnit),
#         ( 2 * ucat.meter, 1, 2 * ucat.meter ),
#         ( 2.0 * ucat.meter, -1, 0.5 / ucat.meter),
#         ( 2.0 * (ucat.pico * ucat.meter)^2 * (ucat.tera * ucat.siemens)^-3, -2, 0.25 * (ucat.pico * ucat.meter)^-4 * (ucat.tera * ucat.siemens)^6 )
#     ]
#     return examples
# end
#
# function inv_implemented()
#     examples = _getExamplesFor_inv()
#     return TestingTools.testMonadicFunction(Base.inv, examples)
# end
#
# function _getExamplesFor_inv()
#     # format: SimpleQuantity, correct result for SimpleQuantity^-1
#     examples = [
#         ( 1 * Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit),
#         ( 2 * ucat.meter, 0.5 * ucat.meter^-1),
#         ( -5 * (ucat.femto * ucat.meter)^-1 * ucat.joule, -0.2 * (ucat.femto * ucat.meter) * ucat.joule^-1 )
#     ]
#     return examples
# end
#
# ## 3. Numeric comparison
#
# function equality_implemented()
#     examples = _getExamplesFor_equality()
#     return TestingTools.testDyadicFunction(Base.:(==), examples)
# end
#
# function _getExamplesFor_equality()
#     baseUnit = ucat.ampere
#
#     sQuantity1 = SimpleQuantity(7, baseUnit)
#     sQuantity1Copy = SimpleQuantity(7, baseUnit)
#
#     sQuantity2 = SimpleQuantity(0.7, ucat.deca * baseUnit)
#     sQuantity3 = SimpleQuantity(pi, baseUnit)
#     sQuantity4 = SimpleQuantity(7, ucat.deca * baseUnit)
#
#     # format: quantity1, quantity2, correct result for quantity1 == quantity2
#     examples = [
#         ( sQuantity1, sQuantity1Copy, true ),
#         ( sQuantity1, sQuantity2, true ),
#         ( sQuantity1, sQuantity3, false ),
#         ( sQuantity1, sQuantity4, false )
#     ]
#     return examples
# end
#
# function test_equality_ErrorsForMismatchedDimensions()
#     (mismatchedSQ1, mismatchedSQ2) = _generateDimensionMismatchedQuantities()
#     expectedError = Alicorn.Exceptions.DimensionMismatchError("compared quantities are not of the same physical dimension")
#     @test_throws expectedError (mismatchedSQ1 == mismatchedSQ2)
# end
#
# function isless_implemented()
#     examples = _getExamplesFor_isless()
#     return TestingTools.testDyadicFunction(Base.isless, examples)
# end
#
# function _getExamplesFor_isless()
#     value = abs(TestingTools.generateRandomReal())
#     baseUnit = TestingTools.generateRandomBaseUnit()
#
#     sQuantity1 = SimpleQuantity(value, baseUnit)
#     sQuantity2 = SimpleQuantity(-value, baseUnit)
#     sQuantity3 = SimpleQuantity(2*value, baseUnit)
#     sQuantity4 = SimpleQuantity(value, ucat.deci * baseUnit)
#
#     # format: quantity1, quantity2, correct result for isless(quantity1, quantity2)
#     examples = [
#         ( sQuantity1, sQuantity2, false ),
#         ( sQuantity2, sQuantity1, true ),
#         ( sQuantity1, sQuantity3, true ),
#         ( sQuantity1, sQuantity4, false )
#     ]
#     return examples
# end
#
# function test_isless_ErrorsForMismatchedDimensions()
#     (mismatchedSQ1, mismatchedSQ2) = _generateDimensionMismatchedQuantities()
#     expectedError = Alicorn.Exceptions.DimensionMismatchError("compared quantities are not of the same physical dimension")
#     @test_throws expectedError isless(mismatchedSQ1, mismatchedSQ2)
# end
#
# function isfinite_implemented()
#     examples = _getExamplesFor_isfinite()
#     return TestingTools.testMonadicFunction(Base.isfinite, examples)
# end
#
# function _getExamplesFor_isfinite()
#     unit = TestingTools.generateRandomUnit()
#
#     sQuantity1 = SimpleQuantity(Inf, unit)
#     sQuantity2 = SimpleQuantity(-Inf, unit)
#     sQuantity3 = SimpleQuantity(NaN, unit)
#     sQuantity4 = SimpleQuantity(pi, unit)
#
#     # format: quantity1, quantity2, correct result for isless(quantity1, quantity2)
#     examples = [
#         ( sQuantity1, false ),
#         ( sQuantity2, false ),
#         ( sQuantity3, false ),
#         ( sQuantity4, true )
#     ]
#     return examples
# end
#
# function isinf_implemented()
#     examples = _getExamplesFor_isinf()
#     return TestingTools.testMonadicFunction(Base.isinf, examples)
# end
#
# function _getExamplesFor_isinf()
#     unit = TestingTools.generateRandomUnit()
#
#     sQuantity1 = SimpleQuantity(Inf, unit)
#     sQuantity2 = SimpleQuantity(-Inf, unit)
#     sQuantity3 = SimpleQuantity(NaN, unit)
#     sQuantity4 = SimpleQuantity(pi, unit)
#
#     # format: quantity1, quantity2, correct result for isless(quantity1, quantity2)
#     examples = [
#         ( sQuantity1, true ),
#         ( sQuantity2, true ),
#         ( sQuantity3, false ),
#         ( sQuantity4, false )
#     ]
#     return examples
# end
#
# function isnan_implemented()
#     examples = _getExamplesFor_isnan()
#     return TestingTools.testMonadicFunction(Base.isnan, examples)
# end
#
# function _getExamplesFor_isnan()
#     unit = TestingTools.generateRandomUnit()
#
#     sQuantity1 = SimpleQuantity(Inf, unit)
#     sQuantity2 = SimpleQuantity(NaN, unit)
#     sQuantity3 = SimpleQuantity(-NaN, unit)
#     sQuantity4 = SimpleQuantity(pi, unit)
#
#     # format: quantity1, quantity2, correct result for isless(quantity1, quantity2)
#     examples = [
#         ( sQuantity1, false ),
#         ( sQuantity2, true ),
#         ( sQuantity3, true ),
#         ( sQuantity4, false )
#     ]
#     return examples
# end
#
# function isapprox_implemented()
#     examples = _getExamplesFor_isapprox()
#     return _test_isapprox_examples(examples)
# end
#
# function _getExamplesFor_isapprox()
#     examples = [
#         ( 7 * ucat.meter, 71 * (ucat.deci * ucat.meter), 0.01, false ),
#         ( 7 * ucat.meter, 71 * (ucat.deci * ucat.meter), 0.015, true )
#     ]
#     return examples
# end
#
# function _test_isapprox_examples(examples::Array)
#     pass = true
#     for (sq1, sq2, rtol, correctResult) in examples
#         pass &= ( isapprox(sq1, sq2, rtol=rtol) == correctResult )
#     end
#     return pass
# end
#
# function test_isapprox_ErrorsForMismatchedDimensions()
#     (mismatchedSQ1, mismatchedSQ2) = _generateDimensionMismatchedQuantities()
#     expectedError = Alicorn.Exceptions.DimensionMismatchError("compared quantities are not of the same physical dimension")
#     @test_throws expectedError isapprox(mismatchedSQ1, mismatchedSQ2)
# end
#
# ## 4. Rounding
#
# function mod2pi_implemented()
#     examples = _getExamplesFor_mod2pi()
#     return TestingTools.testMonadicFunction(Base.mod2pi, examples)
# end
#
# function _getExamplesFor_mod2pi()
#     # format: SimpleQuantity, correct result for mod2pi(SimpleQuantity)
#     examples = [
#         ( 6*pi * Alicorn.unitlessUnit, mod2pi(6*pi) * Alicorn.unitlessUnit ),
#         ( -7.1*pi * Alicorn.ampere, mod2pi(-7.1*pi) * Alicorn.ampere )
#     ]
#     return examples
# end
#
# ## 5. Sign and absolute value
#
# function abs_implemented()
#     examples = _getExamplesFor_abs()
#     return TestingTools.testMonadicFunction(Base.abs, examples)
# end
#
# function _getExamplesFor_abs()
#     # format: SimpleQuantity, correct result for abs(SimpleQuantity)
#     examples = [
#         ( 5.2 * ucat.joule, 5.2 * ucat.joule ),
#         ( -7.1 * ucat.ampere, 7.1 * ucat.ampere ),
#         ( (4 + 2im) * ucat.meter , sqrt(4^2 + 2^2) * ucat.meter )
#     ]
#     return examples
# end
#
# function abs2_implemented()
#     examples = _getExamplesFor_abs2()
#     return TestingTools.testMonadicFunction(Base.abs2, examples)
# end
#
# function _getExamplesFor_abs2()
#     # format: SimpleQuantity, correct result for abs2(SimpleQuantity)
#     examples = [
#         ( 5.2 * ucat.joule, (5.2)^2 * (ucat.joule)^2 ),
#         ( -7.1 * ucat.ampere, (7.1)^2 * (ucat.ampere)^2 ),
#         ( (4 + 2im) * ucat.meter , (4^2 + 2^2) * (ucat.meter)^2 )
#     ]
#     return examples
# end
#
# function sign_implemented()
#     examples = _getExamplesFor_sign()
#     return TestingTools.testMonadicFunction(Base.sign, examples)
# end
#
# function _getExamplesFor_sign()
#     # format: SimpleQuantity, correct result for sign(SimpleQuantity)
#     examples = [
#         ( 5.2 * ucat.joule, 1 ),
#         ( -7.1 * ucat.ampere, -1 ),
#         ( (4 + 2im) * ucat.meter , sign(4 + 2im) )
#     ]
#     return examples
# end
#
# function signbit_implemented()
#     examples = _getExamplesFor_signbit()
#     return TestingTools.testMonadicFunction(Base.signbit, examples)
# end
#
# function _getExamplesFor_signbit()
#     # format: SimpleQuantity, correct result for signbit(SimpleQuantity)
#     examples = [
#         ( 5.2 * ucat.joule, false ),
#         ( -7.1 * ucat.ampere, true )
#     ]
#     return examples
# end
#
# function copysign_implemented()
#     examples = _getExamplesFor_copysign()
#     return TestingTools.testDyadicFunction(Base.copysign, examples)
# end
#
# function _getExamplesFor_copysign()
#     # format: SimpleQuantity, object, correct result for copysign(SimpleQuantity, object)
#     examples = [
#         ( 5.2 * ucat.joule, -3.5, -5.2 * ucat.joule ),
#         ( 5.2 * ucat.joule, 3.5, 5.2 * ucat.joule ),
#         ( 3.5, 5.2 * ucat.joule, 3.5 ),
#         ( 3.5, -5.2 * ucat.joule, -3.5 ),
#         ( -3.5, 5.2 * ucat.joule, 3.5 ),
#         ( -3.5, -5.2 * ucat.joule, -3.5 ),
#         ( -7.1 * ucat.ampere, 5.2 * ucat.joule, 7.1 * ucat.ampere),
#         ( -7.1 * ucat.ampere, -5.2 * ucat.joule, -7.1 * ucat.ampere ),
#         ( 7.1 * ucat.ampere, 5.2 * ucat.joule, 7.1 * ucat.ampere ),
#         ( 7.1 * ucat.ampere, -5.2 * ucat.joule, -7.1 * ucat.ampere )
#     ]
#     return examples
# end
#
# function flipsign_implemented()
#     examples = _getExamplesFor_flipsign()
#     return TestingTools.testDyadicFunction(Base.flipsign, examples)
# end
#
# function _getExamplesFor_flipsign()
#     # format: SimpleQuantity, correct result for flipsign(SimpleQuantity, object)
#     examples = [
#         ( 5.2 * ucat.joule, -5.2 * ucat.joule, -5.2 * ucat.joule ),
#         ( -5.2 * ucat.joule, -5.2 * ucat.joule, 5.2 * ucat.joule ),
#         ( 5.2 * ucat.joule, 5.2 * ucat.joule, 5.2 * ucat.joule ),
#         ( -5.2 * ucat.joule, -5.2 * ucat.joule, 5.2 * ucat.joule ),
#         ( 3.5, -5.2 * ucat.joule, -3.5 ),
#         ( -3.5, -5.2 * ucat.joule, 3.5 ),
#         ( 3.5, 5.2 * ucat.joule, 3.5 ),
#         ( 3.5, -5.2 * ucat.joule, -3.5 ),
#         ( 5.2 * ucat.joule, -3.5, -5.2 * ucat.joule ),
#         ( -5.2 * ucat.joule, -3.5, 5.2 * ucat.joule ),
#         ( 5.2 * ucat.joule, 3.5, 5.2 * ucat.joule ),
#         ( -5.2 * ucat.joule, 3.5, -5.2 * ucat.joule )
#     ]
#     return examples
# end
#
#
# ## 6. Roots
#
# function sqrt_implemented()
#     examples = _getExamplesFor_sqrt()
#     return TestingTools.testMonadicFunction(Base.sqrt, examples)
# end
#
# function _getExamplesFor_sqrt()
#     # format: SimpleQuantity, correct result for sqrt(SimpleQuantity)
#     examples = [
#         ( 1 * Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit ),
#         ( 4 * (ucat.pico * ucat.meter)^-3, 2 * (ucat.pico * ucat.meter)^-1.5 )
#     ]
#     return examples
# end
#
# function cbrt_implemented()
#     examples = _getExamplesFor_cbrt()
#     return TestingTools.testMonadicFunction(Base.cbrt, examples)
# end
#
# function _getExamplesFor_cbrt()
#     # format: SimpleQuantity, correct result for cbrt(SimpleQuantity)
#     examples = [
#         ( 1 * Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit ),
#         ( 4 * (ucat.pico * ucat.meter)^-3, cbrt(4) * (ucat.pico * ucat.meter)^-1 )
#     ]
#     return examples
# end
#
# ## 7. Literal zero
#
# function zero_implemented()
#     examples = _getExamplesFor_zero()
#     return TestingTools.testMonadicFunction(Base.zero, examples)
# end
#
# function _getExamplesFor_zero()
#     # format: SimpleQuantity, correct result for zero(SimpleQuantity)
#     examples = [
#         ( 1 * Alicorn.unitlessUnit, zero(Int64) * Alicorn.unitlessUnit ),
#         ( 4.0 * (ucat.pico * ucat.meter)^-3, zero(Float64) * (ucat.pico * ucat.meter)^-3 )
#     ]
#     return examples
# end
#
# function zero_dyadicImplemented()
#     examples = _getExamplesFor_zero_dyadic()
#     return TestingTools.testDyadicFunction(Base.zero, examples)
# end
#
# function _getExamplesFor_zero_dyadic()
#     # format: numberType, unit, correct result for zero(numberType, unit)
#     examples = [
#         ( UInt32, Alicorn.unitlessUnit, zero(UInt32) * Alicorn.unitlessUnit ),
#         ( Float64, (ucat.pico * ucat.meter)^-3, zero(Float64) * (ucat.pico * ucat.meter)^-3 )
#     ]
#     return examples
# end
#
# function test_zero_dyadic_errorsOnNonnumberType()
#     type = String
#     expectedError = Core.DomainError(type, "type $type is not a subtype of Number")
#     @test_throws expectedError zero(type, ucat.meter)
# end
#
# ## 8. Complex numbers
#
# function real_implemented()
#     examples = _getExamplesFor_real()
#     return TestingTools.testMonadicFunction(Base.real, examples)
# end
#
# function _getExamplesFor_real()
#     # format: SimpleQuantity, correct result for real(SimpleQuantity)
#     examples = [
#         ( 1 * Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit ),
#         ( 1im * Alicorn.unitlessUnit, 0 * Alicorn.unitlessUnit ),
#         ( (4.0 + 2im) * (ucat.pico * ucat.meter)^-3, 4.0 * (ucat.pico * ucat.meter)^-3 )
#     ]
#     return examples
# end
#
# function imag_implemented()
#     examples = _getExamplesFor_imag()
#     return TestingTools.testMonadicFunction(Base.imag, examples)
# end
#
# function _getExamplesFor_imag()
#     # format: SimpleQuantity, correct result for imag(SimpleQuantity)
#     examples = [
#         ( 1 * Alicorn.unitlessUnit, 0 * Alicorn.unitlessUnit ),
#         ( 1im * Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit ),
#         ( (4.0 + 2im) * (ucat.pico * ucat.meter)^-3, 2.0 * (ucat.pico * ucat.meter)^-3 )
#     ]
#     return examples
# end
#
# function conj_implemented()
#     examples = _getExamplesFor_conj()
#     return TestingTools.testMonadicFunction(Base.conj, examples)
# end
#
# function _getExamplesFor_conj()
#     # format: SimpleQuantity, correct result for conj(SimpleQuantity)
#     examples = [
#         ( 1 * Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit ),
#         ( 1im * Alicorn.unitlessUnit, -1im * Alicorn.unitlessUnit ),
#         ( (4.0 + 2im) * (ucat.pico * ucat.meter)^-3, (4.0 - 2im) * (ucat.pico * ucat.meter)^-3 )
#     ]
#     return examples
# end
#
# function angle_implemented()
#     examples = _getExamplesFor_angle()
#     return TestingTools.testMonadicFunction(Base.angle, examples)
# end
#
# function _getExamplesFor_angle()
#     # format: SimpleQuantity, correct result for angle(SimpleQuantity)
#     examples = [
#         ( 1 * Alicorn.unitlessUnit, 0 ),
#         ( 1im * Alicorn.unitlessUnit, pi/2 ),
#         ( (4.0 + 2im) * (ucat.pico * ucat.meter)^-3, angle(4.0 + 2im) )
#     ]
#     return examples
# end
#
#
# ## 9. Compatibility with array functions
#
# function length_implemented()
#     examples = _getExamplesFor_length()
#     return TestingTools.testMonadicFunction(Base.length, examples)
# end
#
# function _getExamplesFor_length()
#     # format: SimpleQuantity, correct result for length(SimpleQuantity)
#     examples = [
#         ( 1123 * ucat.meter, 1 )
#     ]
#     return examples
# end
#
# function size_implemented()
#     examples = _getExamplesFor_size()
#     return TestingTools.testMonadicFunction(Base.size, examples)
# end
#
# function _getExamplesFor_size()
#     # format: SimpleQuantity, correct result for size(SimpleQuantity)
#     examples = [
#         ( 1123 * ucat.meter, () )
#     ]
#     return examples
# end
#
# function ndims_implemented()
#     examples = _getExamplesFor_ndims()
#     return TestingTools.testMonadicFunction(Base.ndims, examples)
# end
#
# function _getExamplesFor_ndims()
#     # format: SimpleQuantity, correct result for ndims(SimpleQuantity)
#     examples = [
#         ( 1123 * ucat.meter, 0 )
#     ]
#     return examples
# end
#
# function getindex_implemented()
#     example = 7.6 * ucat.ampere
#     returnedResult = getindex(example,1)
#     expectedResult = 7.6 * ucat.ampere
#     return (returnedResult == expectedResult)
# end
#
# function test_getindex_errorsForIndexGreaterOne()
#     example = 7.6 * ucat.ampere
#     expectedError = Core.BoundsError
#     @test_throws expectedError getindex(example, 2)
# end

end # module
