@doc raw"""
    Unit <: AbstractUnit

A composite unit formed by several [`UnitFactor`](@ref) objects.

# Fields

- `unitFactors::Vector{UnitFactor}`: ordered list of [`UnitFactor`](@ref) objects
  that form the `Unit` through multiplication (concatenation).

# Constructors
```
Unit(unitFactors::Vector{UnitFactor})
Unit(abstractUnit::AbstractUnit)
Unit()
```

# Remarks

The constructor `Unit(abstractUnit::AbstractUnit)` is equivalent to [`convertToUnit(abstractUnit::AbstractUnit)`](@ref). The constructor `Unit()` returns the constant [`unitlessUnit`](@ref).

When a `Unit` is initialized, `UnitFactor` objects are added to the
`unitFactors` field in order of appearance. `UnitFactor` objects with the same
base (`UnitPrefix` and `BaseUnit`) are merged.

# Examples
1. The unit ``\sqrt{\mathrm{Hz}}/\mathrm{nm}`` (square root of hertz per nanometer)
   can be constructed using the constructor method as follows:
   ```jldoctest
   julia> ucat = UnitCatalogue();

   julia> sqrtHz = UnitFactor(ucat.hertz, 1/2)
   UnitFactor Hz^5e-1

   julia> per_nm = UnitFactor(ucat.nano, ucat.meter, -1)
   UnitFactor nm^-1

   julia> sqrtHz_per_nm = Unit([sqrtHz, per_nm])
   Unit Hz^5e-1 nm^-1
   ```
2. Alternatively, ``\sqrt{\mathrm{Hz}}/\mathrm{nm}`` can also be constructed arithmetically:
   ```jldoctest
   julia> ucat = UnitCatalogue();

   julia> sqrtHz_per_nm = sqrt(ucat.hertz) / ( ucat.nano * ucat.meter )
   Unit Hz^5e-1 nm^-1
   ```
"""
struct Unit <: AbstractUnit
    unitFactors::Vector{UnitFactor}

    function Unit(unitFactors::Vector{UnitFactor})
        unitFactors = _stripUnitlessFactors(unitFactors)
        unitFactors = _mergeDuplicateFactors(unitFactors)
        new(unitFactors)
    end
end

function _stripUnitlessFactors(unitFactors::Vector{UnitFactor})
    unitlessFactor = UnitFactor(unitlessBaseUnit)
    if unitFactors != [unitlessFactor]
        unitlessFactorVector = repeat([unitlessFactor], length(unitFactors))
        unitlessMask = ( unitFactors .== unitlessFactorVector )
        unitFactors = unitFactors[.!unitlessMask]
    end
    return unitFactors
end

function _mergeDuplicateFactors(unitFactors::Vector{UnitFactor})
    originalFactors = deepcopy(unitFactors)
    mergedFactors = Vector{UnitFactor}()
    _transferAndMergeAllFactors!(originalFactors, mergedFactors)
    return mergedFactors
end

function _transferAndMergeAllFactors!(originalFactors::Vector{UnitFactor}, mergedFactors::Vector{UnitFactor})
    while length(originalFactors) > 0
        _mergeLeadingFactor!(originalFactors, mergedFactors)
    end
    _replaceEmptyFactorListWithUnitlessFactor!(mergedFactors)
end

function _mergeLeadingFactor!(originalFactors::Vector{UnitFactor}, mergedFactors::Vector{UnitFactor})
    leadingFactor = _popLeadingFactor(originalFactors)
    mergedFactor = _mergeWithDuplicates!(leadingFactor, originalFactors)
    _addMergedFactor!(mergedFactors, mergedFactor)
end

function _popLeadingFactor(originalFactors::Vector{UnitFactor})
    return popfirst!(originalFactors)
end

function _mergeWithDuplicates!(factor::UnitFactor, originalFactors::Vector{UnitFactor})
    for (index, otherFactor) in enumerate(originalFactors)
        factor = _mergeIfDuplicate!(factor, otherFactor, index, originalFactors)
    end
    return factor
end

function _mergeIfDuplicate!(factor, otherFactor, index, originalFactors)
    if _haveSameBasis(factor, otherFactor)
        factor = _mergeUnitFactors(factor, otherFactor)
        deleteat!(originalFactors, index)
    end
    return factor
end

function _haveSameBasis(factor1::UnitFactor, factor2::UnitFactor)
    samePrefix = (factor1.unitPrefix == factor2.unitPrefix)
    sameBaseUnit = (factor1.baseUnit == factor2.baseUnit)
    return samePrefix && sameBaseUnit
end

function _mergeUnitFactors(factor1::UnitFactor, factor2::UnitFactor)
    exponent = _mergeUnitFactors_calculateExponent(factor1, factor2)
    if exponent == 0
        newUnitFactor = _mergeUnitFactors_zeroExponent()
    else
        newUnitFactor = _mergeUnitFactors_nonzeroExponent(factor1, exponent)
    end
    return newUnitFactor
end

function _mergeUnitFactors_calculateExponent(factor1::UnitFactor, factor2::UnitFactor)
    exponent1 = factor1.exponent
    exponent2 = factor2.exponent
    exponent = exponent1 + exponent2
    return exponent
end

function _mergeUnitFactors_zeroExponent()
    return UnitFactor(unitlessBaseUnit)
end

function _mergeUnitFactors_nonzeroExponent(factor::UnitFactor, exponent::Real)
    unitPrefix = factor.unitPrefix
    baseUnit = factor.baseUnit
    newUnitFactor = UnitFactor(unitPrefix, baseUnit, exponent)
    return newUnitFactor
end

function _addMergedFactor!(mergedFactors::Vector{UnitFactor}, mergedFactor::UnitFactor)
     if !( mergedFactor == UnitFactor(unitlessBaseUnit) )
        push!(mergedFactors, mergedFactor)
    end
end

function _replaceEmptyFactorListWithUnitlessFactor!(mergedFactors::Vector{UnitFactor})
    if isempty(mergedFactors)
        push!(mergedFactors, UnitFactor(unitlessBaseUnit))
    end
end

## Outer constructors

# documented in the type definition
function Unit(abstractUnit::AbstractUnit)
    return convertToUnit(abstractUnit)
end

# documented in the type definition
function Unit()
    unitlessFactor = UnitFactor()
    return unitlessUnit
end

## Methods implementing the interface of AbstractUnit

"""
    Base.:*(unit1::Unit, unit2::Unit)

Multiply `unit1` with `unit2` and return the result as a unit of type `Unit`.
"""
function Base.:*(unit1::Unit, unit2::Unit)
    unitFactors1 = unit1.unitFactors
    unitFactors2 = unit2.unitFactors
    newUnitFactors = vcat(unitFactors1, unitFactors2)
    return Unit(newUnitFactors)
end

"""
    Base.:/(unit1::Unit, unit2::Unit)

Divide `unit1` by `unit2` and return the result as a unit of type `Unit`.
"""
function Base.:/(unit1::Unit, unit2::Unit)
    unitFactors1 = unit1.unitFactors
    unitFactors2 = unit2.unitFactors
    inverseUnitFactors2 = _inv_unitFactors(unitFactors2)
    newUnitFactors = vcat(unitFactors1, inverseUnitFactors2)
    return Unit(newUnitFactors)
end

function _inv_unitFactors(unitFactors::Vector{UnitFactor})
    inverseUnitFactors = map(inv, unitFactors)
    return inverseUnitFactors
end

# documented as part of the interface of AbstractUnit
function convertToUnit(unit::Unit)
    return unit
end

# documented as part of the interface of AbstractUnit
function convertToBasicSI(unit::Unit)
    (prefactor, basicSIAsExponents) = convertToBasicSIAsExponents(unit)
    basicSIUnit = convertToUnit(basicSIAsExponents)
    return (prefactor, basicSIUnit)
end

# documented as part of the interface of AbstractUnit
function convertToBasicSIAsExponents(unit::Unit)
    unitFactors = unit.unitFactors

    prefactor = 1
    basicSIAsExponents = BaseUnitExponents()

    for unitFactor in unitFactors
        (unitFactorPrefactor, unitFactorInBasicSIExponents) = convertToBasicSIAsExponents(unitFactor)
        prefactor *= unitFactorPrefactor
        basicSIAsExponents += unitFactorInBasicSIExponents
    end

    return (prefactor, basicSIAsExponents)
end

"""
    Base.:*(unitPrefix::UnitPrefix, unit::Unit)

Combine `unitPrefix` and `unit` to form a unit of type `Unit`.

The operation is only permitted if
1. `unit` contains a single unit factor `unitFactor::UnitFactor`,
2. `unitFactor` does not already contain a unit prefix, and
3. the exponent of `unitFactor` is 1.

# Raises Exceptions
- `Base.ArgumentError`: if `unit.unitFactors` contains more than one element `unitFactor::UnitFactor`
- `Base.ArgumentError`: if `unitFactor.unitPrefix != Alicorn.emptyUnitPrefix`
- `Base.ArgumentError`: if `unitFactor.exponent != 1`
"""
function Base.:*(unitPrefix::UnitPrefix, unit::Unit)
    _assertHasSingleUnitFactor(unit)
    unitFactor = unit.unitFactors[1]

    _assertHasEmptyPrefix(unit)
    _assertHasTrivialExponent(unit)

    baseUnit = unitFactor.baseUnit
    return Unit(UnitFactor(unitPrefix, baseUnit))
end

function _assertHasSingleUnitFactor(unit::Unit)
    unitFactors = unit.unitFactors
    nrOfFactors =  length(unitFactors)
    if !( nrOfFactors == 1 )
        throw(Base.ArgumentError("unit needs to have single factor for multiplication of UnitPrefix with Unit"))
    end
end

function _assertHasEmptyPrefix(unit::Unit)
    firstUnitFactor = unit.unitFactors[1]
    prefix = firstUnitFactor.unitPrefix
    if !(prefix == emptyUnitPrefix)
        throw(Base.ArgumentError("prefix of single UnitFactor in Unit needs to be emptyUnitPrefix for multiplication of UnitPrefix with Unit"))
    end
end

function _assertHasTrivialExponent(unit::Unit)
    firstUnitFactor = unit.unitFactors[1]
    exponent = firstUnitFactor.exponent
    if !(exponent == 1)
        throw(Base.ArgumentError("exponent of single UnitFactor in Unit needs to be 1 for multiplication of UnitPrefix with Unit"))
    end
end

"""
    Base.inv(unit::Unit)

Return the (multiplicative) inverse of `unit` as a unit of type `Unit`.
"""
function Base.inv(unit::Unit)
    unitFactors = unit.unitFactors
    inverseUnitFactors = Vector{UnitFactor}()
    for unitFactor in unitFactors
        inverseUnitFactor = inv(unitFactor)
        push!(inverseUnitFactors, inverseUnitFactor)
    end
    inverseUnit = Unit(inverseUnitFactors)
    return inverseUnit
end

"""
    Base.:^(unit::Unit, exponent::Real)

Raise `unit` to the power of `exponent` and return the result as a unit of type `Unit`.
"""
function Base.:^(unit::Unit, exponent::Real)
    newUnitFactors = unit.unitFactors.^exponent
    newUnit = Unit(newUnitFactors)
    return newUnit
end

"""
    Base.sqrt(unit::Unit)

Take the square root of `unit` and return it as unit of type `Unit`.
"""
function Base.sqrt(unit::Unit)
    return unit^(0.5)
end

"""
    Base.cbrt(unit::Unit)

Take the cubic root of `unit` and return it as unit of type `Unit`.
"""
function Base.cbrt(unit::Unit)
    return unit^(1/3)
end

## Methods

function Base.:(==)(unit1::Unit, unit2::Unit)
    return unit1.unitFactors == unit2.unitFactors
end

## Constants of type UnitFactor

"""
Constant of type `Unit` indicating the absence of a unit.

The constant is not exported by Alicorn but can be accessed as `Alicorn.unitlessUnit`.
"""
const unitlessUnit = Unit( unitlessUnitFactor )
