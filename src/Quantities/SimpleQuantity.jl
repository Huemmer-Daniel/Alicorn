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
SimpleQuantity(abstractUnit::AbstractUnit)
```

If no `AbstractUnit` is passed to the constructor, the `Alicorn.unitlessUnit` is used by default. If no value is passed to the constructor, the value is set to 1 by default.

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

   julia> quantity = 7 nanometer
   7 nm
   ```
3. The value can be of any numerical type `T <: Number`. Any mathematical operation included in the
   interface of [`AbstractQuantity`](@ref) is applied to the value field, and
   the unit is modified accordingly.
   ```jldoctest
   julia> ucat = UnitCatalogue() ;

   julia> nanometer = ucat.nano * ucat.meter
   UnitFactor nm

   julia> quantity = 5 nanometer
   5 nm

   julia> sqrt(quantity)
   2.23606797749979 nm^5e-1
   ```
"""
mutable struct SimpleQuantity{T} <: AbstractQuantity{T}
    value::T
    unit::Unit

    function SimpleQuantity(value::T, abstractUnit::AbstractUnit) where T <: Number
        unit = convertToUnit(abstractUnit)
        simpleQuantity = new{T}(value, unit)
        return simpleQuantity
    end
end

## ## External constructors

function SimpleQuantity(value::T) where T <: Number
    unit = unitlessUnit
    simpleQuantity = SimpleQuantity(value, unit)
    return simpleQuantity
end

function SimpleQuantity(abstractUnit::AbstractUnit)
    value = 1
    unit = convertToUnit(abstractUnit)
    simpleQuantity = SimpleQuantity(value, unit)
    return simpleQuantity
end

## ## Methods for creating a SimpleQuantity

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

## ## Methods implementing the interface of AbstractQuantity

## 1. Unit conversion

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

export inUnitsOf
"""
    inUnitsOf(simpleQuantity1::SimpleQuantity, simpleQuantity2::SimpleQuantity)

Express `simpleQuantity1` in units of `simpleQuantity2`.
"""
function inUnitsOf(simpleQuantity1::SimpleQuantity, simpleQuantity2::SimpleQuantity)
    targetUnit = simpleQuantity2.unit
    return inUnitsOf(simpleQuantity1, targetUnit)
end

export inBasicSIUnits
# method documented as part of the AbstractQuantity interface
function inBasicSIUnits(simpleQuantity::SimpleQuantity)
    originalValue = simpleQuantity.value
    originalUnit = simpleQuantity.unit

    ( conversionFactor, resultingBasicSIUnit ) = convertToBasicSI(originalUnit)

    resultingValue = originalValue * conversionFactor
    resultingQuantity = SimpleQuantity( resultingValue, resultingBasicSIUnit )
    return resultingQuantity
end

# method documented as part of the AbstractQuantity interface
function Base.:*(simpleQuantity::SimpleQuantity, abstractUnit::AbstractUnit)
    value = simpleQuantity.value
    unit = simpleQuantity.unit

    unitProduct = unit * abstractUnit

    return SimpleQuantity(value, unitProduct)
end

# method documented as part of the AbstractQuantity interface
function Base.:*(abstractUnit::AbstractUnit, simpleQuantity::SimpleQuantity)
    value = simpleQuantity.value
    unit = simpleQuantity.unit

    unitProduct = abstractUnit * unit

    return SimpleQuantity(value, unitProduct)
end

# method documented as part of the AbstractQuantity interface
function Base.:/(simpleQuantity::SimpleQuantity, abstractUnit::AbstractUnit)
    value = simpleQuantity.value
    unit = simpleQuantity.unit

    unitQuotient = unit / abstractUnit

    return SimpleQuantity(value, unitQuotient)
end

# method documented as part of the AbstractQuantity interface
function Base.:/(abstractUnit::AbstractUnit, simpleQuantity::SimpleQuantity)
    value = simpleQuantity.value
    unit = simpleQuantity.unit

    unitQuotient = abstractUnit / unit

    return SimpleQuantity(1/value, unitQuotient)
end

## 2. Arithmetic unary and binary operators

# method documented as part of the AbstractQuantity interface
function Base.:+(simpleQuantity::SimpleQuantity)
    return simpleQuantity
end

# method documented as part of the AbstractQuantity interface
function Base.:-(simpleQuantity::SimpleQuantity)
    value = -simpleQuantity.value
    unit = simpleQuantity.unit
    return SimpleQuantity( value, unit )
end

"""
    Base.:+(simpleQuantity1::SimpleQuantity, simpleQuantity2::SimpleQuantity)

Add two SimpleQuantities.

The resulting quantity is expressed in units of `simpleQuantity1`.

# Raises Exceptions
- `Alicorn.Exceptions.DimensionMismatchError`: if `simpleQuantity1` and `simpleQuantity2` are of different dimensions
"""
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

"""
    Base.:-(simpleQuantity1::SimpleQuantity, simpleQuantity2::SimpleQuantity)

Subtract two SimpleQuantities.

The resulting quantity is expressed in units of `simpleQuantity1`.

# Raises Exceptions
- `Alicorn.Exceptions.DimensionMismatchError`: if `simpleQuantity1` and `simpleQuantity2` are of different dimensions
"""
function Base.:-(simpleQuantity1::SimpleQuantity, simpleQuantity2::SimpleQuantity)
    return simpleQuantity1 + (-simpleQuantity2)
end

## TODO below

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

## 3. Updating binary operators

## 4. Numeric comparison

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

## 5. Rounding

## 6. Sign and absolute value

## 7. Roots

# method documented as part of the AbstractQuantity interface
function Base.sqrt(simpleQuantity::SimpleQuantity)
    rootOfValue = sqrt(simpleQuantity.value)
    rootOfUnit = sqrt(simpleQuantity.unit)
    rootOfQuantity = SimpleQuantity(rootOfValue, rootOfUnit)
    return rootOfQuantity
end


## 8. Literal zero

## 9. Complex numbers

## 10. Compatibility with array functions

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

## ## Additional Methods

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
