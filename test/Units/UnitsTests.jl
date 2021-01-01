module UnitsTests

using Test
using ..TestingTools

include("UnitPrefixTests.jl")
include("BaseUnitExponentsTests.jl")
include("BaseUnitTests.jl")
include("UnitFactorTests.jl")
include("UnitCatalogueTests.jl")

function run()
    @testset "Units" begin
        UnitPrefixTests.run()
        BaseUnitExponentsTests.run()
        BaseUnitTests.run()
        UnitFactorTests.run()
        UnitCatalogueTests.run()
    end
end

end # module
