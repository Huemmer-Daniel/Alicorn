using ..Utils
using ..Exceptions

export UnitCatalogue
@doc raw"""
    UnitCatalogue

Collection of [`UnitFactorElement`](@ref) objects. These include unit prefixes of type [`UnitPrefix`](@ref) and named units of type [`BaseUnit`](@ref).

A single `UnitCatalogue` object serves as a consistent library of unit elements.
Users can construct composite units based on the prefix and unit
definitions stored in the unit catalogue. In most use cases, it is sufficient to
initialize a single unit catalogue using `UnitCatalogue()`. The returned
catalogue contains the unit prefixes and named units accepted for use with the
International System of Units.

Unit prefixes and base units stored in a unit catalogue can be accessed using
dot notation through [`Base.getproperty`](@ref) using their `name` field. In
consequence, the names of elements stored in the unit catalogue have to be
unique.

# Fields

The fields of `UnitCatalogue` are not considered part of the public interface
and cannot be accessed using the dot notation. The stored [`UnitFactorElement`](@ref)
objects can be accessed through the following methods:

- [`Base.getproperty(unitCatalogue::UnitCatalogue, symbol::Symbol)`](@ref)
- [`listUnitPrefixes(unitCatalogue::UnitCatalogue)`](@ref)
- [`listBaseUnits(unitCatalogue::UnitCatalogue)`](@ref)
- [`listUnitPrefixNames(unitCatalogue::UnitCatalogue)`](@ref)
- [`listBaseUnitNames(unitCatalogue::UnitCatalogue)`](@ref)
- [`providesUnitPrefix(unitCatalogue::UnitCatalogue, symbol::String)`](@ref)
- [`providesBaseUnit(unitCatalogue::UnitCatalogue, symbol::String)`](@ref)
- [`add!(unitCatalogue::UnitCatalogue, unitPrefix::UnitPrefix)`](@ref)
- [`add!(unitCatalogue::UnitCatalogue, baseUnit::BaseUnit)`](@ref)
- [`remove!(unitCatalogue::UnitCatalogue, elementName::String)`](@ref)

# Constructors
```
UnitCatalogue(unitPrefixes::Vector{UnitPrefix}, baseUnits::Vector{BaseUnit})
UnitCatalogue(unitPrefixes::Vector, baseUnits::Vector)
UnitCatalogue()
```

# Raises exceptions
- `Alicorn.Exceptions.DuplicationError`: if attempting to add [`UnitFactorElement`](@ref)
  objects with identical `name` fields to the `UnitCatalogue`

# Remarks
If vectors of types other than [`UnitPrefix`](@ref) and [`BaseUnit`](@ref) are provided, the
constructor attempts to convert them to those types.

If the constructor is invoked without arguments, the default set of unit prefix
and base unit definitions is added to the `UnitCatalogue`.

# Examples
1. Initialize a default unit catalogue (containing the standard unit prefixes
   and named units accepted for use with the International System of Units) and
   use it to define the unit ``\mathrm{nm}`` (nanometer):
   ```jldoctest
   julia> ucat = UnitCatalogue()
   UnitCatalogue providing
    21 unit prefixes
    43 base units
   julia> nm = ucat.nano * ucat.meter
   UnitFactor nm
   ```
2. Initialize an empty unit catalogue (to be filled with custom prefix and unit
   definitions) and add new prefix with name `nano`:
   ```jldoctest
   julia> ucat = UnitCatalogue([], [])
   UnitCatalogue providing
    0 unit prefixes
    0 base units
   julia> nano = UnitPrefix(name="nano", symbol="n", value=1e-9)
   UnitPrefix nano (n) of value 1e-9
   julia> add!(ucat, nano)
   UnitCatalogue providing
    1 unit prefixes
    0 base units
   julia> ucat.nano
   UnitPrefix nano (n) of value 1e-9
   ```
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

## Outer constructors

function UnitCatalogue(unitPrefixes::Vector, baseUnits::Vector)
    unitPrefixes = convert(Vector{UnitPrefix}, unitPrefixes)
    baseUnits = convert(Vector{BaseUnit}, baseUnits)
    return UnitCatalogue(unitPrefixes, baseUnits)
end

# documented in the type definition
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
        throw(Exceptions.DuplicationError("names of unit elements have to be unique"))
    end
end

## Extend methods for accessing properties of UnitCatalogue

"""
    Base.getproperty(unitCatalogue::UnitCatalogue, symbol::Symbol)

Access a [`UnitFactorElement`](@ref) stored in `unitCatalogue` through
its name using the dot notation.

# Raises Exception
- `Base.KeyError`: if attempting to access a non-existent element

# Examples
```@jldoctest
julia> ucat = UnitCatalogue() ;

julia> ucat.peta
UnitPrefix peta (P) of value 1e+15
julia> ucat.ohm
BaseUnit ohm (1 Ω = 1 kg m^2 s^-3 A^-2)
```
"""
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

"""
    Base.propertynames(unitCatalogue::UnitCatalogue)

List the names of [`UnitFactorElement`](@ref) objects stored in `unitCatalogue`
as `Symbol` objects.

This method is called to provide tab completion in the REPL.
"""
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


## Methods

export listUnitPrefixes
"""
    listUnitPrefixes(unitCatalogue::UnitCatalogue)

Return a dictionary indexing the [`UnitPrefix`](@ref) objects stored in `unitCatalogue` by
their name.

# Example

```@jldoctest
julia> ucat = UnitCatalogue() ;

julia> prefixes = listUnitPrefixes(ucat) ;

julia> prefixes["micro"]
UnitPrefix micro (μ) of value 1e-6
```
"""
function listUnitPrefixes(unitCatalogue::UnitCatalogue)
    return getfield(unitCatalogue, :prefixCatalogue)
end

export listBaseUnits
"""
    listBaseUnits(unitCatalogue::UnitCatalogue)

Return a dictionary indexing the [`BaseUnit`](@ref) objects stored in `unitCatalogue` by
their name.

# Example

```@jldoctest
julia> ucat = UnitCatalogue() ;

julia> baseUnits = listBaseUnits(ucat) ;

julia> baseUnits["siemens"]
BaseUnit siemens (1 S = 1 kg^-1 m^-2 s^3 A^2)
```
"""
function listBaseUnits(unitCatalogue::UnitCatalogue)
    return getfield(unitCatalogue, :baseUnitCatalogue)
end

export listUnitPrefixNames
"""
    listUnitPrefixNames(unitCatalogue::UnitCatalogue)

List the names of the [`UnitPrefix`](@ref) objects stored in `unitCatalogue` as a `Vector{String}`.
"""
function listUnitPrefixNames(unitCatalogue::UnitCatalogue)
    knownPrefixesDict = listUnitPrefixes(unitCatalogue)
    knownPrefixNames = collect(keys(knownPrefixesDict))
    return sort!(knownPrefixNames)
end

export listBaseUnitNames
"""
    listBaseUnitNames(unitCatalogue::UnitCatalogue)

List the names of the [`BaseUnit`](@ref) objects stored in `unitCatalogue` as a `Vector{String}`.
"""
function listBaseUnitNames(unitCatalogue::UnitCatalogue)
    knownBaseUnitsDict = listBaseUnits(unitCatalogue)
    knownBaseUnitsNames = collect(keys(knownBaseUnitsDict))
    return sort!(knownBaseUnitsNames)
end

export providesUnitPrefix
"""
    providesUnitPrefix(unitCatalogue::UnitCatalogue, name::String)

Check if a [`UnitPrefix`](@ref) with name `name` is stored in `unitCatalogue`.

# Output
`::Bool`
"""
function providesUnitPrefix(unitCatalogue::UnitCatalogue, name::String)
    return Utils.isElementOf(name, listUnitPrefixNames(unitCatalogue))
end

export providesBaseUnit
"""
    providesBaseUnit(unitCatalogue::UnitCatalogue, name::String)

Check if a [`BaseUnit`](@ref) with name `name` is stored in `unitCatalogue`.

# Output
`::Bool`
"""
function providesBaseUnit(unitCatalogue::UnitCatalogue, name::String)
    return Utils.isElementOf(name, listBaseUnitNames(unitCatalogue))
end

export add!
"""
    add!(unitCatalogue::UnitCatalogue, unitPrefix::UnitPrefix)
    add!(unitCatalogue::UnitCatalogue, baseUnit::BaseUnit)

Add a [`UnitFactorElement`](@ref) to `unitCatalogue`.

No element with the same name as the element to add may already exist in `unitCatalogue`.

# Raises Exception
- `Alicorn.Exceptions.DuplicationError`: if a [`UnitFactorElement`](@ref) carrying the
  same `name` field as the element to add already exists in `unitCatalogue`.
"""
function add!(unitCatalogue::UnitCatalogue, unitPrefix::UnitPrefix)
    _addUnitFactorElement!(unitCatalogue, :prefixCatalogue, unitPrefix)
    return unitCatalogue
end

function _addUnitFactorElement!(unitCatalogue::UnitCatalogue, targetCatalogue::Symbol, element::UnitFactorElement)
    _assertElementNameIsUnique(unitCatalogue, element)
    getfield(unitCatalogue, targetCatalogue)[element.name] = element
end

function _assertElementNameIsUnique(unitCatalogue::UnitCatalogue, unitFactorElement::UnitFactorElement)
    knownElements = _listUnitFactorElementNames(unitCatalogue)
    if Utils.isElementOf(unitFactorElement.name, knownElements)
        throw(Exceptions.DuplicationError("catalogue already contains an element \"$(unitFactorElement.name)\""))
    end
end

function _listUnitFactorElementNames(unitCatalogue::UnitCatalogue)
    prefixNames = listUnitPrefixNames(unitCatalogue)
    baseUnitNames = listBaseUnitNames(unitCatalogue)
    unitFactorElementNames = vcat(prefixNames, baseUnitNames)
    return unitFactorElementNames
end

# documented together with add!(unitCatalogue::UnitCatalogue, prefix::UnitPrefix)
function add!(unitCatalogue::UnitCatalogue, baseUnit::BaseUnit)
    _addUnitFactorElement!(unitCatalogue, :baseUnitCatalogue, baseUnit)
    return unitCatalogue
end

export remove!
"""
    remove!(unitCatalogue::UnitCatalogue, name::String)

Remove the [`UnitFactorElement`](@ref) object of name `name` from `unitCatalogue`.

# Raises Exception
- `Base.KeyError`: if attempting to delete a non-existent element
"""
function remove!(unitCatalogue::UnitCatalogue, name::String)
    if providesUnitPrefix(unitCatalogue, name)
        _removeUnitFactorElement!(unitCatalogue, :prefixCatalogue, name)
    elseif providesBaseUnit(unitCatalogue, name)
        _removeUnitFactorElement!(unitCatalogue, :baseUnitCatalogue, name)
    else
        throw(KeyError(name))
    end
    return unitCatalogue
end

function _removeUnitFactorElement!(unitCatalogue::UnitCatalogue, targetCatalogue::Symbol, elementName::String)
    delete!( getfield(unitCatalogue, targetCatalogue), elementName )
    return unitCatalogue
end
