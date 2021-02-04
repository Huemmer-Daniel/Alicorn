using ..Utils

export BaseUnit
@doc raw"""
    BaseUnit <: AbstractUnit

A named unit derived from the seven basic SI units.

# Fields

- `name::String`: long form name of the unit
- `symbol::String`: short symbol used to denote the named unit in a composite unit
- `prefactor::Real`: numerical prefactor multiplying the polynomial of basic SI units corresponding to the named unit.
- `exponents::BaseUnitExponents`: collection of the powers in the polynomial of basic SI units corresponding to the named unit.

# Constructor
```
BaseUnit(; name::String, symbol::String, prefactor::Real, exponents::BaseUnitExponents)
```

# Raises Exceptions

- `Core.ArgumentError`: if attempting to initialize the `name` field with a string that is not valid as an identifier
- `Core.DomainError`: if attempting to initialize the `prefactor` field with an infinite number

# Examples
1. The meter can be represented by
   ```jldoctest
   julia> BaseUnit( name="meter",
                    symbol="m",
                    prefactor=1,
                    exponents=BaseUnitExponents(m=1) )
   BaseUnit meter (1 m = 1 m)
   ```
2. The gram can be represented by
   ```jldoctest
   julia> BaseUnit( name="gram",
                    symbol="g",
                    prefactor=1e-3,
                    exponents=BaseUnitExponents(kg=1) )
   BaseUnit gram (1 g = 1e-3 kg)
   ```
3. The joule is defined as
   ```math
   1\,\mathrm{J} = 1\,\mathrm{kg}\,\mathrm{m^2}\,\mathrm{s^{-2}}.
   ```
   and can be represents by
   ```jldoctest
   julia> BaseUnit( name="joule",
                    symbol="J",
                    prefactor=1,
                    exponents=BaseUnitExponents(kg=1, m=2, s=-2) )
   BaseUnit joule (1 J = 1 kg m^2 s^-2)
   ```
"""
struct BaseUnit <: AbstractUnit
    name::String
    symbol::String
    prefactor::Real
    exponents::BaseUnitExponents

    function BaseUnit(; name::String, symbol::String, prefactor::Real, exponents::BaseUnitExponents)
        Utils.assertIsFinite(prefactor)
        Utils.assertNameIsValidSymbol(name)
        new(name, symbol, prefactor, exponents)
    end
end

## Methods implementing the interface of AbstractUnit

# documented as part of the interface of AbstractUnit
function convertToUnit(baseUnit::BaseUnit)
    return Unit( UnitFactor(baseUnit) )
end

# documented as part of the interface of AbstractUnit
function convertToBasicSI(baseUnit::BaseUnit)
    prefactor = baseUnit.prefactor
    exponents = baseUnit.exponents

    basicSIUnit = convertToUnit(exponents)

    return (prefactor, basicSIUnit)
end

# documented as part of the interface of AbstractUnit
function convertToBasicSIAsExponents(baseUnit::BaseUnit)
    prefactor = baseUnit.prefactor
    exponents = baseUnit.exponents

    return (prefactor, exponents)
end

"""
    Base.:*(unitPrefix::UnitPrefix, baseUnit::BaseUnit)

Combine `unitPrefix` and `baseUnit` to form a unit of type `UnitFactor`.
"""
function Base.:*(unitPrefix::UnitPrefix, baseUnit::BaseUnit)
    return UnitFactor(unitPrefix, baseUnit)
end

"""
    Base.inv(baseUnit::BaseUnit)

Return the (multiplicative) inverse of `baseUnit` as a unit of type `UnitFactor`.
"""
function Base.inv(baseUnit::BaseUnit)
    return inv( UnitFactor(baseUnit) )
end

"""
    Base.:^(baseUnit::BaseUnit, exponent::Real)

Raise `baseUnit` to the power of `exponent` and return the result as a unit of type `UnitFactor`.
"""
function Base.:^(baseUnit::BaseUnit, exponent::Real)
    return UnitFactor(baseUnit)^exponent
end

"""
    Base.sqrt(baseUnit::BaseUnit)

Take the square root of `baseUnit` and return it as unit of type `UnitFactor`.
"""
function Base.sqrt(baseUnit::BaseUnit)
    return UnitFactor(baseUnit)^0.5
end

## Constants of type BaseUnit

export unitlessBaseUnit
"""
Constant of type `BaseUnit` indicating the absence of a unit.

The constant is not exported by Alicorn but can be accessed as `Alicorn.unitlessBaseUnit`.
"""
const unitlessBaseUnit = BaseUnit( name="unitless", symbol="<unitless>", prefactor=1, exponents=BaseUnitExponents() )

export gram
"""
Constant of type `BaseUnit` representing the gram.

The constant is not exported by Alicorn but can be accessed as `Alicorn.gram`.
"""
const gram = BaseUnit( name="gram", symbol="g", prefactor=1e-3, exponents=BaseUnitExponents(kg=1) )

export meter
"""
Constant of type `BaseUnit` representing the meter.

The constant is not exported by Alicorn but can be accessed as `Alicorn.meter`.
"""
const meter = BaseUnit( name="meter", symbol="m", prefactor=1, exponents=BaseUnitExponents(m=1) )

export second
"""
Constant of type `BaseUnit` representing the second.

The constant is not exported by Alicorn but can be accessed as `Alicorn.second`.
"""
const second = BaseUnit( name="second", symbol="s", prefactor=1, exponents=BaseUnitExponents(s=1) )

export ampere
"""
Constant of type `BaseUnit` representing the ampere.

The constant is not exported by Alicorn but can be accessed as `Alicorn.ampere`.
"""
const ampere = BaseUnit( name="ampere", symbol="A", prefactor=1, exponents=BaseUnitExponents(A=1) )

export kelvin
"""
Constant of type `BaseUnit` representing the kelvin.

The constant is not exported by Alicorn but can be accessed as `Alicorn.kelvin`.
"""
const kelvin = BaseUnit( name="kelvin", symbol="K", prefactor=1, exponents=BaseUnitExponents(K=1) )

export mol
"""
Constant of type `BaseUnit` representing the mol.

The constant is not exported by Alicorn but can be accessed as `Alicorn.mol`.
"""
const mol = BaseUnit( name="mol", symbol="mol", prefactor=1, exponents=BaseUnitExponents(mol=1) )

export candela
"""
Constant of type `BaseUnit` representing the candela.

The constant is not exported by Alicorn but can be accessed as `Alicorn.candela`.
"""
const candela = BaseUnit( name="candela", symbol="cd", prefactor=1, exponents=BaseUnitExponents(cd=1) )
