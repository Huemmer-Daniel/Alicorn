module SimpleQuantityArrayTests

using Alicorn
using Test
using ..TestingTools

const ucat = UnitCatalogue()

function run()
    @testset "SimpleQuantityArray" begin

        # Constructors
        @test canInstanciateSQArrayWithRealArray()
        @test canInstanciateSQArrayWithComplexArray()
        @test canInstanciateSQArraWithBaseUnit()
        @test canInstanciateSQArraWithUnitFactor()
        @test canInstanciateSQArraWithoutUnit()
        @test canInstanciateSQArraWithoutValue()
    end
end

## Constructors

function canInstanciateSQArrayWithRealArray()
    values = TestingTools.generateRandomReal(dim = (2,2))
    unit = TestingTools.generateRandomUnit()
    sqArray = SimpleQuantityArray(values, unit)
    correctFields = Dict([
        ("values", values),
        ("unit", unit)
    ])
    return _verifyHasCorrectFields(sqArray, correctFields)
end

function _verifyHasCorrectFields(sqArray::SimpleQuantityArray, correctFields::Dict{String,Any})
    correctValue = (sqArray.values == correctFields["values"])
    correctUnit = (sqArray.unit == correctFields["unit"])
    correct = correctValue && correctUnit
    return correct
end

function canInstanciateSQArrayWithComplexArray()
    values = TestingTools.generateRandomComplex(dim = (2,2))
    println(values)
    unit = TestingTools.generateRandomUnit()
    sqArray = SimpleQuantityArray(values, unit)
    correctFields = Dict([
        ("values", values),
        ("unit", unit)
    ])
    return _verifyHasCorrectFields(sqArray, correctFields)
end

end # module

# # TODO: Examples copied from SimpleQuantityTests
#
# function _getMatrixExamplesFor_addition()
#     # format: addend1, addend2, correct sum
#     examples = [
#         ( [2, 1] * Alicorn.unitlessUnit, [1, 2] * Alicorn.unitlessUnit, [3, 3] * Alicorn.unitlessUnit ),
#         ( [7; 2] * ucat.siemens, [2; 7] * (ucat.milli * ucat.siemens), [7.002; 2.007] * ucat.siemens ),
#         ( [2; 7] * (ucat.milli * ucat.second), [7; 2] * ucat.second , [7.002e3; 2.007e3] * (ucat.milli * ucat.second) )
#     ]
#     return examples
# end
#
# function _getMatrixExamplesFor_subtraction()
#     # format: addend1, addend2, correct sum
#     examples = [
#         ( [2, 1] * Alicorn.unitlessUnit, [1, 2] * Alicorn.unitlessUnit, [1, -1] * Alicorn.unitlessUnit ),
#         ( [7; 2] * ucat.siemens, [2; 7] * (ucat.milli * ucat.siemens), [6.998; 1.993] * ucat.siemens ),
#         ( [2; 7] * (ucat.milli * ucat.second), [7; 2] * ucat.second , [-6.998e3; -1.993e3] * (ucat.milli * ucat.second) )
#     ]
#     return examples
# end
#
# function _getMatrixExamplesFor_multiplication()
#     # format: factor1, factor2, correct product factor1 * factor2
#     examples = [
#         ( [1 1] * Alicorn.unitlessUnit, [1; 1] * Alicorn.unitlessUnit, [2] * Alicorn.unitlessUnit ),
#         ( [1 0; 2 0] * Alicorn.unitlessUnit, [2 3; 4 5] * ucat.second, [2 3; 4 6] * ucat.second ),
#         ( [2 3; 4 5] * ucat.second, [1 0; 2 0] * Alicorn.unitlessUnit, [8 0; 14 0] * ucat.second ),
#         ( [2.5] * ucat.meter, [2 3] * ucat.second, [5 7.5] * ucat.meter * ucat.second ),
#         ( [2.5] * ucat.second, [2 3] * ucat.meter, [5 7.5] * ucat.second * ucat.meter )
#     ]
#     return examples
# end
#
#
# function _getMatrixExamplesFor_multiplicationWithDimensionless()
#     # format: factor1, factor2, correct product factor1 * factor2
#     examples = [
#         ( [1 1] * Alicorn.unitlessUnit, [1; 1], [2] * Alicorn.unitlessUnit ),
#         ( [1 1], [1; 1] * Alicorn.unitlessUnit, [2] * Alicorn.unitlessUnit ),
#         ( [1 0; 2 0] * ucat.second, [2 3; 4 5] , [2 3; 4 6] * ucat.second ),
#         ( [2 3; 4 5], [1 0; 2 0] * ucat.second, [8 0; 14 0] * ucat.second )
#     ]
#     return examples
# end
#
# function _getMixedExamplesFor_multiplicationWithDimensionless()
#     # format: factor1, factor2, correct product factor1 * factor2
#     examples = [
#         ( [1 1] * Alicorn.unitlessUnit, 2, [2 2] * Alicorn.unitlessUnit ),
#         ( 2, [1 1] * Alicorn.unitlessUnit, [2 2] * Alicorn.unitlessUnit ),
#         ( [1 0; 2 0] * ucat.second, 3, [3 0; 6 0] * ucat.second ),
#         ( 3, [1 0; 2 0] * ucat.second, [3 0; 6 0] * ucat.second ),
#         ( 2.5 * ucat.meter, [2 3] , [5 7.5] * ucat.meter  ),
#         ( [2 3], 2.5 * ucat.meter, [5 7.5] * ucat.meter  )
#     ]
#     return examples
# end
#
# function _getMixedExamplesFor_division()
#     # format: factor1, factor2, correct product factor1 * factor2
#     examples = [
#         ( [1 1] * Alicorn.unitlessUnit, 1 * Alicorn.unitlessUnit, [1 1] * Alicorn.unitlessUnit ),
#         ( [2, 3] * Alicorn.unitlessUnit, 2 * ucat.second, [1, 1.5] * ucat.second^-1 ),
#         ( [2; 10] * ucat.second, 5 * Alicorn.unitlessUnit, [0.4; 2] * ucat.second ),
#         ( [4 4] * ucat.meter,  2 * ucat.second, [2 2] * ucat.meter / ucat.second ),
#         ( [4 4] * ucat.second, 2 * ucat.meter, [2 2] * ucat.second / ucat.meter ),
#         ( [-7 -7] * ucat.lumen * (ucat.nano * ucat.second),  2 * (ucat.pico * ucat.second) , [-3.5 -3.5] * ucat.lumen * (ucat.nano * ucat.second) / (ucat.pico * ucat.second) ),
#         ( [2 2; 2 2] * (ucat.milli * ucat.candela)^-4, 4 * (ucat.milli * ucat.candela)^2, [0.5 0.5; 0.5 0.5] * (ucat.milli * ucat.candela)^-6 )
#     ]
#     return examples
# end
#
# function _getMixedExamplesFor_divisionByDimensionless()
#     # format: factor1, factor2, correct product factor1 * factor2
#     examples = [
#         ( [1 1] * Alicorn.unitlessUnit, 1, [1 1] * Alicorn.unitlessUnit ),
#         ( [1 1], 1 * Alicorn.unitlessUnit, [1 1] * Alicorn.unitlessUnit ),
#         ( [2, 3] * ucat.second, 2 , [1, 1.5] * ucat.second ),
#         ( [2, 3] , 2 * ucat.second , [1, 1.5] / ucat.second ),
#     ]
#     return examples
# end
#
# function _getMatrixExamplesFor_inv()
#     # format: SimpleQuantity, correct result for SimpleQuantity^-1
#     examples = [
#         ( [1 0 ; 0 1] * Alicorn.unitlessUnit, [1 0 ; 0 1] * Alicorn.unitlessUnit),
#         ( [2 4; 2 8] * ucat.meter, [1 -0.5; -0.25 0.25] * ucat.meter^-1),
#         ( -[2 4; 2 8] * (ucat.femto * ucat.meter)^-1 * ucat.joule, -[1 -0.5; -0.25 0.25] * (ucat.femto * ucat.meter) * ucat.joule^-1 )
#     ]
#     return examples
# end
#
# function _getMatrixExamplesFor_exponentiation()
#     # format: SimpleQuantity, exponent, correct result for SimpleQuantity^exponent
#     examples = [
#         ( [1 0; 0 1] * Alicorn.unitlessUnit, 1, [1 0; 0 1] * Alicorn.unitlessUnit ),
#         ( [1 0; 0 1] * Alicorn.unitlessUnit, 2, [1 0; 0 1] * Alicorn.unitlessUnit ),
#         ( [1 2; 3 4] * ucat.meter, 0, [1 0; 0 1] * Alicorn.unitlessUnit ),
#     ]
#     return examples
# end
#
#
# function _getMatrixExamplesFor_sqrt()
#     # format: SimpleQuantity, correct result for sqrt(SimpleQuantity)
#     examples = [
#         ( [1 0; 0 1] * Alicorn.unitlessUnit, [1 0; 0 1] * Alicorn.unitlessUnit),
#         ( [4 0; 0 4] * (ucat.pico * ucat.meter)^-3, [2 0; 0 2] * (ucat.pico * ucat.meter)^-1.5 )
#     ]
#     return examples
# end
#
# function _getMatrixExamplesFor_size()
#     # format: SimpleQuantity, correct result for size(SimpleQuantity)
#     examples = [
#         ( [1 0; 0 1; 2 3] * (ucat.pico * ucat.meter)^-3, (3, 2) ),
#         ( [1 0 2; 0 1 3] * (ucat.pico * ucat.meter)^-3, (2, 3) )
#     ]
#     return examples
# end
#
#
# function _getMatrixExamplesFor_length()
#     # format: SimpleQuantity, correct result for sqrt(SimpleQuantity)
#     examples = [
#         ( [1 0; 0 1; 2 3] * (ucat.pico * ucat.meter)^-3, 6)
#     ]
#     return examples
# end
