function initializeWithDefaultDefinitions()
    unitPrefixes = _getDefaultPrefixes()
    baseUnits = _getDefaultBaseUnits()
    ucat = UnitCatalogue( unitPrefixes, baseUnits )
    add!(ucat, emptyUnitPrefix)
    add!(ucat, unitlessBaseUnit)
    return ucat
end

function _getDefaultPrefixes()
    return [
        UnitPrefix(name="yotta", symbol="Y", value=1e+24),
        UnitPrefix(name="zetta", symbol="Z", value=1e+21),
        UnitPrefix(name="exa", symbol="E", value=1e+18),
        UnitPrefix(name="peta", symbol="P", value=1e+15),
        UnitPrefix(name="tera", symbol="T", value=1e+12),
        UnitPrefix(name="giga", symbol="G", value=1e+9),
        UnitPrefix(name="mega", symbol="M", value=1e+6),
        UnitPrefix(name="kilo", symbol="k", value=1e+3),
        UnitPrefix(name="hecto", symbol="h", value=1e+2),
        UnitPrefix(name="deca", symbol="da", value=1e+1),
        UnitPrefix(name="deci", symbol="d", value=1e-1),
        UnitPrefix(name="centi", symbol="c", value=1e-2),
        UnitPrefix(name="milli", symbol="m", value=1e-3),
        UnitPrefix(name="micro", symbol="μ", value=1e-6),
        UnitPrefix(name="nano", symbol="n", value=1e-9),
        UnitPrefix(name="pico", symbol="p", value=1e-12),
        UnitPrefix(name="femto", symbol="f", value=1e-15),
        UnitPrefix(name="atto", symbol="a", value=1e-18),
        UnitPrefix(name="zepto", symbol="z", value=1e-21),
        UnitPrefix(name="yocto", symbol="y", value=1e-24)
    ]
end

function _getDefaultBaseUnits()
    return [
        # basic units
        BaseUnit(name="gram", symbol="g", prefactor=1e-3, exponents=BaseUnitExponents(kg=1)),
        BaseUnit(name="meter", symbol="m", prefactor=1, exponents=BaseUnitExponents(m=1)),
        BaseUnit(name="second", symbol="s", prefactor=1, exponents=BaseUnitExponents(s=1)),
        BaseUnit(name="ampere", symbol="A", prefactor=1, exponents=BaseUnitExponents(A=1)),
        BaseUnit(name="kelvin", symbol="K", prefactor=1, exponents=BaseUnitExponents(K=1)),
        BaseUnit(name="mol", symbol="mol", prefactor=1, exponents=BaseUnitExponents(mol=1)),
        BaseUnit(name="candela", symbol="cd", prefactor=1, exponents=BaseUnitExponents(cd=1)),
        # coherent units
        BaseUnit(name="hertz", symbol="Hz", prefactor=1, exponents=BaseUnitExponents(s=-1)),
        BaseUnit(name="radian", symbol="rad", prefactor=1, exponents=BaseUnitExponents()),
        BaseUnit(name="steradian", symbol="sr", prefactor=1, exponents=BaseUnitExponents()),
        BaseUnit(name="newton", symbol="N", prefactor=1, exponents=BaseUnitExponents(kg=1, m=1, s=-2)),
        BaseUnit(name="pascal", symbol="Pa", prefactor=1, exponents=BaseUnitExponents(kg=1, m=-1, s=-2)),
        BaseUnit(name="joule", symbol="J", prefactor=1, exponents=BaseUnitExponents(kg=1, m=2, s=-2)),
        BaseUnit(name="watt", symbol="W", prefactor=1, exponents=BaseUnitExponents(kg=1, m=2, s=-3)),
        BaseUnit(name="coulomb", symbol="C", prefactor=1, exponents=BaseUnitExponents(s=1, A=1)),
        BaseUnit(name="volt", symbol="V", prefactor=1, exponents=BaseUnitExponents(kg=1, m=2, s=-3, A=-1)),
        BaseUnit(name="farad", symbol="F", prefactor=1, exponents=BaseUnitExponents(kg=-1, m=-2, s=4, A=2)),
        BaseUnit(name="ohm", symbol="Ω", prefactor=1, exponents=BaseUnitExponents(kg=1, m=2, s=-3, A=-2)),
        BaseUnit(name="siemens", symbol="S", prefactor=1, exponents=BaseUnitExponents(kg=-1, m=-2, s=3, A=2)),
        BaseUnit(name="weber", symbol="W", prefactor=1, exponents=BaseUnitExponents(kg=1, m=2, s=-2, A=-1)),
        BaseUnit(name="tesla", symbol="T", prefactor=1, exponents=BaseUnitExponents(kg=1, s=-2, A=-1)),
        BaseUnit(name="henry", symbol="H", prefactor=1, exponents=BaseUnitExponents(kg=1, m=2, s=-2, A=-2)),
        BaseUnit(name="degreeCelsius", symbol="°C", prefactor=1, exponents=BaseUnitExponents(K=1)),
        BaseUnit(name="lumen", symbol="lm", prefactor=1, exponents=BaseUnitExponents(cd=1)),
        BaseUnit(name="lux", symbol="lx", prefactor=1, exponents=BaseUnitExponents(m=-2, cd=1)),
        BaseUnit(name="becquerel", symbol="Bq", prefactor=1, exponents=BaseUnitExponents(s=-1)),
        BaseUnit(name="gray", symbol="Gy", prefactor=1, exponents=BaseUnitExponents(m=2, s=-2)),
        BaseUnit(name="sievert", symbol="Sv", prefactor=1, exponents=BaseUnitExponents(m=2, s=-2)),
        BaseUnit(name="katal", symbol="kat", prefactor=1, exponents=BaseUnitExponents(s=-1, mol=1)),
        # accepted units
        BaseUnit(name="minute", symbol="min", prefactor=60, exponents=BaseUnitExponents(s=1)),
        BaseUnit(name="hour", symbol="h", prefactor=3600, exponents=BaseUnitExponents(s=1)),
        BaseUnit(name="day", symbol="d", prefactor=86400, exponents=BaseUnitExponents(s=1)),
        BaseUnit(name="astronomicalUnit", symbol="au", prefactor=149597870700, exponents=BaseUnitExponents(m=1)),
        BaseUnit(name="degree", symbol="°", prefactor=pi/180, exponents=BaseUnitExponents()),
        BaseUnit(name="arcminute", symbol="'", prefactor=pi/10800, exponents=BaseUnitExponents()),
        BaseUnit(name="arcsecond", symbol="\"", prefactor=pi/648000, exponents=BaseUnitExponents()),
        BaseUnit(name="hectare", symbol="ha", prefactor=10000, exponents=BaseUnitExponents(m=2)),
        BaseUnit(name="liter", symbol="l", prefactor=0.001, exponents=BaseUnitExponents(m=3)),
        BaseUnit(name="tonne", symbol="t", prefactor=1000, exponents=BaseUnitExponents(kg=1)),
        BaseUnit(name="dalton", symbol="Da", prefactor=1.66053906660e-27, exponents=BaseUnitExponents(kg=1)),
        BaseUnit(name="electronvolt", symbol="eV", prefactor=1.602176634e-19, exponents=BaseUnitExponents(kg=1, m=2, s=-2)),
        # additional units
        BaseUnit(name="angstrom", symbol="Å", prefactor=1e-10, exponents=BaseUnitExponents(m=1))
    ]
end
