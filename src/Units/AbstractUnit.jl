export AbstractUnit
abstract type AbstractUnit <: AbstractUnitElement end

Base.broadcastable(abstractUnit::AbstractUnit) = Ref(abstractUnit)
