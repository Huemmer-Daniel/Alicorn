function Base.show(io::IO, dimension::Dimension)
    output = generatePrettyPrintingOutput(dimension)
    print(io, output)
end

function generatePrettyPrintingOutput(dimension::Dimension)
    prettyString = generateStringRepresentation(dimension)
    return "Dimension " * prettyString
end

function generateStringRepresentation(dimension::Dimension)
    exponents = _getExponentsAsArray(dimension)
    prettyString = ""
    for exp in exponents
        prettyString = _addPrettyFactor_Dimension(prettyString, exp)
    end
    if isempty(prettyString)
        prettyString = "1"
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

function _addPrettyFactor_Dimension(prettyString::String, exp::Tuple)
    (symbol, exponent) = exp

    if exponent == 0
        return prettyString
    else
        expString = prettyPrintScientificNumber(exponent, sigdigits=2)
        addString = "$symbol^$expString"
        return _addStringWithWhitespace( prettyString, addString )
    end
end
