module AbstractQuantityArrayTests

using Alicorn
using Test
using ..TestingTools

## Mock implementations of AbstractQuantity interface
struct MockQuantityArrayStub{T,N} <: AbstractQuantityArray{T,N} end

Base.size(A::MockQuantityArrayStub{T,N}) where {T,N} = (2,2)
Base.getindex(A::MockQuantityArrayStub{T,N}, inds...) where {T,N} = 7

## Mock implementations of AbstractQuantity interface
struct MockQuantityStub{T} <: AbstractQuantity{T} end

## Test interface using mock implementation
function run()
    # test interface to be implemented by AbstractUnitArray realizations
    @testset "AbstractQuantityArray interface to implement" begin

        # 1. Unit conversion
        test_inUnitsOf_required()
        test_inBasicSIUnits_required()
        test_AbstractQuantityArray_AbstractUnit_multiplicationRequired()
        test_AbstractUnit_AbstractQuantityArray_multiplicationRequired()
        test_AbstractQuantityArray_AbstractUnit_divisionRequired()
        test_AbstractUnit_AbstractQuantityArray_divisionRequired()

        # 2. Arithemtic unary and binary operators
        test_unary_plus_required()
        test_unary_minus_required()
        test_addition_required()
        test_subtraction_required()
        # multiplication
        test_multiplication_required()
        test_AbstractQuantityArray_Array_multiplication_required()
        test_Array_AbstractQuantityArray_multiplication_required()
        test_AbstractQuantityArray_AbstractQuantity_multiplication_required()
        test_AbstractQuantity_AbstractQuantityArray_multiplication_required()
        test_AbstractQuantityArray_Number_multiplication_required()
        test_Number_AbstractQuantityArray_multiplication_required()
        # division
        test_division_required()
        test_AbstractQuantityArray_Array_division_required()
        test_Array_AbstractQuantityArray_division_required()
        test_AbstractQuantityArray_AbstractQuantity_division_required()
        test_AbstractQuantity_AbstractQuantityArray_division_required()
        test_AbstractQuantityArray_Number_division_required()
        test_Number_AbstractQuantityArray_division_required()
        # inverse division
        test_inverseDivision_required()
        test_AbstractQuantityArray_Array_inverseDivision_required()
        test_Array_AbstractQuantityArray_inverseDivision_required()
        # AbstractQuantityArray  \ AbstractQuantity not required, since there is no function Base.\(::Array, ::Number)
        test_AbstractQuantity_AbstractQuantityArray_inverseDivision_required()
        # AbstractQuantityArray  \ Number not required, since there is no function Base.\(::Array, ::Number)
        test_Number_AbstractQuantityArray_inverseDivision_required()
        test_exponentiation_required()
        test_inv_required()

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

function test_AbstractQuantityArray_AbstractUnit_divisionRequired()
    mockQArray = MockQuantityArrayStub{Any,2}()
    unit = TestingTools.generateRandomUnit()
    expectedError = Core.ErrorException("missing specialization of Base.:/(::AbstractQuantityArray, ::AbstractUnit) for subtype Main.QuantitiesTests.AbstractQuantityArrayTests.MockQuantityArrayStub{Any, 2}")
    @test_throws expectedError mockQArray / unit
end

function test_AbstractUnit_AbstractQuantityArray_divisionRequired()
    mockQArray = MockQuantityArrayStub{Any,2}()
    unit = TestingTools.generateRandomUnit()
    expectedError = Core.ErrorException("missing specialization of Base.:/(::AbstractUnit, ::AbstractQuantityArray) for subtype Main.QuantitiesTests.AbstractQuantityArrayTests.MockQuantityArrayStub{Any, 2}")
    @test_throws expectedError unit / mockQArray
end

## 2. Arithmetic unary and binary operators

function test_unary_plus_required()
    mockQArray = MockQuantityArrayStub{Any,2}()
    expectedError = Core.ErrorException("missing specialization of Base.:+(::AbstractQuantityArray) for subtype Main.QuantitiesTests.AbstractQuantityArrayTests.MockQuantityArrayStub{Any, 2}")
    @test_throws expectedError (+mockQArray)
end

function test_unary_minus_required()
    mockQArray = MockQuantityArrayStub{Any,2}()
    expectedError = Core.ErrorException("missing specialization of Base.:-(::AbstractQuantityArray) for subtype Main.QuantitiesTests.AbstractQuantityArrayTests.MockQuantityArrayStub{Any, 2}")
    @test_throws expectedError (-mockQArray)
end

function test_addition_required()
    mockQArray = MockQuantityArrayStub{Any,2}()
    expectedError = Core.ErrorException("missing specialization of Base.:+(::AbstractQuantityArray, ::AbstractQuantityArray) for subtype Main.QuantitiesTests.AbstractQuantityArrayTests.MockQuantityArrayStub{Any, 2}")
    @test_throws expectedError mockQArray + mockQArray
end

function test_subtraction_required()
    mockQArray = MockQuantityArrayStub{Any,2}()
    expectedError = Core.ErrorException("missing specialization of Base.:-(::AbstractQuantityArray, ::AbstractQuantityArray) for subtype Main.QuantitiesTests.AbstractQuantityArrayTests.MockQuantityArrayStub{Any, 2}")
    @test_throws expectedError mockQArray - mockQArray
end

function test_multiplication_required()
    mockQArray = MockQuantityArrayStub{Any,2}()
    expectedError = Core.ErrorException("missing specialization of Base.:*(::AbstractQuantityArray, ::AbstractQuantityArray) for subtype Main.QuantitiesTests.AbstractQuantityArrayTests.MockQuantityArrayStub{Any, 2}")
    @test_throws expectedError mockQArray * mockQArray
end

function test_AbstractQuantityArray_Array_multiplication_required()
    mockQArray = MockQuantityArrayStub{Any,2}()
    array = TestingTools.generateRandomReal(dim=(2,3))
    expectedError = Core.ErrorException("missing specialization of Base.:*(::AbstractQuantityArray, ::Array{<:Number}) for subtype Main.QuantitiesTests.AbstractQuantityArrayTests.MockQuantityArrayStub{Any, 2}")
    @test_throws expectedError mockQArray * array
end

function test_Array_AbstractQuantityArray_multiplication_required()
    mockQArray = MockQuantityArrayStub{Any,2}()
    array = TestingTools.generateRandomReal(dim=(2,3))
    expectedError = Core.ErrorException("missing specialization of Base.:*(::Array{<:Number}, ::AbstractQuantityArray) for subtype Main.QuantitiesTests.AbstractQuantityArrayTests.MockQuantityArrayStub{Any, 2}")
    @test_throws expectedError array * mockQArray
end

function test_AbstractQuantityArray_AbstractQuantity_multiplication_required()
    mockQArray = MockQuantityArrayStub{Any,2}()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("missing specialization of Base.:*(::AbstractQuantityArray, ::AbstractQuantity) for subtype Main.QuantitiesTests.AbstractQuantityArrayTests.MockQuantityArrayStub{Any, 2}")
    @test_throws expectedError mockQArray * mockQuantity
end

function test_AbstractQuantity_AbstractQuantityArray_multiplication_required()
    mockQArray = MockQuantityArrayStub{Any,2}()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("missing specialization of Base.:*(::AbstractQuantity, ::AbstractQuantityArray) for subtype Main.QuantitiesTests.AbstractQuantityArrayTests.MockQuantityArrayStub{Any, 2}")
    @test_throws expectedError mockQuantity * mockQArray
end

function test_AbstractQuantityArray_Number_multiplication_required()
    mockQArray = MockQuantityArrayStub{Any,2}()
    expectedError = Core.ErrorException("missing specialization of Base.:*(::AbstractQuantityArray, ::Number) for subtype Main.QuantitiesTests.AbstractQuantityArrayTests.MockQuantityArrayStub{Any, 2}")
    @test_throws expectedError mockQArray * 2
end

function test_Number_AbstractQuantityArray_multiplication_required()
    mockQArray = MockQuantityArrayStub{Any,2}()
    expectedError = Core.ErrorException("missing specialization of Base.:*(::Number, ::AbstractQuantityArray) for subtype Main.QuantitiesTests.AbstractQuantityArrayTests.MockQuantityArrayStub{Any, 2}")
    @test_throws expectedError 2 * mockQArray
end

function test_division_required()
    mockQArray = MockQuantityArrayStub{Any,2}()
    expectedError = Core.ErrorException("missing specialization of Base.:/(::AbstractQuantityArray, ::AbstractQuantityArray) for subtype Main.QuantitiesTests.AbstractQuantityArrayTests.MockQuantityArrayStub{Any, 2}")
    @test_throws expectedError mockQArray / mockQArray
end

function test_AbstractQuantityArray_Array_division_required()
    mockQArray = MockQuantityArrayStub{Any,2}()
    array = TestingTools.generateRandomReal(dim=(2,3))
    expectedError = Core.ErrorException("missing specialization of Base.:/(::AbstractQuantityArray, ::Array{<:Number}) for subtype Main.QuantitiesTests.AbstractQuantityArrayTests.MockQuantityArrayStub{Any, 2}")
    @test_throws expectedError mockQArray / array
end

function test_Array_AbstractQuantityArray_division_required()
    mockQArray = MockQuantityArrayStub{Any,2}()
    array = TestingTools.generateRandomReal(dim=(2,3))
    expectedError = Core.ErrorException("missing specialization of Base.:/(::Array{<:Number}, ::AbstractQuantityArray) for subtype Main.QuantitiesTests.AbstractQuantityArrayTests.MockQuantityArrayStub{Any, 2}")
    @test_throws expectedError array / mockQArray
end

function test_AbstractQuantityArray_AbstractQuantity_division_required()
    mockQArray = MockQuantityArrayStub{Any,2}()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("missing specialization of Base.:/(::AbstractQuantityArray, ::AbstractQuantity) for subtype Main.QuantitiesTests.AbstractQuantityArrayTests.MockQuantityArrayStub{Any, 2}")
    @test_throws expectedError mockQArray / mockQuantity
end

function test_AbstractQuantity_AbstractQuantityArray_division_required()
    mockQArray = MockQuantityArrayStub{Any,2}()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException("missing specialization of Base.:/(::AbstractQuantity, ::AbstractQuantityArray) for subtype Main.QuantitiesTests.AbstractQuantityArrayTests.MockQuantityArrayStub{Any, 2}")
    @test_throws expectedError mockQuantity / mockQArray
end

function test_AbstractQuantityArray_Number_division_required()
    mockQArray = MockQuantityArrayStub{Any,2}()
    expectedError = Core.ErrorException("missing specialization of Base.:/(::AbstractQuantityArray, ::Number) for subtype Main.QuantitiesTests.AbstractQuantityArrayTests.MockQuantityArrayStub{Any, 2}")
    @test_throws expectedError mockQArray / 2
end

function test_Number_AbstractQuantityArray_division_required()
    mockQArray = MockQuantityArrayStub{Any,2}()
    expectedError = Core.ErrorException("missing specialization of Base.:/(::Number, ::AbstractQuantityArray) for subtype Main.QuantitiesTests.AbstractQuantityArrayTests.MockQuantityArrayStub{Any, 2}")
    @test_throws expectedError 2 / mockQArray
end

function test_inverseDivision_required()
    mockQArray = MockQuantityArrayStub{Any,2}()
    expectedError = Core.ErrorException(raw"missing specialization of Base.:\(::AbstractQuantityArray, ::AbstractQuantityArray) for subtype Main.QuantitiesTests.AbstractQuantityArrayTests.MockQuantityArrayStub{Any, 2}")
    @test_throws expectedError mockQArray \ mockQArray
end

function test_AbstractQuantityArray_Array_inverseDivision_required()
    mockQArray = MockQuantityArrayStub{Any,2}()
    array = TestingTools.generateRandomReal(dim=(2,3))
    expectedError = Core.ErrorException(raw"missing specialization of Base.:\(::AbstractQuantityArray, ::Array{<:Number}) for subtype Main.QuantitiesTests.AbstractQuantityArrayTests.MockQuantityArrayStub{Any, 2}")
    @test_throws expectedError mockQArray \ array
end

function test_Array_AbstractQuantityArray_inverseDivision_required()
    mockQArray = MockQuantityArrayStub{Any,2}()
    array = TestingTools.generateRandomReal(dim=(2,3))
    expectedError = Core.ErrorException(raw"missing specialization of Base.:\(::Array{<:Number}, ::AbstractQuantityArray) for subtype Main.QuantitiesTests.AbstractQuantityArrayTests.MockQuantityArrayStub{Any, 2}")
    @test_throws expectedError array \ mockQArray
end

function test_AbstractQuantity_AbstractQuantityArray_inverseDivision_required()
    mockQArray = MockQuantityArrayStub{Any,2}()
    mockQuantity = MockQuantityStub{Any}()
    expectedError = Core.ErrorException(raw"missing specialization of Base.:\(::AbstractQuantity, ::AbstractQuantityArray) for subtype Main.QuantitiesTests.AbstractQuantityArrayTests.MockQuantityArrayStub{Any, 2}")
    @test_throws expectedError mockQuantity \ mockQArray
end

function test_Number_AbstractQuantityArray_inverseDivision_required()
    mockQArray = MockQuantityArrayStub{Any,2}()
    expectedError = Core.ErrorException(raw"missing specialization of Base.:\(::Number, ::AbstractQuantityArray) for subtype Main.QuantitiesTests.AbstractQuantityArrayTests.MockQuantityArrayStub{Any, 2}")
    @test_throws expectedError 2 \ mockQArray
end

function test_exponentiation_required()
    mockQArray = MockQuantityArrayStub{Any,2}()
    exponent = TestingTools.generateRandomExponent()
    expectedError = Core.ErrorException(raw"missing specialization of Base.:^(::AbstractQuantityArray, ::Number) for subtype Main.QuantitiesTests.AbstractQuantityArrayTests.MockQuantityArrayStub{Any, 2}")
    @test_throws expectedError mockQArray^exponent
end

function test_inv_required()
    mockQArray = MockQuantityArrayStub{Any,2}()
    expectedError = Core.ErrorException("missing specialization of Base.inv(::AbstractQuantityArray) for subtype Main.QuantitiesTests.AbstractQuantityArrayTests.MockQuantityArrayStub{Any, 2}")
    @test_throws expectedError inv(mockQArray)
end

end # module
