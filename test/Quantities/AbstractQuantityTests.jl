module AbstractQuantityTests

using Alicorn
using Test
using ..TestingTools

## Mock implementations of AbstractQuantity interface
struct MockQuantityStub{T} <: AbstractQuantity{T} end

## Test interface using mock implementation
function run()
    # test interface to be implemented by AbstractUnit realizations
    @testset "AbstractQuantity interface to implement" begin

        # 1. Unit conversion
        test_inUnitsOf_required()
        test_inBasicSIUnits_required()
        test_AbstractQuantity_AbstractUnit_multiplicationRequired()
        test_AbstractUnit_AbstractQuantity_multiplicationRequired()
        test_AbstractQuantity_AbstractUnit_divisionRequired()
        test_AbstractUnit_AbstractQuantity_divisionRequired()

        # 2. Arithemtic unary and binary operators
        test_unary_plus_required()
        test_unary_minus_required()
        test_addition_required()
        test_subtraction_required()
        test_multiplication_required()
        test_multiplicationWithDimensionless_required()
        test_division_required()
        test_divisionByDimensionless_required()
        test_inverseDivision_required()
        test_inverseDivisionByDimensionless_required()
        test_exponentiation_required()
        test_inv_required()

        # 4. Numeric comparison
        test_equality_required()
        test_isless_required()
        test_isfinite_required()
        test_isinf_required()
        test_isnan_required()
        test_isnan_required()
        test_isapprox_required()

        # 5. Rounding
        test_mod2pi_required()

        # 6. Sign and absolute value
        test_abs_required()
        test_abs2_required()
        test_sign_required()
        test_signbit_required()

        # 7. Roots
        test_sqrt_required()

        # 8. Literal zero
        # 9. Complex numbers
        # 10. Compatibility with array functions
        test_length_required()
        test_size_required()
    end
end

## 1. Unit conversion

function test_inUnitsOf_required()
    mockQuantity = MockQuantityStub{Any}()
    targetUnit = TestingTools.generateRandomUnit()
    expectedError = Core.ErrorException("missing specialization of inUnitsOf(::AbstractQuantity, ::AbstractUnit) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError inUnitsOf(mockQuantity, targetUnit)
end

function test_inBasicSIUnits_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("missing specialization of inBasicSIUnits(::AbstractQuantity) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError inBasicSIUnits(mockQuantity)
end

function test_AbstractQuantity_AbstractUnit_multiplicationRequired()
    mockQuantity = MockQuantityStub{Any}()
    unit = TestingTools.generateRandomUnit()
    expectedError = Core.ErrorException("missing specialization of Base.:*(::AbstractQuantity, ::AbstractUnit) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError mockQuantity * unit
end

function test_AbstractUnit_AbstractQuantity_multiplicationRequired()
    mockQuantity = MockQuantityStub{Any}()
    unit = TestingTools.generateRandomUnit()
    expectedError = Core.ErrorException("missing specialization of Base.:*(::AbstractUnit, ::AbstractQuantity) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError unit * mockQuantity
end

function test_AbstractQuantity_AbstractUnit_divisionRequired()
    mockQuantity = MockQuantityStub{Any}()
    unit = TestingTools.generateRandomUnit()
    expectedError = Core.ErrorException("missing specialization of Base.:/(::AbstractQuantity, ::AbstractUnit) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError mockQuantity / unit
end

function test_AbstractUnit_AbstractQuantity_divisionRequired()
    mockQuantity = MockQuantityStub{Any}()
    unit = TestingTools.generateRandomUnit()
    expectedError = Core.ErrorException("missing specialization of Base.:/(::AbstractUnit, ::AbstractQuantity) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError unit / mockQuantity
end

## 2. Arithmetic unary and binary operators

function test_unary_plus_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("missing specialization of Base.:+(::AbstractQuantity) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError (+mockQuantity)
end

function test_unary_minus_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("missing specialization of Base.:-(::AbstractQuantity) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError (-mockQuantity)
end

function test_addition_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("missing specialization of Base.:+(::AbstractQuantity, ::AbstractQuantity) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError mockQuantity + mockQuantity
end

function test_subtraction_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("missing specialization of Base.:-(::AbstractQuantity, ::AbstractQuantity) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError mockQuantity - mockQuantity
end

function test_multiplication_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("missing specialization of Base.:*(::AbstractQuantity, ::AbstractQuantity) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError mockQuantity * mockQuantity
end

function test_multiplicationWithDimensionless_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("missing specialization of Base.:*(::Number, ::AbstractQuantity) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError 2 * mockQuantity
    expectedError = Core.ErrorException("missing specialization of Base.:*(::AbstractQuantity, ::Number) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError mockQuantity * 2
end

function test_division_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("missing specialization of Base.:/(::AbstractQuantity, ::AbstractQuantity) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError mockQuantity / mockQuantity
end

function test_divisionByDimensionless_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("missing specialization of Base.:/(::AbstractQuantity, ::Number) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError mockQuantity / 2
    expectedError = Core.ErrorException("missing specialization of Base.:/(::Number, ::AbstractQuantity) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError 2 / mockQuantity
end

function test_inverseDivision_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException(raw"missing specialization of Base.:\(::AbstractQuantity, ::AbstractQuantity) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError mockQuantity \ mockQuantity
end

function test_inverseDivisionByDimensionless_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException(raw"missing specialization of Base.:\(::AbstractQuantity, ::Number) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError mockQuantity \ 2
    expectedError = Core.ErrorException(raw"missing specialization of Base.:\(::Number, ::AbstractQuantity) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError 2 \ mockQuantity
end

function test_exponentiation_required()
    mockQuantity = MockQuantityStub{Any}()
    exponent = TestingTools.generateRandomExponent()
    expectedError = Core.ErrorException("missing specialization of Base.:^(::AbstractQuantity, ::Number) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError mockQuantity^exponent
end

function test_inv_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("missing specialization of Base.inv(::AbstractQuantity) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError inv(mockQuantity)
end

## 3. Updating binary operators

function test_updatingPlus_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("missing specialization of Base.+=(::AbstractQuantity, ::AbstractQuantity) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError inv(mockQuantity)
end

## 4. Numeric comparison

function test_equality_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("missing specialization of Base.:==(::AbstractQuantity, ::AbstractQuantity) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError (mockQuantity == mockQuantity)
end

function test_isless_required()
    mockQuantity1 = MockQuantityStub{Any}()
    mockQuantity2 = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("missing specialization of Base.isless(::AbstractQuantity, ::AbstractQuantity) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError isless(mockQuantity1, mockQuantity2)
end

function test_isfinite_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("missing specialization of Base.isfinite(::AbstractQuantity) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError isfinite(mockQuantity)
end

function test_isinf_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("missing specialization of Base.isinf(::AbstractQuantity) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError isinf(mockQuantity)
end

function test_isnan_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("missing specialization of Base.isnan(::AbstractQuantity) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError isnan(mockQuantity)
end

function test_isapprox_required()
    mockQuantity1 = MockQuantityStub{Any}()
    mockQuantity2 = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("missing specialization of Base.isapprox(::AbstractQuantity, ::AbstractQuantity, ::Real) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError isapprox(mockQuantity1, mockQuantity2)
end

## 5. Rounding

function test_mod2pi_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("missing specialization of Base.mod2pi(::AbstractQuantity) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError mod2pi(mockQuantity)
end

## 6. Sign and absolute value

function test_abs_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("missing specialization of Base.abs(::AbstractQuantity) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError abs(mockQuantity)
end

function test_abs2_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("missing specialization of Base.abs2(::AbstractQuantity) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError abs2(mockQuantity)
end

function test_sign_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("missing specialization of Base.sign(::AbstractQuantity) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError sign(mockQuantity)
end

function test_signbit_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("missing specialization of Base.signbit(::AbstractQuantity) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError signbit(mockQuantity)
end

## 7. Roots

function test_sqrt_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("missing specialization of Base.sqrt(::AbstractQuantity) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError sqrt(mockQuantity)
end

## 8. Literal zero

## 9. Complex numbers

## 10. Compatibility with array functions

function test_length_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("missing specialization of Base.length(::AbstractQuantity) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError length(mockQuantity)
end

function test_size_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("missing specialization of Base.size(::AbstractQuantity) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError size(mockQuantity)
end

end # module
