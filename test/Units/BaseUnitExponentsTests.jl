module BaseUnitExponentsTests

using Alicorn
using ..TestingTools
using Test
using Random

function run()
    @testset "BaseUnitExponents" begin
        canInstantiateBaseUnitExponents()
        BaseUnitExponents_ErrorsOnInfiniteArguments()
        BaseUnitExponents_FieldsCorrectlyInitialized()
        testPrettyPrinting()
    end
end

function canInstantiateBaseUnitExponents()
    pass = false
    try
        BaseUnitExponents(kg=1, m=2, s=3, A=4, K=5, mol=6, cd=7)
        pass = true
    catch
    end
    @test pass
end

function BaseUnitExponents_ErrorsOnInfiniteArguments()
    infiniteNumbers = TestingTools.getInfiniteNumbers()
    for number in infiniteNumbers
        @test_throws DomainError(number, "argument must be finite") BaseUnitExponents(kg = number)
        @test_throws DomainError(number, "argument must be finite") BaseUnitExponents(m = number)
        @test_throws DomainError(number, "argument must be finite") BaseUnitExponents(s = number)
        @test_throws DomainError(number, "argument must be finite") BaseUnitExponents(A = number)
        @test_throws DomainError(number, "argument must be finite") BaseUnitExponents(K = number)
        @test_throws DomainError(number, "argument must be finite") BaseUnitExponents(mol = number)
        @test_throws DomainError(number, "argument must be finite") BaseUnitExponents(cd = number)
    end
end

function BaseUnitExponents_FieldsCorrectlyInitialized()
    (baseUnitExp, randFields) = TestingTools.generateRandomBaseUnitExponents()
    @test _verifyHasCorrectFields(baseUnitExp, randFields)
end


function _verifyHasCorrectFields(baseUnitExp::BaseUnitExponents, randFields::Dict)
    correct = ( baseUnitExp.kilogramExponent == randFields["kg"] )
    correct &= ( baseUnitExp.meterExponent == randFields["m"] )
    correct &= ( baseUnitExp.secondExponent == randFields["s"] )
    correct &= ( baseUnitExp.ampereExponent == randFields["A"] )
    correct &= ( baseUnitExp.molExponent == randFields["mol"] )
    correct &= ( baseUnitExp.candelaExponent == randFields["cd"] )
    return correct
end

function testPrettyPrinting()
    examples = _getExamplesForPrettyPrinting()
    @test TestingTools.verifyPrettyPrintingImplemented(examples)
end

function _getExamplesForPrettyPrinting()
    examples = [
    ( BaseUnitExponents(), "BaseUnitExponents 1"),
    ( BaseUnitExponents(kg=1), "BaseUnitExponents kg"),
    ( BaseUnitExponents(m=2), "BaseUnitExponents m^2"),
    ( BaseUnitExponents(m=2, s=1.554), "BaseUnitExponents m^2 s^1.6"),
    ( BaseUnitExponents(s=1.554, A=pi), "BaseUnitExponents s^1.6 A^3.1"),
    ( BaseUnitExponents(s=1.554, A=pi, K=-1), "BaseUnitExponents s^1.6 A^3.1 K^-1"),
    ( BaseUnitExponents(s=1.554, mol=pi, K=-1), "BaseUnitExponents s^1.6 K^-1 mol^3.1"),
    ( BaseUnitExponents(cd=-70), "BaseUnitExponents cd^-7e+1"),
    ]
    return examples
end

end # module
