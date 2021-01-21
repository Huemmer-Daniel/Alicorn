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

        @test convertToUnit_implemented()

        @test Number_BaseUnitExponents_multiplication_implemented()
        @test addition_implemented()
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

function convertToUnit_implemented()
    examples = _getExamplesFor_convertToUnit()
    return TestingTools.testMonadicFunction(convertToUnit, examples)
end

function _getExamplesFor_convertToUnit()
    # format: BaseUnitExponents, the corresponding unit in terms of SI basic units
    examples = [
        ( BaseUnitExponents(kg=1) , Unit( Alicorn.kilogram ) ),
        ( BaseUnitExponents(m=1, s=-2.5) , Unit( Alicorn.meter * Alicorn.second^(-2.5) ) ),
        ( BaseUnitExponents(A=2) , Unit( Alicorn.ampere^2 ) ),
        ( BaseUnitExponents(K=3) , Unit( Alicorn.kelvin^3 ) ),
        ( BaseUnitExponents(mol=4) , Unit( Alicorn.mol^4 ) ),
        ( BaseUnitExponents(cd=5) , Unit( Alicorn.candela^5 ) )
    ]
    return examples
end

function Number_BaseUnitExponents_multiplication_implemented()
    examples = _getExamplesFor_Number_BaseUnitExponents_multiplication()
    return TestingTools.testDyadicFunction(Base.:*, examples)
end

function _getExamplesFor_Number_BaseUnitExponents_multiplication()
    examples = [
        ( 3, BaseUnitExponents(kg=1), BaseUnitExponents(kg=3) ),
        ( 3, BaseUnitExponents(m=2), BaseUnitExponents(m=6) ),
        ( 3, BaseUnitExponents(s=-2), BaseUnitExponents(s=-6) ),
        ( 3, BaseUnitExponents(A=2, s=-2), BaseUnitExponents(A=6, s=-6) ),
        ( 3, BaseUnitExponents(K=5), BaseUnitExponents(K=15) ),
        ( -1, BaseUnitExponents(mol=-1), BaseUnitExponents(mol=1) ),
        ( BaseUnitExponents(cd=2), 2, BaseUnitExponents(cd=4) )
    ]
    return examples
end

function addition_implemented()
    examples = _getExamplesFor_addition()
    return TestingTools.testDyadicFunction(Base.:+, examples)
end

function _getExamplesFor_addition()
    examples = [
        ( BaseUnitExponents(kg=1), BaseUnitExponents(kg=1, m=2), BaseUnitExponents(kg=2, m=2) ),
        ( BaseUnitExponents(m=2), BaseUnitExponents(m=-2), BaseUnitExponents(m=0) ),
        ( BaseUnitExponents(s=-2), BaseUnitExponents(s=1), BaseUnitExponents(s=-1) ),
        ( BaseUnitExponents(A=-2), BaseUnitExponents(A=7), BaseUnitExponents(A=5) ),
        ( BaseUnitExponents(mol=-2), BaseUnitExponents(mol=7), BaseUnitExponents(mol=5) ),
        ( BaseUnitExponents(cd=3, mol=-2), BaseUnitExponents(mol=7, cd=-1), BaseUnitExponents(mol=5, cd=2) )
    ]
    return examples
end

end # module
