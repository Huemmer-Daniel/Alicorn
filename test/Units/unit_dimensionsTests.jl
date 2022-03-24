module unit_dimensionsTests

using Alicorn
using Test
using ..TestingTools

const ucat = UnitCatalogue()
const intu = InternalUnits()

function run()
    @testset "unit_dimensionsTests" begin
        @test dimensionOf_implementedForUnits()
    end
end

## Units

function dimensionOf_implementedForUnits()
    examples = _getExamplesFor_dimensionOf_forUnits()
    return TestingTools.testMonadicFunction(dimensionOf, examples)
end

struct MockUnitForDimension <: AbstractUnit
    unitFactor::UnitFactor
end

function Alicorn.Units.convertToUnit(mockUnit::MockUnitForDimension)
    return convertToUnit(mockUnit.unitFactor)
end

function _getExamplesFor_dimensionOf_forUnits()

    # format: object of type AbstractUnit, corresponding Dimension
    examples = [
        # BaseUnit
        ( Alicorn.unitlessBaseUnit, Dimension( ) ),
        ( ucat.joule, Dimension( M=1, L=2, T=-2 ) ),
        # UnitFactor
        ( Alicorn.unitlessUnitFactor, Dimension( ) ),
        ( ucat.tera * ucat.farad, Dimension( M=-1, L=-2, T=4, I=2 ) ),
        # Unit
        ( Alicorn.unitlessUnit, Dimension( ) ),
        ( (ucat.nano * ucat.siemens) / ucat.mol * ucat.candela^2 * ucat.kelvin^-3, Dimension( M=-1, L=-2, T=3, I=2, N=-1, J=2, θ=-3 ) ),
        # AbstractUnit
        ( MockUnitForDimension( (ucat.nano * ucat.siemens) ), Dimension( M=-1, L=-2, T=3, I=2 ) ),
    ]
    return examples
end

end # module
