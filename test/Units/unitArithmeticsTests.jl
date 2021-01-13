module unitArithmeticsTests

using Alicorn
using Test
using ..TestingTools

function run()
    @testset "unit arithmetics" begin

        # exponenciation

        @test inv_implementedForUnitFactor()
        @test UnitFactor_exponenciation_implemented()

        @test inv_implementedForBaseUnit()
        @test BaseUnit_exponenciation_implemented()

        @test inv_implementedForUnit()
        @test Unit_exponenciation_implemented()

        # multiplication and division

        @test UnitPrefix_BaseUnit_multiplication_implemented()

        @test UnitPrefix_UnitFactor_multiplication_implemented()
        test_UnitPrefix_UnitFactor_multiplication_ErrorsOnNonemptyPrefixInUnitFactor()
        test_UnitPrefix_UnitFactor_multiplication_ErrorsOnNontrivialExponentInUnitFactor()

        @test UnitPrefix_Unit_multiplication_implemented()
        test_UnitPrefix_Unit_multiplication_ErrorsForMultipleFactorUnit()
        test_UnitPrefix_Unit_multiplication_ErrorsOnNonemptyPrefixInUnit()
        test_UnitPrefix_Unit_multiplication_ErrorsOnNontrivialExponentInUnit()

        @test BaseUnit_multiplication_implemented()
        @test BaseUnit_division_implemented()

        @test UnitFactor_multiplication_implemented()
        @test UnitFactor_division_implemented()

        @test Unit_multiplication_implemented()
        @test Unit_division_implemented()

        @test BaseUnit_UnitFactor_multiplication_implemented()
        @test BaseUnit_UnitFactor_division_implemented()

        @test BaseUnit_Unit_multiplication_implemented()
        @test BaseUnit_Unit_division_implemented()

        @test UnitFactor_Unit_multiplication_implemented()
        @test UnitFactor_Unit_division_implemented()
    end
end

function inv_implementedForUnitFactor()
    examples = _getExamplesFor_inv_implementedForUnitFactor()
    return TestingTools.testMonadicFunction(inv, examples)
end

function _getExamplesFor_inv_implementedForUnitFactor()
    unitPrefix = TestingTools.generateRandomUnitPrefix()
    baseUnit = TestingTools.generateRandomBaseUnit()
    exponent = TestingTools.generateRandomExponent()
    unitFactor = UnitFactor(unitPrefix, baseUnit, exponent)
    inverseUnitFactor = UnitFactor(unitPrefix, baseUnit, -exponent)
    unitlessUnitFactor = Alicorn.unitlessUnitFactor

    examples = [
        (unitlessUnitFactor, unitlessUnitFactor),
        (unitFactor, inverseUnitFactor)
    ]
    return examples
end

function UnitFactor_exponenciation_implemented()
    examples = _getExamplesFor_UnitFactor_exponenciation()
    return TestingTools.testDyadicFunction(Base.:^, examples)
end

function _getExamplesFor_UnitFactor_exponenciation()
    unitPrefix = TestingTools.generateRandomUnitPrefix()
    baseUnit = TestingTools.generateRandomBaseUnit()

    examples = [
        ( UnitFactor(unitPrefix, baseUnit, 2), 3, UnitFactor(unitPrefix, baseUnit, 6) ),
        ( UnitFactor(unitPrefix, baseUnit, 4.0), 2, UnitFactor(unitPrefix, baseUnit, 8) ),
        ( UnitFactor(unitPrefix, baseUnit, 2), 0.5, UnitFactor(unitPrefix, baseUnit, 1) ),
        ( UnitFactor(unitPrefix, baseUnit, 2.5), 3, UnitFactor(unitPrefix, baseUnit, 7.5) ),
        ( UnitFactor(unitPrefix, baseUnit, 2.5), -3, UnitFactor(unitPrefix, baseUnit, -7.5) )
    ]
    return examples
end

function inv_implementedForBaseUnit()
    examples = _getExamplesFor_inv_implementedForBaseUnit()
    return TestingTools.testMonadicFunction(Base.inv, examples)
end

function _getExamplesFor_inv_implementedForBaseUnit()
    unitlessBaseUnit = Alicorn.unitlessBaseUnit
    unitlessUnitFactor = Alicorn.unitlessUnitFactor

    baseUnit = TestingTools.generateRandomBaseUnit()

    # format: baseUnit, correct result for baseUnit^(-1)
    examples = [
        ( unitlessBaseUnit, unitlessUnitFactor ),
        ( baseUnit, UnitFactor(baseUnit, -1) )
    ]
end

function BaseUnit_exponenciation_implemented()
    examples =  _getExamplesFor_BaseUnit_exponenciation()
    return TestingTools.testDyadicFunction(Base.:^, examples)
end

function _getExamplesFor_BaseUnit_exponenciation()
    unitlessBaseUnit = Alicorn.unitlessBaseUnit
    unitlessUnitFactor = Alicorn.unitlessUnitFactor

    baseUnit = TestingTools.generateRandomBaseUnit()
    exponent = TestingTools.generateRandomExponent()

    # format: baseUnit, exponent, correct result for baseUnit^exponent
    examples = [
        ( unitlessBaseUnit, 1, unitlessUnitFactor ),
        ( baseUnit, exponent, UnitFactor(baseUnit, exponent) )
    ]
end

function inv_implementedForUnit()
    examples = _getExamplesFor_inv_implementedForUnit()
    return TestingTools.testMonadicFunction(inv, examples)
end

function _getExamplesFor_inv_implementedForUnit()
    unitFactors = TestingTools.generateRandomUnitFactors(2)

    unitFactor1 = unitFactors[1]
    inverseUnitFactor1 = inv(unitFactor1)

    unitFactor2 = unitFactors[2]
    inverseUnitFactor2 = inv(unitFactor2)

    unitlessUnit = Alicorn.unitlessUnit

    examples = [
        ( Unit([unitFactor1, unitFactor2]), Unit([inverseUnitFactor1, inverseUnitFactor2]) ),
        (unitlessUnit, unitlessUnit)
    ]
    return examples
end

function Unit_exponenciation_implemented()
    examples = _getExamplesFor_Unit_exponenciation()
    return TestingTools.testDyadicFunction(Base.:^, examples)
end

function _getExamplesFor_Unit_exponenciation()
    unitPrefix1 = TestingTools.generateRandomUnitPrefix()
    baseUnit1 = TestingTools.generateRandomBaseUnit()
    unitPrefix2 = TestingTools.generateRandomUnitPrefix()
    baseUnit2 = TestingTools.generateRandomBaseUnit()

    examples = [
        (
            Unit([ UnitFactor(unitPrefix1, baseUnit1, 2), UnitFactor(unitPrefix1, baseUnit1, 3)]),
            3,
            Unit([ UnitFactor(unitPrefix1, baseUnit1, 6), UnitFactor(unitPrefix1, baseUnit1, 9)]),
        ),
        (
            Unit([ UnitFactor(unitPrefix1, baseUnit1, 1), UnitFactor(unitPrefix1, baseUnit1, 2)]),
            4.0,
            Unit([ UnitFactor(unitPrefix1, baseUnit1, 4), UnitFactor(unitPrefix1, baseUnit1, 8)]),
        ),
        (
            Unit([ UnitFactor(unitPrefix1, baseUnit1, 1.4), UnitFactor(unitPrefix1, baseUnit1, 2.5)]),
            2,
            Unit([ UnitFactor(unitPrefix1, baseUnit1, 2.8), UnitFactor(unitPrefix1, baseUnit1, 5)])
        ),
        (
            Unit([ UnitFactor(unitPrefix1, baseUnit1, 1.4), UnitFactor(unitPrefix1, baseUnit1, 2.5)]),
            -2,
            Unit([ UnitFactor(unitPrefix1, baseUnit1, -2.8), UnitFactor(unitPrefix1, baseUnit1, -5)])
        )
    ]
    return examples
end

function UnitPrefix_BaseUnit_multiplication_implemented()
    prefix = TestingTools.generateRandomUnitPrefix()
    baseUnit = TestingTools.generateRandomBaseUnit()
    returnedUnitFactor = prefix * baseUnit
    correctUnitFactor = UnitFactor(prefix, baseUnit, 1)
    return (returnedUnitFactor == correctUnitFactor)
end

function UnitPrefix_UnitFactor_multiplication_implemented()
    prefix = TestingTools.generateRandomUnitPrefix()
    baseUnit = TestingTools.generateRandomBaseUnit()
    unitFactor = UnitFactor(baseUnit)
    returnedUnitFactor = prefix * unitFactor
    correctUnitFactor = UnitFactor(prefix, baseUnit)
    return (returnedUnitFactor == correctUnitFactor)
end

function test_UnitPrefix_UnitFactor_multiplication_ErrorsOnNonemptyPrefixInUnitFactor()
    prefix1 = TestingTools.generateRandomUnitPrefix()
    prefix2 = TestingTools.generateRandomUnitPrefix()
    baseUnit = TestingTools.generateRandomBaseUnit()
    unitFactor = UnitFactor(prefix2, baseUnit)
    @test_throws Base.ArgumentError("prefix of UnitFactor needs to be emptyUnitPrefix for multiplication of UnitPrefix with UnitFactor") (prefix1 * unitFactor)
end

function test_UnitPrefix_UnitFactor_multiplication_ErrorsOnNontrivialExponentInUnitFactor()
    prefix = TestingTools.generateRandomUnitPrefix()
    baseUnit = TestingTools.generateRandomBaseUnit()
    exponent = pi
    unitFactor = UnitFactor(baseUnit, exponent)
    @test_throws Base.ArgumentError("exponent of UnitFactor needs to be 1 for multiplication of UnitPrefix with UnitFactor") (prefix * unitFactor)
end

function UnitPrefix_Unit_multiplication_implemented()
    prefix = TestingTools.generateRandomUnitPrefix()
    baseUnit = TestingTools.generateRandomBaseUnit()
    unit = Unit(baseUnit)
    returnedUnit = prefix * unit
    correctUnit = Unit(UnitFactor(prefix, baseUnit, 1))
    return (returnedUnit == correctUnit)
end

function test_UnitPrefix_Unit_multiplication_ErrorsForMultipleFactorUnit()
    prefix = TestingTools.generateRandomUnitPrefix()
    unitFactors = TestingTools.generateRandomUnitFactors(2)
    unit = Unit(unitFactors)
    @test_throws Base.ArgumentError("unit needs to have single factor for multiplication of UnitPrefix with Unit") (prefix * unit)
end

function test_UnitPrefix_Unit_multiplication_ErrorsOnNonemptyPrefixInUnit()
    prefix1 = TestingTools.generateRandomUnitPrefix()
    prefix2 = TestingTools.generateRandomUnitPrefix()
    baseUnit = TestingTools.generateRandomBaseUnit()
    unit = Unit(UnitFactor(prefix2, baseUnit))
    @test_throws Base.ArgumentError("prefix of single UnitFactor in Unit needs to be emptyUnitPrefix for multiplication of UnitPrefix with Unit") (prefix1 * unit)
end

function test_UnitPrefix_Unit_multiplication_ErrorsOnNontrivialExponentInUnit()
    prefix = TestingTools.generateRandomUnitPrefix()
    baseUnit = TestingTools.generateRandomBaseUnit()
    exponent = pi
    unit = Unit(UnitFactor(baseUnit, exponent))
    @test_throws Base.ArgumentError("exponent of single UnitFactor in Unit needs to be 1 for multiplication of UnitPrefix with Unit") (prefix * unit)
end

function BaseUnit_multiplication_implemented()
    examples = _getExamplesFor_BaseUnit_multiplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_BaseUnit_multiplication()
    unitlessBaseUnit = Alicorn.unitlessBaseUnit
    unitlessUnit = Alicorn.unitlessUnit

    baseUnit1 = TestingTools.generateRandomBaseUnit()
    baseUnit2 = TestingTools.generateRandomBaseUnit()

    # format: factor1, factor2, correct result for factor1 * factor2
    # where factor1, factor2 are instances of BaseUnit
    examples = [
        ( baseUnit1, baseUnit2, Unit([UnitFactor(baseUnit1), UnitFactor(baseUnit2)]) ),
        ( baseUnit1, unitlessBaseUnit, Unit(baseUnit1) ),
        ( unitlessBaseUnit, baseUnit2, Unit(baseUnit2) ),
        ( unitlessBaseUnit, unitlessBaseUnit, unitlessUnit )
    ]
    return examples
end

function BaseUnit_division_implemented()
    examples = _getExamplesFor_BaseUnit_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_BaseUnit_division()
    unitlessBaseUnit = Alicorn.unitlessBaseUnit
    unitlessUnit = Alicorn.unitlessUnit

    baseUnit1 = TestingTools.generateRandomBaseUnit()
    invBaseUnit1 = inv(baseUnit1)
    baseUnit2 = TestingTools.generateRandomBaseUnit()
    invBaseUnit2 = inv(baseUnit2)

    # format: dividend, divisor, correct result for dividend / divisor
    # where dividend, divisor are instances of BaseUnit
    examples = [
        ( baseUnit1, baseUnit2, Unit([ UnitFactor(baseUnit1), invBaseUnit2 ]) ),
        ( baseUnit1, baseUnit1, unitlessUnit),
        ( baseUnit1, unitlessBaseUnit, Unit(baseUnit1) ),
        ( unitlessBaseUnit, baseUnit2, Unit(invBaseUnit2) ),
        ( unitlessBaseUnit, unitlessBaseUnit, unitlessUnit )
    ]
    return examples
end

function UnitFactor_multiplication_implemented()
    examples = _getExamplesFor_UnitFactor_multiplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_UnitFactor_multiplication()
    unitlessUnitFactor = Alicorn.unitlessUnitFactor
    unitlessUnit = Alicorn.unitlessUnit

    unitFactors = TestingTools.generateRandomUnitFactors(2)
    unitFactor1 = unitFactors[1]
    inverseUnitFactor1 = inv(unitFactor1)
    unitFactor2 = unitFactors[2]

    exmples = [
        (unitFactor1, unitFactor2, Unit([unitFactor1, unitFactor2]) ),
        (unitFactor1, inverseUnitFactor1, unitlessUnit),
        (unitFactor1, unitlessUnitFactor, Unit(unitFactor1) ),
        (unitlessUnitFactor, unitFactor2, Unit(unitFactor2) ),
        (unitlessUnitFactor, unitlessUnitFactor, unitlessUnit)
    ]
    return exmples
end

function UnitFactor_division_implemented()
    examples = _getExamplesFor_UnitFactor_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_UnitFactor_division()
    unitlessUnitFactor = Alicorn.unitlessUnitFactor
    unitlessUnit = Alicorn.unitlessUnit

    unitFactor1 = TestingTools.generateRandomUnitFactor()
    invUnitFactor1 = inv(unitFactor1)
    unitFactor2 = TestingTools.generateRandomUnitFactor()
    invUnitFactor2 = inv(unitFactor2)

    # format: dividend, divisor, correct result for dividend / divisor
    # where dividend, divisor are instances of UnitFactor
    examples = [
        ( unitFactor1, unitFactor2, Unit([ unitFactor1, invUnitFactor2 ]) ),
        ( unitFactor1, unitFactor1, unitlessUnit),
        ( unitFactor1, unitlessUnitFactor, Unit(unitFactor1) ),
        ( unitlessUnitFactor, unitFactor2, Unit(invUnitFactor2) ),
        ( unitlessUnitFactor, unitlessUnitFactor, unitlessUnit )
    ]
    return examples
end

function Unit_multiplication_implemented()
    examples = _getExamplesFor_Unit_multiplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_Unit_multiplication()
    unitlessUnit = Alicorn.unitlessUnit

    unitFactors = TestingTools.generateRandomUnitFactors(2)
    unitFactor1 = unitFactors[1]
    inverseUnitFactor1 = inv(unitFactor1)
    unitFactor2 = unitFactors[2]

    # format: factor1, factor2, correct result for factor1 * factor2
    # where factor1, factor2 are instances of Unit
    examples = [
        ( Unit(unitFactor1), Unit(unitFactor2), Unit([ unitFactor1, unitFactor2 ]) ),
        ( Unit(unitFactor1), Unit(inverseUnitFactor1), unitlessUnit ),
        ( Unit(unitFactor1), unitlessUnit, Unit(unitFactor1) ),
        ( unitlessUnit, Unit(unitFactor1), Unit(unitFactor1) ),
        ( unitlessUnit, unitlessUnit, unitlessUnit ),
    ]
    return examples
end

function Unit_division_implemented()
    examples = _getExamplesFor_Unit_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_Unit_division()
    unitlessUnit = Alicorn.unitlessUnit

    unitFactors = TestingTools.generateRandomUnitFactors(2)
    unitFactor1 = unitFactors[1]
    inverseUnitFactor1 = inv(unitFactor1)
    unitFactor2 = unitFactors[2]
    inverseUnitFactor2 = inv(unitFactor2)

    # format: dividend, divisor, correct result for dividend / divisor
    # where dividend, divisor are instances of Unit
    examples = [
        ( Unit(unitFactor1), Unit(unitFactor2), Unit([ unitFactor1, inverseUnitFactor2 ]) ),
        ( Unit(unitFactor1), Unit(unitFactor1), unitlessUnit ),
        ( Unit(unitFactor1), unitlessUnit, Unit(unitFactor1) ),
        ( unitlessUnit, Unit(unitFactor1), Unit(inverseUnitFactor1) ),
        ( unitlessUnit, unitlessUnit, unitlessUnit )
    ]
    return examples
end

function BaseUnit_UnitFactor_multiplication_implemented()
    examples = _getExamplesFor_BaseUnit_UnitFactor_multiplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_BaseUnit_UnitFactor_multiplication()
    unitlessBaseUnit = Alicorn.unitlessBaseUnit
    unitlessUnitFactor = Alicorn.unitlessUnitFactor
    unitlessUnit = Alicorn.unitlessUnit

    baseUnit = TestingTools.generateRandomBaseUnit()
    inverseBaseUnit = inv(baseUnit)
    unitFactor = TestingTools.generateRandomUnitFactor()
    inverseUnitFactor = inv(unitFactor)

    # format: factor1, factor2, correct result for factor1 * factor2
    # where factor1, factor2 instances of BaseUnit or UnitFactor
    examples = [
        # factor1 is BaseUnit, factor2 is UnitFactor
        ( baseUnit, unitFactor, Unit([ UnitFactor(baseUnit), unitFactor ]) ),
        ( baseUnit, inverseBaseUnit, unitlessUnit ),
        ( baseUnit, unitlessUnitFactor, Unit(baseUnit) ),
        ( unitlessBaseUnit, unitFactor, Unit(unitFactor) ),
        ( unitlessBaseUnit, unitlessUnitFactor, unitlessUnit),

        # factor1 is UnitFactor, factor2 is BaseUnit
        ( unitFactor, baseUnit, Unit([ unitFactor, UnitFactor(baseUnit) ]) ),
        ( inverseBaseUnit, baseUnit, unitlessUnit ),
        ( unitFactor, unitlessBaseUnit, Unit(unitFactor) ),
        ( unitlessUnitFactor, baseUnit, Unit(baseUnit) ),
        ( unitlessUnitFactor, unitlessBaseUnit, unitlessUnit)
    ]
    return examples
end

function BaseUnit_UnitFactor_division_implemented()
    examples = _getExamplesFor_BaseUnit_UnitFactor_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_BaseUnit_UnitFactor_division()
        unitlessBaseUnit = Alicorn.unitlessBaseUnit
        unitlessUnitFactor = Alicorn.unitlessUnitFactor
        unitlessUnit = Alicorn.unitlessUnit

        baseUnit = TestingTools.generateRandomBaseUnit()
        inverseBaseUnit = inv(baseUnit)
        unitFactor = TestingTools.generateRandomUnitFactor()
        inverseUnitFactor = inv(unitFactor)

        # format: dividend, divisor, correct result for dividend / divisor
        # where dividend, divisor are instances of BaseUnit or UnitFactor
        examples = [
            # dividend is BaseUnit, divisor is UnitFactor
            ( baseUnit, unitFactor, Unit([ UnitFactor(baseUnit), inverseUnitFactor ]) ),
            ( baseUnit, UnitFactor(baseUnit), unitlessUnit ),
            ( baseUnit, unitlessUnitFactor, Unit(baseUnit) ),
            ( unitlessBaseUnit, unitFactor, Unit(inverseUnitFactor) ),
            ( unitlessBaseUnit, unitlessUnitFactor, unitlessUnit ),
            # dividend is UnitFactor, divisor is BaseUnit
            ( unitFactor, baseUnit, Unit([ unitFactor, inverseBaseUnit ]) ),
            ( UnitFactor(baseUnit), baseUnit, unitlessUnit),
            ( unitFactor, unitlessBaseUnit, Unit(unitFactor) ),
            ( unitlessUnitFactor, baseUnit, Unit(inverseBaseUnit) ),
            ( unitlessUnitFactor, unitlessBaseUnit, unitlessUnit )
        ]
        return examples
end

function BaseUnit_Unit_multiplication_implemented()
    examples = _getExamplesFor_BaseUnit_Unit_multiplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_BaseUnit_Unit_multiplication()
    unitlessBaseUnit = Alicorn.unitlessBaseUnit
    unitlessUnit = Alicorn.unitlessUnit

    baseUnit = TestingTools.generateRandomBaseUnit()
    inverseBaseUnit = inv(baseUnit)
    unitFactor = TestingTools.generateRandomUnitFactor()
    inverseUnitFactor = inv(unitFactor)

    # format: factor1, factor2, correct result for factor1 * factor2
    # where factor1, factor2 instances of BaseUnit or Unit
    examples = [
        # factor1 is BaseUnit, factor2 is Unit
        ( baseUnit, Unit(unitFactor), Unit([UnitFactor(baseUnit), unitFactor]) ),
        ( baseUnit, Unit(inverseBaseUnit), unitlessUnit ),
        ( baseUnit, unitlessUnit, Unit(baseUnit) ),
        ( unitlessBaseUnit, Unit(unitFactor), Unit(unitFactor) ),
        ( unitlessBaseUnit, unitlessUnit, unitlessUnit ),

        # factor1 is Unit, factor2 is BaseUnit
        ( Unit(unitFactor), baseUnit, Unit([unitFactor, UnitFactor(baseUnit)]) ),
        ( Unit(inverseBaseUnit), baseUnit, unitlessUnit ),
        ( Unit(unitFactor), unitlessBaseUnit, Unit(unitFactor) ),
        ( unitlessUnit, baseUnit, Unit(baseUnit) ),
        ( unitlessUnit, unitlessBaseUnit, unitlessUnit )
    ]
    return examples
end

function BaseUnit_Unit_division_implemented()
    examples = _getExamplesFor_BaseUnit_Unit_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_BaseUnit_Unit_division()
        unitlessBaseUnit = Alicorn.unitlessBaseUnit
        unitlessUnit = Alicorn.unitlessUnit

        baseUnit = TestingTools.generateRandomBaseUnit()
        inverseBaseUnit = inv(baseUnit)
        unitFactor = TestingTools.generateRandomUnitFactor()
        inverseUnitFactor = inv(unitFactor)

        # format: dividend, divisor, correct result for dividend / divisor
        # where dividend, divisor are instances of BaseUnit or Unit
        examples = [
            # dividend is BaseUnit, divisor is Unit
            ( baseUnit, Unit(unitFactor), Unit([ UnitFactor(baseUnit), inverseUnitFactor ]) ),
            ( baseUnit, Unit(baseUnit), unitlessUnit ),
            ( baseUnit, unitlessUnit, Unit(baseUnit) ),
            ( unitlessBaseUnit, Unit(unitFactor), Unit(inverseUnitFactor) ),
            ( unitlessBaseUnit, unitlessUnit, unitlessUnit ),
            # dividend is Unit, divisor is BaseUnit
            ( Unit(unitFactor), baseUnit, Unit([unitFactor, inverseBaseUnit ]) ),
            ( Unit(baseUnit), baseUnit, unitlessUnit ),
            ( Unit(unitFactor), unitlessBaseUnit, Unit(unitFactor) ),
            ( unitlessUnit, baseUnit, Unit(inverseBaseUnit) ),
            ( unitlessUnit, unitlessBaseUnit, unitlessUnit )
        ]
        return examples
end

function UnitFactor_Unit_multiplication_implemented()
    examples = _getExamplesFor_UnitFactor_Unit_multiplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_UnitFactor_Unit_multiplication()
    unitlessUnitFactor = Alicorn.unitlessUnitFactor
    unitlessUnit = Alicorn.unitlessUnit

    unitFactors = TestingTools.generateRandomUnitFactors(2)

    unitFactor1 = unitFactors[1]
    inverseUnitFactor1 = inv(unitFactor1)
    unitFactor2 = unitFactors[2]
    inverseUnitFactor2 = inv(unitFactor2)

    # format: factor1, factor2, correct result for factor1 * factor2
    # where factor1, factor2 instances of UnitFactor or Unit
    examples = [
        # factor1 is UnitFactor, factor2 is Unit
        ( unitFactor1, Unit(unitFactor2), Unit([unitFactor1, unitFactor2]) ),
        ( unitFactor1, Unit(inverseUnitFactor1), unitlessUnit ),
        ( unitFactor1, unitlessUnit, Unit(unitFactor1) ),
        ( unitlessUnitFactor, Unit(unitFactor2), Unit(unitFactor2) ),
        ( unitlessUnitFactor, unitlessUnit, unitlessUnit ),

        # factor1 is UnitFactor, factor2 is Unit
        # ( Unit(unitFactor), baseUnit, Unit([unitFactor, UnitFactor(baseUnit)]) ),
        # ( Unit(inverseBaseUnit), baseUnit, unitlessUnit ),
        # ( Unit(unitFactor), unitlessBaseUnit, Unit(unitFactor) ),
        # ( unitlessUnit, baseUnit, Unit(baseUnit) ),
        # ( unitlessUnit, unitlessBaseUnit, unitlessUnit )
    ]
    return examples
end


function UnitFactor_Unit_division_implemented()
    examples = _getExamplesFor_UnitFactor_Unit_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_UnitFactor_Unit_division()
        unitlessUnitFactor = Alicorn.unitlessUnitFactor
        unitlessUnit = Alicorn.unitlessUnit

        unitFactors = TestingTools.generateRandomUnitFactors(2)
        unitFactor1 = unitFactors[1]
        inverseUnitFactor1 = inv(unitFactor1)
        unitFactor2 = unitFactors[2]
        inverseUnitFactor2 = inv(unitFactor2)

        # format: dividend, divisor, correct result for dividend / divisor
        # where dividend, divisor are instances of UnitFactor or Unit
        examples = [
            # dividend is UnitFactor, divisor is Unit
            ( unitFactor1, Unit(unitFactor2), Unit([ unitFactor1, inverseUnitFactor2 ]) ),
            ( unitFactor1, Unit(unitFactor1), unitlessUnit ),
            ( unitFactor1, unitlessUnit, Unit(unitFactor1) ),
            ( unitlessUnitFactor, Unit(unitFactor2), Unit(inverseUnitFactor2) ),
            ( unitlessUnitFactor, unitlessUnit, unitlessUnit ),
            # dividend is Unit, divisor is UnitFactor
            ( Unit(unitFactor1), unitFactor2, Unit([unitFactor1, inverseUnitFactor2 ]) ),
            ( Unit(unitFactor1), unitFactor1, unitlessUnit ),
            ( Unit(unitFactor1), unitlessUnitFactor, Unit(unitFactor1) ),
            ( unitlessUnit, unitFactor1, Unit(inverseUnitFactor1) ),
            ( unitlessUnit, unitlessUnitFactor, unitlessUnit )
        ]
        return examples
end

end # module
