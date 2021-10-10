module PrettyPrinting

using ..Utils
using ..Units
using ..Dimensions
using ..Quantities

function _addStringWithWhitespace(string, addString)
    if string != "" && string[end] != " " && addString != ""
        addString  = " " * addString
    end
    return string * addString
end

include("numbers.jl")
include("UnitPrefix.jl")
include("BaseUnitExponents.jl")
include("BaseUnit.jl")
include("UnitFactor.jl")
include("UnitCatalogue.jl")
include("Unit.jl")

include("SimpleQuantity.jl")
include("SimpleQuantityArray.jl")
include("Dimension.jl")
include("InternalUnits.jl")
include("Quantity.jl")
include("QuantityArray.jl")

end # module
