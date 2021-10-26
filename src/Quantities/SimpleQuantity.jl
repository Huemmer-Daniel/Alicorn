@doc raw"""
    SimpleQuantity{T<:Number} <: AbstractQuantity{T}

A physical quantity consisting of a scalar value and a physical unit.

# Fields
- `value::T`: value of the quantity
- `unit::Unit`: unit of the quantity

# Constructors
```
SimpleQuantity(::Number, ::AbstractUnit)
SimpleQuantity(::Number)
SimpleQuantity(::AbstractUnit)
```
If no unit is passed to the constructor, `unitlessUnit` is used by default. If
no value is passed to the constructor, the value is set to 1 by default.

If the type `T` is specified explicitly, Alicorn attempts to convert the `value`
accordingly:
```
SimpleQuantity{T}(::SimpleQuantity) where {T<:Number}
SimpleQuantity{T}(::Number, ::AbstractUnit) where {T<:Number}
SimpleQuantity{T}(::Number) where {T<:Number}
SimpleQuantity{T}(::AbstractUnit) where {T<:Number}
```

# Examples
1. The quantity ``7\,\mathrm{nm}`` (seven nanometers) can be constructed using
   the constructor method as follows:
   ```jldoctest
   julia> ucat = UnitCatalogue() ;

   julia> nanometer = ucat.nano * ucat.meter
   UnitFactor nm

   julia> quantity = SimpleQuantity(7, nanometer)
   7 nm
   ```
2. Alternatively, ``7\,\mathrm{nm}`` can be constructed arithmetically:
   ```jldoctest
   julia> ucat = UnitCatalogue() ;

   julia> nm = ucat.nano * ucat.meter
   UnitFactor nm

   julia> quantity = 7nm
   7 nm
   ```
"""
mutable struct SimpleQuantity{T<:Number} <: AbstractQuantity{T}
    value::T
    unit::Unit

    function SimpleQuantity(value::T, unit::Unit) where {T<:Number}
        return new{T}(value, unit)
    end
end


## ## External constructors

SimpleQuantity(value::Number, abstractUnit::AbstractUnit) = SimpleQuantity(value, convertToUnit(abstractUnit))
SimpleQuantity(value::Number) = SimpleQuantity(value, unitlessUnit)
SimpleQuantity(abstractUnit::AbstractUnit) = SimpleQuantity(1, abstractUnit)
SimpleQuantity(simpleQuantity::SimpleQuantity) = simpleQuantity

SimpleQuantity{T}(simpleQuantity::SimpleQuantity) where {T<:Number} = SimpleQuantity(convert(T, simpleQuantity.value), simpleQuantity.unit)
SimpleQuantity{T}(value::Number, abstractUnit::AbstractUnit) where {T<:Number} = SimpleQuantity(convert(T, value), abstractUnit)
SimpleQuantity{T}(value::Number) where {T<:Number} = SimpleQuantity(convert(T, value))
SimpleQuantity{T}(abstractUnit::AbstractUnit) where {T<:Number} = SimpleQuantity(T(1), abstractUnit)


## ## Type conversion

"""
    Base.convert(::Type{T}, simpleQuantity::SimpleQuantity) where {T<:SimpleQuantity}

Convert `simpleQuantity` from type `SimpleQuantity{S} where S` to type `SimpleQuantity{T}`.

Allows to convert, for instance, from `SimpleQuantity{Float64}` to `SimpleQuantity{UInt8}`.
"""
Base.convert(::Type{T}, simpleQuantity::SimpleQuantity) where {T<:SimpleQuantity} = simpleQuantity isa T ? simpleQuantity : T(simpleQuantity)


## ## Methods for creating a SimpleQuantity

"""
    Base.:*(value::Number, abstractUnit::AbstractUnit)

Combine `value` and `abstractUnit` to form a physical quantity of type `SimpleQuantity`.

# Example
```jldoctest
julia> ucat = UnitCatalogue() ;

julia> 3.5 * ucat.tesla
3.5 T
```
"""
function Base.:*(value::Number, abstractUnit::AbstractUnit)
    return SimpleQuantity(value, abstractUnit)
end

"""
    Base.:/(value::Number, abstractUnit::AbstractUnit)

Combine `value` and `abstractUnit` to form a physical quantity of type `SimpleQuantity`.

# Example
```jldoctest
julia> ucat = UnitCatalogue() ;

julia> 3.5 / ucat.second
3.5 s^-1
```
"""
function Base.:/(value::Number, abstractUnit::AbstractUnit)
    inverseAbstractUnit = inv(abstractUnit)
    return SimpleQuantity(value, inverseAbstractUnit)
end

## ## Methods implementing the interface of AbstractQuantity

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

# TODO below

Base.copy(simpleQuantity::SimpleQuantity) = SimpleQuantity(copy(simpleQuantity.value), simpleQuantity.unit)
Base.deepcopy(simpleQuantity::SimpleQuantity) = SimpleQuantity(deepcopy(simpleQuantity.value), simpleQuantity.unit)
