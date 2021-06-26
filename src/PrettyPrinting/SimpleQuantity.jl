function Base.show(io::IO, simpleQuantity::SimpleQuantity)
    output = generatePrettyPrintingOutput(simpleQuantity)
    print(io, output)
end

function generatePrettyPrintingOutput(simpleQuantity::SimpleQuantity)
    value = simpleQuantity.value
    if isa(value, Number)
        prettyString = generatePrettyStringForNumber(simpleQuantity)
    else
        prettyString = generatePrettyStringGeneral(simpleQuantity)
    end
    return prettyString
end

function generatePrettyStringForNumber(simpleQuantity)
    value = simpleQuantity.value
    unit = simpleQuantity.unit

    valueStr = string(value)
    unitStr = generateStringRepresentation(unit)

    return valueStr * " " * unitStr
end
