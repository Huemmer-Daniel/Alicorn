export SimpleQuantity
mutable struct SimpleQuantity{T}
    value::T
    unit::Unit

    function SimpleQuantity(value::T, abstractUnit::AbstractUnit) where T
        unit::Unit = convertToUnit(abstractUnit)
        simpleQuantity = new{typeof(value)}(value, unit)
        return simpleQuantity
    end
end
