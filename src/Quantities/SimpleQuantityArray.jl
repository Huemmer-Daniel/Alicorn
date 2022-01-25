@doc raw"""
    SimpleQuantityArray{T<:Number,N} <: AbstractQuantityArray{T,N}

A physical quantity consisting of a number array and a physical unit.

The value field of a `SimpleQuantityArray{T,N}` is of type `Array{T,N}`. `T`
needs to be a subtype of `Number`.

# Fields
- `value::Array{T,N}`: value of the quantity
- `unit::Unit`: unit of the quantity

# Constructors
```
SimpleQuantityArray(::AbstractArray, ::AbstractUnit)
SimpleQuantityArray(::AbstractArray)
```
If no unit is passed to the constructor, `unitlessUnit` is used by default.

```
SimpleQuantityArray{T}(::AbstractArray, ::AbstractUnit) where {T<:Number}
SimpleQuantityArray{T}(::AbstractArray) where {T<:Number}
```
If the type `T` is specified explicitly, Alicorn attempts to convert the `value`
accordingly.
"""
mutable struct SimpleQuantityArray{T<:Number,N} <: AbstractQuantityArray{T,N}
    value::Array{T,N}
    unit::Unit

    function SimpleQuantityArray(value::Array{T,N}, unit::Unit) where {T<:Number, N}
        return new{T,N}(value, unit)
    end
end

"""
    SimpleQuantityVector{T}

One-dimensional array-valued simple quantity with elements of type `T`.

Alias for `SimpleQuantityArray{T,1}`.
"""
const SimpleQuantityVector{T} = SimpleQuantityArray{T,1}

"""
    SimpleQuantityMatrix{T}

Two-dimensional array-valued simple quantity with elements of type `T`.

Alias for `SimpleQuantityArray{T,2}`.
"""
const SimpleQuantityMatrix{T} = SimpleQuantityArray{T,2}


## ## External constructors

SimpleQuantityArray(value::AbstractArray{T}, abstractUnit::AbstractUnit) where {T<:Number} = SimpleQuantityArray( Array(value), convertToUnit(abstractUnit) )
SimpleQuantityArray(value::AbstractArray{T}) where {T<:Number} = SimpleQuantityArray(value, unitlessUnit)

SimpleQuantityArray{T}(value::AbstractArray, abstractUnit::AbstractUnit) where {T<:Number} = SimpleQuantityArray( convert(Array{T}, value), abstractUnit)
SimpleQuantityArray{T}(value::AbstractArray) where {T<:Number} = SimpleQuantityArray( convert(Array{T}, value) )


## ## Type conversion

"""
    Base.convert(::Type{T}, sqArray::SimpleQuantityArray) where {T<:SimpleQuantityArray}

Convert `sqArray` from type `SimpleQuantityArray{S} where S` to type `SimpleQuantityArray{T}`.

Allows to convert, for instance, from `SimpleQuantityArray{Float64}` to `SimpleQuantityArray{UInt8}`.
"""
Base.convert(::Type{T}, sqArray::SimpleQuantityArray) where {T<:SimpleQuantityArray} = sqArray isa T ? sqArray : T(sqArray)


## ## Methods for creating a SimpleQuantityArray

"""
    Base.:*(value::AbstractArray{T}, abstractUnit::AbstractUnit) where {T<:Number}

Combine the array `value` and `abstractUnit` to form a physical quantity of type `SimpleQuantityArray`.

If `abstractUnit` is a product of a `UnitPrefix` and `BaseUnit`, they are first
combined into a `SimpleQuantity`, which is then in turn combined with `value`.

# Example
```jldoctest
julia> ucat = UnitCatalogue() ;

julia> [3.5, 4.6] * ucat.milli * ucat.tesla
2-element SimpleQuantityVector{Float64} of unit mT:
 3.5
 4.6
```
"""
function Base.:*(value::AbstractArray{T}, abstractUnit::AbstractUnit) where {T<:Number}
    return SimpleQuantityArray(value, abstractUnit)
end

"""
    Base.:/(value::AbstractArray{T}, abstractUnit::AbstractUnit) where {T<:Number}

Combine the array `value` and `abstractUnit` to form a physical quantity of type `SimpleQuantityArray`.

If `abstractUnit` is a product of a `UnitPrefix` and `BaseUnit`, they are first
combined into a `SimpleQuantity`, which is then in turn combined with `value`.

# Example
```jldoctest
julia> ucat = UnitCatalogue() ;

julia> [3.5, 4.6] / ucat.nano * ucat.second
2-element SimpleQuantityVector{Float64} of unit ns^-1:
 3.5
 4.6
```
"""
function Base.:/(value::AbstractArray{T}, abstractUnit::AbstractUnit) where {T<:Number}
    inverseAbstractUnit = inv(abstractUnit)
    return SimpleQuantityArray(value, inverseAbstractUnit)
end

# the following definitions allow to create a simple quantity by directly
# multiplying (dividing) n::Array, pre::UnitPrefix, and base::Union{BaseUnit, UnitFactor}) without
# parentheses:
#  n * pre * base
#  n / pre * base
# instead of
#  n * (pre * base)
#  n / (pre * base)
Base.:*(array::AbstractArray{T}, unitPrefix::UnitPrefix) where {T<:Number} = (array, unitPrefix, *)
Base.:/(array::AbstractArray{T}, unitPrefix::UnitPrefix) where {T<:Number} = (array, unitPrefix, /)
Base.:*(arrayWithUnitPrefix::Tuple{AbstractArray{T}, UnitPrefix, typeof(*)}, baseUnit::Union{BaseUnit, UnitFactor}) where {T<:Number} = arrayWithUnitPrefix[1] * ( arrayWithUnitPrefix[2] * baseUnit )
Base.:*(arrayWithUnitPrefix::Tuple{AbstractArray{T}, UnitPrefix, typeof(/)}, baseUnit::Union{BaseUnit, UnitFactor}) where {T<:Number} = arrayWithUnitPrefix[1] / ( arrayWithUnitPrefix[2] * baseUnit )

## ## Methods implementing the interface of AbstractArray

Base.size(sqArray::SimpleQuantityArray) = size(sqArray.value)

Base.IndexStyle(::Type{<:SimpleQuantityArray}) = IndexLinear()

function Base.getindex(sqArray::SimpleQuantityArray, inds...)
    unit = sqArray.unit
    array = sqArray.value

    subarray = getindex(array, inds...)

    return subarray * unit # can return both a SimpleQuantity and a SimpleQuantityArray
end

function Base.setindex!(sqArray::SimpleQuantityArray, sqSubarray::Union{SimpleQuantityArray, SimpleQuantity}, inds...)
    targetUnit = sqArray.unit
    array = sqArray.value

    sqSubarray = inUnitsOf(sqSubarray, targetUnit)
    subarray = sqSubarray.value
    setindex!(array, subarray, inds...)

    return array * targetUnit
end

function Base.setindex!(sqArray::SimpleQuantityArray, subarray::Union{AbstractArray{<:Number}, Number}, inds...)
    if iszero(subarray)
        setindex!(sqArray.value, subarray, inds...)
    else
        throw( Exceptions.DimensionMismatchError("dimensions of the quantity and the desired unit do not agree") )
    end
    return sqArray
end

# TODO below

## ## Methods implementing the interface of AbstractQuantityArray

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

## 5. Array methods

# method documented in Base
Base.eltype(sqArray::SimpleQuantityArray{T}) where T = SimpleQuantity{T}

# # method documented in Base
# Base.length(sqArray::SimpleQuantityArray) = length(sqArray.value)
#
# # method documented in Base
# Base.ndims(sqArray::SimpleQuantityArray) = ndims(sqArray.value)

# method documented in Base
# Base.axes(sqArray::SimpleQuantityArray) = axes(sqArray.value)
# Base.axes(sqArray::SimpleQuantityArray, d) = axes(sqArray.value, d)

# method documented in Base
function Base.findmax(sqArray::SimpleQuantityArray; dims=:)
    unit = sqArray.unit
    array = sqArray.value

    (maxVal, maxIndex) = findmax(array, dims=dims)

    return (maxVal * unit, maxIndex)
end

# method documented in Base
function Base.findmin(sqArray::SimpleQuantityArray; dims=:)
    unit = sqArray.unit
    array = sqArray.value

    (minVal, minIndex) = findmin(array, dims=dims)

    return (minVal * unit, minIndex)
end

function Base.transpose(sqArray::SimpleQuantityArray)
    unit = sqArray.unit
    value = transpose(sqArray.value)
    return SimpleQuantityArray(value, unit)
end

function Base.repeat(sqArray::SimpleQuantityArray; inner=nothing, outer=nothing)
    unit = sqArray.unit
    array = sqArray.value

    repeatedArray = repeat(array; inner=inner, outer=outer)

    return repeatedArray * unit
end

function Base.repeat(sqArray::SimpleQuantityArray, counts...)
    return repeat(sqArray, outer=counts)
end


## ## Additional Methods

## TODO BELOW

Base.circshift(sqArray::SimpleQuantityArray, shifts::Real) = circshift(sqArray.value, shifts) * sqArray.unit
Base.circshift(sqArray::SimpleQuantityArray, shifts::Base.DimsInteger) = circshift(sqArray.value, shifts) * sqArray.unit
Base.circshift(sqArray::SimpleQuantityArray, shifts) = circshift(sqArray.value, shifts) * sqArray.unit

Base.deleteat!(sqArray::SimpleQuantityArray, inds) = deleteat!(sqArray.value, inds)

Base.copy(sqArray::SimpleQuantityArray) = SimpleQuantityArray(copy(sqArray.value), sqArray.unit)
Base.deepcopy(sqArray::SimpleQuantityArray) = SimpleQuantityArray(deepcopy(sqArray.value), sqArray.unit)

## ## Broadcasting

# Broadcasting style
Base.BroadcastStyle(::Type{<:SimpleQuantityArray}) = Broadcast.ArrayStyle{SimpleQuantityArray}()

# contruct destination array
function Base.similar(bc::Broadcast.Broadcasted{Broadcast.ArrayStyle{SimpleQuantityArray}}, ::Type{SimpleQuantity{ElType}}) where ElType
    # we do not want to convert any units here, if necessary this was already done upstream
    (targetUnit, unitlessBroadcasted) = squeezeOutUnits(bc)
    targetSqArray = SimpleQuantityArray( similar(Array{ElType}, axes(unitlessBroadcasted)) , targetUnit)
    return targetSqArray
end

function squeezeOutUnits(bc::Broadcast.Broadcasted{Broadcast.ArrayStyle{SimpleQuantityArray}})
    func = bc.f
    args = bc.args

    unitsAndValue = squeezeOutUnits.(args)
    unitlessArgs = _isolatevalue(unitsAndValue)

    unit = inferTargetUnit(func, unitsAndValue...)
    unitlessBroadcasted = Broadcast.Broadcasted{Broadcast.ArrayStyle}( func, unitlessArgs )

    return (unit, unitlessBroadcasted)
end

function _isolatevalue(unitsAndValue::Tuple)
    unitlessArgs = Tuple([value for (~,value) in unitsAndValue])
end

function squeezeOutUnits(sqArray::SimpleQuantityArray)
    unit = sqArray.unit
    unitlessArray = sqArray.value
    return (unit, unitlessArray)
end

function squeezeOutUnits(extruded::Base.Broadcast.Extruded{T, K, D}) where {T<:SimpleQuantityArray, K<:Any, D<:Any}
    sqArray = extruded.x
    keeps = extruded.keeps
    defaults = extruded.defaults

    unit = sqArray.unit
    unitlessArray = sqArray.value

    extrudedWithoutUnits = Base.Broadcast.Extruded(unitlessArray, keeps, defaults)
    return (unit, extrudedWithoutUnits)
end

function squeezeOutUnits(simpleQuantity::SimpleQuantity)
    unit = simpleQuantity.unit
    unitlessNumber = simpleQuantity.value
    return (unit, unitlessNumber)
end

function squeezeOutUnits(any::Any)
    return (Nothing, any)
end

# infer target units for different broadcastable operations on SimpleQuantityArrays



inferTargetUnit(::typeof(abs), arg::Tuple{<:AbstractUnit, <:Any}) = arg[1]

inferTargetUnit(::typeof(angle), arg::Tuple{<:AbstractUnit, <:Any}) = unitlessUnit

inferTargetUnit(::typeof(/), arg1::Tuple{<:AbstractUnit, <:Any}, arg2::Tuple) = arg1[1]

inferTargetUnit(::typeof(/), arg1::Tuple, arg2::Tuple{<:AbstractUnit, <:Any}) = inv(arg2[1])

function inferTargetUnit(::typeof(/), arg1::Tuple{<:AbstractUnit, <:Any}, arg2::Tuple{<:AbstractUnit, <:Any})
    unit1 = arg1[1]
    unit2 = arg2[1]
    return unit1 / unit2
end

inferTargetUnit(::typeof(*), arg1::Tuple{<:AbstractUnit, <:Any}, arg2::Tuple) = arg1[1]

inferTargetUnit(::typeof(*), arg1::Tuple, arg2::Tuple{<:AbstractUnit, <:Any}) = arg2[1]

function inferTargetUnit(::typeof(*), arg1::Tuple{<:AbstractUnit, <:Any}, arg2::Tuple{<:AbstractUnit, <:Any})
    unit1 = arg1[1]
    unit2 = arg2[1]
    return unit1 * unit2
end

function inferTargetUnit(::typeof(Base.literal_pow), arg1::Tuple, arg2::Tuple{<:AbstractUnit, <:AbstractArray}, arg3::Tuple{<:Any, <:Base.RefValue{Val{exponent}}}) where exponent
    unit = arg2[1]
    return unit^exponent
end

function inferTargetUnit(::typeof(Base.literal_pow), arg1::Tuple, arg2::Tuple{<:AbstractUnit, <:Base.Broadcast.Extruded}, arg3::Tuple{<:Any, <:Base.RefValue{Val{exponent}}}) where exponent
    unit = arg2[1]
    return unit^exponent
end

inferTargetUnit(::typeof(real), arg::Tuple{<:AbstractUnit, <:Any}) = arg[1]

inferTargetUnit(::typeof(imag), arg::Tuple{<:AbstractUnit, <:Any}) = arg[1]

inferTargetUnit(::typeof(isless), arg1::Tuple{<:AbstractUnit, <:Any}, arg2::Tuple{<:AbstractUnit, <:Any}) = unitlessUnit

# broadcastable operations on SimpleQuantityArrays that require eager evaluation

# addition of two SimpleQuantityArray
function Broadcast.broadcasted(::typeof(+), sqArray1::SimpleQuantityArray, sqArray2::SimpleQuantityArray)
    targetUnit = sqArray1.unit
    sqArray2 = _addition_ConvertQuantityArrayToTargetUnit(sqArray2, targetUnit)
    sumvalue = sqArray1.value .+ sqArray2.value
    sumQuantity = SimpleQuantityArray( sumvalue, targetUnit )
end

function Broadcast.broadcasted(::typeof(+), bc::Broadcast.Broadcasted{Broadcast.ArrayStyle{SimpleQuantityArray}}, sqArray2::SimpleQuantityArray)
    sqArray1 = Broadcast.materialize(bc)
    Broadcast.broadcasted(+, sqArray1, sqArray2)
end

function Broadcast.broadcasted(::typeof(+), sqArray1::SimpleQuantityArray, bc::Broadcast.Broadcasted{Broadcast.ArrayStyle{SimpleQuantityArray}})
    sqArray2 = Broadcast.materialize(bc)
    Broadcast.broadcasted(+, sqArray1, sqArray2)
end

function Broadcast.broadcasted(::typeof(+), bc1::Broadcast.Broadcasted{Broadcast.ArrayStyle{SimpleQuantityArray}}, bc2::Broadcast.Broadcasted{Broadcast.ArrayStyle{SimpleQuantityArray}})
    sqArray1 = Broadcast.materialize(bc1)
    sqArray2 = Broadcast.materialize(bc2)
    Broadcast.broadcasted(+, sqArray1, sqArray2)
end

# subtraction of two SimpleQuantityArray
function Broadcast.broadcasted(::typeof(-), sqArray1::SimpleQuantityArray, sqArray2::SimpleQuantityArray)
    targetUnit = sqArray1.unit
    sqArray2 = _addition_ConvertQuantityArrayToTargetUnit(sqArray2, targetUnit)
    sumvalue = sqArray1.value .- sqArray2.value
    sumQuantity = SimpleQuantityArray( sumvalue, targetUnit )
end

function Broadcast.broadcasted(::typeof(-), bc::Broadcast.Broadcasted{Broadcast.ArrayStyle{SimpleQuantityArray}}, sqArray2::SimpleQuantityArray)
    sqArray1 = Broadcast.materialize(bc)
    Broadcast.broadcasted(-, sqArray1, sqArray2)
end

function Broadcast.broadcasted(::typeof(-), sqArray1::SimpleQuantityArray, bc::Broadcast.Broadcasted{Broadcast.ArrayStyle{SimpleQuantityArray}})
    sqArray2 = Broadcast.materialize(bc)
    Broadcast.broadcasted(-, sqArray1, sqArray2)
end

function Broadcast.broadcasted(::typeof(-), bc1::Broadcast.Broadcasted{Broadcast.ArrayStyle{SimpleQuantityArray}}, bc2::Broadcast.Broadcasted{Broadcast.ArrayStyle{SimpleQuantityArray}})
    sqArray1 = Broadcast.materialize(bc1)
    sqArray2 = Broadcast.materialize(bc2)
    Broadcast.broadcasted(-, sqArray1, sqArray2)
end

# addition of a SimpleQuantityArray and a SimpleQuantity
function Broadcast.broadcasted(::typeof(+), sqArray::SimpleQuantityArray, simpleQuantity::SimpleQuantity)
    targetUnit = sqArray.unit
    simpleQuantity = _addition_ConvertQuantityArrayToTargetUnit(simpleQuantity, targetUnit)
    sumvalue = sqArray.value .+ simpleQuantity.value
    sumQuantity = SimpleQuantityArray( sumvalue, targetUnit )
end

function Broadcast.broadcasted(::typeof(+), simpleQuantity::SimpleQuantity, sqArray::SimpleQuantityArray)
    targetUnit = simpleQuantity.unit
    sqArray = _addition_ConvertQuantityArrayToTargetUnit(sqArray, targetUnit)
    sumvalue = simpleQuantity.value .+ sqArray.value
    sumQuantity = SimpleQuantityArray( sumvalue, targetUnit )
end

function Broadcast.broadcasted(::typeof(+), bc::Broadcast.Broadcasted{Broadcast.ArrayStyle{SimpleQuantityArray}}, simpleQuantity::SimpleQuantity)
    sqArray = Broadcast.materialize(bc)
    Broadcast.broadcasted(+, sqArray, simpleQuantity)
end

function Broadcast.broadcasted(::typeof(+), simpleQuantity::SimpleQuantity, bc::Broadcast.Broadcasted{Broadcast.ArrayStyle{SimpleQuantityArray}})
    sqArray = Broadcast.materialize(bc)
    Broadcast.broadcasted(+, simpleQuantity, sqArray)
end

# subtraction of a SimpleQuantityArray and a SimpleQuantity

function Broadcast.broadcasted(::typeof(-), sqArray::SimpleQuantityArray, simpleQuantity::SimpleQuantity)
    targetUnit = sqArray.unit
    simpleQuantity = _addition_ConvertQuantityArrayToTargetUnit(simpleQuantity, targetUnit)
    sumvalue = sqArray.value .- simpleQuantity.value
    sumQuantity = SimpleQuantityArray( sumvalue, targetUnit )
end

function Broadcast.broadcasted(::typeof(-), simpleQuantity::SimpleQuantity, sqArray::SimpleQuantityArray)
    targetUnit = simpleQuantity.unit
    sqArray = _addition_ConvertQuantityArrayToTargetUnit(sqArray, targetUnit)
    sumvalue = simpleQuantity.value .- sqArray.value
    sumQuantity = SimpleQuantityArray( sumvalue, targetUnit )
end

function Broadcast.broadcasted(::typeof(-), bc::Broadcast.Broadcasted{Broadcast.ArrayStyle{SimpleQuantityArray}}, simpleQuantity::SimpleQuantity)
    sqArray = Broadcast.materialize(bc)
    Broadcast.broadcasted(-, sqArray, simpleQuantity)
end

function Broadcast.broadcasted(::typeof(-), simpleQuantity::SimpleQuantity, bc::Broadcast.Broadcasted{Broadcast.ArrayStyle{SimpleQuantityArray}})
    sqArray = Broadcast.materialize(bc)
    Broadcast.broadcasted(-, simpleQuantity, sqArray)
end
