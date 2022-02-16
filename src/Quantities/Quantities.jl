module Quantities

using ..Exceptions
using ..Units
using ..Dimensions

include("AbstractQuantity.jl")
include("AbstractQuantityArray.jl")
export AbstractQuantity, AbstractQuantityArray, AbstractQuantityVector, AbstractQuantityMatrix
export ScalarQuantity, VectorQuantity, MatrixQuantity, ArrayQuantity

include("SimpleQuantity.jl")
include("SimpleQuantityArray.jl")
export SimpleQuantity, SimpleQuantityArray, SimpleQuantityVector, SimpleQuantityMatrix

include("InternalUnits.jl")
export InternalUnits, internalUnitFor, conversionFactor

include("Quantity.jl")
include("QuantityArray.jl")
export Quantity, QuantityArray, QuantityVector, QuantityMatrix

include("quantity_dimensions.jl")
export dimensionOf
include("quantity_typeConversion.jl")
include("quantity_unitConversion.jl")
export inUnitsOf, valueInUnitsOf, inInternalUnitsOf, inBasicSIUnits, valueOfDimensionless
include("quantity_unit_arithmetics.jl")

include("quantity_arithmetics.jl")

const defaultInternalUnits = InternalUnits()
const dimensionless = Dimension()

end # module
