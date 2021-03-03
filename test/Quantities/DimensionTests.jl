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

        @test dimensionOf_implementedForUnits()
        @test dimensionOf_implementedForQuantities()
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

function addition_implemented()
    examples = _getExamplesFor_addition()
    return TestingTools.testDyadicFunction(Base.:+, examples)
end

function _getExamplesFor_addition()
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

function dimensionOf_implementedForUnits()
    examples = _getExamplesFor_dimensionOf_forUnits()
    return TestingTools.testMonadicFunction(dimensionOf, examples)
end

struct MockUnitForDimension <: AbstractUnit
    unitFactor::UnitFactor
end

function Alicorn.Units.convertToUnit(mockUnit::MockUnitForDimension)
    return convertToUnit(mockUnit.unitFactor)
end

function _getExamplesFor_dimensionOf_forUnits()
    ucat = UnitCatalogue()

    # format: object of type AbstractUnit, corresponding Dimension
    examples = [
        # BaseUnit
        ( Alicorn.unitlessBaseUnit, Dimension( ) ),
        ( ucat.joule, Dimension( M=1, L=2, T=-2 ) ),
        # UnitFactor
        ( Alicorn.unitlessUnitFactor, Dimension( ) ),
        ( ucat.tera * ucat.farad, Dimension( M=-1, L=-2, T=4, I=2 ) ),
        # Unit
        ( Alicorn.unitlessUnit, Dimension( ) ),
        ( (ucat.nano * ucat.siemens) / ucat.mol * ucat.candela^2 * ucat.kelvin^-3, Dimension( M=-1, L=-2, T=3, I=2, N=-1, J=2, θ=-3 ) ),
        # AbstractUnit
        ( MockUnitForDimension( (ucat.nano * ucat.siemens) ), Dimension( M=-1, L=-2, T=3, I=2 ) ),
    ]
    return examples
end

function dimensionOf_implementedForQuantities()
    examples = _getExamplesFor_dimensionOf_forQuantities()
    return TestingTools.testMonadicFunction(dimensionOf, examples)
end

struct MockQuantityForDimension <: AbstractQuantity
    unit::Unit
end

function Alicorn.Quantities.inBasicSIUnits(mockQuantity::MockQuantityForDimension)
    mockUnit = mockQuantity.unit
    return 1 * mockUnit
end

function _getExamplesFor_dimensionOf_forQuantities()
    ucat = UnitCatalogue()

    # format: object of type AbstractQuantity, corresponding Dimension
    examples = [
        # SimpleQuantity
        ( 1 * Alicorn.unitlessUnit, Dimension() ),
        ( 1 * ucat.henry, Dimension(M=1, L=2, T=-2, I=-2) ),
        # AbstractQuantity
        ( MockQuantityForDimension( Unit(ucat.henry) ), Dimension(M=1, L=2, T=-2, I=-2)  )
    ]
    return examples
end

end # module
