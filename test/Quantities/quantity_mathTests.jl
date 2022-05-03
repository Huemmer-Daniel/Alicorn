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
        # Unary plus
        @test unaryPlus_implemented_forSimpleQuantity()
        @test unaryPlus_implemented_forSimpleQuantityArray()
        @test unaryPlus_implemented_forQuantity()
        @test unaryPlus_implemented_forQuantityArray()
        # Unary minus
        @test unaryMinus_implemented_forSimpleQuantity()
        @test unaryMinus_implemented_forSimpleQuantityArray()
        @test unaryMinus_implemented_forQuantity()
        @test unaryMinus_implemented_forQuantityArray()

        ## Arithmetic binary operators
        # Addition
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

        # Subtraction
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

        # Multiplication
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
        # mixed: SimpleQuantity, SimpleQuantityArray, Quantity, and QuantityArray
        @test SimpleQuantity_Quantity_multiplication_implemented()
        @test Quantity_SimpleQuantity_multiplication_implemented()
        @test SimpleQuantityArray_QuantityArray_multiplication_implemented()
        @test QuantityArray_SimpleQuantityArray_multiplication_implemented()
        @test SimpleQuantityArray_Quantity_multiplication_implemented()
        @test Quantity_SimpleQuantityArray_multiplication_implemented()
        @test QuantityArray_SimpleQuantity_multiplication_implemented()
        @test SimpleQuantity_QuantityArray_multiplication_implemented()

        # Division
        # SimpleQuantity
        @test SimpleQuantity_SimpleQuantity_division_implemented()
        @test SimpleQuantity_Number_division_implemented()
        @test Number_SimpleQuantity_division_implemented()
        @test SimpleQuantity_Array_division_implemented()
        @test Array_SimpleQuantity_division_implemented()
        # SimpleQuantityArray
        @test SimpleQuantityArray_SimpleQuantityArray_division_implemented()
        @test SimpleQuantityArray_Array_division_implemented()
        @test Array_SimpleQuantityArray_division_implemented()
        @test SimpleQuantityArray_SimpleQuantity_division_implemented()
        @test SimpleQuantity_SimpleQuantityArray_division_implemented()
        @test SimpleQuantityArray_Number_division_implemented()
        @test Number_SimpleQuantityArray_division_implemented()
        # Quantity
        @test Quantity_Quantity_division_implemented()
        @test Quantity_Number_division_implemented()
        @test Number_Quantity_division_implemented()
        @test Quantity_Array_division_implemented()
        @test Array_Quantity_division_implemented()
        # QuantityArray
        @test QuantityArray_QuantityArray_division_implemented()
        @test QuantityArray_Array_division_implemented()
        @test Array_QuantityArray_division_implemented()
        @test QuantityArray_Quantity_division_implemented()
        @test Quantity_QuantityArray_division_implemented()
        @test QuantityArray_Number_division_implemented()
        @test Number_QuantityArray_division_implemented()
        # mixed: SimpleQuantity, SimpleQuantityArray, Quantity, and QuantityArray
        @test SimpleQuantity_Quantity_division_implemented()
        @test Quantity_SimpleQuantity_division_implemented()
        @test SimpleQuantityArray_QuantityArray_division_implemented()
        @test QuantityArray_SimpleQuantityArray_division_implemented()
        @test SimpleQuantityArray_Quantity_division_implemented()
        @test Quantity_SimpleQuantityArray_division_implemented()
        @test QuantityArray_SimpleQuantity_division_implemented()
        @test SimpleQuantity_QuantityArray_division_implemented()

        # Exponentiation
        @test SimpleQuantity_exponentiation_implemented()
        @test SimpleQuantityArray_exponentiation_implemented()
        @test Quantity_exponentiation_implemented()
        @test QuantityArray_exponentiation_implemented()

        # Inversion
        @test SimpleQuantity_inv_implemented()
        @test SimpleQuantityArray_inv_implemented()
        @test Quantity_inv_implemented()
        @test QuantityArray_inv_implemented()

        ## Numeric comparison
        # Equality
        @test SimpleQuantity_equality_implemented()
        @test SimpleQuantityArray_equality_implemented()
        @test Quantity_equality_implemented()
        @test QuantityArray_equality_implemented()

        # Less
        @test SimpleQuantity_isless_implemented()
        test_SimpleQuantity_isless_ErrorsForMismatchedUnits()
        @test Quantity_isless_implemented()
        test_Quantity_isless_ErrorsForMismatchedDimensions()

        # isfinite
        @test SimpleQuantity_isfinite_implemented()
        @test Quantity_isfinite_implemented()

        # isinf
        @test SimpleQuantity_isinf_implemented()
        @test Quantity_isinf_implemented()

        # isnan
        @test SimpleQuantity_isnan_implemented()
        @test Quantity_isnan_implemented()

        # isapprox
        @test SimpleQuantity_isapprox_implemented()
        @test SimpleQuantityArray_isapprox_implemented()
        @test Quantity_isapprox_implemented()
        @test QuantityArray_isapprox_implemented()


        ## Sign and absolute value
        # abs
        @test SimpleQuantity_abs_implemented()
        @test Quantity_abs_implemented()

        # abs2
        @test SimpleQuantity_abs2_implemented()
        @test Quantity_abs2_implemented()

        # sign
        @test SimpleQuantity_sign_implemented()
        @test Quantity_sign_implemented()

        # signbit
        @test SimpleQuantity_signbit_implemented()
        @test Quantity_signbit_implemented()

        # copysign
        @test copysign_to_SimpleQuantity_implemented()
        @test copysign_to_Quantity_implemented()
        @test copysign_to_Number_implemented()

        # flipsign
        @test flipsign_of_SimpleQuantity_implemented()
        @test flipsign_of_Quantity_implemented()
        @test flipsign_of_Number_implemented()

        ## Roots
        # sqrt
        @test SimpleQuantity_sqrt_implemented()
        @test Quantity_sqrt_implemented()

        # cbrt
        @test SimpleQuantity_cbrt_implemented()
        @test Quantity_cbrt_implemented()

        ## Complex numbers
        # real
        @test SimpleQuantity_real_implemented()
        @test SimpleQuantityArray_real_implemented()
        @test Quantity_real_implemented()
        @test QuantityArray_real_implemented()

        # imag
        @test SimpleQuantity_imag_implemented()
        @test SimpleQuantityArray_imag_implemented()
        @test Quantity_imag_implemented()
        @test QuantityArray_imag_implemented()

        # angle
        @test SimpleQuantity_angle_implemented()
        @test Quantity_angle_implemented()

        # conj
        @test SimpleQuantity_conj_implemented()
        @test Quantity_conj_implemented()
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
    mismatchedAddend2 = Quantity{Int32}(7, timeDim, intu)
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
    mismatchedAddend2 = QuantityArray{Int32}([7], timeDim, intu)
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
        ( 2 * ucat.second, [2.5 3.5] * ucat.meter, [5 7] * ucat.second * ucat.meter ),
        ( 2.5 * ucat.meter, [2] * ucat.second, [5.0] * ucat.meter * ucat.second ),
        ( 2.5 * (ucat.pico * ucat.second), [-7; 1] * ucat.lumen * (ucat.nano * ucat.second), [-17.5 ; 2.5 ] * (ucat.pico * ucat.second) * ucat.lumen * (ucat.nano * ucat.second) ),
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
        ( Quantity{Float64}(2.5, lengthDim, intu2),  Quantity{Int32}(2, timeDim, intu), Quantity{Float64}(5, Dimension(L=1, T=1), intu2) ),
        ( Quantity{Int32}(2, timeDim, intu), Quantity{Float64}(-2.5, lengthDim, intu2), Quantity{Float64}(-10, Dimension(L=1, T=1), intu ) )
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
    examples = _getExamplesFor_Array_QuantityArray_multiplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_Array_QuantityArray_multiplication()
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
        ( SimpleQuantity{Float64}(2.5, ucat.meter),  Quantity{Int32}(2, timeDim, intu), Quantity{Float64}(5, Dimension(L=1, T=1), intu) ),
        ( SimpleQuantity{Int32}(2, ucat.meter), Quantity{Float64}(-2.5, timeDim, intu2), Quantity{Float64}(-2.5, Dimension(L=1, T=1), intu2 ) )
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
        ( Quantity{Int32}(2, timeDim, intu), SimpleQuantity{Float64}(2.5, ucat.meter), Quantity{Float64}(5, Dimension(L=1, T=1), intu) ),
        ( Quantity{Float64}(-2.5, timeDim, intu2), SimpleQuantity{Int32}(2, ucat.meter), Quantity{Float64}(-2.5, Dimension(L=1, T=1), intu2 ) )
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
        ( [1 1] * Alicorn.unitlessUnit, Quantity(2, timeDim, intu), QuantityArray([2 2], timeDim, intu) ),
        ( [2, 2] * ucat.second, Quantity(1, dimless, intu), QuantityArray([2, 2], timeDim, intu) ),
        ( [2.5 3.5] * ucat.meter, Quantity(4, timeDim, intu2), QuantityArray([5 7], Dimension(L=1, T=1), intu2) ),
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
        ( Quantity(2, timeDim, intu), [1 1] * Alicorn.unitlessUnit, QuantityArray([2 2], timeDim, intu) ),
        ( Quantity(1, dimless, intu), [2, 2] * ucat.second, QuantityArray([2, 2], timeDim, intu) ),
        ( Quantity(4, timeDim, intu2), [2.5 3.5] * ucat.meter, QuantityArray([5 7], Dimension(L=1, T=1), intu2) ),
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


## division
# division: SimpleQuantity
function SimpleQuantity_SimpleQuantity_division_implemented()
    examples = _getExamplesFor_SimpleQuantity_SimpleQuantity_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_SimpleQuantity_SimpleQuantity_division()
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

# division: SimpleQuantityArray
function SimpleQuantityArray_SimpleQuantityArray_division_implemented()
    examples = _getExamplesFor_SimpleQuantityArray_SimpleQuantityArray_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_SimpleQuantityArray_SimpleQuantityArray_division()
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

# division: Quantity
function Quantity_Quantity_division_implemented()
    examples = _getExamplesFor_Quantity_Quantity_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_Quantity_Quantity_division()
    # format: factor1, factor2, correct result for factor1 / factor2
    examples = [
        ( Quantity(1, dimless, intu), Quantity(1, dimless, intu), Quantity(1, dimless, intu) ),
        ( Quantity(1, dimless, intu), Quantity(2, lengthDim, intu), Quantity(1/2, Dimension(L=-1), intu) ),
        ( Quantity(3, lengthDim, intu2), Quantity(4, timeDim, intu), Quantity(0.75, Dimension(L=1, T=-1), intu2) ),
        ( Quantity(4, lengthDim, intu), Quantity(1, lengthDim, intu2), Quantity(2, dimless, intu) ),
        ( Quantity{Int32}(10, timeDim, intu), Quantity{Int32}(2, lengthDim, intu), Quantity{Int32}(5, Dimension(T=1,L=-1), intu) )
    ]
    return examples
end

function Quantity_Number_division_implemented()
    examples = _getExamplesFor_Quantity_Number_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_Quantity_Number_division()
    # format: factor1, factor2, correct result for factor1 / factor2
    examples = [
        ( Quantity(1, dimless, intu), 1, Quantity(1, dimless, intu) ),
        ( Quantity(1, lengthDim, intu2), 2, Quantity(1/2, lengthDim, intu2) ),
        ( Quantity(3, lengthDim, intu), 4, Quantity(0.75, lengthDim, intu) ),
        ( Quantity{Int32}(10, timeDim, intu), Int32(2), Quantity{Int32}(5, timeDim, intu) )
    ]
    return examples
end

function Number_Quantity_division_implemented()
    examples = _getExamplesFor_Number_Quantity_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_Number_Quantity_division()
    # format: factor1, factor2, correct result for factor1 / factor2
    examples = [
        ( 1, Quantity(1, dimless, intu), Quantity(1, dimless, intu) ),
        ( 2, Quantity(1, lengthDim, intu2), Quantity(2, Dimension(L=-1), intu2) ),
        ( 4, Quantity(3, lengthDim, intu), Quantity(4/3, Dimension(L=-1), intu) ),
        ( Int32(10), Quantity{Int32}(2, timeDim, intu) , Quantity{Int32}(5, Dimension(T=-1), intu) )
    ]
    return examples
end

function Quantity_Array_division_implemented()
    examples = _getExamplesFor_Quantity_Array_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_Quantity_Array_division()
    # format: factor1, factor2, correct result for factor1 / factor2
    examples = [
        ( Quantity(2, dimless, intu), [1; 2], QuantityArray( 2 / [1; 2], dimless, intu) ),
        ( Quantity(8, timeDim, intu), [2; 2], QuantityArray( 8 / [2; 2], timeDim, intu) ),
        ( Quantity(2, Dimension(L=1, T=2), intu2), [-4] , QuantityArray(2/[-4], Dimension(L=1, T=2), intu2) )
    ]
    return examples
end

function Array_Quantity_division_implemented()
    examples = _getExamplesFor_Array_Quantity_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_Array_Quantity_division()
    # format: factor1, factor2, correct result for factor1 / factor2
    examples = [
        ( [1; 2], Quantity(2, dimless, intu), QuantityArray([1; 2] / 2, dimless, intu) ),
        ( [2; 2], Quantity(8, timeDim, intu2), QuantityArray([2; 2] / 8, Dimension(T=-1), intu2) ),
        ( [-4], Quantity(2, lengthDim, intu), QuantityArray([-4]/2, Dimension(L=-1), intu) )
    ]
    return examples
end

# division: QuantityArray
function QuantityArray_QuantityArray_division_implemented()
    examples = _getExamplesFor_QuantityArray_QuantityArray_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_QuantityArray_QuantityArray_division()
    # format: factor1, factor2, correct quotient factor1 / factor2
    examples = [
        ( QuantityArray([1; 2], dimless, intu), QuantityArray([1; 1], dimless, intu), QuantityArray([ 0.5 0.5; 1.0 1.0 ], dimless, intu) ),
        ( QuantityArray([1, 1], dimless, intu), QuantityArray([2, 2], Dimension(T=1), intu), QuantityArray(0.25 * ones(2,2), Dimension(T=-1), intu) ),
        ( QuantityArray([2], timeDim, intu), QuantityArray([1], dimless, intu), QuantityArray([2] / [1], timeDim, intu) ),
        ( QuantityArray([12], lengthDim, intu2), QuantityArray([2, 2], timeDim, intu), QuantityArray([3.0 3.0], Dimension(L=1,T=-1), intu2) ),
        ( QuantityArray([5, 2], lengthDim, intu), QuantityArray([1], lengthDim, intu2), QuantityArray([5, 2] / [2], dimless, intu ) ),
        ( QuantityArray{Int32}([-8; 2], lengthDim, intu), QuantityArray{Int32}([2], lengthDim, intu) , QuantityArray{Int32}([-8; 2]/[2]), dimless, intu )
    ]
    return examples
end

function QuantityArray_Array_division_implemented()
    examples = _getExamplesFor_QuantityArray_Array_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_QuantityArray_Array_division()
    # format: factor1, factor2, correct quotient factor1 / factor2
    examples = [
        ( QuantityArray([1; 2], dimless, intu), [1; 1], QuantityArray([ 0.5 0.5; 1.0 1.0 ], dimless, intu) ),
        ( QuantityArray([1, 1], timeDim, intu2), [2, 2], QuantityArray(0.25 * ones(2,2), timeDim, intu2) ),
        ( QuantityArray([2], timeDim, intu), [1], QuantityArray([2] / [1], timeDim, intu) ),
        ( QuantityArray([12], lengthDim, intu2), [2, 2], QuantityArray([3.0 3.0], lengthDim, intu2) ),
        ( QuantityArray([5, 2], lengthDim, intu), [2], QuantityArray([5, 2] / [2], lengthDim, intu ) ),
        ( QuantityArray{Int32}([-8; 2], lengthDim, intu), Array{Int32}([2]), QuantityArray{Int32}([-8; 2]/[2], lengthDim, intu ) )
    ]
    return examples
end

function Array_QuantityArray_division_implemented()
    examples = _getExamplesFor_Array_QuantityArray_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_Array_QuantityArray_division()
    # format: factor1, factor2, correct quotient factor1 / factor2
    examples = [
        ( [1; 2], QuantityArray([1; 1], dimless, intu), QuantityArray([ 0.5 0.5; 1.0 1.0 ], dimless, intu) ),
        ( [1, 1], QuantityArray([2, 2], timeDim), QuantityArray(0.25 * ones(2,2), Dimension(T=-1), intu) ),
        ( [12], QuantityArray([2, 2], lengthDim, intu2), QuantityArray([3.0 3.0], Dimension(L=-1), intu2) ),
        ( [5, 2], QuantityArray([2], timeDim, intu), QuantityArray([5, 2] / [2], Dimension(T=-1), intu) ),
        ( Array{Int32}([4]), QuantityArray{Int32}([2], timeDim, intu ), QuantityArray{Float64}([4]/[2], Dimension(T=-1), intu ) )
    ]
    return examples
end

function QuantityArray_Quantity_division_implemented()
    examples = _getExamplesFor_QuantityArray_Quantity_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_QuantityArray_Quantity_division()
    # format: factor1, factor2, correct quotient factor1 / factor2
    examples = [
        ( QuantityArray([1; 2], dimless, intu ), Quantity(1, dimless, intu ), QuantityArray([1; 2], dimless, intu ) ),
        ( QuantityArray([1, 1], dimless, intu ), Quantity(2, timeDim, intu), QuantityArray([0.5, 0.5], Dimension(T=-1), intu) ),
        ( QuantityArray([2], lengthDim, intu2), Quantity(8, Dimension(L=1, T=-1), intu), QuantityArray([0.5], timeDim, intu2) ),
        ( QuantityArray([12], lengthDim, intu), Quantity(2, timeDim, intu2), QuantityArray([6], Dimension(L=1,T=-1), intu) ),
        ( QuantityArray{Int32}([10, 2], lengthDim, intu), Quantity{Int32}(2, dimless, intu), QuantityArray{Int32}([5, 1], lengthDim, intu) )
    ]
    return examples
end

function Quantity_QuantityArray_division_implemented()
    examples = _getExamplesFor_Quantity_QuantityArray_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_Quantity_QuantityArray_division()
    # format: factor1, factor2, correct quotient factor1 / factor2
    examples = [
        ( Quantity(1, dimless, intu), QuantityArray([1; 2], dimless, intu), QuantityArray(1/[1; 2], dimless, intu) ),
        ( Quantity(2, timeDim, intu), QuantityArray([1, 1], dimless, intu), QuantityArray(2/[1,1], timeDim, intu) ),
        ( Quantity(4, dimless, intu), QuantityArray([2], timeDim, intu2), QuantityArray(4/[2], Dimension(T=-1), intu) ),
        ( Quantity(2, lengthDim, intu2), QuantityArray([12], lengthDim, intu), QuantityArray(2/[6], dimless, intu2) ),
        ( Quantity{Int32}(12, lengthDim, intu), QuantityArray{Int32}([1, 1], timeDim, intu2), QuantityArray{Float64}( [6 6], Dimension(L=1, T=-1), intu ) )
    ]
    return examples
end

function QuantityArray_Number_division_implemented()
    examples = _getExamplesFor_QuantityArray_Number_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_QuantityArray_Number_division()
    # format: factor1, factor2, correct quotient factor1 / factor2
    examples = [
        ( QuantityArray([1; 2], dimless, intu ), 1, QuantityArray([1; 2], dimless, intu ) ),
        ( QuantityArray([1, 1], timeDim, intu ), 2, QuantityArray([0.5, 0.5], timeDim, intu) ),
        ( QuantityArray([2], lengthDim, intu2), 4, QuantityArray([0.5], lengthDim, intu2) ),
        ( QuantityArray([12], lengthDim, intu), 2, QuantityArray([6], lengthDim, intu) ),
        ( QuantityArray{Int32}([10, 2], lengthDim, intu), 2, QuantityArray{Int32}([5, 1], lengthDim, intu) )
    ]
    return examples
end

function Number_QuantityArray_division_implemented()
    examples = _getExamplesFor_Number_QuantityArray_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_Number_QuantityArray_division()
    # format: factor1, factor2, correct quotient factor1 / factor2
    examples = [
        ( 1, QuantityArray([1; 2], dimless, intu), QuantityArray(1/[1; 2], dimless, intu) ),
        ( 2, QuantityArray([1, 1], timeDim, intu), QuantityArray(2/[1,1], Dimension(T=-1), intu) ),
        ( 4, QuantityArray([2], timeDim, intu2), QuantityArray(4/[2], Dimension(T=-1), intu2) ),
        ( 2, QuantityArray([12], lengthDim, intu), QuantityArray(2/[12], Dimension(L=-1), intu) ),
        ( Int32(12), QuantityArray{Int32}([1, 1], timeDim, intu), QuantityArray{Float64}( [6 6], Dimension(T=-1), intu ) )
    ]
    return examples
end

# division: mixed
function SimpleQuantity_Quantity_division_implemented()
    examples = _getExamplesFor_SimpleQuantity_Quantity_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_SimpleQuantity_Quantity_division()
    # format: factor1, factor2, correct result for factor1 / factor2
    examples = [
        ( 1 * Alicorn.unitlessUnit, Quantity(1, dimless, intu), Quantity(1, dimless, intu) ),
        ( 1 * Alicorn.unitlessUnit, Quantity(2, timeDim, intu), Quantity(0.5, Dimension(T=-1), intu) ),
        ( 2 * ucat.second, Quantity(1, timeDim, intu), Quantity(2, dimless, intu) ),
        ( 2 * ucat.meter,  Quantity(2, lengthDim, intu2), Quantity(0.5, dimless, intu2) ),
        ( 5 * ucat.second, Quantity(2, lengthDim, intu), Quantity(2.5, Dimension(T=1, L=-1), intu) )
    ]
    return examples
end

function Quantity_SimpleQuantity_division_implemented()
    examples = _getExamplesFor_Quantity_SimpleQuantity_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_Quantity_SimpleQuantity_division()
    # format: factor1, factor2, correct result for factor1 / factor2
    examples = [
        ( Quantity(1, dimless, intu), 1 * Alicorn.unitlessUnit, Quantity(1, dimless, intu) ),
        ( Quantity(2, timeDim, intu), 1 * Alicorn.unitlessUnit, Quantity(2, timeDim, intu) ),
        ( Quantity(1, timeDim, intu), 2 * ucat.second, Quantity(1/2, dimless, intu) ),
        ( Quantity{Int32}(2, lengthDim, intu2), Int32(2) * ucat.meter, Quantity{Int32}(2, dimless, intu2) ),
        ( Quantity(2, lengthDim, intu), 5 * ucat.second, Quantity(2/5, Dimension(T=-1, L=1), intu) )
    ]
    return examples
end

function SimpleQuantityArray_QuantityArray_division_implemented()
    examples = _getExamplesFor_SimpleQuantityArray_QuantityArray_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_SimpleQuantityArray_QuantityArray_division()
    # format: factor1, factor2, correct quotient factor1 / factor2
    examples = [
        ( [1; 2] * Alicorn.unitlessUnit, QuantityArray([1; 1], dimless, intu), QuantityArray([ 0.5 0.5; 1.0 1.0 ], dimless, intu) ),
        ( [1, 1] * Alicorn.unitlessUnit, QuantityArray([2, 2], Dimension(T=1), intu), QuantityArray(0.25 * ones(2,2), Dimension(T=-1), intu) ),
        ( [2] * ucat.second, QuantityArray([1], dimless, intu), QuantityArray([2] / [1], timeDim, intu) ),
        ( [24] * ucat.meter, QuantityArray([2, 2], timeDim, intu2), QuantityArray([3.0 3.0], Dimension(L=1,T=-1), intu2) ),
        ( [5, 2] * ucat.meter, QuantityArray([1], lengthDim, intu2), QuantityArray([5, 2] / [2], dimless, intu2 ) ),
        ( Array{Int32}([-8; 2]) * ucat.meter, QuantityArray{Int32}([2], lengthDim, intu) , QuantityArray{Int32}([-8; 2]/[2]), dimless, intu )
    ]
    return examples
end

function QuantityArray_SimpleQuantityArray_division_implemented()
    examples = _getExamplesFor_QuantityArray_SimpleQuantityArray_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_QuantityArray_SimpleQuantityArray_division()
    # format: factor1, factor2, correct quotient factor1 / factor2
    examples = [
        ( QuantityArray([1; 2], dimless, intu), [1; 1] * Alicorn.unitlessUnit, QuantityArray([ 0.5 0.5; 1.0 1.0 ], dimless, intu) ),
        ( QuantityArray([1, 1], timeDim, intu), [2, 2] * Alicorn.unitlessUnit, QuantityArray(0.25 * ones(2,2), timeDim, intu) ),
        ( QuantityArray([2], dimless, intu), [1] * ucat.second, QuantityArray([2] / [1], Dimension(T=-1), intu) ),
        ( QuantityArray([24], timeDim, intu2), [4, 4] * ucat.meter, QuantityArray([6 6], Dimension(L=-1,T=1), intu2) ),
        ( QuantityArray([5, 2], lengthDim, intu2), [1] * ucat.meter, QuantityArray([5, 2] / [0.5], dimless, intu2 ) ),
        ( QuantityArray{Int32}([-8; 2], lengthDim, intu), Array{Int32}([2]) * ucat.meter, QuantityArray{Int32}([-8; 2]/[2]), dimless, intu )
    ]
    return examples
end

function SimpleQuantityArray_Quantity_division_implemented()
    examples = _getExamplesFor_SimpleQuantityArray_Quantity_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_SimpleQuantityArray_Quantity_division()
    # format: factor1, factor2, correct quotient factor1 / factor2
    examples = [
        ( [1; 2] * Alicorn.unitlessUnit, Quantity(1, dimless, intu ), QuantityArray([1; 2], dimless, intu ) ),
        ( [1, 1] * Alicorn.unitlessUnit, Quantity(2, timeDim, intu), QuantityArray([0.5, 0.5], Dimension(T=-1), intu) ),
        ( [4] * ucat.meter, Quantity(8, Dimension(L=1, T=-1), intu), QuantityArray([0.5], timeDim, intu) ),
        ( [12] * ucat.meter, Quantity(2, timeDim, intu), QuantityArray([6], Dimension(L=1,T=-1), intu) ),
        ( Array{Int32}([10, 2]) * ucat.meter, Quantity{Int32}(2, dimless, intu), QuantityArray{Int32}([5, 1], lengthDim, intu) )
    ]
    return examples
end

function Quantity_SimpleQuantityArray_division_implemented()
    examples = _getExamplesFor_Quantity_SimpleQuantityArray_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_Quantity_SimpleQuantityArray_division()
    # format: factor1, factor2, correct quotient factor1 / factor2
    examples = [
        ( Quantity(1, dimless, intu), [1; 2] * Alicorn.unitlessUnit, QuantityArray(1/[1; 2], dimless, intu) ),
        ( Quantity(2, timeDim, intu), [1, 1] * Alicorn.unitlessUnit, QuantityArray(2/[1,1], timeDim, intu) ),
        ( Quantity(4, dimless, intu), [2] * ucat.second, QuantityArray(4/[2], Dimension(T=-1), intu) ),
        ( Quantity(2, lengthDim, intu2), [12] * ucat.meter, QuantityArray(2/[6], dimless, intu2) ),
        ( Quantity{Int32}(12, lengthDim, intu), Array{Int32}([1, 1]) * ucat.second, QuantityArray{Float64}( [6 6], Dimension(L=1, T=-1), intu ) )
    ]
    return examples
end

function QuantityArray_SimpleQuantity_division_implemented()
    examples = _getExamplesFor_QuantityArray_SimpleQuantity_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_QuantityArray_SimpleQuantity_division()
    # format: factor1, factor2, correct quotient factor1 / factor2
    examples = [
        ( QuantityArray([1; 2], dimless, intu ), 1 * Alicorn.unitlessUnit, QuantityArray([1; 2], dimless, intu ) ),
        ( QuantityArray([1, 1], dimless, intu ), 2 * ucat.second, QuantityArray([0.5, 0.5], Dimension(T=-1), intu) ),
        ( QuantityArray([2], lengthDim, intu2), 8 * ucat.meter / ucat.second, QuantityArray([0.5], timeDim, intu2) ),
        ( QuantityArray([12], lengthDim, intu), 2 * ucat.second, QuantityArray([6], Dimension(L=1,T=-1), intu) ),
        ( QuantityArray{Int32}([10, 2], lengthDim, intu), Int32(2) * Alicorn.unitlessUnit, QuantityArray{Int32}([5, 1], lengthDim, intu) )
    ]
    return examples
end

function SimpleQuantity_QuantityArray_division_implemented()
    examples = _getExamplesFor_SimpleQuantity_QuantityArray_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_SimpleQuantity_QuantityArray_division()
    # format: factor1, factor2, correct quotient factor1 / factor2
    examples = [
        ( 1 * Alicorn.unitlessUnit, QuantityArray([1; 2], dimless, intu), QuantityArray(1/[1; 2], dimless, intu) ),
        ( 2 * ucat.second, QuantityArray([1, 1], dimless, intu), QuantityArray(2/[1,1], timeDim, intu) ),
        ( 4 * Alicorn.unitlessUnit, QuantityArray([2], timeDim, intu2), QuantityArray(4/[2], Dimension(T=-1), intu2) ),
        ( 2 * ucat.meter, QuantityArray([12], lengthDim, intu), QuantityArray(2/[12], dimless, intu) ),
        ( Int32(12) * ucat.meter, QuantityArray{Int32}([1, 1], timeDim, intu2), QuantityArray{Float64}( [3 3], Dimension(L=1, T=-1), intu2 ) )
    ]
    return examples
end


## exponentiation

function SimpleQuantity_exponentiation_implemented()
    examples = _getExamplesFor_SimpleQuantity_exponentiation()
    return TestingTools.testDyadicFunction(Base.:^, examples)
end

function _getExamplesFor_SimpleQuantity_exponentiation()
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

function SimpleQuantityArray_exponentiation_implemented()
    examples = _getExamplesFor_SimpleQuantityArray_exponentiation()
    return TestingTools.testDyadicFunction(Base.:^, examples)
end

function _getExamplesFor_SimpleQuantityArray_exponentiation()
    # format: ::SimpleQuantityArray, exponent, correct result for ::SimpleQuantityArray^exponent
    examples = [
        ( [1 0;0 1] * Alicorn.unitlessUnit, 1, [1 0;0 1] * Alicorn.unitlessUnit ),
        ( [2 0;0 2] * ucat.meter, 0, [1 0;0 1] * Alicorn.unitlessUnit),
        ( [2 0;0 2] * ucat.meter, 2.0, [4 0;0 4] * (ucat.meter^2) ),
        ( [2 0;0 2.0] * ucat.meter, -1, [0.5 0; 0 0.5] / ucat.meter)
    ]
    return examples
end

function Quantity_exponentiation_implemented()
    examples = _getExamplesFor_Quantity_exponentiation()
    return TestingTools.testDyadicFunction(Base.:^, examples)
end

function _getExamplesFor_Quantity_exponentiation()
    # format: Quantity, exponent, correct result for SimpleQuantity^exponent
    examples = [
        ( Quantity(1, dimless, intu), 1, Quantity(1, dimless, intu) ),
        ( Quantity(2, lengthDim, intu), 0, Quantity(1, dimless, intu) ),
        ( Quantity(2, lengthDim, intu2), 1, Quantity(2, lengthDim, intu2) ),
        ( Quantity(2.0, lengthDim, intu), -1, Quantity(0.5, Dimension(L=-1), intu ) ),
        ( Quantity(2.0, lengthDim, intu2), 2, Quantity( 16 * ucat.meter^2, intu2 ) ),
        ( Quantity(2.0, Dimension(L=2), intu2), -2.5, Quantity(2.0^-2.5, Dimension(L=-5), intu2) )
    ]
    return examples
end

function QuantityArray_exponentiation_implemented()
    examples = _getExamplesFor_QuantityArray_exponentiation()
    return TestingTools.testDyadicFunction(Base.:^, examples)
end

function _getExamplesFor_QuantityArray_exponentiation()
    # format: ::QuantityArray, exponent, correct result for ::SimpleQuantityArray^exponent
    examples = [
        ( QuantityArray([1 0;0 1], dimless, intu), 1, QuantityArray([1 0;0 1], dimless, intu) ),
        ( QuantityArray([2 0;0 2], lengthDim, intu), 0, QuantityArray([1 0;0 1], dimless, intu) ),
        ( QuantityArray([2 0;0 2], lengthDim, intu), 2.0, QuantityArray([4 0;0 4], Dimension(L=2), intu) ),
        ( QuantityArray([2 0;0 2.0], lengthDim, intu), -1, QuantityArray([0.5 0; 0 0.5], Dimension(L=-1), intu) )
    ]
    return examples
end


## Inversion

function SimpleQuantity_inv_implemented()
    examples = _getExamplesFor_SimpleQuantity_inv()
    return TestingTools.testMonadicFunction(Base.inv, examples)
end

function _getExamplesFor_SimpleQuantity_inv()
    # format: q::SimpleQuantity, correct result for q^-1
    examples = [
        ( 1 * Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit),
        ( 2 * ucat.meter, 0.5 * ucat.meter^-1),
        ( -5 * (ucat.femto * ucat.meter)^-1 * ucat.joule, -0.2 * (ucat.femto * ucat.meter) * ucat.joule^-1 )
    ]
    return examples
end

function SimpleQuantityArray_inv_implemented()
    examples = _getExamplesFor_SimpleQuantityArray_inv()
    return TestingTools.testMonadicFunction(Base.inv, examples)
end

function _getExamplesFor_SimpleQuantityArray_inv()
    # format: ::SimpleQuantityArray, correct result for inv(::SimpleQuantityArray)
    examples = [
        ( [1 0 ; 0 1] * Alicorn.unitlessUnit, [1 0 ; 0 1]* Alicorn.unitlessUnit),
        ( [2 4; 8 12] * ucat.meter, [-1.5 0.5; 1 -0.25] * ucat.meter^-1)
    ]
    return examples
end

function Quantity_inv_implemented()
    examples = _getExamplesFor_Quantity_inv()
    return TestingTools.testMonadicFunction(Base.inv, examples)
end

function _getExamplesFor_Quantity_inv()
    # format: q::Quantity, correct result for q^-1
    examples = [
        ( Quantity(1, dimless, intu), Quantity(1, dimless, intu) ),
        ( Quantity(2, lengthDim, intu), Quantity(0.5, Dimension(L=-1), intu) ),
        ( Quantity(-2, lengthDim, intu2), Quantity(-0.25 * ucat.meter^-1, intu2) )
    ]
    return examples
end

function QuantityArray_inv_implemented()
    examples = _getExamplesFor_QuantityArray_inv()
    return TestingTools.testMonadicFunction(Base.inv, examples)
end

function _getExamplesFor_QuantityArray_inv()
    # format: ::QuantityArray, correct result for inv(::SimpleQuantityArray)
    examples = [
        ( QuantityArray([1 0 ; 0 1], dimless, intu), QuantityArray([1 0 ; 0 1], dimless, intu) ),
        ( QuantityArray([2 4; 8 12], lengthDim, intu2), QuantityArray([-1.5 0.5; 1 -0.25], Dimension(L=-1), intu2) )
    ]
    return examples
end


#### Numeric comparison

## Equality

function SimpleQuantity_equality_implemented()
    examples = _getExamplesFor_SimpleQuantity_equality()
    return TestingTools.testDyadicFunction(Base.:(==), examples)
end

function _getExamplesFor_SimpleQuantity_equality()
    baseUnit = ucat.ampere

    q1 = SimpleQuantity(7, baseUnit)
    q1Copy = SimpleQuantity(7, baseUnit)

    q2 = SimpleQuantity(0.7, ucat.deca * baseUnit)
    q3 = SimpleQuantity(pi, baseUnit)
    q4 = SimpleQuantity(7, ucat.deca * baseUnit)
    q5 = SimpleQuantity(7, ucat.meter)

    # format: quantity1, quantity2, correct result for quantity1 == quantity2
    examples = [
        ( q1, q1Copy, true ),
        ( q1, q2, false ),
        ( q1, q3, false ),
        ( q1, q4, false ),
        ( q1, q5, false )
    ]
    return examples
end

function SimpleQuantityArray_equality_implemented()
    examples = _getExamplesFor_SimpleQuantityArray_equality()
    return TestingTools.testDyadicFunction(Base.:(==), examples)
end

function _getExamplesFor_SimpleQuantityArray_equality()
    baseUnit = ucat.ampere

    sqArray1 = SimpleQuantityArray([2], baseUnit)
    sqArray1Copy = SimpleQuantityArray([2], baseUnit)

    sqArray2 = SimpleQuantityArray([0.2], ucat.deca * baseUnit)
    sqArray3 = SimpleQuantityArray([7.1 6; 2.0 3], baseUnit)
    sqArray4 = SimpleQuantityArray([7 6; 2.0 3], ucat.deca * baseUnit)
    sqArray5 = SimpleQuantityArray([7 6; 2.0 3], baseUnit)
    sqArray6 = SimpleQuantityArray([7 6; 2.0 3], ucat.meter)

    # format: sqArray1::SimpleQuantityArray, sqArray2::SimpleQuantityArray, correct result for sqArray1 == sqArray2
    examples = [
        ( sqArray1, sqArray1Copy, true ),
        ( sqArray1, sqArray2, false ),
        ( sqArray5, sqArray3, false ),
        ( sqArray5, sqArray4, false ),
        ( sqArray1, sqArray6, false )
    ]
    return examples
end

function Quantity_equality_implemented()
    examples = _getExamplesFor_Quantity_equality()
    return TestingTools.testDyadicFunction(Base.:(==), examples)
end

function _getExamplesFor_Quantity_equality()
    q1 = Quantity(7, lengthDim, intu)
    q1Copy = Quantity(7, lengthDim, intu)

    q2 = Quantity(7, timeDim, intu)
    q3 = Quantity(7, lengthDim, intu2)
    q4 = Quantity(6, lengthDim, intu)

    # format: quantity1, quantity2, correct result for quantity1 == quantity2
    examples = [
        ( q1, q1Copy, true ),
        ( q1, q2, false ),
        ( q1, q3, false ),
        ( q1, q4, false )
    ]
    return examples
end

function QuantityArray_equality_implemented()
    examples = _getExamplesFor_QuantityArray_equality()
    return TestingTools.testDyadicFunction(Base.:(==), examples)
end

function _getExamplesFor_QuantityArray_equality()
    baseUnit = ucat.ampere

    sqArray1 = QuantityArray([2], lengthDim, intu)
    sqArray1Copy = QuantityArray([2], lengthDim, intu)

    sqArray2 = QuantityArray([2], timeDim, intu)
    sqArray3 = QuantityArray([2], lengthDim, intu2)
    sqArray4 = QuantityArray([6], lengthDim, intu)

    # format: sqArray1::QuantityArray, sqArray2::QuantityArray, correct result for sqArray1 == sqArray2
    examples = [
        ( sqArray1, sqArray1Copy, true ),
        ( sqArray1, sqArray2, false ),
        ( sqArray1, sqArray3, false ),
        ( sqArray1, sqArray4, false ),
    ]
    return examples
end


# Less

function SimpleQuantity_isless_implemented()
    examples = _getExamplesFor_SimpleQuantity_isless()
    return TestingTools.testDyadicFunction(Base.isless, examples)
end

function _getExamplesFor_SimpleQuantity_isless()
    value = abs(TestingTools.generateRandomReal())
    baseUnit = TestingTools.generateRandomBaseUnit()

    q1 = SimpleQuantity(value, baseUnit)
    q2 = SimpleQuantity(-value, baseUnit)
    q3 = SimpleQuantity(2*value, baseUnit)

    # format: quantity1, quantity2, correct result for isless(quantity1, quantity2)
    examples = [
        ( q1, q2, false ),
        ( q2, q1, true ),
        ( q1, q3, true )
    ]
    return examples
end

function test_SimpleQuantity_isless_ErrorsForMismatchedUnits()
    (mismatchedSQ1, mismatchedSQ2) = _generateDimensionMismatchedQuantities_forSimpleQuantity()
    expectedError = Alicorn.Exceptions.UnitMismatchError("compared quantities are not of the same physical unit")
    @test_throws expectedError isless(mismatchedSQ1, mismatchedSQ2)
end

function Quantity_isless_implemented()
    examples = _getExamplesFor_Quantity_isless()
    return TestingTools.testDyadicFunction(Base.isless, examples)
end

function _getExamplesFor_Quantity_isless()
    value = abs(TestingTools.generateRandomReal())

    q1 = Quantity(value, lengthDim, intu)
    q2 = Quantity(-value, lengthDim, intu)
    q3 = Quantity(2*value, lengthDim, intu)

    # format: quantity1, quantity2, correct result for isless(quantity1, quantity2)
    examples = [
        ( q1, q2, false ),
        ( q2, q1, true ),
        ( q1, q3, true )
    ]
    return examples
end

function test_Quantity_isless_ErrorsForMismatchedDimensions()
    (mismatchedSQ1, mismatchedSQ2) = _generateDimensionMismatchedQuantities_forQuantity()
    expectedError = Alicorn.Exceptions.DimensionMismatchError("compared quantities are not of the same physical dimension")
    @test_throws expectedError isless(mismatchedSQ1, mismatchedSQ2)
end

# isfinite

function SimpleQuantity_isfinite_implemented()
    examples = _getExamplesFor_SimpleQuantity_isfinite()
    return TestingTools.testMonadicFunction(Base.isfinite, examples)
end

function _getExamplesFor_SimpleQuantity_isfinite()
    unit = TestingTools.generateRandomUnit()

    q1 = SimpleQuantity(Inf, unit)
    q2 = SimpleQuantity(-Inf, unit)
    q3 = SimpleQuantity(NaN, unit)
    q4 = SimpleQuantity(pi, unit)

    # format: quantity1, quantity2, correct result for isless(quantity1, quantity2)
    examples = [
        ( q1, false ),
        ( q2, false ),
        ( q3, false ),
        ( q4, true )
    ]
    return examples
end

function Quantity_isfinite_implemented()
    examples = _getExamplesFor_Quantity_isfinite()
    return TestingTools.testMonadicFunction(Base.isfinite, examples)
end

function _getExamplesFor_Quantity_isfinite()
    unit = TestingTools.generateRandomUnit()

    q1 = Quantity(Inf, lengthDim, intu)
    q2 = Quantity(-Inf, lengthDim, intu)
    q3 = Quantity(NaN, lengthDim, intu)
    q4 = Quantity(pi, lengthDim, intu)

    # format: quantity1, quantity2, correct result for isless(quantity1, quantity2)
    examples = [
        ( q1, false ),
        ( q2, false ),
        ( q3, false ),
        ( q4, true )
    ]
    return examples
end

# isinf

function SimpleQuantity_isinf_implemented()
    examples = _getExamplesFor_SimpleQuantity_isinf()
    return TestingTools.testMonadicFunction(Base.isinf, examples)
end

function _getExamplesFor_SimpleQuantity_isinf()
    unit = TestingTools.generateRandomUnit()

    q1 = SimpleQuantity(Inf, unit)
    q2 = SimpleQuantity(-Inf, unit)
    q3 = SimpleQuantity(NaN, unit)
    q4 = SimpleQuantity(pi, unit)

    # format: quantity1, quantity2, correct result for isless(quantity1, quantity2)
    examples = [
        ( q1, true ),
        ( q2, true ),
        ( q3, false ),
        ( q4, false )
    ]
    return examples
end

function Quantity_isinf_implemented()
    examples = _getExamplesFor_Quantity_isinf()
    return TestingTools.testMonadicFunction(Base.isinf, examples)
end

function _getExamplesFor_Quantity_isinf()
    unit = TestingTools.generateRandomUnit()

    q1 = Quantity(Inf, lengthDim, intu)
    q2 = Quantity(-Inf, lengthDim, intu)
    q3 = Quantity(NaN, lengthDim, intu)
    q4 = Quantity(pi, lengthDim, intu)

    # format: quantity1, quantity2, correct result for isless(quantity1, quantity2)
    examples = [
        ( q1, true ),
        ( q2, true ),
        ( q3, false ),
        ( q4, false )
    ]
    return examples
end

# isnan

function SimpleQuantity_isnan_implemented()
    examples = _getExamplesFor_SimpleQuantity_isnan()
    return TestingTools.testMonadicFunction(Base.isnan, examples)
end

function _getExamplesFor_SimpleQuantity_isnan()
    unit = TestingTools.generateRandomUnit()

    q1 = SimpleQuantity(Inf, unit)
    q2 = SimpleQuantity(NaN, unit)
    q3 = SimpleQuantity(-NaN, unit)
    q4 = SimpleQuantity(pi, unit)

    # format: quantity1, quantity2, correct result for isless(quantity1, quantity2)
    examples = [
        ( q1, false ),
        ( q2, true ),
        ( q3, true ),
        ( q4, false )
    ]
    return examples
end

function Quantity_isnan_implemented()
    examples = _getExamplesFor_Quantity_isnan()
    return TestingTools.testMonadicFunction(Base.isnan, examples)
end

function _getExamplesFor_Quantity_isnan()
    unit = TestingTools.generateRandomUnit()

    q1 = Quantity(Inf, lengthDim, intu)
    q2 = Quantity(NaN, lengthDim, intu)
    q3 = Quantity(-NaN, lengthDim, intu)
    q4 = Quantity(pi, lengthDim, intu)

    # format: quantity1, quantity2, correct result for isless(quantity1, quantity2)
    examples = [
        ( q1, false ),
        ( q2, true ),
        ( q3, true ),
        ( q4, false )
    ]
    return examples
end


# isapprox

function SimpleQuantity_isapprox_implemented()
    examples = _getExamplesFor_SimpleQuantity_isapprox()
    return _test_isapprox_examples(examples)
end

function _getExamplesFor_SimpleQuantity_isapprox()
    examples = [
        ( 7 * ucat.meter, 7.1 * ucat.meter, 0.01, false ),
        ( 7 * ucat.meter, 7.1 * ucat.meter, 0.015, true )
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

function SimpleQuantityArray_isapprox_implemented()
    examples = _getExamplesFor_SimpleQuantityArray_isapprox()
    return _test_isapprox_examples(examples)
end

function _getExamplesFor_SimpleQuantityArray_isapprox()
    examples = [
        ( [7, 2] * ucat.meter, [7.1, 2.1] * ucat.meter, 0.01, false ),
        ( [7, 2] * ucat.meter, [7.1, 2.1] * ucat.meter, 0.02, true )
    ]
    return examples
end

function Quantity_isapprox_implemented()
    examples = _getExamplesFor_Quantity_isapprox()
    return _test_isapprox_examples(examples)
end

function _getExamplesFor_Quantity_isapprox()
    examples = [
        ( Quantity(7, lengthDim, intu), Quantity(7.1, lengthDim, intu), 0.01, false ),
        ( Quantity(7, lengthDim, intu), Quantity(7.1, lengthDim, intu), 0.02, true )
    ]
    return examples
end

function QuantityArray_isapprox_implemented()
    examples = _getExamplesFor_QuantityArray_isapprox()
    return _test_isapprox_examples(examples)
end

function _getExamplesFor_QuantityArray_isapprox()
    examples = [
        ( QuantityArray([7, 2], lengthDim, intu), QuantityArray([7.1, 2.1], lengthDim, intu), 0.01, false ),
        ( QuantityArray([7, 2], lengthDim, intu), QuantityArray([7.1, 2.1], lengthDim, intu), 0.02, true )
    ]
    return examples
end


## Sign and absolute value

# abs
function SimpleQuantity_abs_implemented()
    examples = _getExamplesFor_SimpleQuantity_abs()
    return TestingTools.testMonadicFunction(Base.abs, examples)
end

function _getExamplesFor_SimpleQuantity_abs()
    # format: SimpleQuantity, correct result for abs(SimpleQuantity)
    examples = [
        ( 5.2 * ucat.joule, 5.2 * ucat.joule ),
        ( -7.1 * ucat.ampere, 7.1 * ucat.ampere ),
        ( (4 + 2im) * ucat.meter , sqrt(4^2 + 2^2) * ucat.meter )
    ]
    return examples
end

function Quantity_abs_implemented()
    examples = _getExamplesFor_Quantity_abs()
    return TestingTools.testMonadicFunction(Base.abs, examples)
end

function _getExamplesFor_Quantity_abs()
    # format: Quantity, correct result for abs(SimpleQuantity)
    examples = [
        ( Quantity(5.2, lengthDim, intu), Quantity(5.2, lengthDim, intu)),
        ( Quantity(-7.1, lengthDim, intu2), Quantity(7.1, lengthDim, intu2) ),
        ( Quantity(4 + 2im, lengthDim, intu2), Quantity(sqrt(4^2 + 2^2), lengthDim, intu2) )
    ]
    return examples
end


# abs2
function SimpleQuantity_abs2_implemented()
    examples = _getExamplesFor_SimpleQuantity_abs2()
    return TestingTools.testMonadicFunction(Base.abs2, examples)
end

function _getExamplesFor_SimpleQuantity_abs2()
    # format: SimpleQuantity, correct result for abs2(SimpleQuantity)
    examples = [
        ( 5.2 * ucat.joule, (5.2)^2 * (ucat.joule)^2 ),
        ( -7.1 * ucat.ampere, (7.1)^2 * (ucat.ampere)^2 ),
        ( (4 + 2im) * ucat.meter , (4^2 + 2^2) * (ucat.meter)^2 )
    ]
    return examples
end

function Quantity_abs2_implemented()
    examples = _getExamplesFor_Quantity_abs2()
    return TestingTools.testMonadicFunction(Base.abs2, examples)
end

function _getExamplesFor_Quantity_abs2()
    # format: Quantity, correct result for abs2(SimpleQuantity)
    examples = [
        ( Quantity(5.2, lengthDim, intu), Quantity((5.2)^2, lengthDim^2, intu) ),
        ( Quantity(-7.1, lengthDim, intu2), Quantity((7.1)^2, lengthDim^2, intu2)  ),
        ( Quantity(4 + 2im, lengthDim, intu),  Quantity(4^2 + 2^2, lengthDim^2, intu) )
    ]
    return examples
end


# sign

function SimpleQuantity_sign_implemented()
    examples = _getExamplesFor_SimpleQuantity_sign()
    return TestingTools.testMonadicFunction(Base.sign, examples)
end

function _getExamplesFor_SimpleQuantity_sign()
    # format: SimpleQuantity, correct result for sign(SimpleQuantity)
    examples = [
        ( 5.2 * ucat.joule, 1 ),
        ( -7.1 * ucat.ampere, -1 ),
        ( (4 + 2im) * ucat.meter , sign(4 + 2im) )
    ]
    return examples
end

function Quantity_sign_implemented()
    examples = _getExamplesFor_Quantity_sign()
    return TestingTools.testMonadicFunction(Base.sign, examples)
end

function _getExamplesFor_Quantity_sign()
    # format: Quantity, correct result for sign(SimpleQuantity)
    examples = [
        ( Quantity(5.2, lengthDim, intu), 1 ),
        ( Quantity(-7.1, lengthDim, intu2), -1 ),
        ( Quantity(4 + 2im, lengthDim, intu) , sign(4 + 2im) )
    ]
    return examples
end


# signbit

function SimpleQuantity_signbit_implemented()
    examples = _getExamplesFor_SimpleQuantity_signbit()
    return TestingTools.testMonadicFunction(Base.signbit, examples)
end

function _getExamplesFor_SimpleQuantity_signbit()
    # format: SimpleQuantity, correct result for signbit(SimpleQuantity)
    examples = [
        ( 5.2 * ucat.joule, false ),
        ( -7.1 * ucat.ampere, true )
    ]
    return examples
end

function Quantity_signbit_implemented()
    examples = _getExamplesFor_Quantity_signbit()
    return TestingTools.testMonadicFunction(Base.signbit, examples)
end

function _getExamplesFor_Quantity_signbit()
    # format: Quantity, correct result for signbit(SimpleQuantity)
    examples = [
        ( Quantity(5.2, lengthDim, intu), false ),
        ( Quantity(-7.1, lengthDim, intu2), true )
    ]
    return examples
end


# copysign

function copysign_to_SimpleQuantity_implemented()
    examples = _getExamplesFor_copysign_to_SimpleQuantity_implemented()
    return TestingTools.testDyadicFunction(Base.copysign, examples)
end

function _getExamplesFor_copysign_to_SimpleQuantity_implemented()
    # format: q::SimpleQuantity, object, correct result for copysign(q, object)
    examples = [
        # from SimpleQuantity
        ( -7.1 * ucat.ampere, 5.2 * ucat.joule, 7.1 * ucat.ampere),
        ( -7.1 * ucat.ampere, -5.2 * ucat.joule, -7.1 * ucat.ampere ),
        ( 7.1 * ucat.ampere, 5.2 * ucat.joule, 7.1 * ucat.ampere ),
        ( 7.1 * ucat.ampere, -5.2 * ucat.joule, -7.1 * ucat.ampere ),
        # from Quantity
        ( -7.1 * ucat.ampere, Quantity(5.2, lengthDim, intu), 7.1 * ucat.ampere),
        ( -7.1 * ucat.ampere, Quantity(-5.2, lengthDim, intu), -7.1 * ucat.ampere ),
        ( 7.1 * ucat.ampere, Quantity(5.2, lengthDim, intu), 7.1 * ucat.ampere ),
        ( 7.1 * ucat.ampere, Quantity(-5.2, lengthDim, intu), -7.1 * ucat.ampere ),
        # from Number
        ( 5.2 * ucat.joule, -3.5, -5.2 * ucat.joule ),
        ( 5.2 * ucat.joule, 3.5, 5.2 * ucat.joule )
    ]
    return examples
end

function copysign_to_Quantity_implemented()
    examples = _getExamplesFor_copysign_to_Quantity_implemented()
    return TestingTools.testDyadicFunction(Base.copysign, examples)
end

function _getExamplesFor_copysign_to_Quantity_implemented()
    # format: q::Quantity, object, correct result for copysign(q, object)
    examples = [
        # from SimpleQuantity
        ( Quantity(-7.1, lengthDim, intu), 5.2 * ucat.joule, Quantity(7.1, lengthDim, intu) ),
        ( Quantity(-7.1, lengthDim, intu), -5.2 * ucat.joule, Quantity(-7.1, lengthDim, intu) ),
        ( Quantity(7.1, lengthDim, intu), 5.2 * ucat.joule, Quantity(7.1, lengthDim, intu) ),
        ( Quantity(7.1, lengthDim, intu), -5.2 * ucat.joule, Quantity(-7.1, lengthDim, intu) ),
        # from Quantity
        ( Quantity(-7.1, lengthDim, intu), Quantity(5.2, lengthDim, intu), Quantity(7.1, lengthDim, intu)),
        ( Quantity(-7.1, lengthDim, intu), Quantity(-5.2, lengthDim, intu), Quantity(-7.1, lengthDim, intu) ),
        ( Quantity(7.1, lengthDim, intu), Quantity(5.2, lengthDim, intu), Quantity(7.1, lengthDim, intu) ),
        ( Quantity(7.1, lengthDim, intu), Quantity(-5.2, lengthDim, intu), Quantity(-7.1, lengthDim, intu) ),
        # from Number
        ( Quantity(7.1, lengthDim, intu), -3.5, Quantity(-7.1, lengthDim, intu) ),
        ( Quantity(7.1, lengthDim, intu), 3.5, Quantity(7.1, lengthDim, intu) )
    ]
    return examples
end

function copysign_to_Number_implemented()
    examples = _getExamplesFor_copysign_to_Number_implemented()
    return TestingTools.testDyadicFunction(Base.copysign, examples)
end

function _getExamplesFor_copysign_to_Number_implemented()
    # format: n::Number, object, correct result for copysign(n, object)
    examples = [
        # from SimpleQuantity
        ( 3.5, 5.2 * ucat.joule, 3.5 ),
        ( 3.5, -5.2 * ucat.joule, -3.5 ),
        ( -3.5, 5.2 * ucat.joule, 3.5 ),
        ( -3.5, -5.2 * ucat.joule, -3.5 ),
        # from Quantity
        ( -7.1, Quantity(5.2, lengthDim, intu), 7.1),
        ( -7.1, Quantity(-5.2, lengthDim, intu), -7.1 ),
        ( 7.1, Quantity(5.2, lengthDim, intu), 7.1 ),
        ( 7.1, Quantity(-5.2, lengthDim, intu), -7.1 ),
    ]
    return examples
end


# flipsign

function flipsign_of_SimpleQuantity_implemented()
    examples = _getExamplesFor_flipsign_of_SimpleQuantity_implemented()
    return TestingTools.testDyadicFunction(Base.flipsign, examples)
end

function _getExamplesFor_flipsign_of_SimpleQuantity_implemented()
    # format: q::SimpleQuantity, correct result for flipsign(q, object)
    examples = [
        # from SimpleQuantity
        ( 5.2 * ucat.joule, -5.2 * ucat.joule, -5.2 * ucat.joule ),
        ( -5.2 * ucat.joule, -5.2 * ucat.joule, 5.2 * ucat.joule ),
        ( 5.2 * ucat.joule, 5.2 * ucat.joule, 5.2 * ucat.joule ),
        ( -5.2 * ucat.joule, -5.2 * ucat.joule, 5.2 * ucat.joule ),
        # from Quantity
        ( 5.2 * ucat.joule, Quantity(-5.2, lengthDim, intu), -5.2 * ucat.joule ),
        ( -5.2 * ucat.joule, Quantity(-5.2, lengthDim, intu), 5.2 * ucat.joule ),
        ( 5.2 * ucat.joule, Quantity(5.2, lengthDim, intu), 5.2 * ucat.joule ),
        ( -5.2 * ucat.joule, Quantity(-5.2, lengthDim, intu), 5.2 * ucat.joule ),
        # from Number
        ( 5.2 * ucat.joule, -3.5, -5.2 * ucat.joule ),
        ( -5.2 * ucat.joule, -3.5, 5.2 * ucat.joule ),
        ( 5.2 * ucat.joule, 3.5, 5.2 * ucat.joule ),
        ( -5.2 * ucat.joule, 3.5, -5.2 * ucat.joule )
    ]
    return examples
end

function flipsign_of_Quantity_implemented()
    examples = _getExamplesFor_flipsign_of_Quantity_implemented()
    return TestingTools.testDyadicFunction(Base.flipsign, examples)
end

function _getExamplesFor_flipsign_of_Quantity_implemented()
    # format: Quantity, correct result for flipsign(SimpleQuantity, object)
    examples = [
        # from SimpleQuantity
        ( Quantity(5.2, lengthDim, intu), -5.2 * ucat.joule, Quantity(-5.2, lengthDim, intu) ),
        ( Quantity(-5.2, lengthDim, intu), -5.2 * ucat.joule, Quantity(5.2, lengthDim, intu) ),
        ( Quantity(5.2, lengthDim, intu), 5.2 * ucat.joule, Quantity(5.2, lengthDim, intu) ),
        ( Quantity(-5.2, lengthDim, intu), -5.2 * ucat.joule, Quantity(5.2, lengthDim, intu) ),
        # from Quantity
        ( Quantity(5.2, lengthDim, intu), Quantity(-5.2, lengthDim, intu), Quantity(-5.2, lengthDim, intu) ),
        ( Quantity(-5.2, lengthDim, intu), Quantity(-5.2, lengthDim, intu), Quantity(5.2, lengthDim, intu) ),
        ( Quantity(5.2, lengthDim, intu), Quantity(5.2, lengthDim, intu), Quantity(5.2, lengthDim, intu) ),
        ( Quantity(-5.2, lengthDim, intu), Quantity(-5.2, lengthDim, intu), Quantity(5.2, lengthDim, intu) ),
        # from Number
        ( Quantity(5.2, lengthDim, intu), -3.5, Quantity(-5.2, lengthDim, intu) ),
        ( Quantity(-5.2, lengthDim, intu), -3.5, Quantity(5.2, lengthDim, intu) ),
        ( Quantity(5.2, lengthDim, intu), 3.5, Quantity(5.2, lengthDim, intu) ),
        ( Quantity(-5.2, lengthDim, intu), 3.5, Quantity(-5.2, lengthDim, intu) )
    ]
    return examples
end

function flipsign_of_Number_implemented()
    examples = _getExamplesFor_flipsign_of_Number_implemented()
    return TestingTools.testDyadicFunction(Base.flipsign, examples)
end

function _getExamplesFor_flipsign_of_Number_implemented()
    # format: n::Number, correct result for flipsign(n, object)
    examples = [
        # from SimpleQuantity
        ( 3.5, -5.2 * ucat.joule, -3.5 ),
        ( -3.5, -5.2 * ucat.joule, 3.5 ),
        ( 3.5, 5.2 * ucat.joule, 3.5 ),
        ( 3.5, -5.2 * ucat.joule, -3.5 ),
        # from Quantity
        ( 3.5, Quantity(-5.2, lengthDim, intu), -3.5 ),
        ( -3.5, Quantity(-5.2, lengthDim, intu), 3.5 ),
        ( 3.5, Quantity(5.2, lengthDim, intu), 3.5 ),
        ( 3.5, Quantity(-5.2, lengthDim, intu), -3.5 )
    ]
    return examples
end


## Roots

# sqrt
function SimpleQuantity_sqrt_implemented()
    examples = _getExamplesFor_SimpleQuantity_sqrt()
    return TestingTools.testMonadicFunction(Base.sqrt, examples)
end

function _getExamplesFor_SimpleQuantity_sqrt()
    # format: q::SimpleQuantity, correct result for sqrt(q)
    examples = [
        ( 1 * Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit ),
        ( 4 * (ucat.pico * ucat.meter)^-3, 2 * (ucat.pico * ucat.meter)^-1.5 )
    ]
    return examples
end

function Quantity_sqrt_implemented()
    examples = _getExamplesFor_Quantity_sqrt()
    return TestingTools.testMonadicFunction(Base.sqrt, examples)
end

function _getExamplesFor_Quantity_sqrt()
    # format: q::Quantity, correct result for sqrt(q)
    examples = [
        ( Quantity(1, dimless, intu), Quantity(1, dimless, intu) ),
        ( Quantity(4, lengthDim, intu), Quantity(2, Dimension(L=1/2), intu) )
    ]
    return examples
end


# cbrt
function SimpleQuantity_cbrt_implemented()
    examples = _getExamplesFor_SimpleQuantity_cbrt()
    return TestingTools.testMonadicFunction(Base.cbrt, examples)
end

function _getExamplesFor_SimpleQuantity_cbrt()
    # format: q::SimpleQuantity, correct result for cbrt(q)
    examples = [
        ( 1 * Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit ),
        ( 4 * (ucat.pico * ucat.meter)^-3, cbrt(4) * (ucat.pico * ucat.meter)^-1 )
    ]
    return examples
end

function Quantity_cbrt_implemented()
    examples = _getExamplesFor_Quantity_cbrt()
    return TestingTools.testMonadicFunction(Base.cbrt, examples)
end

function _getExamplesFor_Quantity_cbrt()
    # format: q::Quantity, correct result for cbrt(q)
    examples = [
        ( Quantity(1, dimless, intu), Quantity(1, dimless, intu) ),
        ( Quantity(8, lengthDim, intu), Quantity(2, Dimension(L=1/3), intu) )
    ]
    return examples
end


## Complex numbers

# real
function SimpleQuantity_real_implemented()
    examples = _getExamplesFor_SimpleQuantity_real_implemented()
    return TestingTools.testMonadicFunction(Base.real, examples)
end

function _getExamplesFor_SimpleQuantity_real_implemented()
    # format: q::SimpleQuantity, correct result for real(q)
    examples = [
        ( 1 * Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit ),
        ( 1im * Alicorn.unitlessUnit, 0 * Alicorn.unitlessUnit ),
        ( (4.0 + 2im) * (ucat.pico * ucat.meter)^-3, 4.0 * (ucat.pico * ucat.meter)^-3 )
    ]
    return examples
end

function SimpleQuantityArray_real_implemented()
    examples = _getExamplesFor_SimpleQuantityArray_real_implemented()
    return TestingTools.testMonadicFunction(Base.real, examples)
end

function _getExamplesFor_SimpleQuantityArray_real_implemented()
    # format: q::SimpleQuantityArray, correct result for real(q)
    examples = [
        ( [1] * Alicorn.unitlessUnit, [1] * Alicorn.unitlessUnit ),
        ( [1im] * Alicorn.unitlessUnit, [0] * Alicorn.unitlessUnit ),
        ( [4.0+2im 3+7im; -5-6im 12-6im] * (ucat.pico * ucat.meter)^-3, [4.0 3; -5 12] * (ucat.pico * ucat.meter)^-3 )
    ]
    return examples
end

function Quantity_real_implemented()
    examples = _getExamplesFor_Quantity_real_implemented()
    return TestingTools.testMonadicFunction(Base.real, examples)
end

function _getExamplesFor_Quantity_real_implemented()
    # format: q::Quantity, correct result for real(q)
    examples = [
        ( Quantity(1, dimless, intu), Quantity(1, dimless, intu) ),
        ( Quantity(1im, lengthDim, intu), Quantity(0, lengthDim, intu) ),
        ( Quantity(4.0 + 2im, lengthDim, intu), Quantity(4.0, lengthDim, intu) )
    ]
    return examples
end

function QuantityArray_real_implemented()
    examples = _getExamplesFor_QuantityArray_real_implemented()
    return TestingTools.testMonadicFunction(Base.real, examples)
end

function _getExamplesFor_QuantityArray_real_implemented()
    # format: q::QuantityArray, correct result for real(q)
    examples = [
        ( QuantityArray([1], lengthDim, intu), QuantityArray([1], lengthDim, intu) ),
        ( QuantityArray([1im], lengthDim, intu), QuantityArray([0], lengthDim, intu) ),
        ( QuantityArray([4.0 + 2im], lengthDim, intu), QuantityArray([4.0], lengthDim, intu) )
    ]
    return examples
end


# imag
function SimpleQuantity_imag_implemented()
    examples = _getExamplesFor_SimpleQuantity_imag_implemented()
    return TestingTools.testMonadicFunction(Base.imag, examples)
end

function _getExamplesFor_SimpleQuantity_imag_implemented()
    # format: q::SimpleQuantity, correct result for imag(q)
    examples = [
        ( 1 * Alicorn.unitlessUnit, 0 * Alicorn.unitlessUnit ),
        ( 1im * Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit ),
        ( (4.0 + 2im) * (ucat.pico * ucat.meter)^-3, 2 * (ucat.pico * ucat.meter)^-3 )
    ]
    return examples
end

function SimpleQuantityArray_imag_implemented()
    examples = _getExamplesFor_SimpleQuantityArray_imag_implemented()
    return TestingTools.testMonadicFunction(Base.imag, examples)
end

function _getExamplesFor_SimpleQuantityArray_imag_implemented()
    # format: q::SimpleQuantityArray, correct result for imag(q)
    examples = [
        ( [1] * Alicorn.unitlessUnit, [0] * Alicorn.unitlessUnit ),
        ( [1im] * Alicorn.unitlessUnit, [1] * Alicorn.unitlessUnit ),
        ( [4.0+2im 3+7im; -5-6im 12-6im] * (ucat.pico * ucat.meter)^-3, [2 7; -6 -6] * (ucat.pico * ucat.meter)^-3 )
    ]
    return examples
end

function Quantity_imag_implemented()
    examples = _getExamplesFor_Quantity_imag_implemented()
    return TestingTools.testMonadicFunction(Base.imag, examples)
end

function _getExamplesFor_Quantity_imag_implemented()
    # format: q::Quantity, correct result for imag(q)
    examples = [
        ( Quantity(1, dimless, intu), Quantity(0, dimless, intu) ),
        ( Quantity(1im, lengthDim, intu), Quantity(1, lengthDim, intu) ),
        ( Quantity(4.0 + 2im, lengthDim, intu), Quantity(2, lengthDim, intu) )
    ]
    return examples
end

function QuantityArray_imag_implemented()
    examples = _getExamplesFor_QuantityArray_imag_implemented()
    return TestingTools.testMonadicFunction(Base.imag, examples)
end

function _getExamplesFor_QuantityArray_imag_implemented()
    # format: q::QuantityArray, correct result for imag(q)
    examples = [
        ( QuantityArray([1], lengthDim, intu), QuantityArray([0], lengthDim, intu) ),
        ( QuantityArray([1im], lengthDim, intu), QuantityArray([1], lengthDim, intu) ),
        ( QuantityArray([4.0 + 2im], lengthDim, intu), QuantityArray([2.0], lengthDim, intu) )
    ]
    return examples
end

# angle
function SimpleQuantity_angle_implemented()
    examples = _getExamplesFor_SimpleQuantity_angle()
    return TestingTools.testMonadicFunction(Base.angle, examples)
end

function _getExamplesFor_SimpleQuantity_angle()
    # format: SimpleQuantity, correct result for angle(q)
    examples = [
        ( 1 * Alicorn.unitlessUnit, 0 ),
        ( 1im * Alicorn.unitlessUnit, pi/2 ),
        ( (4.0 + 2im) * (ucat.pico * ucat.meter)^-3, angle(4.0 + 2im) )
    ]
    return examples
end

function Quantity_angle_implemented()
    examples = _getExamplesFor_Quantity_angle()
    return TestingTools.testMonadicFunction(Base.angle, examples)
end

function _getExamplesFor_Quantity_angle()
    # format: q::Quantity, correct result for angle(q)
    examples = [
        ( Quantity(1, dimless, intu), 0 ),
        ( Quantity(1im, lengthDim, intu), pi/2 ),
        ( Quantity(4.0 + 2im, lengthDim, intu), angle(4.0 + 2im) )
    ]
    return examples
end


# conj
function SimpleQuantity_conj_implemented()
    examples = _getExamplesFor_SimpleQuantity_conj()
    return TestingTools.testMonadicFunction(Base.conj, examples)
end

function _getExamplesFor_SimpleQuantity_conj()
    # format: q::SimpleQuantity, correct result for conj(q)
    examples = [
        ( 1 * Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit ),
        ( 1im * Alicorn.unitlessUnit, -1im * Alicorn.unitlessUnit ),
        ( (4.0 + 2im) * (ucat.pico * ucat.meter)^-3, (4.0 - 2im) * (ucat.pico * ucat.meter)^-3 )
    ]
    return examples
end

function Quantity_conj_implemented()
    examples = _getExamplesFor_Quantity_conj()
    return TestingTools.testMonadicFunction(Base.conj, examples)
end

function _getExamplesFor_Quantity_conj()
    # format: q::Quantity, correct result for conj(q)
    examples = [
        ( Quantity(1, dimless, intu), Quantity(1, dimless, intu) ),
        ( Quantity(1im, lengthDim, intu), Quantity(-1im, lengthDim, intu) ),
        ( Quantity(4.0 + 2im, lengthDim, intu), Quantity(4.0 - 2im, lengthDim, intu) )
    ]
    return examples
end

end # module
