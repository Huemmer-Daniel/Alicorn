module Exceptions

struct DublicationError <: Exception
    message::String
end

function Base.show(io::IO, dublicationError::DublicationError)
    print(io,dublicationError.message)
end

end # module
