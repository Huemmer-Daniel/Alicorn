module QuantitiesTests

using Test
using ..TestingTools

include("AbstractQuantityTests.jl")
include("AbstractQuantityArrayTests.jl")

include("SimpleQuantityTests.jl")
include("SimpleQuantityArrayTests.jl")

include("InternalUnitsTests.jl")
include("DimensionTests.jl")
include("QuantityTests.jl")

function run()
    @testset "Quantities" begin
        # AbstractQuantityTests.run() TODO
        # AbstractQuantityArrayTests.run()
        #
        # SimpleQuantityTests.run()
        SimpleQuantityArrayTests.run()

        # InternalUnitsTests.run()
        # DimensionTests.run()
        # QuantityTests.run()
    end
end

end # module
