module Exceptions

struct DuplicationError <: Exception
    message::String
end

function Base.show(io::IO, duplicationError::DuplicationError)
    print(io, duplicationError.message)
end

struct DimensionMismatchError <: Exception
    message::String
end

function Base.show(io::IO, dimensionMismatchError::DimensionMismatchError)
    print(io, dimensionMismatchError.message)
end

end # module
