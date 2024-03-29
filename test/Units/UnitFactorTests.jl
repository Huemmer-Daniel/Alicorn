module UnitFactorTests

using Alicorn
using Test
using ..TestingTools

function run()
    @testset "UnitFactor" begin
        @test canInstanciateUnitFactor()
        test_UnitFactor_ErrorsOnInfiniteExponent()
        @test UnitFactor_ReturnsUnitlessOnZeroExponent()
        test_UnitFactor_TriesCastingExponentsToInt()
        @test UnitFactor_actsAsScalarInBroadcast()
        @test UnitFactor_fieldsCorrectlyInitialized()
        @test UnitFactor_RemovesPrefixAndExponentIfBaseUnitIsUnitless()

        @test equality_implemented()

        @test canInstanciateUnitFactorWithoutPrefix()
        @test canInstanciateUnitFactorWithoutExponent()
        @test canInstanciateUnitFactorWithoutPrefixAndExponent()
        @test canInstanciateUnitlessUnitFactor()

        @test unitlessUnitFactorIsDefined()
        @test kilogramIsDefined()

        @test inv_implemented()
        @test exponentiation_implemented()
        @test sqrt_implemented()
        @test cbrt_implemented()

        @test multiplication_implemented()
        @test division_implemented()

        @test BaseUnit_UnitFactor_multiplication_implemented()
        @test BaseUnit_UnitFactor_division_implemented()

        @test UnitPrefix_UnitFactor_multiplication_implemented()
        test_UnitPrefix_UnitFactor_multiplication_ErrorsOnNonemptyPrefixInUnitFactor()
        test_UnitPrefix_UnitFactor_multiplication_ErrorsOnNontrivialExponentInUnitFactor()

        @test convertToBasicSI_implemented()
    end
end

function canInstanciateUnitFactor()
    pass = false
    try
        unitPrefix = TestingTools.generateRandomUnitPrefix()
        baseUnit = TestingTools.generateRandomBaseUnit()
        exponent = TestingTools.generateRandomNonzeroReal()
        UnitFactor(unitPrefix, baseUnit, exponent)
        pass = true
    catch
    end
    return pass
end

function test_UnitFactor_ErrorsOnInfiniteExponent()
    infiniteExponents = TestingTools.getInfiniteNumbers()
    _verify_UnitFactor_ErrorsOnExponents(infiniteExponents)
end

function _verify_UnitFactor_ErrorsOnExponents(exponents::Vector{T}) where T <: Real
    unitPrefix = TestingTools.generateRandomUnitPrefix()
    baseUnit = TestingTools.generateRandomBaseUnit()
    for exponent in exponents
        _verify_UnitFactor_ErrorsOnExponent(unitPrefix, baseUnit, exponent)
    end
end

function _verify_UnitFactor_ErrorsOnExponent(unitPrefix::UnitPrefix, baseUnit::BaseUnit, exponent::Real)
    @test_throws DomainError(exponent,"argument must be finite") UnitFactor(unitPrefix, baseUnit, exponent)
end

function UnitFactor_ReturnsUnitlessOnZeroExponent()
    unitPrefix = TestingTools.generateRandomUnitPrefix()
    baseUnit = TestingTools.generateRandomBaseUnit()
    exponent = 0
    return ( UnitFactor(unitPrefix, baseUnit, exponent) == Alicorn.unitlessUnitFactor )
end

function test_UnitFactor_TriesCastingExponentsToInt()
    unitPrefix = TestingTools.generateRandomUnitPrefix()
    baseUnit = TestingTools.generateRandomBaseUnit()
    exponent = 3.0
    unitFactor = UnitFactor(unitPrefix, baseUnit, exponent)
    @test isa(unitFactor.exponent, Int)
end

function UnitFactor_actsAsScalarInBroadcast()
    (unitFactor1, unitFactor2) = _generateTwoDifferentUnitFactorsWithoutUsingBroadcasting()
    unitFactorArray = [ unitFactor1, unitFactor2 ]
    pass = false
    try
        elementwiseComparison = (unitFactorArray .== unitFactor1)
        pass = (elementwiseComparison == [true, false])
    catch
    end
    return pass
end

function _generateTwoDifferentUnitFactorsWithoutUsingBroadcasting()
    unitFactor1 = TestingTools.generateRandomUnitFactor()
    unitFactor2 = unitFactor1
    while unitFactor2 == unitFactor1
        unitFactor2 = TestingTools.generateRandomUnitFactor()
    end
    return (unitFactor1, unitFactor2)
end

function UnitFactor_fieldsCorrectlyInitialized()
    (unitFactor, randomFields) = TestingTools.generateRandomUnitFactorWithFields()
    return _verifyHasCorrectFields(unitFactor, randomFields)
end

function _verifyHasCorrectFields(unitFactor::UnitFactor, randomFields::Dict)
    correct = (unitFactor.unitPrefix == randomFields["unitPrefix"])
    correct &= (unitFactor.baseUnit == randomFields["baseUnit"])
    correct &= (unitFactor.exponent == randomFields["exponent"])
    return correct
end

function equality_implemented()
    randomFields1 = TestingTools.generateRandomUnitFactorFields()
    randomFields2 = deepcopy(randomFields1)
    unitFactor1 = _initializeUnitFactorFromDict(randomFields1)
    unitFactor2 = _initializeUnitFactorFromDict(randomFields2)
    return unitFactor1 == unitFactor2
end

function _initializeUnitFactorFromDict(fields::Dict)
    unitFactor = UnitFactor(
        fields["unitPrefix"],
        fields["baseUnit"],
        fields["exponent"]
    )
    return unitFactor
end

function UnitFactor_RemovesPrefixAndExponentIfBaseUnitIsUnitless()
    prefix = TestingTools.generateRandomUnitPrefix()
    exponent = TestingTools.generateRandomExponent()

    returnedFactor = UnitFactor(prefix, Alicorn.unitlessBaseUnit, exponent)
    returnedPrefix = returnedFactor.unitPrefix
    returnedExponent = returnedFactor.exponent

    correct = ( returnedPrefix == Alicorn.emptyUnitPrefix && returnedExponent == 1 )
    return correct
end

function canInstanciateUnitFactorWithoutPrefix()
    pass = false
    try
        baseUnit = TestingTools.generateRandomBaseUnit()
        exponent = TestingTools.generateRandomNonzeroReal()
        UnitFactor(baseUnit, exponent)
        pass = true
    catch
    end
    return pass
end

function canInstanciateUnitFactorWithoutExponent()
    pass = false
    try
        unitPrefix = TestingTools.generateRandomUnitPrefix()
        baseUnit = TestingTools.generateRandomBaseUnit()
        UnitFactor(unitPrefix, baseUnit)
        pass = true
    catch
    end
    return pass
end

function canInstanciateUnitFactorWithoutPrefixAndExponent()
    pass = false
    try
        baseUnit = TestingTools.generateRandomBaseUnit()
        UnitFactor(baseUnit)
        pass = true
    catch
    end
    return pass
end

function canInstanciateUnitlessUnitFactor()
    unitlessUnitFactor = UnitFactor(Alicorn.emptyUnitPrefix, Alicorn.unitlessBaseUnit, 1)
    return ( UnitFactor() == unitlessUnitFactor )
end

function unitlessUnitFactorIsDefined()
    unitless = Alicorn.unitlessUnitFactor

    expectedUnitPrefix = Alicorn.emptyUnitPrefix
    expectedBaseUnit = Alicorn.unitlessBaseUnit
    expectedExponent = 1

    correctUnitPrefix = (unitless.unitPrefix == expectedUnitPrefix)
    correctBaseUnit = (unitless.baseUnit == expectedBaseUnit)
    correctExponent = (unitless.exponent == expectedExponent)
    correct = (correctUnitPrefix && correctBaseUnit && correctExponent)

    return correct
end

function kilogramIsDefined()
    kilogram = Alicorn.kilo * Alicorn.gram
    return (Alicorn.kilogram == kilogram)
end

function inv_implemented()
    examples = _getExamplesFor_inv()
    return TestingTools.testMonadicFunction(inv, examples)
end

function _getExamplesFor_inv()
    unitPrefix = TestingTools.generateRandomUnitPrefix()
    baseUnit = TestingTools.generateRandomBaseUnit()
    exponent = TestingTools.generateRandomExponent()
    unitFactor = UnitFactor(unitPrefix, baseUnit, exponent)
    inverseUnitFactor = UnitFactor(unitPrefix, baseUnit, -exponent)
    unitlessUnitFactor = Alicorn.unitlessUnitFactor

    examples = [
        (unitlessUnitFactor, unitlessUnitFactor),
        (unitFactor, inverseUnitFactor)
    ]
    return examples
end

function exponentiation_implemented()
    examples = _getExamplesFor_exponentiation()
    return TestingTools.testDyadicFunction(Base.:^, examples)
end

function _getExamplesFor_exponentiation()
    unitPrefix = TestingTools.generateRandomUnitPrefix()
    baseUnit = TestingTools.generateRandomBaseUnit()

    examples = [
        ( Alicorn.unitlessUnitFactor, 0, Alicorn.unitlessUnitFactor ),
        ( Alicorn.unitlessUnitFactor, 1, Alicorn.unitlessUnitFactor ),
        ( Alicorn.unitlessUnitFactor, -1, Alicorn.unitlessUnitFactor ),
        ( Alicorn.unitlessUnitFactor, 2, Alicorn.unitlessUnitFactor ),
        ( UnitFactor(unitPrefix, baseUnit, 2), 0, Alicorn.unitlessUnitFactor ),
        ( UnitFactor(unitPrefix, baseUnit, 2), 3, UnitFactor(unitPrefix, baseUnit, 6) ),
        ( UnitFactor(unitPrefix, baseUnit, 4.0), 2, UnitFactor(unitPrefix, baseUnit, 8) ),
        ( UnitFactor(unitPrefix, baseUnit, 2), 0.5, UnitFactor(unitPrefix, baseUnit, 1) ),
        ( UnitFactor(unitPrefix, baseUnit, 2.5), 3, UnitFactor(unitPrefix, baseUnit, 7.5) ),
        ( UnitFactor(unitPrefix, baseUnit, 2.5), -3, UnitFactor(unitPrefix, baseUnit, -7.5) )
    ]
    return examples
end

function sqrt_implemented()
    examples = _getExamplesFor_sqrt()
    return TestingTools.testMonadicFunction(Base.:sqrt, examples)
end

function _getExamplesFor_sqrt()
    unitPrefix = TestingTools.generateRandomUnitPrefix()
    baseUnit = TestingTools.generateRandomBaseUnit()
    exponent = TestingTools.generateRandomExponent()

    # format: UnitFactor, correct result for sqrt(UnitFactor)
    examples = [
        ( Alicorn.unitlessUnitFactor, Alicorn.unitlessUnitFactor ),
        ( UnitFactor(unitPrefix, baseUnit, exponent), UnitFactor(unitPrefix, baseUnit, exponent/2) )
    ]
    return examples
end

function cbrt_implemented()
    examples = _getExamplesFor_cbrt()
    return TestingTools.testMonadicFunction(Base.:cbrt, examples)
end

function _getExamplesFor_cbrt()
    unitPrefix = TestingTools.generateRandomUnitPrefix()
    baseUnit = TestingTools.generateRandomBaseUnit()
    exponent = 6

    # format: UnitFactor, correct result for cbrt(UnitFactor)
    examples = [
        ( Alicorn.unitlessUnitFactor, Alicorn.unitlessUnitFactor ),
        ( UnitFactor(unitPrefix, baseUnit, exponent), UnitFactor(unitPrefix, baseUnit, exponent/3) )
    ]
    return examples
end


function multiplication_implemented()
    examples = _getExamplesFor_multiplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_multiplication()
    unitlessUnitFactor = Alicorn.unitlessUnitFactor
    unitlessUnit = Alicorn.unitlessUnit

    unitFactors = TestingTools.generateRandomUnitFactors(2)
    unitFactor1 = unitFactors[1]
    inverseUnitFactor1 = inv(unitFactor1)
    unitFactor2 = unitFactors[2]

    exmples = [
        (unitFactor1, unitFactor2, Unit([unitFactor1, unitFactor2]) ),
        (unitFactor1, inverseUnitFactor1, unitlessUnit),
        (unitFactor1, unitlessUnitFactor, Unit(unitFactor1) ),
        (unitlessUnitFactor, unitFactor2, Unit(unitFactor2) ),
        (unitlessUnitFactor, unitlessUnitFactor, unitlessUnit)
    ]
    return exmples
end

function division_implemented()
    examples = _getExamplesFor_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_division()
    unitlessUnitFactor = Alicorn.unitlessUnitFactor
    unitlessUnit = Alicorn.unitlessUnit

    unitFactor1 = TestingTools.generateRandomUnitFactor()
    invUnitFactor1 = inv(unitFactor1)
    unitFactor2 = TestingTools.generateRandomUnitFactor()
    invUnitFactor2 = inv(unitFactor2)

    # format: dividend, divisor, correct result for dividend / divisor
    # where dividend, divisor are instances of UnitFactor
    examples = [
        ( unitFactor1, unitFactor2, Unit([ unitFactor1, invUnitFactor2 ]) ),
        ( unitFactor1, unitFactor1, unitlessUnit),
        ( unitFactor1, unitlessUnitFactor, Unit(unitFactor1) ),
        ( unitlessUnitFactor, unitFactor2, Unit(invUnitFactor2) ),
        ( unitlessUnitFactor, unitlessUnitFactor, unitlessUnit )
    ]
    return examples
end

function BaseUnit_UnitFactor_multiplication_implemented()
    examples = _getExamplesFor_BaseUnit_UnitFactor_multiplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_BaseUnit_UnitFactor_multiplication()
    unitlessBaseUnit = Alicorn.unitlessBaseUnit
    unitlessUnitFactor = Alicorn.unitlessUnitFactor
    unitlessUnit = Alicorn.unitlessUnit

    baseUnit = TestingTools.generateRandomBaseUnit()
    inverseBaseUnit = inv(baseUnit)
    unitFactor = TestingTools.generateRandomUnitFactor()
    inverseUnitFactor = inv(unitFactor)

    # format: factor1, factor2, correct result for factor1 * factor2
    # where factor1, factor2 instances of BaseUnit or UnitFactor
    examples = [
        # factor1 is BaseUnit, factor2 is UnitFactor
        ( baseUnit, unitFactor, Unit([ UnitFactor(baseUnit), unitFactor ]) ),
        ( baseUnit, inverseBaseUnit, unitlessUnit ),
        ( baseUnit, unitlessUnitFactor, Unit(baseUnit) ),
        ( unitlessBaseUnit, unitFactor, Unit(unitFactor) ),
        ( unitlessBaseUnit, unitlessUnitFactor, unitlessUnit),

        # factor1 is UnitFactor, factor2 is BaseUnit
        ( unitFactor, baseUnit, Unit([ unitFactor, UnitFactor(baseUnit) ]) ),
        ( inverseBaseUnit, baseUnit, unitlessUnit ),
        ( unitFactor, unitlessBaseUnit, Unit(unitFactor) ),
        ( unitlessUnitFactor, baseUnit, Unit(baseUnit) ),
        ( unitlessUnitFactor, unitlessBaseUnit, unitlessUnit)
    ]
    return examples
end

function BaseUnit_UnitFactor_division_implemented()
    examples = _getExamplesFor_BaseUnit_UnitFactor_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_BaseUnit_UnitFactor_division()
        unitlessBaseUnit = Alicorn.unitlessBaseUnit
        unitlessUnitFactor = Alicorn.unitlessUnitFactor
        unitlessUnit = Alicorn.unitlessUnit

        baseUnit = TestingTools.generateRandomBaseUnit()
        inverseBaseUnit = inv(baseUnit)
        unitFactor = TestingTools.generateRandomUnitFactor()
        inverseUnitFactor = inv(unitFactor)

        # format: dividend, divisor, correct result for dividend / divisor
        # where dividend, divisor are instances of BaseUnit or UnitFactor
        examples = [
            # dividend is BaseUnit, divisor is UnitFactor
            ( baseUnit, unitFactor, Unit([ UnitFactor(baseUnit), inverseUnitFactor ]) ),
            ( baseUnit, UnitFactor(baseUnit), unitlessUnit ),
            ( baseUnit, unitlessUnitFactor, Unit(baseUnit) ),
            ( unitlessBaseUnit, unitFactor, Unit(inverseUnitFactor) ),
            ( unitlessBaseUnit, unitlessUnitFactor, unitlessUnit ),
            # dividend is UnitFactor, divisor is BaseUnit
            ( unitFactor, baseUnit, Unit([ unitFactor, inverseBaseUnit ]) ),
            ( UnitFactor(baseUnit), baseUnit, unitlessUnit),
            ( unitFactor, unitlessBaseUnit, Unit(unitFactor) ),
            ( unitlessUnitFactor, baseUnit, Unit(inverseBaseUnit) ),
            ( unitlessUnitFactor, unitlessBaseUnit, unitlessUnit )
        ]
        return examples
end

function UnitPrefix_UnitFactor_multiplication_implemented()
    prefix = TestingTools.generateRandomUnitPrefix()
    baseUnit = TestingTools.generateRandomBaseUnit()
    unitFactor = UnitFactor(baseUnit)
    returnedUnitFactor = prefix * unitFactor
    correctUnitFactor = UnitFactor(prefix, baseUnit)
    return (returnedUnitFactor == correctUnitFactor)
end

function test_UnitPrefix_UnitFactor_multiplication_ErrorsOnNonemptyPrefixInUnitFactor()
    prefix1 = TestingTools.generateRandomUnitPrefix()
    prefix2 = TestingTools.generateRandomUnitPrefix()
    baseUnit = TestingTools.generateRandomBaseUnit()
    unitFactor = UnitFactor(prefix2, baseUnit)
    @test_throws Base.ArgumentError("prefix of UnitFactor needs to be emptyUnitPrefix for multiplication of UnitPrefix with UnitFactor") (prefix1 * unitFactor)
end

function test_UnitPrefix_UnitFactor_multiplication_ErrorsOnNontrivialExponentInUnitFactor()
    prefix = TestingTools.generateRandomUnitPrefix()
    baseUnit = TestingTools.generateRandomBaseUnit()
    exponent = pi
    unitFactor = UnitFactor(baseUnit, exponent)
    @test_throws Base.ArgumentError("exponent of UnitFactor needs to be 1 for multiplication of UnitPrefix with UnitFactor") (prefix * unitFactor)
end

function convertToBasicSI_implemented()
    examples = _getExamplesFor_convertToBasicSI()
    return TestingTools.testMonadicFunction(convertToBasicSI, examples)
end

function _getExamplesFor_convertToBasicSI()
    ucat = UnitCatalogue()

    # format: UnitFactor, (corresponding prefactor, corresponding SI unit)
    examples = [
        ( ucat.meter^2, (1, Unit(ucat.meter^2)) ),
        ( ucat.gram^3, (1e-9, Unit((ucat.kilo * ucat.gram)^3)) ),
        ( (ucat.milli*ucat.liter)^(-1), (1e6, Unit(ucat.meter^-3)) )
    ]
    return examples
end

end # module
