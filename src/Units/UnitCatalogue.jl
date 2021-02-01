using ..Utils
using ..Exceptions

export UnitCatalogue
"""
    UnitCatalogue

TODO
"""
mutable struct UnitCatalogue
    prefixCatalogue::Dict{String, UnitPrefix}
    baseUnitCatalogue::Dict{String, BaseUnit}

    function UnitCatalogue(unitPrefixes::Vector{UnitPrefix}, baseUnits::Vector{BaseUnit})
        _assertUnitFactorElementNamesAreUnique(unitPrefixes, baseUnits)
        unitPrefixCatalogue = _generateUnitFactorElementCatalogueFromVector(unitPrefixes)
        baseUnitCatalogue = _generateUnitFactorElementCatalogueFromVector(baseUnits)
        return new(unitPrefixCatalogue, baseUnitCatalogue)
    end
end

function UnitCatalogue(unitPrefixes::Vector, baseUnits::Vector)
    unitPrefixes = convert(Vector{UnitPrefix}, unitPrefixes)
    baseUnits = convert(Vector{BaseUnit}, baseUnits)
    return UnitCatalogue(unitPrefixes, baseUnits)
end

function UnitCatalogue()
    unitCatalogue = initializeWithDefaultDefinitions()
    return unitCatalogue
end

function _generateUnitFactorElementCatalogueFromVector(unitFactorElements::Vector{T}) where T <: UnitFactorElement
    unitFactorElementNames = _getUnitFactorElementNames(unitFactorElements)
    catalogue = Dict(zip(unitFactorElementNames,unitFactorElements))
end

function _getUnitFactorElementNames(unitFactorElements::Vector{T}) where T <: UnitFactorElement
    nrOfElements = length(unitFactorElements)
    unitFactorElementNames = Array{String}(undef, nrOfElements)
    for (index, element) in enumerate(unitFactorElements)
        unitFactorElementNames[index] = element.name
    end
    return unitFactorElementNames
end

function _assertUnitFactorElementNamesAreUnique(unitPrefixes::Vector{UnitPrefix}, baseUnits::Vector{BaseUnit})
    allUnitFactorElementNames = _getAllUnitFactorElementNames(unitPrefixes, baseUnits)
    for name in allUnitFactorElementNames
        _assertNamesIsUnique(allUnitFactorElementNames, name)
    end
end

function _getAllUnitFactorElementNames(unitPrefixes::Vector{UnitPrefix}, baseUnits::Vector{BaseUnit})
    unitPrefixNames = _getUnitFactorElementNames(unitPrefixes)
    baseUnitNames = _getUnitFactorElementNames(baseUnits)
    allUnitFactorElementNames = [unitPrefixNames; baseUnitNames]
    return allUnitFactorElementNames
end

function _assertNamesIsUnique(allUnitFactorElementNames::Vector{String}, name::String)
    if Utils.occurencesIn(name, allUnitFactorElementNames) > 1
        throw(Exceptions.DublicationError("names of unit elements have to be unique"))
    end
end

export listUnitPrefixes
function listUnitPrefixes(unitCatalogue::UnitCatalogue)
    return getfield(unitCatalogue, :prefixCatalogue)
end

export listBaseUnits
function listBaseUnits(unitCatalogue::UnitCatalogue)
    return getfield(unitCatalogue, :baseUnitCatalogue)
end

export listUnitPrefixNames
function listUnitPrefixNames(unitCatalogue::UnitCatalogue)
    knownPrefixesDict = listUnitPrefixes(unitCatalogue)
    knownPrefixNames = collect(keys(knownPrefixesDict))
    return sort!(knownPrefixNames)
end

export listBaseUnitNames
function listBaseUnitNames(unitCatalogue::UnitCatalogue)
    knownBaseUnitsDict = listBaseUnits(unitCatalogue)
    knownBaseUnitsNames = collect(keys(knownBaseUnitsDict))
    return sort!(knownBaseUnitsNames)
end

export providesUnitPrefix
function providesUnitPrefix(unitCatalogue::UnitCatalogue, name::String)
    return Utils.isElementOf(name, listUnitPrefixNames(unitCatalogue))
end

export providesBaseUnit
function providesBaseUnit(unitCatalogue::UnitCatalogue, name::String)
    return Utils.isElementOf(name, listBaseUnitNames(unitCatalogue))
end

function Base.getproperty(unitCatalogue::UnitCatalogue, symbol::Symbol)
    name = String(symbol)
    if providesUnitPrefix(unitCatalogue, name)
        return getfield(unitCatalogue,:prefixCatalogue)[name]
    elseif providesBaseUnit(unitCatalogue, name)
        return getfield(unitCatalogue,:baseUnitCatalogue)[name]
    else
        throw(KeyError(name))
    end
end

function Base.propertynames(unitCatalogue::UnitCatalogue)
    prefixNames = listUnitPrefixNames(unitCatalogue)
    baseUnitNames = listBaseUnitNames(unitCatalogue)
    unitFactorElementNames = vcat(prefixNames, baseUnitNames)

    propertyList = _generatePropertySymbolList(unitFactorElementNames)
    return propertyList
end

function _generatePropertySymbolList(unitFactorElementNames::Vector{String})
    sort!(unitFactorElementNames)
    nrOfProperties = length(unitFactorElementNames)
    propertyList = Array{Symbol}(undef,nrOfProperties)
    for (index, name) in enumerate(unitFactorElementNames)
        propertyList[index] = Symbol(name)
    end
    return propertyList
end

export add!
function add!(ucat::UnitCatalogue, prefix::UnitPrefix)
    _addUnitFactorElement!(ucat, :prefixCatalogue, prefix)
    return ucat
end

function _addUnitFactorElement!(ucat::UnitCatalogue, targetCatalogue::Symbol, element::UnitFactorElement)
    _assertElementNameIsUnique(ucat, element)
    getfield(ucat, targetCatalogue)[element.name] = element
end

function _assertElementNameIsUnique(ucat::UnitCatalogue, unitFactorElement::UnitFactorElement)
    knownElements = _listUnitFactorElementNames(ucat)
    if Utils.isElementOf(unitFactorElement.name, knownElements)
        throw(Exceptions.DublicationError("catalogue already contains an element \"$(unitFactorElement.name)\""))
    end
end

function _listUnitFactorElementNames(ucat::UnitCatalogue)
    prefixNames = listUnitPrefixNames(ucat)
    baseUnitNames = listBaseUnitNames(ucat)
    unitFactorElementNames = vcat(prefixNames, baseUnitNames)
    return unitFactorElementNames
end

function add!(ucat::UnitCatalogue, baseUnit::BaseUnit)
    _addUnitFactorElement!(ucat, :baseUnitCatalogue, baseUnit)
    return ucat
end

export remove!
function remove!(ucat::UnitCatalogue, elementName::String)
    if providesUnitPrefix(ucat, elementName)
        _removeUnitFactorElement!(ucat, :prefixCatalogue, elementName)
    elseif providesBaseUnit(ucat, elementName)
        _removeUnitFactorElement!(ucat, :baseUnitCatalogue, elementName)
    end
    return ucat
end

function _removeUnitFactorElement!(ucat::UnitCatalogue, targetCatalogue::Symbol, elementName::String)
    delete!( getfield(ucat, targetCatalogue), elementName )
    return ucat
end
