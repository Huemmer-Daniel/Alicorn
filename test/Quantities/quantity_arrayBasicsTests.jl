module quantity_arrayBasicsTests

using Alicorn
using Test
using ..TestingTools

const ucat = UnitCatalogue()
const defaultInternalUnits = InternalUnits()
const intu2 = InternalUnits(length=2*ucat.meter)
const lengthDim = Dimension(L=1)

function run()
    @testset "quantity_arrayBasicsTests" begin

        # eltype
        @test eltype_implementedForSimpleQuantityArray()
        @test eltype_implementedForQuantityArray()

    end
end

## eltype

function eltype_implementedForSimpleQuantityArray()
    sqArray = SimpleQuantityArray{Int32}([1, 3], ucat.meter)
    return eltype(sqArray) == SimpleQuantity{Int32}
end

function eltype_implementedForQuantityArray()
    sqArray = QuantityArray{Int32}([1, 3], lengthDim, intu2)
    return eltype(sqArray) == Quantity{Int32}
end

end # module
