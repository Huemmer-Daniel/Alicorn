module Alicorn

include("Utils/Utils.jl")

include("Exceptions/Exceptions.jl")

include("Units/Units.jl")
using .Units
export UnitPrefix

export BaseUnit
export BaseUnitExponents

export UnitCatalogue
export providesUnitPrefix
export listUnitPrefixes
export remove!
export add!

include("PrettyPrinting/PrettyPrinting.jl")

end # module
