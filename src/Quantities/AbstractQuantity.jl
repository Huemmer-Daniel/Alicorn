export AbstractQuantity
"""
    AbstractQuantity

Abstract supertype for all types that represent a physical quantity.

Currently the only concrete subtype of `AbstractQuantity` is [`SimpleQuantity`](@ref).
"""
abstract type AbstractQuantity end

## 1. Generic functions
# these functions need to work for all implementations of AbstractQuantity

## 2. Interface
# the following functions need to be extended for concrete implementations of
# AbstractQuantity

"""
    Base.:==(quantity1::AbstractQuantity, quantity2::AbstractQuantity)

Compare two physical quantities.

The behavior of the comparison depends on the concrete subtype of `AbstractUnit`.
"""
function Base.:(==)(quantity1::AbstractQuantity, quantity2::AbstractQuantity)
    subtype = typeof(quantity1)
    error("subtype $subtype of AbstractQuantity misses an implementation of the == function")
end

export inUnitsOf
"""
    inUnitsOf(quantity::AbstractQuantity, targetUnit::AbstractUnit)::SimpleQuantity

Express `quantity` as an object of type `SimpleQuantity` in terms of the unit specified by `targetUnit`.
"""
function inUnitsOf(quantity::AbstractQuantity, targetUnit::AbstractUnit)::SimpleQuantity
    subtype = typeof(quantity)
    error("subtype $subtype of AbstractQuantity misses an implementation of the inUnitsOf function")
end

export inBasicSIUnits
"""
    inBasicSIUnits(quantity::AbstractQuantity)::SimpleQuantity

Express `quantity` as an object of type `SimpleQuantity` using the seven basic SI units.
"""
function inBasicSIUnits(quantity::AbstractQuantity)::SimpleQuantity
    subtype = typeof(quantity)
    error("subtype $subtype of AbstractQuantity misses an implementation of the inBasicSIUnits function")
end

"""
    Base.:*(quantity::AbstractQuantity, unit::AbstractUnit)

Modify the unit of `quantity` by multiplying it with `unit`.
"""
function Base.:*(quantity::AbstractQuantity, unit::AbstractUnit)
    subtype = typeof(quantity)
    error("subtype $subtype of AbstractQuantity misses an implementation of the multiplication with an AbstractUnit")
end

"""
    Base.:/(quantity::AbstractQuantity, unit::AbstractUnit)

Modify the unit of `quantity` by dividing it by `unit`.
"""
function Base.:/(quantity::AbstractQuantity, unit::AbstractUnit)
    subtype = typeof(quantity)
    error("subtype $subtype of AbstractQuantity misses an implementation of the division by an AbstractUnit")
end

"""
    Base.:+(quantity1::AbstractQuantity, quantity2::AbstractQuantity)

Add two physical quantities.
"""
function Base.:+(quantity1::AbstractQuantity, quantity2::AbstractQuantity)
    subtype = typeof(quantity1)
    error("subtype $subtype of AbstractQuantity misses an implementation of addition")
end

"""
    Base.:-(quantity1::AbstractQuantity, quantity2::AbstractQuantity)

Subtract `quantity2` from `quantity1`.
"""
function Base.:-(quantity1::AbstractQuantity, quantity2::AbstractQuantity)
    subtype = typeof(quantity1)
    error("subtype $subtype of AbstractQuantity misses an implementation of subtraction")
end

"""
    Base.:*(quantity1::AbstractQuantity, quantity2::AbstractQuantity)

Multiply two physical quantities.
"""
function Base.:*(quantity1::AbstractQuantity, quantity2::AbstractQuantity)
    subtype = typeof(quantity1)
    error("subtype $subtype of AbstractQuantity misses an implementation of multiplication")
end

"""
    Base.:/(quantity1::AbstractQuantity, quantity2::AbstractQuantity)

Divide `quantity1` by `quantity2`.
"""
function Base.:/(quantity1::AbstractQuantity, quantity2::AbstractQuantity)
    subtype = typeof(quantity1)
    error("subtype $subtype of AbstractQuantity misses an implementation of division")
end

"""
    Base.inv(quantity::AbstractQuantity)

Determine the multiplicative inverse of `quantity`.
"""
function Base.inv(quantity::AbstractQuantity)
    subtype = typeof(quantity)
    error("subtype $subtype of AbstractQuantity misses an implementation of the inv function")
end

"""
    Base.:^(quantity::AbstractQuantity, exponent::Real)

Raise `quantity` to the power of `exponent`.
"""
function Base.:^(quantity::AbstractQuantity, exponent::Real)
    subtype = typeof(quantity)
    error("subtype $subtype of AbstractQuantity misses an implementation of exponentiation")
end

"""
    Base.sqrt(quantity::AbstractQuantity)

Take the square root of `quantity`.
"""
function Base.sqrt(quantity::AbstractQuantity)
    subtype = typeof(quantity)
    error("subtype $subtype of AbstractQuantity misses an implementation of the sqrt function")
end

"""
    Base.transpose(quantity::AbstractQuantity)

Transpose `quantity`.
"""
function Base.transpose(quantity::AbstractQuantity)
    subtype = typeof(quantity)
    error("subtype $subtype of AbstractQuantity misses an implementation of the transpose function")
end
