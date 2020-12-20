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

end # module
