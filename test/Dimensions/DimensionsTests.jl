module DimensionsTests

using Alicorn
using Test
using ..TestingTools

function run()
    @testset "Dimension" begin
        @test canInstanciateDimension()
        test_Dimension_ErrorsOnInfiniteArguments()
        @test Dimension_FieldsCorrectlyInitialized()
        @test Dimension_TriesCastingExponentsToInt()

        equality_implemented()
        @test Dimension_actsAsScalarInBroadcast()

        @test Number_Dimension_multiplication_implemented()
        @test inv_implemented()
        @test multiplication_implemented()
        @test division_implemented()
        @test exponentiation_implemented()
        @test sqrt_implemented()
        @test cbrt_implemented()
    end
end

function canInstanciateDimension()
    pass = false
    try
        Dimension(L=1, M=2, T=3, I=4, θ=5, N=6, J=7)
        pass = true
    catch
    end
    return pass
end

function test_Dimension_ErrorsOnInfiniteArguments()
    invalidExponents = _getExamplesFor_Dimension_ErrorsOnInfiniteArguments()
    _testExamplesFor_Dimension_ErrorsOnInfiniteArguments(invalidExponents)
end

function _getExamplesFor_Dimension_ErrorsOnInfiniteArguments()
    infiniteNumbers = TestingTools.getInfiniteNumbers()
    invalidExponents = Dict{String,Real}()
    invalidExponents["mass"] = rand(infiniteNumbers)
    invalidExponents["length"] = rand(infiniteNumbers)
    invalidExponents["time"] = rand(infiniteNumbers)
    invalidExponents["current"] = rand(infiniteNumbers)
    invalidExponents["temperature"] = rand(infiniteNumbers)
    invalidExponents["amount"] = rand(infiniteNumbers)
    invalidExponents["luminousIntensity"] = rand(infiniteNumbers)
    return invalidExponents
end

function _testExamplesFor_Dimension_ErrorsOnInfiniteArguments(invalidExponents::Dict{String,Real})
    @test_throws DomainError(invalidExponents["mass"], "argument must be finite") Dimension(M=invalidExponents["mass"])
    @test_throws DomainError(invalidExponents["length"], "argument must be finite") Dimension(M=invalidExponents["length"])
    @test_throws DomainError(invalidExponents["time"], "argument must be finite") Dimension(M=invalidExponents["time"])
    @test_throws DomainError(invalidExponents["current"], "argument must be finite") Dimension(M=invalidExponents["current"])
    @test_throws DomainError(invalidExponents["temperature"], "argument must be finite") Dimension(M=invalidExponents["temperature"])
    @test_throws DomainError(invalidExponents["amount"], "argument must be finite") Dimension(M=invalidExponents["amount"])
    @test_throws DomainError(invalidExponents["luminousIntensity"], "argument must be finite") Dimension(M=invalidExponents["luminousIntensity"])
end

function Dimension_FieldsCorrectlyInitialized()
    (dimension, randFields) = TestingTools.generateRandomDimenionWithFields()
    return _verifyHasCorrectFields(dimension, randFields)
end

function _verifyHasCorrectFields(dimension::Dimension, randFields::Dict)
    correct = ( dimension.massExponent == randFields["mass"] )
    correct &= ( dimension.lengthExponent == randFields["length"] )
    correct &= ( dimension.timeExponent == randFields["time"] )
    correct &= ( dimension.currentExponent == randFields["current"] )
    correct &= ( dimension.temperatureExponent == randFields["temperature"] )
    correct &= ( dimension.amountExponent == randFields["amount"] )
    correct &= ( dimension.luminousIntensityExponent == randFields["luminousIntensity"] )
    return correct
end

function Dimension_TriesCastingExponentsToInt()
    dimension = Dimension(L=1.0, M=2.0, T=3.0, I=4.0, θ=5.0, N=6.0, J=7.0)

    pass = isa(dimension.lengthExponent, Int)
    pass &= isa(dimension.massExponent, Int)
    pass &= isa(dimension.timeExponent, Int)
    pass &= isa(dimension.currentExponent, Int)
    pass &= isa(dimension.temperatureExponent, Int)
    pass &= isa(dimension.amountExponent, Int)
    pass &= isa(dimension.luminousIntensityExponent, Int)
    return pass
end

function equality_implemented()
    randomFields1 = TestingTools.generateRandomDimensionFields()
    randomFields2 = deepcopy(randomFields1)
    dimension1 = _initializeDimensionFromDict(randomFields1)
    dimension2 = _initializeDimensionFromDict(randomFields2)
    return dimension1 == dimension2
end

function _initializeDimensionFromDict(fields::Dict)
    dimension = Dimension(
        L = fields["length"],
        M = fields["mass"],
        T = fields["time"],
        I = fields["current"],
        θ = fields["temperature"],
        N = fields["amount"],
        J = fields["luminousIntensity"]
    )
    return dimension
end

function Dimension_actsAsScalarInBroadcast()
    (dimension1, dimension2) = _generateTwoDifferentDimensionsWithoutUsingBroadcasting()
    DimensionExponentsArray = [ dimension1, dimension2 ]
    pass = false
    try
        elementwiseComparison = (DimensionExponentsArray .== dimension1)
        pass = elementwiseComparison == [true, false]
        catch
    end
    return pass
end

function _generateTwoDifferentDimensionsWithoutUsingBroadcasting()
    dimension1 = TestingTools.generateRandomDimension()
    dimension2 = dimension1
    while dimension2 == dimension1
        dimension2 = TestingTools.generateRandomDimension()
    end
    return (dimension1, dimension2)
end

function Number_Dimension_multiplication_implemented()
    examples = _getExamplesFor_Number_Dimension_multiplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_Number_Dimension_multiplication()
    examples = [
        ( 3, Dimension(M=1), Dimension(M=3) ),
        ( 3, Dimension(L=2), Dimension(L=6) ),
        ( 3, Dimension(T=-2), Dimension(T=-6) ),
        ( 3, Dimension(I=2, T=-2), Dimension(I=6, T=-6) ),
        ( 3, Dimension(θ=5), Dimension(θ=15) ),
        ( -1, Dimension(N=-1), Dimension(N=1) ),
        ( Dimension(J=2), 2, Dimension(J=4) )
    ]
    return examples
end

function inv_implemented()
    examples = _getExamplesFor_inv()
    return TestingTools.testMonadicFunction(Base.inv, examples)
end

function _getExamplesFor_inv()
    examples = [
        ( Dimension(M=1), Dimension(M=-1) ),
        ( Dimension(L=2), Dimension(L=-2) ),
        ( Dimension(T=-2), Dimension(T=2) ),
        ( Dimension(I=7), Dimension(I=-7) ),
        ( Dimension(N=-2), Dimension(N=2) ),
        ( Dimension(J=3, N=-2), Dimension(J=-3, N=2) )
    ]
    return examples
end

function multiplication_implemented()
    examples = _getExamplesFor_multiplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_multiplication()
    examples = [
        ( Dimension(M=1), Dimension(M=1, L=2), Dimension(M=2, L=2) ),
        ( Dimension(L=2), Dimension(L=-2), Dimension(L=0) ),
        ( Dimension(T=-2), Dimension(T=1), Dimension(T=-1) ),
        ( Dimension(I=-2), Dimension(I=7), Dimension(I=5) ),
        ( Dimension(N=-2), Dimension(N=7), Dimension(N=5) ),
        ( Dimension(J=3, N=-2), Dimension(N=7, J=-1), Dimension(N=5, J=2) )
    ]
    return examples
end

function division_implemented()
    examples = _getExamplesFor_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_division()
    examples = [
        ( Dimension(M=1), Dimension(M=1, L=2), Dimension(L=-2) ),
        ( Dimension(L=2), Dimension(L=2), Dimension(L=0) ),
        ( Dimension(T=-2), Dimension(T=-1), Dimension(T=-1) ),
        ( Dimension(I=-2), Dimension(I=-7), Dimension(I=5) ),
        ( Dimension(N=-2), Dimension(N=-7), Dimension(N=5) ),
        ( Dimension(J=3, N=-2), Dimension(N=7, J=-1), Dimension(N=-9, J=4) )
    ]
    return examples
end

function exponentiation_implemented()
    examples = _getExamplesFor_exponentiation()
    return TestingTools.testDyadicFunction(Base.:^, examples)
end

function _getExamplesFor_exponentiation()
    examples = [
        ( Dimension(M=1), 1, Dimension(M=1) ),
        ( Dimension(M=1), 2, Dimension(M=2) ),
        ( Dimension(L=2), 1/2, Dimension(L=1) ),
        ( Dimension(T=-2), 3.5, Dimension(T=-7) ),
        ( Dimension(I=-2), -2, Dimension(I=4) ),
        ( Dimension(N=-2), -1, Dimension(N=2) ),
        ( Dimension(J=3, N=-2), 2.5, Dimension(J=7.5, N=-5) )
    ]
    return examples
end

function sqrt_implemented()
    examples = _getExamplesFor_sqrt()
    return TestingTools.testMonadicFunction(Base.:sqrt, examples)
end

function _getExamplesFor_sqrt()
    examples = [
        ( Dimension(M=1), Dimension(M=1/2) ),
        ( Dimension(L=2), Dimension(L=1) ),
        ( Dimension(T=-2), Dimension(T=-1) ),
        ( Dimension(N=-2), Dimension(N=-1) ),
        ( Dimension(J=3, N=-2), Dimension(J=3/2, N=-1) )
    ]
    return examples
end

function cbrt_implemented()
    examples = _getExamplesFor_cbrt()
    return TestingTools.testMonadicFunction(Base.:cbrt, examples)
end

function _getExamplesFor_cbrt()
    examples = [
        ( Dimension(M=1), Dimension(M=1/3) ),
        ( Dimension(L=2), Dimension(L=2/3) ),
        ( Dimension(T=-2), Dimension(T=-2/3 ) ),
        ( Dimension(N=-2), Dimension(N=-2/3) ),
        ( Dimension(J=3, N=-2), Dimension(J=1, N=-2/3) )
    ]
    return examples
end

end # module
