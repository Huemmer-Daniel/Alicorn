function Base.show(io::IO, internalUnits::InternalUnits)
    output = _generatePrettyPrintingOutput(internalUnits)
    print(io, output)
end

function _generatePrettyPrintingOutput(internalUnits::InternalUnits)
    massString              = "\n mass unit:               " * generatePrettyPrintingOutput(internalUnits.mass)
    lengthString            = "\n length unit:             " * generatePrettyPrintingOutput(internalUnits.length)
    timeString              = "\n time unit:               " * generatePrettyPrintingOutput(internalUnits.time)
    currentString           = "\n current unit:            " * generatePrettyPrintingOutput(internalUnits.current)
    temperatureString       = "\n temperature unit:        " * generatePrettyPrintingOutput(internalUnits.temperature)
    amountString            = "\n amount unit:             " * generatePrettyPrintingOutput(internalUnits.amount)
    luminousIntensityString = "\n luminous intensity unit: " * generatePrettyPrintingOutput(internalUnits.luminousIntensity)

    outputString = "InternalUnits" * massString * lengthString * timeString * currentString * temperatureString * amountString * luminousIntensityString
    return outputString
end
