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
