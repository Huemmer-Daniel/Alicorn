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
Dimension L^1
```
If we raise `Q` to the power of 3, it has dimension ``L^3`` which can be represented by `3 * D`:
```jldoctest; setup = :( ucat = UnitCatalogue(); Q = 2 * ucat.meter; D = dimensionOf(Q) )
julia> D2 = dimensionOf(Q^3)
Dimension L^3

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

"""
    Base.inv(dimension::Dimension)

Invert a physical dimension.

If a quantity `Q` is of dimension `D`, then `1/Q` is of dimension `inv(D)`.
"""
function Base.inv(dimension::Dimension)
        resultingExponents = Dimension(
        M = -dimension.massExponent,
        L = -dimension.lengthExponent,
        T = -dimension.timeExponent,
        I = -dimension.currentExponent,
        θ = -dimension.temperatureExponent,
        N = -dimension.amountExponent,
        J = -dimension.luminousIntensityExponent
    )
    return resultingExponents
end


Base.:*(dimension::Dimension, number::Number) = number * dimension

"""
    Base.:*(dimension1::Dimension, dimension2::Dimension)

Add each exponent in `dimension1` to its counterpart in `dimension2`.

If a quantity `Q1` (`Q2`) is of dimension `D1` (`D2`), then `Q1 * Q2` is of dimension `D1 * D2`.

# Example
```jldoctest
julia> ucat = UnitCatalogue() ;

julia> Q1 = 2 * ucat.meter
2 m

julia> D1 = dimensionOf(Q1)
Dimension L^1

julia> Q2 = 3 / ucat.second
3 s^-1

julia> D2 = dimensionOf(Q2)
Dimension T^-1

julia> D = dimensionOf( Q1 * Q2 )
Dimension L^1 T^-1

julia> D == D1 * D2
true
```
"""
function Base.:*(dimension1::Dimension, dimension2::Dimension)
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


"""
    Base.:/(dimension1::Dimension, dimension2::Dimension)

Subtract each exponent in `dimension2` from its counterpart in `dimension1`.

If a quantity `Q1` (`Q2`) is of dimension `D1` (`D2`), then `Q1 / Q2` is of dimension `D1 / D2`.

# Example
```jldoctest
julia> ucat = UnitCatalogue() ;

julia> Q1 = 2 * ucat.meter
2 m

julia> D1 = dimensionOf(Q1)
Dimension L^1

julia> Q2 = 3 / ucat.second
3 s^-1

julia> D2 = dimensionOf(Q2)
Dimension T^-1

julia> D = dimensionOf( Q1 / Q2 )
Dimension L^1 T^1

julia> D == D1 / D2
true
```
"""
function Base.:/(dimension1::Dimension, dimension2::Dimension)
    return dimension1 * inv(dimension2)
end


"""
    Base.:^(dimension::Dimension, exponent::Number)

Exponentiate a physical dimension.

If a quantity `Q` is of dimension `D`, then `Q^p` is of dimension `D^p`.
"""
function Base.:^(dimension::Dimension, exponent::Number)
    resultingExponents = Dimension(
        M = exponent * dimension.massExponent,
        L = exponent * dimension.lengthExponent,
        T = exponent * dimension.timeExponent,
        I = exponent * dimension.currentExponent,
        θ = exponent * dimension.temperatureExponent,
        N = exponent * dimension.amountExponent,
        J = exponent * dimension.luminousIntensityExponent
    )
    return resultingExponents
end

"""
    Base.:sqrt(dimension::Dimension)

Square root a physical dimension.

If a quantity `Q` is of dimension `D`, then `sqrt(Q)` is of dimension `sqrt(D)`.
"""
function Base.:sqrt(dimension::Dimension)
    resultingExponents = Dimension(
        M = dimension.massExponent/2,
        L = dimension.lengthExponent/2,
        T = dimension.timeExponent/2,
        I = dimension.currentExponent/2,
        θ = dimension.temperatureExponent/2,
        N = dimension.amountExponent/2,
        J = dimension.luminousIntensityExponent/2
    )
    return resultingExponents
end

"""
    Base.:cbrt(dimension::Dimension)

Cubic root a physical dimension.

If a quantity `Q` is of dimension `D`, then `cbrt(Q)` is of dimension `cbrt(D)`.
"""
function Base.:cbrt(dimension::Dimension)
    resultingExponents = Dimension(
        M = dimension.massExponent/3,
        L = dimension.lengthExponent/3,
        T = dimension.timeExponent/3,
        I = dimension.currentExponent/3,
        θ = dimension.temperatureExponent/3,
        N = dimension.amountExponent/3,
        J = dimension.luminousIntensityExponent/3
    )
    return resultingExponents
end
