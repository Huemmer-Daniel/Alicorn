export AbstractQuantity
"""
    AbstractQuantity{T}

Abstract supertype for all types that represent a physical quantity.

Currently the only concrete subtype of `AbstractQuantity` is [`SimpleQuantity`](@ref).
"""
abstract type AbstractQuantity{T} end

# Interface
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

function Base.:/(unit::AbstractUnit, quantity::AbstractQuantity, )
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
    Base.:*(quantity::AbstractQuantity, object::Number)
    Base.:*(object::Number, quantity::AbstractQuantity)

Multiply a physical quantity with a dimensionless number.
"""
function Base.:*(quantity::AbstractQuantity, number::Number)
    subtype = typeof(quantity)
    error("missing specialization of Base.:*(::AbstractQuantity, ::Number) for subtype $subtype")
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

## 4. Numeric comparison

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


## 5. Rounding

"""
    Base.mod2pi(quantity::AbstractQuantity)

Modulus after division by `2π`, returning a quantity with a value in the range `[0,2π)`.
"""
function Base.mod2pi(quantity::AbstractQuantity)
    subtype = typeof(quantity)
    error("missing specialization of Base.mod2pi(::AbstractQuantity) for subtype $subtype")
end

## 6. Sign and absolute value

function Base.abs(quantity::AbstractQuantity)
    subtype = typeof(quantity)
    error("missing specialization of Base.abs(::AbstractQuantity) for subtype $subtype")
end

function Base.abs2(quantity::AbstractQuantity)
    subtype = typeof(quantity)
    error("missing specialization of Base.abs2(::AbstractQuantity) for subtype $subtype")
end

function Base.sign(quantity::AbstractQuantity)
    subtype = typeof(quantity)
    error("missing specialization of Base.sign(::AbstractQuantity) for subtype $subtype")
end

function Base.signbit(quantity::AbstractQuantity)
    subtype = typeof(quantity)
    error("missing specialization of Base.signbit(::AbstractQuantity) for subtype $subtype")
end

## 7. Roots

"""
    Base.sqrt(quantity::AbstractQuantity)

Take the square root of `quantity`.
"""
function Base.sqrt(quantity::AbstractQuantity)
    subtype = typeof(quantity)
    error("missing specialization of Base.sqrt(::AbstractQuantity) for subtype $subtype")
end


## 8. Literal zero

## 9. Complex numbers

## 10. Compatibility with array functions

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
