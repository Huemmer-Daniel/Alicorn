module quantity_arrayMathTests

using Alicorn
using Test
using ..TestingTools

const ucat = UnitCatalogue()
const intu = InternalUnits()

function run()
    @testset "quantity_arrayMathTests" begin
        # circshift
        @test circshift_implemented_forSimpleQuantityArray()
        @test circshift_implemented_forQuantityArray()

        # transpose
        @test transpose_implemented_forSimpleQuantityArray()
        @test transpose_implemented_forQuantityArray()

        # findmax
        @test findmax_implemented_forSimpleQuantityArray()
        @test findmax_implemented_forQuantityArray()

        # findmin
        @test findmin_implemented_forSimpleQuantityArray()
        @test findmin_implemented_forQuantityArray()
    end
end


## circshift

function circshift_implemented_forSimpleQuantityArray()
    examples = _getExamplesFor_circshift_implemented_forSimpleQuantityArray()
    return TestingTools.testDyadicFunction(Base.circshift, examples)
end

function _getExamplesFor_circshift_implemented_forSimpleQuantityArray()
    # format: sq::SimpleQuantityArray, shifts, correct result for circshift(sq, shifts)
    examples = [
        ( SimpleQuantityArray( [1, 2, 3], ucat.unitless ), ( 2 ) ,
            SimpleQuantityArray( [2, 3, 1], ucat.unitless )),
        ( SimpleQuantityArray( [1 2 3; 5 6 7], ucat.meter ), ( 3 ) ,
            SimpleQuantityArray( [5 6 7; 1 2 3], ucat.meter )),
        ( SimpleQuantityArray( [1 2 3; 5 6 7], ucat.second ), ( 3, 2 ) ,
            SimpleQuantityArray( [6 7 5; 2 3 1], ucat.second )),
    ]
end

function circshift_implemented_forQuantityArray()
    examples = _getExamplesFor_circshift_implemented_forQuantityArray()
    return TestingTools.testDyadicFunction(Base.circshift, examples)
end

function _getExamplesFor_circshift_implemented_forQuantityArray()
    # format: q::QuantityArray, shifts, correct result for circshift(q, shifts)
    examples = [
        ( QuantityArray( [1, 2, 3] ), ( 2 ) ,
            QuantityArray( [2, 3, 1] )),
        ( QuantityArray( [1 2 3; 5 6 7], Dimension(T=1), InternalUnits(time=2*ucat.second) ), ( 3 ) ,
            QuantityArray( [5 6 7; 1 2 3], Dimension(T=1), InternalUnits(time=2*ucat.second) )),
        ( QuantityArray( [1 2 3; 5 6 7], Dimension(L=1), InternalUnits(time=2*ucat.second) ), ( 3, 2 ) ,
            QuantityArray( [6 7 5; 2 3 1], Dimension(L=1), InternalUnits(time=2*ucat.second) )),
    ]
end


## transpose

function transpose_implemented_forSimpleQuantityArray()
    examples = _getExamplesFor_transpose_implemented_forSimpleQuantityArray()
    return TestingTools.testMonadicFunction(Base.transpose, examples)
end

function _getExamplesFor_transpose_implemented_forSimpleQuantityArray()
    # format: sq::SimpleQuantityArray, correct result for transpose(sq)
    examples = [
        ( SimpleQuantityArray( ones(2,2), ucat.unitless ), SimpleQuantityArray( ones(2,2), ucat.unitless )  ),
        ( SimpleQuantityArray( [1 2], ucat.meter ), SimpleQuantityArray( reshape([1; 2], 2, 1), ucat.meter )  ),
        ( SimpleQuantityArray( [1, 2], ucat.second ), SimpleQuantityArray( [1 2], ucat.second )  ),
        ( SimpleQuantityArray( [1 2; 3 4], ucat.ampere ), SimpleQuantityArray( [1 3; 2 4], ucat.ampere )  ),
        ( SimpleQuantityArray( [1+3im 2; 3-2im 4], ucat.ampere ), SimpleQuantityArray( [1+3im 3-2im; 2 4], ucat.ampere )  ),
    ]
end

function transpose_implemented_forQuantityArray()
    examples = _getExamplesFor_transpose_implemented_forQuantityArray()
    return TestingTools.testMonadicFunction(Base.transpose, examples)
end

function _getExamplesFor_transpose_implemented_forQuantityArray()
    # format: sq::QuantityArray, correct result for transpose(sq)
    examples = [
        ( QuantityArray( ones(2,2) ), QuantityArray( ones(2,2) )  ),
        ( QuantityArray( [1 2] ), QuantityArray( reshape([1; 2], 2, 1) )  ),
        ( QuantityArray{Int32}( [1, 2], Dimension(L=1), intu ), QuantityArray{Int32}( [1 2], Dimension(L=1), intu  )  ),
        ( QuantityArray( [1 2; 3 4], Dimension(T=1), InternalUnits(time=2*ucat.second) ), QuantityArray( [1 3; 2 4], Dimension(T=1), InternalUnits(time=2*ucat.second) )  ),
        ( QuantityArray( [1+3im 2; 3-2im 4], Dimension(T=1), InternalUnits(time=2*ucat.second)), QuantityArray( [1+3im 3-2im; 2 4], Dimension(T=1), InternalUnits(time=2*ucat.second) )  ),
    ]
end


## findmax

function findmax_implemented_forSimpleQuantityArray()
    examples = _getExamplesFor_findmax_implemented_forSimpleQuantityArray()
    return TestingTools.testMonadicFunction(Base.findmax, examples)
end

function _getExamplesFor_findmax_implemented_forSimpleQuantityArray()
    # format: sq::SimpleQuantityArray, correct result for findmax(sq)
    examples = [
        ( SimpleQuantityArray( [ -4, 5 ], ucat.unitless ), (SimpleQuantity(5, ucat.unitless), 2) ),
        ( SimpleQuantityArray{Int32}( [ -4 5; 6 -5 ], ucat.meter ), (SimpleQuantity{Int32}(6, ucat.meter), CartesianIndex(2, 1)) ),
    ]
end

function findmax_implemented_forQuantityArray()
    examples = _getExamplesFor_findmax_implemented_forQuantityArray()
    return TestingTools.testMonadicFunction(Base.findmax, examples)
end

function _getExamplesFor_findmax_implemented_forQuantityArray()
    # format: q::QuantityArray, correct result for findmax(q)
    examples = [
        ( QuantityArray( [ -4, 5 ] ), (Quantity(5), 2) ),
        (QuantityArray{Int32}( [ -4 5; 6 -5 ], Dimension(T=1), InternalUnits(time=2*ucat.second) ),
            (Quantity{Int32}(6, Dimension(T=1), InternalUnits(time=2*ucat.second)), CartesianIndex(2, 1)) ),
    ]
end


## findmin

function findmin_implemented_forSimpleQuantityArray()
    examples = _getExamplesFor_findmin_implemented_forSimpleQuantityArray()
    return TestingTools.testMonadicFunction(Base.findmin, examples)
end

function _getExamplesFor_findmin_implemented_forSimpleQuantityArray()
    # format: sq::SimpleQuantityArray, correct result for findmin(sq)
    examples = [
        ( SimpleQuantityArray( [ -4, 5 ], ucat.unitless ), (SimpleQuantity(-4, ucat.unitless), 1) ),
        ( SimpleQuantityArray{Int32}( [ -4 5; 6 -5 ], ucat.meter ), (SimpleQuantity{Int32}(-5, ucat.meter), CartesianIndex(2, 2)) ),
    ]
end

function findmin_implemented_forQuantityArray()
    examples = _getExamplesFor_findmin_implemented_forQuantityArray()
    return TestingTools.testMonadicFunction(Base.findmin, examples)
end

function _getExamplesFor_findmin_implemented_forQuantityArray()
    # format: q::QuantityArray, correct result for findmin(q)
    examples = [
        ( QuantityArray( [ -4, 5 ] ), (Quantity(-4), 1) ),
        (QuantityArray{Int32}( [ -4 5; 6 -5 ], Dimension(T=1), InternalUnits(time=2*ucat.second) ),
            (Quantity{Int32}(-5, Dimension(T=1), InternalUnits(time=2*ucat.second)), CartesianIndex(2, 2)) ),
    ]
end

end # module
