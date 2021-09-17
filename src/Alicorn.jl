module Alicorn

include("Utils/Utils.jl")

include("Exceptions/Exceptions.jl")

include("Units/Units.jl")
using .Units

export AbstractUnitElement

export AbstractUnit
export convertToUnit
export convertToBasicSI
export convertToBasicSIAsExponents

export UnitElement
export UnitPrefix
export BaseUnitExponents
export BaseUnit
export UnitFactorElement
export UnitFactor
export Unit

export UnitCatalogue
export listUnitPrefixes
export listBaseUnits
export listUnitPrefixNames
export listBaseUnitNames
export providesUnitPrefix
export providesBaseUnit
export remove!
export add!

export inv

include("Quantities/Quantities.jl")
using .Quantities

export AbstractQuantity
export AbstractQuantityArray
export AbstractQuantityVector
export AbstractQuantityMatrix
export SimpleQuantity
export SimpleQuantityArray
export SimpleQuantityVector
export SimpleQuantityMatrix
export valueOfDimensionless
export inUnitsOf
export inBasicSIUnits
export valueInUnitsOf

export Dimension
export dimensionOf

export InternalUnits

export Quantity

export ScalarQuantity, VectorQuantity, MatrixQuantity, ArrayQuantity

include("PrettyPrinting/PrettyPrinting.jl")

end # module
