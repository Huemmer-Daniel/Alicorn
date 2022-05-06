```@meta
DocTestSetup = quote
    using Alicorn
    ucat = UnitCatalogue()
    intu = InternalUnits( length=1*ucat.milli*ucat.meter )
    mass = Quantity(2 * (ucat.kilo * ucat.gram), intu)
    acceleration = QuantityArray([10 15 20] * ucat.meter * ucat.second^-2, intu)
    force = mass * acceleration
    force2 = inUnitsOf(force, ucat.kilo * ucat.newton)
end
```

# Advanced Usage

This section demonstrates how to accomplish some typical tasks.

#### Contents

```@contents
Pages = ["advanced_usage.md"]
```

## Using Quantity Types

We can repeat a calculation similar to the basic usage example using [`Quantity`](@ref) and [`QuantityArray`](@ref). We start by choosing a set of [`InternalUnits`](@ref)

```jldoctest
julia> using Alicorn

julia> ucat = UnitCatalogue() ;

julia> intu = InternalUnits( length=1*ucat.milli*ucat.meter )
InternalUnits
 mass unit:               1 kg
 length unit:             1 mm
 time unit:               1 s
 current unit:            1 A
 temperature unit:        1 K
 amount unit:             1 mol
 luminous intensity unit: 1 cd
```
We can then define the quantities given in the problem
```jldoctest
julia> mass = Quantity(2 * (ucat.kilo * ucat.gram), intu)
Quantity{Int64} of dimension M^1 in units of (1 kg):
 2

julia> acceleration = QuantityArray([10 15 20] * ucat.meter * ucat.second^-2, intu)
1×3 QuantityMatrix{Int64} of dimension L^1 T^-2 in units of (1 mm, 1 s):
 10000  15000  20000
```
and have Julia calculate the required force:
```jldoctest
julia> force = mass * acceleration
1×3 QuantityMatrix{Int64} of dimension M^1 L^1 T^-2 in units of (1 kg, 1 mm, 1 s):
 20000  30000  40000
```
Note that the force has been expressed using the same set of [`InternalUnits`](@ref). We decide we would like to express the force in units of kilonewton
```jldoctest
julia> force2 = inUnitsOf(force, ucat.kilo * ucat.newton)
1×3 SimpleQuantityMatrix{Float64} of unit kN:
 0.02  0.03  0.04
```

## Broadcasting

Alicorn offers broadcasting for most mathematical functions available for quantities. For example,
```jldoctest
julia> force ./ force2
1×3 QuantityMatrix{Float64} of dimension 1 in units of (1):
 1.0  1.0  1.0
```

## Custom UnitCatalogue

### Empty UnitCatalogue

An empty [`UnitCatalogue`](@ref) can be initialized by explicitly passing empty
lists of prefixes and units to the constructor:
```jldoctest
julia> emptyUcat = UnitCatalogue([],[])
UnitCatalogue providing
 0 unit prefixes
 0 base units
```
Users can then fill the catalogue with custom definitions.

### Custom Prefixes

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

### Custom Units

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

### Removing a Prefix or Unit

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

### Redefining a Prefix or Unit

The names of prefixes and base units stored in a `UnitCatalogue` have to
be unique. In consequence, to redefine a prefix or unit, it first has to be
removed from the catalogue and, subsequently, the newly defined element added.


```@meta
DocTestSetup = nothing
```
