using ..Utils
using ..Exceptions

export UnitCatalogue
mutable struct UnitCatalogue
    prefixCatalogue::Dict{String, UnitPrefix}
    baseUnitCatalogue::Dict{String, BaseUnit}

    function UnitCatalogue(unitPrefixes::Vector{UnitPrefix}, baseUnits::Vector{BaseUnit})
        _assertUnitElementNamesAreUnique(unitPrefixes, baseUnits)
        unitPrefixCatalogue = _generateUnitElementCatalogueFromVector(unitPrefixes)
        baseUnitCatalogue = _generateUnitElementCatalogueFromVector(baseUnits)
        new(unitPrefixCatalogue, baseUnitCatalogue)
    end

    function UnitCatalogue(unitPrefixes::Vector, baseUnits::Vector)
        unitPrefixes = convert(Vector{UnitPrefix}, unitPrefixes)
        baseUnits = convert(Vector{BaseUnit}, baseUnits)
        UnitCatalogue(unitPrefixes, baseUnits)
    end

    function UnitCatalogue()
        unitCatalogue = initializeWithDefaultDefinitions()
        return unitCatalogue
    end
end

function _generateUnitElementCatalogueFromVector(unitElements::Vector{T}) where T <: UnitElement
    unitElementNames = _getUnitElementNames(unitElements)
    catalogue = Dict(zip(unitElementNames,unitElements))
end

function _getUnitElementNames(unitElements::Vector{T}) where T <: UnitElement
    nrOfElements = length(unitElements)
    unitElementNames = Array{String}(undef, nrOfElements)
    for (index, element) in enumerate(unitElements)
        unitElementNames[index] = element.name
    end
    return unitElementNames
end

function _assertUnitElementNamesAreUnique(unitPrefixes::Vector{UnitPrefix}, baseUnits::Vector{BaseUnit})
    allUnitElementNames = _getAllUnitElementNames(unitPrefixes, baseUnits)
    for name in allUnitElementNames
        _assertNamesIsUnique(allUnitElementNames, name)
    end
end

function _getAllUnitElementNames(unitPrefixes::Vector{UnitPrefix}, baseUnits::Vector{BaseUnit})
    unitPrefixNames = _getUnitElementNames(unitPrefixes)
    baseUnitNames = _getUnitElementNames(baseUnits)
    allUnitElementNames = [unitPrefixNames; baseUnitNames]
    return allUnitElementNames
end

function _assertNamesIsUnique(allUnitElementNames::Vector{String}, name::String)
    if Utils.occurencesIn(name, allUnitElementNames) > 1
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
    unitElementNames = vcat(prefixNames, baseUnitNames)

    propertyList = _generatePropertySymbolList(unitElementNames)
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

export add!
function add!(ucat::UnitCatalogue, prefix::UnitPrefix)
    _addUnitElement!(ucat, :prefixCatalogue, prefix)
    return ucat
end

function _addUnitElement!(ucat::UnitCatalogue, targetCatalogue::Symbol, element::UnitElement)
    _assertElementNameIsUnique(ucat, element)
    getfield(ucat, targetCatalogue)[element.name] = element
end

function _assertElementNameIsUnique(ucat::UnitCatalogue, unitElement::UnitElement)
    knownElements = _listUnitElementNames(ucat)
    if Utils.isElementOf(unitElement.name, knownElements)
        throw(Exceptions.DublicationError("catalogue already contains an element \"$(unitElement.name)\""))
    end
end

function _listUnitElementNames(ucat::UnitCatalogue)
    prefixNames = listUnitPrefixNames(ucat)
    baseUnitNames = listBaseUnitNames(ucat)
    unitElementNames = vcat(prefixNames, baseUnitNames)
    return unitElementNames
end

function add!(ucat::UnitCatalogue, baseUnit::BaseUnit)
    _addUnitElement!(ucat, :baseUnitCatalogue, baseUnit)
    return ucat
end

export remove!
function remove!(ucat::UnitCatalogue, elementName::String)
    if providesUnitPrefix(ucat, elementName)
        _removeUnitElement!(ucat, :prefixCatalogue, elementName)
    elseif providesBaseUnit(ucat, elementName)
        _removeUnitElement!(ucat, :baseUnitCatalogue, elementName)
    end
    return ucat
end

function _removeUnitElement!(ucat::UnitCatalogue, targetCatalogue::Symbol, elementName::String)
    delete!( getfield(ucat, targetCatalogue), elementName )
    return ucat
end
