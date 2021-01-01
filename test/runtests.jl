include("TestingTools/TestingTools.jl")

include("Utils/UtilsTests.jl")
# UtilsTests.run()
#
include("Units/UnitsTests.jl")
# UnitsTests.run() TODO

include("PrettyPrinting/PrettyPrintingTests.jl")
PrettyPrintingTests.run()
