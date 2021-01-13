export Unit
struct Unit
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

function Unit(unitFactor::UnitFactor)
    return Unit([unitFactor])
end

function Unit(baseUnit::BaseUnit)
    return Unit( UnitFactor(baseUnit) )
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
