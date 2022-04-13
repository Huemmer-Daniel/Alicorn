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
function Dimensions.dimensionOf(abstractUnit::AbstractUnit)
    unit = convertToUnit(abstractUnit)
    return dimensionOf(unit)
end

function Dimensions.dimensionOf(unit::Unit)
    unitFactors = unit.unitFactors

    unitFactor_dimensions = map(dimensionOf, unitFactors)
    dimension = prod(unitFactor_dimensions)
    return dimension
end

function Dimensions.dimensionOf(unitFactor::UnitFactor)
    baseUnit = unitFactor.baseUnit
    exponent = unitFactor.exponent

    baseUnit_dimension = dimensionOf(baseUnit)
    dimension = exponent * baseUnit_dimension
    return dimension
end

function Dimensions.dimensionOf(baseUnit::BaseUnit)
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
