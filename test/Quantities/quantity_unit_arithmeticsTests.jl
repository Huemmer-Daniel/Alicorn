module quantity_unit_arithmeticsTests

using Alicorn
using Test
using ..TestingTools

const ucat = UnitCatalogue()
const defaultInternalUnits = InternalUnits()
const intu2 = InternalUnits(length=2*ucat.meter)
const dimless = Dimension()
const lengthDim = Dimension(L=1)

function run()
    @testset "quantity_unit_arithmetics" begin

    # SimpleQuanity
    @test SimpleQuantity_AbstractUnit_multiplication()
    @test AbstractUnit_SimpleQuantity_multiplication()
    @test SimpleQuantity_AbstractUnit_division()
    @test AbstractUnit_SimpleQuantity_division()

    # Quantity
    @test_skip Quantity_AbstractUnit_multiplication()

    # SimpleQuantityArray
    @test SimpleQuantityArray_AbstractUnit_multiplication()
    @test AbstractUnit_SimpleQuantityArray_multiplication()
    @test SimpleQuantityArray_AbstractUnit_division()
    @test AbstractUnit_SimpleQuantityArray_division()

    # QuantityArray

    end
end

## SimpleQuanity

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

## Quantity

function Quantity_AbstractUnit_multiplication()
    examples = _getExamplesFor_Quantity_AbstractUnit_multiplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_Quantity_AbstractUnit_multiplication()
    # format: (qIn::Quantity, unit::AbstractUnit, qOut::Quantity)
    # where qOut is the correct result for qIn * unit
    examples = [
        ( Quantity(1, dimless, defaultInternalUnits), Alicorn.unitlessUnit, Quantity(1, dimless, defaultInternalUnits) ),
        ( Quantity(1, Dimension(L=2), defaultInternalUnits), ucat.meter, Quantity(1, lengthDim, defaultInternalUnits) )
    ]
    return examples
end

## SimpleQuantityArray

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

## QuantityArray

end # module
