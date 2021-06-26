function Base.showarg(io::IO, sqArray::SimpleQuantityArray, toplevel)
    unitString = generateStringRepresentation(sqArray.unit)
    descriptor = " of unit $unitString"
    return print(io, typeof(sqArray), descriptor)
end
