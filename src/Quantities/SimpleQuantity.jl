export SimpleQuantity
@doc raw"""
    SimpleQuantity{T} <: AbstractQuantity{T}

A physical quantity consisting of a value and a physical unit.

`SimpleQuantity` is a parametric type, where `T` is the type of the
quantity's value. The type `T` needs to be a subtype of `Number`.

# Fields
- `value::T`: value of the quantity
- `unit::Unit`: unit of the quantity

# Constructor
```
SimpleQuantity(value::T, abstractUnit::AbstractUnit) where T <: Number
SimpleQuantity(value::T) where T <: Number
```

If no `AbstractUnit` is passed to the constructor, the `Alicorn.unitlessUnit` is used by default.

# Examples
1. The quantity ``7\,\mathrm{nm}`` (seven nanometers) can be constructed using
   the constructor method as follows:
   ```jldoctest
   julia> ucat = UnitCatalogue() ;

   julia> nanometer = ucat.nano * ucat.meter
   UnitFactor nm

   julia> quantity = SimpleQuantity(7, nanometer)
   7 nm
   ```
2. Alternatively, ``7\,\mathrm{nm}`` can be constructed arithmetically:
   ```jldoctest
   julia> ucat = UnitCatalogue() ;

   julia> nanometer = ucat.nano * ucat.meter
   UnitFactor nm

   julia> quantity = 7 * nanometer
   7 nm
   ```
3. The value can be of any numerical type `T <: Number`. Any mathematical operation included in the
   interface of [`AbstractQuantity`](@ref) is applied to the value field, and
   the unit is modified accordingly.
   ```jldoctest
   julia> ucat = UnitCatalogue() ;

   julia> nanometer = ucat.nano * ucat.meter
   UnitFactor nm

   julia> quantity = 5 * nanometer
   5 nm

   julia> sqrt(quantity)
   2.23606797749979 nm^5e-1
   ```
"""
mutable struct SimpleQuantity{T} <: AbstractQuantity{T}
    value::T
    unit::Unit

    function SimpleQuantity(value::T, abstractUnit::AbstractUnit) where T <: Number
        unit::Unit = convertToUnit(abstractUnit)
        simpleQuantity = new{T}(value, unit)
        return simpleQuantity
    end
end

## External constructors

function SimpleQuantity(value::T) where T <: Number
    unit = unitlessUnit
    simpleQuantity = SimpleQuantity(value, unit)
    return simpleQuantity
end

## Methods implementing the interface of AbstractQuantity

"""
    Base.:(==)(simpleQuantity1::SimpleQuantity, simpleQuantity2::SimpleQuantity)

Compare two `SimpleQuantity` objects.

The two quantities are equal if both their values and their units are equal.
Note that the units are not converted during the comparison.

# Examples
```jldoctest
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

export inBasicSIUnits
# method documented as part of the AbstractQuantity interface
function inBasicSIUnits(simpleQuantity::SimpleQuantity)::SimpleQuantity
    originalValue = simpleQuantity.value
    originalUnit = simpleQuantity.unit

    ( conversionFactor, resultingBasicSIUnit ) = convertToBasicSI(originalUnit)

    resultingValue = originalValue * conversionFactor
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
function Base.:*(simpleQuantity::SimpleQuantity, object::Number)
    productValue = simpleQuantity.value * object
    productQuantity = SimpleQuantity(productValue, simpleQuantity.unit)
    return productQuantity
end

# method documented as part of the AbstractQuantity interface
function Base.:*(object::Number, simpleQuantity::SimpleQuantity)
    productValue = object * simpleQuantity.value
    productQuantity = SimpleQuantity(productValue, simpleQuantity.unit)
    return productQuantity
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
    quotientUnit = simpleQuantity1.unit / simpleQuantity2.unit
    quotientQuantity = SimpleQuantity(quotientValue, quotientUnit)
    return quotientQuantity
end

# method documented as part of the AbstractQuantity interface
function Base.:/(simpleQuantity::SimpleQuantity, object::Number)
    quotientValue = simpleQuantity.value / object
    quotientUnit = simpleQuantity.unit
    quotientQuantity = SimpleQuantity(quotientValue, quotientUnit)
    return quotientQuantity
end

# method documented as part of the AbstractQuantity interface
function Base.:/(object::Number, simpleQuantity::SimpleQuantity)
    quotientValue = object / simpleQuantity.value
    quotientUnit = inv(simpleQuantity.unit)
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
function Base.sqrt(simpleQuantity::SimpleQuantity)
    rootOfValue = sqrt(simpleQuantity.value)
    rootOfUnit = sqrt(simpleQuantity.unit)
    rootOfQuantity = SimpleQuantity(rootOfValue, rootOfUnit)
    return rootOfQuantity
end

# method documented as part of the AbstractQuantity interface
function Base.transpose(simpleQuantity::SimpleQuantity)
    transposeOfValue = transpose(simpleQuantity.value)
    unit = simpleQuantity.unit
    transposeOfQuantity = SimpleQuantity(transposeOfValue, unit)
    return transposeOfQuantity
end

# method documented as part of the AbstractQuantity interface
function Base.length(simpleQuantity::SimpleQuantity)
    return length(simpleQuantity.value)
end

# method documented as part of the AbstractQuantity interface
function Base.size(simpleQuantity::SimpleQuantity)
    return size(simpleQuantity.value)
end

# method documented as part of the AbstractQuantity interface
function Base.getindex(simpleQuantity::SimpleQuantity, index...)
    value = getindex(simpleQuantity.value, index...)
    unit = simpleQuantity.unit
    simpleQuantity = SimpleQuantity(value, unit)
    return simpleQuantity
end

# method documented as part of the AbstractQuantity interface
function Base.setindex!(simpleQuantity::SimpleQuantity{A}, element::SimpleQuantity, index...) where A <: AbstractArray
    element = _convertElementToTypeAndUnitOfArray(simpleQuantity, element)
    setindex!(simpleQuantity.value, element.value, index...)
    return simpleQuantity
end

function _convertElementToTypeAndUnitOfArray(simpleQuantity::SimpleQuantity{A}, element::SimpleQuantity) where A <: AbstractArray
    element.value = convert(typeof(simpleQuantity.value[1]), element.value)
    element = inUnitsOf(element, simpleQuantity.unit)
    return element
end

# method documented as part of the AbstractQuantity interface
function Base.repeat(simpleQuantity::SimpleQuantity{A}, counts::Vararg{Integer, N}) where {A <: AbstractArray, N}
    abstractArray = simpleQuantity.value
    repeatedAbstractArray = repeat(abstractArray, counts...)
    unit = simpleQuantity.unit
    repeatedSimpleQuantity = SimpleQuantity(repeatedAbstractArray, unit)
    return repeatedSimpleQuantity
end

# method documented as part of the AbstractQuantity interface
function Base.ndims(simpleQuantity::SimpleQuantity{T}) where T <: Number
    ndims = Base.ndims(simpleQuantity.value)
    return ndims
end

## Methods

export valueOfDimensionless
"""
    valueOfDimensionless(simpleQuantity::SimpleQuantity)

Strips the unit from a dimensionless quantity and returns its bare value.

# Raises Exceptions
- `Alicorn.Exceptions.DimensionMismatchError`: if `simpleQuantity` is not dimensionless
"""
function valueOfDimensionless(simpleQuantity::SimpleQuantity)
    try
        simpleQuantity = inUnitsOf(simpleQuantity, unitlessUnit)
    catch exception
        if typeof(exception) == Exceptions.DimensionMismatchError
            throw(Exceptions.DimensionMismatchError("quantity is not dimensionless"))
        else
            rethrow()
        end
    end
    value = simpleQuantity.value
    return value
end

function _assertIsUnitless(simpleQuantity)
    unit = simpleQuantity.unit
    if !(unit == unitlessUnit)
        throw(Exceptions.UnitMismatchError("quantity is not dimensionless"))
    end
end

"""
    Base.:*(value::Number, abstractUnit::AbstractUnit)::SimpleQuantity

Combine `value` and `abstractUnit` to form a physical quantity of type `SimpleQuantity`.

# Example
```jldoctest
julia> ucat = UnitCatalogue() ;

julia> 3.5 * ucat.tesla
3.5 T
```
"""
function Base.:*(value::Number, abstractUnit::AbstractUnit)::SimpleQuantity
    return SimpleQuantity(value, abstractUnit)
end

"""
    Base.:/(value::Number, abstractUnit::AbstractUnit)::SimpleQuantity

Combine `value` and `abstractUnit` to form a physical quantity of type `SimpleQuantity`.

# Example
```jldoctest
julia> ucat = UnitCatalogue() ;

julia> 3.5 / ucat.second
3.5 s^-1
```
"""
function Base.:/(value::Number, abstractUnit::AbstractUnit)::SimpleQuantity
    inverseAbstractUnit = inv(abstractUnit)
    return SimpleQuantity(value, inverseAbstractUnit)
end
