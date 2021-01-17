function Base.show(io::IO, baseUnitExp::BaseUnitExponents)
    output = _generateLongPrettyPrintingOutput(baseUnitExp)
    print(io, output)
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
