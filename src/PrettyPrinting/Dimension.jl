function Base.show(io::IO, dimension::Dimension)
    output = _generateLongPrettyPrintingOutput(dimension)
    print(io, output)
end

function _generateLongPrettyPrintingOutput(dimension::Dimension)
    prettyString = _generateLongStringRepresentation(dimension)
    return "Dimension " * prettyString
end

function _generateLongStringRepresentation(dimension::Dimension)
    exponents = _getExponentsAsArray(dimension)
    prettyString = ""
    for exp in exponents
        prettyString = _addLongPrettyFactor_Dimension(prettyString, exp)
    end
    return prettyString
end

function _getExponentsAsArray(dimension::Dimension)
    exponents = [
    ("M", dimension.massExponent),
    ("L", dimension.lengthExponent),
    ("T", dimension.timeExponent),
    ("I", dimension.currentExponent),
    ("θ", dimension.temperatureExponent),
    ("N", dimension.amountExponent),
    ("J",  dimension.luminousIntensityExponent)
    ]
    return exponents
end

function _addLongPrettyFactor_Dimension(prettyString::String, exp::Tuple)
    (symbol, exponent) = exp

    expString = prettyPrintScientificNumber(exponent, sigdigits=2)
    addString = "$symbol^$expString"

    return _addStringWithWhitespace( prettyString, addString )
end
