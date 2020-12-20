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
    (prefix, randFields) = TestingTools.generateRandomPrefix()
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

function testEqualPrefixesAreIdentical()
    @test UnitPrefix(name="nano",symbol="n",value=1e-9) === UnitPrefix(name="nano",symbol="n",value=1e-9)
end

end # module
