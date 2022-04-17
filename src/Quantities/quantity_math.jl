## Arithmetic unary operators

# Unary plus
Base.:+(q::AbstractQuantity) = q
Base.:+(q::AbstractQuantityArray) = q

# Unary minus
Base.:-(q::AbstractQuantity) = unaryMinus(q)
Base.:-(q::AbstractQuantityArray) = unaryMinus(q)
unaryMinus(q::SimpleQuantityType) = (-q.value) * q.unit
unaryMinus(q::Quantity) = Quantity(-q.value, q.dimension, q.internalUnits)
unaryMinus(q::QuantityArray) = QuantityArray(-q.value, q.dimension, q.internalUnits)

## Arithmetic binary operators

# Addition
"""
    Base.:+(q1::SimpleQuantity, q2::SimpleQuantity)
    Base.:+(q1::SimpleQuantityArray, q2::SimpleQuantityArray)

Add two objects of type `SimpleQuantity` or `SimpleQuantityArray`.

The resulting quantity is expressed in units of `q1`.

# Raises Exceptions
- `Alicorn.Exceptions.DimensionMismatchError`: if `q1` and `q2` are of different dimensions
"""
function Base.:+(q1::SimpleQuantityType, q2::SimpleQuantityType)
    _addition_assertSameDimension(q1::SimpleQuantityType, q2::SimpleQuantityType)
    q2 = inUnitsOf(q2, q1.unit)
    return (q1.value + q2.value) * q1.unit
end

"""
    Base.:+(q1::Quantity, q2::Quantity)
    Base.:+(q1::QuantityArray, q2::QuantityArray)

Add two objects of type `Quantity` or `QuantityArray`.

The resulting quantity is expressed in internal units of `q1`.

# Raises Exceptions
- `Alicorn.Exceptions.DimensionMismatchError`: if `q1` and `q2` are of different dimensions
"""
function Base.:+(q1::Quantity, q2::Quantity)
    _addition_assertSameDimension(q1, q2)
    q2 = inInternalUnitsOf(q2, q1.internalUnits)
    return Quantity(q1.value + q2.value, q1.dimension, q1.internalUnits)
end

function Base.:+(q1::QuantityArray, q2::QuantityArray)
    _addition_assertSameDimension(q1, q2)
    q2 = inInternalUnitsOf(q2, q1.internalUnits)
    return QuantityArray(q1.value + q2.value, q1.dimension, q1.internalUnits)
end

function _addition_assertSameDimension(q1::AbstractQuantityType, q2::AbstractQuantityType)
    if dimensionOf(q1) != dimensionOf(q2)
        newException = Exceptions.DimensionMismatchError("summands are not of the same physical dimension")
        throw(newException)
    end
end

"""
    Base.:+(q1::SimpleQuantity, q2::Quantity)
    Base.:+(q1::Quantity, q2::SimpleQuantity)
    Base.:+(q1::SimpleQuantityArray, q2::QuantityArray)
    Base.:+(q1::QuantityArray, q2::SimpleQuantityArray)

Add two objects of type `SimpleQuantity` and `Quantity`, or `SimpleQuantityArray` and `QuantityArray`.

Returns a quantity of type `Quantity` or `QuantityArray`.

# Raises Exceptions
- `Alicorn.Exceptions.DimensionMismatchError`: if `q1` and `q2` are of different dimensions
"""
Base.:+(q1::SimpleQuantity, q2::Quantity) = Quantity(q1, q2.internalUnits) + q2
Base.:+(q1::Quantity, q2::SimpleQuantity) = q1 + Quantity(q2, q1.internalUnits)
Base.:+(q1::SimpleQuantityArray, q2::QuantityArray) = QuantityArray(q1, q2.internalUnits) + q2
Base.:+(q1::QuantityArray, q2::SimpleQuantityArray) = q1 + QuantityArray(q2, q1.internalUnits)


# Subtraction
"""
    Base.:-(q1::SimpleQuantity, q2::SimpleQuantity)
    Base.:-(q1::SimpleQuantityArray, q2::SimpleQuantityArray)

Subtract two objects of type `SimpleQuantity` or `SimpleQuantityArray`.

The resulting quantity is expressed in units of `q1`.

# Raises Exceptions
- `Alicorn.Exceptions.DimensionMismatchError`: if `q1` and `q2` are of different dimensions
"""
Base.:-(q1::SimpleQuantityType, q2::SimpleQuantityType) = q1 + (-q2)

"""
    Base.:-(q1::Quantity, q2::Quantity)
    Base.:-(q1::QuantityArray, q2::QuantityArray)

Subtract two objects of type `Quantity` or `QuantityArray`.

The resulting quantity is expressed in internal units of `q1`.

# Raises Exceptions
- `Alicorn.Exceptions.DimensionMismatchError`: if `q1` and `q2` are of different dimensions
"""
Base.:-(q1::QuantityType, q2::QuantityType) = q1 + (-q2)

"""
    Base.:-(q1::SimpleQuantity, q2::Quantity)
    Base.:-(q1::Quantity, q2::SimpleQuantity)
    Base.:-(q1::SimpleQuantityArray, q2::QuantityArray)
    Base.:-(q1::QuantityArray, q2::SimpleQuantityArray)

Subtract two objects of type `SimpleQuantity` and `Quantity`, or `SimpleQuantityArray` and `QuantityArray`.

Returns a quantity of type `Quantity` or `QuantityArray`.

# Raises Exceptions
- `Alicorn.Exceptions.DimensionMismatchError`: if `q1` and `q2` are of different dimensions
"""
Base.:-(q1::SimpleQuantityType, q2::QuantityType) = q1 + (-q2)
Base.:-(q1::QuantityType, q2::SimpleQuantityType) = q1 + (-q2)


# Multiplication
# define individual methods for all combinations to avoid ambiguities with Julia base
# SimpleQuantity
Base.:*(a::SimpleQuantity, b::SimpleQuantity) = multiplication(a, b)
Base.:*(a::SimpleQuantity, b::Number) = multiplication(a, b)
Base.:*(a::Number, b::SimpleQuantity) = multiplication(a, b)
Base.:*(a::SimpleQuantity, b::Array{<:Number}) = multiplication(a, b)
Base.:*(a::Array{<:Number}, b::SimpleQuantity) = multiplication(a, b)

# SimpleQuantityArray
Base.:*(a::SimpleQuantityArray, b::SimpleQuantityArray) = multiplication(a, b)
Base.:*(a::SimpleQuantityArray, b::Array{<:Number}) = multiplication(a, b)
Base.:*(a::Array{<:Number}, b::SimpleQuantityArray) = multiplication(a, b)
Base.:*(a::SimpleQuantityArray, b::SimpleQuantity) = multiplication(a, b)
Base.:*(a::SimpleQuantity, b::SimpleQuantityArray) = multiplication(a, b)
Base.:*(a::SimpleQuantityArray, b::Number) = multiplication(a, b)
Base.:*(a::Number, b::SimpleQuantityArray) = multiplication(a, b)

multiplication(q1::SimpleQuantityType, q2::SimpleQuantityType) =  (q1.value * q2.value) * (q1.unit * q2.unit)
multiplication(q::SimpleQuantityType, dimless::DimensionlessType) = (q.value * dimless) * q.unit
multiplication(dimless::DimensionlessType, q::SimpleQuantityType) = (dimless * q.value) * q.unit

# Quantity
Base.:*(a::Quantity, b::Quantity) = multiplication(a, b)
Base.:*(a::Quantity, b::Number) = multiplication(a, b)
Base.:*(a::Number, b::Quantity) = multiplication(a, b)
Base.:*(a::Quantity, b::Array{<:Number}) = multiplication(a, b)
Base.:*(a::Array{<:Number}, b::Quantity) = multiplication(a, b)

# QuantityArray
Base.:*(a::QuantityArray, b::QuantityArray) = multiplication(a, b)
Base.:*(a::QuantityArray, b::Array) = multiplication(a, b)
Base.:*(a::Array, b::QuantityArray) = multiplication(a, b)
Base.:*(a::QuantityArray, b::Quantity) = multiplication(a, b)
Base.:*(a::Quantity, b::QuantityArray) = multiplication(a, b)
Base.:*(a::QuantityArray, b::Number) = multiplication(a, b)
Base.:*(a::Number, b::QuantityArray) = multiplication(a, b)

function multiplication(q1::QuantityType, q2::QuantityType)
    q2 = inInternalUnitsOf(q2, q1.internalUnits)
    return _createQuantityType( q1.value * q2.value, q1.dimension * q2.dimension, q1.internalUnits )
end

function multiplication(q::QuantityType, dimless::DimensionlessType)
    return _createQuantityType( q.value * dimless, q.dimension, q.internalUnits )
end

function multiplication(dimless::DimensionlessType, q::QuantityType)
    return _createQuantityType( dimless * q.value, q.dimension, q.internalUnits )
end

function _createQuantityType(value::Union{Number, AbstractArray{<:Number}}, dimension::Dimension, intu::InternalUnits)
    if isa(value, Number)
        return Quantity(value, dimension, intu)
    else
        return QuantityArray(value, dimension, intu)
    end
end

# mixed: SimpleQuantity, SimpleQuantityArray, Quantity, and QuantityArray
Base.:*(a::SimpleQuantity, b::Quantity) = multiplication(a, b)
Base.:*(a::Quantity, b::SimpleQuantity) = multiplication(a, b)
Base.:*(a::SimpleQuantityArray, b::QuantityArray) = multiplication(a, b)
Base.:*(a::QuantityArray, b::SimpleQuantityArray) = multiplication(a, b)
Base.:*(a::SimpleQuantityArray, b::Quantity) = multiplication(a, b)
Base.:*(a::Quantity, b::SimpleQuantityArray) = multiplication(a, b)
Base.:*(a::QuantityArray, b::SimpleQuantity) = multiplication(a, b)
Base.:*(a::SimpleQuantity, b::QuantityArray) = multiplication(a, b)

multiplication(q1::SimpleQuantityType, q2::QuantityType) = _createQuantityType(q1, q2.internalUnits) * q2
multiplication(q1::QuantityType, q2::SimpleQuantityType) = q1 * _createQuantityType(q2, q1.internalUnits)

function _createQuantityType(q::SimpleQuantityType, intu::InternalUnits)
    if isa(q.value, Number)
        return Quantity(q, intu)
    else
        return QuantityArray(q, intu)
    end
end


# Division
# define individual methods for all combinations to avoid ambiguities with Julia base
# SimpleQuantity
Base.:/(a::SimpleQuantity, b::SimpleQuantity) = division(a, b)
Base.:/(a::SimpleQuantity, b::Number) = division(a, b)
Base.:/(a::Number, b::SimpleQuantity) = division(a, b)
Base.:/(a::SimpleQuantity, b::Array{<:Number}) = division(a, b)
Base.:/(a::Array{<:Number}, b::SimpleQuantity) = division(a, b)

# SimpleQuantityArray
Base.:/(a::SimpleQuantityArray, b::SimpleQuantityArray) = division(a, b)
Base.:/(a::SimpleQuantityArray, b::Array{<:Number}) = division(a, b)
Base.:/(a::Array{<:Number}, b::SimpleQuantityArray) = division(a, b)
Base.:/(a::SimpleQuantityArray, b::SimpleQuantity) = division(a, b)
Base.:/(a::SimpleQuantity, b::SimpleQuantityArray) = division(a, b)
Base.:/(a::SimpleQuantityArray, b::Number) = division(a, b)
Base.:/(a::Number, b::SimpleQuantityArray) = division(a, b)

division(q1::SimpleQuantityType, q2::SimpleQuantityType) = (q1.value / q2.value) * q1.unit / q2.unit
division(q::SimpleQuantityType, dimless::DimensionlessType) = (q.value / dimless) * q.unit
division(dimless::DimensionlessType, q::SimpleQuantityType) = (dimless / q.value) * inv(q.unit)

# Quantity
Base.:/(a::Quantity, b::Quantity) = division(a, b)
Base.:/(a::Quantity, b::Number) = division(a, b)
Base.:/(a::Number, b::Quantity) = division(a, b)
Base.:/(a::Quantity, b::Array{<:Number}) = division(a, b)
Base.:/(a::Array{<:Number}, b::Quantity) = division(a, b)

# QuantityArray
Base.:/(a::QuantityArray, b::QuantityArray) = division(a, b)
Base.:/(a::QuantityArray, b::Array) = division(a, b)
Base.:/(a::Array, b::QuantityArray) = division(a, b)
Base.:/(a::QuantityArray, b::Quantity) = division(a, b)
Base.:/(a::Quantity, b::QuantityArray) = division(a, b)
Base.:/(a::QuantityArray, b::Number) = division(a, b)
Base.:/(a::Number, b::QuantityArray) = division(a, b)

function division(q1::QuantityType, q2::QuantityType)
    q2 = inInternalUnitsOf(q2, q1.internalUnits)
    return _createQuantityType( q1.value / q2.value, q1.dimension / q2.dimension, q1.internalUnits )
end

function division(q::QuantityType, dimless::DimensionlessType)
    return _createQuantityType( q.value / dimless, q.dimension, q.internalUnits )
end

function division(dimless::DimensionlessType, q::QuantityType)
    return _createQuantityType( dimless / q.value, inv(q.dimension), q.internalUnits )
end

# mixed: SimpleQuantity, SimpleQuantityArray, Quantity, and QuantityArray
Base.:/(a::SimpleQuantity, b::Quantity) = division(a, b)
Base.:/(a::Quantity, b::SimpleQuantity) = division(a, b)
Base.:/(a::SimpleQuantityArray, b::QuantityArray) = division(a, b)
Base.:/(a::QuantityArray, b::SimpleQuantityArray) = division(a, b)
Base.:/(a::SimpleQuantityArray, b::Quantity) = division(a, b)
Base.:/(a::Quantity, b::SimpleQuantityArray) = division(a, b)
Base.:/(a::QuantityArray, b::SimpleQuantity) = division(a, b)
Base.:/(a::SimpleQuantity, b::QuantityArray) = division(a, b)

division(q1::SimpleQuantityType, q2::QuantityType) = _createQuantityType(q1, q2.internalUnits) / q2
division(q1::QuantityType, q2::SimpleQuantityType) = q1 / _createQuantityType(q2, q1.internalUnits)


# Power

# SimpleQuantity and SimpleQuantityArray
Base.:^(a::SimpleQuantityType, b::Real) = power(a, b)
Base.:^(a::SimpleQuantityType, b::Integer) = power(a, b)

function power(q::SimpleQuantityType, exponent::Real)
    exponentiatedValue = Base.literal_pow(^, q.value, Val(exponent))
    exponentiatedUnit = (q.unit)^exponent
    return exponentiatedValue * exponentiatedUnit
end

# Quantity and QuantityArray
Base.:^(a::QuantityType, b::Real) = power(a, b)
Base.:^(a::QuantityType, b::Integer) = power(a, b)

function power(q::QuantityType, exponent::Real)
    exponentiatedValue = Base.literal_pow(^, q.value, Val(exponent))
    exponentiatedDimension = (q.dimension)^exponent
    return _createQuantityType(exponentiatedValue, exponentiatedDimension, q.internalUnits)
end


# Inverse

Base.:inv(q::SimpleQuantityType) = inv(q.value) * inv(q.unit)
Base.:inv(q::QuantityType) = _createQuantityType( inv(q.value), inv(q.dimension), q.internalUnits )


## Numeric comparison

# Equality

"""
    Base.:(==)(q1::SimpleQuantity, q2::SimpleQuantity)
    Base.:(==)(q1::SimpleQuantityArray, q2::SimpleQuantityArray)

Returns `true` if `q1` and `q2` are of equal dimension and value.

If necessary, `q2` is expressed in units of `q1.unit`
before the comparison. Note that the conversion oftens lead to rounding errors
that render `q1` not equal `q2`.

# Examples
```jldoctest
julia> ucat = UnitCatalogue() ;

julia> q1 = 7 * ucat.meter
7 m

julia> q2 = 700 * (ucat.centi * ucat.meter)
700 cm

julia> q1 == q1
true

julia> q1 == q2
true
```
"""
function Base.:(==)(q1::SimpleQuantityType, q2::SimpleQuantityType)
    if dimensionOf(q1) != dimensionOf(q2)
        return false
    else
        q2 = inUnitsOf(q2, q1.unit)
        return q1.value == q2.value
    end
end

"""
    Base.:(==)(q1::Quantity, q2::Quantity)
    Base.:(==)(q1::QuantityArray, q2::QuantityArray)

Compare two `Quantity` or `QuantityArray` objects.

The two quantities are equal if their values, their dimensions, and their internal units are equal.
Note that the internal units are not converted during the comparison.
"""
function Base.:(==)(q1::QuantityType, q2::QuantityType)
    valuesEqual = ( q1.value == q2.value )
    dimensionsEqual = ( q1.dimension == q2.dimension )
    internalUnitsEqual = ( q1.internalUnits == q2.internalUnits )
    isEqual = valuesEqual && dimensionsEqual && internalUnitsEqual
    return isEqual
end


# isless

"""
    Base.isless(q1::SimpleQuantity, q2::SimpleQuantity)

Returns `true` if `q1` is of lesser value than `q2`.

If necessary, `q2` is expressed in units of `q1.unit`
before the comparison. Note that the conversion often leads to rounding errors.

# Raises Exceptions
- `Alicorn.Exceptions.DimensionMismatchError`: if `q1` and
`q2` are not of the same dimension
"""
function Base.isless(q1::SimpleQuantity, q2::SimpleQuantity)
    _assertComparedWithSameDimension(q1, q2)
    q2 = inUnitsOf(q2, q1.unit)
    return isless( q1.value, q2.value )
end

"""
    Base.isless(q1::Quantity, q2::Quantity)

Returns `true` if `q1` is of lesser value than `q2`.

If necessary, `q2` is expressed in internal units of `q1.internalUnits`
before the comparison. Note that the conversion often leads to rounding errors.

# Raises Exceptions
- `Alicorn.Exceptions.DimensionMismatchError`: if `q1` and
`q2` are not of the same dimension
"""
function Base.isless(q1::Quantity, q2::Quantity)
    _assertComparedWithSameDimension(q1, q2)
    q2 = inInternalUnitsOf(q2, q1.internalUnits)
    return isless( q1.value, q2.value )
end

function _assertComparedWithSameDimension(q1::AbstractQuantity, q2::AbstractQuantity)
    if dimensionOf(q1) != dimensionOf(q2)
        newException = Exceptions.DimensionMismatchError("compared quantities are not of the same physical dimension")
        throw(newException)
    end
end


# isfinite
Base.isfinite(q::AbstractQuantity) = isfinite(q.value)

# isinf
Base.isinf(q::AbstractQuantity) = isinf(q.value)

# isnan
Base.isnan(q::AbstractQuantity) = isnan(q.value)


# isapprox

"""
    Base.isapprox(q1::SimpleQuantity, q2::SimpleQuantity; rtol::Real = sqrt(eps()) )
    Base.isapprox(q1::SimpleQuantityArray, q2::SimpleQuantityArray; rtol::Real = sqrt(eps()) )

Returns `isapprox(q1.value, q2.value, rtol=rtol)`.

If necessary, `q2` is expressed in units of `q1.unit`
before the comparison. Note that the conversion often leads to rounding errors.

Returns `false` if the two quantities are not of equal physical dimension.
"""
function Base.isapprox(q1::SimpleQuantityType, q2::SimpleQuantityType; rtol::Real = sqrt(eps()))
    if dimensionOf(q1) != dimensionOf(q2)
        return false
    else
        q2 = inUnitsOf(q2, q1.unit)
        return isapprox(q1.value, q2.value, rtol=rtol)
    end
end

"""
    Base.isapprox(q1::Quantity, q2::Quantity; rtol::Real = sqrt(eps()) )
    Base.isapprox(q1::QuantityArray, q2::QuantityArray; rtol::Real = sqrt(eps()) )

Returns `isapprox(q1.value, q2.value, rtol=rtol)`.

If necessary, `q2` is expressed in internal units of `q1.internalUnits`
before the comparison. Note that the conversion often leads to rounding errors.

Returns `false` if the two quantities are not of equal physical dimension.
"""
function Base.isapprox(q1::QuantityType, q2::QuantityType; rtol::Real = sqrt(eps()))
    if dimensionOf(q1) != dimensionOf(q2)
        return false
    else
        q2 = inInternalUnitsOf(q2, q1.internalUnits)
        return isapprox(q1.value, q2.value, rtol=rtol)
    end
end


## Sign and absolute value

# abs
Base.abs(q::SimpleQuantity) = SimpleQuantity(abs(q.value), q.unit)
Base.abs(q::Quantity) = Quantity(abs(q.value), q.dimension, q.internalUnits)

# abs2
Base.abs2(q::SimpleQuantity) = SimpleQuantity( abs2(q.value), (q.unit)^2 )
Base.abs2(q::Quantity) = Quantity( abs2(q.value), q.dimension^2, q.internalUnits)

# sign
Base.sign(q::Union{SimpleQuantity, Quantity}) = sign(q.value)

# signbit
Base.signbit(q::Union{SimpleQuantity, Quantity}) = signbit(q.value)

# copysign
# to SimpleQuantity
Base.copysign(q1::SimpleQuantity, q2::Union{SimpleQuantity, Quantity}) =
    SimpleQuantity(copysign(q1.value, q2.value), q1.unit)
Base.copysign(q::SimpleQuantity, number::Number) = SimpleQuantity(copysign(q.value, number), q.unit)
# to Quantity
Base.copysign(q1::Quantity, q2::Union{SimpleQuantity, Quantity}) =
    Quantity(copysign(q1.value, q2.value), q1.dimension, q1.internalUnits)
Base.copysign(q::Quantity, number::Number) = Quantity(copysign(q.value, number), q.dimension, q.internalUnits)
# to Number
Base.copysign(number::Number, q::Union{SimpleQuantity, Quantity}) = copysign(number, q.value)

# flipsign
# of SimpleQuantity
Base.flipsign(q1::SimpleQuantity, q2::Union{SimpleQuantity, Quantity}) =
    SimpleQuantity(flipsign(q1.value, q2.value), q1.unit)
Base.flipsign(q1::SimpleQuantity, number::Number) =
    SimpleQuantity(flipsign(q1.value, number), q1.unit)
# of Quantity
Base.flipsign(q1::Quantity, q2::Union{SimpleQuantity, Quantity}) =
    Quantity(flipsign(q1.value, q2.value), q1.dimension, q1.internalUnits)
Base.flipsign(q1::Quantity, number::Number) =
    Quantity(flipsign(q1.value, number), q1.dimension, q1.internalUnits)
# of Number
Base.flipsign(number::Number, q::Union{SimpleQuantity, Quantity}) = flipsign(number, q.value)


## Roots

# sqrt
Base.sqrt(q::SimpleQuantity) = SimpleQuantity( sqrt(q.value), sqrt(q.unit) )
Base.sqrt(q::Quantity) = Quantity( sqrt(q.value), q.dimension^(1/2), q.internalUnits )

# cbrt
Base.cbrt(q::SimpleQuantity) = SimpleQuantity( cbrt(q.value), cbrt(q.unit) )
Base.cbrt(q::Quantity) = Quantity( cbrt(q.value), q.dimension^(1/3), q.internalUnits )


## Complex numbers

# real
Base.real(q::SimpleQuantityType) = real(q.value) * q.unit
Base.real(q::QuantityType) = _createQuantityType( real(q.value), q.dimension, q.internalUnits )

# imag
Base.imag(q::SimpleQuantityType) = imag(q.value) * q.unit
Base.imag(q::QuantityType) = _createQuantityType( imag(q.value), q.dimension, q.internalUnits )

# angle
Base.angle(q::Union{SimpleQuantity, Quantity}) = angle(q.value)

# conj
Base.conj(q::SimpleQuantity) = SimpleQuantity(conj(q.value), q.unit)
Base.conj(q::Quantity) = Quantity(conj(q.value), q.dimension, q.internalUnits)
