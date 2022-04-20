module QuantitiesTests

using Test
using ..TestingTools

include("SimpleQuantityTests.jl")
include("SimpleQuantityArrayTests.jl")

include("InternalUnitsTests.jl")
include("QuantityTests.jl")
include("QuantityArrayTests.jl")

include("quantity_dimensionsTests.jl")
include("quantity_typeConversionTests.jl")
include("quantity_unitConversionTests.jl")

include("quantity_abstractArrayTests.jl")
include("quantity_arrayBasicsTests.jl")

include("quantity_unit_arithmeticsTests.jl")
include("quantity_mathTests.jl")
include("quantity_arrayMathTests.jl")
include("quantity_broadcastingTests.jl")

function run()
    @testset "Quantities" begin
        SimpleQuantityTests.run()
        SimpleQuantityArrayTests.run()

        InternalUnitsTests.run()
        QuantityTests.run()
        QuantityArrayTests.run()

        quantity_dimensionsTests.run()
        quantity_typeConversionTests.run()
        quantity_unitConversionTests.run()

        quantity_abstractArrayTests.run()
        quantity_arrayBasicsTests.run()
        
        quantity_unit_arithmeticsTests.run()
        quantity_mathTests.run()
        quantity_arrayMathTests.run()
        quantity_broadcastingTests.run()
    end
end

end # module
