module UnitPrefixTests

using Alicorn
using Alicorn.Utils
using Test
using Random
using ..TestingTools

function run()
    @testset "UnitPrefix" begin
        @test canInstantiateUnitPrefix()
        test_UnitPrefix_ErrorsForInfiniteValues()
        test_UnitPrefix_ErrorsForNonIdentifierNames()
        @test UnitPrefix_FieldsCorrectlyInitialized()
        @test equality_implemented()
        @test equalPrefixesAreIdentical()

        @test emptyUnitPrefixIsDefined()
        @test kiloIsDefined()
        @test UnitPrefix_actsAsScalarInBroadcast()
    end
end

function canInstantiateUnitPrefix()
    pass = false
    try
        UnitPrefix(name="nano", symbol="n", value=1e-9)
        pass = true
    catch
    end
    return pass
end

function test_UnitPrefix_ErrorsForInfiniteValues()
    infiniteNumbers = TestingTools.getInfiniteNumbers()
    for number in infiniteNumbers
        @test_throws DomainError(number,"argument must be finite") UnitPrefix(
            name = "test",
            symbol = "t",
            value = number
        )
    end
end

function test_UnitPrefix_ErrorsForNonIdentifierNames()
    invalidNames = TestingTools.getInvalidUnitElementNamesTestset()
    for name in invalidNames
        @test_throws ArgumentError("name argument must be a valid identifier") UnitPrefix(
            name = name,
            symbol = "t",
            value = 2
        )
    end
end

function UnitPrefix_FieldsCorrectlyInitialized()
    (prefix, randFields) = TestingTools.generateRandomUnitPrefixWithFields()
    return _verifyPrefixHasCorrectFields(prefix, randFields)
end

function _verifyPrefixHasCorrectFields(prefix::UnitPrefix, randFields::Dict)
    correct = (prefix.name == randFields["name"])
    correct &= (prefix.symbol == randFields["symbol"])
    correct &= (prefix.value == randFields["value"])
    return correct
end

function equality_implemented()
    randomFields1 = TestingTools.generateRandomUnitPrefixFields()
    randomFields2 = deepcopy(randomFields1)
    prefix1 = _initializeUnitFactorFromDict(randomFields1)
    prefix2 = _initializeUnitFactorFromDict(randomFields2)
    return prefix1 == prefix2
end

function _initializeUnitFactorFromDict(fields::Dict)
    unitPrefix = UnitPrefix(
        name = fields["name"],
        symbol = fields["symbol"],
        value = fields["value"]
    )
    return unitPrefix
end

function equalPrefixesAreIdentical()
    randomFields = TestingTools.generateRandomUnitPrefixFields()
    prefix1 = _initializeUnitFactorFromDict(randomFields)
    prefix2 = _initializeUnitFactorFromDict(randomFields)
    return prefix1 === prefix2
end

function emptyUnitPrefixIsDefined()
    emptyPrefix = Alicorn.emptyUnitPrefix

    expectedName = "empty"
    expectedSymbol = "<empty>"
    expectedValue = 1

    nameCorrect = (emptyPrefix.name == expectedName)
    symbolCorrect = (emptyPrefix.symbol == expectedSymbol)
    valueCorrect = (emptyPrefix.value == expectedValue)
    correct = (nameCorrect && symbolCorrect && valueCorrect)

    return correct
end

function kiloIsDefined()
    kilo = UnitPrefix(
        name = "kilo",
        symbol = "k",
        value = 1e3
    )
    return Alicorn.kilo == kilo
end

function UnitPrefix_actsAsScalarInBroadcast()
    (unitPrefix1, unitPrefix2) = _generateTwoDifferentUnitPrefixesWithoutUsingBroadcasting()
    unitPrefixArray = [ unitPrefix1, unitPrefix2 ]
    pass = false
    try
        elementwiseComparison = (unitPrefixArray .== unitPrefix1)
        pass = elementwiseComparison == [true, false]
    catch
    end
    return pass
end

function _generateTwoDifferentUnitPrefixesWithoutUsingBroadcasting()
    unitPrefix1 = TestingTools.generateRandomUnitPrefix()
    unitPrefix2 = unitPrefix1
    while unitPrefix2 == unitPrefix1
        unitPrefix2 = TestingTools.generateRandomUnitPrefix()
    end
    return (unitPrefix1, unitPrefix2)
end

end # module
