export AbstractQuantity
"""
    AbstractQuantity{T}

Abstract supertype for all types that represent a scalar physical quantity.

Currently the only concrete subtype of `AbstractQuantity` is [`SimpleQuantity`](@ref).
"""
abstract type AbstractQuantity{T} end

## ## Interface
# the following functions need to be extended for concrete implementations of
# AbstractQuantity

## 1. Unit conversion

export inUnitsOf
"""
    inUnitsOf(quantity::AbstractQuantity, targetUnit::AbstractUnit)::SimpleQuantity

Express `quantity` as an object of type `SimpleQuantity` in terms of the unit specified by `targetUnit`.
"""
function inUnitsOf(quantity::AbstractQuantity, targetUnit::AbstractUnit)::SimpleQuantity
    subtype = typeof(quantity)
    error("missing specialization of inUnitsOf(::AbstractQuantity, ::AbstractUnit) for subtype $subtype")
end

export inBasicSIUnits
"""
    inBasicSIUnits(quantity::AbstractQuantity)::SimpleQuantity

Express `quantity` as an object of type `SimpleQuantity` using the seven basic SI units.
"""
function inBasicSIUnits(quantity::AbstractQuantity)::SimpleQuantity
    subtype = typeof(quantity)
    error("missing specialization of inBasicSIUnits(::AbstractQuantity) for subtype $subtype")
end

"""
    Base.:*(quantity::AbstractQuantity, unit::AbstractUnit)
    Base.:*(unit::AbstractUnit, quantity::AbstractQuantity)

Modify the unit of `quantity` by multiplying it with `unit`.
"""
function Base.:*(quantity::AbstractQuantity, unit::AbstractUnit)
    subtype = typeof(quantity)
    error("missing specialization of Base.:*(::AbstractQuantity, ::AbstractUnit) for subtype $subtype")
end

function Base.:*(unit::AbstractUnit, quantity::AbstractQuantity)
    subtype = typeof(quantity)
    error("missing specialization of Base.:*(::AbstractUnit, ::AbstractQuantity) for subtype $subtype")
end

"""
    Base.:/(quantity::AbstractQuantity, unit::AbstractUnit)
    Base.:/(unit::AbstractUnit, quantity::AbstractQuantity)

Modify the unit of `quantity` by dividing it by `unit`, or vice versa.
"""
function Base.:/(quantity::AbstractQuantity, unit::AbstractUnit)
    subtype = typeof(quantity)
    error("missing specialization of Base.:/(::AbstractQuantity, ::AbstractUnit) for subtype $subtype")
end

function Base.:/(unit::AbstractUnit, quantity::AbstractQuantity)
    subtype = typeof(quantity)
    error("missing specialization of Base.:/(::AbstractUnit, ::AbstractQuantity) for subtype $subtype")
end

## 2. Arithmetic unary and binary operators

"""
    Base.:+(quantity::AbstractQuantity)

Unary plus operator, acting as the identity operator.
"""
function Base.:+(quantity::AbstractQuantity)
    subtype = typeof(quantity)
    error("missing specialization of Base.:+(::AbstractQuantity) for subtype $subtype")
end

"""
    Base.:-(quantity::AbstractQuantity)

Unary minus operator, returning the additive inverse of the quantity.
"""
function Base.:-(quantity::AbstractQuantity)
    subtype = typeof(quantity)
    error("missing specialization of Base.:-(::AbstractQuantity) for subtype $subtype")
end

"""
    Base.:+(quantity1::AbstractQuantity, quantity2::AbstractQuantity)

Add two physical quantities.

The behavior of the addition depends on the concrete implementation of `AbstractQuantity`.
"""
function Base.:+(quantity1::AbstractQuantity, quantity2::AbstractQuantity)
    subtype = typeof(quantity1)
    error("missing specialization of Base.:+(::AbstractQuantity, ::AbstractQuantity) for subtype $subtype")
end

"""
    Base.:-(quantity1::AbstractQuantity, quantity2::AbstractQuantity)

Subtract `quantity2` from `quantity1`.

The behavior of the subtraction depends on the concrete implementation of `AbstractQuantity`.
"""
function Base.:-(quantity1::AbstractQuantity, quantity2::AbstractQuantity)
    subtype = typeof(quantity1)
    error("missing specialization of Base.:-(::AbstractQuantity, ::AbstractQuantity) for subtype $subtype")
end

"""
    Base.:*(quantity1::AbstractQuantity, quantity2::AbstractQuantity)

Multiply two physical quantities.
"""
function Base.:*(quantity1::AbstractQuantity, quantity2::AbstractQuantity)
    subtype = typeof(quantity1)
    error("missing specialization of Base.:*(::AbstractQuantity, ::AbstractQuantity) for subtype $subtype")
end

"""
    Base.:*(quantity::AbstractQuantity, number::Number)
    Base.:*(number::Number, quantity::AbstractQuantity)

Multiply a physical quantity with a dimensionless number.
"""
function Base.:*(quantity::AbstractQuantity, number::Number)
    subtype = typeof(quantity)
    error("missing specialization of Base.:*(::AbstractQuantity, ::Number) for subtype $subtype")
end

"""
    Base.:*(quantity::AbstractQuantity, array::Array{<:Number})
    Base.:*(number::Number, quantity::AbstractQuantity)

Multiply a physical quantity with a dimensionless number.
"""
function Base.:*(quantity::AbstractQuantity, array::Array{<:Number})
    subtype = typeof(quantity)
    error("missing specialization of Base.:*(::AbstractQuantity, ::Array{<:Number}) for subtype $subtype")
end

function Base.:*(array::Array{<:Number}, quantity::AbstractQuantity)
    subtype = typeof(quantity)
    error("missing specialization of Base.:*(::Array{<:Number}, ::AbstractQuantity) for subtype $subtype")
end


function Base.:*(number::Number, quantity::AbstractQuantity)
    subtype = typeof(quantity)
    error("missing specialization of Base.:*(::Number, ::AbstractQuantity) for subtype $subtype")
end

"""
    Base.:/(quantity1::AbstractQuantity, quantity2::AbstractQuantity)

Divide `quantity1` by `quantity2`.
"""
function Base.:/(quantity1::AbstractQuantity, quantity2::AbstractQuantity)
    subtype = typeof(quantity1)
    error("missing specialization of Base.:/(::AbstractQuantity, ::AbstractQuantity) for subtype $subtype")
end

"""
    Base.:/(quantity::AbstractQuantity, number::Number)
    Base.:/(number::Number, quantity::AbstractQuantity)

Divide a physical quantity by a dimensionless number (or vice versa).
"""
function Base.:/(quantity::AbstractQuantity, number::Number)
    subtype = typeof(quantity)
    error("missing specialization of Base.:/(::AbstractQuantity, ::Number) for subtype $subtype")
end

function Base.:/(number::Number, quantity::AbstractQuantity)
    subtype = typeof(quantity)
    error("missing specialization of Base.:/(::Number, ::AbstractQuantity) for subtype $subtype")
end

raw"
    Base.:\(quantity1::AbstractQuantity, quantity2::AbstractQuantity)

Inverse divide: divide `quantity2` by `quantity1`.
"
function Base.:\(quantity1::AbstractQuantity, quantity2::AbstractQuantity)
    subtype = typeof(quantity1)
    error(raw"missing specialization of Base.:\(::AbstractQuantity, ::AbstractQuantity) for subtype " * "$subtype")
end

raw"
    Base.:\(quantity::AbstractQuantity, number::Number)
    Base.:\(number::Number, quantity::AbstractQuantity)

Inverse divide: divide `quantity2` by `number` (or vice versa).
"
function Base.:\(quantity::AbstractQuantity, number::Number)
    subtype = typeof(quantity)
    error(raw"missing specialization of Base.:\(::AbstractQuantity, ::Number) for subtype " * "$subtype")
end

function Base.:\(number::Number, quantity::AbstractQuantity)
    subtype = typeof(quantity)
    error(raw"missing specialization of Base.:\(::Number, ::AbstractQuantity) for subtype " * "$subtype")
end

"""
    Base.:^(quantity::AbstractQuantity, exponent::Real)

Raise `quantity` to the power of `exponent`.
"""
function Base.:^(quantity::AbstractQuantity, exponent::Real)
    subtype = typeof(quantity)
    error("missing specialization of Base.:^(::AbstractQuantity, ::Number) for subtype $subtype")
end

"""
    Base.inv(quantity::AbstractQuantity)

Determine the multiplicative inverse of `quantity`.
"""
function Base.inv(quantity::AbstractQuantity)
    subtype = typeof(quantity)
    error("missing specialization of Base.inv(::AbstractQuantity) for subtype $subtype")
end

## 3. Numeric comparison

"""
    Base.:==(quantity1::AbstractQuantity, quantity2::AbstractQuantity)

Returns `true` if `quantity1` is equal to `quantity2`.

The behavior of the comparison depends on the concrete subtype of `AbstractUnit`.
"""
function Base.:(==)(quantity1::AbstractQuantity, quantity2::AbstractQuantity)
    subtype = typeof(quantity1)
    error("missing specialization of Base.:==(::AbstractQuantity, ::AbstractQuantity) for subtype $subtype")
end

"""
    Base.isless(quantity1::AbstractQuantity, quantity2::AbstractQuantity)

Returns `true` if `quantity1` is less than `quantity2`.

The behavior of the comparison depends on the concrete subtype of `AbstractUnit`.
"""
function Base.isless(quantity1::AbstractQuantity, quantity2::AbstractQuantity)
    subtype = typeof(quantity1)
    error("missing specialization of Base.isless(::AbstractQuantity, ::AbstractQuantity) for subtype $subtype")
end

"""
    Base.isfinite(quantity::AbstractQuantity)

Returns `true` if the value of `quantity` is a finite number.
"""
function Base.isfinite(quantity::AbstractQuantity)
    subtype = typeof(quantity)
    error("missing specialization of Base.isfinite(::AbstractQuantity) for subtype $subtype")
end

"""
    Base.isinf(quantity::AbstractQuantity)

Returns `true` if the value of `quantity` is an infinite number.
"""
function Base.isinf(quantity::AbstractQuantity)
    subtype = typeof(quantity)
    error("missing specialization of Base.isinf(::AbstractQuantity) for subtype $subtype")
end

"""
    Base.isnan(quantity::AbstractQuantity)

Returns `true` if the value of `quantity` is a NaN.
"""
function Base.isnan(quantity::AbstractQuantity)
    subtype = typeof(quantity)
    error("missing specialization of Base.isnan(::AbstractQuantity) for subtype $subtype")
end

"""
    Base.isapprox(quantity1::AbstractQuantity, quantity2::AbstractQuantity; rtol::Real = sqrt(eps()))

Returns `true` if `abs(x-y) <= rtol*max(abs(x), abs(y))
"""
function Base.isapprox(quantity1::AbstractQuantity, quantity2::AbstractQuantity; rtol::Real = sqrt(eps()))
    subtype = typeof(quantity1)
    error("missing specialization of Base.isapprox(::AbstractQuantity, ::AbstractQuantity, ::Real) for subtype $subtype")
end


## 4. Rounding

"""
    Base.mod2pi(quantity::AbstractQuantity)

Modulus after division by `2π`, returning a quantity with a value in the range `[0,2π)`.
"""
function Base.mod2pi(quantity::AbstractQuantity)
    subtype = typeof(quantity)
    error("missing specialization of Base.mod2pi(::AbstractQuantity) for subtype $subtype")
end

## 5. Sign and absolute value

"""
    Base.abs(quantity::AbstractQuantity)

Apply `abs` to the value of `quantity` without changing its unit.
"""
function Base.abs(quantity::AbstractQuantity)
    subtype = typeof(quantity)
    error("missing specialization of Base.abs(::AbstractQuantity) for subtype $subtype")
end

"""
    Base.abs2(quantity::AbstractQuantity)

Apply `abs2` to the value of `quantity` without changing its unit.
"""
function Base.abs2(quantity::AbstractQuantity)
    subtype = typeof(quantity)
    error("missing specialization of Base.abs2(::AbstractQuantity) for subtype $subtype")
end

"""
    Base.sign(quantity::AbstractQuantity)

Apply `sign` to the value of `quantity`. The result is a number, not a quantity.

Return zero if `x==0` and `x/|x|` otherwise.
"""
function Base.sign(quantity::AbstractQuantity)
    subtype = typeof(quantity)
    error("missing specialization of Base.sign(::AbstractQuantity) for subtype $subtype")
end

"""
    Base.signbit(quantity::AbstractQuantity)

Apply `signbit` to the value of `quantity`.

Returns `true` if the value of the sign is negative, otherwise `false`.
"""
function Base.signbit(quantity::AbstractQuantity)
    subtype = typeof(quantity)
    error("missing specialization of Base.signbit(::AbstractQuantity) for subtype $subtype")
end

"""
    Base.copysign(quantity1::AbstractQuantity, quantity2::AbstractQuantity)
    Base.copysign(quantity::AbstractQuantity, number::Number)
    Base.copysign(number::Number, quantity::AbstractQuantity)

Change the sign of the first argument to the sign of the second argument.
"""
function Base.copysign(quantity1::AbstractQuantity, quantity2::AbstractQuantity)
    subtype = typeof(quantity1)
    error("missing specialization of Base.copysign(::AbstractQuantity, ::AbstractQuantity) for subtype $subtype")
end

function Base.copysign(quantity::AbstractQuantity, number::Number)
    subtype = typeof(quantity)
    error("missing specialization of Base.copysign(::AbstractQuantity, ::Number) for subtype $subtype")
end

function Base.copysign(number::Number, quantity::AbstractQuantity)
    subtype = typeof(quantity)
    error("missing specialization of Base.copysign(::Number, ::AbstractQuantity) for subtype $subtype")
end

"""
    Base.flipsign(quantity1::AbstractQuantity, quantity2::AbstractQuantity)
    Base.flipsign(quantity::AbstractQuantity, number::Number)
    Base.flipsign(number::Number, quantity::AbstractQuantity)

Invert the sign of the first argument if the second argument is negative.
"""
function Base.flipsign(quantity1::AbstractQuantity, quantity2::AbstractQuantity)
    subtype = typeof(quantity1)
    error("missing specialization of Base.flipsign(::AbstractQuantity, ::AbstractQuantity) for subtype $subtype")
end

function Base.flipsign(quantity::AbstractQuantity, number::Number)
    subtype = typeof(quantity)
    error("missing specialization of Base.flipsign(::AbstractQuantity, ::Number) for subtype $subtype")
end

function Base.flipsign(number::Number, quantity::AbstractQuantity)
    subtype = typeof(quantity)
    error("missing specialization of Base.flipsign(::Number, ::AbstractQuantity) for subtype $subtype")
end

## 6. Roots

"""
    Base.sqrt(quantity::AbstractQuantity)

Apply `sqrt` to the value of `quantity` and modify its unit accordingly.
"""
function Base.sqrt(quantity::AbstractQuantity)
    subtype = typeof(quantity)
    error("missing specialization of Base.sqrt(::AbstractQuantity) for subtype $subtype")
end

"""
    Base.cbrt(quantity::AbstractQuantity)

Apply `cbrt` to the value of `quantity` and modify its unit accordingly.
"""
function Base.cbrt(quantity::AbstractQuantity)
    subtype = typeof(quantity)
    error("missing specialization of Base.cbrt(::AbstractQuantity) for subtype $subtype")
end


## 7. Literal zero

"""
    Base.zero(quantity::AbstractQuantity)

Return a quantity which has the same unit as `quantity` and value zero of the same type as the value of `quantity`.
"""
function Base.zero(quantity::AbstractQuantity)
    subtype = typeof(quantity)
    error("missing specialization of Base.zero(::AbstractQuantity) for subtype $subtype")
end

## 8. Complex numbers

"""
    Base.real(quantity::AbstractQuantity)

Apply `real` to the value of `quantity` without changing its unit.
"""
function Base.real(quantity::AbstractQuantity)
    subtype = typeof(quantity)
    error("missing specialization of Base.real(::AbstractQuantity) for subtype $subtype")
end

"""
    Base.imag(quantity::AbstractQuantity)

Apply `imag` to the value of `quantity` without changing its unit.
"""
function Base.imag(quantity::AbstractQuantity)
    subtype = typeof(quantity)
    error("missing specialization of Base.imag(::AbstractQuantity) for subtype $subtype")
end

"""
    Base.conj(quantity::AbstractQuantity)

Apply `conj` to the value of `quantity` without changing its unit.
"""
function Base.conj(quantity::AbstractQuantity)
    subtype = typeof(quantity)
    error("missing specialization of Base.conj(::AbstractQuantity) for subtype $subtype")
end

"""
    Base.angle(quantity::AbstractQuantity)

Apply `angle` to the value of `quantity`. The result is a number in the range `[0,2π)`.
"""
function Base.angle(quantity::AbstractQuantity)
    subtype = typeof(quantity)
    error("missing specialization of Base.angle(::AbstractQuantity) for subtype $subtype")
end

## 9. Compatibility with array functions

"""
    Base.length(quantity::AbstractQuantity)

Returns `length(quantity.value)`.
"""
function Base.length(quantity::AbstractQuantity)
    subtype = typeof(quantity)
    error("missing specialization of Base.length(::AbstractQuantity) for subtype $subtype")
end

"""
    Base.size(quantity::AbstractQuantity)

Returns `size(quantity.value)`.
"""
function Base.size(quantity::AbstractQuantity)
    subtype = typeof(quantity)
    error("missing specialization of Base.size(::AbstractQuantity) for subtype $subtype")
end

"""
    Base.ndims(quantity::AbstractQuantity)

Returns `ndims(quantity.value)`.
"""
function Base.ndims(quantity::AbstractQuantity)
    subtype = typeof(quantity)
    error("missing specialization of Base.ndims(::AbstractQuantity) for subtype $subtype")
end

"""
    Base.getindex(quantity::AbstractQuantity, inds...)

Attempts to access `quantity` as an array.

The method is provided to ensure compatibility with the syntax for accessing elements of `AbstractQuantityArray` objects.
"""
function Base.getindex(quantity::AbstractQuantity, inds...)
    subtype = typeof(quantity)
    error("missing specialization of Base.getindex(::AbstractQuantity, inds...) for subtype $subtype")
end
