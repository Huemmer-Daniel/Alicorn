export SimpleQuantity
@doc raw"""
    SimpleQuantity{T} <: AbstractQuantity{T}

A physical quantity consisting of a value and a physical unit.

`SimpleQuantity` is a parametric type, where `T` is the type of the
quantity's value. While the value can be of any type, `SimpleQuantity`
implements the `AbstractQuantity` interface and hence assumes that the type
`T` supports arithmetic operations.

# Fields
- `value::T`: value of the quantity
- `unit::Unit`: unit of the quantity

# Constructor
```
SimpleQuantity(value::T, abstractUnit::AbstractUnit) where T
SimpleQuantity(value::T) where T
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
3. The value can be of any type. Any mathematical operation included in the
   interface of [`AbstractQuantity`](@ref) is applied to the value field, and
   the unit is modified accordingly.
   ```jldoctest
   julia> ucat = UnitCatalogue() ;

   julia> nanometer = ucat.nano * ucat.meter
   UnitFactor nm

   julia> quantity1 = [4 5] * nanometer
   SimpleQuantity{Array{Int64,2}} of unit nm

   julia> quantity1sqrd = quantity1 * transpose(quantity1)
   SimpleQuantity{Array{Int64,2}} of unit nm^2

   julia> quantity1sqrd.value
   1×1 Array{Int64,2}:
    41
   ```
   The responsibility to check that the resulting quantity is meaningful and
   supports arithemtic operations lies with the user. For example, Alicorn
   allows to assign a unit to a string. String concatenation with * or ^ results
   in a corresponding change of the unit:
   ```jldoctest; setup = :( ucat = UnitCatalogue(); nanometer = ucat.nano * ucat.meter )
   julia> quantity2 = "this is nonsense" * nanometer
   SimpleQuantity{String} of unit nm

   julia> quantity2sqrd = quantity2^2
   SimpleQuantity{String} of unit nm^2

   julia> quantity2sqrd.value
   "this is nonsensethis is nonsense"
   ```
   On the other hand, multiplication with a number
   raises an exception since there is no corresponding method for strings.
   ```
   julia> 2 * quantity2
   MethodError: no method matching *(::Int64, ::SimpleQuantity{String})
   [...]
   ```
"""
mutable struct SimpleQuantity{T} <: AbstractQuantity{T}
    value::T
    unit::Unit

    function SimpleQuantity(value::T, abstractUnit::AbstractUnit) where T
        unit::Unit = convertToUnit(abstractUnit)
        simpleQuantity = new{typeof(value)}(value, unit)
        return simpleQuantity
    end
end

## External constructors

function SimpleQuantity(value::T) where T
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
function inUnitsOf(simpleQuantity::SimpleQuantity, targetUnit::AbstractUnit)::SimpleQuantity
    originalValue = simpleQuantity.value
    originalUnit = simpleQuantity.unit

    if originalUnit == targetUnit
        resultingQuantity = simpleQuantity
    else

        (originalUnitPrefactor, originalBaseUnitExponents) = convertToBasicSIAsExponents(originalUnit)
        (targetUnitPrefactor, targetBaseUnitExponents) = convertToBasicSIAsExponents(targetUnit)

        _assertDimensionsMatch(originalBaseUnitExponents, targetBaseUnitExponents)
        conversionFactor = originalUnitPrefactor / targetUnitPrefactor

        resultingValue = originalValue .* conversionFactor
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
function Base.:*(simpleQuantity::SimpleQuantity, object::Any)
    productValue = simpleQuantity.value * object
    productQuantity = SimpleQuantity(productValue, simpleQuantity.unit)
    return productQuantity
end

# method documented as part of the AbstractQuantity interface
function Base.:*(object::Any, simpleQuantity::SimpleQuantity)
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
function Base.:/(simpleQuantity::SimpleQuantity, object::Any)
    quotientValue = simpleQuantity.value / object
    quotientUnit = simpleQuantity.unit
    quotientQuantity = SimpleQuantity(quotientValue, quotientUnit)
    return quotientQuantity
end

# method documented as part of the AbstractQuantity interface
function Base.:/(object::Any, simpleQuantity::SimpleQuantity)
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
function Base.ndims(simpleQuantity::SimpleQuantity{T}) where {T <: Union{Number, AbstractArray{<:Any}}}
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
    Base.:*(value::Any, abstractUnit::AbstractUnit)::SimpleQuantity

Combine `value` and `abstractUnit` to form a physical quantity of type `SimpleQuantity`.

# Example
```jldoctest
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
```jldoctest
julia> ucat = UnitCatalogue() ;

julia> 3.5 / ucat.second
3.5 s^-1
```
"""
function Base.:/(value::Any, abstractUnit::AbstractUnit)::SimpleQuantity
    inverseAbstractUnit = inv(abstractUnit)
    return SimpleQuantity(value, inverseAbstractUnit)
end



## AbstractArray interface



## Broadcasting TODO
#
# function Base.similar(bc::Broadcast.Broadcasted{AbstractQuantityArrayStyle}, ::Type{ElType}) where ElType
#     # Scan the inputs for the ArrayAndChar:
#     simpleQuantityArray = find_quantity(bc)
#     # Use the char field of A to create the output
#     println(bc)
#     SimpleQuantity( similar(Array{ElType}, axes(bc)), simpleQuantityArray.unit )
# end
#
# "`A = find_quantity(As)` returns the first SimpleQuantity among the arguments."
# find_quantity(bc::Base.Broadcast.Broadcasted) = find_quantity(bc.args)
# find_quantity(args::Tuple) = find_quantity(find_aac(args[1]), Base.tail(args))
# find_quantity(x) = x
# find_quantity(::Tuple{}) = nothing
# find_quantity(a::SimpleQuantity, rest) = a
# find_quantity(::Any, rest) = find_quantity(rest)
#

#

#
# function Base.axes(simpleQuantityArray::SimpleQuantity{<:AbstractArray})
#     println("gotcha")
# end

# TODO: generalize to allow fusing
function Base.broadcasted(::typeof(*), sqArray1::SimpleQuantity{<:AbstractArray}, sqArray2::SimpleQuantity{<:AbstractArray})
    productUnit = sqArray1.unit * sqArray2.unit
    productValue = sqArray1.value .* sqArray2.value
    return SimpleQuantity(productValue, productUnit)
end

# TODO: generalize to allow fusing
function Base.broadcasted(::typeof(*), sqArray::SimpleQuantity{<:AbstractArray}, array::AbstractArray)
    productUnit = sqArray.unit
    productValue = sqArray.value .* array
    return SimpleQuantity(productValue, productUnit)
end

# TODO: generalize to allow fusing
function Base.broadcasted(::typeof(*), array::AbstractArray, sqArray::SimpleQuantity{<:AbstractArray})
    productUnit = sqArray.unit
    productValue = array .* sqArray.value
    return SimpleQuantity(productValue, productUnit)
end

# TODO: generalize to allow fusing
function Base.broadcasted(::typeof(abs), sqArray::SimpleQuantity{<:AbstractArray})
    unit = sqArray.unit
    absValue = abs.(sqArray.value)
    return SimpleQuantity(absValue, unit)
end

# TODO: generalize to allow fusing
function Base.broadcasted(::typeof(*), simpleQuantity::SimpleQuantity{<:Number}, array::AbstractArray)
    productUnit = simpleQuantity.unit
    productValue = simpleQuantity.value .* array
    return SimpleQuantity(productValue, productUnit)
end

# TODO: generalize to allow fusing
function Base.broadcasted(::typeof(*), simpleQuantity::SimpleQuantity{<:Number}, sqArray::SimpleQuantity{<:AbstractArray})
    productUnit = simpleQuantity.unit * sqArray.unit
    productValue = simpleQuantity.value .* sqArray.value
    return SimpleQuantity(productValue, productUnit)
end

# TODO: generalize to allow fusing
function Base.broadcasted(::typeof(Base.literal_pow), ::typeof(^), sqArray::SimpleQuantity{<:AbstractArray}, exponent::Val{exp}) where exp
    productUnit = sqArray.unit^exp
    productValue = sqArray.value.^exp
    return SimpleQuantity(productValue, productUnit)
end

# TODO: generalize to allow fusing
function Base.broadcasted(::typeof(/), array::AbstractArray, sqArray::SimpleQuantity{<:AbstractArray})
    productUnit = inv(sqArray.unit)
    productValue = array ./ sqArray.value
    return SimpleQuantity(productValue, productUnit)
end

# TODO:
function Base.iterate(sqArray::SimpleQuantity{<:Union{Number, AbstractArray}}, state=(eachindex(sqArray),))
    y = iterate(state...)
    y === nothing && return nothing
    sqArray[y[1]], (state[1], Base.tail(y)...)
end

# TODO:
function Base.eachindex(sqArray::SimpleQuantity{<:Union{Number, AbstractArray}})
    return eachindex(sqArray.value)
end

# TODO:
function Base.:-(simpleQuantity::SimpleQuantity)
    unit = simpleQuantity.unit
    inverseValue = -simpleQuantity.value
    return SimpleQuantity(inverseValue, unit)
end

# TODO:
function Base.minimum(simpleQuantity::SimpleQuantity{<:Union{Number, AbstractArray}})
    unit = simpleQuantity.unit
    min = minimum(simpleQuantity.value)
    return SimpleQuantity(min, unit)
end

# TODO:
function Base.maximum(simpleQuantity::SimpleQuantity{<:Union{Number, AbstractArray}})
    unit = simpleQuantity.unit
    max = maximum(simpleQuantity.value)
    return SimpleQuantity(max, unit)
end

# function Base.broadcasted(::typeof(sqrt), sqArray1::SimpleQuantity{<:AbstractArray})
#     sqrtUnit = sqArray1.unit^(0.5)
#     sqrtValue = sqrt.(sqArray1.value)
#     println("gotcha2")
#     return SimpleQuantity(sqrtValue, sqrtUnit)
# end
#
export ArrayAndChar
struct ArrayAndChar{T,N} <: AbstractArray{T,N}
    data::Array{T,N}
    char::Char
end
Base.size(A::ArrayAndChar) = size(A.data)
Base.getindex(A::ArrayAndChar{T,N}, inds::Vararg{Int,N}) where {T,N} = A.data[inds...]
Base.setindex!(A::ArrayAndChar{T,N}, val, inds::Vararg{Int,N}) where {T,N} = A.data[inds...] = val
Base.showarg(io::IO, A::ArrayAndChar, toplevel) = print(io, typeof(A), " with char '", A.char, "'")

Base.BroadcastStyle(::Type{<:ArrayAndChar}) = Broadcast.ArrayStyle{ArrayAndChar}()

function Base.similar(bc::Broadcast.Broadcasted{Broadcast.ArrayStyle{ArrayAndChar}}, ::Type{ElType}) where ElType
    # Scan the inputs for the ArrayAndChar:
    A = find_aac(bc)
    # Use the char field of A to create the output
    ArrayAndChar(similar(Array{ElType}, axes(bc)), A.char)
end

# "`A = find_aac(As)` returns the first ArrayAndChar among the arguments."
find_aac(bc::Base.Broadcast.Broadcasted) = find_aac(bc.args)
find_aac(args::Tuple) = find_aac(find_aac(args[1]), Base.tail(args))
find_aac(x) = x
find_aac(::Tuple{}) = nothing
find_aac(a::ArrayAndChar, rest) = a
find_aac(::Any, rest) = find_aac(rest)
