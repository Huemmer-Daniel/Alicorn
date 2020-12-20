using ..Utils
using ..Exceptions

export UnitCatalogue
struct UnitCatalogue
    prefixCatalogue::Dict{String,UnitPrefix}

    function UnitCatalogue()
        prefixCatalogue = _getBasicPrefixesDict()
        new(prefixCatalogue)
    end
end

function _getBasicPrefixesDict()::Dict{String, UnitPrefix}
    return Dict([
    ("yotta",UnitPrefix(name="yotta",symbol="Y",value=1e+24)),
    ("zetta",UnitPrefix(name="zetta",symbol="Z",value=1e+21)),
    ("exa",UnitPrefix(name="exa",symbol="E",value=1e+18)),
    ("peta",UnitPrefix(name="peta",symbol="P",value=1e+15)),
    ("tera",UnitPrefix(name="tera",symbol="T",value=1e+12)),
    ("giga",UnitPrefix(name="giga",symbol="G",value=1e+9)),
    ("mega",UnitPrefix(name="mega",symbol="M",value=1e+6)),
    ("kilo",UnitPrefix(name="kilo",symbol="k",value=1e+3)),
    ("hecto",UnitPrefix(name="hecto",symbol="h",value=1e+2)),
    ("deca",UnitPrefix(name="deca",symbol="da",value=1e+1)),
    ("deci",UnitPrefix(name="deci",symbol="d",value=1e-1)),
    ("centi",UnitPrefix(name="centi",symbol="c",value=1e-2)),
    ("milli",UnitPrefix(name="milli",symbol="m",value=1e-3)),
    ("micro",UnitPrefix(name="micro",symbol="μ",value=1e-6)),
    ("nano",UnitPrefix(name="nano",symbol="n",value=1e-9)),
    ("pico",UnitPrefix(name="pico",symbol="p",value=1e-12)),
    ("femto",UnitPrefix(name="femto",symbol="f",value=1e-15)),
    ("atto",UnitPrefix(name="atto",symbol="a",value=1e-18)),
    ("zepto",UnitPrefix(name="zepto",symbol="z",value=1e-21)),
    ("yocto",UnitPrefix(name="yocto",symbol="y",value=1e-24))
    ])
end

function Base.getproperty(unitCatalogue::UnitCatalogue, symbol::Symbol)
    name = String(symbol)
    if providesUnitPrefix(unitCatalogue, name)
        return getfield(unitCatalogue,:prefixCatalogue)[name]
    else
        throw(KeyError(name))
    end
end

export providesUnitPrefix
function providesUnitPrefix(unitCatalogue::UnitCatalogue, name::String)
    return Utils.isElementOf(name, listUnitPrefixes(unitCatalogue))
end

export listUnitPrefixes
function listUnitPrefixes(unitCatalogue::UnitCatalogue)
    knownPrefixesDict = _getKnownPrefixesDict(unitCatalogue)
    knownPrefixNames = collect(keys(knownPrefixesDict))
    return sort!(knownPrefixNames)
end

function _getKnownPrefixesDict(unitCatalogue::UnitCatalogue)
    return getfield(unitCatalogue,:prefixCatalogue)
end

function Base.propertynames(unitCatalogue::UnitCatalogue)
    prefixNames = listUnitPrefixes(unitCatalogue)
    propertyList = _generatePropertySymbolList(prefixNames)
    return propertyList
end

function _generatePropertySymbolList(unitElementNames::Vector{String})
    sort!(unitElementNames)
    nrOfProperties = length(unitElementNames)
    propertyList = Array{Symbol}(undef,nrOfProperties)
    for (index, name) in enumerate(unitElementNames)
        propertyList[index] = Symbol(name)
    end
    return propertyList
end

export remove!
function remove!(ucat::UnitCatalogue, elementName::String)
    delete!(getfield(ucat,:prefixCatalogue),elementName)
    return ucat
end

export add!
function add!(ucat::UnitCatalogue, prefix::UnitPrefix)
    _assertElementNameIsUnique(ucat,prefix.name)
    getfield(ucat,:prefixCatalogue)[prefix.name] = prefix
    return ucat
end

function _assertElementNameIsUnique(ucat::UnitCatalogue, elementName::String)
    knownElements = listUnitPrefixes(ucat)
    if Utils.isElementOf(elementName, knownElements)
        throw(Exceptions.DublicationError("catalogue already contains an element \"$elementName\""))
    end
end
