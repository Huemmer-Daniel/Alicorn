## Arithmetic unary operators

# unary plus
Base.:+(q::AbstractQuantity) = q
Base.:+(q::AbstractQuantityArray) = q

# unary minus
Base.:-(q::AbstractQuantity) = unaryMinus(q)
Base.:-(q::AbstractQuantityArray) = unaryMinus(q)
unaryMinus(q::SimpleQuantityType) = (-q.value) * q.unit
unaryMinus(q::Quantity) = Quantity(-q.value, q.dimension, q.internalUnits)
unaryMinus(q::QuantityArray) = QuantityArray(-q.value, q.dimension, q.internalUnits)

## Arithmetic binary operators

# addition
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


# subtraction
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


# multiplication
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

function multiplication(q1::SimpleQuantityType, q2::SimpleQuantityType)
    productValue = q1.value * q2.value
    productUnit = q1.unit * q2.unit
    return  productValue * productUnit
end

function multiplication(q::SimpleQuantityType, dimless::DimensionlessType)
    productValue = q.value * dimless
    productUnit = q.unit
    return productValue * productUnit
end

function multiplication(dimless::DimensionlessType, q::SimpleQuantityType)
    productValue = dimless * q.value
    productUnit = q.unit
    return productValue * productUnit
end

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
    return _createQuantityType( q1.value * q2.value, q1.dimension + q2.dimension, q1.internalUnits )
end

function multiplication(quantity::QuantityType, dimless::DimensionlessType)
    return _createQuantityType( quantity.value * dimless, quantity.dimension, quantity.internalUnits )
end

function multiplication(dimless::DimensionlessType, quantity::QuantityType)
    return _createQuantityType( dimless * quantity.value, quantity.dimension, quantity.internalUnits )
end

function _createQuantityType(value::Union{Number, Array{<:Number}}, dimension::Dimension, intu::InternalUnits)
    if isa(value, Number)
        return Quantity(value, dimension, intu)
    else
        return QuantityArray(value, dimension, intu)
    end
end

# mixed: Quantity, QuantityArray, SimpleQuantity, and SimpleQuantityArray
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

## TODO below

## Equality

"""
    Base.:(==)(quantity1::Quantity, quantity2::Quantity)

Compare two `Quantity` objects.

The two quantities are equal if their values, their dimensions, and their internal units are equal.
Note that the units are not converted during the comparison.
"""
function Base.:(==)(quantity1::Quantity, quantity2::Quantity)
    valuesEqual = ( quantity1.value == quantity2.value )
    dimensionsEqual = ( quantity1.dimension == quantity2.dimension )
    internalUnitsEqual = ( quantity1.internalUnits == quantity2.internalUnits )
    isEqual = valuesEqual && dimensionsEqual && internalUnitsEqual
    return isEqual
end

"""
    Base.:(==)(qArray1::QuantityArray, qArray2::QuantityArray)

Compare two `QuantityArray` objects.

The two quantities are equal if their values, their dimensions, and their internal units are equal.
Note that the units are not converted during the comparison.
"""
function Base.:(==)(qArray1::QuantityArray, qArray2::QuantityArray)
    valuesEqual = ( qArray1.value == qArray2.value )
    dimensionsEqual = ( qArray1.dimension == qArray2.dimension )
    internalUnitsEqual = ( qArray1.internalUnits == qArray2.internalUnits )
    isEqual = valuesEqual && dimensionsEqual && internalUnitsEqual
    return isEqual
end


## Division

# methods documented as part of the AbstractQuantity interface
# scalar quantity
Base.:/(a::SimpleQuantity, b::SimpleQuantity) = division(a, b)
Base.:/(a::SimpleQuantity, b::Number) = division(a, b)
Base.:/(a::Number, b::SimpleQuantity) = division(a, b)
Base.:/(a::SimpleQuantity, b::Array{<:Number}) = division(a, b)
Base.:/(a::Array{<:Number}, b::SimpleQuantity) = division(a, b)
# array quantity
Base.:/(a::SimpleQuantityArray, b::SimpleQuantityArray) = division(a, b)
Base.:/(a::SimpleQuantityArray, b::Array{<:Number}) = division(a, b)
Base.:/(a::Array{<:Number}, b::SimpleQuantityArray) = division(a, b)
Base.:/(a::SimpleQuantityArray, b::SimpleQuantity) = division(a, b)
Base.:/(a::SimpleQuantity, b::SimpleQuantityArray) = division(a, b)
Base.:/(a::SimpleQuantityArray, b::Number) = division(a, b)
Base.:/(a::Number, b::SimpleQuantityArray) = division(a, b)

function division(q1::SimpleQuantityType, q2::SimpleQuantityType)
    quotientValue = q1.value / q2.value
    quotientUnit = q1.unit / q2.unit
    return  quotientValue * quotientUnit
end

function division(sQuantity::SimpleQuantityType, dimless::DimensionlessType)
    quotientValue = sQuantity.value / dimless
    quotientUnit = sQuantity.unit
    return quotientValue * quotientUnit
end

function division(dimless::DimensionlessType, sQuantity::SimpleQuantityType)
    quotientValue = dimless / sQuantity.value
    quotientUnit = inv(sQuantity.unit)
    return quotientValue * quotientUnit
end

## Inverse division

# methods documented as part of the AbstractQuantity interface
# scalar quantity
Base.:\(a::SimpleQuantity, b::SimpleQuantity) = inverseDivision(a, b)
Base.:\(a::SimpleQuantity, b::Number) = inverseDivision(a, b)
Base.:\(a::Number, b::SimpleQuantity) = inverseDivision(a, b)
Base.:\(a::SimpleQuantity, b::Array{<:Number}) = inverseDivision(a, b)
Base.:\(a::Array{<:Number}, b::SimpleQuantity) = inverseDivision(a, b)
# array quantity
Base.:\(a::SimpleQuantityArray, b::SimpleQuantityArray) = inverseDivision(a, b)
Base.:\(a::SimpleQuantityArray, b::Array{<:Number}) = inverseDivision(a, b)
Base.:\(a::Array{<:Number}, b::SimpleQuantityArray) = inverseDivision(a, b)
Base.:\(a::SimpleQuantity, b::SimpleQuantityArray) = inverseDivision(a, b)
Base.:\(a::Number, b::SimpleQuantityArray) = inverseDivision(a, b)

function inverseDivision(q1::SimpleQuantityType, q2::SimpleQuantityType)
    quotientValue = q1.value \ q2.value
    quotientUnit = q2.unit / q1.unit
    return  quotientValue * quotientUnit
end

function inverseDivision(sQuantity::SimpleQuantityType, dimless::DimensionlessType)
    quotientValue = sQuantity.value \ dimless
    quotientUnit = inv(sQuantity.unit)
    return quotientValue * quotientUnit
end

function inverseDivision(dimless::DimensionlessType, sQuantity::SimpleQuantityType)
    quotientValue = dimless \ sQuantity.value
    quotientUnit = sQuantity.unit
    return quotientValue * quotientUnit
end

## Power

# methods documented as part of the AbstractQuantity interface
# scalar quantity
Base.:^(a::SimpleQuantity, b::Real) = power(a, b)
Base.:^(a::SimpleQuantity, b::Integer) = power(a, b)
# array quantity
Base.:^(a::SimpleQuantityArray, b::Real) = power(a, b)
Base.:^(a::SimpleQuantityArray, b::Integer) = power(a, b)

function power(sQuantity::SimpleQuantityType, exponent::Real)
    exponentiatedValue = Base.literal_pow(^, sQuantity.value, Val(exponent))
    exponentiatedUnit = (sQuantity.unit)^exponent
    return exponentiatedValue * exponentiatedUnit
end

## Inverse

# methods documented as part of the AbstractQuantity interface
# scalar quantity
Base.:inv(a::SimpleQuantity) = inverse(a)
# array quantity
Base.:inv(a::SimpleQuantityArray) = inverse(a)

function inverse(sQuantity::SimpleQuantityType)
    inverseValue = inv(sQuantity.value)
    inverseUnit = inv(sQuantity.unit)
    return inverseValue * inverseUnit
end


## TODO below

## ## SimpleQuantity


## 2. Arithmetic unary and binary operators


## 3. Numeric comparison

"""
    Base.:(==)(simpleQuantity1::SimpleQuantity, simpleQuantity2::SimpleQuantity)

Returns `true` if `simpleQuantity1` and `simpleQuantity2` are of equal value.

If necessary, `simpleQuantity2` is expressed in units of `simpleQuantity1.unit`
before the comparison. Note that the conversion oftens lead to rounding errors
that render `simpleQuantity1` not equal `simpleQuantity2`.

# Raises Exceptions
- `Alicorn.Exceptions.DimensionMismatchError`: if `simpleQuantity1` and
`simpleQuantity2` are not of the same dimension

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
function Base.:(==)(simpleQuantity1::SimpleQuantity, simpleQuantity2::SimpleQuantity)
    simpleQuantity2 = _ensureComparedWithSameUnit(simpleQuantity1, simpleQuantity2)
    return simpleQuantity1.value == simpleQuantity2.value
end

"""
    Base.isless(simpleQuantity1::SimpleQuantity, simpleQuantity2::SimpleQuantity)

Returns `true` if `simpleQuantity1` is of lesser value than `simpleQuantity2`.

If necessary, `simpleQuantity2` is expressed in units of `simpleQuantity1.unit`
before the comparison. Note that the conversion often leads to rounding errors.

# Raises Exceptions
- `Alicorn.Exceptions.DimensionMismatchError`: if `simpleQuantity1` and
`simpleQuantity2` are not of the same dimension
"""
function Base.isless(simpleQuantity1::SimpleQuantity, simpleQuantity2::SimpleQuantity)
    simpleQuantity2 = _ensureComparedWithSameUnit(simpleQuantity1, simpleQuantity2)
    return isless( simpleQuantity1.value, simpleQuantity2.value )
end

function _ensureComparedWithSameUnit(simpleQuantity1::SimpleQuantity, simpleQuantity2::SimpleQuantity)
    try
        simpleQuantity2 = inUnitsOf(simpleQuantity2, simpleQuantity1.unit)
    catch exception
        _handleExceptionIn_ensureComparedWithSameUnit(exception)
    end
    return simpleQuantity2
end

function _handleExceptionIn_ensureComparedWithSameUnit(exception)
    if isa(exception, Exceptions.DimensionMismatchError)
        newException = Exceptions.DimensionMismatchError("compared quantities are not of the same physical dimension")
        throw(newException)
    else
        rethrow()
    end
end

# method documented as part of the AbstractQuantity interface
function Base.isfinite(simpleQuantity::SimpleQuantity)
    return isfinite(simpleQuantity.value)
end

# method documented as part of the AbstractQuantity interface
function Base.isinf(simpleQuantity::SimpleQuantity)
    return isinf(simpleQuantity.value)
end

# method documented as part of the AbstractQuantity interface
function Base.isnan(simpleQuantity::SimpleQuantity)
    return isnan(simpleQuantity.value)
end

"""
    Base.isapprox(simpleQuantity1::SimpleQuantity, simpleQuantity2::SimpleQuantity; rtol::Real = sqrt(eps()) )

Returns `isapprox(simpleQuantity1.value, simpleQuantity2.value, rtol=rtol)`.

If necessary, `simpleQuantity2` is expressed in units of `simpleQuantity1.unit`
before the comparison. Note that the conversion often leads to rounding errors.

# Raises Exceptions
- `Alicorn.Exceptions.DimensionMismatchError`: if `simpleQuantity1` and
`simpleQuantity2` are not of the same dimension
"""
function Base.isapprox(simpleQuantity1::SimpleQuantity, simpleQuantity2::SimpleQuantity; rtol::Real = sqrt(eps()))
    simpleQuantity2 = _ensureComparedWithSameUnit(simpleQuantity1, simpleQuantity2)
    return isapprox(simpleQuantity1.value, simpleQuantity2.value, rtol=rtol)
end

## 4. Rounding

# method documented as part of the AbstractQuantity interface
function Base.mod2pi(simpleQuantity::SimpleQuantity)
    unit = simpleQuantity.unit
    value = mod2pi(simpleQuantity.value)
    return SimpleQuantity(value, unit)
end

## 5. Sign and absolute value

# method documented as part of the AbstractQuantity interface
function Base.abs(simpleQuantity::SimpleQuantity)
    unit = simpleQuantity.unit
    value = abs(simpleQuantity.value)
    return SimpleQuantity(value, unit)
end

# method documented as part of the AbstractQuantity interface
function Base.abs2(simpleQuantity::SimpleQuantity)
    unit = (simpleQuantity.unit)^2
    value = abs2(simpleQuantity.value)
    return SimpleQuantity(value, unit)
end

# method documented as part of the AbstractQuantity interface
function Base.sign(simpleQuantity::SimpleQuantity)
    value = sign(simpleQuantity.value)
    return value
end

# method documented as part of the AbstractQuantity interface
function Base.signbit(simpleQuantity::SimpleQuantity)
    value = signbit(simpleQuantity.value)
    return value
end

# method documented as part of the AbstractQuantity interface
function Base.copysign(simpleQuantity1::SimpleQuantity, simpleQuantity2::SimpleQuantity)
    unit = simpleQuantity1.unit
    value = copysign(simpleQuantity1.value, simpleQuantity2.value)
    return SimpleQuantity(value, unit)
end

function Base.copysign(simpleQuantity::SimpleQuantity, number::Number)
    unit = simpleQuantity.unit
    value = copysign(simpleQuantity.value, number)
    return SimpleQuantity(value, unit)
end

function Base.copysign(number::Number, simpleQuantity::SimpleQuantity)
    value = copysign(number, simpleQuantity.value)
    return value
end

# method documented as part of the AbstractQuantity interface
function Base.flipsign(simpleQuantity1::SimpleQuantity, simpleQuantity2::SimpleQuantity)
    unit = simpleQuantity1.unit
    value = flipsign(simpleQuantity1.value, simpleQuantity2.value)
    return SimpleQuantity(value, unit)
end

function Base.flipsign(simpleQuantity::SimpleQuantity, number::Number)
    unit = simpleQuantity.unit
    value = flipsign(simpleQuantity.value, number)
    return SimpleQuantity(value, unit)
end

function Base.flipsign(number::Number, simpleQuantity::SimpleQuantity)
    value = flipsign(number, simpleQuantity.value)
    return value
end

## 6. Roots

# method documented as part of the AbstractQuantity interface
function Base.sqrt(simpleQuantity::SimpleQuantity)
    rootOfValue = sqrt(simpleQuantity.value)
    rootOfUnit = sqrt(simpleQuantity.unit)
    rootOfQuantity = SimpleQuantity(rootOfValue, rootOfUnit)
    return rootOfQuantity
end

# method documented as part of the AbstractQuantity interface
function Base.cbrt(simpleQuantity::SimpleQuantity)
    rootOfValue = cbrt(simpleQuantity.value)
    rootOfUnit = cbrt(simpleQuantity.unit)
    rootOfQuantity = SimpleQuantity(rootOfValue, rootOfUnit)
    return rootOfQuantity
end


## 8. Complex numbers

# method documented as part of the AbstractQuantity interface
function Base.real(simpleQuantity::SimpleQuantity)
    unit = simpleQuantity.unit
    value = real(simpleQuantity.value)
    return SimpleQuantity(value, unit)
end

# method documented as part of the AbstractQuantity interface
function Base.imag(simpleQuantity::SimpleQuantity)
    unit = simpleQuantity.unit
    value = imag(simpleQuantity.value)
    return SimpleQuantity(value, unit)
end

# method documented as part of the AbstractQuantity interface
function Base.conj(simpleQuantity::SimpleQuantity)
    unit = simpleQuantity.unit
    value = conj(simpleQuantity.value)
    return SimpleQuantity(value, unit)
end

# method documented as part of the AbstractQuantity interface
function Base.angle(simpleQuantity::SimpleQuantity)
    value = angle(simpleQuantity.value)
    return value
end

## 9. Compatibility with array functions

# method documented as part of the AbstractQuantity interface
function Base.length(simpleQuantity::SimpleQuantity)
    return length(simpleQuantity.value)
end

# method documented as part of the AbstractQuantity interface
function Base.size(simpleQuantity::SimpleQuantity)
    return size(simpleQuantity.value)
end

# method documented as part of the AbstractQuantity interface
function Base.ndims(simpleQuantity::SimpleQuantity)
    return ndims(simpleQuantity.value)
end

# method documented as part of the AbstractQuantity interface
function Base.getindex(simpleQuantity::SimpleQuantity, index...)
    unit = simpleQuantity.unit
    value = getindex(simpleQuantity.value, index...)
    return SimpleQuantity(value, unit)
end

Base.iterate(simpleQuantity::SimpleQuantity) = (simpleQuantity,nothing)
Base.iterate(simpleQuantity::SimpleQuantity, state) = nothing



## ## SimpleQuantityArray



# TODO below

## 2. Arithmetic unary and binary operators

"""
    Base.:-(sqArray1::SimpleQuantityArray, sqArray2::SimpleQuantityArray)

Subtract two `SimpleQuantityArrays`.

The resulting quantity is expressed in units of `sqArray1`.

# Raises Exceptions
- `Alicorn.Exceptions.DimensionMismatchError`: if `sqArray1` and `sqArray2` are of different dimensions
"""
function Base.:-(sqArray1::SimpleQuantityArray, sqArray2::SimpleQuantityArray)
    return sqArray1 + (-sqArray2)
end

## 3. Numeric comparison

"""
    Base.:(==)(sqArray1::SimpleQuantityArray, sqArray2::SimpleQuantityArray)

Returns `true` if `sqArray1` and `sqArray2` are of equal value and dimension.

If necessary, `sqArray2` is expressed in units of `sqArray1.unit`
before the comparison. Note that the conversion oftens lead to rounding errors
that render `sqArray1` not equal `sqArray2`.

# Raises Exceptions
- `Alicorn.Exceptions.DimensionMismatchError`: if `sqArray1` and
`sqArray2` are not of the same dimension
```
"""
function Base.:(==)(sqArray1::SimpleQuantityArray, sqArray2::SimpleQuantityArray)
    sqArray2 = _ensureComparedWithSameUnit(sqArray1, sqArray2)
    return ( sqArray1.value == sqArray2.value )
end

function _ensureComparedWithSameUnit(sqArray1::SimpleQuantityArray, sqArray2::SimpleQuantityArray)
    try
        targetUnit = sqArray1.unit
        sqArray2 = inUnitsOf(sqArray2, targetUnit)
    catch exception
        _handleExceptionIn_ensureComparedWithSameUnit(exception)
    end
    return sqArray2
end

"""
    Base.isapprox(sqArray1::SimpleQuantityArray, sqArray2::SimpleQuantityArray; rtol::Real = sqrt(eps()) )

Returns `isapprox(sqArray1.value, sqArray2.value, rtol=rtol)`.

If necessary, `sqArray2` is expressed in units of `sqArray1.unit`
before the comparison. Note that the conversion often leads to rounding errors.

# Raises Exceptions
- `Alicorn.Exceptions.DimensionMismatchError`: if `sqArray1` and
`sqArray2` are not of the same dimension
"""
function Base.isapprox(sqArray1::SimpleQuantityArray, sqArray2::SimpleQuantityArray; rtol::Real = sqrt(eps()))
    sqArray2 = _ensureComparedWithSameUnit(sqArray1, sqArray2)
    return isapprox(sqArray1.value, sqArray2.value, rtol=rtol)
end

## 4. Complex numbers

# method documented as part of the AbstractQuantity interface
function Base.real(sqArray::SimpleQuantityArray)
    value = real(sqArray.value)
    unit = sqArray.unit
    return value * unit
end

# method documented as part of the AbstractQuantity interface
function Base.imag(sqArray::SimpleQuantityArray)
    value = imag(sqArray.value)
    unit = sqArray.unit
    return value * unit
end

# method documented as part of the AbstractQuantity interface
function Base.conj(sqArray::SimpleQuantityArray)
    value = conj(sqArray.value)
    unit = sqArray.unit
    return value * unit
end
