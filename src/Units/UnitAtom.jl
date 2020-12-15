export UnitAtom
struct UnitAtom
    name::String
    symbol::String
    prefactor::Float64
    exponents::Dict

    function UnitAtom(; name::String, symbol::String, prefactor::Float64, exponents::Dict)
        new(name, symbol, prefactor, exponents)
    end
end

export UnitAtomExponents
struct UnitAtomExponents
    kilogramExponent::Float64
    meterExponent::Float64
    secondExponent::Float64
    ampereExponent::Float64
    KelvinExponent::Float64
    molExponent::Float64
    candelaExponent::Float64

    function UnitAtomExponents(; kg::Real=1, m::Real=1, s::Real=1, A::Real=1, K::Real=1, mol::Real=1, cd::Real=1 )
        Utils.assertNumberIsFinite(kg)
        Utils.assertNumberIsFinite(m)
        Utils.assertNumberIsFinite(s)
        Utils.assertNumberIsFinite(A)
        Utils.assertNumberIsFinite(K)
        Utils.assertNumberIsFinite(mol)
        Utils.assertNumberIsFinite(cd)
        new(kg, m, s, A, K, mol, cd)
    end
end
