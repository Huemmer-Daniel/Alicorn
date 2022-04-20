module quantity_arrayBasicsTests

using Alicorn
using Test
using ..TestingTools

const ucat = UnitCatalogue()
const defaultInternalUnits = InternalUnits()
const intu = InternalUnits()
const intu2 = InternalUnits(length=2*ucat.meter)
const lengthDim = Dimension(L=1)

function run()
    @testset "quantity_arrayBasicsTests" begin

        # eltype
        @test eltype_implemented()
        # copy
        @test copy_implementedForSimpleQuantity()
        @test deepcopy_implementedForSimpleQuantity()
        @test copy_implementedForSimpleQuantityArray()
        @test deepcopy_implementedForSimpleQuantityArray()
        @test copy_implementedForQuantity()
        @test deepcopy_implementedForQuantity()
        @test copy_implementedForQuantityArray()
        @test deepcopy_implementedForQuantityArray()
        # axes
        @test axes_implemented()
        @test axes_implemented_withDimension()
        # ndims
        @test ndims_implemented()
        # length
        @test length_implemented()
        # firstindex
        @test firstindex_implemented()
        @test firstindex_implemented_withDimension()
        # lastindex
        @test lastindex_implemented()
        @test lastindex_implemented_withDimension()
        # IteratorSize
        @test IteratorSize_implemented()
        # keys
        @test keys_implemented()
        # get
        @test get_implemented()
        # first
        @test first_implemented()
        # last
        @test last_implemented()

        # deleteat!
        @test deleteat!_implemented()

        # repeat
        @test repeat_implemented()

    end
end

## eltype

function eltype_implemented()
    examples = _getExamplesFor_eltype_implemented()
    return TestingTools.testMonadicFunction(Base.eltype, examples)
end

function _getExamplesFor_eltype_implemented()
    # format: q::AbstractQuantityType, correct result for eltype(q)
    examples = [
        ( SimpleQuantity{Int32}(3, ucat.meter), SimpleQuantity{Int32} ),
        ( SimpleQuantityArray{Int32}([1, 3], ucat.meter), SimpleQuantity{Int32} ),
        ( Quantity{Int32}( 3, lengthDim, intu2), Quantity{Int32} ),
        ( QuantityArray{Int32}([1, 3], lengthDim, intu2), Quantity{Int32} )
    ]

    return examples
end

## copy

function copy_implementedForSimpleQuantity()
    sQuantity = 5.7 * ucat.meter
    sQuantity2 = copy(sQuantity)
    return sQuantity == sQuantity2
end

function deepcopy_implementedForSimpleQuantity()
    sQuantity = 5.7 * ucat.meter
    sQuantity2 = deepcopy(sQuantity)
    return sQuantity == sQuantity2
end

function copy_implementedForSimpleQuantityArray()
    sqArray = [5.7 -4] * ucat.meter
    sqArray2 = copy(sqArray)
    return sqArray == sqArray2
end

function deepcopy_implementedForSimpleQuantityArray()
    sqArray = [5.7 -4] * ucat.meter
    sqArray2 = deepcopy(sqArray)
    return sqArray == sqArray2
end

function copy_implementedForQuantity()
    quantity = Quantity(5.7, lengthDim, intu)
    quantity2 = copy(quantity)
    return quantity == quantity2
end

function deepcopy_implementedForQuantity()
    quantity = Quantity(5.7, lengthDim, intu)
    quantity2 = deepcopy(quantity)
    return quantity == quantity2
end

function copy_implementedForQuantityArray()
    qArray = QuantityArray([5.7, -2], lengthDim, intu)
    qArray2 = copy(qArray)
    return qArray == qArray2
end

function deepcopy_implementedForQuantityArray()
    qArray = QuantityArray([5.7, -2], lengthDim, intu)
    qArray2 = deepcopy(qArray)
    return qArray == qArray2
end

## axes

function axes_implemented()
    examples = _getExamplesFor_axes_implemented()
    return TestingTools.testMonadicFunction(Base.axes, examples)
end

function _getExamplesFor_axes_implemented()
    # format: q::AbstractQuantityType, correct result for axes(q)
    examples = [
        ( SimpleQuantity{Int32}(3, ucat.meter), () ),
        ( SimpleQuantityArray{Int32}([1, 3], ucat.meter), (Base.OneTo(2),) ),
        ( SimpleQuantityArray{Int32}([1 3; 3 4; 5 6], ucat.meter), (Base.OneTo(3), Base.OneTo(2)) ),
        ( Quantity{Int32}( 3, lengthDim, intu2), () ),
        ( QuantityArray{Int32}([1, 3], lengthDim, intu2), (Base.OneTo(2),) ),
        ( QuantityArray{Int32}([1 3; 3 4; 5 6], lengthDim, intu2), (Base.OneTo(3), Base.OneTo(2)) )
    ]

    return examples
end

function axes_implemented_withDimension()
    examples = _getExamplesFor_axes_implemented_withDimension()
    return TestingTools.testDyadicFunction(Base.axes, examples)
end

function _getExamplesFor_axes_implemented_withDimension()
    # format: q::AbstractQuantityType, correct result for axes(q)
    examples = [
        ( SimpleQuantity{Int32}(3, ucat.meter), 1, Base.OneTo(1) ),
        ( SimpleQuantityArray{Int32}([1, 3], ucat.meter), 1, Base.OneTo(2) ),
        ( SimpleQuantityArray{Int32}([1 3; 3 4; 5 6], ucat.meter), 1, Base.OneTo(3) ),
        ( Quantity{Int32}( 3, lengthDim, intu2), 1, Base.OneTo(1) ),
        ( QuantityArray{Int32}([1, 3], lengthDim, intu2), 1, Base.OneTo(2) ),
        ( QuantityArray{Int32}([1 3; 3 4; 5 6], lengthDim, intu2), 1, Base.OneTo(3) )
    ]

    return examples
end

## ndims

function ndims_implemented()
    examples = _getExamplesFor_ndims_implemented()
    return TestingTools.testMonadicFunction(Base.ndims, examples)
end

function _getExamplesFor_ndims_implemented()
    # format: q::AbstractQuantityType, correct result for ndims(q)
    examples = [
        ( SimpleQuantity{Int32}(3, ucat.meter), 0 ),
        ( SimpleQuantityArray{Int32}([1, 3], ucat.meter), 1 ),
        ( SimpleQuantityArray{Int32}([1 3; 3 4; 5 6], ucat.meter), 2 ),
        ( Quantity{Int32}( 3, lengthDim, intu2), 0 ),
        ( QuantityArray{Int32}([1, 3], lengthDim, intu2), 1 ),
        ( QuantityArray{Int32}([1 3; 3 4; 5 6], lengthDim, intu2), 2 )
    ]

    return examples
end

## length

function length_implemented()
    examples = _getExamplesFor_length_implemented()
    return TestingTools.testMonadicFunction(Base.length, examples)
end

function _getExamplesFor_length_implemented()
    # format: q::AbstractQuantityType, correct result for length(q)
    examples = [
        ( SimpleQuantity{Int32}(3, ucat.meter), 1 ),
        ( SimpleQuantityArray{Int32}([1, 3], ucat.meter), 2 ),
        ( SimpleQuantityArray{Int32}([1 3; 3 4; 5 6], ucat.meter), 6 ),
        ( Quantity{Int32}( 3, lengthDim, intu2), 1 ),
        ( QuantityArray{Int32}([1, 3], lengthDim, intu2), 2 ),
        ( QuantityArray{Int32}([1 3; 3 4; 5 6], lengthDim, intu2), 6 )
    ]

    return examples
end

## firstindex

function firstindex_implemented()
    examples = _getExamplesFor_firstindex_implemented()
    return TestingTools.testMonadicFunction(Base.firstindex, examples)
end

function _getExamplesFor_firstindex_implemented()
    # format: q::AbstractQuantityType, correct result for firstindex(q)
    examples = [
        ( SimpleQuantity{Int32}(3, ucat.meter), 1 ),
        ( SimpleQuantityArray{Int32}([1, 3], ucat.meter), 1 ),
        ( SimpleQuantityArray{Int32}([1 3; 3 4; 5 6], ucat.meter), 1 ),
        ( Quantity{Int32}( 3, lengthDim, intu2), 1 ),
        ( QuantityArray{Int32}([1, 3], lengthDim, intu2), 1 ),
        ( QuantityArray{Int32}([1 3; 3 4; 5 6], lengthDim, intu2), 1 )
    ]

    return examples
end

function firstindex_implemented_withDimension()
    examples = _getExamplesFor_firstindex_implemented_withDimension()
    return TestingTools.testDyadicFunction(Base.firstindex, examples)
end

function _getExamplesFor_firstindex_implemented_withDimension()
    # format: q::AbstractQuantityType, correct result for firstindex(q)
    examples = [
        ( SimpleQuantity{Int32}(3, ucat.meter), 1, 1 ),
        ( SimpleQuantityArray{Int32}([1, 3], ucat.meter), 1, 1 ),
        ( SimpleQuantityArray{Int32}([1 3; 3 4; 5 6], ucat.meter), 1, 1 ),
        ( Quantity{Int32}( 3, lengthDim, intu2), 1, 1 ),
        ( QuantityArray{Int32}([1, 3], lengthDim, intu2), 1, 1 ),
        ( QuantityArray{Int32}([1 3; 3 4; 5 6], lengthDim, intu2), 1, 1 )
    ]

    return examples
end


## lastindex

function lastindex_implemented()
    examples = _getExamplesFor_lastindex_implemented()
    return TestingTools.testMonadicFunction(Base.lastindex, examples)
end

function _getExamplesFor_lastindex_implemented()
    # format: q::AbstractQuantityType, correct result for lastindex(q)
    examples = [
        ( SimpleQuantity{Int32}(3, ucat.meter), 1 ),
        ( SimpleQuantityArray{Int32}([1, 3], ucat.meter), 2 ),
        ( SimpleQuantityArray{Int32}([1 3; 3 4; 5 6], ucat.meter), 6 ),
        ( Quantity{Int32}( 3, lengthDim, intu2), 1 ),
        ( QuantityArray{Int32}([1, 3], lengthDim, intu2), 2 ),
        ( QuantityArray{Int32}([1 3; 3 4; 5 6], lengthDim, intu2), 6 )
    ]

    return examples
end

function lastindex_implemented_withDimension()
    examples = _getExamplesFor_lastindex_implemented_withDimension()
    return TestingTools.testDyadicFunction(Base.lastindex, examples)
end

function _getExamplesFor_lastindex_implemented_withDimension()
    # format: q::AbstractQuantityType, correct result for lastindex(q)
    examples = [
        ( SimpleQuantity{Int32}(3, ucat.meter), 1, 1 ),
        ( SimpleQuantityArray{Int32}([1, 3], ucat.meter), 1, 2 ),
        ( SimpleQuantityArray{Int32}([1 3; 3 4; 5 6], ucat.meter), 1, 3 ),
        ( Quantity{Int32}( 3, lengthDim, intu2), 1, 1 ),
        ( QuantityArray{Int32}([1, 3], lengthDim, intu2), 1, 2 ),
        ( QuantityArray{Int32}([1 3; 3 4; 5 6], lengthDim, intu2), 1, 3 )
    ]

    return examples
end


## IteratorSize

function IteratorSize_implemented()
    examples = _getExamplesFor_IteratorSize_implemented()
    return TestingTools.testMonadicFunction(Base.IteratorSize, examples)
end

function _getExamplesFor_IteratorSize_implemented()
    # format: q::AbstractQuantityType, correct result for IteratorSize(q)
    a1 = [1, 3]
    a2 = [1 3; 3 4; 5 6]
    examples = [
        ( SimpleQuantity{Int32}(3, ucat.meter), Base.HasShape{0}() ),
        ( SimpleQuantityArray{Int32}(a1, ucat.meter), Base.HasShape{1}() ),
        ( SimpleQuantityArray{Int32}(a2, ucat.meter), Base.HasShape{2}() ),
        ( Quantity{Int32}(3, lengthDim, intu2), Base.HasShape{0}() ),
        ( QuantityArray{Int32}(a1, lengthDim, intu2), Base.HasShape{1}() ),
        ( QuantityArray{Int32}(a2, lengthDim, intu2), Base.HasShape{2}() )
    ]

    return examples
end


## keys

function keys_implemented()
    examples = _getExamplesFor_keys_implemented()
    return TestingTools.testMonadicFunction(Base.keys, examples)
end

function _getExamplesFor_keys_implemented()
    # format: q::AbstractQuantityType, correct result for keys(q)
    a1 = [1, 3]
    keys1 = keys(a1)
    a2 = [1 3; 3 4; 5 6]
    keys2 = keys(a2)
    examples = [
        ( SimpleQuantity{Int32}(3, ucat.meter), Base.OneTo(1) ),
        ( SimpleQuantityArray{Int32}(a1, ucat.meter), keys1 ),
        ( SimpleQuantityArray{Int32}(a2, ucat.meter), keys2 ),
        ( Quantity{Int32}(3, lengthDim, intu2), Base.OneTo(1) ),
        ( QuantityArray{Int32}(a1, lengthDim, intu2), keys1 ),
        ( QuantityArray{Int32}(a2, lengthDim, intu2), keys2 )
    ]

    return examples
end


## get

function get_implemented()
    examples = _getExamplesFor_get_implemented()
    return test_get(examples)
end

function _getExamplesFor_get_implemented()
    # format: q::AbstractQuantityType, correct result for get(q, ind, default)
    a1 = [1, 3]
    a2 = [1 3; 3 4; 5 6]
    examples = [
        ( SimpleQuantity{Int32}(3, ucat.meter), 1, -7, SimpleQuantity{Int32}(3, ucat.meter) ),
        ( SimpleQuantity{Int32}(3, ucat.meter), 2, -7, -7 ),
        #
        ( SimpleQuantityArray{Int32}(a1, ucat.meter), 2, -7, SimpleQuantity{Int32}(3, ucat.meter) ),
        ( SimpleQuantityArray{Int32}(a2, ucat.meter), 7, -7, -7 ),
        #
        ( Quantity{Int32}(3, lengthDim, intu2), 1, -7, Quantity{Int32}(3, lengthDim, intu2) ),
        ( Quantity{Int32}(3, lengthDim, intu2), 2, -7, -7 ),
        #
        ( QuantityArray{Int32}(a1, lengthDim, intu2), 2, -7, Quantity{Int32}(3, lengthDim, intu2) ),
        ( QuantityArray{Int32}(a2, lengthDim, intu2), 7, -7, -7 ),
    ]

    return examples
end

function test_get(examples::Array)
    correct = true
    for (q, ind, def, correctResult) in examples
        returnedResult = get(q, ind, def)
        correct &= returnedResult == correctResult
    end
    return correct
end


## first

function first_implemented()
    examples = _getExamplesFor_first_implemented()
    return TestingTools.testMonadicFunction(Base.first, examples)
end

function _getExamplesFor_first_implemented()
    # format: q::AbstractQuantityType, correct result for first(q)
    a1 = [1, 3]
    a2 = [7 3; 3 4; 5 6]
    examples = [
        ( SimpleQuantity{Int32}(3, ucat.meter), SimpleQuantity{Int32}(3, ucat.meter) ),
        ( SimpleQuantityArray{Int32}(a1, ucat.meter), SimpleQuantity{Int32}(1, ucat.meter) ),
        ( SimpleQuantityArray{Int32}(a2, ucat.meter), SimpleQuantity{Int32}(7, ucat.meter)  ),
        ( Quantity{Int32}(3, lengthDim, intu2), Quantity{Int32}(3, lengthDim, intu2) ),
        ( QuantityArray{Int32}(a1, lengthDim, intu2), Quantity{Int32}(1, lengthDim, intu2) ),
        ( QuantityArray{Int32}(a2, lengthDim, intu2), Quantity{Int32}(7, lengthDim, intu2) )
    ]

    return examples
end


## last

function last_implemented()
    examples = _getExamplesFor_last_implemented()
    return TestingTools.testMonadicFunction(Base.last, examples)
end

function _getExamplesFor_last_implemented()
    # format: q::AbstractQuantityType, correct result for last(q)
    a1 = [1, 3]
    a2 = [7 3; 3 4; 5 6]
    examples = [
        ( SimpleQuantity{Int32}(3, ucat.meter), SimpleQuantity{Int32}(3, ucat.meter) ),
        ( SimpleQuantityArray{Int32}(a1, ucat.meter), SimpleQuantity{Int32}(3, ucat.meter) ),
        ( SimpleQuantityArray{Int32}(a2, ucat.meter), SimpleQuantity{Int32}(6, ucat.meter)  ),
        ( Quantity{Int32}(3, lengthDim, intu2), Quantity{Int32}(3, lengthDim, intu2) ),
        ( QuantityArray{Int32}(a1, lengthDim, intu2), Quantity{Int32}(3, lengthDim, intu2) ),
        ( QuantityArray{Int32}(a2, lengthDim, intu2), Quantity{Int32}(6, lengthDim, intu2) )
    ]

    return examples
end


## deleteat!

function deleteat!_implemented()
    examples = _getExamplesFor_deleteat!_implemented()
    return TestingTools.testDyadicFunction(Base.deleteat!, examples)
end

function _getExamplesFor_deleteat!_implemented()
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

function repeat_implemented()
    correct = true

    examples = _getExamplesFor_repeat_implemented__inner_outer()
    correct &= _test_repeat__inner_outer(examples)

    examples = _getExamplesFor_repeat_implemented__counts()
    correct &= _test_repeat__counts(examples)

    return correct
end

function _getExamplesFor_repeat_implemented__inner_outer()
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

function _getExamplesFor_repeat_implemented__counts()
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
