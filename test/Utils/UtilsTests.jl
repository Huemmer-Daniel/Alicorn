module UtilsTests

using Test
using ..TestingTools
using Alicorn.Utils

function run()
    @testset "Utils" begin
        testSeparatePrefactorAndDecade()
        separatePrefactorAndDecadeErrorsOnInfiniteNumbers()
        getDecadeTest()
        getDecadeErrorsOnInfiniteNumbers()
        assertIsFiniteTest()
        assertElementsAreFiniteTest()
        testArefinite()
        isElementOfTest()
        testAssertIsValidSymbol()
    end
end

function testSeparatePrefactorAndDecade()
    examples = _getSeparatePrefactorAndDecadeExamples()
    @test _checkSeparatePrefactorAndDecadeExamplesImplemented(examples)
end

function _getSeparatePrefactorAndDecadeExamples()
    examples = [
    (1.456e-9, (1.456,-9)),
    (1e-10, (1.0,-10)),
    (2e-9, (2.0,-9)),
    (1.0, (1.0,0)),
    (0.0, (0.0,0)),
    (7.123e8, (7.123,8)),
    (12.123e99, (1.2123,100))
    ]
    return examples
end

function _checkSeparatePrefactorAndDecadeExamplesImplemented(examples::Array{Tuple{Float64,Tuple{Float64,Int64}}})
    correct = true
    for (number, (correctPrefactor, correctDecade)) in examples
        (returnedPrefactor, returnedDecade) = Utils.separatePrefactorAndDecade(number)
        correct &= (returnedPrefactor≈correctPrefactor) && (returnedDecade==correctDecade)
    end
    return correct
end

function separatePrefactorAndDecadeErrorsOnInfiniteNumbers()
    @test_throws DomainError(Inf,"argument must be finite") Utils.separatePrefactorAndDecade(Inf)
    @test_throws DomainError(-Inf,"argument must be finite") Utils.separatePrefactorAndDecade(-Inf)
    @test_throws DomainError(Inf16,"argument must be finite") Utils.separatePrefactorAndDecade(Inf16)
    @test_throws DomainError(NaN,"argument must be finite") Utils.separatePrefactorAndDecade(NaN)
    @test_throws DomainError(NaN32,"argument must be finite") Utils.separatePrefactorAndDecade(NaN32)
end


function getDecadeTest()
    examples = _getDecadeExamples()
    @test return _checkGetDecadeExamplesImplemented(examples)
end

function _getDecadeExamples()
    examples = [
    (1.456e-9,-9),
    (1e-10,-10),
    (2e-9,-9),
    (1.0,0),
    (0.0,0),
    (7.123e8,8),
    (12.123e99,100),
    (-12.123e99,100)
    ]
    return examples
end

function _checkGetDecadeExamplesImplemented(examples::Array{Tuple{Float64,Int64}})
    correct = true
    for (number, correctDecade) in examples
        returnedDecade = Utils.getDecade(number)
        correct = (returnedDecade == correctDecade)
    end
    return correct
end

function getDecadeErrorsOnInfiniteNumbers()
    @test_throws DomainError(Inf,"argument must be finite") Utils.getDecade(Inf)
    @test_throws DomainError(-Inf,"argument must be finite") Utils.getDecade(-Inf)
    @test_throws DomainError(Inf16,"argument must be finite") Utils.getDecade(Inf16)
    @test_throws DomainError(NaN,"argument must be finite") Utils.getDecade(NaN)
    @test_throws DomainError(NaN32,"argument must be finite") Utils.getDecade(NaN32)
end

function assertIsFiniteTest()
    infiniteNumbers = TestingTools.getInfiniteNumbers()
    for number in infiniteNumbers
        @test_throws DomainError(number,"argument must be finite") Utils.assertIsFinite(number)
    end
    finiteNumbers = [1, -1e-90, pi]
    for number in finiteNumbers
        @test Utils.assertIsFinite(number)
    end
end

function assertElementsAreFiniteTest()
    infiniteArrays = _getInfiniteArrayExamples()
    for array in infiniteArrays
        @test_throws DomainError(array,"argument must have finite elements") Utils.assertElementsAreFinite(array)
    end
    finiteArrays = _getFiniteArrayExamples()
    for array in finiteArrays
        @test Utils.assertElementsAreFinite(array)
    end
end

function _getInfiniteArrayExamples()
    finiteArray = [1, 2]
    infiniteNumbers = TestingTools.getInfiniteNumbers()
    infiniteArrays::Array{Array{Real,1},1} = []
    for infNumber in infiniteNumbers
        infArray = vcat(finiteArray, infNumber)
        push!(infiniteArrays, infArray)
    end
    return infiniteArrays
end

function _getFiniteArrayExamples()
    return [
    [7, 8],
    [7 8],
    [1.1 pi; 7 -1.123e-9]
    ]
end

function testArefinite()
    infiniteArrays = _getInfiniteArrayExamples()
    for array in infiniteArrays
        @test !Utils.arefinite(array)
    end
    finiteArrays = _getFiniteArrayExamples()
    for array in finiteArrays
        @test Utils.arefinite(array)
    end
end

function isElementOfTest()
    examples = _getIsElementOfExamples()
    @test _checkIsElementOfExamplesImplemented(examples)
end

function _getIsElementOfExamples()
    examples::Array{ Tuple{T, Array{T,N} where N, Bool} where T } = [
    ("a", ["a" "b" "c" "d"], true),
    (1, [2 3; 4 5], false),
    ]
    return examples
end

function _checkIsElementOfExamplesImplemented(examples::Array{ Tuple{T, Array{T,N} where N, Bool} where T })
    correct = true
    for (element, collection, correctResult) in examples
        returnedResult = Utils.isElementOf(element,collection)
        correct &= (returnedResult == correctResult)
    end
    return correct
end

function testAssertIsValidSymbol()
    invalidNames = TestingTools.getInvalidUnitElementNamesTestset()
    for name in invalidNames
        @test_throws ArgumentError("name argument must be a valid identifier") Utils.assertNameIsValidSymbol(name)
    end
end

end # end
