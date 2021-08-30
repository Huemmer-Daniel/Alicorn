export AbstractQuantityArray
"""
    AbstractQuantity{T,N} <: AbstractArray{T,N}

Abstract supertype for all types that represent a physical quantity array.

Currently the only concrete subtype of `AbstractQuantityArray` is [`AbstractQuantityArray`](@ref).
"""
abstract type AbstractQuantityArray{T,N} <: AbstractArray{T,N} end

## ## Interface
# the following functions need to be extended for concrete implementations of
# AbstractQuantity

## 1. Unit conversion

export inUnitsOf
"""
    inUnitsOf(qArray::AbstractQuantityArray, targetUnit::AbstractUnit)::SimpleQuantityArray

Express `qArray` as an object of type `SimpleQuantityArray` in terms of the unit specified by `targetUnit`.
"""
function inUnitsOf(qArray::AbstractQuantityArray, targetUnit::AbstractUnit)::SimpleQuantityArray
    subtype = typeof(qArray)
    error("missing specialization of inUnitsOf(::AbstractQuantityArray, ::AbstractUnit) for subtype $subtype")
end

export inBasicSIUnits
"""
    inBasicSIUnits(qArray::AbstractQuantity)::SimpleQuantityArray

Express `qArray` as an object of type `SimpleQuantityArray` using the seven basic SI units.
"""
function inBasicSIUnits(qArray::AbstractQuantityArray)::SimpleQuantityArray
    subtype = typeof(qArray)
    error("missing specialization of inBasicSIUnits(::AbstractQuantityArray) for subtype $subtype")
end

"""
    Base.:*(qArray::AbstractQuantityArray, unit::AbstractUnit)
    Base.:*(unit::AbstractUnit, qArray::AbstractQuantityArray)

Modify the unit of `qArray` by multiplying it with `unit`.
"""
function Base.:*(qArray::AbstractQuantityArray, unit::AbstractUnit)
    subtype = typeof(qArray)
    error("missing specialization of Base.:*(::AbstractQuantityArray, ::AbstractUnit) for subtype $subtype")
end

function Base.:*(unit::AbstractUnit, qArray::AbstractQuantityArray)
    subtype = typeof(qArray)
    error("missing specialization of Base.:*(::AbstractUnit, ::AbstractQuantityArray) for subtype $subtype")
end

"""
    Base.:/(qArray::AbstractQuantityArray, unit::AbstractUnit)
    Base.:/(unit::AbstractUnit, qArray::AbstractQuantityArray)

Modify the unit of `qArray` by dividing it by `unit`, or vice versa.
"""
function Base.:/(qArray::AbstractQuantityArray, unit::AbstractUnit)
    subtype = typeof(qArray)
    error("missing specialization of Base.:/(::AbstractQuantityArray, ::AbstractUnit) for subtype $subtype")
end

function Base.:/(unit::AbstractUnit, qArray::AbstractQuantityArray)
    subtype = typeof(qArray)
    error("missing specialization of Base.:/(::AbstractUnit, ::AbstractQuantityArray) for subtype $subtype")
end


## 2. Arithmetic unary and binary operators

"""
    Base.:+(quantity::AbstractQuantityArray)

Unary plus operator, acting as the identity operator.
"""
function Base.:+(qArray::AbstractQuantityArray)
    subtype = typeof(qArray)
    error("missing specialization of Base.:+(::AbstractQuantityArray) for subtype $subtype")
end

"""
    Base.:-(qArray::AbstractQuantityArray)

Unary minus operator, returning the additive inverse of the quantity.
"""
function Base.:-(qArray::AbstractQuantityArray)
    subtype = typeof(qArray)
    error("missing specialization of Base.:-(::AbstractQuantityArray) for subtype $subtype")
end

"""
    Base.:+(qArray1::AbstractQuantityArray, qArray2::AbstractQuantityArray)

Add two arrays of physical quantities.

The behavior of the addition depends on the concrete implementation of `AbstractQuantity`.
"""
function Base.:+(qArray1::AbstractQuantityArray, qArray2::AbstractQuantityArray)
    subtype = typeof(qArray1)
    error("missing specialization of Base.:+(::AbstractQuantityArray, ::AbstractQuantityArray) for subtype $subtype")
end

"""
    Base.:-(qArray1::AbstractQuantityArray, qArray2::AbstractQuantityArray)

Subtract `qArray1` from `qArray1`.

The behavior of the subtraction depends on the concrete implementation of `AbstractQuantity`.
"""
function Base.:-(qArray1::AbstractQuantityArray, qArray2::AbstractQuantityArray)
    subtype = typeof(qArray1)
    error("missing specialization of Base.:-(::AbstractQuantityArray, ::AbstractQuantityArray) for subtype $subtype")
end

"""
    Base.:*(qArray1::AbstractQuantityArray, qArray2::AbstractQuantityArray)

Multiply two arrays of physical quantities.
"""
function Base.:*(qArray1::AbstractQuantityArray, qArray2::AbstractQuantityArray)
    subtype = typeof(qArray1)
    error("missing specialization of Base.:*(::AbstractQuantityArray, ::AbstractQuantityArray) for subtype $subtype")
end

"""
    Base.:*(qArray::AbstractQuantityArray, array::Array{<:Number})
    Base.:*(array::Array{<:Number}, qArray::AbstractQuantityArray)

Multiply an array of physical quantities with a dimensionless array or vice versa.
"""
function Base.:*(qArray::AbstractQuantityArray, array::Array{<:Number})
    subtype = typeof(qArray)
    error("missing specialization of Base.:*(::AbstractQuantityArray, ::Array{<:Number}) for subtype $subtype")
end

function Base.:*(array::Array{<:Number}, qArray::AbstractQuantityArray)
    subtype = typeof(qArray)
    error("missing specialization of Base.:*(::Array{<:Number}, ::AbstractQuantityArray) for subtype $subtype")
end

"""
    Base.:*(qArray::AbstractQuantityArray, quantity::AbstractQuantity)
    Base.:*(quantity::AbstractQuantity, qArray::AbstractQuantityArray)

Multiply an array of physical quantities with a physical quantity.
"""
function Base.:*(qArray::AbstractQuantityArray, quantity::AbstractQuantity)
    subtype = typeof(qArray)
    error("missing specialization of Base.:*(::AbstractQuantityArray, ::AbstractQuantity) for subtype $subtype")
end

function Base.:*(quantity::AbstractQuantity, qArray::AbstractQuantityArray)
    subtype = typeof(qArray)
    error("missing specialization of Base.:*(::AbstractQuantity, ::AbstractQuantityArray) for subtype $subtype")
end

"""
    Base.:*(qArray::AbstractQuantityArray, number::Number)
    Base.:*(number::Number, qArray::AbstractQuantityArray)

Multiply an array of physical quantities with a dimensionless number.
"""
function Base.:*(qArray::AbstractQuantityArray, number::Number)
    subtype = typeof(qArray)
    error("missing specialization of Base.:*(::AbstractQuantityArray, ::Number) for subtype $subtype")
end

function Base.:*(number::Number, qArray::AbstractQuantityArray)
    subtype = typeof(qArray)
    error("missing specialization of Base.:*(::Number, ::AbstractQuantityArray) for subtype $subtype")
end

"""
    Base.:/(qArray1::AbstractQuantityArray, qArray2::AbstractQuantityArray)

Divide two arrays of physical quantities.
"""
function Base.:/(qArray1::AbstractQuantityArray, qArray2::AbstractQuantityArray)
    subtype = typeof(qArray1)
    error("missing specialization of Base.:/(::AbstractQuantityArray, ::AbstractQuantityArray) for subtype $subtype")
end

"""
    Base.:/(qArray::AbstractQuantityArray, array::Array{<:Number})
    Base.:/(array::Array{<:Number}, qArray::AbstractQuantityArray)

Divide an array of physical quantities by a dimensionless array or vice versa.
"""
function Base.:/(qArray::AbstractQuantityArray, array::Array{<:Number})
    subtype = typeof(qArray)
    error("missing specialization of Base.:/(::AbstractQuantityArray, ::Array{<:Number}) for subtype $subtype")
end

function Base.:/(array::Array{<:Number}, qArray::AbstractQuantityArray)
    subtype = typeof(qArray)
    error("missing specialization of Base.:/(::Array{<:Number}, ::AbstractQuantityArray) for subtype $subtype")
end

"""
    Base.:/(qArray::AbstractQuantityArray, quantity::AbstractQuantity)
    Base.:/(quantity::AbstractQuantity, qArray::AbstractQuantityArray)

Divide an array of physical quantities by a physical quantity or vice versa.
"""
function Base.:/(qArray::AbstractQuantityArray, quantity::AbstractQuantity)
    subtype = typeof(qArray)
    error("missing specialization of Base.:/(::AbstractQuantityArray, ::AbstractQuantity) for subtype $subtype")
end

function Base.:/(quantity::AbstractQuantity, qArray::AbstractQuantityArray)
    subtype = typeof(qArray)
    error("missing specialization of Base.:/(::AbstractQuantity, ::AbstractQuantityArray) for subtype $subtype")
end

"""
    Base.:/(qArray::AbstractQuantityArray, number::Number)
    Base.:/(number::Number, qArray::AbstractQuantityArray)

Divide an array of physical quantities by a dimensionless number or vice versa.
"""
function Base.:/(qArray::AbstractQuantityArray, number::Number)
    subtype = typeof(qArray)
    error("missing specialization of Base.:/(::AbstractQuantityArray, ::Number) for subtype $subtype")
end

function Base.:/(number::Number, qArray::AbstractQuantityArray)
    subtype = typeof(qArray)
    error("missing specialization of Base.:/(::Number, ::AbstractQuantityArray) for subtype $subtype")
end


raw"""
    Base.:\(qArray1::AbstractQuantityArray, qArray2::AbstractQuantityArray)

Inverse divide two arrays of physical quantities.
"""
function Base.:\(qArray1::AbstractQuantityArray, qArray2::AbstractQuantityArray)
    subtype = typeof(qArray1)
    error(raw"missing specialization of Base.:\(::AbstractQuantityArray, ::AbstractQuantityArray) for subtype " * "$subtype")
end

raw"""
    Base.:\(qArray::AbstractQuantityArray, array::Array{<:Number})
    Base.:\(array::Array{<:Number}, qArray::AbstractQuantityArray)

Inverse divide an array of physical quantities by a dimensionless array or vice versa.
"""
function Base.:\(qArray::AbstractQuantityArray, array::Array{<:Number})
    subtype = typeof(qArray)
    error(raw"missing specialization of Base.:\(::AbstractQuantityArray, ::Array{<:Number}) for subtype " * "$subtype")
end

function Base.:\(array::Array{<:Number}, qArray::AbstractQuantityArray)
    subtype = typeof(qArray)
    error(raw"missing specialization of Base.:\(::Array{<:Number}, ::AbstractQuantityArray) for subtype " * "$subtype")
end

raw"""
    Base.:\(quantity::AbstractQuantity, qArray::AbstractQuantityArray)

Inverse divide a physical quantity by an array of physical quantities.
"""
function Base.:\(quantity::AbstractQuantity, qArray::AbstractQuantityArray)
    subtype = typeof(qArray)
    error(raw"missing specialization of Base.:\(::AbstractQuantity, ::AbstractQuantityArray) for subtype " * "$subtype")
end

raw"""
    Base.:\(number::Number, qArray::AbstractQuantityArray)

Inverse divide a dimensionless number by an array of physical quantities.
"""
function Base.:\(number::Number, qArray::AbstractQuantityArray)
    subtype = typeof(qArray)
    error(raw"missing specialization of Base.:\(::Number, ::AbstractQuantityArray) for subtype " * "$subtype")
end

"""
    Base.:^(qArray::AbstractQuantityArray, exponent::Real)

Raise `qArray` to the power of `exponent`.
"""
function Base.:^(qArray::AbstractQuantityArray, exponent::Real)
    subtype = typeof(qArray)
    error("missing specialization of Base.:^(::AbstractQuantityArray, ::Number) for subtype $subtype")
end

"""
    Base.:inv(qArray::AbstractQuantityArray)

Matrix inverse.
"""
function Base.:inv(qArray::AbstractQuantityArray)
    subtype = typeof(qArray)
    error("missing specialization of Base.inv(::AbstractQuantityArray) for subtype $subtype")
end


## 3. Numeric comparison

"""
    Base.:==(qArray1::AbstractQuantityArray, qArray2::AbstractQuantityArray)

Returns `true` if `qArray1` and `qArray2` are of equal value.

The behavior of the comparison depends on the concrete subtype of `AbstractQuantityArray`.
"""
function Base.:(==)(qArray1::AbstractQuantityArray, qArray2::AbstractQuantityArray)
    subtype = typeof(qArray1)
    error("missing specialization of Base.:==(::AbstractQuantityArray, ::AbstractQuantityArray) for subtype $subtype")
end

"""
    Base.isapprox(qArray1::AbstractQuantityArray, qArray2::AbstractQuantityArray; rtol::Real = sqrt(eps()) )

Returns `true` if `qArray1` and `qArray2` are of approximately equal value.

The behavior of the comparison depends on the concrete subtype of `AbstractQuantityArray`.
"""
function Base.isapprox(qArray1::AbstractQuantityArray, qArray2::AbstractQuantityArray; rtol::Real = sqrt(eps()))
    subtype = typeof(qArray1)
    error("missing specialization of Base.isapprox(::AbstractQuantityArray, ::AbstractQuantityArray, ::Real) for subtype $subtype")
end

## 4. Complex numbers

## 5. Additional array methods

# """
#     Base.findmax(qArray::AbstractQuantityArray)
#
# Returns the value and index of the maximum. If there are multiple maximum elements, then the first one will be returned. If any element is `NaN`, this element is returned.
# """
# function Base.findmax(qArray::AbstractQuantityArray)
#     subtype = typeof(qArray)
#     error("missing specialization of Base.findmax(::AbstractQuantityArray) for subtype $subtype")
# end

"""
    Base.findmax(qArray::AbstractQuantityArray; dims=:)

Returns the value and index of the maximum along dimension `dims`.

If `dims` is omitted, all dimensions are included. If there are multiple maximum elements, then the first one will be returned. If any element is `NaN`, this element is returned.
"""
function Base.findmax(qArray::AbstractQuantityArray; dims=:)
    subtype = typeof(qArray)
    error("missing specialization of Base.findmax(::AbstractQuantityArray; dims) for subtype $subtype")
end

# """
#     Base.findmin(qArray::AbstractQuantityArray)
#
# Returns the value and index of the minimum. If there are multiple minimum elements, then the first one will be returned. If any element is `NaN`, this element is returned.
# """
# function Base.findmin(qArray::AbstractQuantityArray)
#     subtype = typeof(qArray)
#     error("missing specialization of Base.findmin(::AbstractQuantityArray) for subtype $subtype")
# end

"""
    Base.findmin(qArray::AbstractQuantityArray; dims=:)

Returns the value and index of the minimum along dimension `dims`.

If `dims` is omitted, all dimensions are included. If there are multiple minimum elements, then the first one will be returned. If any element is `NaN`, this element is returned.
"""
function Base.findmin(qArray::AbstractQuantityArray; dims=:)
    subtype = typeof(qArray)
    error("missing specialization of Base.findmin(::AbstractQuantityArray; dims) for subtype $subtype")
end
