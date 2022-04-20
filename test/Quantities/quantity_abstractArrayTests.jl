module quantity_abstractArrayTests

using Alicorn
using Test
using ..TestingTools

const ucat = UnitCatalogue()
const defaultInternalUnits = InternalUnits()
const intu2 = InternalUnits(length=2*ucat.meter)
const lengthDim = Dimension(L=1)

function run()
    @testset "quantity_abstractArrayTests" begin
        # size
        @test size_implementedForSimpleQuantityArray()
        @test size_implementedForQuantityArray()

        # IndexStyle
        @test SimpleQuantity_reportsLinearIndexing()
        @test SimpleQuantityArray_reportsLinearIndexing()
        @test Quantity_reportsLinearIndexing()
        @test QuantityArray_reportsLinearIndexing()

        # getindex
        @test getindex_implementedForSimpleQuantity()
        @test getindex_implementedForSimpleQuantityArray()
        @test getindex_implementedForQuantity()
        @test getindex_implementedForQuantityArray()

        # setindex
        @test setindex!_implementedForSimpleQuantityArray()
        test_setindex!_forSimpleQuantityArray_errorsForMismatchedUnits()
        @test setindex!_implementedForQuantityArray()
        test_setindex!_forQuantityArray_errorsForMismatchedUnits()

        # length
        @test size_implementedForSimpleQuantityArray()
        @test size_implementedForQuantityArray()

    end
end

## size

function size_implementedForSimpleQuantityArray()
    examples = _getExamplesFor_size_implementedForSimpleQuantityArray()
    return TestingTools.testMonadicFunction(Base.size, examples)
end

function _getExamplesFor_size_implementedForSimpleQuantityArray()
    # format: (sqArray::SimpleQuantityArray, t::Tuple)
    # where t is the correct result for size(sqArray)
    examples = [
        ( SimpleQuantityArray([1], ucat.meter), (1,) ),
        ( SimpleQuantityArray([1.2 -3; 2 -pi; 2 3], (ucat.meter)^2 ), (3,2) ),
        ( SimpleQuantityArray([1.2 -3 2; 2 -pi 3], (ucat.meter)^2 ), (2,3) )
    ]
end

function size_implementedForQuantityArray()
    examples = _getExamplesFor_size_implementedForQuantityArray()
    return TestingTools.testMonadicFunction(Base.size, examples)
end

function _getExamplesFor_size_implementedForQuantityArray()
    # format: (qArray::QuantityArray, t::Tuple)
    # where t is the correct result for size(qArray)
    examples = [
        ( QuantityArray([1], lengthDim, defaultInternalUnits), (1,) ),
        ( QuantityArray([1.2 -3; 2 -pi; 2 3], Dimension(L=2), intu2), (3,2) ),
        ( QuantityArray([1.2 -3 2; 2 -pi 3], lengthDim, defaultInternalUnits ), (2,3) )
    ]
end

## IndexStyle

function SimpleQuantity_reportsLinearIndexing()
    return ( Base.IndexStyle(SimpleQuantity) == IndexLinear() )
end

function SimpleQuantityArray_reportsLinearIndexing()
    return ( Base.IndexStyle(SimpleQuantityArray) == IndexLinear() )
end

function Quantity_reportsLinearIndexing()
    return ( Base.IndexStyle(Quantity) == IndexLinear() )
end
function QuantityArray_reportsLinearIndexing()
    return ( Base.IndexStyle(QuantityArray) == IndexLinear() )
end

## getindex

function test_getindex(examples)
    correct = true
    for (returnedArray, expectedArray) in examples
        correct &= ( returnedArray == expectedArray )
    end
    return correct
end

function getindex_implementedForSimpleQuantity()
    examples = _getExamplesFor_getindex_implementedForSimpleQuantity()
    return test_getindex(examples)
end

function _getExamplesFor_getindex_implementedForSimpleQuantity()

    a = SimpleQuantity{Int32}(-3, (ucat.meter)^2 )

    # single index
    returned1 = getindex(a, 1)
    correct1 = SimpleQuantity{Int32}( -3, (ucat.meter)^2 )

    examples = [
        ( returned1, correct1 )
    ]
end

function getindex_implementedForSimpleQuantityArray()
    examples = _getExamplesFor_getindex_implementedForSimpleQuantityArray()
    return test_getindex(examples)
end

function _getExamplesFor_getindex_implementedForSimpleQuantityArray()

    a = SimpleQuantityArray{Int32}([1 -3; 2 7; 2 3], (ucat.meter)^2 )

    # cartesian single index
    returned1 = getindex(a, 3, 2)
    correct1 = SimpleQuantity{Int32}( 3, (ucat.meter)^2 )

    # cartesian range
    returned2 = getindex(a, 1:3, 2)
    correct2 = SimpleQuantityArray{Int32}( [-3, 7, 3], (ucat.meter)^2 )

    # linear single index
    returned3 = getindex(a, 5)
    correct3 = SimpleQuantity{Int32}( 7, (ucat.meter)^2 )

    # linear range
    returned4 = getindex(a, 2:4)
    correct4 = SimpleQuantityArray{Int32}( [2, 2, -3], (ucat.meter)^2 )

    # colon
    returned5 = getindex(a, :,2)
    correct5 = SimpleQuantityArray{Int32}([-3; 7; 3], (ucat.meter)^2 )

    # cartesian index array
    returned6 = getindex(a, 2, [1, 2])
    correct6 = SimpleQuantityArray{Int32}([2; 7], (ucat.meter)^2 )

    # linear index array
    returned7 = getindex(a, [1, 3, 4])
    correct7 = SimpleQuantityArray{Int32}([1; 2; -3], (ucat.meter)^2 )

    # boolean indexing
    returned8 = getindex(a, [true false; false true; true true])
    correct8 = SimpleQuantityArray{Int32}([1; 2; 7; 3], (ucat.meter)^2 )

    examples = [
        ( returned1, correct1 ),
        ( returned2, correct2 ),
        ( returned3, correct3 ),
        ( returned4, correct4 ),
        ( returned5, correct5 ),
        ( returned6, correct6 ),
        ( returned7, correct7 ),
        ( returned8, correct8 )
    ]
end

function getindex_implementedForQuantity()
    examples = _getExamplesFor_getindex_implementedForQuantity()
    return test_getindex(examples)
end

function _getExamplesFor_getindex_implementedForQuantity()

    a = Quantity{Int32}( 3, Dimension(L=2), intu2 )

    # cartesian single index
    returned1 = getindex(a, 1)
    correct1 = Quantity{Int32}( 3, Dimension(L=2), intu2 )


    examples = [
        ( returned1, correct1 )
    ]
end

function getindex_implementedForQuantityArray()
    examples = _getExamplesFor_getindex_implementedForQuantityArray()
    return test_getindex(examples)
end

function _getExamplesFor_getindex_implementedForQuantityArray()

    a = QuantityArray{Int32}([1 -3; 2 7; 2 3], Dimension(L=2), intu2 )

    # cartesian single index
    returned1 = getindex(a, 3, 2)
    correct1 = Quantity{Int32}( 3, Dimension(L=2), intu2 )

    # cartesian range
    returned2 = getindex(a, 1:3, 2)
    correct2 = QuantityArray{Int32}( [-3, 7, 3], Dimension(L=2), intu2 )

    # linear single index
    returned3 = getindex(a, 5)
    correct3 = Quantity{Int32}( 7, Dimension(L=2), intu2 )

    # linear range
    returned4 = getindex(a, 2:4)
    correct4 = QuantityArray{Int32}( [2, 2, -3], Dimension(L=2), intu2 )

    # colon
    returned5 = getindex(a, :,2)
    correct5 = QuantityArray{Int32}([-3; 7; 3], Dimension(L=2), intu2 )

    # cartesian index array
    returned6 = getindex(a, 2, [1, 2])
    correct6 = QuantityArray{Int32}([2; 7], Dimension(L=2), intu2 )

    # linear index array
    returned7 = getindex(a, [1, 3, 4])
    correct7 = QuantityArray{Int32}([1; 2; -3], Dimension(L=2), intu2 )

    # boolean indexing
    returned8 = getindex(a, [true false; false true; true true])
    correct8 = QuantityArray{Int32}([1; 2; 7; 3], Dimension(L=2), intu2 )

    examples = [
        ( returned1, correct1 ),
        ( returned2, correct2 ),
        ( returned3, correct3 ),
        ( returned4, correct4 ),
        ( returned5, correct5 ),
        ( returned6, correct6 ),
        ( returned7, correct7 ),
        ( returned8, correct8 )
    ]
end

## setindex!

function test_setindex!(examples)
    correct = true
    for (returnedArray, expectedArray) in examples
        correct &= ( returnedArray == expectedArray )
    end
    return correct
end

function setindex!_implementedForSimpleQuantityArray()
    examples = _getExamplesFor_setindex!_implementedForSimpleQuantityArray()
    return test_setindex!(examples)
end

function _getExamplesFor_setindex!_implementedForSimpleQuantityArray()
    a = SimpleQuantityArray{Int32}([1 -3; 2 7; 2 3], (ucat.meter)^2 )

    # cartesian single index
    a1 = copy(a)
    suba1 = SimpleQuantity{Int32}(5, (ucat.meter)^2 )
    returned1 = setindex!(a1, suba1, 3, 2)
    correct1 = SimpleQuantityArray{Int32}([1 -3; 2 7; 2 5], (ucat.meter)^2 )

    # cartesian range
    a2 = copy(a)
    suba2 = SimpleQuantityArray{Int32}([-4; -5; -6], (ucat.meter)^2 )
    returned2 = setindex!(a2, suba2, 1:3, 2)
    correct2 = SimpleQuantityArray{Int32}([1 -4; 2 -5; 2 -6], (ucat.meter)^2 )

    # linear single index
    a3 = copy(a)
    suba3 = SimpleQuantity{Int32}(5, (ucat.meter)^2 )
    returned3 = setindex!(a3, suba3, 5)
    correct3 = SimpleQuantityArray{Int32}([1 -3; 2 5 ; 2 3], (ucat.meter)^2 )

    # linear range
    a4 = copy(a)
    suba4 = SimpleQuantityArray{Int32}( [8, 9, -10], (ucat.meter)^2 )
    returned4 = setindex!(a4, suba4, 2:4)
    correct4 = SimpleQuantityArray{Int32}([1 -10; 8 7; 9 3], (ucat.meter)^2 )

    # colon
    a5 = copy(a)
    suba5 = SimpleQuantityArray{Int32}([8; 9; -10], (ucat.meter)^2 )
    returned5 = setindex!(a5, suba5, :,2)
    correct5 = SimpleQuantityArray{Int32}([1 8; 2 9; 2 -10], (ucat.meter)^2 )

    # cartesian index array
    a6 = copy(a)
    suba6 = SimpleQuantityArray{Int32}([-11; 12], (ucat.meter)^2 )
    returned6 = setindex!(a6, suba6, 2, [1, 2])
    correct6 = SimpleQuantityArray{Int32}([1 -3; -11 12; 2 3], (ucat.meter)^2 )

    # linear index array
    a7 = copy(a)
    suba7 = SimpleQuantityArray{Int32}([-11; 12; 13], (ucat.meter)^2 )
    returned7 = setindex!(a7, suba7, [1, 3, 4])
    correct7 = SimpleQuantityArray{Int32}([-11 13; 2 7; 12 3], (ucat.meter)^2 )

    # boolean indexing
    a8 = copy(a)
    suba8 = SimpleQuantityArray{Int32}([-11; 12; 13; 19], (ucat.meter)^2 )
    returned8 = setindex!(a8, suba8, [true false; false true; true true])
    correct8 = SimpleQuantityArray{Int32}([-11 -3; 2 13; 12 19], (ucat.meter)^2 )

    # check that unit conversion works
    a9 = copy(a)
    suba9 = SimpleQuantity{Int32}(50000, (ucat.centi * ucat.meter)^2 )
    returned9 = setindex!(a9, suba9, 3, 2)
    correct9 = SimpleQuantityArray{Int32}([1 -3; 2 7; 2 5], (ucat.meter)^2 )

    # check that type conversion of the array elements works
    a10 = copy(a)
    suba10 = SimpleQuantity{Float64}(5.0, (ucat.meter)^2 )
    returned10 = setindex!(a10, suba10, 3, 2)
    correct10 = SimpleQuantityArray{Int32}([1 -3; 2 7; 2 5], (ucat.meter)^2 )

    # check on vector
    a11 = SimpleQuantityArray{Int32}([1; -3; 2; 7; 2; 3], (ucat.meter)^2 )
    suba11 = SimpleQuantity{Int32}(5, (ucat.meter)^2 )
    returned11 = setindex!(a11, suba11, 3)
    correct11 = SimpleQuantityArray{Int32}([1; -3; 5; 7; 2; 3], (ucat.meter)^2 )

    examples = [
        ( returned1, correct1 ),
        ( returned2, correct2 ),
        ( returned3, correct3 ),
        ( returned4, correct4 ),
        ( returned5, correct5 ),
        ( returned6, correct6 ),
        ( returned7, correct7 ),
        ( returned8, correct8 ),
        ( returned9, correct9 ),
        ( returned10, correct10 ),
        ( returned11, correct11 ),
    ]
end

function test_setindex!_forSimpleQuantityArray_errorsForMismatchedUnits()
    sqArray = [7, 2] * Alicorn.meter
    mismatchedUnit = Alicorn.second
    expectedError = Alicorn.Exceptions.DimensionMismatchError("dimensions of the quantity and the desired unit do not agree")
    @test_throws expectedError setindex!(sqArray, 2*mismatchedUnit, 1)
end

function setindex!_implementedForQuantityArray()
    examples = _getExamplesFor_setindex!_implementedForQuantityArray()
    return test_setindex!(examples)
end

function _getExamplesFor_setindex!_implementedForQuantityArray()
    a = QuantityArray{Int32}([1 -3; 2 7; 2 3], lengthDim, intu2 )

    # cartesian single index
    a1 = copy(a)
    suba1 = Quantity{Int32}(5, lengthDim, intu2 )
    returned1 = setindex!(a1, suba1, 3, 2)
    correct1 = QuantityArray{Int32}([1 -3; 2 7; 2 5], lengthDim, intu2 )

    # cartesian range
    a2 = copy(a)
    suba2 = QuantityArray{Int32}([-4; -5; -6], lengthDim, intu2 )
    returned2 = setindex!(a2, suba2, 1:3, 2)
    correct2 = QuantityArray{Int32}([1 -4; 2 -5; 2 -6], lengthDim, intu2 )

    # linear single index
    a3 = copy(a)
    suba3 = Quantity{Int32}(5, lengthDim, intu2 )
    returned3 = setindex!(a3, suba3, 5)
    correct3 = QuantityArray{Int32}([1 -3; 2 5 ; 2 3], lengthDim, intu2 )

    # linear range
    a4 = copy(a)
    suba4 = QuantityArray{Int32}( [8, 9, -10], lengthDim, intu2 )
    returned4 = setindex!(a4, suba4, 2:4)
    correct4 = QuantityArray{Int32}([1 -10; 8 7; 9 3], lengthDim, intu2 )

    # colon
    a5 = copy(a)
    suba5 = QuantityArray{Int32}([8; 9; -10], lengthDim, intu2 )
    returned5 = setindex!(a5, suba5, :,2)
    correct5 = QuantityArray{Int32}([1 8; 2 9; 2 -10], lengthDim, intu2 )

    # cartesian index array
    a6 = copy(a)
    suba6 = QuantityArray{Int32}([-11; 12], lengthDim, intu2 )
    returned6 = setindex!(a6, suba6, 2, [1, 2])
    correct6 = QuantityArray{Int32}([1 -3; -11 12; 2 3], lengthDim, intu2 )

    # linear index array
    a7 = copy(a)
    suba7 = QuantityArray{Int32}([-11; 12; 13], lengthDim, intu2 )
    returned7 = setindex!(a7, suba7, [1, 3, 4])
    correct7 = QuantityArray{Int32}([-11 13; 2 7; 12 3], lengthDim, intu2 )

    # boolean indexing
    a8 = copy(a)
    suba8 = QuantityArray{Int32}([-11; 12; 13; 19], lengthDim, intu2 )
    returned8 = setindex!(a8, suba8, [true false; false true; true true])
    correct8 = QuantityArray{Int32}([-11 -3; 2 13; 12 19], lengthDim, intu2 )

    # check that conversion of internal units works
    a9 = copy(a)
    suba9 = Quantity{Int32}(10, lengthDim, defaultInternalUnits )
    returned9 = setindex!(a9, suba9, 2, 2)
    correct9 = QuantityArray{Int32}([1 -3; 2 5; 2 3], lengthDim, intu2 )

    # check that type conversion of the array elements works
    a10 = copy(a)
    suba10 = Quantity{Int32}(10.0, lengthDim, intu2 )
    returned10 = setindex!(a10, suba10, 3, 2)
    correct10 = QuantityArray{Int32}([1 -3; 2 7; 2 10], lengthDim, intu2 )

    examples = [
        ( returned1, correct1 ),
        ( returned2, correct2 ),
        ( returned3, correct3 ),
        ( returned4, correct4 ),
        ( returned5, correct5 ),
        ( returned6, correct6 ),
        ( returned7, correct7 ),
        ( returned8, correct8 ),
        ( returned9, correct9 ),
        ( returned10, correct10 )
    ]
end

function test_setindex!_forQuantityArray_errorsForMismatchedUnits()
    sqArray = [7, 2] * Alicorn.meter
    mismatchedUnit = Alicorn.second
    expectedError = Alicorn.Exceptions.DimensionMismatchError("dimensions of the quantity and the desired unit do not agree")
    @test_throws expectedError setindex!(sqArray, 2*mismatchedUnit, 1)
end

end # module
