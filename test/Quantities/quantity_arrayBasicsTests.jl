module quantity_arrayBasicsTests

using Alicorn
using Test
using ..TestingTools

const ucat = UnitCatalogue()
const defaultInternalUnits = InternalUnits()
const intu2 = InternalUnits(length=2*ucat.meter)
const lengthDim = Dimension(L=1)

function run()
    @testset "quantity_arrayBasicsTests" begin

        # eltype
        @test eltype_implementedForArrayQuantities()

        # deleteat!
        @test deleteat!_implementedForArrayQuantities()

        # repeat
        @test repeat_implementedForArrayQuantities()

    end
end

## eltype

function eltype_implementedForArrayQuantities()
    examples = _getExamplesFor_eltype_implementedForArrayQuantities()
    return TestingTools.testMonadicFunction(Base.eltype, examples)
end

function _getExamplesFor_eltype_implementedForArrayQuantities()
    # format: q::AbstractQuantityArray, correct result for eltype(q)
    examples = [
        ( SimpleQuantityArray{Int32}([1, 3], ucat.meter), SimpleQuantity{Int32} ),
        ( QuantityArray{Int32}([1, 3], lengthDim, intu2), Quantity{Int32} )
    ]

    return examples
end

## deleteat!

function deleteat!_implementedForArrayQuantities()
    examples = _getExamplesFor_deleteat!_implementedForArrayQuantities()
    return TestingTools.testDyadicFunction(Base.deleteat!, examples)
end

function _getExamplesFor_deleteat!_implementedForArrayQuantities()
    # format: q::AbstractQuantityArray, inds, correct result for deleteat!(q, inds)
    examples = [
        # SimpleQuantityArray
        ( SimpleQuantityArray{Int32}( [ 1; 2; 3; 4 ] ), 2, SimpleQuantityArray{Int32}( [ 1; 3; 4 ] )  ),
        ( SimpleQuantityArray{Int32}( [ 1; 2; 3; 4 ] ), (2, 3), SimpleQuantityArray{Int32}( [ 1; 4 ] )  ),
        ( SimpleQuantityArray( [ 2 ] ), 1, SimpleQuantityArray( Array{Float64}([]) )  ),
        # QuantityArray
        ( QuantityArray{Int32}( [ 1; 2; 3; 4 ], lengthDim, intu2), 3, QuantityArray{Int32}( [ 1; 2; 4 ], lengthDim, intu2) ),
        ( QuantityArray{Int32}( [ 1; 2; 3; 4 ], lengthDim, intu2), (3, 4), QuantityArray{Int32}( [ 1; 2 ], lengthDim, intu2) ),
        ( QuantityArray( [ 4 ], lengthDim, intu2), 1, QuantityArray( Array{Float64}([]), lengthDim, intu2) )
    ]

    return examples
end

## repeat

function repeat_implementedForArrayQuantities()
    correct = true

    examples = _getExamplesFor_repeat_implementedForArrayQuantities__inner_outer()
    correct &= _test_repeat__inner_outer(examples)

    examples = _getExamplesFor_repeat_implementedForArrayQuantities__counts()
    correct &= _test_repeat__counts(examples)

    return correct
end

function _getExamplesFor_repeat_implementedForArrayQuantities__inner_outer()
    # format: q::AbstractQuantityArray, inner, outer, correct result for repeat(q, inner=inner, outer=outer)
    examples = [
        # SimpleQuantityArray
        ( SimpleQuantityArray{Int32}( [ 1; 2; 3 ] ), 3, nothing,
            SimpleQuantityArray{Int32}( [ 1; 1; 1; 2; 2; 2; 3; 3; 3 ] ) ),

        ( SimpleQuantityArray{Int32}( [ 1; 2; 3 ] ), nothing, 2 ,
            SimpleQuantityArray{Int32}( [ 1; 2; 3; 1; 2; 3 ] ) ),

        ( SimpleQuantityArray{Int32}( [ 1 2; 3 4 ] ), nothing, (2, 3) ,
            SimpleQuantityArray{Int32}( [1 2 1 2 1 2; 3 4 3 4 3 4; 1 2 1 2 1 2 ; 3 4 3 4 3 4] ) ),

        # QuantityArray
        ( QuantityArray{Int32}( [ 1; 2; 3 ], lengthDim, intu2 ), 3, nothing,
            QuantityArray{Int32}( [ 1; 1; 1; 2; 2; 2; 3; 3; 3 ], lengthDim, intu2 ) ),

        ( QuantityArray{Int32}( [ 1; 2; 3 ], lengthDim, intu2 ), nothing, 2 ,
            QuantityArray{Int32}( [ 1; 2; 3; 1; 2; 3 ], lengthDim, intu2 ) ),

        ( QuantityArray{Int32}( [ 1 2; 3 4 ], lengthDim, intu2 ), nothing, (2, 3) ,
            QuantityArray{Int32}( [1 2 1 2 1 2; 3 4 3 4 3 4; 1 2 1 2 1 2 ; 3 4 3 4 3 4], lengthDim, intu2 ) ),
    ]
    return examples
end

function _test_repeat__inner_outer(examples::Array)
    correct = true
    for (q, inner, outer, correctResult) in examples
        returnedResult = repeat(q, inner=inner, outer=outer)
        correct &= (returnedResult == correctResult)
    end
    return correct
end

function _getExamplesFor_repeat_implementedForArrayQuantities__counts()
    # format: q::AbstractQuantityArray, counts, correct result for repeat(q, counts)
    examples = [
        # SimpleQuantityArray
        ( SimpleQuantityArray{Int32}( [ 1; 2; 3 ] ), 2,
            SimpleQuantityArray{Int32}( [ 1; 2; 3; 1; 2; 3 ] ) ),

        ( SimpleQuantityArray{Int32}( [ 1 2 3] ), (2,3 ),
            SimpleQuantityArray{Int32}( [ 1 2 3 1 2 3 1 2 3; 1 2 3 1 2 3 1 2 3] ) ),

        # QuantityArray
        ( QuantityArray{Int32}( [ 1; 2; 3 ], lengthDim, intu2  ), 2,
            QuantityArray{Int32}( [ 1; 2; 3; 1; 2; 3 ], lengthDim, intu2  ) ),

        ( QuantityArray{Int32}( [ 1 2 3], lengthDim, intu2  ), (2, 3),
            QuantityArray{Int32}( [ 1 2 3 1 2 3 1 2 3; 1 2 3 1 2 3 1 2 3], lengthDim, intu2  ) ),
    ]
end

function _test_repeat__counts(examples::Array)
    correct = true
    for (q, counts, correctResult) in examples
        returnedResult = repeat(q, counts...)
        correct &= (returnedResult == correctResult)
    end
    return correct
end

end # module
