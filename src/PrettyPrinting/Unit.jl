function Base.show(io::IO, unit::Unit)
    output = _generatePrettyPrintingOutput(unit)
    print(io, output)
end

function _generatePrettyPrintingOutput(unit::Unit)
    stringRepresentation = generateStringRepresentation(unit)
    return "Unit " * stringRepresentation
end

function generateStringRepresentation(unit::Unit)
    unitFactors = unit.unitFactors
    unitStrRepr = ""
    for unitFactor in unitFactors
        unitFactorStrRepr = generateStringRepresentation(unitFactor)
        unitStrRepr = _addStringWithWhitespace(unitStrRepr, unitFactorStrRepr)
    end
    return unitStrRepr
end
