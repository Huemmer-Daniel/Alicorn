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

function prettyPrintScientificNumber(number::Real; sigdigits::Int64=4)
    if number == 0
        prettyString = "0"
    elseif isinf(number)
        prettyString = "$number"
    elseif isnan(number)
        prettyString = "NaN"
    else
        prettyString = _prettyPrintFiniteNumber(number, sigdigits)
    end
    return prettyString
end

function _prettyPrintFiniteNumber(number::Real, sigdigits::Int64)
    (prefactor,decade) = separatePrefactorAndDecade(number)
    prefactorString = _getPrettyPrefactorString(prefactor, sigdigits)
    decadeString = _getPrettyDecadeString(decade)
    return prefactorString * decadeString
end

function _getPrettyPrefactorString(prefactor::Real, sigdigits::Int64)
    if isinteger(prefactor)
        prefactor = convert(Int64,prefactor)
    else
        prefactor = round(prefactor; sigdigits=sigdigits)
    end
    return "$prefactor"
end

function _getPrettyDecadeString(decade::Int64)
    if decade == 0
        decadeString = ""
    else
        absDecade = abs(decade)
        decadeSignString = decade < 0 ? "-" : "+"
        decadeString = "e" * decadeSignString * "$absDecade"
    end
    return decadeString
end

function isElementOf(element::T, array::Array{T}) where T
    occurences = sum(array .== element)
    return occurences > 0
end

end # module
