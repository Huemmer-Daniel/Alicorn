module AbstractQuantityTests

using Alicorn
using Test
using ..TestingTools

## 1. Mock implementations of AbstractQuantity interface
struct MockQuantityStub{T} <: AbstractQuantity{T} end

## 2. Test mock implementation
function run()
    # test interface to be implemented by AbstractUnit realizations
    @testset "AbstractQuantity interface to implement" begin
        test_equality_required()
        test_inUnitsOf_required()
        test_inBasicSIUnits_required()
        test_AbstractQuantity_AbstractUnit_multiplicationRequired()
        test_AbstractQuantity_AbstractUnit_divisionRequired()
        test_addition_required()
        test_subtraction_required()
        test_multiplication_required()
        test_multiplicationWithDimensionless_required()
        test_division_required()
        test_divisionByDimensionless_required()
        test_inv_required()
        test_exponentiation_required()
        test_sqrt_required()

        test_length_required()
        test_size_required()
        test_getindex_required()
    end
end

function test_equality_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any} of AbstractQuantity misses an implementation of the == function")
    @test_throws expectedError (mockQuantity == mockQuantity)
end

function test_inUnitsOf_required()
    mockQuantity = MockQuantityStub{Any}()
    targetUnit = TestingTools.generateRandomUnit()
    expectedError = Core.ErrorException("subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any} of AbstractQuantity misses an implementation of the inUnitsOf function")
    @test_throws expectedError inUnitsOf(mockQuantity, targetUnit)
end

function test_inBasicSIUnits_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any} of AbstractQuantity misses an implementation of the inBasicSIUnits function")
    @test_throws expectedError inBasicSIUnits(mockQuantity)
end

function test_AbstractQuantity_AbstractUnit_multiplicationRequired()
    mockQuantity = MockQuantityStub{Any}()
    unit = TestingTools.generateRandomUnit()
    expectedError = Core.ErrorException("subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any} of AbstractQuantity misses an implementation of the multiplication with an AbstractUnit")
    @test_throws expectedError mockQuantity * unit
end

function test_AbstractQuantity_AbstractUnit_divisionRequired()
    mockQuantity = MockQuantityStub{Any}()
    unit = TestingTools.generateRandomUnit()
    expectedError = Core.ErrorException("subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any} of AbstractQuantity misses an implementation of the division by an AbstractUnit")
    @test_throws expectedError mockQuantity / unit
end

function test_addition_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any} of AbstractQuantity misses an implementation of addition")
    @test_throws expectedError mockQuantity + mockQuantity
end

function test_subtraction_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any} of AbstractQuantity misses an implementation of subtraction")
    @test_throws expectedError mockQuantity - mockQuantity
end

function test_multiplication_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any} of AbstractQuantity misses an implementation of multiplication")
    @test_throws expectedError mockQuantity * mockQuantity
end

function test_multiplicationWithDimensionless_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any} of AbstractQuantity misses an implementation of multiplication")
    @test_throws expectedError 2 * mockQuantity
    @test_throws expectedError mockQuantity * 2
end

function test_division_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any} of AbstractQuantity misses an implementation of division")
    @test_throws expectedError mockQuantity / mockQuantity
end

function test_divisionByDimensionless_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any} of AbstractQuantity misses an implementation of division")
    @test_throws expectedError mockQuantity / 2
    @test_throws expectedError 2 / mockQuantity
end

function test_inv_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any} of AbstractQuantity misses an implementation of the inv function")
    @test_throws expectedError inv(mockQuantity)
end

function test_exponentiation_required()
    mockQuantity = MockQuantityStub{Any}()
    exponent = TestingTools.generateRandomExponent()
    expectedError = Core.ErrorException("subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any} of AbstractQuantity misses an implementation of exponentiation")
    @test_throws expectedError mockQuantity^exponent
end

function test_sqrt_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any} of AbstractQuantity misses an implementation of the sqrt function")
    @test_throws expectedError sqrt(mockQuantity)
end

function test_length_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any} of AbstractQuantity misses an implementation of the length function")
    @test_throws expectedError length(mockQuantity)
end

function test_size_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any} of AbstractQuantity misses an implementation of the size function")
    @test_throws expectedError size(mockQuantity)
end

function test_getindex_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any} of AbstractQuantity misses an implementation of the getindex function")
    @test_throws expectedError getindex(mockQuantity, 1)
end

function test_setindex!_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any} of AbstractQuantity misses an implementation of the setindex! function")
    @test_throws expectedError setindex(mockQuantity, "value", 1)
end

end # module
