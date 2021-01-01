module Alicorn

include("Utils/Utils.jl")

include("Exceptions/Exceptions.jl")

include("Units/Units.jl")
using .Units

export UnitElement
export UnitPrefix
export BaseUnitExponents
export BaseUnit

export UnitCatalogue
export listUnitPrefixes
export listBaseUnits
export listUnitPrefixNames
export listBaseUnitNames
export providesUnitPrefix
export providesBaseUnit
export remove!
export add!

include("PrettyPrinting/PrettyPrinting.jl")

end # module
