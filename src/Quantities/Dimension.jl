using ..Utils

export Dimension
@doc raw"""
    Dimension

The dimension of a physical quantity, expressed as a collection of powers exponentiating each of the seven basic dimensions of the SI system.

# Fields
- `massExponent::Real`
- `lengthExponent::Real`
- `timeExponent::Real`
- `currentExponent::Real`
- `temperatureExponent::Real`
- `amountExponent::Real`
- `luminousIntensityExponent::Real`

# Constructor
```
Dimension(; length::Real=0, mass::Real=0, time::Real=0, current::Real=0, temperature::Real=0, amount::Real=0, luminousIntensity::Real=0)

# Raises Exceptions
- `Core.DomainError`: if attempting to initialize any field with an infinite number

# Remarks
The constructor converts any exponent to `Int` if possible.

# Examples
TODO
```
"""
struct Dimension
    massExponent::Real
    lengthExponent::Real
    timeExponent::Real
    currentExponent::Real
    temperatureExponent::Real
    amountExponent::Real
    luminousIntensityExponent::Real

    function Dimension(; length::Real=0, mass::Real=0, time::Real=0, current::Real=0, temperature::Real=0, amount::Real=0, luminousIntensity::Real=0)
        exponents = (mass, length, time, current, temperature, amount, luminousIntensity)
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

# objects of type Dimension act as scalars in broadcasting
Base.broadcastable(dimension::Dimension) = Ref(dimension)

"""
    Base.:*(number::Number, dimension::Dimension)

TODO
"""
function Base.:*(number::Number, dimension::Dimension)
    resultingDimension = Dimension(
        mass = number * dimension.massExponent,
        length = number * dimension.lengthExponent,
        time = number * dimension.timeExponent,
        current = number * dimension.currentExponent,
        temperature = number * dimension.temperatureExponent,
        amount = number * dimension.amountExponent,
        luminousIntensity = number * dimension.luminousIntensityExponent
    )
    return resultingDimension
end

# documented together with Base.:*(number::Number, dimension::Dimension)
function Base.:*(dimension::Dimension, number::Number)
    return number * dimension
end

"""
    Base.:+(dimension1::Dimension, dimension2::Dimension)

TODO
"""
function Base.:+(dimension1::Dimension, dimension2::Dimension)
    resultingExponents = Dimension(
        mass = dimension1.massExponent + dimension2.massExponent,
        length = dimension1.lengthExponent + dimension2.lengthExponent,
        time = dimension1.timeExponent + dimension2.timeExponent,
        current = dimension1.currentExponent + dimension2.currentExponent,
        temperature = dimension1.temperatureExponent + dimension2.temperatureExponent,
        amount = dimension1.amountExponent + dimension2.amountExponent,
        luminousIntensity = dimension1.luminousIntensityExponent + dimension2.luminousIntensityExponent
    )
    return resultingExponents
end
