module DimensionTests

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
        @test addition_implemented()
    end
end

function canInstanciateDimension()
    pass = false
    try
        Dimension(length=1, mass=2, time=3, current=4, temperature=5, amount=6, luminousIntensity=7)
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
    @test_throws DomainError(invalidExponents["mass"], "argument must be finite") Dimension(mass=invalidExponents["mass"])
    @test_throws DomainError(invalidExponents["length"], "argument must be finite") Dimension(mass=invalidExponents["length"])
    @test_throws DomainError(invalidExponents["time"], "argument must be finite") Dimension(mass=invalidExponents["time"])
    @test_throws DomainError(invalidExponents["current"], "argument must be finite") Dimension(mass=invalidExponents["current"])
    @test_throws DomainError(invalidExponents["temperature"], "argument must be finite") Dimension(mass=invalidExponents["temperature"])
    @test_throws DomainError(invalidExponents["amount"], "argument must be finite") Dimension(mass=invalidExponents["amount"])
    @test_throws DomainError(invalidExponents["luminousIntensity"], "argument must be finite") Dimension(mass=invalidExponents["luminousIntensity"])
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
    dimension = Dimension(length=1.0, mass=2.0, time=3.0, current=4.0, temperature=5.0, amount=6.0, luminousIntensity=7.0)

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
        length = fields["length"],
        mass = fields["mass"],
        time = fields["time"],
        current = fields["current"],
        temperature = fields["temperature"],
        amount = fields["amount"],
        luminousIntensity = fields["luminousIntensity"]
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
        ( 3, Dimension(mass=1), Dimension(mass=3) ),
        ( 3, Dimension(length=2), Dimension(length=6) ),
        ( 3, Dimension(time=-2), Dimension(time=-6) ),
        ( 3, Dimension(current=2, time=-2), Dimension(current=6, time=-6) ),
        ( 3, Dimension(temperature=5), Dimension(temperature=15) ),
        ( -1, Dimension(amount=-1), Dimension(amount=1) ),
        ( Dimension(luminousIntensity=2), 2, Dimension(luminousIntensity=4) )
    ]
    return examples
end

function addition_implemented()
    examples = _getExamplesFor_addition()
    return TestingTools.testDyadicFunction(Base.:+, examples)
end

function _getExamplesFor_addition()
examples = [
    ( Dimension(mass=1), Dimension(mass=1, length=2), Dimension(mass=2, length=2) ),
    ( Dimension(length=2), Dimension(length=-2), Dimension(length=0) ),
    ( Dimension(time=-2), Dimension(time=1), Dimension(time=-1) ),
    ( Dimension(current=-2), Dimension(current=7), Dimension(current=5) ),
    ( Dimension(amount=-2), Dimension(amount=7), Dimension(amount=5) ),
    ( Dimension(luminousIntensity=3, amount=-2), Dimension(amount=7, luminousIntensity=-1), Dimension(amount=5, luminousIntensity=2) )
]
return examples
end

end # module
