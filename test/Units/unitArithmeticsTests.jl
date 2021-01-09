module unitArithmeticsTests

using Alicorn
using Test
using ..TestingTools

function run()
    @testset "unit arithmetics" begin
        @test UnitPrefix_BaseUnit_multiplication_implemented()
        @test inv_implementedForUnitFactor()
        @test UnitFactor_exponenciation_implemented()
        @test inv_implementedForUnit()
        @test Unit_exponenciation_implemented()
        @test Unit_multiplication_implemented()
        @test Unit_division_implemented()
    end
end

function UnitPrefix_BaseUnit_multiplication_implemented()
    prefix = TestingTools.generateRandomUnitPrefix()
    baseUnit = TestingTools.generateRandomBaseUnit()
    returnedUnit = prefix * baseUnit
    correctUnit = Unit(UnitFactor(prefix, baseUnit, 1))
    return returnedUnit == correctUnit
end

function inv_implementedForUnitFactor()
    examples = _getExamplesFor_inv_implementedForUnitFactor()
    return _testExamplesFor_inv_implementedForUnitFactor(examples)
end

function _getExamplesFor_inv_implementedForUnitFactor()
    unitPrefix = TestingTools.generateRandomUnitPrefix()
    baseUnit = TestingTools.generateRandomBaseUnit()
    exponent = TestingTools.generateRandomExponent()
    unitFactor = UnitFactor(unitPrefix, baseUnit, exponent)
    inverseUnitFactor = UnitFactor(unitPrefix, baseUnit, -exponent)
    unitlessUnitFactor = _generateUnitlessUnitFactor()

    examples = [
        (unitlessUnitFactor, unitlessUnitFactor),
        (unitFactor, inverseUnitFactor)
    ]
    return examples
end

function _generateUnitlessUnitFactor()
    return UnitFactor(Alicorn.unitlessBaseUnit)
end

function _testExamplesFor_inv_implementedForUnitFactor(examples::Vector)
    pass = true
    for (unit, correctInverse) in examples
        returnedInverse = inv(unit)
        pass &= (returnedInverse == correctInverse)
    end
    return pass
end

function inv_implementedForUnit()
    examples = _getExamplesFor_inv_implementedForUnit()
    return _testExamplesFor_inv_implementedForUnit(examples)
end

function _getExamplesFor_inv_implementedForUnit()
    unitFactors = TestingTools.generateRandomUnitFactors(2)

    unitFactor1 = unitFactors[1]
    inverseUnitFactor1 = inv(unitFactor1)

    unitFactor2 = unitFactors[2]
    inverseUnitFactor2 = inv(unitFactor2)

    unitlessUnit = _generateUnitlessUnit()

    examples = [
        ( Unit([unitFactor1, unitFactor2]), Unit([inverseUnitFactor1, inverseUnitFactor2]) ),
        (unitlessUnit, unitlessUnit)
    ]
    return examples
end

function _generateUnitlessUnit()
    return Unit(UnitFactor(Alicorn.unitlessBaseUnit))
end

function _testExamplesFor_inv_implementedForUnit(examples::Vector)
    pass  = true
    for (unit, correctInverseUnit) in examples
        returnedInverseUnit = inv(unit)
        pass &= (returnedInverseUnit == correctInverseUnit)
    end
    return pass
end

function UnitFactor_exponenciation_implemented()
    examples = _getExamplesFor_UnitFactor_exponenciation()
    return _testExamplesFor_UnitFactor_exponenciation(examples)
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

function _testExamplesFor_UnitFactor_exponenciation(examples::Vector{Tuple{UnitFactor,T,UnitFactor}}) where T <: Real
    pass = true
    for (unitFactor, exponent, correctResult) in examples
        returnedResult = unitFactor^exponent
        pass &= (returnedResult == correctResult)
    end
    return pass
end

function Unit_exponenciation_implemented()
    examples = _getExamplesFor_Unit_exponenciation()
    return _testExamplesFor_Unit_exponenciation(examples)
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

function _testExamplesFor_Unit_exponenciation(examples::Vector{Tuple{Unit,T,Unit}}) where T <: Real
    pass = true
    for (unit, exponent, correctResult) in examples
        returnedResult = unit^exponent
        pass &= (returnedResult == correctResult)
    end
    return pass
end

function Unit_multiplication_implemented()
    examples = _getExamplesFor_Unit_multiplication()
    return _testExamplesFor_Unit_multiplication(examples)
end

function _getExamplesFor_Unit_multiplication()
    unitFactors = TestingTools.generateRandomUnitFactors(2)

    unitFactor1 = unitFactors[1]
    inverseUnitFactor1 = inv(unitFactor1)

    unitFactor2 = unitFactors[2]
    inverseUnitFactor2 = inv(unitFactor2)

    unitlessUnit = _generateUnitlessUnit()

    examples = [
        (
            Unit(unitFactor1),
            Unit(unitFactor2),
            Unit([ unitFactor1, unitFactor2 ])
        ),
        (
            Unit(unitFactor2),
            Unit(unitFactor1),
            Unit([ unitFactor2, unitFactor1 ])
        ),
        (
            Unit(unitFactor1),
            Unit(unitFactor1),
            Unit(unitFactor1)^2
        ),
        (
            Unit(unitFactor1),
            Unit(inverseUnitFactor1),
            unitlessUnit
        ),
        (
            unitlessUnit,
            unitlessUnit,
            unitlessUnit
        ),
        (
            Unit(unitFactor1),
            unitlessUnit,
            Unit(unitFactor1)
        ),
        (
            unitlessUnit,
            Unit(unitFactor1),
            Unit(unitFactor1)
        )
    ]
    return examples
end

function _testExamplesFor_Unit_multiplication(examples::Vector)
    pass = true
    for (factor1, factor2, correctResult) in examples
        returnedResult = factor1 * factor2
        pass &= (returnedResult == correctResult)
    end
    return pass
end

function Unit_division_implemented()
    examples = _getExamplesFor_Unit_division()
    return _testExamplesFor_Unit_division(examples)
end

function _getExamplesFor_Unit_division()
    unitFactors = TestingTools.generateRandomUnitFactors(2)

    unitFactor1 = unitFactors[1]
    inverseUnitFactor1 = inv(unitFactor1)

    unitFactor2 = unitFactors[2]
    inverseUnitFactor2 = inv(unitFactor2)

    unitlessUnit = _generateUnitlessUnit()

    examples = [
        (
            Unit(unitFactor1),
            Unit(unitFactor2),
            Unit([ unitFactor1, inverseUnitFactor2 ])
        ),
        (
            Unit(unitFactor2),
            Unit(unitFactor1),
            Unit([ unitFactor2, inverseUnitFactor1 ])
        ),
        (
            Unit(unitFactor1),
            Unit(unitFactor1),
            unitlessUnit
        ),
        (
            Unit(unitFactor1),
            Unit(inverseUnitFactor1),
            Unit(unitFactor1)^2
        ),
        (
            unitlessUnit,
            unitlessUnit,
            unitlessUnit
        ),
        (
            Unit(unitFactor1),
            unitlessUnit,
            Unit(unitFactor1)
        ),
        (
            unitlessUnit,
            Unit(unitFactor1),
            Unit(inverseUnitFactor1)
        )
    ]
    return examples
end

function _testExamplesFor_Unit_division(examples::Vector)
    pass = true
    for (dividend, divisor, correctResult) in examples
        returnedResult = dividend / divisor
        pass &= (returnedResult == correctResult)
    end
    return pass
end

end # module
