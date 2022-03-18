module quantity_basicsTests

using Alicorn
using Test
using ..TestingTools

const ucat = UnitCatalogue()
const intu = InternalUnits(length=2*ucat.meter)
const lengthDim = Dimension(L=1)

function run()
    @testset "quantity_basicsTests" begin
        @test copy_implementedForSimpleQuantity()
        @test deepcopy_implementedForSimpleQuantity()

        @test copy_implementedForSimpleQuantityArray()
        @test deepcopy_implementedForSimpleQuantityArray()

        @test copy_implementedForQuantity()
        @test deepcopy_implementedForQuantity()

        @test copy_implementedForQuantityArray()
        @test deepcopy_implementedForQuantityArray()
    end
end

function copy_implementedForSimpleQuantity()
    sQuantity = 5.7 * ucat.meter
    sQuantity2 = copy(sQuantity)
    return sQuantity == sQuantity2
end

function deepcopy_implementedForSimpleQuantity()
    sQuantity = 5.7 * ucat.meter
    sQuantity2 = deepcopy(sQuantity)
    return sQuantity == sQuantity2
end

function copy_implementedForSimpleQuantityArray()
    sqArray = [5.7 -4] * ucat.meter
    sqArray2 = copy(sqArray)
    return sqArray == sqArray2
end

function deepcopy_implementedForSimpleQuantityArray()
    sqArray = [5.7 -4] * ucat.meter
    sqArray2 = deepcopy(sqArray)
    return sqArray == sqArray2
end

function copy_implementedForQuantity()
    quantity = Quantity(5.7, lengthDim, intu)
    quantity2 = copy(quantity)
    return quantity == quantity2
end

function deepcopy_implementedForQuantity()
    quantity = Quantity(5.7, lengthDim, intu)
    quantity2 = deepcopy(quantity)
    return quantity == quantity2
end

function copy_implementedForQuantityArray()
    qArray = QuantityArray([5.7, -2], lengthDim, intu)
    qArray2 = copy(qArray)
    return qArray == qArray2
end

function deepcopy_implementedForQuantityArray()
    qArray = QuantityArray([5.7, -2], lengthDim, intu)
    qArray2 = deepcopy(qArray)
    return qArray == qArray2
end

end # module
