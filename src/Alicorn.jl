module Alicorn

include("Utils/Utils.jl")

include("Exceptions/Exceptions.jl")

include("Dimensions/Dimensions.jl")
using .Dimensions

export Dimension, dimensionOf

include("Units/Units.jl")
using .Units

export AbstractUnitElement
export UnitPrefix
export AbstractUnit, convertToUnit, convertToBasicSI,
    convertToBasicSIAsExponents
export BaseUnitExponents, convertToUnit
export BaseUnit
export UnitFactorElement
export UnitFactor
export UnitCatalogue, listUnitPrefixes, listBaseUnits, listUnitPrefixNames,
    listBaseUnitNames, providesUnitPrefix, providesBaseUnit, add!, remove!

export Unit

include("Quantities/Quantities.jl")
using .Quantities

export AbstractQuantity, AbstractQuantityArray, AbstractQuantityVector,
    AbstractQuantityMatrix
export ScalarQuantity, VectorQuantity, MatrixQuantity, ArrayQuantity
export SimpleQuantity, SimpleQuantityArray, SimpleQuantityVector,
    SimpleQuantityMatrix
export InternalUnits, internalUnitFor, conversionFactor
export Quantity, QuantityArray, QuantityVector, QuantityMatrix
export inUnitsOf, valueInUnitsOf, inInternalUnitsOf, inBasicSIUnits,
    valueOfDimensionless

include("PrettyPrinting/PrettyPrinting.jl")

end # module
