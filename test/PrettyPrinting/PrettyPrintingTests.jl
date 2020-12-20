module PrettyPrintingTests

using Alicorn
using Test
using ..TestingTools

function run()
    @testset "PrettyPrinting" begin
        testScientificNumberPrettyPrinting()
        testUnitPrefixPrettyPrinting()
        testBaseUnitExponentsPrettyPrinting()
        testBaseUnitPrettyPrinting()
        testUnitCataloguePrettyPrinting()
    end
end

## Numbers

function testScientificNumberPrettyPrinting()
    (examples, significantDigits) = _getPrettyPrintingExamples()
    @test _checkPrettyPrintingExamplesImplemented(examples, significantDigits)
end

function _getPrettyPrintingExamples()
    significantDigits = 3
    examples = [
    (1.200e-10,"1.2e-10"),
    (1.234e-9,"1.23e-9"),
    (0,"0"),
    (1,"1"),
    (2.9,"2.9"),
    (0.9,"9e-1"),
    (0.91,"9.1e-1"),
    (0.912,"9.12e-1"),
    (0.9127,"9.13e-1"),
    (101.9,"1.02e+2"),
    (Inf,"Inf"),
    (NaN,"NaN"),
    (NaN32,"NaN"),
    (-Inf,"-Inf"),
    (Inf32,"Inf"),
    ]
    return (examples, significantDigits)
end

function _checkPrettyPrintingExamplesImplemented(examples::Array{Tuple{Real,String}}, significantDigits::Int64)
    correct = true
    for (number, correctPrettyStr) in examples
        returnedPrettyString = Alicorn.PrettyPrinting.prettyPrintScientificNumber(number, sigdigits=significantDigits)
        correct &= returnedPrettyString==correctPrettyStr
    end
    return correct
end

## UnitPrefix

function testUnitPrefixPrettyPrinting()
    examples = _getUnitPrefixExamples()
    @test verifyPrettyPrintingImplemented(examples)
end

function _getUnitPrefixExamples()
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

function verifyPrettyPrintingImplemented(examples)
    correct = true
    for (object, correctPrettyStr) in examples
        generatedPrettyStr = getShowString(object)
        correct &= ( generatedPrettyStr == correctPrettyStr )
    end
    return correct
end

function getShowString(object)
    io = IOBuffer()
    show(io, object)
    generatedString = String(take!(io))
    return generatedString
end


## BaseUnitExponents

function testBaseUnitExponentsPrettyPrinting()
    examples = _getBaseUnitExponentsExamples()
    @test verifyPrettyPrintingImplemented(examples)
end

function _getBaseUnitExponentsExamples()
    examples = [
    ( BaseUnitExponents(), "BaseUnitExponents 1"),
    ( BaseUnitExponents(kg=1), "BaseUnitExponents kg"),
    ( BaseUnitExponents(m=2), "BaseUnitExponents m^2"),
    ( BaseUnitExponents(m=2, s=1.554), "BaseUnitExponents m^2 s^1.6"),
    ( BaseUnitExponents(s=1.554, A=pi), "BaseUnitExponents s^1.6 A^3.1"),
    ( BaseUnitExponents(s=1.554, A=pi, K=-1), "BaseUnitExponents s^1.6 A^3.1 K^-1"),
    ( BaseUnitExponents(s=1.554, mol=pi, K=-1), "BaseUnitExponents s^1.6 K^-1 mol^3.1"),
    ( BaseUnitExponents(cd=-70), "BaseUnitExponents cd^-7e+1"),
    ]
    return examples
end


## BaseUnit

function testBaseUnitPrettyPrinting()
    examples = _getBaseUnitExamples()
    @test verifyPrettyPrintingImplemented(examples)
end


function _getBaseUnitExamples()
    example1 = (
        BaseUnit(
            name = "Newton",
            symbol = "N",
            prefactor = 1,
            exponents = BaseUnitExponents(kg=1, m=1, s=-2)
        ),
        "BaseUnit Newton (1 N = 1 kg m s^-2)"
    )

    example2 = (
        BaseUnit(
            name = "electronvolt",
            symbol = "eV",
            prefactor = 1.609176634E-19,
            exponents = BaseUnitExponents(kg=1, m=2, s=-2)
        ),
        "BaseUnit electronvolt (1 eV = 1.61e-19 kg m^2 s^-2)"
    )

    return [example1, example2]
end


## UnitCatalogue

function testUnitCataloguePrettyPrinting()
    ucat = UnitCatalogue()
    correctPrettyString = _getCorrectPrettyString(ucat)
    returnedPrettyString = getShowString(ucat)
    @test (returnedPrettyString == correctPrettyString)
end

function _getCorrectPrettyString(ucat::UnitCatalogue)
    nrOfUnitPrefixes = length(listUnitPrefixes(ucat))
    prettyString = "UnitCatalogue providing\n\t$nrOfUnitPrefixes unit prefixes"
    return prettyString
end

end # module
