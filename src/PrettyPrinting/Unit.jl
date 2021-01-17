function Base.show(io::IO, unit::Unit)
    output = generatePrettyPrintingOutput(unit)
    print(io, output)
end

function generatePrettyPrintingOutput(unit::Unit)
    stringRepresentation = _generateStringRepresentation(unit)
    return "Unit " * stringRepresentation
end

function _generateStringRepresentation(unit::Unit)
    unitFactors = unit.unitFactors
    unitStrRepr = ""
    for unitFactor in unitFactors
        unitFactorStrRepr = _generateStringRepresentation(unitFactor)
        unitStrRepr = _addStringWithWhitespace(unitStrRepr, unitFactorStrRepr)
    end
    return unitStrRepr
end
