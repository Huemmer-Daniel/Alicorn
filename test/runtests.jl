include("TestingTools/TestingTools.jl")

include("Utils/UtilsTests.jl")
UtilsTests.run()

include("Units/UnitsTests.jl")
UnitsTests.run()

include("Quantities/QuantitiesTests.jl")
QuantitiesTests.run()

include("PrettyPrinting/PrettyPrintingTests.jl")
PrettyPrintingTests.run()
