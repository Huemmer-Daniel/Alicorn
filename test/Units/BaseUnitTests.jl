module BaseUnitTests

using Alicorn
using Test
using ..TestingTools

function run()
    @testset "BaseUnit" begin
        canInstantiateBaseUnit()
        BaseUnit_ErrorsOnInfinitePrefactor()
        BaseUnit_ErrorsForNonIdentifierNames()
        BaseUnit_FieldsCorrectlyInitialized()
        test_isequal()
    end
end

function canInstantiateBaseUnit()
    pass = false
    try
        BaseUnit(
            name="gram",
            symbol="g",
            prefactor=1e-3,
            exponents=BaseUnitExponents(kg=1)
        )
        pass = true
    catch
    end
    @test pass
end

function BaseUnit_ErrorsOnInfinitePrefactor()
    infiniteNumbers = TestingTools.getInfiniteNumbers()
    for number in infiniteNumbers
        @test_throws DomainError(number,"argument must be finite") BaseUnit(
            name="gram",
            symbol="g",
            prefactor=number,
            exponents=BaseUnitExponents(kg=1)
        )
    end
end

function BaseUnit_ErrorsForNonIdentifierNames()
    invalidNames = TestingTools.getInvalidUnitElementNamesTestset()
    for name in invalidNames
        @test_throws ArgumentError("name argument must be a valid identifier") BaseUnit(
            name = name,
            symbol = "t",
            prefactor = 2,
            exponents = BaseUnitExponents()
        )
    end
end

function BaseUnit_FieldsCorrectlyInitialized()
    (baseUnit, randFields) = TestingTools.generateRandomBaseUnit()
    @test _verifyHasCorrectFields(baseUnit, randFields)
end

function _verifyHasCorrectFields(baseUnit::BaseUnit, randFields::Dict)
    correct = (baseUnit.name == randFields["name"])
    correct &= (baseUnit.symbol == randFields["symbol"])
    correct &= (baseUnit.prefactor == randFields["prefactor"])
    correct &= (baseUnit.exponents == randFields["exponents"])
    return correct
end

function test_isequal()
    randomFields = TestingTools.generateRandomBaseUnitFields()
    baseUnit1 = _initializeUnitFactorFromDict(randomFields)
    baseUnit2 = _initializeUnitFactorFromDict(randomFields)
    @test baseUnit1 == baseUnit2
end

function _initializeUnitFactorFromDict(fields::Dict)
    baseUnit = BaseUnit(
        name = fields["name"],
        symbol = fields["symbol"],
        prefactor = fields["prefactor"],
        exponents = fields["exponents"]
    )
    return baseUnit
end

end # module
