# Broadcasting style
Base.BroadcastStyle(::Type{<:SimpleQuantityArray}) = Broadcast.ArrayStyle{SimpleQuantityArray}()
Base.BroadcastStyle(::Type{<:QuantityArray}) = Broadcast.ArrayStyle{QuantityArray}()

# contruct destination array
function Base.similar(bc::Broadcast.Broadcasted{Broadcast.ArrayStyle{SimpleQuantityArray}}, ::Type{SimpleQuantity{ElType}}) where ElType
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

inferTargetUnit(::typeof(sqrt), arg::Tuple{<:AbstractUnit, <:Any}) = sqrt(arg[1])

inferTargetUnit(::typeof(real), arg::Tuple{<:AbstractUnit, <:Any}) = arg[1]

inferTargetUnit(::typeof(imag), arg::Tuple{<:AbstractUnit, <:Any}) = arg[1]

inferTargetUnit(::typeof(isless), arg1::Tuple{<:AbstractUnit, <:Any}, arg2::Tuple{<:AbstractUnit, <:Any}) = unitlessUnit



## SimpleQuantityArray eager evaluation
# broadcastable operations on SimpleQuantityArrays that require eager evaluation

# addition of two SimpleQuantityArray
function Broadcast.broadcasted(::typeof(+), sqArray1::SimpleQuantityArray, sqArray2::SimpleQuantityArray)
    targetUnit = sqArray1.unit
    _addition_assertSameDimension(sqArray1, sqArray2)
    sqArray2 = inUnitsOf(sqArray2, targetUnit)
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
    _addition_assertSameDimension(sqArray1, sqArray2)
    sqArray2 = inUnitsOf(sqArray2, targetUnit)
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
    _addition_assertSameDimension(sqArray, simpleQuantity)
    simpleQuantity = inUnitsOf(simpleQuantity, targetUnit)
    sumvalue = sqArray.value .+ simpleQuantity.value
    sumQuantity = SimpleQuantityArray( sumvalue, targetUnit )
end

function Broadcast.broadcasted(::typeof(+), simpleQuantity::SimpleQuantity, sqArray::SimpleQuantityArray)
    targetUnit = simpleQuantity.unit
    _addition_assertSameDimension(sqArray, simpleQuantity)
    sqArray = inUnitsOf(sqArray, targetUnit)
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
    _addition_assertSameDimension(sqArray, simpleQuantity)
    simpleQuantity = inUnitsOf(simpleQuantity, targetUnit)
    sumvalue = sqArray.value .- simpleQuantity.value
    sumQuantity = SimpleQuantityArray( sumvalue, targetUnit )
end

function Broadcast.broadcasted(::typeof(-), simpleQuantity::SimpleQuantity, sqArray::SimpleQuantityArray)
    targetUnit = simpleQuantity.unit
    _addition_assertSameDimension(sqArray, simpleQuantity)
    sqArray = inUnitsOf(sqArray, targetUnit)
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
