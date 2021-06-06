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


## 3. Updating binary operators

## 4. Numeric comparison

"""
    Base.:==(quantity1::AbstractQuantity, quantity2::AbstractQuantity)

Compare two physical quantities.

The behavior of the comparison depends on the concrete subtype of `AbstractUnit`.
"""
function Base.:(==)(quantity1::AbstractQuantity, quantity2::AbstractQuantity)
    subtype = typeof(quantity1)
    error("missing specialization of Base.:==(::AbstractQuantity, ::AbstractQuantity) for subtype $subtype")
end

## 5. Rounding

## 6. Sign and absolute value

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
