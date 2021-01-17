module AbstractUnitTests

using Alicorn
using Test
using ..TestingTools

## 1. Mock implementations of AbstractUnit interface
struct MockUnitStub <: AbstractUnit end

struct MockUnit <: AbstractUnit
    mockUnitFactor::Real
end

function Alicorn.Units.convertToUnit(mockUnit::MockUnit)
    return mockUnit.mockUnitFactor
end

## 2. Test mock implementation
function run()
    # test interface to be implemented by AbstractUnit realizations
    @testset "AbstractUnit interface to implement" begin
        test_convertToUnit_required()
        test_UnitPrefix_AbstractUnit_multipliation_required()
        test_inv_required()
        test_exponenciation_required()
    end

    # test generic functions that are pre-implemented for all AbstractUnits
    @testset "AbstractUnit implemented functions" begin
        @test multiplication_implementedThrough_convertToUnit()
        @test division_implementedThrough_convertToUnit()
        @test AbstractUnit_actsAsScalarInBroadcast()
    end
end

function test_convertToUnit_required()
    mockUnit = MockUnitStub()
    expectedError = Core.ErrorException("subtype Main.UnitsTests.AbstractUnitTests.MockUnitStub of AbstractUnit misses an implementation of the convertToUnit function")
    @test_throws expectedError convertToUnit(mockUnit)
end

function test_UnitPrefix_AbstractUnit_multipliation_required()
    unitPrefix = TestingTools.generateRandomUnitPrefix()
    mockUnit = MockUnitStub()

    expectedError = Core.ErrorException("subtype Main.UnitsTests.AbstractUnitTests.MockUnitStub of AbstractUnit misses an implementation of multiplication with UnitPrefix")

    @test_throws expectedError unitPrefix * mockUnit
end

function test_inv_required()
    mockUnit = MockUnitStub()
    expectedError = Core.ErrorException("subtype Main.UnitsTests.AbstractUnitTests.MockUnitStub of AbstractUnit misses an implementation of the Base.inv function")
    @test_throws expectedError inv(mockUnit)
end

function test_exponenciation_required()
    mockUnit = MockUnitStub()
    exponent = TestingTools.generateRandomExponent()

    expectedError = Core.ErrorException("subtype Main.UnitsTests.AbstractUnitTests.MockUnitStub of AbstractUnit misses an implementation of the Base.^ function")

    @test_throws expectedError mockUnit^exponent
end

function multiplication_implementedThrough_convertToUnit()
    mockUnit1 = MockUnit(2.5)
    mockUnit2 = MockUnit(2)

    returnedProduct = mockUnit1 * mockUnit2
    correctProduct = 5.0

    return (returnedProduct == correctProduct)
end

function division_implementedThrough_convertToUnit()
    mockUnit1 = MockUnit(6)
    mockUnit2 = MockUnit(2)

    returnedQuotient = mockUnit1 / mockUnit2
    correctQuotient = 3.0

    return (returnedQuotient == correctQuotient)
end

function AbstractUnit_actsAsScalarInBroadcast()
    mockUnit1 = MockUnit(6)
    mockUnit2 = MockUnit(2)
    mockUnitArray = [ mockUnit1, mockUnit2 ]
    pass = false
    try
        elementwiseComparison = (mockUnitArray .== mockUnit1)
        pass = (elementwiseComparison == [true, false])
    catch
    end
    return pass
end

end # module
