export AbstractQuantity
"""
    AbstractQuantity

Abstract supertype for all types that represent a physical quantity.

Currently the only concrete subtype of `AbstractQuantity` is [`SimpleQuantity`](@ref).
"""
abstract type AbstractQuantity{T} end

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
    Base.:*(quantity::AbstractQuantity, object::Any)
    Base.:*(object::Any, quantity::AbstractQuantity)

Multiply a physical quantity with a dimensionless object. It is assumed that multipliation of `quantity.value` with `object` is implemented.
"""
function Base.:*(quantity::AbstractQuantity, object::Any)
    subtype = typeof(quantity)
    error("subtype $subtype of AbstractQuantity misses an implementation of multiplication")
end

function Base.:*(object::Any, quantity::AbstractQuantity)
    subtype = typeof(quantity)
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
    Base.:/(quantity::AbstractQuantity, object::Any)
    Base.:/(object::Any, quantity::AbstractQuantity)

Divide a physical quantity by a dimensionless object (or vice versa). It is assumed that division of `quantity.value` by `object` (and vice versa) is implemented.
"""
function Base.:/(quantity::AbstractQuantity, object::Any)
    subtype = typeof(quantity)
    error("subtype $subtype of AbstractQuantity misses an implementation of division")
end

function Base.:/(object::Any, quantity::AbstractQuantity)
    subtype = typeof(quantity)
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

"""
    Base.length(quantity::AbstractQuantity)

Returns `length(quantity.value)`.
"""
function Base.length(quantity::AbstractQuantity)
    subtype = typeof(quantity)
    error("subtype $subtype of AbstractQuantity misses an implementation of the length function")
end

"""
    Base.size(quantity::AbstractQuantity)

Returns `size(quantity.value)`.
"""
function Base.size(quantity::AbstractQuantity)
    subtype = typeof(quantity)
    error("subtype $subtype of AbstractQuantity misses an implementation of the size function")
end

"""
    Base.getindex(abstractQuantity::AbstractQuantity, key...)

Returns an element from a collection `abstractQuantity` wrapped by AbstractQuantity as an AbstractQuantity object with the corresponding unit.
"""
function Base.getindex(collection::AbstractQuantity, key...)
    subtype = typeof(collection)
    error("subtype $subtype of AbstractQuantity misses an implementation of the getindex function")
end

"""
    Base.setindex!(array::AbstractQuantity{A}, element::AbstractQuantity, key...) where A <: AbstractArray

Sets an element in an array wrapped by AbstractQuantity.

The `element` needs to have a unit compatible with the unit of `array`, and `element.value` has to be of a type that can be converted to the type of `array.value`.
"""
function Base.setindex!(array::AbstractQuantity{A}, element::AbstractQuantity, key...) where A <: AbstractArray
    subtype = typeof(array)
    error("subtype $subtype of AbstractQuantity misses an implementation of the setindex! function")
end
