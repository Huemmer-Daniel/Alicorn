module quantity_unitConversionTests

using Alicorn
using Test
using ..TestingTools

const ucat = UnitCatalogue()
const intu = InternalUnits()

function run()
    @testset "quantity_unitConversion" begin
        # inUnitsOf
        @test inUnitsOf_implemented_forSimpleQuantity()
        test_inUnitsOf_ErrorsForMismatchedUnits_forSimpleQuantity()

        @test inUnitsOf_implemented_forQuantity()
        test_inUnitsOf_ErrorsForMismatchedUnits_forQuantity()

        @test inUnitsOf_implemented_forSimpleQuantityArray()
        test_inUnitsOf_ErrorsForMismatchedUnits_forSimpleQuantityArray()

        @test inUnitsOf_implemented_forQuantityArray()
        test_inUnitsOf_ErrorsForMismatchedUnits_forQuantityArray()

        # valueInUnitsOf
        @test valueInUnitsOf_implemented_forSimpleQuantity()
        test_valueInUnitsOf_ErrorsForMismatchedUnits_forSimpleQuantity()
        @test valueInUnitsOf_implemented_forSimpleQuantity_forSimpleQuantityAsTargetUnit()

        @test valueInUnitsOf_implemented_forQuantity()
        test_valueInUnitsOf_ErrorsForMismatchedUnits_forQuantity()
        @test valueInUnitsOf_implemented_forQuantity_forSimpleQuantityAsTargetUnit()

        @test valueInUnitsOf_implemented_forSimpleQuantityArray()
        test_valueInUnitsOf_ErrorsForMismatchedUnits_forSimpleQuantityArray()
        @test valueInUnitsOf_implemented_forSimpleQuantityArray_forSimpleQuantityAsTargetUnit()

        @test valueInUnitsOf_implemented_forQuantityArray()
        test_valueInUnitsOf_ErrorsForMismatchedUnits_forQuantityArray()
        @test valueInUnitsOf_implemented_forQuantityArray_forSimpleQuantityAsTargetUnit()

        # inBasicSIUnits

        # valueOfDimensionless
    end
end

## inUnitsOf

function inUnitsOf_implemented_forSimpleQuantity()
    examples = _getExamplesFor_inUnitsOf_forSimpleQuantity()
    return TestingTools.testDyadicFunction(inUnitsOf, examples)
end

function _getExamplesFor_inUnitsOf_forSimpleQuantity()
    electronvoltInBasicSI = ucat.electronvolt.prefactor

    # format: SimpleQuantity, Unit, SimpleQuantity expressed in units of Unit
    examples = [
        ( 1 * Alicorn.unitlessUnit, Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit ),
        ( 7 * ucat.meter, ucat.milli*ucat.meter, 7000 * (ucat.milli*ucat.meter) ),
        ( 2 * (ucat.milli * ucat.second)^2, ucat.second^2, 2e-6 * ucat.second^2 ),
        ( 1 * ucat.joule, ucat.electronvolt, (1/electronvoltInBasicSI) * ucat.electronvolt ),
        ( 5 * Alicorn.unitlessUnit, Alicorn.unitlessUnit, 5 * Alicorn.unitlessUnit)
    ]
    return examples
end

function test_inUnitsOf_ErrorsForMismatchedUnits_forSimpleQuantity()
    simpleQuantity = 7 * Alicorn.meter
    mismatchedUnit = Alicorn.second
    expectedError = Alicorn.Exceptions.DimensionMismatchError("dimensions of the quantity and the desired unit do not agree")
    @test_throws expectedError inUnitsOf(simpleQuantity, mismatchedUnit)
end

function inUnitsOf_implemented_forQuantity()
    examples = _getExamplesFor_inUnitsOf_forQuantity()
    return TestingTools.testDyadicFunction(inUnitsOf, examples)
end

function _getExamplesFor_inUnitsOf_forQuantity()
    # format:  Quantity, Unit, SimpleQuantity expressed in units of Unit
    examples = [
        ( Quantity(5, Dimension(), InternalUnits()), Alicorn.unitlessUnit, 5 * Alicorn.unitlessUnit ),
        ( Quantity(700, Dimension(L=1), InternalUnits(length=1*(ucat.centi*ucat.meter))), ucat.milli*ucat.meter, 7000 * (ucat.milli*ucat.meter) ),
        ( Quantity(2, Dimension(T=2), InternalUnits(time=1*(ucat.milli * ucat.second))), ucat.second^2, 2e-6 * ucat.second^2 )
    ]
    return examples
end

function test_inUnitsOf_ErrorsForMismatchedUnits_forQuantity()
    quantity = Quantity(7, Dimension(L=1), InternalUnits(length=1*ucat.meter))
    mismatchedUnit = Alicorn.second
    expectedError = Alicorn.Exceptions.DimensionMismatchError("dimensions of the quantity and the desired unit do not agree")
    @test_throws expectedError inUnitsOf(quantity, mismatchedUnit)
end

function inUnitsOf_implemented_forSimpleQuantityArray()
    examples = _getExamplesFor_inUnitsOf_forSimpleQuantityArray()
    return TestingTools.testDyadicFunction(inUnitsOf, examples)
end

function _getExamplesFor_inUnitsOf_forSimpleQuantityArray()
    electronvoltInBasicSI = ucat.electronvolt.prefactor

    # format: SimpleQuantityArray, Unit, SimpleQuantityArray expressed in units of Unit
    examples = [
        ( ones(2,2) * Alicorn.unitlessUnit, Alicorn.unitlessUnit, ones(2,2) * Alicorn.unitlessUnit ),
        ( [7; 3] * ucat.meter, ucat.milli*ucat.meter, [7000; 3000] * (ucat.milli*ucat.meter) ),
        ( [2] * (ucat.milli * ucat.second)^2, ucat.second^2, [2e-6] * ucat.second^2 ),
        ( ones(2,2) * ucat.joule, ucat.electronvolt, ( (1/electronvoltInBasicSI) * ones(2,2) ) * ucat.electronvolt ),
        ( [5 2] * Alicorn.unitlessUnit, Alicorn.unitlessUnit, [5 2] * Alicorn.unitlessUnit)
    ]
    return examples
end

function test_inUnitsOf_ErrorsForMismatchedUnits_forSimpleQuantityArray()
    sqArray = [7, 2] * Alicorn.meter
    mismatchedUnit = Alicorn.second
    expectedError = Alicorn.Exceptions.DimensionMismatchError("dimensions of the quantity and the desired unit do not agree")
    @test_throws expectedError inUnitsOf(sqArray, mismatchedUnit)
end


function inUnitsOf_implemented_forQuantityArray()
    examples = _getExamplesFor_inUnitsOf_forQuantityArray()
    return TestingTools.testDyadicFunction(inUnitsOf, examples)
end

function _getExamplesFor_inUnitsOf_forQuantityArray()
    # format: QuantityArray, Unit, SimpleQuantityArray expressed in units of Unit
    examples = [
        ( QuantityArray(ones(2,2), Dimension(), InternalUnits()), Alicorn.unitlessUnit, ones(2,2) * Alicorn.unitlessUnit ),
        ( QuantityArray([700], Dimension(L=1), InternalUnits(length=1*(ucat.centi*ucat.meter))), ucat.milli*ucat.meter, [7000] * (ucat.milli*ucat.meter) ),
        ( QuantityArray([2], Dimension(T=2), InternalUnits(time=1*(ucat.milli * ucat.second))), ucat.second^2, [2e-6] * ucat.second^2 )
    ]
    return examples
end

function test_inUnitsOf_ErrorsForMismatchedUnits_forQuantityArray()
    qArray = QuantityArray([7, 2] * Alicorn.meter, intu)
    mismatchedUnit = Alicorn.second
    expectedError = Alicorn.Exceptions.DimensionMismatchError("dimensions of the quantity and the desired unit do not agree")
    @test_throws expectedError inUnitsOf(qArray, mismatchedUnit)
end


## valueInUnitsOf

function valueInUnitsOf_implemented_forSimpleQuantity()
    examples = _getExamplesFor_valueInUnitsOf_forSimpleQuantity()
    return TestingTools.testDyadicFunction(valueInUnitsOf, examples)
end

function _getExamplesFor_valueInUnitsOf_forSimpleQuantity()
    # format: SimpleQuantity, Unit, value of SimpleQuantity expressed in units of Unit
    examples = [
        ( 1 * Alicorn.unitlessUnit, Alicorn.unitlessUnit, 1),
        ( 7 * ucat.meter, ucat.milli*ucat.meter, 7000 ),
        ( 2 * (ucat.milli * ucat.second)^2, ucat.second^2, 2e-6 ),
        ( 5 * Alicorn.unitlessUnit, Alicorn.unitlessUnit, 5 )
    ]
    return examples
end

function test_valueInUnitsOf_ErrorsForMismatchedUnits_forSimpleQuantity()
    simpleQuantity = 7 * Alicorn.meter
    mismatchedUnit = Alicorn.second
    expectedError = Alicorn.Exceptions.DimensionMismatchError("dimensions of the quantity and the desired unit do not agree")
    @test_throws expectedError valueInUnitsOf(simpleQuantity, mismatchedUnit)
end

function valueInUnitsOf_implemented_forSimpleQuantity_forSimpleQuantityAsTargetUnit()
    examples = _getExamplesFor_valueInUnitsOf_forSimpleQuantity_forSimpleQuantityAsTargetUnit()
    return TestingTools.testDyadicFunction(valueInUnitsOf, examples)
end

function _getExamplesFor_valueInUnitsOf_forSimpleQuantity_forSimpleQuantityAsTargetUnit()
    # format: SimpleQuantity1, SimpleQuantity2, SimpleQuantity1 expressed in units of SimpleQuantity2
    examples = [
        ( 1 * Alicorn.unitlessUnit, 3 * Alicorn.unitlessUnit, 1/3  ),
        ( 7 * ucat.meter, 2 * (ucat.milli*ucat.meter), 3500  ),
        ( 2 * (ucat.milli * ucat.second)^2, 2 * ucat.second^2, 1e-6  ),
        ( 6 * Alicorn.unitlessUnit, -3 * Alicorn.unitlessUnit, -2 )
    ]
    return examples
end

function valueInUnitsOf_implemented_forQuantity()
    examples = _getExamplesFor_valueInUnitsOf_forQuantity()
    return TestingTools.testDyadicFunction(valueInUnitsOf, examples)
end

function _getExamplesFor_valueInUnitsOf_forQuantity()
    # format: Quantity, Unit, value of Quantity expressed in units of Unit
    examples = [
        ( Quantity(5, Dimension(), InternalUnits()), Alicorn.unitlessUnit, 5 ),
        ( Quantity(700, Dimension(L=1), InternalUnits(length=1*(ucat.centi*ucat.meter))), ucat.milli*ucat.meter, 7000 ),
        ( Quantity(2, Dimension(T=2), InternalUnits(time=1*(ucat.milli * ucat.second))), ucat.second^2, 2e-6 )
    ]
    return examples
end

function test_valueInUnitsOf_ErrorsForMismatchedUnits_forQuantity()
    quantity = Quantity(7, Dimension(L=1), InternalUnits(length=1*ucat.meter))
    mismatchedUnit = Alicorn.second
    expectedError = Alicorn.Exceptions.DimensionMismatchError("dimensions of the quantity and the desired unit do not agree")
    @test_throws expectedError valueInUnitsOf(quantity, mismatchedUnit)
end

function valueInUnitsOf_implemented_forQuantity_forSimpleQuantityAsTargetUnit()
    examples = _getExamplesFor_valueInUnitsOf_forQuantity_forSimpleQuantityAsTargetUnit()
    return TestingTools.testDyadicFunction(valueInUnitsOf, examples)
end

function _getExamplesFor_valueInUnitsOf_forQuantity_forSimpleQuantityAsTargetUnit()
    # format: Quantity, SimpleQuantity, value of Quantity expressed in units of SimpleQuantity
    examples = [
        ( Quantity(5, Dimension(), InternalUnits()), 3 * Alicorn.unitlessUnit, 5/3 ),
        ( Quantity(700, Dimension(L=1), InternalUnits(length=1*(ucat.centi*ucat.meter))), 2 * (ucat.milli*ucat.meter), 3500 ),
        ( Quantity(2, Dimension(T=2), InternalUnits(time=1*(ucat.milli * ucat.second))), 10 * (ucat.second^2), 2e-7 )
    ]
    return examples
end

function valueInUnitsOf_implemented_forSimpleQuantityArray()
    examples = _getExamplesFor_valueInUnitsOf_forSimpleQuantityArray()
    return TestingTools.testDyadicFunction(valueInUnitsOf, examples)
end

function _getExamplesFor_valueInUnitsOf_forSimpleQuantityArray()
    # format: SimpleQuantityArray, Unit, SimpleQuantityArray expressed in units of Unit
    examples = [
        ( ones(2,2) * Alicorn.unitlessUnit, Alicorn.unitlessUnit, ones(2,2) ),
        ( [7; 3] * ucat.meter, ucat.milli*ucat.meter, [7000; 3000] ),
        ( [2] * (ucat.milli * ucat.second)^2, ucat.second^2, [2e-6] ),
        ( [5 2] * Alicorn.unitlessUnit, Alicorn.unitlessUnit, [5 2] )
    ]
    return examples
end

function test_valueInUnitsOf_ErrorsForMismatchedUnits_forSimpleQuantityArray()
    sqArray = [7, 2] * Alicorn.meter
    mismatchedUnit = Alicorn.second
    expectedError = Alicorn.Exceptions.DimensionMismatchError("dimensions of the quantity and the desired unit do not agree")
    @test_throws expectedError valueInUnitsOf(sqArray, mismatchedUnit)
end

function valueInUnitsOf_implemented_forSimpleQuantityArray_forSimpleQuantityAsTargetUnit()
    examples = _getExamplesFor_valueInUnitsOf_forSimpleQuantityArray_forSimpleQuantityAsTargetUnit()
    return TestingTools.testDyadicFunction(valueInUnitsOf, examples)
end

function _getExamplesFor_valueInUnitsOf_forSimpleQuantityArray_forSimpleQuantityAsTargetUnit()
    # format: SimpleQuantityArray, SimpleQuantity, SimpleQuantityArray expressed in units of SimpleQuantity
    examples = [
        ( [1] * Alicorn.unitlessUnit, 3 * Alicorn.unitlessUnit, [1/3]  ),
        ( [7] * ucat.meter, 2 * (ucat.milli*ucat.meter), [3500.0] ),
        ( [2] * (ucat.milli * ucat.second)^2, 2 * ucat.second^2, [1e-6]  ),
        ( [6; 12] * Alicorn.unitlessUnit, 3 * Alicorn.unitlessUnit, [2.0; 4.0] )
    ]
    return examples
end

function valueInUnitsOf_implemented_forQuantityArray()
    examples = _getExamplesFor_valueInUnitsOf_forQuantityArray()
    return TestingTools.testDyadicFunction(valueInUnitsOf, examples)
end

function _getExamplesFor_valueInUnitsOf_forQuantityArray()
    # format: QuantityArray, Unit, value of QuantityArray expressed in units of Unit
    examples = [
        ( QuantityArray(ones(2,2), Dimension(), InternalUnits()), Alicorn.unitlessUnit, ones(2,2) ),
        ( QuantityArray([700], Dimension(L=1), InternalUnits(length=1*(ucat.centi*ucat.meter))), ucat.milli*ucat.meter, [7000] ),
        ( QuantityArray([2], Dimension(T=2), InternalUnits(time=1*(ucat.milli * ucat.second))), ucat.second^2, [2e-6] )
    ]
    return examples
end

function test_valueInUnitsOf_ErrorsForMismatchedUnits_forQuantityArray()
    qArray = QuantityArray([7, 2] * Alicorn.meter, intu)
    mismatchedUnit = Alicorn.second
    expectedError = Alicorn.Exceptions.DimensionMismatchError("dimensions of the quantity and the desired unit do not agree")
    @test_throws expectedError valueInUnitsOf(qArray, mismatchedUnit)
end

function valueInUnitsOf_implemented_forQuantityArray_forSimpleQuantityAsTargetUnit()
    examples = _getExamplesFor_valueInUnitsOf_forQuantityArray_forSimpleQuantityAsTargetUnit()
    return TestingTools.testDyadicFunction(valueInUnitsOf, examples)
end

function _getExamplesFor_valueInUnitsOf_forQuantityArray_forSimpleQuantityAsTargetUnit()
    # format: QuantityArray, Unit, value of QuantityArray expressed in units of Unit
    examples = [
        ( QuantityArray(ones(2,2), Dimension(), InternalUnits()), 2 * Alicorn.unitlessUnit, ones(2,2) / 2 ),
        ( QuantityArray([700], Dimension(L=1), InternalUnits(length=1*(ucat.centi*ucat.meter))), 2*(ucat.milli*ucat.meter), [3500] ),
        ( QuantityArray([2], Dimension(T=2), InternalUnits(time=1*(ucat.milli * ucat.second))), 10*ucat.second^2, [2e-7] )
    ]
    return examples
end

end # module
