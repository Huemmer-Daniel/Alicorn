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
A
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

function inferTargetUnit(::typeof(*), arg1::Tuple{<:AbstractUnit, <:Any}, arg2::Tuple{<:AbstractUnit, <:Any})
    unit1 = arg1[1]
    unit2 = arg2[1]
    return unit1 * unit2
end

function inferTargetUnit(::typeof(Base.literal_pow), arg1::Tuple{<:Any, <:Any}, arg2::Tuple{<:AbstractUnit, <:AbstractArray}, arg3::Tuple{<:Any, <:Base.RefValue})
    unit = arg2[1]
    exponent = arg3[2]
    return unit^
end
