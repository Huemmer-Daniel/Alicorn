module UnitTests

using Alicorn
using Test
using ..TestingTools

function run()
    @testset "Unit" begin
        canInstanciateUnit()
        test_Unit_fieldsCorrectlyInitialized()

        test_equality()

        canInstanciateUnitWithSingleUnitFactor()
        canInstanciateUnitlessUnitWithoutArguments()
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
    @test pass
end

function test_Unit_fieldsCorrectlyInitialized()
    (randomUnit, randomUnitFactors) = TestingTools.generateRandomUnitWithFields()
    @test _verifyHasCorrectFields(randomUnit, randomUnitFactors)
end

function _verifyHasCorrectFields(unit::Unit, correctUnitFactors::Vector{UnitFactor})
    assignedUnitFactors = unit.unitFactors
    pass = true
    for (assignedFactor, correctFactor) in zip(assignedUnitFactors, correctUnitFactors)
        pass &= (assignedFactor == correctFactor)
    end
    return pass
end

function test_equality()
    randomUnitFactors1 = TestingTools.generateRandomUnitFields()
    randomUnitFactors2 = deepcopy(randomUnitFactors1)
    unit1 = Unit(randomUnitFactors1)
    unit2 = Unit(randomUnitFactors2)
    @test unit1 == unit2
end

function canInstanciateUnitWithSingleUnitFactor()
    pass = false
    try
        unitFactor = TestingTools.generateRandomUnitFactor()
        Unit(unitFactor)
        pass = true
    catch
    end
    @test pass
end

function canInstanciateUnitlessUnitWithoutArguments()
    unitlessUnitFactor = UnitFactor()
    unitlessUnit = Unit(unitlessUnitFactor)
    unitlessUnitReturned = Unit()
    @test (unitlessUnitReturned == unitlessUnit)
end

end # module
