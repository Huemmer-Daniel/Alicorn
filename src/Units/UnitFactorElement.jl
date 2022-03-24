"""
    UnitFactorElement = Union{UnitPrefix, BaseUnit}

Type union that encompasses the types [`UnitPrefix`](@ref) and [`BaseUnit`](@ref) which are used to construct objects of type [`UnitFactor`](@ref).
"""
const UnitFactorElement = Union{UnitPrefix, BaseUnit}

Base.broadcastable(unitFactorElement::UnitFactorElement) = Ref(unitFactorElement)
