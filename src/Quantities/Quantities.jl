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

end
