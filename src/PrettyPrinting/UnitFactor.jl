function Base.show(io::IO, unitFactor::UnitFactor)
    output = generatePrettyPrintingOutput(unitFactor)
    print(io, output)
end

function generatePrettyPrintingOutput(unitFactor::UnitFactor)
    stringRepresentation = _generateStringRepresentation(unitFactor)
    return "UnitFactor " * stringRepresentation
end

function _generateStringRepresentation(unitFactor::UnitFactor)
    prefix = unitFactor.unitPrefix
    prefixSymbol = _generateUnitFactorPrefixString(prefix)
    baseUnitSymbol = unitFactor.baseUnit.symbol
    exponent = unitFactor.exponent
    exponentString = _generateUnitFactorExponentString(exponent)

    stringRepresentation = prefixSymbol * baseUnitSymbol * exponentString
    return stringRepresentation
end

function _generateUnitFactorPrefixString(unitPrefix::UnitPrefix)
    if unitPrefix == emptyUnitPrefix
        unitPrefixString = ""
    else
        unitPrefixString = unitPrefix.symbol
    end
    return unitPrefixString
end

function _generateUnitFactorExponentString(exponent::Real)
    if exponent == 1
        exponentString = ""
    else
        exponentString = "^" * prettyPrintScientificNumber(exponent, sigdigits=2)
    end
    return exponentString
end
