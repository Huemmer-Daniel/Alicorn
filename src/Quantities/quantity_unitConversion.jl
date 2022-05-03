## inUnitsOf
"""
    inUnitsOf(quantity::AbstractQuantity, unit::AbstractUnit)::SimpleQuantity

Express `quantity` as an object of type `SimpleQuantity` in terms of the unit specified by `unit`.

# Raises Exceptions
- `Alicorn.Exceptions.DimensionMismatchError`: if the dimensions of `quantity` and `unit` do not agree
"""
function inUnitsOf(quantity::AbstractQuantity, unit::AbstractUnit)::SimpleQuantity end

inUnitsOf(simpleQuantity::SimpleQuantity, targetUnit::AbstractUnit) = (simpleQuantity.unit == targetUnit) ? simpleQuantity : _inUnitsOf(simpleQuantity, targetUnit)

function _inUnitsOf(simpleQuantity::SimpleQuantity{T}, targetUnit::AbstractUnit) where T
    targetUnit = Unit(targetUnit)

    originalValue = simpleQuantity.value
    originalUnit = simpleQuantity.unit

    (originalUnitPrefactor, originalBaseUnitExponents) = convertToBasicSIAsExponents(originalUnit)
    (targetUnitPrefactor, targetBaseUnitExponents) = convertToBasicSIAsExponents(targetUnit)

    _assertDimensionsMatch(originalBaseUnitExponents, targetBaseUnitExponents)
    conversionFactor = originalUnitPrefactor / targetUnitPrefactor

    resultingValue = originalValue * conversionFactor
    resultingValue = _attemptConversionToType(T, resultingValue)

    resultingSimpleQuantity = SimpleQuantity( resultingValue, targetUnit )
end

function _assertDimensionsMatch(baseUnitExponents1::BaseUnitExponents, baseUnitExponents2::BaseUnitExponents)
    if baseUnitExponents1 != baseUnitExponents2
        throw( Exceptions.DimensionMismatchError("dimensions of the quantity and the desired unit do not agree") )
    end
end

function inUnitsOf(quantity::Quantity{T}, targetUnit::AbstractUnit) where T
    quantityInternalUnit = internalUnitFor(quantity.dimension, quantity.internalUnits)
    quantityAsSimpleQuantity = quantity.value * quantityInternalUnit

    resultingValue = _attemptConversionToType(T, quantityAsSimpleQuantity.value)
    resultingUnit = quantityAsSimpleQuantity.unit

    resultingSimpleQuantity = inUnitsOf(resultingValue * resultingUnit, targetUnit)
    return resultingSimpleQuantity
end

"""
    inUnitsOf(qArray::AbstractQuantityArray, unit::AbstractUnit)::SimpleQuantityArray

Express `qArray` as an object of type `SimpleQuantityArray` in terms of the unit specified by `unit`.

# Raises Exceptions
- `Alicorn.Exceptions.DimensionMismatchError`: if the dimensions of `qArray` and `unit` do not agree
"""
function inUnitsOf(qArray::AbstractQuantityArray, unit::AbstractUnit)::SimpleQuantityArray end

function inUnitsOf(sqArray::SimpleQuantityArray{T}, targetUnit::AbstractUnit) where T
    originalValue = sqArray.value
    originalUnit = sqArray.unit

    if originalUnit == targetUnit
        resultingSimpleQuantityArray = sqArray
    else

        (originalUnitPrefactor, originalBaseUnitExponents) = convertToBasicSIAsExponents(originalUnit)
        (targetUnitPrefactor, targetBaseUnitExponents) = convertToBasicSIAsExponents(targetUnit)

        _assertDimensionsMatch(originalBaseUnitExponents, targetBaseUnitExponents)
        conversionFactor = originalUnitPrefactor / targetUnitPrefactor

        resultingValue = originalValue .* conversionFactor
        resultingValue = _attemptConversionToType(Array{T}, resultingValue)

        resultingSimpleQuantityArray = SimpleQuantityArray( resultingValue, targetUnit )
    end
    return resultingSimpleQuantityArray
end

function inUnitsOf(qArray::QuantityArray{T}, targetUnit::AbstractUnit) where T
    internalUnit = internalUnitFor(qArray.dimension, qArray.internalUnits)
    sqArray = qArray.value * internalUnit

    resultingValue = _attemptConversionToType(Array{T}, sqArray.value)
    resultingUnit = sqArray.unit

    resultingSqQuantity = inUnitsOf(resultingValue * resultingUnit, targetUnit)
    return resultingSqQuantity
end


## valueInUnitsOf
"""
    valueInUnitsOf(quantity::AbstractQuantity, unit::AbstractUnit)

Returns the numerical value of `quantity` expressed in units of `unit`.

# Raises Exceptions
- `Alicorn.Exceptions.DimensionMismatchError`: if the dimensions of `quantity` and `unit` do not agree
"""
valueInUnitsOf(quantity::AbstractQuantity, unit::AbstractUnit) = inUnitsOf(quantity, unit).value

"""
    valueInUnitsOf(quantity::AbstractQuantity, simpleQuantity::SimpleQuantity)

Returns the numerical value of `quantity` expressed in units of `simpleQuantity`.

The result is equivalent to `valueOfDimensionless(quantity / simpleQuantity)`.

# Raises Exceptions
- `Alicorn.Exceptions.DimensionMismatchError`: if the dimensions of `quantity` and `simpleQuantity` do not agree
"""
function valueInUnitsOf(quantity::AbstractQuantity{T}, simpleQuantity::SimpleQuantity) where T
    resultingValue = valueInUnitsOf(quantity, simpleQuantity.unit) / simpleQuantity.value
    resultingValue = _attemptConversionToType(T, resultingValue)
    return resultingValue
end

"""
    valueInUnitsOf(qArray::AbstractQuantityArray, unit::AbstractUnit)

Returns the numerical value of `qArray` expressed in units of `unit`.

# Raises Exceptions
- `Alicorn.Exceptions.DimensionMismatchError`: if the dimensions of `quantity` and `unit` do not agree
"""
valueInUnitsOf(qArray::AbstractQuantityArray, unit::AbstractUnit) = inUnitsOf(qArray, unit).value

"""
    valueInUnitsOf(quantityArray::AbstractQuantityArray, simpleQuantity::SimpleQuantity)

Returns the numerical value of `quantityArray` expressed in units of `simpleQuantity`.

The result is equivalent to `valueOfDimensionless(quantityArray / simpleQuantity)`.

# Raises Exceptions
- `Alicorn.Exceptions.DimensionMismatchError`: if the dimensions of `quantityArray` and `simpleQuantity` do not agree
"""
function valueInUnitsOf(qArray::AbstractQuantityArray{T}, simpleQuantity::SimpleQuantity) where T
    resultingValue = valueInUnitsOf(qArray, simpleQuantity.unit) / simpleQuantity.value
    resultingValue = _attemptConversionToType(Array{T}, resultingValue)
    return resultingValue
end

## inInternalUnitsOf

"""
    inInternalUnitsOf(quantity::Quantity{T}, targetIntU::InternalUnits) where T

Returns a new `Quantity{S}` corresponding to `quantity`, but stored using
`targetIntU` as new internal units.

The value type `S` of the returned quantity is identical to `T`, if possible.
"""
inInternalUnitsOf(quantity::Quantity, targetIntU::InternalUnits) = Quantity(quantity, targetIntU)


"""
    inInternalUnitsOf(qArray::QuantityArray{T}, targetIntU::InternalUnits) where T

Returns a new `QuantityArray` corresponding to `qArray`, but stored using
`targetIntU` as new internal units.

The value type `S` of the returned quantity array is identical to `T`, if
possible.
"""
inInternalUnitsOf(qArray::QuantityArray, targetIntU::InternalUnits) = QuantityArray(qArray, targetIntU)


## inBasicSIUnits
"""
    inBasicSIUnits(quantity::AbstractQuantity)::SimpleQuantity

Express `quantity` as an object of type `SimpleQuantity` using the seven basic SI units.
"""
function inBasicSIUnits(quantity::AbstractQuantity)::SimpleQuantity end

function inBasicSIUnits(simpleQuantity::SimpleQuantity{T}) where T
    originalValue = simpleQuantity.value
    originalUnit = simpleQuantity.unit

    ( conversionFactor, resultingBasicSIUnit ) = convertToBasicSI(originalUnit)

    resultingValue = originalValue * conversionFactor
    resultingValue = _attemptConversionToType(T, resultingValue)
    resultingQuantity = SimpleQuantity( resultingValue, resultingBasicSIUnit )
    return resultingQuantity
end

inBasicSIUnits(quantity::Quantity) = inBasicSIUnits( SimpleQuantity(quantity) )

"""
    inBasicSIUnits(qArray::AbstractQuantity)::SimpleQuantityArray

Express `qArray` as an object of type `SimpleQuantityArray` using the seven basic SI units.
"""
function inBasicSIUnits(qArray::AbstractQuantityArray)::SimpleQuantityArray end

function inBasicSIUnits(sqArray::SimpleQuantityArray{T}) where T
    originalvalue = sqArray.value
    originalUnit = sqArray.unit

    ( conversionFactor, resultingBasicSIUnit ) = convertToBasicSI(originalUnit)

    resultingValue = originalvalue * conversionFactor
    resultingValue = _attemptConversionToType(Array{T}, resultingValue)
    resultingQuantity = SimpleQuantityArray( resultingValue, resultingBasicSIUnit )
    return resultingQuantity
end

inBasicSIUnits(qArray::QuantityArray) = inBasicSIUnits( SimpleQuantityArray(qArray) )


## valueOfDimensionless
"""
    valueOfDimensionless(quantity::AbstractQuantity)

Strips the unit from a dimensionless quantity and returns its bare value.

# Raises Exceptions
- `Alicorn.Exceptions.DimensionMismatchError`: if `quantity` is not dimensionless
"""
function valueOfDimensionless(quantity::AbstractQuantity) end

function valueOfDimensionless(simpleQuantity::SimpleQuantity)
    simpleQuantity =_convertToUnitless(simpleQuantity)
    value = simpleQuantity.value
    return value
end

function _convertToUnitless(quantity::Union{AbstractQuantity, AbstractQuantityArray})
    try
        quantity = inUnitsOf(quantity, unitlessUnit)
    catch exception
        if typeof(exception) == Exceptions.DimensionMismatchError
            throw(Exceptions.DimensionMismatchError("quantity is not dimensionless"))
        else
            rethrow()
        end
    end
    return quantity
end

function valueOfDimensionless(quantity::Quantity)
    _verifyIsDimensionless(quantity)
    return quantity.value
end

function _verifyIsDimensionless(quantity::Union{Quantity, QuantityArray})
    if quantity.dimension != dimensionless
        throw(Exceptions.DimensionMismatchError("quantity is not dimensionless"))
    end
end

"""
    valueOfDimensionless(qArray::AbstractQuantityArray)

Strips the unit from a dimensionless quantity array and returns its bare value.

# Raises Exceptions
- `Alicorn.Exceptions.DimensionMismatchError`: if `qArray` is not dimensionless
"""
function valueOfDimensionless(qArray::AbstractQuantityArray) end

function valueOfDimensionless(sqArray::SimpleQuantityArray)
    sqArray = _convertToUnitless(sqArray)
    value = sqArray.value
    return value
end

function valueOfDimensionless(qArray::QuantityArray)
    _verifyIsDimensionless(qArray)
    return qArray.value
end
