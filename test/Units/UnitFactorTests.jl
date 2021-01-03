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
        test_equality()

        canInstanciateUnitFactorWithoutPrefix()
        canInstanciateUnitFactorWithoutExponent()
        canInstanciateUnitFactorWithoutPrefixAndExponent()
        canInstanciateUnitlessUnitFactor()
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
    @test pass
end

function UnitFactor_ErrorsOnInfiniteExponent()
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

function UnitFactor_ErrorsOnZeroExponent()
    unitPrefix = TestingTools.generateRandomUnitPrefix()
    baseUnit = TestingTools.generateRandomBaseUnit()
    exponent = 0
    @test_throws DomainError(exponent,"argument must be nonzero") UnitFactor(unitPrefix, baseUnit, exponent)
end

function test_UnitFactor_fieldsCorrectlyInitialized()
    (unitFactor, randomFields) = TestingTools.generateRandomUnitFactorWithFields()
    @test _verifyHasCorrectFields(unitFactor, randomFields)
end

function _verifyHasCorrectFields(unitFactor::UnitFactor, randomFields::Dict)
    correct = (unitFactor.unitPrefix == randomFields["unitPrefix"])
    correct &= (unitFactor.baseUnit == randomFields["baseUnit"])
    correct &= (unitFactor.exponent == randomFields["exponent"])
    return correct
end

function test_equality()
    randomFields1 = TestingTools.generateRandomUnitFactorFields()
    randomFields2 = deepcopy(randomFields1)
    unitFactor1 = _initializeUnitFactorFromDict(randomFields1)
    unitFactor2 = _initializeUnitFactorFromDict(randomFields2)
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

function canInstanciateUnitFactorWithoutPrefix()
    pass = false
    try
        baseUnit = TestingTools.generateRandomBaseUnit()
        exponent = TestingTools.generateRandomNonzeroReal()
        UnitFactor(baseUnit, exponent)
        pass = true
    catch
    end
    @test pass
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
    @test pass
end

function canInstanciateUnitFactorWithoutPrefixAndExponent()
    pass = false
    try
        baseUnit = TestingTools.generateRandomBaseUnit()
        UnitFactor(baseUnit)
        pass = true
    catch
    end
    @test pass
end

function canInstanciateUnitlessUnitFactor()
    unitlessUnitFactor = UnitFactor(Alicorn.emptyUnitPrefix, Alicorn.unitlessBaseUnit, 1)
    @test (UnitFactor() == unitlessUnitFactor)
end

end # module
