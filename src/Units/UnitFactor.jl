using ..Utils

export UnitFactor
struct UnitFactor <: AbstractUnit
    unitPrefix::UnitPrefix
    baseUnit::BaseUnit
    exponent::Real

    function UnitFactor(unitPrefix::UnitPrefix, baseUnit::BaseUnit, exponent::Real)
        _verifyInitializationArguments(unitPrefix, baseUnit, exponent)
        exponent = Utils.tryCastingToInt(exponent)

        if exponent == 0
            unitFactor = unitlessUnitFactor
        else
            unitFactor = new(unitPrefix, baseUnit, exponent)
        end

        return unitFactor
    end
end

function _verifyInitializationArguments(unitPrefix::UnitPrefix, baseUnit::BaseUnit, exponent::Real)
    Utils.assertIsFinite(exponent)
    _assertEmptyPrefixIfUnitless(baseUnit, unitPrefix)
    _assertTrivialExponentIfUnitless(baseUnit, exponent)
end

function _assertEmptyPrefixIfUnitless(baseUnit::BaseUnit, unitPrefix::UnitPrefix)
    if baseUnit == unitlessBaseUnit && unitPrefix != emptyUnitPrefix
        throw( Core.ArgumentError("unitless BaseUnit requires empty UnitPrefix") )
    end
end

function _assertTrivialExponentIfUnitless(baseUnit::BaseUnit, exponent::Real)
    if baseUnit == unitlessBaseUnit && exponent != 1
        throw( Core.ArgumentError("unitless BaseUnit requires exponent 1") )
    end
end

function UnitFactor(baseUnit::BaseUnit, exponent::Real)
    return UnitFactor(emptyUnitPrefix, baseUnit, exponent)
end

function UnitFactor(unitPrefix::UnitPrefix, baseUnit::BaseUnit)
    return UnitFactor(unitPrefix, baseUnit, 1)
end

function UnitFactor(baseUnit::BaseUnit)
    return UnitFactor(emptyUnitPrefix, baseUnit, 1)
end

function UnitFactor()
    return UnitFactor(emptyUnitPrefix, unitlessBaseUnit, 1)
end

Base.broadcastable(baseUnitExponents::BaseUnitExponents) = Ref(baseUnitExponents)

export unitlessUnitFactor
unitlessUnitFactor = UnitFactor( emptyUnitPrefix, unitlessBaseUnit, 1)

export kilogram
kilogram = kilo * gram

function Base.inv(unitFactor::UnitFactor)
    if unitFactor == UnitFactor(unitlessBaseUnit)
        return unitFactor
    else
        inverseUnitFactor = UnitFactor(unitFactor.unitPrefix, unitFactor.baseUnit, -unitFactor.exponent)
        return inverseUnitFactor
    end
end

function Base.:^(unitFactor::UnitFactor, exponent::Real)
    unitPrefix = unitFactor.unitPrefix
    baseUnit = unitFactor.baseUnit

    newExponent = unitFactor.exponent * exponent
    try
        newExponent = convert(Int, newExponent)
    catch
    end

    newUnitFactor = UnitFactor(unitPrefix, baseUnit, newExponent)
    return newUnitFactor
end

function Base.:*(unitPrefix::UnitPrefix, unitFactor::UnitFactor)
    _assertHasEmptyPrefix(unitFactor)
    _assertHasTrivialExponent(unitFactor)

    baseUnit = unitFactor.baseUnit
    return UnitFactor(unitPrefix, baseUnit)
end

function _assertHasEmptyPrefix(unitFactor::UnitFactor)
    prefix = unitFactor.unitPrefix
    if !(prefix == emptyUnitPrefix)
        throw(Base.ArgumentError("prefix of UnitFactor needs to be emptyUnitPrefix for multiplication of UnitPrefix with UnitFactor"))
    end
end

function _assertHasTrivialExponent(unitFactor::UnitFactor)
    exponent = unitFactor.exponent
    if !(exponent == 1)
        throw(Base.ArgumentError("exponent of UnitFactor needs to be 1 for multiplication of UnitPrefix with UnitFactor"))
    end
end

function convertToUnit(unitFactor::UnitFactor)
    return Unit([unitFactor])
end

function convertToBasicSI(unitFactor::UnitFactor)
    (prefactor, basicSIExponents) = convertToBasicSIAsExponents(unitFactor)
    basicSIUnit = convertToUnit(basicSIExponents)

    return (prefactor, basicSIUnit)
end

function convertToBasicSIAsExponents(unitFactor::UnitFactor)
    unitPrefix = unitFactor.unitPrefix
    baseUnit = unitFactor.baseUnit
    exponent = unitFactor.exponent

    prefixValue = unitPrefix.value

    baseUnitPrefactor = baseUnit.prefactor
    baseUnitExponents = baseUnit.exponents

    prefactor = (prefixValue * baseUnitPrefactor)^exponent
    basicSIExponents = exponent * baseUnitExponents

    return (prefactor, basicSIExponents)
end
