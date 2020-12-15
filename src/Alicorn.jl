module Alicorn

include("Utils/Utils.jl")

include("Exceptions/Exceptions.jl")

include("Units/Units.jl")
using .Units
export UnitPrefix

export UnitAtom
export UnitAtomExponents

export UnitCatalogue
export providesUnitPrefix
export listUnitPrefixes
export remove!
export add!

end # module
