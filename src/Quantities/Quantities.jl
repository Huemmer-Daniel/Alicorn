module Quantities

using ..Exceptions
using ..Dimensions
using ..Units

include("AbstractQuantity.jl")
include("AbstractQuantityArray.jl")
export AbstractQuantity, AbstractQuantityArray, AbstractQuantityVector, AbstractQuantityMatrix, AbstractQuantityType,
    DimensionlessType
export ScalarQuantity, VectorQuantity, MatrixQuantity, ArrayQuantity

include("SimpleQuantity.jl")
include("SimpleQuantityArray.jl")
export SimpleQuantity, SimpleQuantityArray, SimpleQuantityVector, SimpleQuantityMatrix, SimpleQuantityType

include("InternalUnits.jl")
export InternalUnits, internalUnitFor, conversionFactor

include("Quantity.jl")
include("QuantityArray.jl")
export Quantity, QuantityArray, QuantityVector, QuantityMatrix, QuantityType

include("quantity_dimensions.jl")
include("quantity_typeConversion.jl")
include("quantity_unitConversion.jl")
export inUnitsOf, valueInUnitsOf, inInternalUnitsOf, inBasicSIUnits, valueOfDimensionless

include("quantity_abstractArray.jl")
include("quantity_arrayBasics.jl")

include("quantity_unit_arithmetics.jl")
include("quantity_math.jl")
include("quantity_arrayMath.jl")
include("quantity_broadcasting.jl")

const defaultInternalUnits = InternalUnits()
const dimensionless = Dimension()

end # module
