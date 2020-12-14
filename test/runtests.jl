include("TestingTools/TestingTools.jl")

include("Utils/UtilsTests.jl")
UtilsTests.run()

include("Units/UnitPrefixTests.jl")
UnitPrefixTests.run()

include("Units/UnitCatalogueTests.jl")
UnitCatalogueTests.run()
