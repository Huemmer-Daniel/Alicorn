module QuantitiesTests

using Test
using ..TestingTools

include("AbstractQuantityTests.jl")
include("SimpleQuantityTests.jl")

function run()
    @testset "Quantities" begin
        AbstractQuantityTests.run()
        SimpleQuantityTests.run()
    end
end

end # module
