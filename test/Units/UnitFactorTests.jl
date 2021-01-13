module UnitFactorTests

using Alicorn
using Test
using ..TestingTools

function run()
    @testset "UnitFactor" begin
        @test canInstanciateUnitFactor()
        test_UnitFactor_ErrorsOnInfiniteExponent()
        test_UnitFactor_ErrorsOnZeroExponent()
        test_UnitFactor_TriesCastingExponentsToInt()
        @test UnitFactor_actsAsScalarInBroadcast()
        @test UnitFactor_fieldsCorrectlyInitialized()
        test_UnitFactor_ErrorsOnUnitlessBaseUnitWithNonemptyPrefix()
        test_UnitFactor_ErrorsOnUnitlessBaseUnitWithNontrivialExponent()

        @test equality_implemented()

        @test canInstanciateUnitFactorWithoutPrefix()
        @test canInstanciateUnitFactorWithoutExponent()
        @test canInstanciateUnitFactorWithoutPrefixAndExponent()
        @test canInstanciateUnitlessUnitFactor()

        @test unitlessUnitFactorIsDefined()
    end
end

function canInstanciateUnitFactor()
    pass = false
    try
        unitPrefix = TestingTools.generateRandomUnitPrefix()
        baseUnit = TestingTools.generateRandomBaseUnit()
        exponent = TestingTools.generateRandomNonzeroReal()
        UnitFactor(unitPrefix, baseUnit, exponent)
        pass = true
    catch
    end
    return pass
end

function test_UnitFactor_ErrorsOnInfiniteExponent()
    infiniteExponents = TestingTools.getInfiniteNumbers()
    _verify_UnitFactor_ErrorsOnExponents(infiniteExponents)
end

function _verify_UnitFactor_ErrorsOnExponents(exponents::Vector{T}) where T <: Real
    unitPrefix = TestingTools.generateRandomUnitPrefix()
    baseUnit = TestingTools.generateRandomBaseUnit()
    for exponent in exponents
        _verify_UnitFactor_ErrorsOnExponent(unitPrefix, baseUnit, exponent)
    end
end

function _verify_UnitFactor_ErrorsOnExponent(unitPrefix::UnitPrefix, baseUnit::BaseUnit, exponent::Real)
    @test_throws DomainError(exponent,"argument must be finite") UnitFactor(unitPrefix, baseUnit, exponent)
end

function test_UnitFactor_ErrorsOnZeroExponent()
    unitPrefix = TestingTools.generateRandomUnitPrefix()
    baseUnit = TestingTools.generateRandomBaseUnit()
    exponent = 0
    @test_throws DomainError(exponent,"argument must be nonzero") UnitFactor(unitPrefix, baseUnit, exponent)
end

function test_UnitFactor_TriesCastingExponentsToInt()
    unitPrefix = TestingTools.generateRandomUnitPrefix()
    baseUnit = TestingTools.generateRandomBaseUnit()
    exponent = 3.0
    unitFactor = UnitFactor(unitPrefix, baseUnit, exponent)
    @test isa(unitFactor.exponent, Int)
end

function UnitFactor_actsAsScalarInBroadcast()
    (unitFactor1, unitFactor2) = _generateTwoDifferentUnitFactorsWithoutUsingBroadcasting()
    unitFactorArray = [ unitFactor1, unitFactor2 ]
    pass = false
    try
        elementwiseComparison = (unitFactorArray .== unitFactor1)
        pass = elementwiseComparison == [true, false]
    catch
    end
    return pass
end

function _generateTwoDifferentUnitFactorsWithoutUsingBroadcasting()
    unitFactor1 = TestingTools.generateRandomUnitFactor()
    unitFactor2 = unitFactor1
    while unitFactor2 == unitFactor1
        unitFactor2 = TestingTools.generateRandomUnitFactor()
    end
    return (unitFactor1, unitFactor2)
end

function UnitFactor_fieldsCorrectlyInitialized()
    (unitFactor, randomFields) = TestingTools.generateRandomUnitFactorWithFields()
    return _verifyHasCorrectFields(unitFactor, randomFields)
end

function _verifyHasCorrectFields(unitFactor::UnitFactor, randomFields::Dict)
    correct = (unitFactor.unitPrefix == randomFields["unitPrefix"])
    correct &= (unitFactor.baseUnit == randomFields["baseUnit"])
    correct &= (unitFactor.exponent == randomFields["exponent"])
    return correct
end

function equality_implemented()
    randomFields1 = TestingTools.generateRandomUnitFactorFields()
    randomFields2 = deepcopy(randomFields1)
    unitFactor1 = _initializeUnitFactorFromDict(randomFields1)
    unitFactor2 = _initializeUnitFactorFromDict(randomFields2)
    return unitFactor1 == unitFactor2
end

function _initializeUnitFactorFromDict(fields::Dict)
    unitFactor = UnitFactor(
        fields["unitPrefix"],
        fields["baseUnit"],
        fields["exponent"]
    )
    return unitFactor
end

function test_UnitFactor_ErrorsOnUnitlessBaseUnitWithNonemptyPrefix()
    unitPrefix = TestingTools.generateRandomUnitPrefix()
    @test_throws Core.ArgumentError("unitless BaseUnit requires empty UnitPrefix") UnitFactor(unitPrefix, Alicorn.unitlessBaseUnit, 1)
end

function test_UnitFactor_ErrorsOnUnitlessBaseUnitWithNontrivialExponent()
    @test_throws Core.ArgumentError("unitless BaseUnit requires exponent 1") UnitFactor(Alicorn.emptyUnitPrefix, Alicorn.unitlessBaseUnit, 2)
end

function canInstanciateUnitFactorWithoutPrefix()
    pass = false
    try
        baseUnit = TestingTools.generateRandomBaseUnit()
        exponent = TestingTools.generateRandomNonzeroReal()
        UnitFactor(baseUnit, exponent)
        pass = true
    catch
    end
    return pass
end

function canInstanciateUnitFactorWithoutExponent()
    pass = false
    try
        unitPrefix = TestingTools.generateRandomUnitPrefix()
        baseUnit = TestingTools.generateRandomBaseUnit()
        UnitFactor(unitPrefix, baseUnit)
        pass = true
    catch
    end
    return pass
end

function canInstanciateUnitFactorWithoutPrefixAndExponent()
    pass = false
    try
        baseUnit = TestingTools.generateRandomBaseUnit()
        UnitFactor(baseUnit)
        pass = true
    catch
    end
    return pass
end

function canInstanciateUnitlessUnitFactor()
    unitlessUnitFactor = UnitFactor(Alicorn.emptyUnitPrefix, Alicorn.unitlessBaseUnit, 1)
    return ( UnitFactor() == unitlessUnitFactor )
end

function unitlessUnitFactorIsDefined()
    unitless = UnitFactor( Alicorn.emptyUnitPrefix, Alicorn.unitlessBaseUnit, 1)
    return (Alicorn.unitlessUnitFactor == unitless)
end

end # module
