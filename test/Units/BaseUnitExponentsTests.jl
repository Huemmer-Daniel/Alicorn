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
        test_isequal()
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

function test_isequal()
    randomFields = TestingTools.generateRandomBaseUnitExponentsFields()
    baseUnitExponents1 = _initializeUnitFactorFromDict(randomFields)
    baseUnitExponents2 = _initializeUnitFactorFromDict(randomFields)
    @test baseUnitExponents1 == baseUnitExponents2
end

function _initializeUnitFactorFromDict(fields::Dict)
    baseUnitExponents = BaseUnitExponents(
        kg = fields["kg"],
        m = fields["m"],
        s = fields["s"],
        A = fields["A"],
        K = fields["K"],
        mol = fields["mol"],
        cd = fields["cd"]
    )
    return baseUnitExponents
end

end # module
