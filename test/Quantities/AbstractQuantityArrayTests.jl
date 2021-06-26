module AbstractQuantityArrayTests

using Alicorn
using Test
using ..TestingTools

## Mock implementations of AbstractQuantity interface
struct MockQuantityArrayStub{T,N} <: AbstractQuantityArray{T,N} end

Base.size(A::MockQuantityArrayStub{T,N}) where {T,N} = (2,2)
Base.getindex(A::MockQuantityArrayStub{T,N}, inds...) where {T,N} = 7

## Test interface using mock implementation
function run()
    # test interface to be implemented by AbstractUnitArray realizations
    @testset "AbstractQuantityArray interface to implement" begin

        # 1. Unit conversion
        test_inUnitsOf_required()
        test_inBasicSIUnits_required()
        test_AbstractQuantityArray_AbstractUnit_multiplicationRequired()
        test_AbstractUnit_AbstractQuantityArray_multiplicationRequired()
    end
end

## 1. Unit conversion

function test_inUnitsOf_required()
    mockQArray = MockQuantityArrayStub{Any,2}()
    targetUnit = TestingTools.generateRandomUnit()
    expectedError = Core.ErrorException("missing specialization of inUnitsOf(::AbstractQuantityArray, ::AbstractUnit) for subtype Main.QuantitiesTests.AbstractQuantityArrayTests.MockQuantityArrayStub{Any, 2}")
    @test_throws expectedError inUnitsOf(mockQArray, targetUnit)
end

function test_inBasicSIUnits_required()
    mockQArray = MockQuantityArrayStub{Any,2}()
    expectedError = Core.ErrorException("missing specialization of inBasicSIUnits(::AbstractQuantityArray) for subtype Main.QuantitiesTests.AbstractQuantityArrayTests.MockQuantityArrayStub{Any, 2}")
    @test_throws expectedError inBasicSIUnits(mockQArray)
end

function test_AbstractQuantityArray_AbstractUnit_multiplicationRequired()
    mockQArray = MockQuantityArrayStub{Any,2}()
    unit = TestingTools.generateRandomUnit()
    expectedError = Core.ErrorException("missing specialization of Base.:*(::AbstractQuantityArray, ::AbstractUnit) for subtype Main.QuantitiesTests.AbstractQuantityArrayTests.MockQuantityArrayStub{Any, 2}")
    @test_throws expectedError mockQArray * unit
end

function test_AbstractUnit_AbstractQuantityArray_multiplicationRequired()
    mockQArray = MockQuantityArrayStub{Any,2}()
    unit = TestingTools.generateRandomUnit()
    expectedError = Core.ErrorException("missing specialization of Base.:*(::AbstractUnit, ::AbstractQuantityArray) for subtype Main.QuantitiesTests.AbstractQuantityArrayTests.MockQuantityArrayStub{Any, 2}")
    @test_throws expectedError unit * mockQArray
end

end # module
