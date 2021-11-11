module InternalUnitsTests

using Alicorn
using Test
using ..TestingTools

const ucat = UnitCatalogue()

function run()
    @testset "InternalUnits" begin
        @test canInstanciateInternalUnitsWithoutArguments()
        @test defaultInternalUnitsInitializedCorrectly()
        @test InternalUnits_FieldsInitializedCorrectly()

        InternalUnits_ErrorsIfInternalUnitsNotReals()
        InternalUnits_ErrorsIfInternalUnitsInfinite()
        InternalUnits_ErrorsIfInternalUnitsZero()
        InternalUnits_ErrorsIfInternalUnitsWrongDimension()

        @test equality_implemented()
        @test internalUnitFor_implemented()
        @test conversionFactor_implemented()
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
    invalidUnits["mass"] = TestingTools.generateRandomNonzeroComplex() * Alicorn.gram
    invalidUnits["length"] = TestingTools.generateRandomNonzeroComplex() * Alicorn.meter
    invalidUnits["time"] = TestingTools.generateRandomNonzeroComplex() * Alicorn.second
    invalidUnits["current"] = TestingTools.generateRandomNonzeroComplex() * Alicorn.ampere
    invalidUnits["temperature"] = TestingTools.generateRandomNonzeroComplex() * Alicorn.kelvin
    invalidUnits["amount"] = TestingTools.generateRandomNonzeroComplex() * Alicorn.mol
    invalidUnits["luminousIntensity"] = TestingTools.generateRandomNonzeroComplex() * Alicorn.candela
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

function equality_implemented()
    examples = _getExamplesFor_equality()
    return TestingTools.testDyadicFunction(Base.:(==), examples)
end

function _getExamplesFor_equality()
    internalUnits1 = TestingTools.generateRandomInternalUnits()
    internalUnits2 = TestingTools.generateRandomInternalUnits()
    internalUnits1Copy = InternalUnits(
        mass=internalUnits1.mass,
        length=internalUnits1.length,
        time=internalUnits1.time,
        current=internalUnits1.current,
        temperature=internalUnits1.temperature,
        amount=internalUnits1.amount,
        luminousIntensity=internalUnits1.luminousIntensity
    )

    # format: internalUnits1, internalUnits2, correct result for internalUnits1 == internalUnits2
    examples = [
        ( internalUnits1, internalUnits1, true ),
        ( internalUnits1, internalUnits2, false ),
        ( internalUnits1, internalUnits1Copy, true )
    ]
    return examples
end

function internalUnitFor_implemented()
    examples = _getExamplesFor_internalUnitFor()
    return TestingTools.testDyadicFunction(internalUnitFor, examples)
end

function _getExamplesFor_internalUnitFor()
    # format: d::Dimension, intu::InternalUnits, sq::SimpleQuantity, correct result for internalUnitFor(d)
    examples = [
        (Dimension(), InternalUnits(), 1*Alicorn.unitlessUnit),
        (Dimension(L=1), InternalUnits(), 1*Alicorn.meter),
        (Dimension(L=2), InternalUnits(length=2*ucat.milli*ucat.meter), 4 * (ucat.milli*ucat.meter)^2 ),
        (Dimension(T=2, I=-1), InternalUnits(time=2*ucat.milli*ucat.second, current=0.5*ucat.kilo*ucat.ampere), 8 * (ucat.milli*ucat.second)^2 * (ucat.kilo*ucat.ampere)^-1 )
    ]
    return examples
end

function conversionFactor_implemented()
    examples = _getExamplesFor_conversionFactor()
    return TestingTools.testTriadicFunction(conversionFactor, examples)
end

function _getExamplesFor_conversionFactor()
    # format: d::Dimension, intu1::InternalUnits, intu2::InternalUnits, f::Number, correct result for conversionFactor(d, intu1, intu2)
    examples = [
        (Dimension(), InternalUnits(), InternalUnits(), 1),
        (Dimension(), InternalUnits(temperature=1*ucat.kelvin), InternalUnits(temperature=2*ucat.milli*ucat.kelvin), 1),
        (Dimension(θ=1), InternalUnits(temperature=1*ucat.kelvin), InternalUnits(temperature=2*ucat.milli*ucat.kelvin), 500),
        (Dimension(θ=-1.0), InternalUnits(temperature=1*ucat.kelvin), InternalUnits(temperature=2*ucat.milli*ucat.kelvin), 1/500),
        (Dimension(θ=2, L=1), InternalUnits(length=1*ucat.meter, temperature=1*ucat.kelvin), InternalUnits(length=2*ucat.meter, temperature=2*ucat.milli*ucat.kelvin), 125000)
    ]
    return examples
end

end # module
