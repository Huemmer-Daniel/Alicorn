function Base.show(io::IO, quantity::Quantity)
    output = generatePrettyPrintingOutput(quantity)
    print(io, output)
end

function generatePrettyPrintingOutput(quantity::Quantity)
    valueStr = string(quantity.value)
    dimStr = generateShortStringRepresentation(quantity.dimension)
    intuStr = generateShortStringRepresentation(quantity.internalUnits, quantity.dimension)

    return "$(typeof(quantity)) of dimension " * dimStr * " in units of (" * intuStr * "):\n $valueStr"
end
