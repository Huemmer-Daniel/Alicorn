## SimpleQuantity

"""
    SimpleQuantity(quantity::AbstractQuantity)

Construct a `SimpleQuantity` from a physical quantity of any implementation of `AbstractQuantity`.

If `quantity` is of type `SimpleQuantity`, it is returned unchanged.
If `quantity` is of type `Quantity`, it is expressed in terms of the SI units
specified by `quantity.InternalUnits`.

# Example
```jldoctest
julia> ucat = UnitCatalogue() ; intu = InternalUnits(length=2*ucat.milli*ucat.meter) ;

julia> q = Quantity(4, Dimension(L=1), intu)
Quantity{Int64} of dimension L^1 in units of (2 mm):
 4
julia> sq = SimpleQuantity(q)
8 mm
```
"""
function SimpleQuantity(::AbstractQuantity) end

SimpleQuantity(simpleQuantity::SimpleQuantity) = simpleQuantity

function SimpleQuantity(quantity::Quantity{T}) where T
    sQuantity = quantity.value * internalUnitFor(quantity.dimension, quantity.internalUnits)
    value = _attemptConversionToType(T, sQuantity.value)
    return SimpleQuantity(value, sQuantity.unit)
end

function _attemptConversionToType(T::Type, value::Union{Number, AbstractArray})
    try
        value = convert(T, value)
    catch
    end
    return value
end

"""
    SimpleQuantity{T}(::AbstractQuantity) where {T<:Number}

Construct a `SimpleQuantity{T}` with specified type `T` from a physical quantity
of any implementation of `AbstractQuantity`.

See `SimpleQuantity(::AbstractQuantity)` for details.
"""
function SimpleQuantity{T}(::AbstractQuantity) where {T<:Number} end

SimpleQuantity{T}(simpleQuantity::SimpleQuantity) where {T<:Number} = SimpleQuantity(convert(T, simpleQuantity.value), simpleQuantity.unit)

function SimpleQuantity{T}(quantity::Quantity) where {T<:Number}
    sQuantity = quantity.value * internalUnitFor(quantity.dimension, quantity.internalUnits)
    value = convert(T, sQuantity.value)
    return SimpleQuantity(value, sQuantity.unit)
end

"""
    Base.convert(::Type{T}, simpleQuantity::SimpleQuantity) where {T<:SimpleQuantity}

Convert `simpleQuantity` from type `SimpleQuantity{S} where S` to any subtype
`T` of `SimpleQuantity`

Allows to convert, for instance, from `SimpleQuantity{Float64}` to `SimpleQuantity{UInt8}`.
"""
Base.convert(::Type{T}, simpleQuantity::SimpleQuantity) where {T<:SimpleQuantity} = simpleQuantity isa T ? simpleQuantity : T(simpleQuantity)


## Quantity

"""
    Quantity(::AbstractQuantity, ::InternalUnits)
    Quantity(::AbstractQuantity)

Construct a `Quantity` from a physical quantity of any implementation of `AbstractQuantity`.

If no `InternalUnits` are specified, they are constructed using basic SI units.
"""
function Quantity(::AbstractQuantity, ::InternalUnits) end
function Quantity(::AbstractQuantity) end

function Quantity(quantity::Quantity{T}, internalUnits::InternalUnits) where T
    if quantity.internalUnits == internalUnits
        return quantity
    else
        convFactor = conversionFactor(quantity.dimension, quantity.internalUnits, internalUnits)
        value = quantity.value * convFactor
        value = _attemptConversionToType(T, value)
        return Quantity(value, quantity.dimension, internalUnits)
    end
end

Quantity(quantity::Quantity) = quantity

function Quantity(simpleQuantity::SimpleQuantity{T}, internalUnits::InternalUnits) where T
    dimension = dimensionOf(simpleQuantity)
    internalUnit = internalUnitFor(dimension, internalUnits)
    internalValue = valueInUnitsOf(simpleQuantity, internalUnit)
    internalValue = _attemptConversionToType(T, internalValue)
    return Quantity(internalValue, dimension, internalUnits)
end

Quantity(simpleQuantity::SimpleQuantity) = Quantity(simpleQuantity, defaultInternalUnits)

"""
    Quantity{T}(::AbstractQuantity, ::InternalUnits) where {T<:Number}
    Quantity{T}(::AbstractQuantity) where {T<:Number}

Construct a `Quantity{T}` with specified type `T` from a physical quantity
of any implementation of `AbstractQuantity`.

See `Quantity(::AbstractQuantity, ::InternalUnits)` for details.

# Raises Exceptions
- `InexactError`: if the internal value of `AbstractQuantity` cannot be
represented as type `T`.
"""
function Quantity{T}(::AbstractQuantity, ::InternalUnits) where {T<:Number} end
function Quantity{T}(::AbstractQuantity) where {T<:Number} end

function Quantity{T}(quantity::Quantity, internalUnits::InternalUnits) where {T<:Number}
    convFactor = conversionFactor(quantity.dimension, quantity.internalUnits, internalUnits)
    value = quantity.value * convFactor
    value = convert(T, value)
    return Quantity(value, quantity.dimension, internalUnits)
end

Quantity{T}(quantity::Quantity) where {T<:Number} = Quantity(convert(T, quantity.value), quantity.dimension, quantity.internalUnits)

function Quantity{T}(simpleQuantity::SimpleQuantity, internalUnits::InternalUnits) where {T<:Number}
    dimension = dimensionOf(simpleQuantity)
    internalUnit = internalUnitFor(dimension, internalUnits)
    internalValue = valueInUnitsOf(simpleQuantity, internalUnit)
    internalValue = convert(T, internalValue)
    return Quantity(internalValue, dimension, internalUnits)
end

Quantity{T}(simpleQuantity::SimpleQuantity) where {T<:Number} = Quantity{T}(simpleQuantity::SimpleQuantity, defaultInternalUnits)

"""
    Base.convert(::Type{T}, quantity::Quantity) where {T<:Quantity}

Convert `quantity` from type `Quantity{S} where S` to any type `T` of
`Quantity`.

Allows to convert, for instance, from `Quantity{Float64}` to `Quantity{UInt8}`.
"""
Base.convert(::Type{T}, quantity::Quantity) where {T<:Quantity} = quantity isa T ? quantity : T(quantity)


## SimpleQuantityArray

"""
    SimpleQuantityArray(quantityArray::AbstractQuantityArray)

Construct a `SimpleQuantityArray` from a physical quantity of any implementation of `AbstractQuantityArray`.

If `quantityArray` is of type `SimpleQuantityArray`, it is returned unchanged.
If `quantityArray` is of type `QuantityArray`, it is expressed in terms of the SI units
specified by `quantityArray.InternalUnits`.
"""
function SimpleQuantityArray(quantityArray::AbstractQuantityArray) end

SimpleQuantityArray(sqArray::SimpleQuantityArray) = sqArray

function SimpleQuantityArray(qArray::QuantityArray{T}) where T
    sqArray = qArray.value * internalUnitFor(qArray.dimension, qArray.internalUnits)
    value = sqArray.value
    value = _attemptConversionToType(Array{T}, value)
    return SimpleQuantityArray(value, sqArray.unit)
end

"""
    SimpleQuantityArray(quantity::AbstractQuantity)

Construct a 1x1 `SimpleQuantityArray` from a physical quantity of any
implementation of `AbstractQuantity`.

See `SimpleQuantityArray(::AbstractQuantityArray)` for details.
"""
function SimpleQuantityArray(quantity::AbstractQuantity) end

SimpleQuantityArray(simpleQuantity::SimpleQuantity) = SimpleQuantityArray([simpleQuantity.value], simpleQuantity.unit)

function SimpleQuantityArray(quantity::Quantity{T}) where T
    sqArray = [quantity.value] * internalUnitFor(quantity.dimension, quantity.internalUnits)
    value = sqArray.value
    value = _attemptConversionToType(Array{T}, value)
    return SimpleQuantityArray(value, sqArray.unit)
end

"""
    SimpleQuantityArray{T}(::AbstractQuantityArray) where {T<:Number}

Construct a `SimpleQuantityArray{T}` with specified type `T` from a physical quantity
of any implementation of `AbstractQuantityArray`.

See `SimpleQuantityArray(::AbstractQuantityArray)` for details.

# Raises Exceptions
- `InexactError`: if the value of `AbstractQuantityArray` cannot be
represented as type `Array{T}`.
"""
function SimpleQuantityArray{T}(quantityArray::AbstractQuantityArray) where {T<:Number} end

SimpleQuantityArray{T}(sqArray::SimpleQuantityArray) where {T<:Number} = SimpleQuantityArray(convert(Array{T}, sqArray.value), sqArray.unit)

function SimpleQuantityArray{T}(qArray::QuantityArray) where {T<:Number}
    sqArray = qArray.value * internalUnitFor(qArray.dimension, qArray.internalUnits)
    value = convert(Array{T}, sqArray.value)
    return SimpleQuantityArray(value, sqArray.unit)
end

"""
    SimpleQuantityArray{T}(quantity::AbstractQuantity) where {T<:Number}

Construct a 1x1 `SimpleQuantityArray{T}` with specified type `T` from a physical
quantity of any implementation of `AbstractQuantity`.

See `SimpleQuantityArray(::AbstractQuantity)` for details.

# Raises Exceptions
- `InexactError`: if the value of `AbstractQuantity` cannot be
represented as type `Array{T}`.
"""
function SimpleQuantityArray{T}(quantity::AbstractQuantity) where {T<:Number} end

SimpleQuantityArray{T}(simpleQuantity::SimpleQuantity) where {T<:Number} = SimpleQuantityArray{T}(Array{T}([simpleQuantity.value]), simpleQuantity.unit)

function SimpleQuantityArray{T}(quantity::Quantity) where {T<:Number}
    sqArray = [quantity.value] * internalUnitFor(quantity.dimension, quantity.internalUnits)
    value = sqArray.value
    value = convert(Array{T}, value)
    return SimpleQuantityArray(value, sqArray.unit)
end

"""
    Base.convert(::Type{T}, sqArray::SimpleQuantityArray) where {T<:SimpleQuantityArray}

Convert `sqArray` from type `SimpleQuantityArray{S} where S` to any subtype `T`
of `SimpleQuantityArray`.

Allows to convert, for instance, from `SimpleQuantityArray{Float64}` to `SimpleQuantityVector{UInt8}`.
"""
Base.convert(::Type{T}, sqArray::SimpleQuantityArray) where {T<:SimpleQuantityArray} = sqArray isa T ? sqArray : T(sqArray)


## QuantityArray

"""
    QuantityArray(::AbstractQuantityArray, ::InternalUnits)
    QuantityArray(::AbstractQuantityArray)

Construct a `QuantityArray` from a physical quantity of any implementation of `AbstractQuantityArray`.

If no `InternalUnits` are specified, they are inferred from the
`AbstractQuantityArray` if possible. Else, basic SI units are used.
"""
function QuantityArray(::AbstractQuantityArray, ::InternalUnits) end
function QuantityArray(::AbstractQuantityArray) end

function QuantityArray(qArray::QuantityArray{T}, internalUnits::InternalUnits) where T
    if qArray.internalUnits == internalUnits
        return qArray
    else
        convFactor = conversionFactor(qArray.dimension, qArray.internalUnits, internalUnits)
        value = qArray.value * convFactor
        value = _attemptConversionToType(typeof(qArray.value), value)
        return QuantityArray(value, qArray.dimension, internalUnits)
    end
end
QuantityArray(qArray::QuantityArray) = qArray

function QuantityArray(sqArray::SimpleQuantityArray{T}, internalUnits::InternalUnits) where T
    dimension = dimensionOf(sqArray)
    internalUnit = internalUnitFor(dimension, internalUnits)
    internalValue = valueInUnitsOf(sqArray, internalUnit)
    internalValue = _attemptConversionToType(typeof(sqArray.value), internalValue)
    return QuantityArray(internalValue, dimension, internalUnits)
end
QuantityArray(sqArray::SimpleQuantityArray) = QuantityArray(sqArray, defaultInternalUnits)

"""
    QuantityArray(quantity::AbstractQuantity, ::InternalUnits)
    QuantityArray(quantity::AbstractQuantity)

Construct a 1x1 `QuantityArray` from a physical quantity of any implementation
of `AbstractQuantity`.

See `QuantityArray(::AbstractQuantityArray)` for details.
"""
function QuantityArray(::AbstractQuantity, ::InternalUnits) end
function QuantityArray(::AbstractQuantity) end

function QuantityArray(quantity::Quantity{T}, internalUnits::InternalUnits) where T
    q_inIntu = Quantity(quantity, internalUnits)
    return QuantityArray( Array([q_inIntu.value]), q_inIntu.dimension, q_inIntu.internalUnits )
end

function QuantityArray(quantity::Quantity)
    return QuantityArray( Array([quantity.value]), quantity.dimension, quantity.internalUnits )
end

function QuantityArray(simpleQuantity::SimpleQuantity, internalUnits::InternalUnits)
    sqArray = SimpleQuantityArray(simpleQuantity)
    return QuantityArray( sqArray, internalUnits )
end

function QuantityArray(simpleQuantity::SimpleQuantity)
    sqArray = SimpleQuantityArray(simpleQuantity)
    return QuantityArray( sqArray )
end

"""
    QuantityArray{T}(::AbstractQuantityArray, ::InternalUnits) where {T<:Number}
    QuantityArray{T}(::AbstractQuantityArray) where {T<:Number}

Construct a `QuantityArray{T}` with specified type `T` from a physical quantity
of any implementation of `AbstractQuantityArray`.

See `QuantityArray(::AbstractQuantityArray, ::InternalUnits)` for details.

# Raises Exceptions
- `InexactError`: if the internal value of `AbstractQuantityArray` cannot be
represented as type `Array{T}`.
"""
function QuantityArray{T}(::AbstractQuantityArray, ::InternalUnits) where {T<:Number} end
function QuantityArray{T}(::AbstractQuantityArray) where {T<:Number} end

function QuantityArray{T}(qArray::QuantityArray, internalUnits::InternalUnits) where {T<:Number}
    convFactor = conversionFactor(qArray.dimension, qArray.internalUnits, internalUnits)
    value = qArray.value * convFactor
    value = convert(Array{T}, value)
    return QuantityArray(value, qArray.dimension, internalUnits)
end

function QuantityArray{T}(qArray::QuantityArray) where {T<:Number}
    value = convert(Array{T}, qArray.value)
    return QuantityArray(value, qArray.dimension, qArray.internalUnits)
end

function QuantityArray{T}(sqArray::SimpleQuantityArray, internalUnits::InternalUnits) where {T<:Number}
    dimension = dimensionOf(sqArray)
    internalUnit = internalUnitFor(dimension, internalUnits)
    internalValue = valueInUnitsOf(sqArray, internalUnit)
    internalValue = convert(Array{T}, internalValue)
    return QuantityArray(internalValue, dimension, internalUnits)
end

QuantityArray{T}(sqArray::SimpleQuantityArray) where {T<:Number} = QuantityArray{T}(sqArray::SimpleQuantityArray, defaultInternalUnits)


"""
    QuantityArray{T}(::AbstractQuantity, ::InternalUnits) where {T<:Number}
    QuantityArray{T}(::AbstractQuantity) where {T<:Number}

Construct a `QuantityArray{T}` with specified type `T` from a physical quantity
of any implementation of `AbstractQuantity`.

See `QuantityArray(::AbstractQuantity, ::InternalUnits)` for details.

# Raises Exceptions
- `InexactError`: if the internal value of `AbstractQuantityArray` cannot be
represented as type `Array{T}`.
"""
function QuantityArray{T}(::AbstractQuantity, ::InternalUnits) where {T<:Number} end
function QuantityArray{T}(::AbstractQuantity) where {T<:Number} end

function QuantityArray{T}(quantity::Quantity, internalUnits::InternalUnits) where {T<:Number}
    convFactor = conversionFactor(quantity.dimension, quantity.internalUnits, internalUnits)
    value = Array([quantity.value * convFactor])
    value = convert(Array{T}, value)
    return QuantityArray(value, quantity.dimension, internalUnits)
end

function QuantityArray{T}(quantity::Quantity) where {T<:Number}
    value = Array([quantity.value])
    value = convert(Array{T}, value)
    return QuantityArray(value, quantity.dimension, quantity.internalUnits)
end

function QuantityArray{T}(simpleQuantity::SimpleQuantity, internalUnits::InternalUnits) where {T<:Number}
    dimension = dimensionOf(simpleQuantity)
    internalUnit = internalUnitFor(dimension, internalUnits)
    internalValue = valueInUnitsOf(simpleQuantity, internalUnit)
    internalValue = Array([internalValue])
    internalValue = convert(Array{T}, internalValue)
    return QuantityArray(internalValue, dimension, internalUnits)
end

QuantityArray{T}(simpleQuantity::SimpleQuantity) where {T<:Number} = QuantityArray{T}(simpleQuantity, defaultInternalUnits)

"""
    Base.convert(::Type{T}, qArray::QuantityArray) where {T<:QuantityArray}

Convert `qArray` from type `QuantityArray{S} where S` to any subtype `T` of
`QuantityArray`.

Allows to convert, for instance, from `QuantityArray{Float64}` to `QuantityVector{UInt8}`.
"""
Base.convert(::Type{T}, qArray::QuantityArray) where {T<:QuantityArray} = qArray isa T ? qArray : T(qArray)
