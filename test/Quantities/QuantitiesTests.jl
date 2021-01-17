module QuantitiesTests

using Test
using ..TestingTools

include("SimpleQuantityTests.jl")

function run()
    @testset "Quantities" begin
        SimpleQuantityTests.run()
    end
end

end # module
