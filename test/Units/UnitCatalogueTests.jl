module UnitCatalogueTests

using Alicorn
using Alicorn.Utils
using Alicorn.Exceptions
using Test
using ..TestingTools

function run()
    @testset "UnitCatalogue" begin
        canInstanciateUnitCatalogue()
        test_UnitCatalogue_errorsOnDuplicateUnitElementNames()

        test_listUnitPrefixes()
        test_listBaseUnits()

        test_listUnitPrefixNames()
        test_listBaseUnitNames()

        test_providesUnitPrefix()
        test_providesBaseUnit()

        test_getproperty()
        test_propertynames()
        test_propertynames_errorsOnUnknownUnitElement()

        canInstanciateEmptyUnitCatalogue()

        canInstanciateDefaultUnitCatalogue()
        defaultDefinitionsImplemented()

        test_add!_forUnitPrefix()
        test_add!_forBaseUnit()
        test_add!_errorsOnDuplicates()
        test_remove!()
    end
end

function canInstanciateUnitCatalogue()
    pass = false
    try
        TestingTools.initializeTestUnitCatalogue()
        pass = true
    catch
    end
    @test pass
end

function test_UnitCatalogue_errorsOnDuplicateUnitElementNames()
    examples = _getExamplesFor_UnitCatalogue_errorsOnDuplicateUnitElementNames()
    _testExamples_UnitCatalogue_errorsOnDuplicateUnitElementNames(examples)
end

function _getExamplesFor_UnitCatalogue_errorsOnDuplicateUnitElementNames()
    unitPrefixes = TestingTools.getUnitPrefixTestSet()
    baseUnits = TestingTools.getBaseUnitTestSet()
    randomUnitPrefix = TestingTools.getRandomUnitPrefix()
    randomBaseUnit = TestingTools.getRandomBaseUnit()

    usedPrefixName = randomUnitPrefix.name
    usedBaseUnitName = randomBaseUnit.name

    prefix_prefix_double = randomUnitPrefix
    baseUnit_baseUnit_double = randomBaseUnit

    prefix_baseUnit_double = UnitPrefix(
        name=usedBaseUnitName,
        symbol="t",
        value=1
    )
    baseUnit_prefix_double = BaseUnit(
        name=usedPrefixName,
        symbol="t",
        prefactor=1,
        exponents=BaseUnitExponents()
    )

    examples = [
    ([ unitPrefixes; prefix_prefix_double ], baseUnits),
    ([ unitPrefixes; prefix_baseUnit_double ], baseUnits),
    (unitPrefixes, [baseUnits; baseUnit_baseUnit_double] ),
    (unitPrefixes, [baseUnits; baseUnit_prefix_double] )
    ]

    return examples
end

function _testExamples_UnitCatalogue_errorsOnDuplicateUnitElementNames(examples::Vector)
    for (unitPrefixes, baseUnits) in examples
        @test_throws Exceptions.DublicationError("names of unit elements have to be unique") UnitCatalogue(unitPrefixes, baseUnits)
    end
end

function test_listUnitPrefixes()
    ucat = TestingTools.initializeTestUnitCatalogue()
    unitPrefixTestCatalogue = _getUnitPrefixTestCatalogue()
    returnedUnitPrefixCatalogue = listUnitPrefixes(ucat)
    @test _cataloguesAreIdentical(unitPrefixTestCatalogue, returnedUnitPrefixCatalogue)
end

function _getUnitPrefixTestCatalogue()
    unitPrefixTestSet = TestingTools.getUnitPrefixTestSet()
    unitPrefixTestCatalogue = _generateUnitElementCatalogueFromSet(unitPrefixTestSet)
    return unitPrefixTestCatalogue
end

function _generateUnitElementCatalogueFromSet(unitElementSet::Vector{T}) where T <: UnitElement
    names = _getUnitElementNamesFrom(unitElementSet)
    catalogue = Dict( zip(names, unitElementSet) )
end

function _getUnitElementNamesFrom(unitElements::Array{T}) where T <: UnitElement
    nrOfElements = length(unitElements)
    unitElementNames = Array{String}(undef, nrOfElements)
    for (index, element) in enumerate(unitElements)
        unitElementNames[index] = element.name
    end
    return unitElementNames
end

function _cataloguesAreIdentical(cat1::Dict{String,T}, cat2::Dict{String,T}) where T <: UnitElement
    return TestingTools.dictsAreIdentical(cat1, cat2)
end

function test_listBaseUnits()
    ucat = TestingTools.initializeTestUnitCatalogue()
    baseUnitTestCatalogue = _getBaseUnitTestCatalogue()
    returnedBaseUnitCatalogue = listBaseUnits(ucat)
    @test _cataloguesAreIdentical(baseUnitTestCatalogue, returnedBaseUnitCatalogue)
end

function _getBaseUnitTestCatalogue()
    baseUnitTestSet = TestingTools.getBaseUnitTestSet()
    baseUnitTestCatalogue = _generateUnitElementCatalogueFromSet(baseUnitTestSet)
    return baseUnitTestCatalogue
end

function test_listUnitPrefixNames()
    ucat = TestingTools.initializeTestUnitCatalogue()
    unitPrefixNames = _getUnitPrefixTestNames()
    returnedUnitPrefixNames = listUnitPrefixNames(ucat)
    @test returnedUnitPrefixNames == unitPrefixNames
end

function _getUnitPrefixTestNames()
    unitPrefixTestSet = TestingTools.getUnitPrefixTestSet()
    unitPrefixNames = _getUnitElementNamesFrom(unitPrefixTestSet)
    sort!(unitPrefixNames)
    return unitPrefixNames
end

function test_listBaseUnitNames()
    ucat = TestingTools.initializeTestUnitCatalogue()
    baseUnitNames = _getBaseUnitTestNames()
    returnedBaseUnitNames = listBaseUnitNames(ucat)
    @test returnedBaseUnitNames == baseUnitNames
end

function _getBaseUnitTestNames()
    baseUnitTestSet = TestingTools.getBaseUnitTestSet()
    baseUnitNames = _getUnitElementNamesFrom(baseUnitTestSet)
    sort!(baseUnitNames)
    return baseUnitNames
end

function test_providesUnitPrefix()
    ucat = TestingTools.initializeTestUnitCatalogue()
    examples = _getExamplesFor_providesUnitPrefix()
    _testExamplesFor_providesUnitPrefix(ucat, examples)
end

function _getExamplesFor_providesUnitPrefix()
    negativeExample = [("nonsense", false)]

    prefixTestNames = _getUnitPrefixTestNames()
    nrOfTestNames = length(prefixTestNames)
    positiveExamples = Array{Tuple{String, Bool}}(undef, nrOfTestNames)
    for (index, name) in enumerate(prefixTestNames)
        positiveExamples[index] = (name, true)
    end
    examples = [negativeExample; positiveExamples]
end

function _testExamplesFor_providesUnitPrefix(ucat::UnitCatalogue, examples::Array{Tuple{String, Bool}})
    functionToTest(prefixName) = providesUnitPrefix(ucat, prefixName)
    return TestingTools.verifyFunctionWorksAsExpected(functionToTest, examples)
end

function test_providesBaseUnit()
    ucat = TestingTools.initializeTestUnitCatalogue()
    examples = _getExamplesFor_providesBaseUnit()
    @test _testExamplesFor_providesBaseUnit(examples, ucat)
end

function _getExamplesFor_providesBaseUnit()
    negativeExample = [("nonsense", false)]

    baseUnitTestNames = _getBaseUnitTestNames()
    nrOfTestNames = length(baseUnitTestNames)
    positiveExamples = Array{Tuple{String, Bool}}(undef, nrOfTestNames)
    for (index, name) in enumerate(baseUnitTestNames)
        positiveExamples[index] = (name, true)
    end
    examples = [negativeExample; positiveExamples]
end

function _testExamplesFor_providesBaseUnit(examples::Array{Tuple{String, Bool}}, ucat::UnitCatalogue)
    functionToTest(baseUnitName) = providesBaseUnit(ucat, baseUnitName)
    return TestingTools.verifyFunctionWorksAsExpected(functionToTest, examples)
end

function test_getproperty()
    ucat = TestingTools.initializeTestUnitCatalogue()
    unitElementNames = _getAllUnitElementNamesFromTestSets()
    pass = _canAccessUnitElementsWith_getproperty(ucat, unitElementNames)
    @test pass
end

function _getAllUnitElementNamesFromTestSets()
    unitPrefixTestSet = TestingTools.getUnitPrefixTestSet()
    unitPrefixNames =  _getUnitElementNamesFrom(unitPrefixTestSet)

    baseUnitTestSet = TestingTools.getBaseUnitTestSet()
    baseUnitNames = _getUnitElementNamesFrom(baseUnitTestSet)

    allNames = vcat(unitPrefixNames, baseUnitNames)
end

function _canAccessUnitElementsWith_getproperty(ucat::UnitCatalogue, unitElementNames::Vector{String})
    pass = false
    try
        _accessAllWith_getproperty(ucat::UnitCatalogue, unitElementNames::Vector{String})
        pass = true
    catch
    end
    return pass
end

function _accessAllWith_getproperty(ucat::UnitCatalogue, unitElementNames::Vector{String})
    for name in unitElementNames
        getproperty(ucat, Symbol(name))
    end
end

function test_propertynames()
    ucat = TestingTools.initializeTestUnitCatalogue()
    correctPropertySymbols = _getCorrectPropertySymbols(ucat)
    returnedPropertySymbols = Base.propertynames(ucat)
    @test (returnedPropertySymbols == correctPropertySymbols)
end

function _getCorrectPropertySymbols(ucat::UnitCatalogue)
    unitElementNames = _getAllUnitElementNamesFromTestSets()
    unitElementNames = sort!(unitElementNames)

    nrOfProperties = length(unitElementNames)
    correctPropertySymbols = Array{Symbol}(undef,nrOfProperties)
    for (index, unitElementName) in enumerate(unitElementNames)
        correctPropertySymbols[index] = Symbol(unitElementName)
    end
    return correctPropertySymbols
end

function test_propertynames_errorsOnUnknownUnitElement()
    ucat = TestingTools.initializeTestUnitCatalogue()
    @test_throws KeyError("nonsense") ucat.nonsense
    @test_throws KeyError("prefixCatalogue") ucat.prefixCatalogue
end

function canInstanciateEmptyUnitCatalogue()
    ucat = UnitCatalogue( [], [] )
    @test isempty(listUnitPrefixes(ucat)) && isempty(listBaseUnits(ucat))
end

function canInstanciateDefaultUnitCatalogue()
    pass = false
    # try
        ucat = UnitCatalogue()
        pass = true
    # catch
    # end
    @test pass
end

function defaultDefinitionsImplemented()
    defaultUcat = UnitCatalogue()
    prefixesImplemented = _checkIfDefaultUnitPrefixesImplemented(defaultUcat)
    baseUnitsImplemented = _checkIfDefaultBaseUnitsImplemented(defaultUcat)
    emptyPrefixImplemented = _checkIfEmptyUnitPrefixImplemented(defaultUcat)
    unitlessBaseUnitImplemented = _checkIfUnitlessBaseUnitImplemented(defaultUcat)
    @test prefixesImplemented && baseUnitsImplemented && emptyPrefixImplemented && unitlessBaseUnitImplemented
end

function _checkIfDefaultUnitPrefixesImplemented(defaultUcat::UnitCatalogue)
    defaultUnitPrefixes = _getDefaultUnitPrefixes()
    return _canCallAllUnitElements(defaultUcat, defaultUnitPrefixes)
end

function _getDefaultUnitPrefixes()
    predefinedPrefixes = [
    UnitPrefix(name="yotta", symbol="Y", value=1e+24),
    UnitPrefix(name="zetta", symbol="Z", value=1e+21),
    UnitPrefix(name="exa", symbol="E", value=1e+18),
    UnitPrefix(name="peta", symbol="P", value=1e+15),
    UnitPrefix(name="tera", symbol="T", value=1e+12),
    UnitPrefix(name="giga", symbol="G", value=1e+9),
    UnitPrefix(name="mega", symbol="M", value=1e+6),
    UnitPrefix(name="kilo", symbol="k", value=1e+3),
    UnitPrefix(name="hecto", symbol="h", value=1e+2),
    UnitPrefix(name="deca", symbol="da", value=1e+1),
    UnitPrefix(name="deci", symbol="d", value=1e-1),
    UnitPrefix(name="centi", symbol="c", value=1e-2),
    UnitPrefix(name="milli", symbol="m", value=1e-3),
    UnitPrefix(name="micro", symbol="μ", value=1e-6),
    UnitPrefix(name="nano", symbol="n", value=1e-9),
    UnitPrefix(name="pico", symbol="p", value=1e-12),
    UnitPrefix(name="femto", symbol="f", value=1e-15),
    UnitPrefix(name="atto", symbol="a", value=1e-18),
    UnitPrefix(name="zepto", symbol="z", value=1e-21),
    UnitPrefix(name="yocto", symbol="y", value=1e-24)
    ]
    return predefinedPrefixes
end

function _canCallAllUnitElements(ucat::UnitCatalogue, unitElements::Vector{T}) where T <: UnitElement
    pass = true
    for element in unitElements
        pass &= _canCallUnitElement(ucat, element)
    end
    return pass
end

function _canCallUnitElement(ucat::UnitCatalogue, unitElement::UnitElement)
    try
        elementSymbol = Symbol(unitElement.name)
        return getproperty(ucat, elementSymbol) === unitElement
    catch
        return false
    end
end

function _checkIfDefaultBaseUnitsImplemented(defaultUcat::UnitCatalogue)
    defaultBaseUnits = _getDefaultBaseUnits()
    return _canCallAllUnitElements(defaultUcat, defaultBaseUnits)
end

function _getDefaultBaseUnits()
    defaultBaseUnits = [
        # basic units
        BaseUnit(name="gram", symbol="g", prefactor=1e-3, exponents=BaseUnitExponents(kg=1)),
        BaseUnit(name="meter", symbol="m", prefactor=1, exponents=BaseUnitExponents(m=1)),
        BaseUnit(name="second", symbol="s", prefactor=1, exponents=BaseUnitExponents(s=1)),
        BaseUnit(name="ampere", symbol="A", prefactor=1, exponents=BaseUnitExponents(A=1)),
        BaseUnit(name="kelvin", symbol="K", prefactor=1, exponents=BaseUnitExponents(K=1)),
        BaseUnit(name="mol", symbol="mol", prefactor=1, exponents=BaseUnitExponents(mol=1)),
        BaseUnit(name="candela", symbol="cd", prefactor=1, exponents=BaseUnitExponents(cd=1)),
        # coherent units
        BaseUnit(name="hertz", symbol="Hz", prefactor=1, exponents=BaseUnitExponents(s=-1)),
        BaseUnit(name="radian", symbol="rad", prefactor=1, exponents=BaseUnitExponents()),
        BaseUnit(name="steradian", symbol="sr", prefactor=1, exponents=BaseUnitExponents()),
        BaseUnit(name="newton", symbol="N", prefactor=1, exponents=BaseUnitExponents(kg=1, m=1, s=-2)),
        BaseUnit(name="pascal", symbol="Pa", prefactor=1, exponents=BaseUnitExponents(kg=1, m=-1, s=-2)),
        BaseUnit(name="joule", symbol="J", prefactor=1, exponents=BaseUnitExponents(kg=1, m=2, s=-2)),
        BaseUnit(name="watt", symbol="W", prefactor=1, exponents=BaseUnitExponents(kg=1, m=2, s=-3)),
        BaseUnit(name="coulomb", symbol="C", prefactor=1, exponents=BaseUnitExponents(s=1, A=1)),
        BaseUnit(name="volt", symbol="V", prefactor=1, exponents=BaseUnitExponents(kg=1, m=2, s=-3, A=-1)),
        BaseUnit(name="farad", symbol="F", prefactor=1, exponents=BaseUnitExponents(kg=-1, m=-2, s=4, A=2)),
        BaseUnit(name="ohm", symbol="Ω", prefactor=1, exponents=BaseUnitExponents(kg=1, m=2, s=-3, A=-2)),
        BaseUnit(name="siemens", symbol="S", prefactor=1, exponents=BaseUnitExponents(kg=-1, m=-2, s=3, A=2)),
        BaseUnit(name="weber", symbol="W", prefactor=1, exponents=BaseUnitExponents(kg=1, m=2, s=-2, A=-1)),
        BaseUnit(name="tesla", symbol="T", prefactor=1, exponents=BaseUnitExponents(kg=1, s=-2, A=-1)),
        BaseUnit(name="henry", symbol="H", prefactor=1, exponents=BaseUnitExponents(kg=1, m=2, s=-2, A=-2)),
        BaseUnit(name="degreeCelsius", symbol="°C", prefactor=1, exponents=BaseUnitExponents(K=1)),
        BaseUnit(name="lumen", symbol="lm", prefactor=1, exponents=BaseUnitExponents(cd=1)),
        BaseUnit(name="lux", symbol="lx", prefactor=1, exponents=BaseUnitExponents(m=-2, cd=1)),
        BaseUnit(name="becquerel", symbol="Bq", prefactor=1, exponents=BaseUnitExponents(s=-1)),
        BaseUnit(name="gray", symbol="Gy", prefactor=1, exponents=BaseUnitExponents(m=2, s=-2)),
        BaseUnit(name="sievert", symbol="Sv", prefactor=1, exponents=BaseUnitExponents(m=2, s=-2)),
        BaseUnit(name="katal", symbol="kat", prefactor=1, exponents=BaseUnitExponents(s=-1, mol=1)),
        # accepted units
        BaseUnit(name="minute", symbol="min", prefactor=60, exponents=BaseUnitExponents(s=1)),
        BaseUnit(name="hour", symbol="h", prefactor=3600, exponents=BaseUnitExponents(s=1)),
        BaseUnit(name="day", symbol="d", prefactor=86400, exponents=BaseUnitExponents(s=1)),
        BaseUnit(name="day", symbol="d", prefactor=86400, exponents=BaseUnitExponents(s=1)),
        BaseUnit(name="astronomicalUnit", symbol="au", prefactor=149597870700, exponents=BaseUnitExponents(m=1)),
        BaseUnit(name="degree", symbol="°", prefactor=pi/180, exponents=BaseUnitExponents()),
        BaseUnit(name="arcminute", symbol="'", prefactor=pi/10800, exponents=BaseUnitExponents()),
        BaseUnit(name="arcsecond", symbol="\"", prefactor=pi/648000, exponents=BaseUnitExponents()),
        BaseUnit(name="hectare", symbol="ha", prefactor=10000, exponents=BaseUnitExponents(m=2)),
        BaseUnit(name="liter", symbol="l", prefactor=0.001, exponents=BaseUnitExponents(m=3)),
        BaseUnit(name="tonne", symbol="t", prefactor=1000, exponents=BaseUnitExponents(kg=1)),
        BaseUnit(name="dalton", symbol="Da", prefactor=1.66053906660e-27, exponents=BaseUnitExponents(kg=1)),
        BaseUnit(name="electronvolt", symbol="eV", prefactor=1.602176634e-19, exponents=BaseUnitExponents(kg=1, m=2, s=-2))
    ]
    return defaultBaseUnits
end

function _checkIfEmptyUnitPrefixImplemented(defaultUcat::UnitCatalogue)
    emptyUnitPrefixImplemented = false
    try
        emptyUnitPrefixImplemented = (defaultUcat.empty == Alicorn.emptyUnitPrefix)
    catch
    end
    return emptyUnitPrefixImplemented
end


function _checkIfUnitlessBaseUnitImplemented(defaultUcat::UnitCatalogue)
    unitlessBaseUnitImplemented = false
    # try
        unitlessBaseUnitImplemented = (defaultUcat.unitless == Alicorn.unitlessBaseUnit)
    # catch
    # end
    return unitlessBaseUnitImplemented
end

function test_add!_forUnitPrefix()
    emptyUcat = UnitCatalogue([], [])
    testUnitPrefix = TestingTools.generateRandomUnitPrefix()
    _test_add!_forUnitElement(emptyUcat, testUnitPrefix)
end

function _test_add!_forUnitElement(ucat::UnitCatalogue, unitElement::T) where T <: UnitElement
    add!(ucat, unitElement)
    @test _checkIfAdditionSuccessful(ucat, unitElement)
end

function _checkIfAdditionSuccessful(ucat::UnitCatalogue, unitElement::T) where T <: UnitElement
    elementSymbol = Symbol(unitElement.name)
    additionSuccessful = false
    try
        additionSuccessful = ( getproperty(ucat, elementSymbol) == unitElement )
    catch
    end
    return additionSuccessful
end

function test_add!_forBaseUnit()
    emptyUcat = UnitCatalogue([], [])
    testBaseUnit = TestingTools.generateRandomBaseUnit()
    _test_add!_forUnitElement(emptyUcat, testBaseUnit)
end

function test_add!_errorsOnDuplicates()
    examples = _getExamplesFor_add!_errorsOnDuplicate()
    _testExamplesFor_add!_errorsOnDuplicate(examples)
    # @test_throws Exceptions.DublicationError("catalogue already contains an element \"nano\"") add!(ucat, unitPrefix)
end

function _getExamplesFor_add!_errorsOnDuplicate()
    testPrefix = UnitPrefix(name="test", symbol="t", value=1)
    testBaseUnit = BaseUnit(name="test", symbol="t", prefactor=1, exponents=BaseUnitExponents())

    examples = [
    (testPrefix, testPrefix),
    (testBaseUnit, testBaseUnit),
    (testPrefix, testBaseUnit),
    (testBaseUnit, testPrefix),
    ]
    return examples
end

function _testExamplesFor_add!_errorsOnDuplicate(examples::Vector)
    for (el1, el2) in examples
        ucat = TestingTools.initializeTestUnitCatalogue()
        add!(ucat, el1)
        @test_throws Exceptions.DublicationError("catalogue already contains an element \"$(el1.name)\"") add!(ucat, el2)
    end
end

function test_remove!()
    ucat = TestingTools.initializeTestUnitCatalogue()
    @test _test_remove!_forUnitPrefix(ucat)
    @test _test_remove!_forBaseUnit(ucat)
end

function _test_remove!_forUnitPrefix(ucat::UnitCatalogue)
    initialPrefixes = listUnitPrefixNames(ucat)

    examplePrefixName = listUnitPrefixNames(ucat)[1]
    remove!(ucat, examplePrefixName)

    remainingPrefixes = listUnitPrefixNames(ucat)
    removalSuccessful = !( Utils.isElementOf(examplePrefixName, remainingPrefixes) )

    expectedRemainingPrefixes = deleteat!(initialPrefixes, 1)
    noSideEffects = (remainingPrefixes == expectedRemainingPrefixes)

    success = removalSuccessful && noSideEffects
    return success
end

function _test_remove!_forBaseUnit(ucat::UnitCatalogue)
    initialBaseUnit = listBaseUnitNames(ucat)

    exampleBaseUnitName = listBaseUnitNames(ucat)[1]
    remove!(ucat, exampleBaseUnitName)

    remainingBaseUnits = listBaseUnitNames(ucat)
    removalSuccessful = !( Utils.isElementOf(exampleBaseUnitName, remainingBaseUnits) )

    expectedRemainingBaseUnits = deleteat!(initialBaseUnit, 1)
    noSideEffects = (remainingBaseUnits == expectedRemainingBaseUnits)

    success = removalSuccessful && noSideEffects
    return success
end

end # module
