## Unary operators

# methods documented as part of the AbstractQuantity interface
# scalar quantity
Base.:+(simpleQuantity::SimpleQuantity) = simpleQuantity
Base.:-(simpleQuantity::SimpleQuantity) = unaryMinus(simpleQuantity)
# array quantity
Base.:+(sqArray::SimpleQuantityArray) = sqArray
Base.:-(sqArray::SimpleQuantityArray) = unaryMinus(sqArray)

function unaryMinus(sQuantity::SimpleQuantityType)
    value = -sQuantity.value
    unit = sQuantity.unit
    return value * unit
end

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


## Multiplication

# methods documented as part of the AbstractQuantity interface
# scalar SimpleQuantity
Base.:*(a::SimpleQuantity, b::SimpleQuantity) = multiplication(a, b)
Base.:*(a::SimpleQuantity, b::Number) = multiplication(a, b)
Base.:*(a::Number, b::SimpleQuantity) = multiplication(a, b)
Base.:*(a::SimpleQuantity, b::Array{<:Number}) = multiplication(a, b)
Base.:*(a::Array{<:Number}, b::SimpleQuantity) = multiplication(a, b)
# scalar Quantity
Base.:*(a::Quantity, b::Quantity) = multiplication(a, b)
Base.:*(a::Quantity, b::SimpleQuantity) = multiplication(a, b)
# array quantity
Base.:*(a::SimpleQuantityArray, b::SimpleQuantityArray) = multiplication(a, b)
Base.:*(a::SimpleQuantityArray, b::Array{<:Number}) = multiplication(a, b)
Base.:*(a::Array{<:Number}, b::SimpleQuantityArray) = multiplication(a, b)
Base.:*(a::SimpleQuantityArray, b::SimpleQuantity) = multiplication(a, b)
Base.:*(a::SimpleQuantity, b::SimpleQuantityArray) = multiplication(a, b)
Base.:*(a::SimpleQuantityArray, b::Number) = multiplication(a, b)
Base.:*(a::Number, b::SimpleQuantityArray) = multiplication(a, b)

function multiplication(sQuantity1::SimpleQuantityType, sQuantity2::SimpleQuantityType)
    productValue = sQuantity1.value * sQuantity2.value
    productUnit = sQuantity1.unit * sQuantity2.unit
    return  productValue * productUnit
end

function multiplication(sQuantity::SimpleQuantityType, dimless::DimensionlessType)
    productValue = sQuantity.value * dimless
    productUnit = sQuantity.unit
    return productValue * productUnit
end

function multiplication(dimless::DimensionlessType, sQuantity::SimpleQuantityType)
    productValue = dimless * sQuantity.value
    productUnit = sQuantity.unit
    return productValue * productUnit
end

# TODO: below

function multiplication(quantity1::QuantityType, quantity2::QuantityType)
    targetInternalUnits = quantity1.internalUnits
    quantity2InIntU = inInternalUnitsOf(quantity2, targetInternalUnits)
    productValue = quantity1.value * quantity2InIntU.value
    productDimension = quantity1.dimension + quantity2InIntU.dimension
    return Quantity( productValue, productDimension, targetInternalUnits )
end

function multiplication(quantity::QuantityType, sQuantity::SimpleQuantityType)
    targetInternalUnits = quantity.internalUnits
    return quantity * Quantity(sQuantity, targetInternalUnits)
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

function division(sQuantity1::SimpleQuantityType, sQuantity2::SimpleQuantityType)
    quotientValue = sQuantity1.value / sQuantity2.value
    quotientUnit = sQuantity1.unit / sQuantity2.unit
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

function inverseDivision(sQuantity1::SimpleQuantityType, sQuantity2::SimpleQuantityType)
    quotientValue = sQuantity1.value \ sQuantity2.value
    quotientUnit = sQuantity2.unit / sQuantity1.unit
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

"""
    Base.:+(simpleQuantity1::SimpleQuantity, simpleQuantity2::SimpleQuantity)

Add two SimpleQuantities.

The resulting quantity is expressed in units of `simpleQuantity1`.

# Raises Exceptions
- `Alicorn.Exceptions.DimensionMismatchError`: if `simpleQuantity1` and `simpleQuantity2` are of different dimensions
"""
function Base.:+(simpleQuantity1::SimpleQuantity, simpleQuantity2::SimpleQuantity)
    targetUnit = simpleQuantity1.unit
    simpleQuantity2 = _addition_ConvertQuantityToTargetUnit(simpleQuantity2, targetUnit)
    sumValue = simpleQuantity1.value + simpleQuantity2.value
    sumQuantity = SimpleQuantity( sumValue, targetUnit )
    return sumQuantity
end

function _addition_ConvertQuantityToTargetUnit(simpleQuantity::SimpleQuantity, targetUnit::AbstractUnit)
    try
        simpleQuantity = inUnitsOf(simpleQuantity, targetUnit)
    catch exception
        _handleExceptionInAddition(exception)
    end
    return simpleQuantity
end

function _handleExceptionInAddition(exception::Exception)
    if isa(exception, Exceptions.DimensionMismatchError)
        newException = Exceptions.DimensionMismatchError("summands are not of the same physical dimension")
        throw(newException)
    else
        rethrow()
    end
end

"""
    Base.:-(simpleQuantity1::SimpleQuantity, simpleQuantity2::SimpleQuantity)

Subtract two SimpleQuantities.

The resulting quantity is expressed in units of `simpleQuantity1`.

# Raises Exceptions
- `Alicorn.Exceptions.DimensionMismatchError`: if `simpleQuantity1` and `simpleQuantity2` are of different dimensions
"""
function Base.:-(simpleQuantity1::SimpleQuantity, simpleQuantity2::SimpleQuantity)
    return simpleQuantity1 + (-simpleQuantity2)
end

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
    Base.:+(sqArray1::SimpleQuantityArray, sqArray2::SimpleQuantityArray)

Add two `SimpleQuantityArrays`.

The resulting quantity is expressed in units of `sqArray1`.

# Raises Exceptions
- `Alicorn.Exceptions.DimensionMismatchError`: if `sqArray1` and `sqArray2` are of different dimensions
"""
function Base.:+(sqArray1::SimpleQuantityArray, sqArray2::SimpleQuantityArray)
    targetUnit = sqArray1.unit
    sqArray2 = _addition_ConvertQuantityArrayToTargetUnit(sqArray2, targetUnit)
    sumvalue = sqArray1.value + sqArray2.value
    sumQuantity = SimpleQuantityArray( sumvalue, targetUnit )
    return sumQuantity
end

function _addition_ConvertQuantityArrayToTargetUnit(sqArray::Union{SimpleQuantityArray, SimpleQuantity}, targetUnit::AbstractUnit)
    try
        sqArray = inUnitsOf(sqArray, targetUnit)
    catch exception
        _handleExceptionInArrayAddition(exception)
    end
    return sqArray
end

function _handleExceptionInArrayAddition(exception::Exception)
    if isa(exception, Exceptions.DimensionMismatchError)
        newException = Exceptions.DimensionMismatchError("summands are not of the same physical dimension")
        throw(newException)
    else
        rethrow()
    end
end

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
