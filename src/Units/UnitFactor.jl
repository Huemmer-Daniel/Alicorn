using ..Utils

export UnitFactor
@doc raw"""
    UnitFactor <: AbstractUnit

A composite unit formed by a named unit, a unit prefix modifying it, and an exponent indicating to which power the pair is raised.

# Fields
- `unitPrefix::UnitPrefixt`
- `baseUnit::BaseUnit`
- `exponent::Real`

# Constructors
```
UnitFactor(unitPrefix::UnitPrefix, baseUnit::BaseUnit, exponent::Real)
```
The exponent needs to be finite, otherwise a `Core.DomainError` is raised. The constructor converts the exponent to `Int` if possible. If `baseUnit=Alicorn.unitlessBaseUnit`, the prefix is always set to `unitPrefix=Alicorn.emptyUnitPrefix` and the exponent to `exponent=1`.
```
UnitFactor(baseUnit::BaseUnit, exponent::Real)
UnitFactor(unitPrefix::UnitPrefix, baseUnit::BaseUnit)
UnitFactor(baseUnit::BaseUnit)
UnitFactor()
```
If any of the three fields are omitted from the constructor call, that field is initialized using the corresponding default value:
- `unitPrefix = unitPrefix=Alicorn.emptyUnitPrefix`
- `baseUnit = Alicorn.unitlessBaseUnit`
- `exponent = 1`

# Raises Exceptions
- `Core.DomainError`: if attempting to initialize the `exponent` field with an infinite number

# Examples
The unit "square kilometer" (``\mathrm{km}^2``) can be represented by a `UnitFactor` as
```
julia> ucat = UnitCatalogue() ;

julia> UnitFactor(ucat.kilo, ucat.meter, 2)
UnitFactor km^2
```
"""
struct UnitFactor <: AbstractUnit
    unitPrefix::UnitPrefix
    baseUnit::BaseUnit
    exponent::Real

    function UnitFactor(unitPrefix::UnitPrefix, baseUnit::BaseUnit, exponent::Real)
        Utils.assertIsFinite(exponent)
        exponent = Utils.tryCastingToInt(exponent)

        if exponent == 0 || baseUnit == unitlessBaseUnit
            unitFactor = new(emptyUnitPrefix, unitlessBaseUnit, 1)
        else
            unitFactor = new(unitPrefix, baseUnit, exponent)
        end

        return unitFactor
    end
end

# documented in the type declaration
function UnitFactor(baseUnit::BaseUnit, exponent::Real)
    return UnitFactor(emptyUnitPrefix, baseUnit, exponent)
end

# documented in the type declaration
function UnitFactor(unitPrefix::UnitPrefix, baseUnit::BaseUnit)
    return UnitFactor(unitPrefix, baseUnit, 1)
end

# documented in the type declaration
function UnitFactor(baseUnit::BaseUnit)
    return UnitFactor(emptyUnitPrefix, baseUnit, 1)
end

# documented in the type declaration
function UnitFactor()
    return UnitFactor(emptyUnitPrefix, unitlessBaseUnit, 1)
end

export unitlessUnitFactor
"""
Constant of type `UnitFactor` indicating the absence of a unit.
"""
const unitlessUnitFactor = UnitFactor( emptyUnitPrefix, unitlessBaseUnit, 1)

export kilogram
"""
Constant of type `UnitFactor` representing the kilogram.
"""
const kilogram = kilo * gram

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

function Base.sqrt(unitFactor::UnitFactor)
    return unitFactor^(0.5)
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

# function documented in as part of the AbstractUnit interface
function convertToUnit(unitFactor::UnitFactor)
    return Unit([unitFactor])
end

# function documented in as part of the AbstractUnit interface
function convertToBasicSI(unitFactor::UnitFactor)
    (prefactor, basicSIExponents) = convertToBasicSIAsExponents(unitFactor)
    basicSIUnit = convertToUnit(basicSIExponents)

    return (prefactor, basicSIUnit)
end

# function documented in as part of the AbstractUnit interface
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
