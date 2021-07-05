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
        test_AbstractQuantity_Number_multiplication_required()
        test_Number_AbstractQuantity_multiplication_required()
        test_AbstractQuantity_Array_multiplication_required()
        test_Array_AbstractQuantity_multiplication_required()
        test_division_required()
        test_AbstractQuantity_Array_division_required()
        test_Array_AbstractQuantity_division_required()
        test_AbstractQuantity_Number_division_required()
        test_Number_AbstractQuantity_division_required()
        test_inverseDivision_required()
        test_AbstractQuantity_Array_inverseDivision_required()
        test_Array_AbstractQuantity_inverseDivision_required()
        test_AbstractQuantity_Number_inverseDivision_required()
        test_Number_AbstractQuantity_inverseDivision_required()
        test_exponentiation_required()
        test_inv_required()

        # 3. Numeric comparison
        test_equality_required()
        test_isless_required()
        test_isfinite_required()
        test_isinf_required()
        test_isnan_required()
        test_isnan_required()
        test_isapprox_required()

        # 4. Rounding
        test_mod2pi_required()

        # 5. Sign and absolute value
        test_abs_required()
        test_abs2_required()
        test_sign_required()
        test_signbit_required()
        test_copysign_required()
        test_flipsign_required()

        # 6. Roots
        test_sqrt_required()
        test_cbrt_required()

        # 7. Literal zero
        test_zero_required()

        # 8. Complex numbers
        test_real_required()
        test_imag_required()
        test_conj_required()
        test_angle_required()

        # 9. Compatibility with array functions
        test_length_required()
        test_size_required()
        test_ndims_required()
        test_getindex_required()
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

function test_AbstractQuantity_Number_multiplication_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("missing specialization of Base.:*(::AbstractQuantity, ::Number) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError mockQuantity * 2
end

function test_Number_AbstractQuantity_multiplication_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("missing specialization of Base.:*(::Number, ::AbstractQuantity) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError 2 * mockQuantity
end

function test_AbstractQuantity_Array_multiplication_required()
    mockQuantity = MockQuantityStub{Any}()
    array = TestingTools.generateRandomReal(dim=(2,3))
    expectedError = Core.ErrorException("missing specialization of Base.:*(::AbstractQuantity, ::Array{<:Number}) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError mockQuantity * array
end

function test_Array_AbstractQuantity_multiplication_required()
    mockQuantity = MockQuantityStub{Any}()
    array = TestingTools.generateRandomReal(dim=(2,3))
    expectedError = Core.ErrorException("missing specialization of Base.:*(::Array{<:Number}, ::AbstractQuantity) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError array * mockQuantity
end

function test_division_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("missing specialization of Base.:/(::AbstractQuantity, ::AbstractQuantity) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError mockQuantity / mockQuantity
end

function test_AbstractQuantity_Array_division_required()
    mockQuantity = MockQuantityStub{Any}()
    array = TestingTools.generateRandomReal(dim=(2,3))
    expectedError = Core.ErrorException("missing specialization of Base.:/(::AbstractQuantity, ::Array{<:Number}) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError mockQuantity / array
end

function test_Array_AbstractQuantity_division_required()
    mockQuantity = MockQuantityStub{Any}()
    array = TestingTools.generateRandomReal(dim=(2,3))
    expectedError = Core.ErrorException("missing specialization of Base.:/(::Array{<:Number}, ::AbstractQuantity) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError array / mockQuantity
end

function test_AbstractQuantity_Number_division_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("missing specialization of Base.:/(::AbstractQuantity, ::Number) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError mockQuantity / 2
end

function test_Number_AbstractQuantity_division_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("missing specialization of Base.:/(::Number, ::AbstractQuantity) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError 2 / mockQuantity
end

function test_inverseDivision_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException(raw"missing specialization of Base.:\(::AbstractQuantity, ::AbstractQuantity) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError mockQuantity \ mockQuantity
end

function test_AbstractQuantity_Array_inverseDivision_required()
    mockQuantity = MockQuantityStub{Any}()
    array = TestingTools.generateRandomReal(dim=(2,3))
    expectedError = Core.ErrorException("missing specialization of Base.:/(::AbstractQuantity, ::Array{<:Number}) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError mockQuantity \ array
end

function test_Array_AbstractQuantity_inverseDivision_required()
    mockQuantity = MockQuantityStub{Any}()
    array = TestingTools.generateRandomReal(dim=(2,3))
    expectedError = Core.ErrorException("missing specialization of Base.:/(::Array{<:Number}, ::AbstractQuantity) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError array \ mockQuantity
end

function test_AbstractQuantity_Number_inverseDivision_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException(raw"missing specialization of Base.:\(::AbstractQuantity, ::Number) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError mockQuantity \ 2
end

function test_Number_AbstractQuantity_inverseDivision_required()
    mockQuantity = MockQuantityStub{Any}()
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

## 3. Numeric comparison

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

## 4. Rounding

function test_mod2pi_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("missing specialization of Base.mod2pi(::AbstractQuantity) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError mod2pi(mockQuantity)
end

## 5. Sign and absolute value

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

function test_copysign_required()
    mockQuantity = MockQuantityStub{Any}()
    mockQuantity2 = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("missing specialization of Base.copysign(::AbstractQuantity, ::AbstractQuantity) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError copysign(mockQuantity, mockQuantity2)
    expectedError = Core.ErrorException("missing specialization of Base.copysign(::AbstractQuantity, ::Number) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError copysign(mockQuantity, -7)
    expectedError = Core.ErrorException("missing specialization of Base.copysign(::Number, ::AbstractQuantity) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError copysign(-7, mockQuantity)
end

function test_flipsign_required()
    mockQuantity = MockQuantityStub{Any}()
    mockQuantity2 = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("missing specialization of Base.flipsign(::AbstractQuantity, ::AbstractQuantity) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError flipsign(mockQuantity, mockQuantity2)
    expectedError = Core.ErrorException("missing specialization of Base.flipsign(::AbstractQuantity, ::Number) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError flipsign(mockQuantity, -7)
    expectedError = Core.ErrorException("missing specialization of Base.flipsign(::Number, ::AbstractQuantity) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError flipsign(7, mockQuantity)
end

## 6. Roots

function test_sqrt_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("missing specialization of Base.sqrt(::AbstractQuantity) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError sqrt(mockQuantity)
end

function test_cbrt_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("missing specialization of Base.cbrt(::AbstractQuantity) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError cbrt(mockQuantity)
end

## 7. Literal zero

function test_zero_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("missing specialization of Base.zero(::AbstractQuantity) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError zero(mockQuantity)
end

## 8. Complex numbers

function test_real_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("missing specialization of Base.real(::AbstractQuantity) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError real(mockQuantity)
end

function test_imag_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("missing specialization of Base.imag(::AbstractQuantity) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError imag(mockQuantity)
end

function test_conj_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("missing specialization of Base.conj(::AbstractQuantity) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError conj(mockQuantity)
end

function test_angle_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("missing specialization of Base.angle(::AbstractQuantity) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError angle(mockQuantity)
end

## 9. Compatibility with array functions

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

function test_ndims_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("missing specialization of Base.ndims(::AbstractQuantity) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError ndims(mockQuantity)
end

function test_getindex_required()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("missing specialization of Base.getindex(::AbstractQuantity, inds...) for subtype Main.QuantitiesTests.AbstractQuantityTests.MockQuantityStub{Any}")
    @test_throws expectedError getindex(mockQuantity, 1)
end

end # module
