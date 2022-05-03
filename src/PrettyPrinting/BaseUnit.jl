function Base.show(io::IO, baseUnit::BaseUnit)
    output = generatePrettyPrintingOutput(baseUnit)
    print(io, output)
end

function generatePrettyPrintingOutput(baseUnit::BaseUnit)
    stringRepresentation = generateStringRepresentation(baseUnit)
    return "BaseUnit " * stringRepresentation
end

function generateStringRepresentation(baseUnit::BaseUnit)
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
    return stringRepresentation
end
