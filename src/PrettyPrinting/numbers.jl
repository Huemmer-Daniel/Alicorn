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
    (prefactor,decade) = Utils.separatePrefactorAndDecade(number)
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
