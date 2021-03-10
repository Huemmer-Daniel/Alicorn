include("TestingTools/TestingTools.jl")

include("Utils/UtilsTests.jl")
# UtilsTests.run() # TODO

include("Units/UnitsTests.jl")
# UnitsTests.run() # TODO

include("Quantities/QuantitiesTests.jl")
QuantitiesTests.run()

include("PrettyPrinting/PrettyPrintingTests.jl")
# PrettyPrintingTests.run() # TODO
