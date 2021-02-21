module QuantitiesTests

using Test
using ..TestingTools

include("AbstractQuantityTests.jl")
include("SimpleQuantityTests.jl")
include("InternalUnitsTests.jl")

function run()
    @testset "Quantities" begin
        AbstractQuantityTests.run()
        SimpleQuantityTests.run()
        InternalUnitsTests.run()
    end
end

end # module
