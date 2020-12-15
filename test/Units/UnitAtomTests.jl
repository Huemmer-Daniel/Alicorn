module UnitAtomTests

using Alicorn
using Test

function run()
    @testset "UnitAtomExponents" begin
        @test canInstantiateUnitAtomExponents()
        UnitAtomExponentsErrorsOnInfiniteArguments()
    end
    @testset "UnitAtom" begin
        @test canInstantiateUnitAtom()
    end
end

function canInstantiateUnitAtomExponents()
    try
        UnitAtomExponents(kg=1, m=2, s=3, A=4, K=5, mol=6, cd=7)
        return true
    catch
        return false
    end
end

function UnitAtomExponentsErrorsOnInfiniteArguments()
    @test_throws DomainError(Inf,"argument must be finite") UnitAtomExponents(kg=Inf)
    @test_throws DomainError(Inf,"argument must be finite") UnitAtomExponents(m=Inf)
    @test_throws DomainError(Inf,"argument must be finite") UnitAtomExponents(s=Inf)
    @test_throws DomainError(-Inf,"argument must be finite") UnitAtomExponents(A=-Inf)
    @test_throws DomainError(-Inf,"argument must be finite") UnitAtomExponents(K=-Inf)
    @test_throws DomainError(-Inf,"argument must be finite") UnitAtomExponents(mol=-Inf)
    @test_throws DomainError(NaN,"argument must be finite") UnitAtomExponents(cd=NaN)
end

function canInstantiateUnitAtom()
    try
        UnitAtom(
            name="gram",
            symbol="g",
            prefactor=1e-3,
            exponents=Dict( [ ("kilogram", 1) ] )
        )
        return true
    catch
        return false
    end
end

end # module
