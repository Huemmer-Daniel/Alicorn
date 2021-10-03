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
export InternalUnits, internalUnitForDimension

include("Quantity.jl")
include("QuantityArray.jl")
export Quantity, QuantityArray, QuantityVector, QuantityMatrix

include("quantity_dimensions.jl")
export dimensionOf
include("quantity_unitConversion.jl")
export inUnitsOf, valueInUnitsOf, inBasicSIUnits, valueOfDimensionless
include("quantity_arithmetics.jl")

end # module
