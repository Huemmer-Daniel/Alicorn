module UnitTests

using Alicorn
using Test
using ..TestingTools

function run()
    @testset "Unit" begin
        @test canInstanciateUnit()
        @test Unit_fieldsCorrectlyInitialized()
        @test Unit_mergesDuplicateUnitFactors()
        @test Unit_removesUnitlessFactor()

        @test equality_implemented()

        @test canInstanciateUnitWithSingleUnitFactor()
        @test canInstanciateUnitWithSingleBaseUnit()
        @test Unit_actsAsIdentityOnUnit()

        @test unitlessUnitIsDefined()
        @test canInstanciateUnitlessUnitWithoutArguments()

        @test Unit_actsAsScalarInBroadcast()

        @test inv_implemented()
        @test exponentiation_implemented()
        @test sqrt_implemented()

        @test multiplication_implemented()
        @test division_implemented()

        @test BaseUnit_Unit_multiplication_implemented()
        @test BaseUnit_Unit_division_implemented()

        @test UnitFactor_Unit_multiplication_implemented()
        @test UnitFactor_Unit_division_implemented()

        @test UnitPrefix_Unit_multiplication_implemented()
        test_UnitPrefix_Unit_multiplication_ErrorsForMultipleFactorUnit()
        test_UnitPrefix_Unit_multiplication_ErrorsOnNonemptyPrefixInUnit()
        test_UnitPrefix_Unit_multiplication_ErrorsOnNontrivialExponentInUnit()

        @test convertToBasicSI_implemented()
    end
end

function canInstanciateUnit()
    pass = false
    try
        unitFactor = TestingTools.generateRandomUnitFactor()
        Unit([unitFactor])
        pass = true
    catch
    end
    return pass
end

function Unit_fieldsCorrectlyInitialized()
    (randomUnit, randomUnitFactors) = TestingTools.generateRandomUnitWithFields()
    return _verifyHasCorrectFields(randomUnit, randomUnitFactors)
end

function Unit_mergesDuplicateUnitFactors()
    examples = _getExamplesFor_Unit_mergesDuplicateUnitFactors()
    return _testExamplesFor_Unit_mergesDuplicateUnitFactors(examples)
end

function _getExamplesFor_Unit_mergesDuplicateUnitFactors()
    (unitPrefix1, unitPrefix2) = _generateTwoDifferentRandomUnitPrefixes()
    (baseUnit1, baseUnit2) = _generateTwoDifferentRandomBaseUnits()

    unitFactor1_power1 = UnitFactor(unitPrefix1, baseUnit1, 1)
    unitFactor1_power3 = UnitFactor(unitPrefix1, baseUnit1, 3)
    unitFactor1_powerMinus3 = UnitFactor(unitPrefix1, baseUnit1, -3)
    unitFactor1_power4 = UnitFactor(unitPrefix1, baseUnit1, 4)
    unitFactor2_power2_5 = UnitFactor(unitPrefix2, baseUnit2, 2.5)
    unitFactor2_powerMinus2_5 = UnitFactor(unitPrefix2, baseUnit2, -2.5)
    unitFactor2_power3_5 = UnitFactor(unitPrefix2, baseUnit2, 3.5)
    unitFactor2_power6 = UnitFactor(unitPrefix2, baseUnit2, 6)
    unitFactor3 = UnitFactor(unitPrefix1, baseUnit2, 2)
    unitlessFactor = _generateUnitlessUnitFactor()

    examples = [
        ( [ unitFactor1_power3, unitFactor1_powerMinus3 ], [ unitlessFactor ] ),
        ( [ unitFactor1_power1, unitFactor1_power3 ], [unitFactor1_power4] ),
        ( [ unitFactor1_power1, unitlessFactor, unitFactor1_power3 ], [unitFactor1_power4] ),
        ( [ unitFactor1_power1, unitFactor2_power2_5, unitFactor1_power3 ], [ unitFactor1_power4, unitFactor2_power2_5 ] ),
        ( [ unitFactor1_power3, unitFactor2_power2_5, unitFactor1_powerMinus3, unitFactor2_powerMinus2_5 ], [ unitlessFactor ] ),
        ( [ unitFactor1_power1, unitFactor2_power2_5, unitFactor1_power3, unitFactor2_power3_5 ], [ unitFactor1_power4, unitFactor2_power6 ] ),
        ( [ unitFactor3, unitFactor1_power1, unitFactor2_power2_5, unitFactor1_power3, unitFactor2_power3_5 ], [ unitFactor3, unitFactor1_power4, unitFactor2_power6 ] ),
    ]
    return examples
end

function _generateTwoDifferentRandomUnitPrefixes()
    unitPrefix1 = TestingTools.generateRandomUnitPrefix()
    unitPrefix2 = unitPrefix1
    while unitPrefix2 == unitPrefix1
        unitPrefix2 = TestingTools.generateRandomUnitPrefix()
    end
    return (unitPrefix1, unitPrefix2)
end

function  _generateTwoDifferentRandomBaseUnits()
    baseUnit1 = TestingTools.generateRandomBaseUnit()
    baseUnit2 = baseUnit1
    while baseUnit2 == baseUnit1
        baseUnit2 = TestingTools.generateRandomBaseUnit()
    end
    return (baseUnit1, baseUnit2)
end

function _generateUnitlessUnitFactor()
    return UnitFactor(Alicorn.unitlessBaseUnit)
end

function _testExamplesFor_Unit_mergesDuplicateUnitFactors(examples::Vector)
    pass = true
    for (passedUnitFactors, correctUnitFactors) in examples
        unit = Unit(passedUnitFactors)
        returnedUnitFactors = unit.unitFactors
        pass &= ( returnedUnitFactors == correctUnitFactors )
    end
    return pass
end

function Unit_removesUnitlessFactor()
    examples = _getExamplesFor_Unit_removesUnitlessFactor()
    return _testExamplesFor_Unit_removesUnitlessFactor(examples)
end

function _getExamplesFor_Unit_removesUnitlessFactor()
    unitFactor = TestingTools.generateRandomUnitFactor()
    unitlessFactor = _generateUnitlessUnitFactor()

    examples = [
        ( [ unitlessFactor ], [ unitlessFactor ] ),
        ( [ unitlessFactor, unitlessFactor ], [ unitlessFactor ] ),
        ( [ unitFactor, unitlessFactor ], [ unitFactor ] ),
        ( [ unitlessFactor, unitFactor ], [ unitFactor ] )
    ]
    return examples
end

function _testExamplesFor_Unit_removesUnitlessFactor(examples::Vector)
    pass = true
    for (passedUnitFactors, correctUnitFactors) in examples
        unit = Unit(passedUnitFactors)
        returnedUnitFactors = unit.unitFactors
        pass &= ( returnedUnitFactors == correctUnitFactors )
    end
    return pass
end

function _verifyHasCorrectFields(unit::Unit, correctUnitFactors::Vector{UnitFactor})
    assignedUnitFactors = unit.unitFactors
    pass = true
    for (assignedFactor, correctFactor) in zip(assignedUnitFactors, correctUnitFactors)
        pass &= (assignedFactor == correctFactor)
    end
    return pass
end

function equality_implemented()
    randomUnitFactors1 = TestingTools.generateRandomUnitFactors(4)
    randomUnitFactors2 = deepcopy(randomUnitFactors1)
    unit1 = Unit(randomUnitFactors1)
    unit2 = Unit(randomUnitFactors2)
    return unit1 == unit2
end

function canInstanciateUnitWithSingleUnitFactor()
    pass = false
    try
        unitFactor = TestingTools.generateRandomUnitFactor()
        Unit(unitFactor)
        pass = true
    catch
    end
    return pass
end

function canInstanciateUnitWithSingleBaseUnit()
    pass = false
    try
        baseUnit = TestingTools.generateRandomBaseUnit()
        Unit(baseUnit)
        pass = true
    catch
    end
    return pass
end

function Unit_actsAsIdentityOnUnit()
    unit = TestingTools.generateRandomUnit()
    sameUnit = Unit(unit)
    pass = (sameUnit === unit)
    return pass
end

function unitlessUnitIsDefined()
    unitless = Alicorn.unitlessUnit
    correct = (unitless.unitFactors == [Alicorn.unitlessUnitFactor])
    return correct
end

function canInstanciateUnitlessUnitWithoutArguments()
    unitlessUnit = Alicorn.unitlessUnit
    unitlessUnitReturned = Unit()
    return (unitlessUnitReturned == unitlessUnit)
end

function Unit_actsAsScalarInBroadcast()
    unit1 = TestingTools.generateRandomUnit()
    unit2 = TestingTools.generateRandomUnit()
    unitArray = [ unit1, unit2 ]
    pass = false
    try
        elementwiseComparison = (unitArray .== unit1)
        pass = (elementwiseComparison == [true, false])
    catch
    end
    return pass
end

function inv_implemented()
    examples = _getExamplesFor_inv()
    return TestingTools.testMonadicFunction(inv, examples)
end

function _getExamplesFor_inv()
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

function exponentiation_implemented()
    examples = _getExamplesFor_exponentiation()
    return TestingTools.testDyadicFunction(Base.:^, examples)
end

function _getExamplesFor_exponentiation()
    unitPrefix1 = TestingTools.generateRandomUnitPrefix()
    baseUnit1 = TestingTools.generateRandomBaseUnit()
    unitPrefix2 = TestingTools.generateRandomUnitPrefix()
    baseUnit2 = TestingTools.generateRandomBaseUnit()

    # format: Unit, exponent, correct result for Unit^exponent
    examples = [
        (
            Alicorn.unitlessUnit,
            0,
            Alicorn.unitlessUnit
        ),
        (
            Alicorn.unitlessUnit,
            1,
            Alicorn.unitlessUnit
        ),
        (
            Alicorn.unitlessUnit,
            -1,
            Alicorn.unitlessUnit
        ),
        (
            Alicorn.unitlessUnit,
            2,
            Alicorn.unitlessUnit
        ),
        (
            Unit([ UnitFactor(unitPrefix1, baseUnit1, 2), UnitFactor(unitPrefix1, baseUnit1, 3)]),
            0,
            Alicorn.unitlessUnit,
        ),
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

function sqrt_implemented()
    examples = _getExamplesFor_sqrt()
    return TestingTools.testMonadicFunction(Base.sqrt, examples)
end

function _getExamplesFor_sqrt()
    unitPrefix1 = TestingTools.generateRandomUnitPrefix()
    baseUnit1 = TestingTools.generateRandomBaseUnit()
    unitPrefix2 = TestingTools.generateRandomUnitPrefix()
    baseUnit2 = TestingTools.generateRandomBaseUnit()

    # format: Unit, correct result for sqrt(Unit)
    examples = [
        (
            Alicorn.unitlessUnit,
            Alicorn.unitlessUnit
        ),
        (
            Unit([ UnitFactor(unitPrefix1, baseUnit1, 2), UnitFactor(unitPrefix2, baseUnit2, 3)]),
            Unit([ UnitFactor(unitPrefix1, baseUnit1, 1), UnitFactor(unitPrefix2, baseUnit2, 1.5)])
        )
    ]
    return examples
end

function multiplication_implemented()
    examples = _getExamplesFor_multiplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_multiplication()
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

function division_implemented()
    examples = _getExamplesFor_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_division()
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

function convertToBasicSI_implemented()
    examples = _getExamplesFor_convertToBasicSI()
    return TestingTools.testMonadicFunction(convertToBasicSI, examples)
end

function _getExamplesFor_convertToBasicSI()
    ucat = UnitCatalogue()

    # format: Unit, (corresponding prefactor, corresponding SI unit)
    examples = [
        ( ucat.meter^2 * ucat.gram^3, (1e-9, Unit( (ucat.kilo * ucat.gram)^3 * ucat.meter^2 )) ),
        ( (ucat.micro * ucat.candela)/(ucat.milli * ucat.joule), (1e-3, Unit( (ucat.kilo * ucat.gram)^-1 * ucat.meter^-2 * ucat.second^2 * ucat.candela )) )
    ]
    return examples
end

end # module
