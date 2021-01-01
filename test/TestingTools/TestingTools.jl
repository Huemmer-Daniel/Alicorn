module TestingTools

using Alicorn
using Random

function getInfiniteNumbers()
    return [ Inf, -Inf, Inf64, Inf32, Inf16, NaN, NaN64, NaN32, NaN16 ]
end

function generateRandomPrefix()
    randFields = generateRandomPrefixFields()
    prefix = UnitPrefix(
        name = randFields["name"],
        symbol = randFields["symbol"],
        value = randFields["value"]
    )
    return (prefix, randFields)
end

function generateRandomPrefixFields()
    randFields = Dict{String,Any}()
    randFields["name"] = generateRandomName()
    randFields["symbol"] = generateRandomSymbol()
    randFields["value"] = generateRandomReal()
    return randFields
end

function generateRandomName()
    return Random.randstring(['a':'z';'A':'Z'],12)
end

function generateRandomSymbol()
    return Random.randstring(2)
end

function generateRandomReal(; dim = 1)
    if dim == 1
        randReal = rand(Float64)
    else
        randReal = rand(Float64, dim)
    end
    return  20 * randReal .- 10
end

function generateRandomBaseUnitExponents()
    randFields = generateRandomBaseUnitExponentsFields()
    baseUnitExp = BaseUnitExponents(
        kg = randFields["kg"],
        m = randFields["m"],
        s = randFields["s"],
        A = randFields["A"],
        K = randFields["K"],
        mol = randFields["mol"],
        cd = randFields["cd"]
    )
    return (baseUnitExp, randFields)
end

function generateRandomBaseUnitExponentsFields()
    coreSIUnits = _getCoreSIUnits()
    randExponents = generateRandomReal( dim = 7 )
    return Dict( zip(coreSIUnits, randExponents) )
end

function _getCoreSIUnits()
    return ["kg", "m", "s", "A", "K", "mol", "cd"]
end

function generateRandomBaseUnit()
    randFields = generateRandomBaseUnitFields()
    baseUnit = BaseUnit(
        name = randFields["name"],
        symbol = randFields["symbol"],
        prefactor = randFields["prefactor"],
        exponents = randFields["exponents"]
    )
    return (baseUnit, randFields)
end

function generateRandomBaseUnitFields()
    randFields = Dict{String,Any}()
    randFields["name"] = generateRandomName()
    randFields["symbol"] = generateRandomSymbol()
    randFields["prefactor"] = generateRandomReal()
    (exponents,) = generateRandomBaseUnitExponents()
    randFields["exponents"] = exponents
    return randFields
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

function verifyFunctionWorksAsExpected(func, examples::Array)
    correct = true
    for (input, correctOutput) in examples
        returnedOutput = func(input)
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
        UnitPrefix(name="zetta", symbol="Z", value=1e+21)
    ]
    return unitPrefixTestSet
end

function getBaseUnitTestSet()
    baseUnitTestSet = [
        BaseUnit(name="gram", symbol="g", prefactor=1e-3, exponents=BaseUnitExponents(kg=1)),
        BaseUnit(name="meter", symbol="m", prefactor=1, exponents=BaseUnitExponents(m=1))
    ]
    return baseUnitTestSet
end

end # module
