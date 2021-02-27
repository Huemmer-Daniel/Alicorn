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
end

function _assertValidNrOfArgs(internalUnits::Tuple)
    # TODO
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
