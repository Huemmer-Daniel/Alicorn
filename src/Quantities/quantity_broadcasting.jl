# make Quantity and SimpleQuantity broadcastable
# QuantityArray and SimpleQuantityArray are <: AbstractArray and therefore already broadcastable
Base.broadcastable(q::AbstractQuantity) = q

# define broadcast styles for SimpleQuantity types and Quantity types
Base.BroadcastStyle(::Type{<:SimpleQuantityArray}) = Broadcast.ArrayStyle{SimpleQuantityArray}()
Base.BroadcastStyle(::Type{<:QuantityArray}) = Broadcast.ArrayStyle{QuantityArray}()
Base.BroadcastStyle(::Type{<:SimpleQuantity}) = Broadcast.DefaultArrayStyle{0}()
Base.BroadcastStyle(::Type{<:Quantity}) = Broadcast.DefaultArrayStyle{0}()
# give precedence to broadcast style of Quantity types over SimpleQuantity types
# this means any broadcast involving a Quantity or QuantityArray will return a QuantityArray
Base.BroadcastStyle(s1::Broadcast.ArrayStyle{SimpleQuantityArray}, s2::Broadcast.ArrayStyle{QuantityArray}) = s2
Base.BroadcastStyle(s1::Broadcast.ArrayStyle{QuantityArray}, s2::Broadcast.ArrayStyle{SimpleQuantityArray}) = s1

## SimpleQuantityArray: eager evaluation

# in construction of a Broadcasted involving SimpleQuantity types, catch operations that
# a) potentially require unit conversions (e.g., addition)
# b) return types other than SimpleQuantityArray
# and force eager evaluation:
# 1. if an argument is a Broadcasted already, materialize is to obtain a SimpleQuantityArray
# 2. then check and match units and evaluate the final array immediately

# Addition
# twice SimpleQuantityArray or SimpleQuantity
function Broadcast.broadcasted(::typeof(+), q1::SimpleQuantityType, q2::SimpleQuantityType)
    _addition_assertSameDimension(q1, q2)
    q2 = inUnitsOf(q2, q1.unit)
    return (q1.value .+ q2.value) * q1.unit
end
# SimpleQuantityArray or SimpleQuantity with Broadcasted
Broadcast.broadcasted(::typeof(+), bc::Broadcast.Broadcasted{Broadcast.ArrayStyle{SimpleQuantityArray}}, q2::SimpleQuantityType) =
    Broadcast.broadcasted(+, Broadcast.materialize(bc), q2)
Broadcast.broadcasted(::typeof(+), q1::SimpleQuantityArray, bc::Broadcast.Broadcasted{Broadcast.ArrayStyle{SimpleQuantityArray}}) =
    Broadcast.broadcasted(+, q1, Broadcast.materialize(bc))
# twice Broadcasted
Broadcast.broadcasted(::typeof(+), bc1::Broadcast.Broadcasted{Broadcast.ArrayStyle{SimpleQuantityArray}}, bc2::Broadcast.Broadcasted{Broadcast.ArrayStyle{SimpleQuantityArray}}) =
    Broadcast.broadcasted(+, Broadcast.materialize(bc1), Broadcast.materialize(bc2))

# Subtraction
# twice SimpleQuantityArray or SimpleQuantity
function Broadcast.broadcasted(::typeof(-), q1::SimpleQuantityType, q2::SimpleQuantityType)
    _addition_assertSameDimension(q1, q2)
    q2 = inUnitsOf(q2, q1.unit)
    return (q1.value .- q2.value) * q1.unit
end
# SimpleQuantityArray or SimpleQuantity with Broadcasted
Broadcast.broadcasted(::typeof(-), bc::Broadcast.Broadcasted{Broadcast.ArrayStyle{SimpleQuantityArray}}, q2::SimpleQuantityArray) =
    Broadcast.broadcasted(-, Broadcast.materialize(bc), q2)
Broadcast.broadcasted(::typeof(-), q1::SimpleQuantityArray, bc::Broadcast.Broadcasted{Broadcast.ArrayStyle{SimpleQuantityArray}}) =
    Broadcast.broadcasted(-, q1, Broadcast.materialize(bc))
# twice Broadcasted
Broadcast.broadcasted(::typeof(-), bc1::Broadcast.Broadcasted{Broadcast.ArrayStyle{SimpleQuantityArray}}, bc2::Broadcast.Broadcasted{Broadcast.ArrayStyle{SimpleQuantityArray}}) =
    Broadcast.broadcasted(-, Broadcast.materialize(bc1), Broadcast.materialize(bc2))

# Numerical comparison
# <
# twice SimpleQuantityArray or SimpleQuantity
function Broadcast.broadcasted(::typeof(<), q1::SimpleQuantityType, q2::SimpleQuantityType)
    _assertComparedWithSameDimension(q1, q2)
    q2 = inUnitsOf(q2, q1.unit)
    return isless.( q1.value, q2.value )
end
# SimpleQuantityArray or SimpleQuantity with Broadcasted
Broadcast.broadcasted(::typeof(<), bc::Broadcast.Broadcasted{Broadcast.ArrayStyle{SimpleQuantityArray}}, q2::SimpleQuantityType) =
    Broadcast.broadcasted(<, Broadcast.materialize(bc), q2)
Broadcast.broadcasted(::typeof(<), q1::SimpleQuantityType, bc::Broadcast.Broadcasted{Broadcast.ArrayStyle{SimpleQuantityArray}}) =
    Broadcast.broadcasted(<, q1, Broadcast.materialize(bc))
# twice Broadcasted
Broadcast.broadcasted(::typeof(<), bc1::Broadcast.Broadcasted{Broadcast.ArrayStyle{SimpleQuantityArray}}, bc2::Broadcast.Broadcasted{Broadcast.ArrayStyle{SimpleQuantityArray}}) =
    Broadcast.broadcasted(<, Broadcast.materialize(bc1), Broadcast.materialize(bc2))
# TODO: add more comparisons

## SimpleQuantityArray: no eager evaluation

# if final array type is SimpleQuantityArray:
# we can assume that the units of all involved quantities are compatible and no unit conversions are requried, since
# unit conversions would have been handled by eager evaluation via specialization of Broadcast.broadcasted while
# constructing the Broadcasted in the first place
function Broadcast.materialize(bc::Broadcast.Broadcasted{Broadcast.ArrayStyle{SimpleQuantityArray}})
    # infer which physical unit bc will evaluate to, and in the process construct a new Broadcasted that only
    # contains the bare values of all quantitites (converted to Quantity or QuantityArray using the targetInternalUnits
    # wherever appropriate)
    (bareValue_bc, targetUnit) = _squeezeOutUnits(bc)
    # evaluate the bare value Broadcasted using Julia default machinery
    bareValue = Broadcast.materialize(bareValue_bc)
    # construct the corresponding SimpleQuantityArray using the targetUnit we inferred earlier
    return SimpleQuantityArray(bareValue, targetUnit)
end

# recursively separate unit from bare values in the Broadcasted object
# returns the appropriate physical unit the Broadcasted object will evaluate to, and a new Broadcasted object
# analogous to bc, but containing only the bare values instead of quantities
function _squeezeOutUnits(bc::Broadcast.Broadcasted{Broadcast.ArrayStyle{SimpleQuantityArray}})
    bareValues = Array{Any}(undef, length(bc.args))
    valuesAndUnits = Array{Tuple}(undef, length(bc.args))
    # infer bare value and dimension of each argument in bc
    # the bare value can be a Broadcasted itself
    for (index,arg) in enumerate(bc.args)
        (bareValue, unit) = _squeezeOutUnits(arg)
        valuesAndUnits[index] = (bareValue, unit)
        bareValues[index] = bareValue
    end
    # the appropriate unit of the evaluated bc depends on the function bc.f and the units of all arguments
    targetUnit = inferTargetUnit(bc.f, valuesAndUnits...)
    # construct a Broadcastable equivalent to bc but containing only the bare values
    bareValue_bc = Broadcast.broadcasted(bc.f, bareValues...)
    return (bareValue_bc, targetUnit)
end
function _squeezeOutUnits(q::SimpleQuantityType)
    return (q.value, q.unit)
end
# fallback: not a SimpleQuantityType, does not feature Unit
_squeezeOutUnits(x::Any) = (x, Nothing)

# infer target unit - checking compatibility is never required: in such cases (e.g., addition), we use eager evaluation
# by specializing Broadcasted.broadcasted in order to be able to convert and match units
# fallback for functions without implementation for broadcasting
inferTargetUnit(t::Any, args...) =
    throw(error("Broadcasting function $t to SimpleQuantityArray not implemented by Alicorn. Defining appropriate method inferTargetUnit(::typeof($t), args...) may solve this issue."))

# unary plus and minus
function inferTargetUnit(t::Union{typeof(+), typeof(-)}, valueAndUnit::Tuple)
    u = valueAndUnit[2]
    return inferTargetUnit(t, u)
end
inferTargetUnit(::typeof(+), u::Unit) = u
inferTargetUnit(::typeof(-), u::Unit) = u

# Multiplication
function inferTargetUnit(::typeof(*), valueAndUnit1::Tuple, valueAndUnit2::Tuple)
    u1 = valueAndUnit1[2]
    u2 = valueAndUnit2[2]
    return inferTargetUnit(*, u1, u2)
end
inferTargetUnit(::typeof(*), u1::Unit, u2::Unit) = u1 * u2
inferTargetUnit(::typeof(*), u1::Unit, u2::Type{Nothing}) = u1
inferTargetUnit(::typeof(*), u1::Type{Nothing}, u2::Unit) = u2
# Division
function inferTargetUnit(::typeof(/), valueAndUnit1::Tuple, valueAndUnit2::Tuple)
    u1 = valueAndUnit1[2]
    u2 = valueAndUnit2[2]
    return inferTargetUnit(/, u1, u2)
end
inferTargetUnit(::typeof(/), u1::Unit, u2::Unit) = u1 / u2
inferTargetUnit(::typeof(/), u1::Unit, u2::Type{Nothing}) = u1
inferTargetUnit(::typeof(/), u1::Type{Nothing}, u2::Unit) = inv(u2)
# Exponentiation
inferTargetUnit(::typeof(^), valueAndUnit::Tuple{Any, Unit}, exponent::Tuple{Any, DataType}) = (valueAndUnit[2])^exponent[1]
# for integer exponents
inferTargetUnit(::typeof(Base.literal_pow), f::Tuple{Base.RefValue{typeof(^)}, DataType}, valueAndUnit::Tuple{<:Any, Unit}, exp::Tuple{Base.RefValue{Val{exponent}}, DataType}) where exponent = (valueAndUnit[2])^exponent

# TODO random collection below
inferTargetUnit(::typeof(abs), valueAndUnit::Tuple{Any, Unit}) = valueAndUnit[2]
inferTargetUnit(::typeof(angle), valueAndUnit::Tuple{Any, Unit}) = unitlessUnit
inferTargetUnit(::typeof(real), valueAndUnit::Tuple{Any, Unit}) = valueAndUnit[2]
inferTargetUnit(::typeof(imag), valueAndUnit::Tuple{Any, Unit}) = valueAndUnit[2]
inferTargetUnit(::typeof(sqrt), valueAndUnit::Tuple{Any, Unit}) = sqrt(valueAndUnit[2])
inferTargetUnit(::typeof(cbrt), valueAndUnit::Tuple{Any, Unit}) = cbrt(valueAndUnit[2])


## QuantityArray: eager evaluation

# in construction of a Broadcasted involving Quantity types, catch operations that
# a) return types other than QuantityArray
# and force eager evaluation:
# 1. if an argument is a Broadcasted already, materialize is to obtain a QuantityArray
# 2. then check dimensions and evaluate the final array immediately

# Numerical comparison
# <
# twice QuantityArray or Quantity
function Broadcast.broadcasted(::typeof(<), q1::QuantityType, q2::QuantityType)
    _assertComparedWithSameDimension(q1, q2)
    q2 = inInternalUnitsOf(q2, q1.internalUnits)
    return isless.( q1.value, q2.value )
end
# QuantityArray or Quantity with Broadcasted
Broadcast.broadcasted(::typeof(<), bc::Broadcast.Broadcasted{Broadcast.ArrayStyle{QuantityArray}}, q2::QuantityType) =
    Broadcast.broadcasted(<, Broadcast.materialize(bc), q2)
Broadcast.broadcasted(::typeof(<), q1::QuantityType, bc::Broadcast.Broadcasted{Broadcast.ArrayStyle{QuantityArray}}) =
    Broadcast.broadcasted(<, q1, Broadcast.materialize(bc))
# twice Broadcasted
Broadcast.broadcasted(::typeof(<), bc1::Broadcast.Broadcasted{Broadcast.ArrayStyle{QuantityArray}}, bc2::Broadcast.Broadcasted{Broadcast.ArrayStyle{QuantityArray}}) =
    Broadcast.broadcasted(<, Broadcast.materialize(bc1), Broadcast.materialize(bc2))

## QuantityArray: no eager evaluation

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
# fallback: not a QuantityType, does not feature InternalUnits
_findFirstInternalUnits(::Any) = Nothing

# recursively separate dimensions and internal units from bare values in the Broadcasted object
# returns the appropriate physical dimension the Broadcasted object will evaluate to, and a new Broadcasted object
# analogous to bc, but containing only the bare values instead of quantities
# in the process, all quantitites are converted to Quantity or QuantityArray using the targetInternalUnits
function _squeezeOutDims(bc::Broadcast.Broadcasted{Broadcast.ArrayStyle{QuantityArray}}, targetInternalUnits::InternalUnits)
    bareValues = Array{Any}(undef, length(bc.args))
    valuesAndDims = Array{Tuple}(undef, length(bc.args))
    # infer bare value and dimension of each argument in bc
    # the bare value can be a Broadcasted itself
    for (index,arg) in enumerate(bc.args)
        (bareValue, dim) = _squeezeOutDims(arg, targetInternalUnits)
        valuesAndDims[index] = (bareValue, dim)
        bareValues[index] = bareValue
    end
    # the appropriate dimension of the evaluated bc depends on the function bc.f and the dimensions of all arguments
    targetDimension = inferTargetDimension(bc.f, valuesAndDims...)
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
# fallback: not a QuantityType of SimpleQuantityType, does not feature Dimension
_squeezeOutDims(x::Any, ::InternalUnits) = (x, Nothing)

# infer target dimension and check compatibility of dimensions if required
# fallback for functions without implementation for broadcasting
inferTargetDimension(t::Any, args...) =
    throw(error("Broadcasting function $t to QuantityArray not implemented by Alicorn. Defining appropriate method inferTargetDimension(::typeof($t), args...) may solve this issue."))

# Unary plus and minus
function inferTargetDimension(t::Union{typeof(+), typeof(-)}, valueAndDim::Tuple)
    d = valueAndDim[2]
    return inferTargetDimension(t, d)
end
inferTargetDimension(::typeof(+), d::Dimension) = d
inferTargetDimension(::typeof(-), d::Dimension) = d

# Addition
function inferTargetDimension(::typeof(+), valueAndDim1::Tuple{Any, Dimension}, valueAndDim2::Tuple{Any, Dimension})
    if valueAndDim1[2] == valueAndDim2[2]
        return valueAndDim1[2]
    else
        newException = Exceptions.DimensionMismatchError("summands are not of the same physical dimension")
        throw(newException)
    end
end

# Subtraction
function inferTargetDimension(::typeof(-), valueAndDim1::Tuple{Any, Dimension}, valueAndDim2::Tuple{Any, Dimension})
    if valueAndDim1[2] == valueAndDim2[2]
        return valueAndDim1[2]
    else
        newException = Exceptions.DimensionMismatchError("summands are not of the same physical dimension")
        throw(newException)
    end
end

# Multiplication
function inferTargetDimension(::typeof(*), valueAndDim1::Tuple, valueAndDim2::Tuple)
    d1 = valueAndDim1[2]
    d2 = valueAndDim2[2]
    return inferTargetDimension(*, d1, d2)
end
inferTargetDimension(::typeof(*), d1::Dimension, d2::Dimension) = d1 * d2
inferTargetDimension(::typeof(*), d1::Dimension, d2::Type{Nothing}) = d1
inferTargetDimension(::typeof(*), d1::Type{Nothing}, d2::Dimension) = d2

# Division
function inferTargetDimension(::typeof(/), valueAndDim1::Tuple, valueAndDim2::Tuple)
    d1 = valueAndDim1[2]
    d2 = valueAndDim2[2]
    return inferTargetDimension(/, d1, d2)
end
inferTargetDimension(::typeof(/), d1::Dimension, d2::Dimension) = d1 / d2
inferTargetDimension(::typeof(/), d1::Dimension, d2::Type{Nothing}) = d1
inferTargetDimension(::typeof(/), d1::Type{Nothing}, d2::Dimension) = inv(d2)

# Exponentiation
inferTargetDimension(::typeof(^), valueAndDim::Tuple{Any, Dimension}, exponent::Tuple{Any, DataType}) = (valueAndDim[2])^exponent[1]
# for integer exponents
inferTargetDimension(::typeof(Base.literal_pow), f::Tuple{Base.RefValue{typeof(^)}, DataType}, valueAndDim::Tuple{<:Any, Dimension}, exp::Tuple{Base.RefValue{Val{exponent}}, DataType}) where exponent = (valueAndDim[2])^exponent

# TODO random collection below
inferTargetDimension(::typeof(abs), valueAndDim::Tuple{Any, Dimension}) = valueAndDim[2]
inferTargetDimension(::typeof(real), valueAndDim::Tuple{Any, Dimension}) = valueAndDim[2]
inferTargetDimension(::typeof(imag), valueAndDim::Tuple{Any, Dimension}) = valueAndDim[2]
inferTargetDimension(::typeof(sqrt), valueAndDim::Tuple{Any, Dimension}) = sqrt(valueAndDim[2])
inferTargetDimension(::typeof(cbrt), valueAndDim::Tuple{Any, Dimension}) = cbrt(valueAndDim[2])
