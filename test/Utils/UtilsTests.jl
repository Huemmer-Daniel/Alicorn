module UtilsTests

using Test
using ..TestingTools
using Alicorn.Utils

function run()
    @testset "Utils" begin
        @test separatePrefactorAndDecade_implemented()
        test_separatePrefactorAndDecade_errorsOnInfiniteNumbers()
        @test getDecade_implemented()
        test_getDecade_errorsOnInfiniteNumbers()
        test_assertIsNonzero()
        test_assertIsFinite()
        test_assertElementsAreFinite()
        @test arefinite_implemented()
        @test occurencesIn_implemented()
        @test isElementOf_implemented()
        test_assertIsValidSymbol()
        @test tryCastingToInt_implemented()
    end
end

function separatePrefactorAndDecade_implemented()
    examples = _getExamplesFor_separatePrefactorAndDecade()
    return _testExamplesFor_separatePrefactorAndDecade(examples)
end

function _getExamplesFor_separatePrefactorAndDecade()
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

function _testExamplesFor_separatePrefactorAndDecade(examples::Array)
    correct = true
    for (number, (correctPrefactor, correctDecade)) in examples
        (returnedPrefactor, returnedDecade) = Utils.separatePrefactorAndDecade(number)
        correct &= (returnedPrefactor≈correctPrefactor) && (returnedDecade==correctDecade)
    end
    return correct
end

function test_separatePrefactorAndDecade_errorsOnInfiniteNumbers()
    @test_throws DomainError(Inf,"argument must be finite") Utils.separatePrefactorAndDecade(Inf)
    @test_throws DomainError(-Inf,"argument must be finite") Utils.separatePrefactorAndDecade(-Inf)
    @test_throws DomainError(Inf16,"argument must be finite") Utils.separatePrefactorAndDecade(Inf16)
    @test_throws DomainError(NaN,"argument must be finite") Utils.separatePrefactorAndDecade(NaN)
    @test_throws DomainError(NaN32,"argument must be finite") Utils.separatePrefactorAndDecade(NaN32)
end

function getDecade_implemented()
    examples = _getExamplesFor_getDecade()
    return _testExamplesFor_getDecade(examples)
end

function _getExamplesFor_getDecade()
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

function _testExamplesFor_getDecade(examples::Array{Tuple{Float64,Int64}})
    correct = true
    for (number, correctDecade) in examples
        returnedDecade = Utils.getDecade(number)
        correct = (returnedDecade == correctDecade)
    end
    return correct
end

function test_getDecade_errorsOnInfiniteNumbers()
    @test_throws DomainError(Inf,"argument must be finite") Utils.getDecade(Inf)
    @test_throws DomainError(-Inf,"argument must be finite") Utils.getDecade(-Inf)
    @test_throws DomainError(Inf16,"argument must be finite") Utils.getDecade(Inf16)
    @test_throws DomainError(NaN,"argument must be finite") Utils.getDecade(NaN)
    @test_throws DomainError(NaN32,"argument must be finite") Utils.getDecade(NaN32)
end

function test_assertIsNonzero()
    number = 0
    @test_throws DomainError(number,"argument must be nonzero") Utils.assertIsNonzero(number)
end

function test_assertIsFinite()
    infiniteNumbers = TestingTools.getInfiniteNumbers()
    for number in infiniteNumbers
        @test_throws DomainError(number,"argument must be finite") Utils.assertIsFinite(number)
    end
    finiteNumbers = [1, -1e-90, pi]
    for number in finiteNumbers
        @test Utils.assertIsFinite(number)
    end
end

function test_assertElementsAreFinite()
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

function arefinite_implemented()
    pass = true

    infiniteArrays = _getInfiniteArrayExamples()
    for array in infiniteArrays
        pass &= !Utils.arefinite(array)
    end

    finiteArrays = _getFiniteArrayExamples()
    for array in finiteArrays
        pass &= Utils.arefinite(array)
    end

    return pass
end

function occurencesIn_implemented()
    examples = _getExamplesFor_occurencesIn()
    return TestingTools.testDyadicFunction(Utils.occurencesIn, examples)
end

function _getExamplesFor_occurencesIn()
    # example has structure (element, array, occurences of element in array)
    examples = [
    (1, [1, 2, 3, 1], 2),
    (1, [7, 2, 3, 7], 0),
    ("a", ["b" 2; 3 "a"], 1)
    ]
    return examples
end


function isElementOf_implemented()
    examples = _getExamplesFor_isElementOf()
    return TestingTools.testDyadicFunction(Utils.isElementOf, examples)
end

function _getExamplesFor_isElementOf()
    examples::Array{ Tuple{T, Array{T,N} where N, Bool} where T } = [
    ("a", ["a" "b" "c" "d"], true),
    (1, [2 3; 4 5], false),
    ]
    return examples
end

function test_assertIsValidSymbol()
    invalidNames = TestingTools.getInvalidUnitElementNamesTestset()
    for name in invalidNames
        @test_throws ArgumentError("name argument must be a valid identifier") Utils.assertNameIsValidSymbol(name)
    end
end

function tryCastingToInt_implemented()
    examples = _getExamplesFor_tryCastingToInt()
    TestingTools.testMonadicFunction(Utils.tryCastingToInt, examples)
end

function _getExamplesFor_tryCastingToInt()
    examples = [
    (1.0, 1),
    (pi, pi),
    (-9.0, -9),
    ( (1.0, 2), (1, 2) ),
    ( [1.0, 2], [1, 2])
    ]
    return examples
end

end # end
