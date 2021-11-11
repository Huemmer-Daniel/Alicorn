using ..Exceptions

@doc raw"""
    InternalUnits

A set of seven `SimpleQuantity` objects which represent a choice of units with
respect to which the seven basic physical dimensions of the SI system are
measured.

# Fields
- `mass::SimpleQuantity`: unit of mass
- `length::SimpleQuantity`: unit of length
- `time::SimpleQuantity`: unit of time
- `current::SimpleQuantity`: unit of current
- `temperature::SimpleQuantity`: unit of temperature
- `amount::SimpleQuantity`: unit of amount
- `luminousIntensity::SimpleQuantity`: unit of luminousIntensity

# Constructors
```
InternalUnits(::SimpleQuantity, ::SimpleQuantity, ::SimpleQuantity, ::SimpleQuantity, ::SimpleQuantity, ::SimpleQuantity, ::SimpleQuantity)
InternalUnits(; mass = 1*kilogram, length = 1*meter, time = 1*second, current = 1*ampere,temperature = 1*kelvin, amount = 1*mol, luminousIntensity = 1*candela)

# Raises Exceptions
- `Core.DomainError`: if attempting to initialize any field with a quantity
of a value that is zero, infinite, or not real
- `Exceptions.DimensionMismatchError`: if attempting to initialize any field
with a quantity whose dimension does not match the physical dimension the field
represents

# Examples
The following `InternalUnits` measure lengths in units of ``3 cm`` and uses
the basic SI units for all other dimensions:
```jldoctest
julia> ucat = UnitCatalogue(); cm = ucat.centi * ucat.meter ;

julia> InternalUnits(length = 3cm)
InternalUnits
 mass unit:               1 kg
 length unit:             3 cm
 time unit:               1 s
 current unit:            1 A
 temperature unit:        1 K
 amount unit:             1 mol
 luminous intensity unit: 1 cd
```
"""
struct InternalUnits
    mass::SimpleQuantity
    length::SimpleQuantity
    time::SimpleQuantity
    current::SimpleQuantity
    temperature::SimpleQuantity
    amount::SimpleQuantity
    luminousIntensity::SimpleQuantity

    function InternalUnits(
            mass::SimpleQuantity,
            length::SimpleQuantity,
            time::SimpleQuantity,
            current::SimpleQuantity,
            temperature::SimpleQuantity,
            amount::SimpleQuantity,
            luminousIntensity::SimpleQuantity
        )
        internalUnits = (mass, length, time, current, temperature, amount, luminousIntensity)
        _verifyArguments(internalUnits)
        return new(internalUnits...)
    end
end

function _verifyArguments(internalUnits::Tuple)
    correctDimensions = _getCorrectDimensions()
    for (internalUnit, correctDimension) in zip(internalUnits, correctDimensions)
        _assertIsReal(internalUnit)
        _assertIsFinite(internalUnit)
        _assertIsNonzero(internalUnit)
        _assertHasCorrectDimension(internalUnit, correctDimension)
    end
end

function _getCorrectDimensions()
    correctDimensions = (
        Dimension(M=1),
        Dimension(L=1),
        Dimension(T=1),
        Dimension(I=1),
        Dimension(θ=1),
        Dimension(N=1),
        Dimension(J=1)
    )
    return correctDimensions
end

function _assertIsReal(internalUnit::SimpleQuantity)
    value = internalUnit.value
    if !isa(value, Real)
        error = Core.DomainError("the values of internal units need to be real numbers")
        throw(error)
    end
end

function _assertIsFinite(internalUnit::SimpleQuantity)
    if !isfinite(internalUnit.value)
        error = Core.DomainError("the values of internal units need to be finite")
        throw(error)
    end
end

function _assertIsNonzero(internalUnit::SimpleQuantity)
    if internalUnit.value == 0
        error = Core.DomainError("the values of internal units need to be nonzero")
        throw(error)
    end
end

function _assertHasCorrectDimension(internalUnit::SimpleQuantity, correctDimension::Dimension)
    if dimensionOf(internalUnit) != correctDimension
        error = Exceptions.DimensionMismatchError("the specified internal unit has the wrong physical dimension")
        throw(error)
    end
end

## External Constructors

function InternalUnits(;
        mass::SimpleQuantity = 1 * kilogram,
        length::SimpleQuantity = 1 * meter,
        time::SimpleQuantity = 1 * second,
        current::SimpleQuantity = 1 * ampere,
        temperature::SimpleQuantity = 1 * kelvin,
        amount::SimpleQuantity = 1 * mol,
        luminousIntensity::SimpleQuantity = 1 * candela
    )
    internalUnits = (mass, length, time, current, temperature, amount, luminousIntensity)
    return InternalUnits(internalUnits...)
end


## Methods

"""
    Base.:(==)(internalUnits1::InternalUnits, internalUnits2::InternalUnits)

Compare two `InternalUnits` objects.

Two `InternalUnits` objects are equal if the `SimpleQuantity` objects
representing the unit for each of the seven physical dimensions are equal.
"""
function Base.:(==)(internalUnits1::InternalUnits, internalUnits2::InternalUnits)
    massUnitEqual = ( internalUnits1.mass == internalUnits2.mass )
    lengthUnitEqual = ( internalUnits1.length == internalUnits2.length )
    timeUnitEqual = ( internalUnits1.time == internalUnits2.time )
    currentUnitEqual = ( internalUnits1.current == internalUnits2.current )
    temperatureUnitEqual = ( internalUnits1.temperature == internalUnits2.temperature )
    amountUnitEqual = ( internalUnits1.amount == internalUnits2.amount )
    luminousIntensityUnitEqual = ( internalUnits1.luminousIntensity == internalUnits2.luminousIntensity )

    isEqual = massUnitEqual && lengthUnitEqual && timeUnitEqual && currentUnitEqual && temperatureUnitEqual && amountUnitEqual && luminousIntensityUnitEqual
    return isEqual
end

"""
    internalUnitFor(dimension::Dimension, internalUnits::InternalUnits)

Returns a `SimpleQuantity` representing the unit in which quantities of physical
dimension `dimension` are measured according to `internalUnits`.
"""
function internalUnitFor(dimension::Dimension, internalUnits::InternalUnits)
    Mexp = dimension.massExponent
    Lexp = dimension.lengthExponent
    Texp = dimension.timeExponent
    Iexp = dimension.currentExponent
    Θexp = dimension.temperatureExponent
    Nexp = dimension.amountExponent
    Jexp = dimension.luminousIntensityExponent

    Munit = internalUnits.mass
    Lunit = internalUnits.length
    Tunit = internalUnits.time
    Iunit = internalUnits.current
    θunit = internalUnits.temperature
    Nunit = internalUnits.amount
    Junit = internalUnits.luminousIntensity

    internalUnit = Munit^Mexp * Lunit^Lexp * Tunit^Texp * Iunit^Iexp * θunit^Θexp * Nunit^Nexp * Junit^Jexp
    return internalUnit
end

"""
    conversionFactor(dimension::Dimension, currentIntU::InternalUnits, targetIntU::InternalUnits)

Returns the factor with which a value of physical dimension `dimension`
expressed in units of `currentIntU` needs to be mutliplied in order to express
it in units of `targetIntU`.
"""
function conversionFactor(dimension::Dimension, currentIntU::InternalUnits, targetIntU::InternalUnits)
    currentInternalUnit = internalUnitFor(dimension, currentIntU)
    targetInternalUnit = internalUnitFor(dimension, targetIntU)
    conversionFactor = valueOfDimensionless(currentInternalUnit/targetInternalUnit)
    return conversionFactor
end
