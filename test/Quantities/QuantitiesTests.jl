module QuantitiesTests

using Test
using ..TestingTools

include("AbstractQuantityTests.jl")
include("AbstractQuantityArrayTests.jl")

include("SimpleQuantityTests.jl")
include("SimpleQuantityArrayTests.jl")

include("InternalUnitsTests.jl")
include("QuantityTests.jl")
include("QuantityArrayTests.jl")

function run()
    @testset "Quantities" begin
        # AbstractQuantityTests.run()
        # AbstractQuantityArrayTests.run()

        # SimpleQuantityTests.run()
        # SimpleQuantityArrayTests.run()

        # InternalUnitsTests.run()
        QuantityTests.run()
        # QuantityArrayTests.run()
    end
end

end # module
