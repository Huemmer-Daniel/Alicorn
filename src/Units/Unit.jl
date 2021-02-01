export Unit
"""
    Unit <: AbstractUnit

TODO
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

function convertToUnit(unit::Unit)
    return unit
end

function Unit(abstractUnit::AbstractUnit)
    return convertToUnit(abstractUnit)
end

function Unit()
    unitlessFactor = UnitFactor()
    return Unit(unitlessFactor)
end

function Base.:(==)(unit1::Unit, unit2::Unit)
    return unit1.unitFactors == unit2.unitFactors
end

export unitlessUnit
unitlessUnit = Unit( unitlessUnitFactor )

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

function Base.:^(unit::Unit, exponent::Real)
    newUnitFactors = unit.unitFactors.^exponent
    newUnit = Unit(newUnitFactors)
    return newUnit
end

function Base.sqrt(unit::Unit)
    return unit^(0.5)
end

function Base.:*(unit1::Unit, unit2::Unit)
    unitFactors1 = unit1.unitFactors
    unitFactors2 = unit2.unitFactors
    newUnitFactors = vcat(unitFactors1, unitFactors2)
    return Unit(newUnitFactors)
end

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

function convertToBasicSI(unit::Unit)
    (prefactor, basicSIAsExponents) = convertToBasicSIAsExponents(unit)
    basicSIUnit = convertToUnit(basicSIAsExponents)
    return (prefactor, basicSIUnit)
end

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
