module UtilsTests

using Test
using Alicorn.Utils

function run()
    @testset "Utils" begin
        separatePrefactorAndDecadeTest()
        separatePrefactorAndDecadeErrorsOnInfiniteNumbers()
        getDecadeTest()
        getDecadeErrorsOnInfiniteNumbers()
        assertNumberIsFiniteTest()
        prettyPrintScientificNumberTest()
        isElementOfTest()
    end
end

function separatePrefactorAndDecadeTest()
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

function assertNumberIsFiniteTest()
    infiniteNumbers = [ Inf, -Inf, NaN, NaN32, Inf32, NaN16, Inf16 ]
    for number in infiniteNumbers
        @test_throws DomainError(number,"argument must be finite") Utils.assertNumberIsFinite(number)
    end
end

function prettyPrintScientificNumberTest()
    (examples,significantDigits) = _getPrettyPrintingExamples()
    @test _checkPrettyPrintingExamplesImplemented(examples,significantDigits)
end

function _getPrettyPrintingExamples()
    significantDigits = 3
    examples = [
    (1.200e-10,"1.2e-10"),
    (1.234e-9,"1.23e-9"),
    (0,"0"),
    (1,"1"),
    (2.9,"2.9"),
    (0.9,"9e-1"),
    (0.91,"9.1e-1"),
    (0.912,"9.12e-1"),
    (0.9127,"9.13e-1"),
    (101.9,"1.02e+2"),
    (Inf,"Inf"),
    (NaN,"NaN"),
    (NaN32,"NaN"),
    (-Inf,"-Inf"),
    (Inf32,"Inf"),
    ]
    return (examples,significantDigits)
end

function _checkPrettyPrintingExamplesImplemented(examples::Array{Tuple{Real,String}},significantDigits::Int64)
    correct = true
    for (number, correctPrettyStr) in examples
        returnedPrettyString = Utils.prettyPrintScientificNumber(number, sigdigits=significantDigits)
        correct &= returnedPrettyString==correctPrettyStr
    end
    return correct
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

end # end
