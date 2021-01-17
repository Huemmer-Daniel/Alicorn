module PrettyPrinting

using ..Units
using ..Utils

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

end # module
