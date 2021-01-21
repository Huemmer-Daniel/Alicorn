module Exceptions

struct DublicationError <: Exception
    message::String
end

function Base.show(io::IO, dublicationError::DublicationError)
    print(io, dublicationError.message)
end

struct DimensionMismatchError <: Exception
    message::String
end

function Base.show(io::IO, dimensionMismatchError::DimensionMismatchError)
    print(io, dimensionMismatchError.message)
end

end # module
