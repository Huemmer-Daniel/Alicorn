module BaseUnitExponentsTests

using Alicorn
using ..TestingTools
using Test
using Random

function run()
    @testset "BaseUnitExponents" begin
        @test canInstantiateBaseUnitExponents()
        test_BaseUnitExponents_ErrorsOnInfiniteArguments()
        @test BaseUnitExponents_FieldsCorrectlyInitialized()
        @test BaseUnitExponents_TriesCastingExponentsToInt()

        equality_implemented()
        @test BaseUnitExponents_actsAsScalarInBroadcast()
    end
end

function canInstantiateBaseUnitExponents()
    pass = false
    try
        BaseUnitExponents(kg=1, m=2, s=3, A=4, K=5, mol=6, cd=7)
        pass = true
    catch
    end
    return pass
end

function test_BaseUnitExponents_ErrorsOnInfiniteArguments()
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
    (baseUnitExp, randFields) = TestingTools.generateRandomBaseUnitExponentsWithFields()
    return _verifyHasCorrectFields(baseUnitExp, randFields)
end

function _verifyHasCorrectFields(baseUnitExp::BaseUnitExponents, randFields::Dict)
    correct = ( baseUnitExp.kilogramExponent == randFields["kg"] )
    correct &= ( baseUnitExp.meterExponent == randFields["m"] )
    correct &= ( baseUnitExp.secondExponent == randFields["s"] )
    correct &= ( baseUnitExp.ampereExponent == randFields["A"] )
    correct &= ( baseUnitExp.kelvinExponent == randFields["K"] )
    correct &= ( baseUnitExp.molExponent == randFields["mol"] )
    correct &= ( baseUnitExp.candelaExponent == randFields["cd"] )
    return correct
end

function BaseUnitExponents_TriesCastingExponentsToInt()
    baseUnitExponent = BaseUnitExponents(kg=1.0, m=2.0, s=3.0, A=4.0, K=5.0, mol=6.0, cd=7.0)
    pass = isa(baseUnitExponent.kilogramExponent, Int)
    pass &= isa(baseUnitExponent.meterExponent, Int)
    pass &= isa(baseUnitExponent.secondExponent, Int)
    pass &= isa(baseUnitExponent.ampereExponent, Int)
    pass &= isa(baseUnitExponent.kelvinExponent, Int)
    pass &= isa(baseUnitExponent.molExponent, Int)
    pass &= isa(baseUnitExponent.candelaExponent, Int)
    return pass
end

function equality_implemented()
    randomFields1 = TestingTools.generateRandomBaseUnitExponentsFields()
    randomFields2 = deepcopy(randomFields1)
    baseUnitExponents1 = _initializeUnitFactorFromDict(randomFields1)
    baseUnitExponents2 = _initializeUnitFactorFromDict(randomFields2)
    return baseUnitExponents1 == baseUnitExponents2
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

function BaseUnitExponents_actsAsScalarInBroadcast()
    (baseUnitExponents1, baseUnitExponents2) = _generateTwoDifferentBaseUnitExponentsWithoutUsingBroadcasting()
    baseUnitExponentsArray = [ baseUnitExponents1, baseUnitExponents2 ]
    pass = false
    try
        elementwiseComparison = (baseUnitExponentsArray .== baseUnitExponents1)
        pass = elementwiseComparison == [true, false]
    catch
    end
    return pass
end

function _generateTwoDifferentBaseUnitExponentsWithoutUsingBroadcasting()
    baseUnitExponents1 = TestingTools.generateRandomBaseUnitExponents()
    baseUnitExponents2 = baseUnitExponents1
    while baseUnitExponents2 == baseUnitExponents1
        baseUnitExponents2 = TestingTools.generateRandomBaseUnitExponents()
    end
    return (baseUnitExponents1, baseUnitExponents2)
end

Base.broadcastable(baseUnitExponents::BaseUnitExponents) = Ref(baseUnitExponents)

end # module
