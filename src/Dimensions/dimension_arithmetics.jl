"""
    Base.:*(number::Number, dimension::Dimension)
    Base.:*(dimension::Dimension, number::Number)

Multiply each exponent in `dimension` by `number`.

If a quantity `Q` is of dimension `D`, then `Q^p` is of dimension `p * D`.

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

Base.:*(dimension::Dimension, number::Number) = number * dimension

"""
    Base.:+(dimension1::Dimension, dimension2::Dimension)

Add each exponent in `dimension1` to its counterpart in `dimension2`.

If a quantity `Q1` (`Q2`)s of dimension `D1` (`D2`), then `Q1 * Q2` is of dimension `D1 + D2`.

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
