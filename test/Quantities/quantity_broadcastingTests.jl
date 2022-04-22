module quantity_broadcastingTests

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
    @testset "quantity_broadcastingTests" begin
        # TODO uncomment below
        # ## Arithemtic unary and binary operators
        # # Unary plus
        # @test unaryPlus_implemented_forSimpleQuantity()
        # @test unaryPlus_implemented_forSimpleQuantityArray()
        # @test unaryPlus_implemented_forQuantity()
        # @test unaryPlus_implemented_forQuantityArray()
        # # Unary minus
        # @test unaryMinus_implemented_forSimpleQuantity()
        # @test unaryMinus_implemented_forSimpleQuantityArray()
        # @test unaryMinus_implemented_forQuantity()
        # @test unaryMinus_implemented_forQuantityArray()
        #
        # ## Arithmetic binary operators
        # # Addition
        # # SimpleQuantity and SimpleQuantityArray
        # @test SimpleQuantity_SimpleQuantity_addition_implemented()
        # test_addition_ErrorsForMismatchedDimensions_forSimpleQuantity()
        # @test SimpleQuantityArray_SimpleQuantityArray_addition_implemented()
        # test_addition_ErrorsForMismatchedDimensions_forSimpleQuantityArray()
        # # Quantity and QuantityArray
        # @test Quantity_Quantity_addition_implemented()
        # test_addition_ErrorsForMismatchedDimensions_forQuantity()
        # @test QuantityArray_QuantityArray_addition_implemented()
        # test_addition_ErrorsForMismatchedDimensions_forQuantityArray()
        # # mixed
        # @test SimpleQuantity_Quantity_addition_implemented()
        # @test SimpleQuantityArray_QuantityArray_addition_implemented()
        #
        # # Subtraction
        # # SimpleQuantity and SimpleQuantityArray
        # @test SimpleQuantity_SimpleQuantity_subtraction_implemented()
        # test_subtraction_ErrorsForMismatchedDimensions_forSimpleQuantity()
        # @test SimpleQuantityArray_SimpleQuantityArray_subtraction_implemented()
        # test_subtraction_ErrorsForMismatchedDimensions_forSimpleQuantityArray()
        # # Quantity and QuantityArray
        # @test Quantity_Quantity_subtraction_implemented()
        # test_subtraction_ErrorsForMismatchedDimensions_forQuantity()
        # @test QuantityArray_QuantityArray_subtraction_implemented()
        # test_subtraction_ErrorsForMismatchedDimensions_forQuantityArray()
        # # mixed
        # @test SimpleQuantity_Quantity_subtraction_implemented()
        # @test SimpleQuantityArray_QuantityArray_subtraction_implemented()

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
        @test_skip Quantity_SimpleQuantityArray_multiplication_implemented()
        @test QuantityArray_SimpleQuantity_multiplication_implemented()
        @test SimpleQuantity_QuantityArray_multiplication_implemented()
    end
end

#### Arithemtic unary and binary operators

## unary plus
function unaryPlus_implemented_forSimpleQuantity()
    randomSimpleQuantity = TestingTools.generateRandomSimpleQuantity()
    correct = (randomSimpleQuantity == .+randomSimpleQuantity)
    return correct
end

function unaryPlus_implemented_forSimpleQuantityArray()
    randomSimpleQuantityArray = TestingTools.generateRandomSimpleQuantityArray()
    correct = (randomSimpleQuantityArray == .+randomSimpleQuantityArray)
    return correct
end

function unaryPlus_implemented_forQuantity()
    randomQuantity = TestingTools.generateRandomQuantity()
    correct = (randomQuantity == .+randomQuantity)
    return correct
end

function unaryPlus_implemented_forQuantityArray()
    randomQuantityArray = TestingTools.generateRandomQuantityArray()
    correct = (randomQuantityArray == .+randomQuantityArray)
    return correct
end


## unary minus
function unaryMinus_implemented_forSimpleQuantity()
    examples = _getExamplesFor_unaryMinus_forSimpleQuantity()
    return TestingTools.testMonadicFunction(Broadcast.BroadcastFunction(Base.:-), examples)
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
    return TestingTools.testMonadicFunction(Broadcast.BroadcastFunction(Base.:-), examples)
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
    return TestingTools.testMonadicFunction(Broadcast.BroadcastFunction(Base.:-), examples)
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
    return TestingTools.testMonadicFunction(Broadcast.BroadcastFunction(Base.:-), examples)
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
    return TestingTools.testDyadicFunction(Broadcast.BroadcastFunction(Base.:+), examples)
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
    @test_throws expectedError (mismatchedAddend1 .+ mismatchedAddend2)
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
    return TestingTools.testDyadicFunction(Broadcast.BroadcastFunction(Base.:+), examples)
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
    @test_throws expectedError (mismatchedAddend1 .+ mismatchedAddend2)
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
    return TestingTools.testDyadicFunction(Broadcast.BroadcastFunction(Base.:+), examples)
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
    @test_throws expectedError (mismatchedAddend1 .+ mismatchedAddend2)
end

function _generateDimensionMismatchedQuantities_forQuantity()
    mismatchedAddend1 = Quantity{Int32}(7, lengthDim, intu)
    mismatchedAddend2 = Quantity{Int32}(7, timeDim, intu)
    return (mismatchedAddend1, mismatchedAddend2)
end

function QuantityArray_QuantityArray_addition_implemented()
    examples = _getExamplesFor_addition_forQuantityArray()
    return TestingTools.testDyadicFunction(Broadcast.BroadcastFunction(Base.:+), examples)
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
    @test_throws expectedError (mismatchedAddend1 .+ mismatchedAddend2)
end

function _generateDimensionMismatchedQuantities_forQuantityArray()
    mismatchedAddend1 = QuantityArray{Int32}([7], lengthDim, intu)
    mismatchedAddend2 = QuantityArray{Int32}([7], timeDim, intu)
    return (mismatchedAddend1, mismatchedAddend2)
end

# addition: mixed
function SimpleQuantity_Quantity_addition_implemented()
    examples = _getExamplesFor_SimpleQuantity_Quantity_addition()
    return TestingTools.testDyadicFunction(Broadcast.BroadcastFunction(Base.:+), examples)
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
    return TestingTools.testDyadicFunction(Broadcast.BroadcastFunction(Base.:+), examples)
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
    return TestingTools.testDyadicFunction(Broadcast.BroadcastFunction(Base.:-), examples)
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
    @test_throws expectedError (mismatchedAddend1 .- mismatchedAddend2)
end

function SimpleQuantityArray_SimpleQuantityArray_subtraction_implemented()
    examples = _getExamplesFor_subtraction_forSimpleQuantityArray()
    return TestingTools.testDyadicFunction(Broadcast.BroadcastFunction(Base.:-), examples)
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
    @test_throws expectedError (mismatchedAddend1 .- mismatchedAddend2)
end

# subtraction: Quantity and QuantityArray
function Quantity_Quantity_subtraction_implemented()
    examples = _getExamplesFor_subtraction_forQuantity()
    return TestingTools.testDyadicFunction(Broadcast.BroadcastFunction(Base.:-), examples)
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
    @test_throws expectedError (mismatchedAddend1 .- mismatchedAddend2)
end

function QuantityArray_QuantityArray_subtraction_implemented()
    examples = _getExamplesFor_subtraction_forQuantityArray()
    return TestingTools.testDyadicFunction(Broadcast.BroadcastFunction(Base.:-), examples)
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
    @test_throws expectedError (mismatchedAddend1 .- mismatchedAddend2)
end

# subtraction: mixed
function SimpleQuantity_Quantity_subtraction_implemented()
    examples = _getExamplesFor_SimpleQuantity_Quantity_subtraction()
    return TestingTools.testDyadicFunction(Broadcast.BroadcastFunction(Base.:-), examples)
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
    return TestingTools.testDyadicFunction(Broadcast.BroadcastFunction(Base.:-), examples)
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
    return TestingTools.testDyadicFunction(Broadcast.BroadcastFunction(Base.:*), examples)
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
    return TestingTools.testDyadicFunction(Broadcast.BroadcastFunction(Base.:*), examples)
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
    return TestingTools.testDyadicFunction(Broadcast.BroadcastFunction(Base.:*), examples)
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
    return TestingTools.testDyadicFunction(Broadcast.BroadcastFunction(Base.:*), examples)
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
    return TestingTools.testDyadicFunction(Broadcast.BroadcastFunction(Base.:*), examples)
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
    return TestingTools.testDyadicFunction(Broadcast.BroadcastFunction(Base.:*), examples)
end

function _getExamplesFor_SimpleQuantityArray_SimpleQuantityArray_multiplication()
    # format: factor1, factor2, correct product factor1 * factor2
    examples = [
        ( ones(2,2) * Alicorn.unitlessUnit, ones(2,2)  * Alicorn.unitlessUnit, ones(2,2) * Alicorn.unitlessUnit ),
        ( [1 1] * Alicorn.unitlessUnit, [2, 2] * ucat.second, 2 * ones(2,2) * ucat.second ),
        ( [2, 2] * ucat.second, [1 1] * Alicorn.unitlessUnit, ( 2 * ones(2,2) ) * ucat.second ),
        ( [2.5 3.5] * ucat.meter,  [2 2] * ucat.second, [5 7.0] * ucat.meter * ucat.second ),
        ( [2] * ucat.second, [2.5 2.5]* ucat.meter, [5.0 5.0] * ucat.second * ucat.meter ),
        ( [-7 1] * ucat.lumen * (ucat.nano * ucat.second),  [2.5 2.5] * (ucat.pico * ucat.second) , [-17.5 2.5] * ucat.lumen * (ucat.nano * ucat.second) * (ucat.pico * ucat.second) ),
        ( [2 2] * (ucat.milli * ucat.candela)^-4, [4; 4] * (ucat.milli * ucat.candela)^2, 8 * ones(2,2) * (ucat.milli * ucat.candela)^-2 )
    ]
    return examples
end

function SimpleQuantityArray_Array_multiplication_implemented()
    examples = _getExamplesFor_SimpleQuantityArray_Array_multiplication()
    return TestingTools.testDyadicFunction(Broadcast.BroadcastFunction(Base.:*), examples)
end

function _getExamplesFor_SimpleQuantityArray_Array_multiplication()
    # format: factor1, factor2, correct product factor1 * factor2
    examples = [
        ( ones(2,2) * Alicorn.unitlessUnit, ones(2,2), ones(2,2) * Alicorn.unitlessUnit ),
        ( [1 1] * ucat.second, [2, 2], 2 * ones(2,2) * ucat.second ),
        ( [2, 2] * ucat.meter, [1 1], 2 * ones(2,2) * ucat.meter ),
        ( [2.5 3.5] * ucat.meter,  [2 2], [5 7] * ucat.meter ),
        ( [2] * ucat.second, [2.5 2.5], [5.0 5.0] * ucat.second ),
        ( [-7 1] * ucat.lumen * (ucat.nano * ucat.second),  [2.5 2.5] , [-17.5 2.5] * ucat.lumen * (ucat.nano * ucat.second) ),
        ( [2 2] * (ucat.milli * ucat.candela)^-4, [4; 4], 8 * ones(2,2) * (ucat.milli * ucat.candela)^-4 )
    ]
    return examples
end

function Array_SimpleQuantityArray_multiplication_implemented()
    examples = _getExamplesFor_Array_SimpleQuantityArray_multiplication()
    return TestingTools.testDyadicFunction(Broadcast.BroadcastFunction(Base.:*), examples)
end

function _getExamplesFor_Array_SimpleQuantityArray_multiplication()
    # format: factor1, factor2, correct product factor1 * factor2
    examples = [
        (  ones(2,2), ones(2,2) * Alicorn.unitlessUnit, ones(2,2) * Alicorn.unitlessUnit ),
        ( [1 1] , [2, 2] * ucat.second, 2 * ones(2,2) * ucat.second ),
        ( [2, 2] , [1 1] * ucat.meter, 2 * ones(2,2) * ucat.meter ),
        ( [2.5 3.5],  [2 2] * ucat.meter, [5 7] * ucat.meter ),
        ( [2], [2.5 2.5] * ucat.second, [5.0 5.0] * ucat.second ),
        ( [-7 1],  [2.5 2.5] * ucat.lumen * (ucat.nano * ucat.second), [-17.5 2.5] * ucat.lumen * (ucat.nano * ucat.second) ),
        ( [2 2] , [4; 4] * (ucat.milli * ucat.candela)^-4, 8 * ones(2,2) * (ucat.milli * ucat.candela)^-4 )
    ]
    return examples
end

function SimpleQuantityArray_SimpleQuantity_multiplication_implemented()
    examples = _getExamplesFor_SimpleQuantityArray_SimpleQuantity_multiplication()
    return TestingTools.testDyadicFunction(Broadcast.BroadcastFunction(Base.:*), examples)
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
    return TestingTools.testDyadicFunction(Broadcast.BroadcastFunction(Base.:*), examples)
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
    return TestingTools.testDyadicFunction(Broadcast.BroadcastFunction(Base.:*), examples)
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
    return TestingTools.testDyadicFunction(Broadcast.BroadcastFunction(Base.:*), examples)
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
    return TestingTools.testDyadicFunction(Broadcast.BroadcastFunction(Base.:*), examples)
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
    return TestingTools.testDyadicFunction(Broadcast.BroadcastFunction(Base.:*), examples)
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
    return TestingTools.testDyadicFunction(Broadcast.BroadcastFunction(Base.:*), examples)
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
    return TestingTools.testDyadicFunction(Broadcast.BroadcastFunction(Base.:*), examples)
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
    return TestingTools.testDyadicFunction(Broadcast.BroadcastFunction(Base.:*), examples)
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
    return TestingTools.testDyadicFunction(Broadcast.BroadcastFunction(Base.:*), examples)
end

function _getExamplesFor_QuantityArray_QuantityArray_multiplication()
    # format: factor1, factor2, correct product factor1 * factor2
    examples = [
        ( QuantityArray(ones(2,2), dimless, intu), QuantityArray(ones(2,2), dimless, intu), QuantityArray(ones(2,2), dimless, intu) ),
        ( QuantityArray([1 1], lengthDim, intu), QuantityArray([2, 2], lengthDim, intu), QuantityArray( 2 * ones(2,2), Dimension(L=2), intu) ),
        ( QuantityArray([2, 2], lengthDim, intu2), QuantityArray([1 1], lengthDim, intu2), QuantityArray( 2 * ones(2,2), Dimension(L=2), intu2 ) ),
        ( QuantityArray{Int32}([2 2], lengthDim, intu2), QuantityArray{Int32}([2 2], lengthDim, intu), QuantityArray{Int32}( [2 2], Dimension(L=2), intu2 ) ),
        ( QuantityArray{Int32}([2, 2], lengthDim, intu), QuantityArray{Int32}([2 2], lengthDim, intu2), QuantityArray{Int32}( 8 * ones(2,2), Dimension(L=2), intu ) ),
    ]
    return examples
end

function QuantityArray_Array_multiplication_implemented()
    examples = _getExamplesFor_QuantityArray_Array_multiplication()
    return TestingTools.testDyadicFunction(Broadcast.BroadcastFunction(Base.:*), examples)
end

function _getExamplesFor_QuantityArray_Array_multiplication()
    # format: factor1, factor2, correct product factor1 * factor2
    examples = [
        ( QuantityArray(ones(2,2), dimless, intu), ones(2,2), QuantityArray(ones(2,2), dimless, intu) ),
        ( QuantityArray([1 1], lengthDim, intu), [2, 2], QuantityArray( 2 * ones(2,2), lengthDim, intu) ),
        ( QuantityArray([2, 2], lengthDim, intu2), [1 1], QuantityArray( 2 * ones(2,2), lengthDim, intu2 ) ),
        ( QuantityArray{Int32}([2, 2], lengthDim, intu2), Array{Int32}([2 2]), QuantityArray{Int32}( 4 * ones(2,2), lengthDim, intu2 ) ),
        ( QuantityArray{Int32}([2, 2], lengthDim, intu), [2 2], QuantityArray{Int64}( 4 * ones(2,2), lengthDim, intu ) )
    ]
    return examples
end

function Array_QuantityArray_multiplication_implemented()
    examples = _getExamplesFor_Array_QuantityArray_multiplication()
    return TestingTools.testDyadicFunction(Broadcast.BroadcastFunction(Base.:*), examples)
end

function _getExamplesFor_Array_QuantityArray_multiplication()
    # format: factor1, factor2, correct product factor1 * factor2
    examples = [
        ( ones(2,2), QuantityArray(ones(2,2), dimless, intu), QuantityArray(ones(2,2), dimless, intu) ),
        ( [1 1], QuantityArray([2, 2], lengthDim, intu), QuantityArray(2 * ones(2,2), lengthDim, intu) ),
        ( [2, 2], QuantityArray([1 1], lengthDim, intu2), QuantityArray( 2 * ones(2,2), lengthDim, intu2 ) ),
        ( Array{Int32}([2, 2]), QuantityArray{Int32}([2 2], lengthDim, intu2), QuantityArray{Int32}( 4 * ones(2,2), lengthDim, intu2 ) ),
        ( [2, 2], QuantityArray{Int32}([2 2], lengthDim, intu), QuantityArray{Int64}( 4 * ones(2,2), lengthDim, intu ) )
    ]
    return examples
end

function QuantityArray_Quantity_multiplication_implemented()
    examples = _getExamplesFor_QuantityArray_Quantity_multiplication_implemented()
    return TestingTools.testDyadicFunction(Broadcast.BroadcastFunction(Base.:*), examples)
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
    return TestingTools.testDyadicFunction(Broadcast.BroadcastFunction(Base.:*), examples)
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
    return TestingTools.testDyadicFunction(Broadcast.BroadcastFunction(Base.:*), examples)
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
    return TestingTools.testDyadicFunction(Broadcast.BroadcastFunction(Base.:*), examples)
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
    return TestingTools.testDyadicFunction(Broadcast.BroadcastFunction(Base.:*), examples)
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
    return TestingTools.testDyadicFunction(Broadcast.BroadcastFunction(Base.:*), examples)
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
    return TestingTools.testDyadicFunction(Broadcast.BroadcastFunction(Base.:*), examples)
end

function _getExamplesFor_SimpleQuantityArray_QuantityArray_multiplication()
    # format: factor1, factor2, correct product factor1 * factor2
    examples = [
        ( SimpleQuantityArray(ones(2,2), Alicorn.unitlessUnit), QuantityArray(ones(2,2), dimless, intu), QuantityArray(ones(2,2), dimless, intu) ),
        ( SimpleQuantityArray([1 1], ucat.meter), QuantityArray([2, 2], lengthDim, intu), QuantityArray(2*ones(2,2), Dimension(L=2), intu) ),
        ( SimpleQuantityArray([2, 2], ucat.meter), QuantityArray([1 1], lengthDim, intu2), QuantityArray(ones(2,2), Dimension(L=2), intu2 ) ),
        ( SimpleQuantityArray{Int32}([2, 2], ucat.meter), QuantityArray{Int32}([2 2], lengthDim, intu), QuantityArray{Int32}( 4 * ones(2,2), Dimension(L=2), intu ) ),
        ( SimpleQuantityArray{Int32}(2 * [2, 2], ucat.meter), QuantityArray{Int32}([2 2], lengthDim, intu2), QuantityArray{Int32}( 4 * ones(2,2), Dimension(L=2), intu2 ) ),
    ]
    return examples
end

function QuantityArray_SimpleQuantityArray_multiplication_implemented()
    examples = _getExamplesFor_QuantityArray_SimpleQuantityArray_multiplication()
    return TestingTools.testDyadicFunction(Broadcast.BroadcastFunction(Base.:*), examples)
end

function _getExamplesFor_QuantityArray_SimpleQuantityArray_multiplication()
    # format: factor1, factor2, correct product factor1 * factor2
    examples = [
        ( QuantityArray(ones(2,2), dimless, intu), SimpleQuantityArray(ones(2,2), Alicorn.unitlessUnit), QuantityArray(ones(2,2), dimless, intu) ),
        ( QuantityArray([1 1], lengthDim, intu), SimpleQuantityArray([2, 2], ucat.meter), QuantityArray(2*ones(2,2), Dimension(L=2), intu) ),
        ( QuantityArray([1, 1], lengthDim, intu2), SimpleQuantityArray([2 2], ucat.meter), QuantityArray(ones(2,2), Dimension(L=2), intu2 ) ),
        ( QuantityArray{Int32}([2, 2], lengthDim, intu), SimpleQuantityArray{Int32}([2 2], ucat.meter), QuantityArray{Int32}( 4 * ones(2,2), Dimension(L=2), intu ) ),
        ( QuantityArray{Int32}([2, 2], lengthDim, intu2), SimpleQuantityArray{Int32}(2 * [2 2], ucat.meter), QuantityArray{Int32}( 4 * ones(2,2), Dimension(L=2), intu2 ) ),
    ]
    return examples
end

function SimpleQuantityArray_Quantity_multiplication_implemented()
    examples = _getExamplesFor_SimpleQuantityArray_Quantity_multiplication()
    return TestingTools.testDyadicFunction(Broadcast.BroadcastFunction(Base.:*), examples)
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
    return TestingTools.testDyadicFunction(Broadcast.BroadcastFunction(Base.:*), examples)
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
    return TestingTools.testDyadicFunction(Broadcast.BroadcastFunction(Base.:*), examples)
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
    return TestingTools.testDyadicFunction(Broadcast.BroadcastFunction(Base.:*), examples)
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

end # module
