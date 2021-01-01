module UnitPrefixTests

using Alicorn
using Alicorn.Utils
using Test
using Random
using ..TestingTools

function run()
    @testset "UnitPrefix" begin
        canInstantiateUnitPrefix()
        UnitPrefix_ErrorsForInfiniteValues()
        UnitPrefix_ErrorsForNonIdentifierNames()
        UnitPrefix_FieldsCorrectlyInitialized()
        test_isequal()
        testEqualPrefixesAreIdentical()
    end
end

function canInstantiateUnitPrefix()
    pass = false
    try
        UnitPrefix(name="nano", symbol="n", value=1e-9)
        pass = true
    catch
    end
    @test pass
end

function UnitPrefix_FieldsCorrectlyInitialized()
    (prefix, randFields) = TestingTools.generateRandomUnitPrefix()
    @test _verifyPrefixHasCorrectFields(prefix, randFields)
end

function _verifyPrefixHasCorrectFields(prefix::UnitPrefix, randFields::Dict)
    correct = (prefix.name == randFields["name"])
    correct &= (prefix.symbol == randFields["symbol"])
    correct &= (prefix.value == randFields["value"])
    return correct
end

function UnitPrefix_ErrorsForInfiniteValues()
    infiniteNumbers = TestingTools.getInfiniteNumbers()
    for number in infiniteNumbers
        @test_throws DomainError(number,"argument must be finite") UnitPrefix(
            name = "test",
            symbol = "t",
            value = number
        )
    end
end

function UnitPrefix_ErrorsForNonIdentifierNames()
    invalidNames = TestingTools.getInvalidUnitElementNamesTestset()
    for name in invalidNames
        @test_throws ArgumentError("name argument must be a valid identifier") UnitPrefix(
            name = name,
            symbol = "t",
            value = 2
        )
    end
end

function test_isequal()
    randomFields = TestingTools.generateRandomUnitPrefixFields()
    prefix1 = _initializeUnitFactorFromDict(randomFields)
    prefix2 = _initializeUnitFactorFromDict(randomFields)
    @test prefix1 == prefix2
end

function _initializeUnitFactorFromDict(fields::Dict)
    unitPrefix = UnitPrefix(
        name = fields["name"],
        symbol = fields["symbol"],
        value = fields["value"]
    )
    return unitPrefix
end

function testEqualPrefixesAreIdentical()
    randomFields = TestingTools.generateRandomUnitPrefixFields()
    prefix1 = _initializeUnitFactorFromDict(randomFields)
    prefix2 = _initializeUnitFactorFromDict(randomFields)
    @test prefix1 === prefix2
end

end # module
