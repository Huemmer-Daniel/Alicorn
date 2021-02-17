```@meta
DocTestSetup = quote
    using Alicorn
end
```

# Advanced Usage

This section demonstrates how to accomplish some typical tasks.

#### Contents

```@contents
Pages = ["advanced_usage.md"]
```

## Empty UnitCatalogue

An empty [`UnitCatalogue`](@ref) can be initialized by explicitly passing empty
lists of prefixes and units to the constructor:
```jldoctest
julia> emptyUcat = UnitCatalogue([],[])
UnitCatalogue providing
 0 unit prefixes
 0 base units
```
Users can then fill the catalogue with custom definitions.

## Custom prefixes

As an example, we define the *dozen* as a unit prefix. The dozen is not
contained in a default [`UnitCatalogue`](@ref):
```jldoctest
julia> ucat = UnitCatalogue()
UnitCatalogue providing
 21 unit prefixes
 43 base units

julia> providesUnitPrefix(ucat, "dozen")
false
```
We define it and add it to the unit catalogue:
```jldoctest; setup = :( ucat = UnitCatalogue() )
julia> dozen = UnitPrefix( name="dozen", symbol="dz", value=12 )
UnitPrefix dozen (dz) of value 1.2e+1

julia> add!(ucat, dozen)
UnitCatalogue providing
 22 unit prefixes
 43 base units

julia> providesUnitPrefix(ucat, "dozen")
true
```

!!! info "Custom unit prefix"
    It is not required to add a new custom prefix to an existing
    `UnitCatalogue`. However, doing so is good practice since a `UnitCatalogue`
    can easily be passed to methods (brought into specific scopes) as a whole.

## Custom units

As an example, we define the international *mile*. The mile is not contained in
the default [`UnitCatalogue`](@ref):
```jldoctest
julia> ucat = UnitCatalogue()
UnitCatalogue providing
 21 unit prefixes
 43 base units

julia> providesUnitPrefix(ucat, "mile")
false
```
We define it and add it to the unit catalogue:
```jldoctest; setup = :( ucat = UnitCatalogue() )
julia> mile = BaseUnit( name="mile", symbol="mi", prefactor=1609.344, exponents=BaseUnitExponents(m=1) )
BaseUnit mile (1 mi = 1.61e+3 m)

julia> add!(ucat, mile)
UnitCatalogue providing
 21 unit prefixes
 44 base units

julia> providesBaseUnit(ucat, "mile")
true
```
!!! info "Custom base unit"
    It is not required to add a new custom base unit to an existing
    `UnitCatalogue`. However, doing so is good practice since a `UnitCatalogue`
    can easily be passed to methods (brought into specific scopes) as a whole.

## Removing a prefix or unit

Unit prefixes and named units can be removed one by one from an existing
`UnitCatalogue`:
```jldoctest
julia> ucat = UnitCatalogue()
UnitCatalogue providing
 21 unit prefixes
 43 base units

julia> providesUnitPrefix(ucat, "milli")
true

julia> remove!(ucat, "milli")
UnitCatalogue providing
 20 unit prefixes
 43 base units

julia> providesUnitPrefix(ucat, "milli")
false
```
and likewise for a unit
```jldoctest
julia> ucat = UnitCatalogue()
UnitCatalogue providing
 21 unit prefixes
 43 base units

julia> providesBaseUnit(ucat, "angstrom")
true

julia> remove!(ucat, "angstrom")
UnitCatalogue providing
 21 unit prefixes
 42 base units

julia> providesBaseUnit(ucat, "angstrom")
false
```

## Redefining a prefix or unit

The names of prefixes and base units stored in a `UnitCatalogue` have to
be unique. In consequence, to redefine a prefix or unit, it first has to be
removed from the catalogue and, subsequently, the newly defined element added.

## Custom methods for quantities

Alicorn extends a range of methods (mathematical functions, such as
multiplication) to operate on physical quantities. The available methods are
part of the interface defined by [`AbstractQuantity`](@ref), concrete
implementations are provided for the [`SimpleQuantity`](@ref) type.

Users can easily extend additional methods to work with the
[`SimpleQuantity`](@ref) type. As an example, the following listing shows how
Alicorn defines the multiplication of two [`SimpleQuantity`](@ref) objects by
extending the `Base.:*` method:
```
function Base.:*(simpleQuantity1::SimpleQuantity, simpleQuantity2::SimpleQuantity)
    productValue = simpleQuantity1.value * simpleQuantity2.value
    productUnit = simpleQuantity1.unit * simpleQuantity2.unit
    productQuantity = SimpleQuantity(productValue, productUnit)
    return productQuantity
end
```
Here, `productValue` is the product of the values of the two quantities, and
`productUnit` is the resulting unit of the product.

```@meta
DocTestSetup = nothing
```
