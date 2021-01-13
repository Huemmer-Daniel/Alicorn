function Base.inv(baseUnit::BaseUnit)
    return inv( UnitFactor(baseUnit) )
end

function Base.:^(baseUnit::BaseUnit, exponent::Real)
    return UnitFactor(baseUnit)^exponent
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

function Base.:*(unitPrefix::UnitPrefix, baseUnit::BaseUnit)
    return UnitFactor(unitPrefix, baseUnit)
end

function Base.:*(unitPrefix::UnitPrefix, unitFactor::UnitFactor)
    _assertHasEmptyPrefix(unitFactor)
    _assertHasTrivialExponent(unitFactor)

    baseUnit = unitFactor.baseUnit
    return UnitFactor(unitPrefix, baseUnit)
end

function _assertHasEmptyPrefix(unitFactor::UnitFactor)
    prefix = unitFactor.unitPrefix
    if !(prefix == emptyUnitPrefix)
        throw(Base.ArgumentError("prefix of UnitFactor needs to be emptyUnitPrefix for multiplication of UnitPrefix with UnitFactor"))
    end
end

function _assertHasTrivialExponent(unitFactor::UnitFactor)
    exponent = unitFactor.exponent
    if !(exponent == 1)
        throw(Base.ArgumentError("exponent of UnitFactor needs to be 1 for multiplication of UnitPrefix with UnitFactor"))
    end
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

function Base.:*(baseUnit1::BaseUnit, baseUnit2::BaseUnit)
    return Unit(baseUnit1) * Unit(baseUnit2)
end

function Base.:/(baseUnit1::BaseUnit, baseUnit2::BaseUnit)
    return Unit(baseUnit1) / Unit(baseUnit2)
end

function Base.:*(unitFactor1::UnitFactor, unitFactor2::UnitFactor)
    return Unit(unitFactor1) * Unit(unitFactor2)
end

function Base.:/(unitFactor1::UnitFactor, unitFactor2::UnitFactor)
    return Unit(unitFactor1) / Unit(unitFactor2)
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

function Base.:*(baseUnit::BaseUnit, unitFactor::UnitFactor)
    return Unit(baseUnit) * Unit(unitFactor)
end

function Base.:*(unitFactor::UnitFactor, baseUnit::BaseUnit)
    return Unit(unitFactor) * Unit(baseUnit)
end

function Base.:/(baseUnit::BaseUnit, unitFactor::UnitFactor)
    return Unit(baseUnit) / Unit(unitFactor)
end

function Base.:/(unitFactor::UnitFactor, baseUnit::BaseUnit)
    return Unit(unitFactor) / Unit(baseUnit)
end

function Base.:*(baseUnit::BaseUnit, unit::Unit)
    return Unit(baseUnit) * unit
end

function Base.:*(unit::Unit, baseUnit::BaseUnit)
    return unit * Unit(baseUnit)
end

function Base.:/(baseUnit::BaseUnit, unit::Unit)
    return Unit(baseUnit) / unit
end

function Base.:/(unit::Unit, baseUnit::BaseUnit)
    return unit / Unit(baseUnit)
end

function Base.:*(unitFactor::UnitFactor, unit::Unit)
    return Unit(unitFactor) * unit
end

function Base.:*(unit::Unit, unitFactor::UnitFactor)
    return unit * Unit(unitFactor)
end

function Base.:/(unitFactor::UnitFactor, unit::Unit)
    return Unit(unitFactor) / unit
end

function Base.:/(unit::Unit, unitFactor::UnitFactor)
    return unit / Unit(unitFactor)
end
