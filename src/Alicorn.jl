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

include("Dimensions/Dimensions.jl")
using .Dimensions

export Dimension

include("Quantities/Quantities.jl")
using .Quantities

export AbstractQuantity, AbstractQuantityArray, AbstractQuantityVector, AbstractQuantityMatrix
export ScalarQuantity, VectorQuantity, MatrixQuantity, ArrayQuantity
export SimpleQuantity, SimpleQuantityArray, SimpleQuantityVector, SimpleQuantityMatrix
export InternalUnits, internalUnitForDimension
export Quantity, QuantityArray, QuantityVector, QuantityMatrix
export dimensionOf
export inUnitsOf, valueInUnitsOf, inBasicSIUnits, valueOfDimensionless

include("PrettyPrinting/PrettyPrinting.jl")

end # module
