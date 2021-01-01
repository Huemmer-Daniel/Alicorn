module PrettyPrinting

using ..Units
using ..Utils

## Numbers

function prettyPrintScientificNumber(number::Real; sigdigits::Int64=4)
    if number == 0
        prettyString = "0"
    elseif isinf(number)
        prettyString = "$number"
    elseif isnan(number)
        prettyString = "NaN"
    else
        prettyString = _prettyPrintFiniteNumber(number, sigdigits)
    end
    return prettyString
end

function _prettyPrintFiniteNumber(number::Real, sigdigits::Int64)
    (prefactor,decade) = Utils.separatePrefactorAndDecade(number)
    prefactorString = _getPrettyPrefactorString(prefactor, sigdigits)
    decadeString = _getPrettyDecadeString(decade)
    return prefactorString * decadeString
end

function _getPrettyPrefactorString(prefactor::Real, sigdigits::Int64)
    if isinteger(prefactor)
        prefactor = convert(Int64,prefactor)
    else
        prefactor = round(prefactor; sigdigits=sigdigits)
    end
    return "$prefactor"
end

function _getPrettyDecadeString(decade::Int64)
    if decade == 0
        decadeString = ""
    else
        absDecade = abs(decade)
        decadeSignString = decade < 0 ? "-" : "+"
        decadeString = "e" * decadeSignString * "$absDecade"
    end
    return decadeString
end


## UnitPrefix

function Base.show(io::IO, prefix::UnitPrefix)
    output = _generatePrettyPrintingOutput(prefix)
    print(io, output)
end

function _generatePrettyPrintingOutput(prefix::UnitPrefix)
    stringRepresentation = _generateStringRepresentation(prefix)
    return "UnitPrefix " * stringRepresentation
end

function _generateStringRepresentation(prefix::UnitPrefix)
    name = prefix.name
    symbol = prefix.symbol
    value = prefix.value
    valueString = prettyPrintScientificNumber(value, sigdigits=3)
    stringRepresentation = "$name ($symbol) of value " * valueString
    return stringRepresentation
end

## BaseUnitExponents

function Base.show(io::IO, baseUnitExp::BaseUnitExponents)
    output = _generateLongPrettyPrintingOutput(baseUnitExp)
    print(io,output)
end

function _generateLongPrettyPrintingOutput(baseUnitExp::BaseUnitExponents)
    prettyString = _generateLongStringRepresentation(baseUnitExp)
    return "BaseUnitExponents " * prettyString
end

function _generateLongStringRepresentation(baseUnitExp::BaseUnitExponents)
    exponents = _getExponentsAsArray(baseUnitExp)
    prettyString = ""
    for exp in exponents
        prettyString = _addLongPrettyFactor(prettyString, exp)
    end
    return prettyString
end

function _getExponentsAsArray(baseUnitExp::BaseUnitExponents)
    exponents = [
    ("kg", baseUnitExp.kilogramExponent),
    ("m", baseUnitExp.meterExponent),
    ("s", baseUnitExp.secondExponent),
    ("A", baseUnitExp.ampereExponent),
    ("K", baseUnitExp.kelvinExponent),
    ("mol", baseUnitExp.molExponent),
    ("cd",  baseUnitExp.candelaExponent)
    ]
    return exponents
end

function _addLongPrettyFactor(prettyString::String, exp::Tuple)
    (symbol, exponent) = exp

    expString = prettyPrintScientificNumber(exponent, sigdigits=2)
    addString = "$symbol^$expString"

    return _addStringWithWhitespace( prettyString, addString )
end

function _generateShortPrettyPrintingOutput(baseUnitExp::BaseUnitExponents)
    prettyString = _generateShortStringRepresentation(baseUnitExp)
    return "BaseUnitExponents " * prettyString
end

function _generateShortStringRepresentation(baseUnitExp::BaseUnitExponents)
    exponents = _getExponentsAsArray(baseUnitExp)
    prettyString = ""
    for exp in exponents
        prettyString = _addShortPrettyFactor(prettyString, exp)
    end
    return prettyString
end

function _addShortPrettyFactor(prettyString::String, exp::Tuple)
    (symbol, exponent) = exp

    if exponent == 0
        addString = ""
    elseif exponent == 1
        addString = "$symbol"
    else
        expString = prettyPrintScientificNumber(exponent, sigdigits=2)
        addString = "$symbol^$expString"
    end

    return _addStringWithWhitespace( prettyString, addString )
end

function _addStringWithWhitespace(string, addString)
    if string != "" && string[end] != " " && addString != ""
        addString  = " " * addString
    end
    return string * addString
end

## BaseUnit

function Base.show(io::IO, baseUnit::BaseUnit)
    output = generatePrettyPrintingOutput(baseUnit)
    print(io,output)
end

function generatePrettyPrintingOutput(baseUnit::BaseUnit)
    stringRepresentation = _generateStringRepresentation(baseUnit)
    return "BaseUnit " * stringRepresentation
end

function _generateStringRepresentation(baseUnit::BaseUnit)
    name = baseUnit.name
    symbol = baseUnit.symbol
    prefactor = baseUnit.prefactor
    prefactorString = prettyPrintScientificNumber(prefactor, sigdigits=3)
    exponentsString = _generateShortStringRepresentation(baseUnit.exponents)

    stringRepresentation = "$name (1"
    stringRepresentation = _addStringWithWhitespace(stringRepresentation, "$symbol")
    stringRepresentation = _addStringWithWhitespace(stringRepresentation, "=")
    stringRepresentation = _addStringWithWhitespace(stringRepresentation, prefactorString)
    stringRepresentation = _addStringWithWhitespace(stringRepresentation, exponentsString)
    stringRepresentation *= ")"
end

## UnitCatalogue

function Base.show(io::IO, ucat::UnitCatalogue)
    output = _generatePrettyPrintingOutput(ucat)
    print(io,output)
end

function _generatePrettyPrintingOutput(ucat::UnitCatalogue)
    nrOfPrefixes = length(listUnitPrefixes(ucat))
    nrOfBaseUnits = length(listBaseUnits(ucat))
    prettyString = "UnitCatalogue providing\n\t$nrOfPrefixes unit prefixes\n\t$nrOfBaseUnits base units"
    return prettyString
end

end # module
