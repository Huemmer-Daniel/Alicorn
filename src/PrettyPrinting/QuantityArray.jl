function Base.showarg(io::IO, qArray::QuantityArray, toplevel)
    dimStr = generateShortStringRepresentation(qArray.dimension)
    intuStr = generateShortStringRepresentation(qArray.internalUnits, qArray.dimension)
    descriptor = " of dimension $dimStr in units of ($intuStr)"
    return print(io, typeof(qArray), descriptor)
end

Base.print_array(io::IO, qArray::QuantityArray) = Base.print_array(io, qArray.value)
