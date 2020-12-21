function initializeDefaultDefinitions!(unitCatalogue::UnitCatalogue)
    initializeDefaultPrefixes!(unitCatalogue)
end

function initializeDefaultPrefixes!(unitCatalogue::UnitCatalogue)
    defaultPrefixes = _getDefaultPrefixes()
    for prefix in defaultPrefixes
        add!(unitCatalogue, prefix)
    end
end

function _getDefaultPrefixes()
    return [
        UnitPrefix(name="yotta",symbol="Y",value=1e+24),
        UnitPrefix(name="zetta",symbol="Z",value=1e+21),
        UnitPrefix(name="exa",symbol="E",value=1e+18),
        UnitPrefix(name="peta",symbol="P",value=1e+15),
        UnitPrefix(name="tera",symbol="T",value=1e+12),
        UnitPrefix(name="giga",symbol="G",value=1e+9),
        UnitPrefix(name="mega",symbol="M",value=1e+6),
        UnitPrefix(name="kilo",symbol="k",value=1e+3),
        UnitPrefix(name="hecto",symbol="h",value=1e+2),
        UnitPrefix(name="deca",symbol="da",value=1e+1),
        UnitPrefix(name="deci",symbol="d",value=1e-1),
        UnitPrefix(name="centi",symbol="c",value=1e-2),
        UnitPrefix(name="milli",symbol="m",value=1e-3),
        UnitPrefix(name="micro",symbol="μ",value=1e-6),
        UnitPrefix(name="nano",symbol="n",value=1e-9),
        UnitPrefix(name="pico",symbol="p",value=1e-12),
        UnitPrefix(name="femto",symbol="f",value=1e-15),
        UnitPrefix(name="atto",symbol="a",value=1e-18),
        UnitPrefix(name="zepto",symbol="z",value=1e-21),
        UnitPrefix(name="yocto",symbol="y",value=1e-24)
    ]
end
