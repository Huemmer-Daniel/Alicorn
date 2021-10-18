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
Dimension M^-1 L^-2 T^3 I^2
```
"""
function dimensionOf(abstractUnit::AbstractUnit)
    unit = convertToUnit(abstractUnit)
    return dimensionOf(unit)
end

function dimensionOf(unit::Unit)
    unitFactors = unit.unitFactors

    unitFactor_dimensions = map(dimensionOf, unitFactors)
    dimension = sum(unitFactor_dimensions)
    return dimension
end

function dimensionOf(unitFactor::UnitFactor)
    baseUnit = unitFactor.baseUnit
    exponent = unitFactor.exponent

    baseUnit_dimension = dimensionOf(baseUnit)
    dimension = exponent * baseUnit_dimension
    return dimension
end

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
Dimension M^1 L^2 T^-2 I^-2
```
"""
function dimensionOf(abstractQuantity::AbstractQuantity)
    simpleQuantity = inBasicSIUnits(abstractQuantity)
    return dimensionOf(simpleQuantity)
end

dimensionOf(simpleQuantity::SimpleQuantity) = dimensionOf(simpleQuantity.unit)

dimensionOf(quantity::Quantity) = quantity.dimension

@doc raw"""
    dimensionOf(quantityArray::AbstractQuantityArray)

Returns the dimension of a physical quantity of type [`AbstractQuantityArray`](@ref),
analogous to [`dimensionOf(::AbstractQuantity)`](@ref)
```
"""
function dimensionOf(quantityArray::AbstractQuantityArray)
    sqArray = inBasicSIUnits(quantityArray)
    return dimensionOf(sqArray)
end

dimensionOf(sqArray::SimpleQuantityArray) = dimensionOf(sqArray.unit)

dimensionOf(qArray::QuantityArray) = qArray.dimension
