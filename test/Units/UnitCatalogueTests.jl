module UnitCatalogueTests

using Alicorn
using Alicorn.Utils
using Alicorn.Exceptions
using Test

function run()
    @testset "UnitCatalogue" begin
        @test canInstanciateUnitCatalogue()
        @test canCallAllBasicPrefixes()

        @test canListKnownPrefixes()
        errorsOnUnknownUnitElement()
        @test providesUnitPrefixTest()
        @test propertynames()

        @test prettyPrinting()

        @test remove!Test()
        @test addUnitPrefix!Test()
        addUnitPrefix!ErrorsOnDuplicates()
    end
end

function canInstanciateUnitCatalogue()
    try
        ucat = UnitCatalogue()
        return true
    catch
        return false
    end
end

function canCallAllBasicPrefixes()
    basicPrefixes = _getBasicPrefixes()
    return _canCallAllPrefixes(basicPrefixes)
end

function _getBasicPrefixes()
    basicPrefixes = [
    UnitPrefix(name="yotta",symbol="Y",value=1e+24),
    UnitPrefix(name="zetta",symbol="Z",value=1e+21),
    UnitPrefix(name="exa",symbol="E",value=1e+18),
    UnitPrefix(name="peta",symbol="P",value=1e+15),
    UnitPrefix(name="tera",symbol="T",value=1e+12),
    UnitPrefix(name="giga",symbol="G",value=1e+9),
    UnitPrefix(name="mega",symbol="M",value=1e+6),
    UnitPrefix(name="kilo",symbol="k",value=1e+3),
    UnitPrefix(name="hecto",symbol="h",value=1e+2),
    UnitPrefix(name="deca",symbol="da",value=1e+1),
    UnitPrefix(name="deci",symbol="d",value=1e-1),
    UnitPrefix(name="centi",symbol="c",value=1e-2),
    UnitPrefix(name="milli",symbol="m",value=1e-3),
    UnitPrefix(name="micro",symbol="μ",value=1e-6),
    UnitPrefix(name="nano",symbol="n",value=1e-9),
    UnitPrefix(name="pico",symbol="p",value=1e-12),
    UnitPrefix(name="femto",symbol="f",value=1e-15),
    UnitPrefix(name="atto",symbol="a",value=1e-18),
    UnitPrefix(name="zepto",symbol="z",value=1e-21),
    UnitPrefix(name="yocto",symbol="y",value=1e-24)
    ]
    return basicPrefixes
end

function _canCallAllPrefixes(basicPrefixes::Vector{UnitPrefix})
    ucat = UnitCatalogue()
    pass = true
    for prefix in basicPrefixes
        pass &= _canCallPrefix(ucat,prefix)
    end
    return pass
end

function _canCallPrefix(ucat::UnitCatalogue, prefix::UnitPrefix)
    try
        prefixSymbol = Symbol(prefix.name)
        return getproperty(ucat,prefixSymbol) === prefix
    catch
        return false
    end
end

function canListKnownPrefixes()
    ucat = UnitCatalogue()
    correctKnownPrefixes = _listBasicPrefixNames()
    returnedKnownPrefixes = listUnitPrefixes(ucat)
    return returnedKnownPrefixes == correctKnownPrefixes
end

function _listBasicPrefixNames()
    basicPrefixes = _getBasicPrefixes()

    nrOfBasicPrefixes = length(basicPrefixes)
    basicPrefixNames = Array{String}(undef,nrOfBasicPrefixes)
    for (index, prefix) in enumerate(basicPrefixes)
        basicPrefixNames[index] = prefix.name
    end

    return sort!(basicPrefixNames)
end

function errorsOnUnknownUnitElement()
    ucat = UnitCatalogue()
    @test_throws KeyError("nonsense") ucat.nonsense
    @test_throws KeyError("prefixCatalogue") ucat.prefixCatalogue
end

function providesUnitPrefixTest()
    ucat = UnitCatalogue()
    examples = _getProvidesUnitPrefixExamples()
    return _checkProvidesUnitPrefixExamplesImplemented(examples, ucat)
end

function _getProvidesUnitPrefixExamples()
    examples = [
    ("nano",true),
    ("zepto",true),
    ("nonsense",false)
    ]
end

function _checkProvidesUnitPrefixExamplesImplemented(examples::Array{Tuple{String,Bool}}, ucat::UnitCatalogue)
    correct = true
    for (name,correctResult) in examples
        returnedResult = providesUnitPrefix(ucat, name)
        correct &= (returnedResult == correctResult)
    end
    return correct
end

function propertynames()
    ucat = UnitCatalogue()
    correctPropertySymbols = _getCorrectPropertyNames(ucat)
    returnedPropertySymbols = Base.propertynames(ucat)
    return (returnedPropertySymbols == correctPropertySymbols)
end

function _getCorrectPropertyNames(ucat::UnitCatalogue)
    prefixNames = _listBasicPrefixNames()
    nrOfProperties = length(prefixNames)
    correctPropertySymbols = Array{Symbol}(undef,nrOfProperties)
    for (index,prefixName) in enumerate(prefixNames)
        correctPropertySymbols[index] = Symbol(prefixName)
    end
    return correctPropertySymbols
end

function prettyPrinting()
    ucat = UnitCatalogue()
    correctPrettyString = _getCorrectPrettyString(ucat)
    returnedPrettyString = _getGeneratedPrettyPrintingString(ucat)
    return (returnedPrettyString == correctPrettyString)
end

function _getCorrectPrettyString(ucat::UnitCatalogue)
    nrOfUnitPrefixes = length(_listBasicPrefixNames())
    prettyString = "UnitCatalogue providing\n\t$nrOfUnitPrefixes unit prefixes"
    return prettyString
end

function _getGeneratedPrettyPrintingString(ucat::UnitCatalogue)
    io = IOBuffer()
    show(io,ucat)
    generatedString = String(take!(io))
    return generatedString
end

function remove!Test()
    ucat = UnitCatalogue()
    remove!(ucat,"nano")
    remainingPrefixes = listUnitPrefixes(ucat)
    removalSuccessful = !(Utils.isElementOf("nano",remainingPrefixes))
    return removalSuccessful
end

function addUnitPrefix!Test()
    ucat = UnitCatalogue()
    unitPrefix = UnitPrefix(name="test",symbol="t",value=2e-2)
    add!(ucat,unitPrefix)
    additionSuccessful = ucat.test == unitPrefix
    return additionSuccessful
end

function addUnitPrefix!ErrorsOnDuplicates()
    ucat = UnitCatalogue()
    unitPrefix = UnitPrefix(name="nano",symbol="t",value=2e-2)
    @test_throws Exceptions.DublicationError("catalogue already contains an element \"nano\"") add!(ucat,unitPrefix)
end

end # module
