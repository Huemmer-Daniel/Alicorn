export SimpleQuantityArray
@doc raw"""
    SimpleQuantityArray{T,N} <: AbstractQuantityArray{T,N}

A physical quantity consisting of a number array and a physical unit.

TODO
"""
mutable struct SimpleQuantityArray{T,N} <: AbstractQuantityArray{T,N}
    values::AbstractArray{T,N}
    unit::Unit

    function SimpleQuantityArray(values::AbstractArray{T,N}, abstractUnit::AbstractUnit) where {T<:Number, N}
        unit = convertToUnit(abstractUnit)
        sqArray = new{T,N}(values, unit)
        return sqArray
    end
end

## ## External constructors

function SimpleQuantityArray(values::AbstractArray{T,N}) where {T<:Number, N}
    unit = unitlessUnit
    sqArray = SimpleQuantityArray(values, unit)
    return sqArray
end

## ## Methods for creating a SimpleQuantityArray

"""
    Base.:*(values::AbstractArray{T,N}, abstractUnit::AbstractUnit) where {T<:Number, N}

Combine the array `values` and `abstractUnit` to form a physical quantity of type `SimpleQuantityArray`.

# Example
```jldoctest
julia> ucat = UnitCatalogue() ;

julia> [3.5, 4.6] * ucat.tesla
2-element SimpleQuantityArray{Float64, 1} of unit T:
 3.5
 4.6
```
"""
function Base.:*(values::AbstractArray{T,N}, abstractUnit::AbstractUnit) where {T<:Number, N}
    return SimpleQuantityArray(values, abstractUnit)
end

"""
    Base.:/(values::AbstractArray{T,N}, abstractUnit::AbstractUnit) where {T<:Number, N}

Combine the array `values` and `abstractUnit` to form a physical quantity of type `SimpleQuantityArray`.

# Example
```jldoctest
julia> ucat = UnitCatalogue() ;

julia> [3.5, 4.6] / ucat.second
2-element SimpleQuantityArray{Float64, 1} of unit s^-1:
 3.5
 4.6
```
"""
function Base.:/(values::AbstractArray{T,N}, abstractUnit::AbstractUnit) where {T<:Number, N}
    inverseAbstractUnit = inv(abstractUnit)
    return SimpleQuantityArray(values, inverseAbstractUnit)
end

## ## Methods implementing the interface of AbstractArray

Base.size(sqArray::SimpleQuantityArray) = size(sqArray.values)

Base.IndexStyle(::Type{<:SimpleQuantityArray}) = IndexLinear()

Base.getindex(sqArray::SimpleQuantityArray, inds...) = getindex(sqArray.values, inds...)

Base.setindex!(sqArray::SimpleQuantityArray, X::Union{<:AbstractArray{T,N}, <:Number}, inds...) where {T <: Number, N}= setindex!(sqArray.values, X, inds...)

## ## Methods implementing the interface of AbstractQuantityArray
## 1. Unit conversion

export inUnitsOf
# method documented as part of the AbstractQuantityArray interface
function inUnitsOf(sqArray::SimpleQuantityArray, targetUnit::AbstractUnit)
    originalValues = sqArray.values
    originalUnit = sqArray.unit

    if originalUnit == targetUnit
        resultingQuantityArray = sqArray
    else

        (originalUnitPrefactor, originalBaseUnitExponents) = convertToBasicSIAsExponents(originalUnit)
        (targetUnitPrefactor, targetBaseUnitExponents) = convertToBasicSIAsExponents(targetUnit)

        _assertDimensionsMatch(originalBaseUnitExponents, targetBaseUnitExponents)
        conversionFactor = originalUnitPrefactor / targetUnitPrefactor

        resultingValues = originalValues .* conversionFactor
        resultingQuantityArray = SimpleQuantityArray( resultingValues, targetUnit )
    end
    return resultingQuantityArray
end

export inBasicSIUnits
# method documented as part of the AbstractQuantityArray interface
function inBasicSIUnits(sqArray::SimpleQuantityArray)
    originalValues = sqArray.values
    originalUnit = sqArray.unit

    ( conversionFactor, resultingBasicSIUnit ) = convertToBasicSI(originalUnit)

    resultingValues = originalValues * conversionFactor
    resultingQuantity = SimpleQuantityArray( resultingValues, resultingBasicSIUnit )
    return resultingQuantity
end

export inUnitsOf
"""
    inUnitsOf(sqArray::SimpleQuantityArray, simpleQuantity::SimpleQuantity)

Express `sqArray` in units of `simpleQuantity`.
"""
function inUnitsOf(sqArray::SimpleQuantityArray, simpleQuantity::SimpleQuantity)
    targetUnit = simpleQuantity.unit
    return inUnitsOf(sqArray, targetUnit)
end

# method documented as part of the AbstractQuantity interface
function Base.:*(sqArray::SimpleQuantityArray, abstractUnit::AbstractUnit)
    values = sqArray.values
    unit = sqArray.unit

    unitProduct = unit * abstractUnit

    return SimpleQuantityArray(values, unitProduct)
end

# method documented as part of the AbstractQuantity interface
function Base.:*(abstractUnit::AbstractUnit, sqArray::SimpleQuantityArray)
    values = sqArray.values
    unit = sqArray.unit

    unitProduct = abstractUnit * unit

    return SimpleQuantityArray(values, unitProduct)
end

# method documented as part of the AbstractQuantity interface
function Base.:/(sqArray::SimpleQuantityArray, abstractUnit::AbstractUnit)
    values = sqArray.values
    unit = sqArray.unit

    unitQuotient = unit / abstractUnit

    return SimpleQuantityArray(values, unitQuotient)
end

# method documented as part of the AbstractQuantity interface
function Base.:/(abstractUnit::AbstractUnit, sqArray::SimpleQuantityArray)
    values = sqArray.values
    unit = sqArray.unit

    unitQuotient = abstractUnit / unit

    return SimpleQuantityArray(inv(values), unitQuotient)
end


## 2. Arithmetic unary and binary operators

# method documented as part of the AbstractQuantity interface
function Base.:+(sqArray::SimpleQuantityArray)
    return sqArray
end

# method documented as part of the AbstractQuantity interface
function Base.:-(sqArray::SimpleQuantityArray)
    values = -sqArray.values
    unit = sqArray.unit
    return SimpleQuantityArray( values, unit )
end


"""
    Base.:+(sqArray1::SimpleQuantityArray, sqArray2::SimpleQuantityArray)

Add two `SimpleQuantityArrays`.

The resulting quantity is expressed in units of `sqArray1`.

# Raises Exceptions
- `Alicorn.Exceptions.DimensionMismatchError`: if `sqArray1` and `sqArray2` are of different dimensions
"""
function Base.:+(sqArray1::SimpleQuantityArray, sqArray2::SimpleQuantityArray)
    targetUnit = sqArray1.unit
    sqArray2 = _addition_ConvertQuantityToTargetUnit(sqArray2, targetUnit)
    sumValues = sqArray1.values + sqArray2.values
    sumQuantity = SimpleQuantityArray( sumValues, targetUnit )
    return sumQuantity
end

function _addition_ConvertQuantityToTargetUnit(sqArray::SimpleQuantityArray, targetUnit::AbstractUnit)
    try
        sqArray = inUnitsOf(sqArray, targetUnit)
    catch exception
        _handleExceptionInArrayAddition(exception)
    end
    return simpleQuantsqArrayity
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

# method documented as part of the AbstractQuantity interface
function Base.:*(sqArray1::SimpleQuantityArray, sqArray2::SimpleQuantityArray)
    productValues = sqArray1.values * sqArray2.values
    productUnit = sqArray1.unit * sqArray2.unit
    productQArray = SimpleQuantityArray(productValues, productUnit)
    return productQArray
end

# method documented as part of the AbstractQuantity interface
function Base.:*(sqArray::SimpleQuantityArray, simpleQuantity::SimpleQuantity)
    productValues = sqArray.values * simpleQuantity.value
    productUnit = sqArray.unit * simpleQuantity.unit
    productQArray = SimpleQuantityArray(productValues, productUnit)
    return productQArray
end

# method documented as part of the AbstractQuantity interface
function Base.:*(simpleQuantity::SimpleQuantity, sqArray::SimpleQuantityArray)
    productValues = simpleQuantity.value * sqArray.values
    productUnit = sqArray.unit * simpleQuantity.unit
    productQArray = SimpleQuantityArray(productValues, productUnit)
    return productQArray
end

# method documented as part of the AbstractQuantity interface
function Base.:*(sqArray::SimpleQuantityArray, number::Number)
    productValues = sqArray.values * number
    productUnit = sqArray.unit
    productQArray = SimpleQuantityArray(productValues, productUnit)
    return productQArray
end

# method documented as part of the AbstractQuantity interface
function Base.:*(number::Number, sqArray::SimpleQuantityArray)
    productValues = number * sqArray.values
    productUnit = sqArray.unit
    productQArray = SimpleQuantityArray(productValues, productUnit)
    return productQArray
end

# method documented as part of the AbstractQuantity interface
function Base.:/(sqArray1::SimpleQuantityArray, sqArray2::SimpleQuantityArray)
    quotientValues = sqArray1.values / sqArray2.values
    quotientUnit = sqArray1.unit / sqArray2.unit
    quotientQArray = SimpleQuantityArray(quotientValues, quotientUnit)
    return quotientQArray
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
    sqArray1 = _ensureComparedWithSameUnit(sqArray1, sqArray2)
    return ( sqArray1.values == sqArray2.values )
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

## ## Broadcasting

## TODO BELOW

# Broadcasting style
Base.BroadcastStyle(::Type{<:SimpleQuantityArray}) = Broadcast.ArrayStyle{SimpleQuantityArray}()

# contruct destination array
function Base.similar(bc::Broadcast.Broadcasted{Broadcast.ArrayStyle{SimpleQuantityArray}}, ::Type{ElType}) where ElType
    # we do not want to convert any units here, if necessary this was already done upstream
    (targetUnit, bc) = squeezeOutUnits(bc)
    println(targetUnit)
    println(bc)
    targetSqArray = SimpleQuantityArray( similar(Array{ElType}, axes(bc)) , targetUnit)
    return targetSqArray
end

function squeezeOutUnits(bc::Broadcast.Broadcasted{Broadcast.ArrayStyle{SimpleQuantityArray}})
    func = bc.f
    args = bc.args

    unitsAndValues = squeezeOutUnits.(args)
    unitlessArgs = _isolateValues(unitsAndValues)

    unit = inferTargetUnit(func, unitsAndValues...)
    unitlessBroadcasted = Broadcast.Broadcasted{Broadcast.ArrayStyle{SimpleQuantityArray}}( func, unitlessArgs )

    return (unit, unitlessBroadcasted)
end

function _isolateValues(unitsAndValues::Tuple)
    unitlessArgs = Tuple([value for (~,value) in unitsAndValues])
end

function squeezeOutUnits(sqArray::SimpleQuantityArray)
    unit = sqArray.unit
    unitlessArray = sqArray.values
    return (unit, unitlessArray)
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

function inferTargetUnit(::typeof(*), arg1::Tuple{<:AbstractUnit, <:Any}, arg2::Tuple{<:AbstractUnit, <:Any})
    unit1 = arg1[1]
    unit2 = arg2[1]
    return unit1 * unit2
end

function inferTargetUnit(::typeof(Base.literal_pow), arg1::Tuple{<:Any, <:Any}, arg2::Tuple{<:AbstractUnit, <:AbstractArray}, arg3::Tuple{<:Any, <:Base.RefValue{Val{exponent}}}) where exponent
    unit = arg2[1]
    return unit^exponent
end

# broadcastable operations on SimpleQuantityArrays that require eager evaluation

function Broadcast.broadcasted(::typeof(+), sqArray1::SimpleQuantityArray, sqArray2::SimpleQuantityArray)
    targetUnit = sqArray1.unit
    sqArray2 = _addition_ConvertQuantityToTargetUnit(sqArray2, targetUnit)
    sumValues = sqArray1.values .+ sqArray2.values
    sumQuantity = SimpleQuantityArray( sumValues, targetUnit )
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

function _addition_ConvertQuantityToTargetUnit(sqArray::SimpleQuantityArray, targetUnit::AbstractUnit)
    try
        sqArray = inUnitsOf(sqArray, targetUnit)
    catch exception
        _handleExceptionInArrayAddition(exception)
    end
    return sqArray
end
