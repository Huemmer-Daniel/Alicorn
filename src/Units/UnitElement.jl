export UnitElement
abstract type UnitElement end

Base.broadcastable(unitElement::UnitElement) = Ref(unitElement)
