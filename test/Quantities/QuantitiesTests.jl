module QuantitiesTests

using Test
using ..TestingTools

include("SimpleQuantityTests.jl")
include("SimpleQuantityArrayTests.jl")

include("InternalUnitsTests.jl")
include("QuantityTests.jl")
include("QuantityArrayTests.jl")

include("quantity_typeConversionTests.jl")
include("quantity_unitConversionTests.jl")

function run()
    @testset "Quantities" begin
        # SimpleQuantityTests.run()
        # SimpleQuantityArrayTests.run()
        #
        # InternalUnitsTests.run()
        # QuantityTests.run()
        # QuantityArrayTests.run()

        quantity_typeConversionTests.run()
        # quantity_unitConversionTests.run()
    end
end

end # module
