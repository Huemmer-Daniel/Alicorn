module UnitPrefixTests

using Alicorn
using Alicorn.Utils
using Test
using Random
using ..TestingTools

function run()
    @testset "UnitPrefix" begin
        canInstantiateUnitPrefix()
        UnitPrefixFieldsCorrectlyInitialized()
        UnitPrefixErrorsForInfiniteValues()
        UnitPrefixErrorsForNonIdentifierNames()
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

function UnitPrefixFieldsCorrectlyInitialized()
    (prefix, randFields) = _generateRandomPrefix()
    @test _verifyPrefixHasCorrectFields(prefix, randFields)
end

function _generateRandomPrefix()
    randFields = _generateRandomPrefixFields()
    prefix = UnitPrefix(name=randFields[1], symbol=randFields[2], value=randFields[3])
    return (prefix, randFields)
end

function _generateRandomPrefixFields()
    name = Random.randstring(['a':'z';'A':'Z'],12)
    symbol = Random.randstring(2)
    value = rand(Float64)
    return (name, symbol, value)
end

function _verifyPrefixHasCorrectFields(prefix::UnitPrefix, randFields::Tuple{String,String,Float64})
    (name, symbol, value) = randFields
    correct = (prefix.name == name)
    correct &= (prefix.symbol == symbol)
    correct &= (prefix.value == value)
    return correct
end

function UnitPrefixErrorsForInfiniteValues()
    @test_throws DomainError(Inf,"argument must be finite") UnitPrefix(name="test", symbol="t", value=Inf)
    @test_throws DomainError(-Inf,"argument must be finite") UnitPrefix(name="test", symbol="t", value=-Inf)
    @test_throws DomainError(NaN,"argument must be finite") UnitPrefix(name="test", symbol="t", value=NaN)
end

function UnitPrefixErrorsForNonIdentifierNames()
    @test_throws ArgumentError("name argument must be a valid identifier") UnitPrefix(name="test test", symbol="t", value=2)
    @test_throws ArgumentError("name argument must be a valid identifier") UnitPrefix(name="test-test", symbol="t", value=2)
    @test_throws ArgumentError("name argument must be a valid identifier") UnitPrefix(name="test?test", symbol="t", value=2)
    @test_throws ArgumentError("name argument must be a valid identifier") UnitPrefix(name="}", symbol="t", value=2)
end

function testEqualPrefixesAreIdentical()
    @test UnitPrefix(name="nano",symbol="n",value=1e-9) === UnitPrefix(name="nano",symbol="n",value=1e-9)
end

function testPrettyPrinting()
    examples = _getExamplesForPrettyPrinting()
    @test _checkExamplesForPrettyPrintingImplemented(examples)
end

function _getExamplesForPrettyPrinting()
    values = [1.200e-10,1.234e-9,0,1,2.9,0.9,0.91,0.912,0.9127,101.9]
    valuesPrettyStrs = ["1.2e-10", "1.23e-9", "0", "1", "2.9", "9e-1", "9.1e-1", "9.12e-1", "9.13e-1", "1.02e+2"]

    examples = Array{Tuple{UnitPrefix,String}}([])
    for (value,valuePrettyStr) = zip(values,valuesPrettyStrs)
        (name,symbol,) = _generateRandomPrefixFields()
        prefix = UnitPrefix(value=value, name=name, symbol=symbol)
        prettyStr = "UnitPrefix $name ($symbol) of value " * valuePrettyStr
        examples = append!(examples,[(prefix,prettyStr)])
    end
    return examples
end

function _checkExamplesForPrettyPrintingImplemented(examples::Array{Tuple{UnitPrefix,String}})
    correct = true
    for (prefix,correctPrettyStr) in examples
        generatedPrettyStr = TestingTools.getShowString(prefix)
        correct &= ( generatedPrettyStr == correctPrettyStr )
    end
    return correct
end

end # module
