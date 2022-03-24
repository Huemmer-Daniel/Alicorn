module Dimensions

using ..Exceptions

include("Dimension.jl")
export Dimension, dimensionOf

include("dimension_arithmetics.jl")

end # module
