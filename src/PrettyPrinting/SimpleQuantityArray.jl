function Base.showarg(io::IO, sqArray::SimpleQuantityArray, toplevel)
    unitString = generateStringRepresentation(sqArray.unit)
    descriptor = " of unit $unitString"
    return print(io, typeof(sqArray), descriptor)
end

Base.print_array(io::IO, sqArray::SimpleQuantityArray) = Base.print_array(io, sqArray.value)
