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
SimpleQuantity(quantity::Quantity) = quantity.value * internalUnitFor(quantity.dimension, quantity.internalUnits)

"""
    SimpleQuantity{T}(::AbstractQuantity) where {T<:Number}

Construct a `SimpleQuantity{T}` with specified type `T` from a physical quantity
of any implementation of `AbstractQuantity`.

See `SimpleQuantity(::AbstractQuantity)` for details.
"""
function SimpleQuantity{T}(::AbstractQuantity) where {T<:Number} end
SimpleQuantity{T}(simpleQuantity::SimpleQuantity) where {T<:Number} = SimpleQuantity(convert(T, simpleQuantity.value), simpleQuantity.unit)
SimpleQuantity{T}(quantity::Quantity) where {T<:Number} = SimpleQuantity{T}( SimpleQuantity(quantity) )

"""
    Base.convert(::Type{T}, simpleQuantity::SimpleQuantity) where {T<:SimpleQuantity}

Convert `simpleQuantity` from type `SimpleQuantity{S} where S` to type `SimpleQuantity{T}`.

Allows to convert, for instance, from `SimpleQuantity{Float64}` to `SimpleQuantity{UInt8}`.
"""
Base.convert(::Type{T}, simpleQuantity::SimpleQuantity) where {T<:SimpleQuantity} = simpleQuantity isa T ? simpleQuantity : T(simpleQuantity)


## Quantity

"""
    Quantity(::AbstractQuantity, ::InternalUnits)
    Quantity(::AbstractQuantity)
"""
function Quantity(::AbstractQuantity, ::InternalUnits) end
function Quantity(::AbstractQuantity) end

function Quantity(quantity::Quantity, internalUnits::InternalUnits) where T
    convFactor = conversionFactor(quantity.dimension, quantity.internalUnits, internalUnits)
    value = quantity.value * convFactor
    value = _attemptConversionToOriginalType(T, value)
    return Quantity(value, quantity.dimension, internalUnits)
end

Quantity(quantity::Quantity) = quantity

function Quantity(simpleQuantity::SimpleQuantity{T}, internalUnits::InternalUnits) where T
    dimension = dimensionOf(simpleQuantity)
    internalUnit = internalUnitFor(dimension, internalUnits)
    internalValue = valueInUnitsOf(simpleQuantity, internalUnit)
    internalValue = _attemptConversionToOriginalType(T, internalValue)
    return Quantity(internalValue, dimension, internalUnits)
end

function _attemptConversionToOriginalType(T::Type, value::Number)
    try
        value = convert(T, value)
    catch
    end
    return value
end

Quantity(simpleQuantity::SimpleQuantity) = Quantity(simpleQuantity, InternalUnits())

"""
    Quantity{T}(::AbstractQuantity, ::InternalUnits) where {T<:Number}
    Quantity{T}(::AbstractQuantity) where {T<:Number}

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

Quantity{T}(simpleQuantity::SimpleQuantity) where {T<:Number} = Quantity{T}(simpleQuantity::SimpleQuantity, InternalUnits())

"""
    Base.convert(::Type{T}, quantity::Quantity) where {T<:Quantity}

Convert `quantity` from type `Quantity{S} where S` to type `Quantity{T}`.

Allows to convert, for instance, from `Quantity{Float64}` to `Quantity{UInt8}`.
"""
Base.convert(::Type{T}, quantity::Quantity) where {T<:Quantity} = quantity isa T ? quantity : T(quantity)


## SimpleQuantityArray

"""
    SimpleQuantityArray(quantityArray::AbstractQuantityArray)

Construct a `SimpleQuantityArray` from a physical quantity of any implementation of `AbstractQuantityArray`.

If `quantityArray` is of type `SimpleQuantityArray`, it is returned unchanged.
If `quantityArray` is of type `QuantityArray`, it is expressed in terms of the SI units
specified by `quantity.InternalUnits`.
"""
function SimpleQuantityArray(quantityArray::AbstractQuantityArray) end
SimpleQuantityArray(sqArray::SimpleQuantityArray) = sqArray
SimpleQuantityArray(qArray::QuantityArray) = qArray.value * internalUnitFor(qArray.dimension, qArray.internalUnits)

"""
    SimpleQuantityArray(quantity::AbstractQuantity)

Construct a 1x1 `SimpleQuantityArray` from a physical quantity of any implementation of `AbstractQuantity`.

See `SimpleQuantityArray(::AbstractQuantityArray)` for details.
"""
function SimpleQuantityArray(quantity::AbstractQuantity) end
SimpleQuantityArray(simpleQuantity::SimpleQuantity) = SimpleQuantityArray([simpleQuantity.value], simpleQuantity.unit)
SimpleQuantityArray(quantity::Quantity) = [quantity.value] * internalUnitFor(quantity.dimension, quantity.internalUnits)

"""
    SimpleQuantityArray{T}(::AbstractQuantityArray) where {T<:Number}

Construct a `SimpleQuantityArray{T}` with specified type `T` from a physical quantity
of any implementation of `AbstractQuantityArray`.

See `SimpleQuantityArray(::AbstractQuantityArray)` for details.
"""
function SimpleQuantityArray{T}(quantityArray::AbstractQuantityArray) where {T<:Quantity} end
SimpleQuantityArray{T}(sqArray::SimpleQuantityArray) where {T<:Number} = SimpleQuantityArray( convert(Array{T}, sqArray.value), sqArray.unit)
SimpleQuantityArray{T}(qArray::QuantityArray) where {T<:Number} = SimpleQuantityArray{T}( SimpleQuantityArray(qArray) )

"""
    SimpleQuantityArray{T}(quantity::AbstractQuantity) where {T<:Number}

Construct a 1x1 `SimpleQuantityArray{T}` with specified type `T` from a physical quantity
of any implementation of `AbstractQuantity`.

See `SimpleQuantityArray(::AbstractQuantityArray)` for details.
"""
function SimpleQuantityArray{T}(quantity::AbstractQuantity) where {T<:Quantity} end
SimpleQuantityArray{T}(simpleQuantity::SimpleQuantity) where {T<:Number} = SimpleQuantityArray{T}([simpleQuantity.value], simpleQuantity.unit)
SimpleQuantityArray{T}(quantity::Quantity) where {T<:Number} = SimpleQuantityArray{T}( SimpleQuantityArray(quantity) )
