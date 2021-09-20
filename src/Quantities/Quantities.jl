module Quantities

using ..Units
using ..Exceptions

include("AbstractQuantity.jl")
include("AbstractQuantityArray.jl")

include("SimpleQuantity.jl")
include("SimpleQuantityArray.jl")

include("Dimension.jl")
include("InternalUnits.jl")
include("Quantity.jl")
include("QuantityArray.jl")

export ScalarQuantity, VectorQuantity, MatrixQuantity, ArrayQuantity
ScalarQuantity{T} = Union{T, AbstractQuantity{T}} where T<:Number
VectorQuantity{T} = Union{Vector{T}, AbstractQuantityArray{T, 1}} where T<:Number
MatrixQuantity{T} = Union{Matrix{T}, AbstractQuantityArray{T, 2}} where T<:Number
ArrayQuantity{T} = Union{Array{T}, AbstractQuantityArray{T}} where T<:Number

include("unitConversion.jl")
include("arithmetics.jl")


end
