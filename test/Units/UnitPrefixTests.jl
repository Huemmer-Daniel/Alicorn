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
        testPrettyPrinting()
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

function testPrettyPrinting()
    examples = _getExamplesForPrettyPrinting()
    @test TestingTools.verifyPrettyPrintingImplemented(examples)
end

function _getExamplesForPrettyPrinting()
    values = [1.200e-10,1.234e-9,0,1,2.9,0.9,0.91,0.912,0.9127,101.9]
    valuesPrettyStrs = ["1.2e-10", "1.23e-9", "0", "1", "2.9", "9e-1", "9.1e-1", "9.12e-1", "9.13e-1", "1.02e+2"]

    examples = Array{Tuple{UnitPrefix,String}}([])
    for (value,valuePrettyStr) = zip(values,valuesPrettyStrs)
        randFields = TestingTools.generateRandomPrefixFields()
        name = randFields["name"]
        symbol = randFields["symbol"]
        prefix = UnitPrefix(value = value, name = name, symbol = symbol)
        prettyStr = "UnitPrefix $name ($symbol) of value " * valuePrettyStr
        examples = append!( examples, [ (prefix, prettyStr) ] )
    end
    return examples
end

end # module
