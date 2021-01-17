module UnitsTests

using Test
using ..TestingTools

include("UnitPrefixTests.jl")
include("AbstractUnitTests.jl")
include("BaseUnitExponentsTests.jl")
include("BaseUnitTests.jl")
include("UnitFactorTests.jl")
include("UnitCatalogueTests.jl")
include("UnitTests.jl")

function run()
    @testset "Units" begin
        UnitPrefixTests.run()
        AbstractUnitTests.run()
        BaseUnitExponentsTests.run()
        BaseUnitTests.run()
        UnitFactorTests.run()
        UnitCatalogueTests.run()
        UnitTests.run()
    end
end

end # module
