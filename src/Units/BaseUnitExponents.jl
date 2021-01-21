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

function convertToUnit(baseUnitExponents::BaseUnitExponents)
    kilogramExponent = baseUnitExponents.kilogramExponent
    meterExponent = baseUnitExponents.meterExponent
    secondExponent = baseUnitExponents.secondExponent
    ampereExponent = baseUnitExponents.ampereExponent
    kelvinExponent = baseUnitExponents.kelvinExponent
    molExponent = baseUnitExponents.molExponent
    candelaExponent = baseUnitExponents.candelaExponent

    kilogramFactor = UnitFactor( kilo, gram, kilogramExponent )
    meterFactor = UnitFactor( meter, meterExponent )
    secondFactor = UnitFactor( second, secondExponent )
    ampereFactor = UnitFactor( ampere, ampereExponent )
    kelvinFactor = UnitFactor( kelvin, kelvinExponent )
    molFactor = UnitFactor( mol, molExponent )
    candelaFactor = UnitFactor( candela, candelaExponent )

    correspondingBasicUnit = Unit([
        kilogramFactor,
        meterFactor,
        secondFactor,
        ampereFactor,
        kelvinFactor,
        molFactor,
        candelaFactor
    ])

    return correspondingBasicUnit
end

function Base.:*(number::Number, baseUnitExponents::BaseUnitExponents)
    resultingExponents = BaseUnitExponents(
        kg = number * baseUnitExponents.kilogramExponent,
        m = number * baseUnitExponents.meterExponent,
        s = number * baseUnitExponents.secondExponent,
        A = number * baseUnitExponents.ampereExponent,
        K = number * baseUnitExponents.kelvinExponent,
        mol = number * baseUnitExponents.molExponent,
        cd = number * baseUnitExponents.candelaExponent
    )
    return resultingExponents
end

function Base.:*(baseUnitExponents::BaseUnitExponents, number::Number)
    return number * baseUnitExponents
end

function Base.:+(baseUnitExponents1::BaseUnitExponents, baseUnitExponents2::BaseUnitExponents)
    resultingExponents = BaseUnitExponents(
        kg = baseUnitExponents1.kilogramExponent + baseUnitExponents2.kilogramExponent,
        m = baseUnitExponents1.meterExponent + baseUnitExponents2.meterExponent,
        s = baseUnitExponents1.secondExponent + baseUnitExponents2.secondExponent,
        A = baseUnitExponents1.ampereExponent + baseUnitExponents2.ampereExponent,
        K = baseUnitExponents1.kelvinExponent + baseUnitExponents2.kelvinExponent,
        mol = baseUnitExponents1.molExponent + baseUnitExponents2.molExponent,
        cd = baseUnitExponents1.candelaExponent + baseUnitExponents2.candelaExponent,
    )
    return resultingExponents
end
