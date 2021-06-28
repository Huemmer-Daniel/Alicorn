module TestingTools

using Alicorn
using Random

function getInfiniteNumbers()
    return [ Inf, -Inf, Inf64, Inf32, Inf16, NaN, NaN64, NaN32, NaN16 ]
end

function generateRandomUnitPrefix()
    (randomPrefix,) = generateRandomUnitPrefixWithFields()
    return randomPrefix
end

function generateRandomUnitPrefixWithFields()
    randomFields = generateRandomUnitPrefixFields()
    randomPrefix = UnitPrefix(
        name = randomFields["name"],
        symbol = randomFields["symbol"],
        value = randomFields["value"]
    )
    return (randomPrefix, randomFields)
end

function generateRandomUnitPrefixFields()
    randomFields = Dict{String,Any}()
    randomFields["name"] = generateRandomName()
    randomFields["symbol"] = generateRandomSymbol()
    randomFields["value"] = abs(generateRandomReal())
    return randomFields
end

function generateRandomName()
    return Random.randstring(['a':'z';'A':'Z'],12)
end

function generateRandomSymbol()
    return Random.randstring(['a':'z';'A':'Z'],2)
end

function generateRandomReal(; dim = 1)
    if dim == 1
        randReal = rand(Float64)
    else
        randReal = rand(Float64, dim)
    end
    return  20 .* randReal .- 10
end

function generateRandomNonzeroReal(; dim = 1)
    randomReal = 0
    while prod(randomReal) == 0
        randomReal = generateRandomReal(dim=dim)
    end
    return randomReal
end

function generateRandomComplex(; dim = 1)
    realPart = generateRandomReal(dim = dim)
    imagPart = generateRandomReal(dim = dim)
    return realPart + im .* imagPart
end

function generateRandomNonzeroComplex(; dim = 1)
    randomComplex = 0
    while prod(randomComplex) == 0
        randomComplex = generateRandomComplex(dim=dim)
    end
    return randomComplex
end

function generateRandomExponent(; dim = 1)
    randomExponent = generateRandomReal(dim=dim)
    randomExponent = Alicorn.Utils.tryCastingToInt(randomExponent)
    return randomExponent
end

function generateRandomBaseUnitExponents()
    (randomBaseUnitExponents,) =  generateRandomBaseUnitExponentsWithFields()
    return randomBaseUnitExponents
end

function generateRandomBaseUnitExponentsWithFields()
    randomFields = generateRandomBaseUnitExponentsFields()
    randomBaseUnitExp = BaseUnitExponents(
        kg = randomFields["kg"],
        m = randomFields["m"],
        s = randomFields["s"],
        A = randomFields["A"],
        K = randomFields["K"],
        mol = randomFields["mol"],
        cd = randomFields["cd"]
    )
    return (randomBaseUnitExp, randomFields)
end

function generateRandomBaseUnitExponentsFields()
    coreSIUnits = _getCoreSIUnits()
    randExponents = generateRandomExponent(dim = 7)
    return Dict( zip(coreSIUnits, randExponents) )
end

function _getCoreSIUnits()
    return ["kg", "m", "s", "A", "K", "mol", "cd"]
end

function generateRandomBaseUnit()
    (randomBaseUnit,) = generateRandomBaseUnitWithFields()
    return randomBaseUnit
end

function generateRandomBaseUnitWithFields()
    randomFields = generateRandomBaseUnitFields()
    baseUnit = BaseUnit(
        name = randomFields["name"],
        symbol = randomFields["symbol"],
        prefactor = randomFields["prefactor"],
        exponents = randomFields["exponents"]
    )
    return (baseUnit, randomFields)
end

function generateRandomBaseUnitFields()
    randomFields = Dict{String,Any}()
    randomFields["name"] = generateRandomName()
    randomFields["symbol"] = generateRandomSymbol()
    randomFields["prefactor"] = abs(generateRandomReal())
    exponents = generateRandomBaseUnitExponents()
    randomFields["exponents"] = exponents
    return randomFields
end

function getInvalidUnitElementNamesTestset()
    return ["test test", "test-test", "test?test", "}"]
end

function dictsAreIdentical(dict1::Dict, dict2::Dict)
    sameType = ( typeof(dict1) == typeof(dict2) )
    if !sameType
        return false
    end

    keysMatch = ( keys(dict1) == keys(dict2) )
    if !keysMatch
        return false
    end

    valuesMatch = true
    for key in keys(dict1)
        valuesMatch &= ( dict1[key] == dict2[key] )
    end
    return valuesMatch
end

function testMonadicFunction(func, examples::Array)
    correct = true
    for (input, correctOutput) in examples
        returnedOutput = func(input)
        correct &= (returnedOutput == correctOutput)
    end
    return correct
end

function testDyadicFunction(func, examples::Array)
    correct = true
    for (input1, input2, correctOutput) in examples
        returnedOutput = func(input1, input2)
        correct &= (returnedOutput == correctOutput)
    end
    return correct
end

function testDyadicFunction_Splat2ndArgs(func, examples::Array)
    correct = true
    for (input1, input2, correctOutput) in examples
        returnedOutput = func(input1, input2...)
        correct &= (returnedOutput == correctOutput)
    end
    return correct
end

function initializeTestUnitCatalogue()
    unitPrefixes = getUnitPrefixTestSet()
    baseUnits = getBaseUnitTestSet()
    ucat = UnitCatalogue(unitPrefixes, baseUnits)
    return ucat
end

function getUnitPrefixTestSet()
    unitPrefixTestSet = [
        UnitPrefix(name="yotta", symbol="Y", value=1e+24),
        UnitPrefix(name="zetta", symbol="Z", value=1e+21),
        UnitPrefix(name="milli", symbol="m", value=1e-3),
        UnitPrefix(name="micro", symbol="μ", value=1e-6),
        UnitPrefix(name="nano", symbol="n", value=1e-9),
        UnitPrefix(name="pico", symbol="p", value=1e-12),
        UnitPrefix(name="femto", symbol="f", value=1e-15),
        UnitPrefix(name="atto", symbol="a", value=1e-18),
        UnitPrefix(name="zepto", symbol="z", value=1e-21),
        UnitPrefix(name="yocto", symbol="y", value=1e-24)
    ]
    return unitPrefixTestSet
end

function getRandomUnitPrefix()
    prefixTestSet = getUnitPrefixTestSet()
    testSetSize = length(prefixTestSet)
    randomIndex = rand(1:testSetSize)
    randomPrefix = prefixTestSet[randomIndex]
    return randomPrefix
end

function getBaseUnitTestSet()
    baseUnitTestSet = [
        BaseUnit(name="gram", symbol="g", prefactor=1e-3, exponents=BaseUnitExponents(kg=1)),
        BaseUnit(name="meter", symbol="m", prefactor=1, exponents=BaseUnitExponents(m=1)),
        BaseUnit(name="hertz", symbol="Hz", prefactor=1, exponents=BaseUnitExponents(s=-1)),
        BaseUnit(name="radian", symbol="rad", prefactor=1, exponents=BaseUnitExponents()),
        BaseUnit(name="steradian", symbol="sr", prefactor=1, exponents=BaseUnitExponents()),
        BaseUnit(name="newton", symbol="N", prefactor=1, exponents=BaseUnitExponents(kg=1, m=1, s=-2)),
        BaseUnit(name="pascal", symbol="Pa", prefactor=1, exponents=BaseUnitExponents(kg=1, m=-1, s=-2)),
        BaseUnit(name="joule", symbol="J", prefactor=1, exponents=BaseUnitExponents(kg=1, m=2, s=-2)),
        BaseUnit(name="watt", symbol="W", prefactor=1, exponents=BaseUnitExponents(kg=1, m=2, s=-3))
    ]
    return baseUnitTestSet
end

function getRandomBaseUnit()
    baseUnitTestSet = getBaseUnitTestSet()
    testSetSize = length(baseUnitTestSet)
    randomIndex = rand(1:testSetSize)
    randomBaseUnit = baseUnitTestSet[randomIndex]
    return randomBaseUnit
end

function generateRandomUnitFactor()
    (randomUnitFactor,) = generateRandomUnitFactorWithFields()
    return randomUnitFactor
end

function generateRandomUnitFactors(length::Int)
    randomUnitFactors = Vector{UnitFactor}()
    for index in 1:length
        randomUnitFactor = _generateDifferentRandomUnitFactor(randomUnitFactors)
        randomUnitFactors = vcat(randomUnitFactors, randomUnitFactor)
    end
    return randomUnitFactors
end

function _generateDifferentRandomUnitFactor(randomUnitFactors::Vector{UnitFactor})
    randomUnitFactor = generateRandomUnitFactor()
    while Alicorn.Utils.isElementOf(randomUnitFactor, randomUnitFactors)
        randomUnitFactor = generateRandomUnitFactor()
    end
    return randomUnitFactor
end

function generateRandomUnitFactorWithFields()
    randomFields = generateRandomUnitFactorFields()
    randomUnitFactor = UnitFactor(
        randomFields["unitPrefix"],
        randomFields["baseUnit"],
        randomFields["exponent"]
    )
    return (randomUnitFactor, randomFields)
end

function generateRandomUnitFactorFields()
    randomPrefix = generateRandomUnitPrefix()
    randombaseUnit = generateRandomBaseUnit()
    randomExponent = generateRandomExponent()

    randomFields = Dict{String,Any}()
    randomFields["unitPrefix"] = randomPrefix
    randomFields["baseUnit"] = randombaseUnit
    randomFields["exponent"] = randomExponent
    return randomFields
end

function generateRandomUnit()
    (randomUnit,) = generateRandomUnitWithFields()
    return randomUnit
end

function generateRandomUnitWithFields()
    randomFields = generateRandomUnitFactors(4)
    randomUnit = Unit(randomFields)
    return (randomUnit, randomFields)
end

function generateRandomSimpleQuantity()
    (randomSimpleQuantity,) = generateRandomSimpleQuantityWithFields()
    return randomSimpleQuantity
end

function generateRandomSimpleQuantityWithFields()
    randomValue = generateRandomReal()
    randomUnit = generateRandomUnit()
    randomFields = Dict{String,Any}()
    randomFields["value"] = randomValue
    randomFields["unit"] = randomUnit

    randomSimpleQuantity = SimpleQuantity(randomValue, randomUnit)

    return (randomSimpleQuantity, randomFields)
end

function generateRandomSimpleQuantityArray()
    (randomSimpleQuantityArray,) = generateRandomSimpleQuantityArrayWithFields()
    return randomSimpleQuantityArray
end

function generateRandomSimpleQuantityArrayWithFields()
    randomValues = generateRandomReal(dim=(3,3))
    randomUnit = generateRandomUnit()

    randomFields = Dict{String,Any}()
    randomFields["values"] = randomValues
    randomFields["unit"] = randomUnit

    randomSimpleQuantityArray = SimpleQuantityArray(randomValues, randomUnit)

end

function generateRandomInternalUnits()
    (randomInternalUnits,) = generateRandomInternalUnitsWithFields()
    return randomInternalUnits
end

function generateRandomInternalUnitsWithFields()
    ucat = UnitCatalogue()
    randomMassUnit = generateRandomNonzeroReal() * (ucat.nano * ucat.gram)
    randomLengthUnit = generateRandomNonzeroReal() * (ucat.deci * ucat.meter)
    randomTimeUnit = generateRandomNonzeroReal() * (ucat.milli * ucat.second)
    randomCurrentUnit = generateRandomNonzeroReal() * (ucat.tera * ucat.ampere)
    randomTemperatureUnit = generateRandomNonzeroReal() * (ucat.deca * ucat.kelvin)
    randomAmountUnit = generateRandomNonzeroReal() * (ucat.kilo * ucat.mol)
    randomLuminousIntensityUnit = generateRandomNonzeroReal() * (ucat.micro * ucat.candela)

    randomFields = Dict([
        ("massUnit", randomMassUnit),
        ("lengthUnit", randomLengthUnit),
        ("timeUnit", randomTimeUnit),
        ("currentUnit", randomCurrentUnit),
        ("temperatureUnit", randomTemperatureUnit),
        ("amountUnit", randomAmountUnit),
        ("luminousIntensityUnit", randomLuminousIntensityUnit)
    ])

    randomInternalUnits = InternalUnits(randomMassUnit, randomLengthUnit, randomTimeUnit, randomCurrentUnit, randomTemperatureUnit, randomAmountUnit, randomLuminousIntensityUnit)

    return (randomInternalUnits, randomFields)
end

function generateRandomDimension()
    (randomDimension,) = generateRandomDimenionWithFields()
    return randomDimension
end

function generateRandomDimenionWithFields()
    randomFields = generateRandomDimensionFields()
    randomDimension = Dimension(
        L = randomFields["length"],
        M = randomFields["mass"],
        T = randomFields["time"],
        I = randomFields["current"],
        θ = randomFields["temperature"],
        N = randomFields["amount"],
        J = randomFields["luminousIntensity"]
    )
    return (randomDimension, randomFields)
end

function generateRandomDimensionFields()
    coreDimensions = _getCoreDimensions()
    randExponents = generateRandomExponent(dim = 7)
    return Dict( zip(coreDimensions, randExponents) )
end

function _getCoreDimensions()
    return ["mass", "length", "time", "current", "temperature", "amount", "luminousIntensity"]
end

function generateRandomQuantityWithFields()
    randomFields = generateRandomQuantityFields()
    randomQuantity = Quantity(
        randomFields["value"],
        randomFields["dimension"],
        randomFields["internalUnits"]
    )
    return (randomQuantity, randomFields)
end

function generateRandomQuantityFields()
    randomValue = generateRandomReal()
    randomDimension = generateRandomDimension()
    randomInternalUnits = generateRandomInternalUnits()

    randomFields = Dict([
        ("value", randomValue),
        ("dimension", randomDimension),
        ("internalUnits", randomInternalUnits)
    ])
    return randomFields
end

end # module
