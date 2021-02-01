export UnitFactorElement
"""
    UnitFactorElement = Union{UnitPrefix, BaseUnit}

Type union that encompasses the types used to construct objects of type [`UnitFactor`](@ref): [`UnitPrefix`](@ref) and [`BaseUnit`](@ref).
"""
const UnitFactorElement = Union{UnitPrefix, BaseUnit}

Base.broadcastable(unitFactorElement::UnitFactorElement) = Ref(unitFactorElement)
