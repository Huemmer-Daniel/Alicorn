module UnitFactorTests

using Alicorn
using Test
using ..TestingTools

function run()
    @testset "UnitFactor" begin
        canInstanciateUnitFactor()
        UnitFactor_ErrorsOnInfiniteExponent()
        UnitFactor_ErrorsOnZeroExponent()
        test_UnitFactor_fieldsCorrectlyInitialized()
        test_isequal()
    end
end

function canInstanciateUnitFactor()
    pass = false
    try
        unitPrefix = TestingTools.getUnitPrefixTestSet()[1]
        baseUnit = TestingTools.getBaseUnitTestSet()[1]
        exponent = 3
        UnitFactor(unitPrefix, baseUnit, exponent)
        pass = true
    catch
    end
    @test pass
end

function UnitFactor_ErrorsOnInfiniteExponent()
    infiniteExponents = TestingTools.getInfiniteNumbers()
    _verify_UnitFactor_ErrorsOnExponents(infiniteExponents)
end

function _verify_UnitFactor_ErrorsOnExponents(exponents::Vector{T}) where T <: Real
    unitPrefix = TestingTools.getUnitPrefixTestSet()[1]
    baseUnit = TestingTools.getBaseUnitTestSet()[1]
    for exponent in exponents
        _verify_UnitFactor_ErrorsOnExponent(unitPrefix, baseUnit, exponent)
    end
end

function _verify_UnitFactor_ErrorsOnExponent(unitPrefix::UnitPrefix, baseUnit::BaseUnit, exponent::Real)
    @test_throws DomainError(exponent,"argument must be finite") UnitFactor(unitPrefix, baseUnit, exponent)
end

function UnitFactor_ErrorsOnZeroExponent()
    unitPrefix = TestingTools.getUnitPrefixTestSet()[1]
    baseUnit = TestingTools.getBaseUnitTestSet()[1]
    exponent = 0
    @test_throws DomainError(exponent,"argument must be nonzero") UnitFactor(unitPrefix, baseUnit, exponent)
end

function test_UnitFactor_fieldsCorrectlyInitialized()
    (unitFactor, randomFields) = TestingTools.generateRandomUnitFactor()
    @test _verifyHasCorrectFields(unitFactor, randomFields)
end

function _verifyHasCorrectFields(unitFactor::UnitFactor, randomFields::Dict)
    correct = (unitFactor.unitPrefix == randomFields["unitPrefix"])
    correct &= (unitFactor.baseUnit == randomFields["baseUnit"])
    correct &= (unitFactor.exponent == randomFields["exponent"])
    return correct
end

function test_isequal()
    randomFields = TestingTools.generateRandomUnitFactorFields()
    unitFactor1 = _initializeUnitFactorFromDict(randomFields)
    unitFactor2 = _initializeUnitFactorFromDict(randomFields)
    @test unitFactor1 == unitFactor2
end

function _initializeUnitFactorFromDict(fields::Dict)
    unitFactor = UnitFactor(
        fields["unitPrefix"],
        fields["baseUnit"],
        fields["exponent"]
    )
    return unitFactor
end

end # module
