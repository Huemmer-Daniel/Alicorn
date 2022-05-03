```@meta
DocTestSetup = quote
    using Alicorn
    ucat = UnitCatalogue()
    mass = 2 * (ucat.kilo * ucat.gram)
    acceleration = 10 * ucat.meter * ucat.second^-2
    force = mass * acceleration
    height = 230 * ( ucat.centi * ucat.meter )
    energy = force * height
    energy_kJ = inUnitsOf(energy, ucat.kilo * ucat.joule)
    noseHeight = 1.7 * ucat.meter
    dropDistance = height - noseHeight
    energyToNose = force * dropDistance
end
```

# Basic Usage

As an examples, let us consider a rock of mass ``m = 2\,\mathrm{kg}``. We know that on earth, a force of ``F = m g`` is required to lift the rock, where approximately ``g = 10\,\mathrm{m/s^2}``. We would like to use Julia with the Alicorn module to calculate the energy ``E = Fh`` we have to invest to raise the rock above our heads to a height of ``h = 230\,\mathrm{cm}``. Alicorn comes with a wide range of predefined units and unit prefixes compatible with the International System of Units. To access them, we load Alicorn and start by initializing a default [`UnitCatalogue`](@ref):
```jldoctest
julia> using Alicorn

julia> ucat = UnitCatalogue()
UnitCatalogue providing
 21 unit prefixes
 43 base units
```
We can then define the quantities given in the problem
```jldoctest
julia> mass = 2 * (ucat.kilo * ucat.gram)
2 kg

julia> acceleration = 10 * ucat.meter * ucat.second^-2
10 m s^-2
```
and have Julia calculate the required force:
```jldoctest
julia> force = mass * acceleration
20 kg m s^-2
```
Note that Alicorn made no assumption about the unit we would like to express the energy in. Instead, it simply combined the units by multiplying them. We decide we would like to express the force in units of kilonewton
```jldoctest
julia> inUnitsOf(force, ucat.kilo * ucat.newton)
0.02 kN
```
and the resulting energy in units of joule:
```jldoctest
julia> energy = force * height
4600 kg m s^-2 cm

julia> inUnitsOf(energy, ucat.joule)
46 J
```
Now, while we are holding the rock up there, we wonder what would happen if we were to accidentally drop it on our nose. Assuming that our nose is ``h_n = 1.7\,\mathrm{m}`` above the ground, we can calculate the energy transferred after a drop of height ``h - h_n`` as follows:
```jldoctest
julia> noseHeight = 1.7 * ucat.meter
1.7 m

julia> dropDistance = height - noseHeight
60.0 cm

julia> energyToNose = force * dropDistance
1200.0 kg m s^-2 cm

julia> inUnitsOf(energyToNose, ucat.joule)
12.0 J
```
Note that Alicorn used the unit of `height` to express the quantity `dropDistance` resulting from taking the difference.

Finally, let us check how the transferred energy compares to the rest energy of an electron-positron pair. We recall that the rest energy of an electron-positron pair is around ``E_p = 1022\,\mathrm{MeV}`` and express our results in the according unit:
```jldoctest
julia> inUnitsOf(energyToNose, ucat.mega * ucat.electronvolt)
7.489810889352916e13 MeV
```

```@meta
DocTestSetup = nothing
```
