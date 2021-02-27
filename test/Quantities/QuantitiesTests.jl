module QuantitiesTests

using Test
using ..TestingTools

include("AbstractQuantityTests.jl")
include("SimpleQuantityTests.jl")
include("InternalUnitsTests.jl")
include("DimensionTests.jl")

function run()
    @testset "Quantities" begin
        AbstractQuantityTests.run()
        SimpleQuantityTests.run()
        InternalUnitsTests.run()
        DimensionTests.run()
    end
end

end # module
