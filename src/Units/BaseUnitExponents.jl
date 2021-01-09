using ..Utils

export BaseUnitExponents
struct BaseUnitExponents
    kilogramExponent::Real
    meterExponent::Real
    secondExponent::Real
    ampereExponent::Real
    kelvinExponent::Real
    molExponent::Real
    candelaExponent::Real

    function BaseUnitExponents(; kg::Real=0, m::Real=0, s::Real=0, A::Real=0, K::Real=0, mol::Real=0, cd::Real=0 )
        exponents = (kg, m, s, A, K, mol, cd)
        _assertExponentsAreFinite(exponents)
        exponents = _tryCastingExponentsToInt(exponents)
        new(exponents...)
    end
end

function _assertExponentsAreFinite(exponents::Tuple)
    for exponent in exponents
        Utils.assertIsFinite(exponent)
    end
end

function _tryCastingExponentsToInt(exponents::Tuple)
    exponents = map(Utils.tryCastingToInt, exponents)
    return exponents
end
