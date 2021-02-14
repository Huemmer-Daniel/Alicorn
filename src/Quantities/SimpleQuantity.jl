export SimpleQuantity
@doc raw"""
    SimpleQuantity{T}

TODO
"""
mutable struct SimpleQuantity{T} <: AbstractQuantity
    value::T
    unit::Unit

    function SimpleQuantity(value::T, abstractUnit::AbstractUnit) where T
        unit::Unit = convertToUnit(abstractUnit)
        simpleQuantity = new{typeof(value)}(value, unit)
        return simpleQuantity
    end
end

## Methods implementing the interface of AbstractQuantity

"""
    Base.:(==)(simpleQuantity1::SimpleQuantity, simpleQuantity2::SimpleQuantity)

Compare two `SimpleQuantity` objects.

The two quantities are equal if both their values and their units are equal.
Note that the units are not converted during the comparison.

# Examples
```@jldoctest
julia> ucat = UnitCatalogue() ;

julia> q1 = 7 * ucat.meter
7 m
julia> q2 = 700 * (ucat.centi * ucat.meter)
700 cm
julia> q1 == q1
true
julia> q1 == q2
false
```
"""
function Base.:(==)(simpleQuantity1::SimpleQuantity, simpleQuantity2::SimpleQuantity)
    valuesEqual = ( simpleQuantity1.value == simpleQuantity2.value )
    unitsEqual = ( simpleQuantity1.unit == simpleQuantity2.unit )
    return valuesEqual && unitsEqual
end

export inUnitsOf
# method documented as part of the AbstractQuantity interface
function inUnitsOf(simpleQuantity::SimpleQuantity, targetUnit::AbstractUnit)::SimpleQuantity
    originalValue = simpleQuantity.value
    originalUnit = simpleQuantity.unit

    (originalUnitPrefactor, originalBaseUnitExponents) = convertToBasicSIAsExponents(originalUnit)
    (targetUnitPrefactor, targetBaseUnitExponents) = convertToBasicSIAsExponents(targetUnit)

    _assertDimensionsMatch(originalBaseUnitExponents, targetBaseUnitExponents)
    conversionFactor = originalUnitPrefactor / targetUnitPrefactor

    resultingValue = originalValue .* conversionFactor
    resultingQuantity = SimpleQuantity( resultingValue, targetUnit )
    return resultingQuantity
end

function _assertDimensionsMatch(baseUnitExponents1::BaseUnitExponents, baseUnitExponents2::BaseUnitExponents)
    if baseUnitExponents1 != baseUnitExponents2
        throw( Exceptions.DimensionMismatchError("dimensions of the quantity and the desired unit do not agree") )
    end
end

export inBasicSIUnits
# method documented as part of the AbstractQuantity interface
function inBasicSIUnits(simpleQuantity::SimpleQuantity)::SimpleQuantity
    originalValue = simpleQuantity.value
    originalUnit = simpleQuantity.unit

    ( conversionFactor, resultingBasicSIUnit ) = convertToBasicSI(originalUnit)

    resultingValue = originalValue .* conversionFactor
    resultingQuantity = SimpleQuantity( resultingValue, resultingBasicSIUnit )
    return resultingQuantity
end

# method documented as part of the AbstractQuantity interface
function Base.:*(simpleQuantity::SimpleQuantity, abstractUnit::AbstractUnit)::SimpleQuantity
    value = simpleQuantity.value
    unit = simpleQuantity.unit

    unitProduct = unit * abstractUnit

    return SimpleQuantity(value, unitProduct)
end

# method documented as part of the AbstractQuantity interface
function Base.:/(simpleQuantity::SimpleQuantity, abstractUnit::AbstractUnit)::SimpleQuantity
    value = simpleQuantity.value
    unit = simpleQuantity.unit

    unitQuotient = unit / abstractUnit

    return SimpleQuantity(value, unitQuotient)
end

# method documented as part of the AbstractQuantity interface
function Base.:+(simpleQuantity1::SimpleQuantity, simpleQuantity2::SimpleQuantity)
    targetUnit = simpleQuantity1.unit
    simpleQuantity2 = _addition_ConvertQuantityToTargetUnit(simpleQuantity2, targetUnit)
    sumValue = simpleQuantity1.value + simpleQuantity2.value
    sumQuantity = SimpleQuantity( sumValue, targetUnit )
    return sumQuantity
end

function _addition_ConvertQuantityToTargetUnit(simpleQuantity::SimpleQuantity, targetUnit::AbstractUnit)
    try
        simpleQuantity = inUnitsOf(simpleQuantity, targetUnit)
    catch exception
        _handleExceptionInAddition(exception)
    end
    return simpleQuantity
end

function _handleExceptionInAddition(exception::Exception)
    if isa(exception, Exceptions.DimensionMismatchError)
        newException = Exceptions.DimensionMismatchError("summands are not of the same physical dimension")
        throw(newException)
    else
        rethrow()
    end
end

# method documented as part of the AbstractQuantity interface
function Base.:-(simpleQuantity1::SimpleQuantity, simpleQuantity2::SimpleQuantity)
    targetUnit = simpleQuantity1.unit
    simpleQuantity2 = _addition_ConvertQuantityToTargetUnit(simpleQuantity2, targetUnit)
    differenceValue = simpleQuantity1.value - simpleQuantity2.value
    differenceQuantity = SimpleQuantity( differenceValue, targetUnit )
    return differenceQuantity
end

# method documented as part of the AbstractQuantity interface
function Base.:*(simpleQuantity1::SimpleQuantity, simpleQuantity2::SimpleQuantity)
    productValue = simpleQuantity1.value * simpleQuantity2.value
    productUnit = simpleQuantity1.unit * simpleQuantity2.unit
    productQuantity = SimpleQuantity(productValue, productUnit)
    return productQuantity
end

# method documented as part of the AbstractQuantity interface
function Base.:/(simpleQuantity1::SimpleQuantity, simpleQuantity2::SimpleQuantity)
    quotientValue = simpleQuantity1.value / simpleQuantity2.value
    quotientUnit = Unit = simpleQuantity1.unit / simpleQuantity2.unit
    quotientQuantity = SimpleQuantity(quotientValue, quotientUnit)
    return quotientQuantity
end

# method documented as part of the AbstractQuantity interface
function Base.inv(simpleQuantity::SimpleQuantity)
    inverseValue = inv(simpleQuantity.value)
    inverseUnit = inv(simpleQuantity.unit)
    inverseQuantity = SimpleQuantity(inverseValue, inverseUnit)
    return inverseQuantity
end

# method documented as part of the AbstractQuantity interface
function Base.:^(simpleQuantity::SimpleQuantity, exponent::Real)
    exponentiatedValue = (simpleQuantity.value)^exponent
    exponentiatedUnit = (simpleQuantity.unit)^exponent
    exponentiatedQuantity = SimpleQuantity(exponentiatedValue, exponentiatedUnit)
    return exponentiatedQuantity
end

# method documented as part of the AbstractQuantity interface
function Base.:sqrt(simpleQuantity::SimpleQuantity)
    rootOfValue = sqrt(simpleQuantity.value)
    rootOfUnit = sqrt(simpleQuantity.unit)
    rootOfQuantity = SimpleQuantity(rootOfValue, rootOfUnit)
    return rootOfQuantity
end

## Methods

"""
    Base.:*(value::Any, abstractUnit::AbstractUnit)::SimpleQuantity

Combine `value` and `abstractUnit` to form a physical quantity of type `SimpleQuantity`.

# Example
```@jldoctest
julia> ucat = UnitCatalogue() ;

julia> 3.5 * ucat.tesla
3.5 T
```
"""
function Base.:*(value::Any, abstractUnit::AbstractUnit)::SimpleQuantity
    return SimpleQuantity(value, abstractUnit)
end

"""
    Base.:/(value::Any, abstractUnit::AbstractUnit)::SimpleQuantity

Combine `value` and `abstractUnit` to form a physical quantity of type `SimpleQuantity`.

# Example
```@jldoctest
julia> ucat = UnitCatalogue() ;

julia> 3.5 / ucat.second
3.5 s^-1
```
"""
function Base.:/(value::Any, abstractUnit::AbstractUnit)::SimpleQuantity
    inverseAbstractUnit = inv(abstractUnit)
    return SimpleQuantity(value, inverseAbstractUnit)
end
