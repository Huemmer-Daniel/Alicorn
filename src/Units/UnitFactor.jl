using ..Utils

export UnitFactor
@doc raw"""
    UnitFactor <: AbstractUnit

A composite unit formed by a named unit of type [`BaseUnit`](@ref), a prefix of type [`UnitPrefix`](@ref) modifying it, and an exponent indicating to which power the pair is raised.

# Fields
- `unitPrefix::UnitPrefix`
- `baseUnit::BaseUnit`
- `exponent::Real`

# Constructors
```
UnitFactor(unitPrefix::UnitPrefix, baseUnit::BaseUnit, exponent::Real)
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

# Remarks

The constructor converts the exponent to `Int` if possible. If `baseUnit=Alicorn.unitlessBaseUnit`, the prefix is always set to `unitPrefix=Alicorn.emptyUnitPrefix` and the exponent to `exponent=1`.

# Examples
1. The unit ``\mathrm{km}^2`` (square kilometer) can be represented by a `UnitFactor` that can be
   constructed using the type constructor method as follows:
   ```jldoctest
   julia> ucat = UnitCatalogue();

   julia> UnitFactor(ucat.kilo, ucat.meter, 2)
   UnitFactor km^2
   ```
2. Alternatively, ``\mathrm{km}^2`` can be constructed arithmetically:
   ```jldoctest
   julia> ucat = UnitCatalogue();

   julia> (ucat.kilo * ucat.meter)^2
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


## Outer constructors

# documented in the type definition
function UnitFactor(baseUnit::BaseUnit, exponent::Real)
    return UnitFactor(emptyUnitPrefix, baseUnit, exponent)
end

# documented in the type definition
function UnitFactor(unitPrefix::UnitPrefix, baseUnit::BaseUnit)
    return UnitFactor(unitPrefix, baseUnit, 1)
end

# documented in the type definition
function UnitFactor(baseUnit::BaseUnit)
    return UnitFactor(emptyUnitPrefix, baseUnit, 1)
end

# documented in the type definition
function UnitFactor()
    return UnitFactor(emptyUnitPrefix, unitlessBaseUnit, 1)
end


## Methods implementing the interface of AbstractUnit

# documented as part of the interface of AbstractUnit
function convertToUnit(unitFactor::UnitFactor)
    return Unit([unitFactor])
end

# documented as part of the interface of AbstractUnit
function convertToBasicSI(unitFactor::UnitFactor)
    (prefactor, basicSIExponents) = convertToBasicSIAsExponents(unitFactor)
    basicSIUnit = convertToUnit(basicSIExponents)

    return (prefactor, basicSIUnit)
end

# documented as part of the interface of AbstractUnit
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

"""
    Base.:*(unitPrefix::UnitPrefix, unitFactor::UnitFactor)

Combine `unitPrefix` and `unitFactor` to form a unit of type `UnitFactor`.

The operation is only permitted if
1. `unitFactor` does not already contain a unit prefix, and
2. the exponent of `unitFactor` is 1.

# Raises Exceptions
- `Base.ArgumentError`: if `unitFactor.unitPrefix != Alicorn.emptyUnitPrefix`
- `Base.ArgumentError`: if `unitFactor.exponent != 1`

"""
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

"""
    Base.inv(unitFactor::UnitFactor)

Return the (multiplicative) inverse of `unitFactor` as a unit of type `UnitFactor`.
"""
function Base.inv(unitFactor::UnitFactor)
    if unitFactor == UnitFactor(unitlessBaseUnit)
        return unitFactor
    else
        inverseUnitFactor = UnitFactor(unitFactor.unitPrefix, unitFactor.baseUnit, -unitFactor.exponent)
        return inverseUnitFactor
    end
end

"""
    Base.:^(unitFactor::UnitFactor, exponent::Real)

Raise `unitFactor` to the power of `exponent` and return the result as a unit of type `UnitFactor`.
"""
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

"""
    Base.sqrt(unitFactor::UnitFactor)

Take the square root of `unitFactor` and return it as unit of type `UnitFactor`.
"""
function Base.sqrt(unitFactor::UnitFactor)
    return unitFactor^(0.5)
end

"""
    Base.cbrt(unitFactor::UnitFactor)

Take the cubic root of `unitFactor` and return it as unit of type `UnitFactor`.
"""
function Base.cbrt(unitFactor::UnitFactor)
    return unitFactor^(1/3)
end

## Constants of type UnitFactor

export unitlessUnitFactor
"""
Constant of type `UnitFactor` indicating the absence of a unit.

The constant is not exported by Alicorn but can be accessed as `Alicorn.unitlessUnitFactor`.
"""
const unitlessUnitFactor = UnitFactor( emptyUnitPrefix, unitlessBaseUnit, 1)

export kilogram
"""
Constant of type `UnitFactor` representing the kilogram.

The constant is not exported by Alicorn but can be accessed as `Alicorn.kilogram`.
"""
const kilogram = kilo * gram
