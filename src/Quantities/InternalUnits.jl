using ..Exceptions

export InternalUnits
@doc raw"""
TODO
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
    _assertQuantitiesAreReals(internalUnits)
    _assertQuantitiesAreFinite(internalUnits)
    _assertQuantitiesAreNonzero(internalUnits)
    _assertQuantitiesHaveCorrectDimension(internalUnits)
end

function _assertQuantitiesAreReals(internalUnits::Tuple)
    for quantity in internalUnits
        _assertQuantityIsReal(quantity)
    end
end

function _assertQuantityIsReal(quantity::SimpleQuantity)
    value = quantity.value
    if !isa(value, Real)
        error = Core.DomainError("the values of internal units need to be real numbers")
        throw(error)
    end
end

function _assertQuantitiesAreFinite(internalUnits::Tuple)
    for quantity in internalUnits
        _assertQuantityIsFinite(quantity)
    end
end

function _assertQuantityIsFinite(quantity::SimpleQuantity)
    value = quantity.value
    if !isfinite(value)
        error = Core.DomainError("the values of internal units need to be finite")
        throw(error)
    end
end

function _assertQuantitiesAreNonzero(internalUnits::Tuple)
    for quantity in internalUnits
        _assertQuantityIsNonzero(quantity)
    end
end

function _assertQuantityIsNonzero(quantity::SimpleQuantity)
    value = quantity.value
    if value == 0
        error = Core.DomainError("the values of internal units need to be nonzero")
        throw(error)
    end
end

function _assertQuantitiesHaveCorrectDimension(internalUnits::Tuple)
    correctDimensions = _getCorrectDimensions()
    for (internalUnit, correctDimension) in zip(internalUnits, correctDimensions)
        _assertQuantityHasCorrectDimension(internalUnit, correctDimension)
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

function _assertQuantityHasCorrectDimension(quantity::SimpleQuantity, correctDimension::Dimension)
    actualDimension = dimensionOf(quantity)
    if actualDimension != correctDimension
        error = Exceptions.DimensionMismatchError("the specified internal unit has the wrong physical dimension")
        throw(error)
    end
end

# External Constructors

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

# Arithmetics

"""
    Base.:(==)(internalUnits1::InternalUnits, internalUnits2::InternalUnits)

Compare two `InternalUnits` objects.
TODO
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
