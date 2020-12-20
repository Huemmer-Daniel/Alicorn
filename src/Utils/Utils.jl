module Utils

function separatePrefactorAndDecade(number::Real)
    assertIsFinite(number)
    decade = getDecade(number)
    prefactor = number/10.0^decade
    return (prefactor,decade)
end

function getDecade(number::Real)
    assertIsFinite(number)
    decade = number == 0 ? 0 : floor(log10(abs(number)))
    return convert(Int64,decade)
end

function assertIsFinite(number::Real)
    if !isfinite(number)
        throw(DomainError(number,"argument must be finite"))
    else
        return true
    end
end

function assertElementsAreFinite(array::Array{T,N}) where {T<:Real,N}
    if !arefinite(array)
        throw(DomainError(array,"argument must have finite elements"))
    else
        return true
    end
end

function arefinite(array::Array{T,N}) where {T<:Real,N}
    elementsAreFinite = map(isfinite, array)
    allAreFinite = prod(elementsAreFinite)
    return allAreFinite
end

function isElementOf(element::T, array::Array{T}) where T
    occurences = sum(array .== element)
    return occurences > 0
end

function assertNameIsValidSymbol(string::String)
    if !Base.isidentifier(string)
        throw(ArgumentError("name argument must be a valid identifier"))
    end
end

end # module
