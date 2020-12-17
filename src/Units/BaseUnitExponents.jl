export BaseUnitExponents
struct BaseUnitExponents
    kilogramExponent::Real
    meterExponent::Real
    secondExponent::Real
    ampereExponent::Real
    KelvinExponent::Real
    molExponent::Real
    candelaExponent::Real

    function BaseUnitExponents(; kg::Real=0, m::Real=0, s::Real=0, A::Real=0, K::Real=0, mol::Real=0, cd::Real=0 )
        _assertExponentsAreFinite([kg, m, s, A, K, mol, cd])
        new(kg, m, s, A, K, mol, cd)
    end
end

function _assertExponentsAreFinite(exponents)
    for exponent in exponents
        Utils.assertIsFinite(exponent)
    end
end
