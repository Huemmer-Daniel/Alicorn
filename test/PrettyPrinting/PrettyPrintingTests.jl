module PrettyPrintingTests

using Alicorn
using Test
using ..TestingTools
using ..UnitsTests

function run()
    @testset "PrettyPrinting" begin
        @test prettyPrintScientificNumber()
        @test unitPrefixPrettyPrinting()
        @test baseUnitExponentsPrettyPrinting()
        @test baseUnitPrettyPrinting()
        @test unitFactorPrettyPrinting()
        @test unitCataloguePrettyPrinting()
        @test unitPrettyPrinting()

        @test simpleQuantityPrettyPrinting()
        end
end

## Numbers

function prettyPrintScientificNumber()
    (examples, significantDigits) = _getPrettyPrintingExamples()
    return _checkPrettyPrintingExamplesImplemented(examples, significantDigits)
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

function unitPrefixPrettyPrinting()
    examples = _getUnitPrefixExamples()
    return _verifyPrettyPrintingImplemented(examples)
end

function _getUnitPrefixExamples()
    values = [1.200e-10,1.234e-9,0,1,2.9,0.9,0.91,0.912,0.9127,101.9]
    valuesPrettyStrs = ["1.2e-10", "1.23e-9", "0", "1", "2.9", "9e-1", "9.1e-1", "9.12e-1", "9.13e-1", "1.02e+2"]

    examples = Array{Tuple{UnitPrefix,String}}([])
    for (value,valuePrettyStr) = zip(values,valuesPrettyStrs)
        randFields = TestingTools.generateRandomUnitPrefixFields()
        name = randFields["name"]
        symbol = randFields["symbol"]
        prefix = UnitPrefix(value = value, name = name, symbol = symbol)
        prettyStr = "UnitPrefix $name ($symbol) of value " * valuePrettyStr
        examples = append!( examples, [ (prefix, prettyStr) ] )
    end
    return examples
end

function _verifyPrettyPrintingImplemented(examples)
    correct = true
    for (object, correctPrettyStr) in examples
        generatedPrettyStr = _getShowString(object)
        correct &= ( generatedPrettyStr == correctPrettyStr )
    end
    return correct
end

function _getShowString(object)
    io = IOBuffer()
    show(io, object)
    generatedString = String(take!(io))
    return generatedString
end

## BaseUnitExponents

function baseUnitExponentsPrettyPrinting()
    examples = _getBaseUnitExponentsExamples()
    return _verifyPrettyPrintingImplemented(examples)
end

function _getBaseUnitExponentsExamples()
    examples = [
    ( BaseUnitExponents(), "BaseUnitExponents kg^0 m^0 s^0 A^0 K^0 mol^0 cd^0"),
    ( BaseUnitExponents(kg=1), "BaseUnitExponents kg^1 m^0 s^0 A^0 K^0 mol^0 cd^0"),
    ( BaseUnitExponents(m=2), "BaseUnitExponents kg^0 m^2 s^0 A^0 K^0 mol^0 cd^0"),
    ( BaseUnitExponents(m=2, s=1.554), "BaseUnitExponents kg^0 m^2 s^1.6 A^0 K^0 mol^0 cd^0"),
    ( BaseUnitExponents(s=1.554, A=pi), "BaseUnitExponents kg^0 m^0 s^1.6 A^3.1 K^0 mol^0 cd^0"),
    ( BaseUnitExponents(s=1.554, A=pi, K=-1), "BaseUnitExponents kg^0 m^0 s^1.6 A^3.1 K^-1 mol^0 cd^0"),
    ( BaseUnitExponents(s=1.554, mol=pi, K=-1), "BaseUnitExponents kg^0 m^0 s^1.6 A^0 K^-1 mol^3.1 cd^0"),
    ( BaseUnitExponents(cd=-70), "BaseUnitExponents kg^0 m^0 s^0 A^0 K^0 mol^0 cd^-7e+1")
    ]
    return examples
end

## BaseUnit

function baseUnitPrettyPrinting()
    examples = _getBaseUnitExamples()
    return _verifyPrettyPrintingImplemented(examples)
end

function _getBaseUnitExamples()
    ucat = UnitCatalogue()
    examples = [
        (ucat.newton, "BaseUnit newton (1 N = 1 kg m s^-2)"),
        (ucat.electronvolt, "BaseUnit electronvolt (1 eV = 1.6e-19 kg m^2 s^-2)"),
        (ucat.unitless, "BaseUnit unitless (1 <unitless> = 1)")
    ]
    return examples
end

## UnitFactor

function unitFactorPrettyPrinting()
    examples = _getUnitFactorExamples()
    return _verifyPrettyPrintingImplemented(examples)
end

function _getUnitFactorExamples()
    ucat = UnitCatalogue()
    examples = [
        (UnitFactor(ucat.nano, ucat.meter, 2), "UnitFactor nm^2"),
        (UnitFactor(ucat.tera, ucat.mol, -pi), "UnitFactor Tmol^-3.1"),
        (UnitFactor(ucat.deca, ucat.dalton, 1), "UnitFactor daDa"),
        (UnitFactor(ucat.dalton, 1), "UnitFactor Da")
    ]
    return examples
end

## UnitCatalogue

function unitCataloguePrettyPrinting()
    ucat = TestingTools.initializeTestUnitCatalogue()
    correctPrettyString = _getCorrectPrettyString(ucat)
    returnedPrettyString = _getShowString(ucat)
    return (returnedPrettyString == correctPrettyString)
end

function _getCorrectPrettyString(ucat::UnitCatalogue)
    nrOfUnitPrefixes = length(listUnitPrefixes(ucat))
    nrOfBaseUnits = length(listBaseUnits(ucat))
    prettyString = "UnitCatalogue providing\n $nrOfUnitPrefixes unit prefixes\n $nrOfBaseUnits base units"
    return prettyString
end

## Unit

function unitPrettyPrinting()
    examples = _getUnitExamples()
    return _verifyPrettyPrintingImplemented(examples)
end

function _getUnitExamples()
    ucat = UnitCatalogue()
    examples = [
        ( Alicorn.unitlessUnit, "Unit <unitless>"),
        ( Unit(ucat.gram), "Unit g"),
        ( ucat.meter * ucat.second^(-2), "Unit m s^-2"),
        ( Unit( ucat.kilo * ucat.gram ), "Unit kg"),
        ( Unit( (ucat.kilo * ucat.gram)^pi ) , "Unit kg^3.1"),
        ( (ucat.kilo * ucat.gram)^pi * (ucat.tera * ucat.henry)^(-2) , "Unit kg^3.1 TH^-2")
    ]
    return examples
end

function simpleQuantityPrettyPrinting()
    examples = _getSimpleQuantityExamples()
    return _verifyPrettyPrintingImplemented(examples)
end

function _getSimpleQuantityExamples()
    ucat = UnitCatalogue()
    unit = (ucat.kilo * ucat.gram)^pi * (ucat.tera * ucat.henry)^(-2)

    int = 712
    float = 4.345193
    complex = 1 + 3im
    array = [1 2; 3.4 5]
    typeofArray = typeof(array)

    examples = [
        # integer
        ( SimpleQuantity( int, unit ), "712 kg^3.1 TH^-2" ),
        # float
        ( SimpleQuantity( float, unit ), "4.345193 kg^3.1 TH^-2" ),
        # complex
        ( SimpleQuantity( complex, unit ), "1 + 3im kg^3.1 TH^-2" ),
        # array
        ( SimpleQuantity( array, unit ), "SimpleQuantity{$typeofArray} of unit kg^3.1 TH^-2" )
    ]
end

end # module
