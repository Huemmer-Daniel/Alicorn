## inUnitsOf
"""
    inUnitsOf(quantity::AbstractQuantity, unit::AbstractUnit)::SimpleQuantity

Express `quantity` as an object of type `SimpleQuantity` in terms of the unit specified by `unit`.

# Raises Exceptions
- `Alicorn.Exceptions.DimensionMismatchError`: if the dimensions of `quantity` and `unit` do not agree
"""
function inUnitsOf(quantity::AbstractQuantity, unit::AbstractUnit)::SimpleQuantity end

function inUnitsOf(simpleQuantity::SimpleQuantity, targetUnit::AbstractUnit)
    originalValue = simpleQuantity.value
    originalUnit = simpleQuantity.unit

    if originalUnit == targetUnit
        resultingQuantity = simpleQuantity
    else

        (originalUnitPrefactor, originalBaseUnitExponents) = convertToBasicSIAsExponents(originalUnit)
        (targetUnitPrefactor, targetBaseUnitExponents) = convertToBasicSIAsExponents(targetUnit)

        _assertDimensionsMatch(originalBaseUnitExponents, targetBaseUnitExponents)
        conversionFactor = originalUnitPrefactor / targetUnitPrefactor

        resultingValue = originalValue * conversionFactor
        resultingQuantity = SimpleQuantity( resultingValue, targetUnit )
    end
    return resultingQuantity
end

function _assertDimensionsMatch(baseUnitExponents1::BaseUnitExponents, baseUnitExponents2::BaseUnitExponents)
    if baseUnitExponents1 != baseUnitExponents2
        throw( Exceptions.DimensionMismatchError("dimensions of the quantity and the desired unit do not agree") )
    end
end

"""
    inUnitsOf(qArray::AbstractQuantityArray, unit::AbstractUnit)::SimpleQuantityArray

Express `qArray` as an object of type `SimpleQuantityArray` in terms of the unit specified by `unit`.

# Raises Exceptions
- `Alicorn.Exceptions.DimensionMismatchError`: if the dimensions of `qArray` and `unit` do not agree
"""
function inUnitsOf(qArray::AbstractQuantityArray, unit::AbstractUnit)::SimpleQuantityArray end

function inUnitsOf(sqArray::SimpleQuantityArray, targetUnit::AbstractUnit)
    originalvalue = sqArray.value
    originalUnit = sqArray.unit

    if originalUnit == targetUnit
        resultingQuantityArray = sqArray
    else

        (originalUnitPrefactor, originalBaseUnitExponents) = convertToBasicSIAsExponents(originalUnit)
        (targetUnitPrefactor, targetBaseUnitExponents) = convertToBasicSIAsExponents(targetUnit)

        _assertDimensionsMatch(originalBaseUnitExponents, targetBaseUnitExponents)
        conversionFactor = originalUnitPrefactor / targetUnitPrefactor

        resultingvalue = originalvalue .* conversionFactor
        resultingQuantityArray = SimpleQuantityArray( resultingvalue, targetUnit )
    end
    return resultingQuantityArray
end


## valueInUnitsOf
"""
    valueInUnitsOf(quantity::AbstractQuantity, unit::AbstractUnit)

Returns the numerical value of `quantity` expressed in units of `unit`.

# Raises Exceptions
- `Alicorn.Exceptions.DimensionMismatchError`: if the dimensions of `quantity` and `unit` do not agree
"""
function valueInUnitsOf(quantity::AbstractQuantity, unit::AbstractUnit) end

valueInUnitsOf(simpleQuantity::SimpleQuantity, unit::AbstractUnit) = inUnitsOf(simpleQuantity, unit).value

"""
    valueInUnitsOf(quantity::AbstractQuantity, simpleQuantity::SimpleQuantity)

Returns the numerical value of `quantity` expressed in units of `simpleQuantity`.

The result is equivalent to `valueOfDimensionless(quantity / simpleQuantity)`.

# Raises Exceptions
- `Alicorn.Exceptions.DimensionMismatchError`: if the dimensions of `quantity` and `simpleQuantity` do not agree
"""
valueInUnitsOf(quantity::AbstractQuantity, simpleQuantity::SimpleQuantity) = valueOfDimensionless(quantity / simpleQuantity)

"""
    valueInUnitsOf(qArray::AbstractQuantityArray, unit::AbstractUnit)

Returns the numerical value of `qArray` expressed in units of `unit`.

# Raises Exceptions
- `Alicorn.Exceptions.DimensionMismatchError`: if the dimensions of `quantity` and `unit` do not agree
"""
function valueInUnitsOf(qArray::AbstractQuantityArray, unit::AbstractUnit) end

valueInUnitsOf(sqArray::SimpleQuantityArray, unit::AbstractUnit) = inUnitsOf(sqArray, unit).value

"""
    valueInUnitsOf(quantityArray::AbstractQuantityArray, simpleQuantity::SimpleQuantity)

Returns the numerical value of `quantityArray` expressed in units of `simpleQuantity`.

The result is equivalent to `valueOfDimensionless(quantityArray / simpleQuantity)`.

# Raises Exceptions
- `Alicorn.Exceptions.DimensionMismatchError`: if the dimensions of `quantityArray` and `simpleQuantity` do not agree
"""
valueInUnitsOf(quantityArray::AbstractQuantityArray, simpleQuantity::SimpleQuantity) = valueOfDimensionless(quantityArray / simpleQuantity)

## inBasicSIUnits
"""
    inBasicSIUnits(quantity::AbstractQuantity)::SimpleQuantity

Express `quantity` as an object of type `SimpleQuantity` using the seven basic SI units.
"""
function inBasicSIUnits(quantity::AbstractQuantity)::SimpleQuantity end

function inBasicSIUnits(simpleQuantity::SimpleQuantity)
    originalValue = simpleQuantity.value
    originalUnit = simpleQuantity.unit

    ( conversionFactor, resultingBasicSIUnit ) = convertToBasicSI(originalUnit)

    resultingValue = originalValue * conversionFactor
    resultingQuantity = SimpleQuantity( resultingValue, resultingBasicSIUnit )
    return resultingQuantity
end

"""
    inBasicSIUnits(qArray::AbstractQuantity)::SimpleQuantityArray

Express `qArray` as an object of type `SimpleQuantityArray` using the seven basic SI units.
"""
function inBasicSIUnits(qArray::AbstractQuantityArray)::SimpleQuantityArray end

function inBasicSIUnits(sqArray::SimpleQuantityArray)
    originalvalue = sqArray.value
    originalUnit = sqArray.unit

    ( conversionFactor, resultingBasicSIUnit ) = convertToBasicSI(originalUnit)

    resultingvalue = originalvalue * conversionFactor
    resultingQuantity = SimpleQuantityArray( resultingvalue, resultingBasicSIUnit )
    return resultingQuantity
end


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

function _convertToUnitless(quantity)
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

valueOfDimensionless(number::Number) = number

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

valueOfDimensionless(array::Array{<:Number}) = array


## Quantity-Unit arithmetics

"""
    Base.:*(quantity::AbstractQuantity, unit::AbstractUnit)
    Base.:*(unit::AbstractUnit, quantity::AbstractQuantity)

Modify the unit of `quantity` by multiplying it with `unit`.
"""
function Base.:*(quantity::AbstractQuantity, unit::AbstractUnit) end
function Base.:*(unit::AbstractUnit, quantity::AbstractQuantity) end

"""
    Base.:*(qArray::AbstractQuantityArray, unit::AbstractUnit)
    Base.:*(unit::AbstractUnit, qArray::AbstractQuantityArray)

Modify the unit of `qArray` by multiplying it with `unit`.
"""
function Base.:*(qArray::AbstractQuantityArray, unit::AbstractUnit) end
function Base.:*(unit::AbstractUnit, qArray::AbstractQuantityArray) end

function Base.:*(simpleQuantity::Union{SimpleQuantity, SimpleQuantityArray}, abstractUnit::AbstractUnit)
    value = simpleQuantity.value
    productUnit = simpleQuantity.unit * abstractUnit
    return value * productUnit
end

function Base.:*(abstractUnit::AbstractUnit, simpleQuantity::Union{SimpleQuantity, SimpleQuantityArray})
    value = simpleQuantity.value
    productUnit = abstractUnit * simpleQuantity.unit
    return value * productUnit
end

"""
    Base.:/(quantity::AbstractQuantity, unit::AbstractUnit)
    Base.:/(unit::AbstractUnit, quantity::AbstractQuantity)

Modify the unit of `quantity` by dividing it by `unit`, or vice versa.
"""
function Base.:/(quantity::AbstractQuantity, unit::AbstractUnit) end
function Base.:/(unit::AbstractUnit, quantity::AbstractQuantity) end

"""
    Base.:/(qArray::AbstractQuantityArray, unit::AbstractUnit)
    Base.:/(unit::AbstractUnit, qArray::AbstractQuantityArray)

Modify the unit of `qArray` by dividing it by `unit`, or vice versa.
"""
function Base.:/(qArray::AbstractQuantityArray, unit::AbstractUnit) end
function Base.:/(unit::AbstractUnit, qArray::AbstractQuantityArray) end

function Base.:/(simpleQuantity::Union{SimpleQuantity, SimpleQuantityArray}, abstractUnit::AbstractUnit)
    value = simpleQuantity.value
    unitQuotient = simpleQuantity.unit / abstractUnit
    return value * unitQuotient
end

function Base.:/(abstractUnit::AbstractUnit, simpleQuantity::Union{SimpleQuantity, SimpleQuantityArray})
    value = inv(simpleQuantity.value)
    unitQuotient = abstractUnit / simpleQuantity.unit
    return value * unitQuotient
end
