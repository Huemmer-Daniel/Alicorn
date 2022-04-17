module Quantities

using ..Exceptions
using ..Dimensions
using ..Units

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
const AbstractQuantityType = Union{AbstractQuantity, AbstractQuantityArray}
const DimensionlessType = Union{Number, AbstractArray{<:Number}}

include("quantity_dimensions.jl")
include("quantity_typeConversion.jl")
include("quantity_unitConversion.jl")
export inUnitsOf, valueInUnitsOf, inInternalUnitsOf, inBasicSIUnits, valueOfDimensionless

include("quantity_objectBasics.jl")
include("quantity_abstractArray.jl")
include("quantity_arrayBasics.jl")
include("quantity_collectionBasics.jl")

include("quantity_unit_arithmetics.jl")
include("quantity_math.jl")
include("quantity_arrayMath.jl")
include("quantity_broadcasting.jl") # TODO needs testing

const defaultInternalUnits = InternalUnits()
const dimensionless = Dimension()

end # module
