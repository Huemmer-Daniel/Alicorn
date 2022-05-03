function Base.show(io::IO, prefix::UnitPrefix)
    output = _generatePrettyPrintingOutput(prefix)
    print(io, output)
end

function _generatePrettyPrintingOutput(prefix::UnitPrefix)
    stringRepresentation = generateStringRepresentation(prefix)
    return "UnitPrefix " * stringRepresentation
end

function generateStringRepresentation(prefix::UnitPrefix)
    name = prefix.name
    symbol = prefix.symbol
    value = prefix.value
    valueString = prettyPrintScientificNumber(value, sigdigits=3)
    stringRepresentation = "$name ($symbol) of value " * valueString
    return stringRepresentation
end
