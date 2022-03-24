module Units

using ..Dimensions

include("AbstractUnitElement.jl")
export AbstractUnitElement

include("UnitPrefix.jl")
export UnitPrefix
# not exported by Alicorn
export emptyUnitPrefix, kilo

include("AbstractUnit.jl")
export AbstractUnit, convertToUnit, convertToBasicSI, convertToBasicSIAsExponents

include("BaseUnitExponents.jl")
export BaseUnitExponents, convertToUnit

include("BaseUnit.jl")
export BaseUnit
# not exported by Alicorn
export unitlessBaseUnit, gram, meter, second, ampere, kelvin, mol, candela

include("UnitFactorElement.jl")
export UnitFactorElement

include("UnitFactor.jl")
export UnitFactor
 # not exported by Alicorn
export unitlessUnitFactor, kilogram

include("UnitCatalogue.jl")
export UnitCatalogue, listUnitPrefixes, listBaseUnits, listUnitPrefixNames,
    listBaseUnitNames, providesUnitPrefix, providesBaseUnit, add!, remove!

include("unitCatalogueInitialization.jl")

include("Unit.jl")
export Unit
# not exported by Alicorn
export unitlessUnit

include("unit_dimensions.jl")

end # module
