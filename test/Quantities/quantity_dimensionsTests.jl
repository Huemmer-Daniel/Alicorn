module quantity_dimensionsTests

using Alicorn
using Test
using ..TestingTools

const ucat = UnitCatalogue()
const intu = InternalUnits()

function run()
    @testset "quantity_dimensionsTests" begin
        @test dimensionOf_implementedForSimpleQuantity()
        @test dimensionOf_implementedForSimpleQuantityArray()

        @test dimensionOf_implementedForQuantity()
        @test dimensionOf_implementedForQuantityArray()
    end
end

## SimpleQuantity

function dimensionOf_implementedForSimpleQuantity()
    examples = _getExamplesFor_dimensionOf_forSimpleQuantity()
    return TestingTools.testMonadicFunction(dimensionOf, examples)
end

function _getExamplesFor_dimensionOf_forSimpleQuantity()

    # format: q::SimpleQuantity, corresponding Dimension
    examples = [
        # SimpleQuantity
        ( 1 * Alicorn.unitlessUnit, Dimension() ),
        ( 1 * ucat.henry, Dimension(M=1, L=2, T=-2, I=-2) )
    ]
    return examples
end

## SimpleQuantityArray

function dimensionOf_implementedForSimpleQuantityArray()
    examples = _getExamplesFor_dimensionOf_forSimpleQuantityArray()
    return TestingTools.testMonadicFunction(dimensionOf, examples)
end

function _getExamplesFor_dimensionOf_forSimpleQuantityArray()

    # format: q::SimpleQuantityArray, corresponding Dimension
    examples = [
        # SimpleQuantity
        ( [1, 2] * Alicorn.unitlessUnit, Dimension() ),
        ( [-6.7 3] * ucat.henry, Dimension(M=1, L=2, T=-2, I=-2) )
    ]
    return examples
end

## Quantity

function dimensionOf_implementedForQuantity()
    examples = _getExamplesFor_dimensionOf_forQuantity()
    return TestingTools.testMonadicFunction(dimensionOf, examples)
end

function _getExamplesFor_dimensionOf_forQuantity()

    # format: q::Quantity, corresponding Dimension
    examples = [
        # Quantity
        ( Quantity(1, Dimension(), intu ) , Dimension() ),
        ( Quantity(-9.8, Dimension(M=1, L=2, T=-2, I=-2), intu ), Dimension(M=1, L=2, T=-2, I=-2)  )
    ]
    return examples
end

## QuantityArray

function dimensionOf_implementedForQuantityArray()
    examples = _getExamplesFor_dimensionOf_forQuantityArray()
    return TestingTools.testMonadicFunction(dimensionOf, examples)
end

function _getExamplesFor_dimensionOf_forQuantityArray()

    # format: q::QuantityArray, corresponding Dimension
    examples = [
        # QuantityArray
        ( QuantityArray([1, -3], Dimension(), intu ) , Dimension() ),
        ( QuantityArray([-9.8 pi], Dimension(M=1, L=2, T=-2, I=-2), intu ), Dimension(M=1, L=2, T=-2, I=-2)  )
    ]
    return examples
end

end # module
