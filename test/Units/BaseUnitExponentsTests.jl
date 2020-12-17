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
        @test_throws DomainError(number,"argument must be finite") BaseUnitExponents(kg=number)
        @test_throws DomainError(number,"argument must be finite") BaseUnitExponents(m=number)
        @test_throws DomainError(number,"argument must be finite") BaseUnitExponents(s=number)
        @test_throws DomainError(number,"argument must be finite") BaseUnitExponents(A=number)
        @test_throws DomainError(number,"argument must be finite") BaseUnitExponents(K=number)
        @test_throws DomainError(number,"argument must be finite") BaseUnitExponents(mol=number)
        @test_throws DomainError(number,"argument must be finite") BaseUnitExponents(cd=number)
    end
end

function BaseUnitExponents_FieldsCorrectlyInitialized()
    (baseUnitExp, randFields) = _generateRandomBaseUnitExponents()
    @test _verifyHasCorrectFields(baseUnitExp, randFields)
end

function _generateRandomBaseUnitExponents()
    randFields = _generateRandomBaseUnitExponentsFields()
    baseUnitExp = BaseUnitExponents(
        kg=randFields["kg"], m=randFields["m"], s=randFields["s"], A=randFields["A"], K=randFields["K"], mol=randFields["mol"], cd=randFields["cd"]
    )
    return (baseUnitExp, randFields)
end

function _generateRandomBaseUnitExponentsFields()
    coreSIUnits = _getCoreSIUnits()
    randFields = zip( coreSIUnits, rand(Int, 7) )
    return Dict(randFields)
end

function _getCoreSIUnits()
    return ["kg", "m", "s", "A", "K", "mol", "cd"]
end

function _verifyHasCorrectFields(baseUnitExp::BaseUnitExponents, randFields::Dict{String, Int})
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
    @test_skip _checkExamplesForPrettyPrintingImplemented(examples)
end

function _getExamplesForPrettyPrinting()
    return NaN
end

function _checkExamplesForPrettyPrintingImplemented(examples)
    return false
end

end # module
