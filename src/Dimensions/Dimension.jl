using ..Utils

@doc raw"""
    Dimension

The dimension of a physical quantity.

The dimension is expressed as a collection ``(a, b, c, d, e, f, g)`` of powers exponentiating each of the seven basic dimensions of the SI system,
```math
\mathrm{M}^a \, \mathrm{L}^b \, \mathrm{T}^c \, \mathrm{I}^d \, \mathrm{\Theta}^e \, \mathrm{N}^f \, \mathrm{J}^g,
```
where
- ``\mathrm{M}``: mass dimension
- ``\mathrm{L}``: length dimension
- ``\mathrm{T}``: time dimension
- ``\mathrm{I}``: electrical current dimension
- ``\mathrm{\Theta}``: temperature dimension
- ``\mathrm{N}``: amount of substance dimension
- ``\mathrm{J}``: luminous intensity dimension

# Fields
- `massExponent::Real`: exponent ``a`` of the mass dimension
- `lengthExponent::Real`: exponent ``b`` of the length dimension
- `timeExponent::Real`: exponent ``c`` of the time dimension
- `currentExponent::Real`: exponent ``d`` of the electrical current dimension
- `temperatureExponent::Real`: exponent ``e`` of the temperature dimension
- `amountExponent::Real`: exponent ``f`` of the amount of substance dimension
- `luminousIntensityExponent::Real`: exponent ``g`` of the luminous intensity dimension

# Constructor
```
Dimension(; M::Real=0, L::Real=0, T::Real=0, I::Real=0, θ::Real=0, N::Real=0, J::Real=0)
```

# Raises Exceptions
- `Core.DomainError`: if attempting to initialize any field with an infinite number

# Remarks
The constructor converts any exponent to `Int` if possible.

# Examples
Quantities describing an energy are of dimension
```math
 \mathrm{M} \, \mathrm{L}^{2} \, \mathrm{T}^{-2}
```
The corresponding `Dimension` object is:
```jldoctest
julia> Dimension(M=1, L=2, T=-2)
Dimension M^1 L^2 T^-2
```
Calling the constructor without any keyword arguments returns exponents that correspond to a dimensionless quantity:
```jldoctest
julia> Dimension()
Dimension 1
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

    function Dimension(; M::Real=0, L::Real=0, T::Real=0, I::Real=0, θ::Real=0, N::Real=0, J::Real=0)
        exponents = (M, L, T, I, θ, N, J)
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

function dimensionOf(unitOrQuantity) end

## Methods

# objects of type Dimension act as scalars in broadcasting
Base.broadcastable(dimension::Dimension) = Ref(dimension)
