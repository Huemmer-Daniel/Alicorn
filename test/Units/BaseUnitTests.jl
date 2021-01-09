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
        @test BaseUnit_actsAsScalarInBroadcast()
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
    unitless = BaseUnit(
        name = "unitless",
        symbol = "<unitless>",
        prefactor = 1,
        exponents = BaseUnitExponents()
    )
    return (Alicorn.unitlessBaseUnit == unitless)
end

function BaseUnit_actsAsScalarInBroadcast()
    (baseUnit1, baseUnit2) = _generateTwoDifferentBaseUnitsWithoutUsingBroadcasting()
    baseUnitArray = [ baseUnit1, baseUnit2 ]
    pass = false
    try
        elementwiseComparison = (baseUnitArray .== baseUnit1)
        pass = elementwiseComparison == [true, false]
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

end # module
