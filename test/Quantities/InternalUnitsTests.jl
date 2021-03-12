module InternalUnitsTests

using Alicorn
using Test
using ..TestingTools

function run()
    @testset "InternalUnits" begin
        @test canInstanciateInternalUnitsWithoutArguments()
        @test defaultInternalUnitsInitializedCorrectly()
        @test InternalUnits_FieldsInitializedCorrectly()

        InternalUnits_ErrorsIfInternalUnitsNotReals()
        InternalUnits_ErrorsIfInternalUnitsInfinite()
        InternalUnits_ErrorsIfInternalUnitsZero()
        InternalUnits_ErrorsIfInternalUnitsWrongDimension()
    end
end

function canInstanciateInternalUnitsWithoutArguments()
    pass = false
    try
        InternalUnits()
        pass = true
    catch
    end
    return pass
end

function defaultInternalUnitsInitializedCorrectly()
    internalUnits = InternalUnits()

    one_kg = 1 * Alicorn.kilogram
    one_m = 1 * Alicorn.meter
    one_s = 1 * Alicorn.second
    one_A = 1 * Alicorn.ampere
    one_K = 1 * Alicorn.kelvin
    one_mol = 1 * Alicorn.mol
    one_cd = 1 * Alicorn.candela

    pass = true
    pass &= (internalUnits.mass == one_kg)
    pass &= internalUnits.length == one_m
    pass &= internalUnits.time == one_s
    pass &= internalUnits.current == one_A
    pass &= internalUnits.temperature == one_K
    pass &= internalUnits.amount == one_mol
    pass &= internalUnits.luminousIntensity == one_cd
    return pass
end

function InternalUnits_FieldsInitializedCorrectly()
    (randomInternalUnits, randomFields) = TestingTools.generateRandomInternalUnitsWithFields()
    return _verifyHasCorrectFields(randomInternalUnits, randomFields)
end

function _verifyHasCorrectFields(internalUnits::InternalUnits, fields::Dict)
    correct = true
    correct &= (internalUnits.mass == fields["massUnit"])
    correct &= (internalUnits.length == fields["lengthUnit"])
    correct &= (internalUnits.time == fields["timeUnit"])
    correct &= (internalUnits.current == fields["currentUnit"])
    correct &= (internalUnits.temperature == fields["temperatureUnit"])
    correct &= (internalUnits.amount == fields["amountUnit"])
    correct &= (internalUnits.luminousIntensity == fields["luminousIntensityUnit"])
    return correct
end

function InternalUnits_ErrorsIfInternalUnitsNotReals()
    invalidUnits = _getExamplesFor_InternalUnits_ErrorsIfInternalUnitsNotReals()
    expectedError = Core.DomainError("the values of internal units need to be real numbers")
    _testExamplesFor_InternalUnits_Errors(invalidUnits, expectedError)
end

function _getExamplesFor_InternalUnits_ErrorsIfInternalUnitsNotReals()
    invalidUnits = Dict{String, SimpleQuantity}()
    invalidUnits["mass"] = TestingTools.generateRandomNonzeroReal(dim=2) * Alicorn.gram
    invalidUnits["length"] = TestingTools.generateRandomNonzeroReal(dim=2) * Alicorn.meter
    invalidUnits["time"] = TestingTools.generateRandomNonzeroReal(dim=2) * Alicorn.second
    invalidUnits["current"] = TestingTools.generateRandomNonzeroReal(dim=2) * Alicorn.ampere
    invalidUnits["temperature"] = TestingTools.generateRandomNonzeroReal(dim=2) * Alicorn.kelvin
    invalidUnits["amount"] = TestingTools.generateRandomNonzeroReal(dim=2) * Alicorn.mol
    invalidUnits["luminousIntensity"] = TestingTools.generateRandomNonzeroReal(dim=2) * Alicorn.candela
    return invalidUnits
end

function _testExamplesFor_InternalUnits_Errors(invalidUnits::Dict{String, SimpleQuantity}, expectedError::Core.Exception)
    @test_throws expectedError InternalUnits(mass=invalidUnits["mass"])
    @test_throws expectedError InternalUnits(length=invalidUnits["length"])
    @test_throws expectedError InternalUnits(time=invalidUnits["time"])
    @test_throws expectedError InternalUnits(current=invalidUnits["current"])
    @test_throws expectedError InternalUnits(temperature=invalidUnits["temperature"])
    @test_throws expectedError InternalUnits(amount=invalidUnits["amount"])
    @test_throws expectedError InternalUnits(luminousIntensity=invalidUnits["luminousIntensity"])
end

function InternalUnits_ErrorsIfInternalUnitsInfinite()
    invalidUnits = _getExamplesFor_InternalUnits_ErrorsIfInternalUnitsInfinite()
    expectedError = Core.DomainError("the values of internal units need to be finite")
    _testExamplesFor_InternalUnits_Errors(invalidUnits, expectedError)
end

function _getExamplesFor_InternalUnits_ErrorsIfInternalUnitsInfinite()
    infiniteNumbers = TestingTools.getInfiniteNumbers()

    invalidUnits = Dict{String, SimpleQuantity}()
    invalidUnits["mass"] = rand(infiniteNumbers) * Alicorn.gram
    invalidUnits["length"] = rand(infiniteNumbers) * Alicorn.meter
    invalidUnits["time"] = rand(infiniteNumbers) * Alicorn.second
    invalidUnits["current"] = rand(infiniteNumbers) * Alicorn.ampere
    invalidUnits["temperature"] = rand(infiniteNumbers) * Alicorn.kelvin
    invalidUnits["amount"] = rand(infiniteNumbers) * Alicorn.mol
    invalidUnits["luminousIntensity"] = rand(infiniteNumbers) * Alicorn.candela
    return invalidUnits
end

function InternalUnits_ErrorsIfInternalUnitsZero()
    invalidUnits = _getExamplesFor_InternalUnits_ErrorsIfInternalUnitsZero()
    expectedError = Core.DomainError("the values of internal units need to be nonzero")
    _testExamplesFor_InternalUnits_Errors(invalidUnits, expectedError)
end

function _getExamplesFor_InternalUnits_ErrorsIfInternalUnitsZero()
    invalidUnits = Dict{String, SimpleQuantity}()
    invalidUnits["mass"] = 0 * Alicorn.gram
    invalidUnits["length"] = 0 * Alicorn.meter
    invalidUnits["time"] = 0 * Alicorn.second
    invalidUnits["current"] = 0 * Alicorn.ampere
    invalidUnits["temperature"] = 0 * Alicorn.kelvin
    invalidUnits["amount"] = 0 * Alicorn.mol
    invalidUnits["luminousIntensity"] = 0 * Alicorn.candela
    return invalidUnits
end

function InternalUnits_ErrorsIfInternalUnitsWrongDimension()
    invalidUnits = _getExamplesFor_InternalUnits_ErrorsIfInternalUnitsWrongDimension()
    expectedError = Alicorn.Exceptions.DimensionMismatchError("the specified internal unit has the wrong physical dimension")
    _testExamplesFor_InternalUnits_Errors(invalidUnits, expectedError)
end

function _getExamplesFor_InternalUnits_ErrorsIfInternalUnitsWrongDimension()
    invalidUnits = Dict{String, SimpleQuantity}()
    invalidUnits["mass"] = 1 * Alicorn.candela
    invalidUnits["length"] = 1 * Alicorn.gram
    invalidUnits["time"] = 1 * Alicorn.meter
    invalidUnits["current"] = 1 * Alicorn.second
    invalidUnits["temperature"] = 1 * Alicorn.ampere
    invalidUnits["amount"] = 1 * Alicorn.kelvin
    invalidUnits["luminousIntensity"] = 1 * Alicorn.mol
    return invalidUnits
end

end # module
