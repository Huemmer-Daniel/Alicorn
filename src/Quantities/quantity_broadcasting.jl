# Broadcasting style
Base.BroadcastStyle(::Type{<:SimpleQuantityArray}) = Broadcast.ArrayStyle{SimpleQuantityArray}()
Base.BroadcastStyle(::Type{<:QuantityArray}) = Broadcast.ArrayStyle{QuantityArray}()
Base.BroadcastStyle(::Type{<:SimpleQuantity}) = Broadcast.DefaultArrayStyle{0}() # TODO tentative
Base.BroadcastStyle(::Type{<:Quantity}) = Broadcast.DefaultArrayStyle{0}()

Base.BroadcastStyle(s1::Broadcast.ArrayStyle{SimpleQuantityArray}, s2::Broadcast.ArrayStyle{QuantityArray}) = s2
Base.BroadcastStyle(s1::Broadcast.ArrayStyle{QuantityArray}, s2::Broadcast.ArrayStyle{SimpleQuantityArray}) = s1

# TODO
# Quantity and SimpleQuantity should be broadcastable
# -> need to support [`axes`](@ref), indexing, and its type supports [`ndims`](@ref)
Base.broadcastable(q::AbstractQuantity) = q

Base.IndexStyle(::Type{<:SimpleQuantity}) = IndexLinear()
Base.IndexStyle(::Type{<:Quantity}) = IndexLinear()

# define getindex twice -- once with a single argument, once as varargs --
# to avoid unintended splatting if inds is itself an iterable collection
Base.getindex(sqArray::SimpleQuantity, inds) = getindex(sqArray.value, inds) * sqArray.unit
Base.getindex(sqArray::SimpleQuantity, inds...) = getindex(sqArray.value, inds...) * sqArray.unit

function Base.getindex(q::Quantity, inds)
    subarray = getindex(q.value, inds)
    if length(subarray) == 1
        return Quantity(subarray, q.dimension, q.internalUnits)
    else
        return QuantityArray(subarray, q.dimension, q.internalUnits)
    end
end

function Base.getindex(q::Quantity, inds...)
    subarray = getindex(q.value, inds...)
    if length(subarray) == 1
        return Quantity(subarray, q.dimension, q.internalUnits)
    else
        return QuantityArray(subarray, q.dimension, q.internalUnits)
    end
end

## TODO end hack

## SimpleQuantityArray

# contruct destination SimpleQuantityArray
function Base.similar(bc::Broadcast.Broadcasted{Broadcast.ArrayStyle{SimpleQuantityArray}}, ::Type{SimpleQuantity{ElType}}) where ElType
    (targetUnit, unitlessBroadcasted) = squeezeOutUnits(bc)
    # println(unitlessBroadcasted)
    targetQuantity = SimpleQuantityArray( similar(Array{ElType}, axes(unitlessBroadcasted)) , targetUnit)
    return targetQuantity
end

# separate units from values in the Broadcasted object
# the unitless Broadcast is then treated with default Julia machinery for handling broadcasting
# the units are handled separately, inferring the unit of the resulting SimpleQuantityArray from all input units and the
# functions involved in the broadcast
function squeezeOutUnits(bc::Broadcast.Broadcasted{Broadcast.ArrayStyle{SimpleQuantityArray}})
    func = bc.f
    args = bc.args
    unitsAndValues = squeezeOutUnits.(args)
    unitlessValues = _isolateValuesFromUnits(unitsAndValues)

    unit = inferTargetUnit(func, unitsAndValues...)
    unitlessBroadcasted = Broadcast.Broadcasted{Broadcast.ArrayStyle}( func, unitlessValues )

    return (unit, unitlessBroadcasted)
end

_isolateValuesFromUnits(unitsAndValues::Tuple) = Tuple([value for (_,value) in unitsAndValues])

squeezeOutUnits(q::SimpleQuantityType) = (q.unit, q.value)

function squeezeOutUnits(extruded::Base.Broadcast.Extruded{T, K, D}) where {T<:SimpleQuantityArray, K<:Any, D<:Any}
    sqArray = extruded.x
    keeps = extruded.keeps
    defaults = extruded.defaults

    unit = sqArray.unit
    unitlessArray = sqArray.value

    extrudedWithoutUnits = Base.Broadcast.Extruded(unitlessArray, keeps, defaults)
    return (unit, extrudedWithoutUnits)
end

squeezeOutUnits(any::Any) = (Nothing, any)


# infer target units for different broadcastable operations on SimpleQuantityArrays

inferTargetUnit(::typeof(abs), arg::Tuple{<:AbstractUnit, <:Any}) = arg[1]

inferTargetUnit(::typeof(angle), arg::Tuple{<:AbstractUnit, <:Any}) = unitlessUnit

inferTargetUnit(::typeof(/), arg1::Tuple{<:AbstractUnit, <:Any}, arg2::Tuple) = arg1[1]

inferTargetUnit(::typeof(/), arg1::Tuple, arg2::Tuple{<:AbstractUnit, <:Any}) = inv(arg2[1])

inferTargetUnit(::typeof(/), arg1::Tuple{<:AbstractUnit, <:Any}, arg2::Tuple{<:AbstractUnit, <:Any}) = arg1[1] / arg2[1]

inferTargetUnit(::typeof(*), arg1::Tuple{<:AbstractUnit, <:Any}, arg2::Tuple) = arg1[1]

inferTargetUnit(::typeof(*), arg1::Tuple, arg2::Tuple{<:AbstractUnit, <:Any}) = arg2[1]

inferTargetUnit(::typeof(*), arg1::Tuple{<:AbstractUnit, <:Any}, arg2::Tuple{<:AbstractUnit, <:Any}) = arg1[1] * arg2[1]

inferTargetUnit(::typeof(Base.literal_pow), arg1::Tuple, arg2::Tuple{<:AbstractUnit, <:AbstractArray}, arg3::Tuple{<:Any, <:Base.RefValue{Val{exponent}}}) where exponent = (arg2[1])^exponent

inferTargetUnit(::typeof(Base.literal_pow), arg1::Tuple, arg2::Tuple{<:AbstractUnit, <:Base.Broadcast.Extruded}, arg3::Tuple{<:Any, <:Base.RefValue{Val{exponent}}}) where exponent = (arg2[1])^exponent

inferTargetUnit(::typeof(sqrt), arg::Tuple{<:AbstractUnit, <:Any}) = sqrt(arg[1])

inferTargetUnit(::typeof(real), arg::Tuple{<:AbstractUnit, <:Any}) = arg[1]

inferTargetUnit(::typeof(imag), arg::Tuple{<:AbstractUnit, <:Any}) = arg[1]

inferTargetUnit(::typeof(isless), arg1::Tuple{<:AbstractUnit, <:Any}, arg2::Tuple{<:AbstractUnit, <:Any}) = unitlessUnit



# SimpleQuantityArray eager evaluation: broadcastable operations on SimpleQuantityArrays that require eager evaluation

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


## QuantityArray

# if final array type is QuantityArray:
# convert all quantities to Quantity or QuantityArray of uniform InternalUnits before evaluating the Broadcasted object
function Broadcast.materialize(bc::Broadcast.Broadcasted{Broadcast.ArrayStyle{QuantityArray}})
    # determine which InternalUnits to use
    targetInternalUnits = _findFirstInternalUnits(bc)
    # infer which physical dimension bc will evaluate to, and in the process construct a new Broadcasted that only
    # contains the bare values of all quantitites (converted to Quantity or QuantityArray using the targetInternalUnits
    # wherever appropriate)
    (bareValue_bc, targetDimension) = _squeezeOutDims(bc, targetInternalUnits)
    # evaluate the bare value Broadcasted using Julia default machinery
    bareValue = Broadcast.materialize(bareValue_bc)
    # construct the corresponding QuantityArray using the targetDimension and targetInternalUnits we inferred earlier
    return QuantityArray(bareValue, targetDimension, targetInternalUnits)
end

# recursively iterate through arguments of bc and return the InternalUnit of the first Quantity or QuantityArray
# encountered; the Broadcasted is of type ArrayStyle{QuantityArray}, so there has to be at least one
function _findFirstInternalUnits(bc::Broadcast.Broadcasted{Broadcast.ArrayStyle{QuantityArray}})
    intU = Nothing
    for arg in bc.args
        intU = _findFirstInternalUnits(arg)
        if isa(intU, InternalUnits)
            return intU
        end
    end
    # should be unreachable
    error("could not determine appropriate InternalUnits during broadcast to Quantity or QuantityArray")
end
_findFirstInternalUnits(q::QuantityType) = q.internalUnits

# recursively separate dimensions and internal units from bare values in the Broadcasted object
# returns the appropriate physical dimension the Broadcasted object will evaluate to, and a new Broadcasted object
# analogous to bc, but containing only the bare values instead of quantities
# in the process, all quantitites are converted to Quantity or QuantityArray using the targetInternalUnits
function _squeezeOutDims(bc::Broadcast.Broadcasted{Broadcast.ArrayStyle{QuantityArray}}, targetInternalUnits::InternalUnits)
    bareValues = Array{Any}(undef, length(bc.args))
    dims = Array{Any}(undef, length(bc.args))
    # infer bare value and dimension of each argument in bc
    # the bare value can be a Broadcasted itself
    for (index,arg) in enumerate(bc.args)
        (bareValue, dim) = _squeezeOutDims(arg, targetInternalUnits)
        bareValues[index] = bareValue
        dims[index] = dim
    end
    # the appropriate dimension of the evaluated bc depends on the function bc.f and the dimensions of all arguments
    targetDimension = inferTargetDimension(bc.f, dims...)
    # construct a Broadcastable equivalent to bc but containing only the bare values
    bareValue_bc = Broadcast.broadcasted(bc.f, bareValues...)
    return (bareValue_bc, targetDimension)
end
function _squeezeOutDims(q::QuantityType, intU::InternalUnits)
    q = inInternalUnitsOf(q, intU)
    return (q.value, q.dimension)
end
function _squeezeOutDims(q::SimpleQuantity, intU::InternalUnits)
    q = Quantity(q, intU)
    return (q.value, q.dimension)
end
function _squeezeOutDims(q::SimpleQuantityArray, intU::InternalUnits)
    q = QuantityArray(q, intU)
    return (q.value, q.dimension)
end
_squeezeOutDims(n::Union{Number, Array{<:Number}}, intU::InternalUnits) = (n, Nothing)
# fallback: error for other types
_squeezeOutDims(a::Any, intU::InternalUnits) =
    throw(error("expected elements of type Number, Array{<:Number}, SimpleQuantityType, or QuantityType in broadcast to QuantityArray, got $(typeof(a))"))

# infer target dimension and check compatibility of dimensions if required
# Multiplication
inferTargetDimension(::typeof(*), d1::Dimension, d2::Dimension) = d1 * d2
inferTargetDimension(::typeof(*), d1::Dimension, d2::Type{Nothing}) = d1
inferTargetDimension(::typeof(*), d1::Type{Nothing}, d2::Dimension) = d2
# Division
inferTargetDimension(::typeof(/), d1::Dimension, d2::Dimension) = d1 / d2
inferTargetDimension(::typeof(/), d1::Dimension, d2::Type{Nothing}) = d1
inferTargetDimension(::typeof(/), d1::Type{Nothing}, d2::Dimension) = inv(d2)
# Addition
function inferTargetDimension(::typeof(+), d1::Dimension, d2::Dimension)
    if d1 == d2
        return d1
    else
        newException = Exceptions.DimensionMismatchError("summands are not of the same physical dimension")
        throw(newException)
    end
end
# Subtraction
function inferTargetDimension(::typeof(-), d1::Dimension, d2::Dimension)
    if d1 == d2
        return d1
    else
        newException = Exceptions.DimensionMismatchError("summands are not of the same physical dimension")
        throw(newException)
    end
end

# fallback for functions without implementation for broadcasting
inferTargetDimension(t::Any, args...) =
    throw(error("Broadcasting function $t to QuantityArray not implemented by Alicorn. Define appropriate method inferTargetDimension(::$t, d::Dimension, args...) to solve this issue."))
