using ..Utils

export Dimension
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
Dimension M^1 L^2 T^-2 I^0 θ^0 N^0 J^0
```
Calling the constructor without any keyword arguments returns exponents that correspond to a dimensionless quantity:
```jldoctest
julia> Dimension()
Dimension M^0 L^0 T^0 I^0 θ^0 N^0 J^0
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

## Methods

# objects of type Dimension act as scalars in broadcasting
Base.broadcastable(dimension::Dimension) = Ref(dimension)

"""
    Base.:*(number::Number, dimension::Dimension)
    Base.:*(dimension::Dimension, number::Number)

Multiply each exponent in `dimension` by `number`.

If a quantity `Q` is of dimension `D`, then `Q^p` is of dimension `D2 = p * D`.

# Example
Let us consider a quantity `Q` of dimension 'length':
```jldoctest
julia> ucat = UnitCatalogue() ;

julia> Q = 2 * ucat.meter
2 m

julia> D = dimensionOf(Q)
Dimension M^0 L^1 T^0 I^0 θ^0 N^0 J^0
```
If we raise `Q` to the power of 3, it has dimension ``L^3`` which can be represented by `3 * D`:
```jldoctest; setup = :( ucat = UnitCatalogue(); Q = 2 * ucat.meter; D = dimensionOf(Q) )
julia> D2 = dimensionOf(Q^3)
Dimension M^0 L^3 T^0 I^0 θ^0 N^0 J^0

julia> D2 == 3 * D
true
```
"""
function Base.:*(number::Number, dimension::Dimension)
    resultingDimension = Dimension(
        M = number * dimension.massExponent,
        L = number * dimension.lengthExponent,
        T = number * dimension.timeExponent,
        I = number * dimension.currentExponent,
        θ = number * dimension.temperatureExponent,
        N = number * dimension.amountExponent,
        J = number * dimension.luminousIntensityExponent
    )
    return resultingDimension
end

# documented together with Base.:*(number::Number, dimension::Dimension)
function Base.:*(dimension::Dimension, number::Number)
    return number * dimension
end

"""
    Base.:+(dimension1::Dimension, dimension2::Dimension)

Add each exponent in `dimension1` to its counterpart in `dimension2`.

If a quantity `Q1` (`Q2`)s of dimension `D1` (`D2`), then `Q1 * Q2` is of dimension `D = D1 + D2`.

# Example
```jldoctest
julia> ucat = UnitCatalogue() ;

julia> Q1 = 2 * ucat.meter
2 m

julia> D1 = dimensionOf(Q1)
Dimension M^0 L^1 T^0 I^0 θ^0 N^0 J^0

julia> Q2 = 3 / ucat.second
3 s^-1

julia> D2 = dimensionOf(Q2)
Dimension M^0 L^0 T^-1 I^0 θ^0 N^0 J^0

julia> D = dimensionOf( Q1 * Q2 )
Dimension M^0 L^1 T^-1 I^0 θ^0 N^0 J^0

julia> D == D1 + D2
true
```
"""
function Base.:+(dimension1::Dimension, dimension2::Dimension)
    resultingExponents = Dimension(
        M = dimension1.massExponent + dimension2.massExponent,
        L = dimension1.lengthExponent + dimension2.lengthExponent,
        T = dimension1.timeExponent + dimension2.timeExponent,
        I = dimension1.currentExponent + dimension2.currentExponent,
        θ = dimension1.temperatureExponent + dimension2.temperatureExponent,
        N = dimension1.amountExponent + dimension2.amountExponent,
        J = dimension1.luminousIntensityExponent + dimension2.luminousIntensityExponent
    )
    return resultingExponents
end

export dimensionOf
@doc raw"""
    dimensionOf(abstractUnit::AbstractUnit)

Returns the dimension of a physical unit of type [`AbstractUnit`](@ref).

# Example
One siemens is defined as ``1\,\mathrm{S} = 1\,\mathrm{kg}^{-1}\,\mathrm{m}^{-2}\,\mathrm{s}^3\,\mathrm{A}^2``. The unit is hence of dimension ``\mathrm{M}^{-1}\,\mathrm{L}^{-2}\,\mathrm{T}^3\,\mathrm{I}^2``:
```jldoctest
julia> ucat = UnitCatalogue() ;

julia> siemens = ucat.siemens
BaseUnit siemens (1 S = 1 kg^-1 m^-2 s^3 A^2)
julia> dimensionOf(siemens)
Dimension M^-1 L^-2 T^3 I^2 θ^0 N^0 J^0
```
"""
function dimensionOf(abstractUnit::AbstractUnit)
    unit = convertToUnit(abstractUnit)
    return dimensionOf(unit)
end

# documented together with dimensionOf(abstractUnit::AbstractUnit)
function dimensionOf(unit::Unit)
    unitFactors = unit.unitFactors

    unitFactor_dimensions = map(dimensionOf, unitFactors)
    dimension = sum(unitFactor_dimensions)
    return dimension
end

# documented together with dimensionOf(abstractUnit::AbstractUnit)
function dimensionOf(unitFactor::UnitFactor)
    baseUnit = unitFactor.baseUnit
    exponent = unitFactor.exponent

    baseUnit_dimension = dimensionOf(baseUnit)
    dimension = exponent * baseUnit_dimension
    return dimension
end

# documented together with dimensionOf(abstractUnit::AbstractUnit)
function dimensionOf(baseUnit::BaseUnit)
    baseUnitExps = baseUnit.exponents

    dimension = Dimension(
        M = baseUnitExps.kilogramExponent,
        L = baseUnitExps.meterExponent,
        T = baseUnitExps.secondExponent,
        I = baseUnitExps.ampereExponent,
        θ = baseUnitExps.kelvinExponent,
        N = baseUnitExps.molExponent,
        J = baseUnitExps.candelaExponent,
    )
    return dimension
end

@doc raw"""
    dimensionOf(quantity::AbstractQuantity)

Returns the dimension of a physical quantity of type [`AbstractQuantity`](@ref).

# Example
One henry is defined as ``1\,\mathrm{H} = 1\,\mathrm{kg}^{1}\,\mathrm{m}^{2}\,\mathrm{s}^{-2}\,\mathrm{A}^{-2}`` and is hence of dimension ``\mathrm{M}^{1}\,\mathrm{L}^{2}\,\mathrm{T}^{-2}\,\mathrm{I}^{-2}``:
```jldoctest
julia> ucat = UnitCatalogue() ;

julia> oneHenry = 1 * ucat.henry
1 H
julia> dimensionOf(oneHenry)
Dimension M^1 L^2 T^-2 I^-2 θ^0 N^0 J^0
```
"""
function dimensionOf(abstractQuantity::AbstractQuantity) end

dimensionOf(simpleQuantity::SimpleQuantity) = dimensionOf(simpleQuantity.unit)

dimensionOf(quantity::Quantity) = quantity.dimension

@doc raw"""
    dimensionOf(quantityArray::AbstractQuantityArray)

Returns the dimension of a physical quantity of type [`AbstractQuantityArray`](@ref),
analogous to [`dimensionOf(::AbstractQuantity)`](@ref)
```
"""
function dimensionOf(quantityArray::AbstractQuantityArray) end

dimensionOf(sqArray::SimpleQuantityArray) = dimensionOf(sqArray.unit)

dimensionOf(qArray::QuantityArray) = qArray.dimension
