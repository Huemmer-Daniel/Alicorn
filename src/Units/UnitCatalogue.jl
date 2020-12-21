using ..Utils
using ..Exceptions

export UnitCatalogue
mutable struct UnitCatalogue
    prefixCatalogue::Dict{String,UnitPrefix}

    function UnitCatalogue(; addDefaultDefinitions = true)
        unitCatalogue = new(Dict())
        if addDefaultDefinitions
            initializeDefaultDefinitions!(unitCatalogue)
        end
        return unitCatalogue
    end
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
