module BaseUnitTests

using Alicorn
using Test
using ..TestingTools

function run()
    @testset "BaseUnit" begin
        @test canInstantiateBaseUnit()
        test_BaseUnit_ErrorsOnInfinitePrefactor()
        test_BaseUnit_ErrorsForNonIdentifierNames()
        @test BaseUnit_FieldsCorrectlyInitialized()
        @test equality_implemented()

        @test unitlessBaseUnitIsDefined()
        @test gramIsDefined()
        @test meterIsDefined()
        @test secondIsDefined()
        @test ampereIsDefined()
        @test kelvinIsDefined()
        @test molIsDefined()
        @test candelaIsDefined()

        @test BaseUnit_actsAsScalarInBroadcast()

        @test inv_implemented()
        @test exponentiation_implemented()
        @test sqrt_implemented()
        @test cbrt_implemented()

        @test multiplication_implemented()
        @test division_implemented()

        @test UnitPrefix_BaseUnit_multiplication_implemented()

        @test convertToBasicSI_implemented()
    end
end

function canInstantiateBaseUnit()
    pass = false
    try
        BaseUnit(
            name="gram",
            symbol="g",
            prefactor=1e-3,
            exponents=BaseUnitExponents(kg=1)
        )
        pass = true
    catch
    end
    return pass
end

function test_BaseUnit_ErrorsOnInfinitePrefactor()
    infiniteNumbers = TestingTools.getInfiniteNumbers()
    for number in infiniteNumbers
        @test_throws DomainError(number,"argument must be finite") BaseUnit(
            name="gram",
            symbol="g",
            prefactor=number,
            exponents=BaseUnitExponents(kg=1)
        )
    end
end

function test_BaseUnit_ErrorsForNonIdentifierNames()
    invalidNames = TestingTools.getInvalidUnitElementNamesTestset()
    for name in invalidNames
        @test_throws ArgumentError("name argument must be a valid identifier") BaseUnit(
            name = name,
            symbol = "t",
            prefactor = 2,
            exponents = BaseUnitExponents()
        )
    end
end

function BaseUnit_FieldsCorrectlyInitialized()
    (baseUnit, randFields) = TestingTools.generateRandomBaseUnitWithFields()
    return _verifyHasCorrectFields(baseUnit, randFields)
end

function _verifyHasCorrectFields(baseUnit::BaseUnit, randFields::Dict)
    correct = (baseUnit.name == randFields["name"])
    correct &= (baseUnit.symbol == randFields["symbol"])
    correct &= (baseUnit.prefactor == randFields["prefactor"])
    correct &= (baseUnit.exponents == randFields["exponents"])
    return correct
end

function equality_implemented()
    randomFields1 = TestingTools.generateRandomBaseUnitFields()
    randomFields2 = deepcopy(randomFields1)
    baseUnit1 = _initializeUnitFactorFromDict(randomFields1)
    baseUnit2 = _initializeUnitFactorFromDict(randomFields2)
    return baseUnit1 == baseUnit2
end

function _initializeUnitFactorFromDict(fields::Dict)
    baseUnit = BaseUnit(
        name = fields["name"],
        symbol = fields["symbol"],
        prefactor = fields["prefactor"],
        exponents = fields["exponents"]
    )
    return baseUnit
end

function unitlessBaseUnitIsDefined()
    unitless = Alicorn.unitlessBaseUnit

    expectedName = "unitless"
    expectedSymbol = "<unitless>"
    expectedPrefactor = 1
    expectedExponents = BaseUnitExponents()

    correctName = (unitless.name == expectedName)
    correctSymbol = (unitless.symbol == expectedSymbol)
    correctPrefactor = (unitless.prefactor == expectedPrefactor)
    correctExponents =  (unitless.exponents == expectedExponents)
    correct = (correctName && correctSymbol && correctPrefactor && correctExponents)

    return correct
end

function gramIsDefined()
    gram = BaseUnit(
        name = "gram",
        symbol = "g",
        prefactor = 1e-3,
        exponents = BaseUnitExponents(kg=1)
    )
    return (Alicorn.gram == gram)
end

function meterIsDefined()
    meter = BaseUnit( name="meter", symbol="m", prefactor=1, exponents=BaseUnitExponents(m=1) )
    return (Alicorn.meter == meter)
end

function secondIsDefined()
    second = BaseUnit( name="second", symbol="s", prefactor=1, exponents=BaseUnitExponents(s=1) )
    return (Alicorn.second == second)
end

function ampereIsDefined()
    ampere = BaseUnit( name="ampere", symbol="A", prefactor=1, exponents=BaseUnitExponents(A=1) )
    return (Alicorn.ampere == ampere)
end

function kelvinIsDefined()
    kelvin = BaseUnit(name="kelvin", symbol="K", prefactor=1, exponents=BaseUnitExponents(K=1))
    return (Alicorn.kelvin == kelvin)
end

function molIsDefined()
    mol = BaseUnit(name="mol", symbol="mol", prefactor=1, exponents=BaseUnitExponents(mol=1))
    return (Alicorn.mol == mol)
end

function candelaIsDefined()
    candela = BaseUnit(name="candela", symbol="cd", prefactor=1, exponents=BaseUnitExponents(cd=1))
    return (Alicorn.candela == candela)
end

function BaseUnit_actsAsScalarInBroadcast()
    (baseUnit1, baseUnit2) = _generateTwoDifferentBaseUnitsWithoutUsingBroadcasting()
    baseUnitArray = [ baseUnit1, baseUnit2 ]
    pass = false
    try
        elementwiseComparison = (baseUnitArray .== baseUnit1)
        pass = (elementwiseComparison == [true, false])
    catch
    end
    return pass
end

function _generateTwoDifferentBaseUnitsWithoutUsingBroadcasting()
    baseUnit1 = TestingTools.generateRandomBaseUnit()
    baseUnit2 = baseUnit1
    while baseUnit2 == baseUnit1
        baseUnit2 = TestingTools.generateRandomBaseUnit()
    end
    return (baseUnit1, baseUnit2)
end

function inv_implemented()
    examples = _getExamplesFor_inv_implemented()
    return TestingTools.testMonadicFunction(Base.inv, examples)
end

function _getExamplesFor_inv_implemented()
    unitlessBaseUnit = Alicorn.unitlessBaseUnit
    unitlessUnitFactor = Alicorn.unitlessUnitFactor

    baseUnit = TestingTools.generateRandomBaseUnit()

    # format: baseUnit, correct result for baseUnit^(-1)
    examples = [
        ( unitlessBaseUnit, unitlessUnitFactor ),
        ( baseUnit, UnitFactor(baseUnit, -1) )
    ]
end

function exponentiation_implemented()
    examples =  _getExamplesFor_exponentiation()
    return TestingTools.testDyadicFunction(Base.:^, examples)
end

function _getExamplesFor_exponentiation()
    unitlessBaseUnit = Alicorn.unitlessBaseUnit
    unitlessUnitFactor = Alicorn.unitlessUnitFactor

    baseUnit = TestingTools.generateRandomBaseUnit()
    exponent = TestingTools.generateRandomExponent()

    # format: baseUnit, exponent, correct result for baseUnit^exponent
    examples = [
        ( unitlessBaseUnit, 0, unitlessUnitFactor ),
        ( unitlessBaseUnit, 1, unitlessUnitFactor ),
        ( unitlessBaseUnit, -1, unitlessUnitFactor ),
        ( unitlessBaseUnit, 2, unitlessUnitFactor ),
        ( baseUnit, 0, unitlessUnitFactor ),
        ( baseUnit, exponent, UnitFactor(baseUnit, exponent) )
    ]
end

function sqrt_implemented()
    examples = _getExamplesFor_sqrt()
    return TestingTools.testMonadicFunction(Base.sqrt, examples)
end

function _getExamplesFor_sqrt()
    unitlessBaseUnit = Alicorn.unitlessBaseUnit
    unitlessUnitFactor = Alicorn.unitlessUnitFactor

    baseUnit = TestingTools.generateRandomBaseUnit()
    exponent = TestingTools.generateRandomExponent()

    # format: baseUnit, exponent, correct result for baseUnit^exponent
    examples = [
        ( unitlessBaseUnit, unitlessUnitFactor ),
        ( baseUnit, UnitFactor(baseUnit, 0.5) )
    ]
    return examples
end

function cbrt_implemented()
    examples = _getExamplesFor_cbrt()
    return TestingTools.testMonadicFunction(Base.cbrt, examples)
end

function _getExamplesFor_cbrt()
    unitlessBaseUnit = Alicorn.unitlessBaseUnit
    unitlessUnitFactor = Alicorn.unitlessUnitFactor

    baseUnit = TestingTools.generateRandomBaseUnit()
    exponent = TestingTools.generateRandomExponent()

    # format: baseUnit, correct result for cbrt(baseUnit)
    examples = [
        ( unitlessBaseUnit, unitlessUnitFactor ),
        ( baseUnit, UnitFactor(baseUnit, 1/3) )
    ]
    return examples
end

function multiplication_implemented()
    examples = _getExamplesFor_multiplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_multiplication()
    unitlessBaseUnit = Alicorn.unitlessBaseUnit
    unitlessUnit = Alicorn.unitlessUnit

    baseUnit1 = TestingTools.generateRandomBaseUnit()
    baseUnit2 = TestingTools.generateRandomBaseUnit()

    # format: factor1, factor2, correct result for factor1 * factor2
    # where factor1, factor2 are instances of BaseUnit
    examples = [
        ( baseUnit1, baseUnit2, Unit([UnitFactor(baseUnit1), UnitFactor(baseUnit2)]) ),
        ( baseUnit1, unitlessBaseUnit, Unit(baseUnit1) ),
        ( unitlessBaseUnit, baseUnit2, Unit(baseUnit2) ),
        ( unitlessBaseUnit, unitlessBaseUnit, unitlessUnit )
    ]
    return examples
end

function division_implemented()
    examples = _getExamplesFor_division()
    return TestingTools.testDyadicFunction(Base.:/, examples)
end

function _getExamplesFor_division()
    unitlessBaseUnit = Alicorn.unitlessBaseUnit
    unitlessUnit = Alicorn.unitlessUnit

    baseUnit1 = TestingTools.generateRandomBaseUnit()
    invBaseUnit1 = inv(baseUnit1)
    baseUnit2 = TestingTools.generateRandomBaseUnit()
    invBaseUnit2 = inv(baseUnit2)

    # format: dividend, divisor, correct result for dividend / divisor
    # where dividend, divisor are instances of BaseUnit
    examples = [
        ( baseUnit1, baseUnit2, Unit([ UnitFactor(baseUnit1), invBaseUnit2 ]) ),
        ( baseUnit1, baseUnit1, unitlessUnit),
        ( baseUnit1, unitlessBaseUnit, Unit(baseUnit1) ),
        ( unitlessBaseUnit, baseUnit2, Unit(invBaseUnit2) ),
        ( unitlessBaseUnit, unitlessBaseUnit, unitlessUnit )
    ]
    return examples
end

function UnitPrefix_BaseUnit_multiplication_implemented()
    prefix = TestingTools.generateRandomUnitPrefix()
    baseUnit = TestingTools.generateRandomBaseUnit()
    returnedUnitFactor = prefix * baseUnit
    correctUnitFactor = UnitFactor(prefix, baseUnit, 1)
    return (returnedUnitFactor == correctUnitFactor)
end

function convertToBasicSI_implemented()
    examples = _getExamplesFor_convertToBasicSI()
    return TestingTools.testMonadicFunction(convertToBasicSI, examples)
end

function _getExamplesFor_convertToBasicSI()
    ucat = UnitCatalogue()

    dalton = ucat.dalton
    daltonPrefactor = dalton.prefactor

    electronvolt = ucat.electronvolt
    electronvoltPrefactor = electronvolt.prefactor

    # format: baseUnit, (corresponding prefactor, corresponding SI unit)
    examples = [
        (ucat.meter, (1, Unit(ucat.meter)) ),
        (ucat.gram, (1e-3, Unit(ucat.kilo * ucat.gram)) ),
        (ucat.liter, (1e-3, Unit(ucat.meter^3)) ),
        (dalton, (daltonPrefactor, Unit(ucat.kilo * ucat.gram)) ),
        (electronvolt, (electronvoltPrefactor, Unit( ucat.kilo*ucat.gram * ucat.meter^2 * ucat.second^(-2) )) )
    ]
    return examples
end

end # module
