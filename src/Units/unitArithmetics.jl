function Base.:*(unitPrefix::UnitPrefix, baseUnit::BaseUnit)
    return Unit(UnitFactor(unitPrefix, baseUnit))
end

function Base.inv(unitFactor::UnitFactor)
    if unitFactor == UnitFactor(unitlessBaseUnit)
        return unitFactor
    else
        inverseUnitFactor = UnitFactor(unitFactor.unitPrefix, unitFactor.baseUnit, -unitFactor.exponent)
        return inverseUnitFactor
    end
end

function Base.:^(unitFactor::UnitFactor, exponent::Real)
    unitPrefix = unitFactor.unitPrefix
    baseUnit = unitFactor.baseUnit

    newExponent = unitFactor.exponent * exponent
    try
        newExponent = convert(Int, newExponent)
    catch
    end

    newUnitFactor = UnitFactor(unitPrefix, baseUnit, newExponent)
    return newUnitFactor
end

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
