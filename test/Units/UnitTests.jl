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

        @test unitlessUnitIsDefined()
        @test canInstanciateUnitlessUnitWithoutArguments()
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

function unitlessUnitIsDefined()
    unitless = Unit( Alicorn.unitlessUnitFactor )
    return (Alicorn.unitlessUnit == unitless)
end

function canInstanciateUnitlessUnitWithoutArguments()
    unitlessUnit = Alicorn.unitlessUnit
    unitlessUnitReturned = Unit()
    return (unitlessUnitReturned == unitlessUnit)
end


end # module
