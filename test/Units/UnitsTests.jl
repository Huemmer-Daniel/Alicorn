module UnitsTests

using Test

include("UnitPrefixTests.jl")
include("UnitAtomTests.jl")
include("UnitCatalogueTests.jl")

function run()
    @testset "Units" begin
        UnitPrefixTests.run()
        UnitAtomTests.run()
        UnitCatalogueTests.run()
    end
end

end # module
