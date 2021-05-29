export SimpleQuantityArray
mutable struct SimpleQuantityArray{T,N} <: AbstractQuantityArray{T,N}
    values::AbstractArray{T,N}
    unit::Unit

    function SimpleQuantityArray(values::AbstractArray{T,N}, abstractUnit::AbstractUnit) where {T<:Number, N}
        unit::Unit = convertToUnit(abstractUnit)
        sqArray = new{T,N}(values, unit)
        return sqArray
    end
end

## Broadcasting

# parts of the AbstractArray interface
Base.size(sqArray::SimpleQuantityArray) = size(sqArray.values)

Base.getindex(sqArray::SimpleQuantityArray, inds...) = getindex(sqArray.values, inds...)

Base.setindex!(sqArray::SimpleQuantityArray, X::Union{<:AbstractArray, <:Number}, inds...) = setindex!(sqArray.values, X, inds...)

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
        _handleExceptionInAddition(exception)
    end
    return sqArray
end

function _handleExceptionInAddition(exception::Exception)
    if isa(exception, Exceptions.DimensionMismatchError)
        newException = Exceptions.DimensionMismatchError("summands are not of the same physical dimension")
        throw(newException)
    else
        rethrow()
    end
end

function inUnitsOf(sqArray::SimpleQuantityArray, targetUnit::AbstractUnit)
    originalValues = sqArray.values
    originalUnit = sqArray.unit

    if originalUnit == targetUnit
        resultingQuantity = simpleQuantity
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
