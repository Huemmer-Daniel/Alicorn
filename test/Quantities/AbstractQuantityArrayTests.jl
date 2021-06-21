module AbstractQuantityArrayTests

using Alicorn
using Test
using ..TestingTools

## Mock implementations of AbstractQuantity interface
struct MockQuantityArrayStub{T,N} <: AbstractQuantityArray{T,N} end

## Test interface using mock implementation
function run()
    # test interface to be implemented by AbstractUnitArray realizations
    @testset "AbstractQuantityArray interface to implement" begin

        # 1. Unit conversion
        test_inUnitsOf_required()
    end
end

## 1. Unit conversion

function test_inUnitsOf_required()
    mockQArray = MockQuantityArrayStub{Any,2}()
    targetUnit = TestingTools.generateRandomUnit()
    expectedError = Core.ErrorException("missing specialization of inUnitsOf(::AbstractQuantityArray, ::AbstractUnit) for subtype Main.QuantitiesTests.AbstractQuantityArrayTests.MockQuantityArrayStub{Any, 2}")
    @test_throws expectedError inUnitsOf(mockQArray, targetUnit)
end

end # module
