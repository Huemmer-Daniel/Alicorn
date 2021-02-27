using ..Utils

export BaseUnitExponents
@doc raw"""
    BaseUnitExponents

Collection of powers exponentiating each of the seven SI basic units. The [`BaseUnit`](@ref) type uses `BaseUnitExponents` to define named units in terms of the basic units.

# Fields
- `kilogramExponent::Real`
- `meterExponent::Real`
- `secondExponent::Real`
- `ampereExponent::Real`
- `kelvinExponent::Real`
- `molExponent::Real`
- `candelaExponent::Real`

# Constructor
```
BaseUnitExponents(; kg::Real=0, m::Real=0, s::Real=0, A::Real=0, K::Real=0, mol::Real=0, cd::Real=0)
```

# Raises Exceptions
- `Core.DomainError`: if attempting to initialize any field with an infinite number

# Remarks
The constructor converts any exponent to `Int` if possible.

# Examples
The joule is defined as
```math
 1\,\mathrm{J} = 1\,\mathrm{kg}\,\mathrm{m^2}\,\mathrm{s^{-2}}.
```
The corresponding `BaseUnitExponents` object is:
```jldoctest
julia> BaseUnitExponents(kg=1, m=2, s=-2)
BaseUnitExponents kg^1 m^2 s^-2 A^0 K^0 mol^0 cd^0
```
Calling the constructor without any keyword arguments returns exponents that correspond to a dimensionless unit:
```jldoctest
julia> BaseUnitExponents()
BaseUnitExponents kg^0 m^0 s^0 A^0 K^0 mol^0 cd^0
```
"""
struct BaseUnitExponents <: AbstractUnitElement
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

## Methods

# objects of type BaseUnitExponents act as scalars in broadcasting
Base.broadcastable(baseUnitExponents::BaseUnitExponents) = Ref(baseUnitExponents)

export convertToUnit
"""
    convertToUnit(baseUnitExponents::BaseUnitExponents)

Return the `Unit` corresponding to a `BaseUnitExponents` object.

# Example
```jldoctest
julia> jouleExponents = BaseUnitExponents(kg=1, m=2, s=-2)
BaseUnitExponents kg^1 m^2 s^-2 A^0 K^0 mol^0 cd^0

julia> convertToUnit(jouleExponents)
Unit kg m^2 s^-2
```
"""
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

"""
    Base.:*(number::Number, baseUnitExponents::BaseUnitExponents)
    Base.:*(baseUnitExponents::BaseUnitExponents, number::Number)

Multiply each exponent in `baseUnitExponents` by `number`. This operation
corresponds to exponentiating the corresponding unit with `number`.

# Example
```jldoctest
julia> meterExps = BaseUnitExponents(m=1)
BaseUnitExponents kg^0 m^1 s^0 A^0 K^0 mol^0 cd^0

julia> convertToUnit(meterExps)
Unit m

julia> meterSqrdExps = 2 * meterExps
BaseUnitExponents kg^0 m^2 s^0 A^0 K^0 mol^0 cd^0

julia> convertToUnit(meterSqrdExps)
Unit m^2
```
"""
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

# documented together with Base.:*(number::Number, baseUnitExponents::BaseUnitExponents)
function Base.:*(baseUnitExponents::BaseUnitExponents, number::Number)
    return number * baseUnitExponents
end

"""
    Base.:+(baseUnitExponents1::BaseUnitExponents, baseUnitExponents2::BaseUnitExponents)

Add each exponent in `baseUnitExponents1` to its counterpart in `baseUnitExponents2`.
This operation corresponds to multiplying the two corresponding units.

# Example
```jldoctest
julia> newtonExps = BaseUnitExponents(kg=1, m=1, s=-2)
BaseUnitExponents kg^1 m^1 s^-2 A^0 K^0 mol^0 cd^0

julia> convertToUnit(newtonExps)
Unit kg m s^-2

julia> meterExps = BaseUnitExponents(m=1)
BaseUnitExponents kg^0 m^1 s^0 A^0 K^0 mol^0 cd^0

julia> convertToUnit(meterExps)
Unit m

julia> jouleExps = newtonExps + meterExps
BaseUnitExponents kg^1 m^2 s^-2 A^0 K^0 mol^0 cd^0

julia> convertToUnit(jouleExps)
Unit kg m^2 s^-2
```
"""
function Base.:+(baseUnitExponents1::BaseUnitExponents, baseUnitExponents2::BaseUnitExponents)
    resultingExponents = BaseUnitExponents(
        kg = baseUnitExponents1.kilogramExponent + baseUnitExponents2.kilogramExponent,
        m = baseUnitExponents1.meterExponent + baseUnitExponents2.meterExponent,
        s = baseUnitExponents1.secondExponent + baseUnitExponents2.secondExponent,
        A = baseUnitExponents1.ampereExponent + baseUnitExponents2.ampereExponent,
        K = baseUnitExponents1.kelvinExponent + baseUnitExponents2.kelvinExponent,
        mol = baseUnitExponents1.molExponent + baseUnitExponents2.molExponent,
        cd = baseUnitExponents1.candelaExponent + baseUnitExponents2.candelaExponent
    )
    return resultingExponents
end
