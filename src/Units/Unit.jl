export Unit
struct Unit
    unitFactors::Vector{UnitFactor}
end

function Unit(unitFactor::UnitFactor)
    return Unit([unitFactor])
end

function Unit()
    unitlessFactor = UnitFactor()
    return Unit(unitlessFactor)
end

function Base.:(==)(unit1::Unit, unit2::Unit)
    return unit1.unitFactors == unit2.unitFactors
end
