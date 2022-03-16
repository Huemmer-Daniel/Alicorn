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


const SimpleQuantityType = Union{SimpleQuantity, SimpleQuantityArray}
const QuantityType = Union{Quantity, QuantityArray}
const DimensionlessType = Union{Number, AbstractArray{<:Number}}

include("quantity_dimensions.jl")
export dimensionOf
include("quantity_typeConversion.jl")
include("quantity_unitConversion.jl")
export inUnitsOf, valueInUnitsOf, inInternalUnitsOf, inBasicSIUnits, valueOfDimensionless

include("quantity_basics.jl") # needs testing
include("quantity_abstractArray.jl")
include("quantity_arrayBasics.jl") # needs implementing and testing

include("quantity_math.jl") # needs implementing and testing
include("quantity_unit_arithmetics.jl") # needs implementing and testing
include("quantity_broadcasting.jl") # needs testing

const dimensionless = Dimension()
const defaultInternalUnits = InternalUnits()


end # module
