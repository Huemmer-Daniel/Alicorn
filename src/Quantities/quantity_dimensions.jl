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
Dimensions.dimensionOf(abstractQuantity::AbstractQuantity) = Dimensions.dimensionOf(abstractQuantity)

Dimensions.dimensionOf(simpleQuantity::SimpleQuantity) = dimensionOf(simpleQuantity.unit)

Dimensions.dimensionOf(quantity::Quantity) = quantity.dimension

@doc raw"""
    dimensionOf(quantityArray::AbstractQuantityArray)

Returns the dimension of a physical quantity of type [`AbstractQuantityArray`](@ref),
analogous to [`dimensionOf(::AbstractQuantity)`](@ref)
```
"""
Dimensions.dimensionOf(quantityArray::AbstractQuantityArray) = Dimensions.dimensionOf(quantityArray)

Dimensions.dimensionOf(sqArray::SimpleQuantityArray) = dimensionOf(sqArray.unit)

Dimensions.dimensionOf(qArray::QuantityArray) = qArray.dimension
