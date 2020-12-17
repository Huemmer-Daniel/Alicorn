export BaseUnit
struct BaseUnit
    name::String
    symbol::String
    prefactor::Real
    exponents::BaseUnitExponents

    function BaseUnit(; name::String, symbol::String, prefactor::Real, exponents::BaseUnitExponents)
        new(name, symbol, prefactor, exponents)
    end
end
