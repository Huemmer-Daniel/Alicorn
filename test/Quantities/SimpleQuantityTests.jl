module SimpleQuantityTests

using Alicorn
using Test
using ..TestingTools

function run()
    @testset "SimpleQuantity" begin
        # initialization
        @test canInstanciateSimpleQuantityWithRealValue()
        @test canInstanciateSimpleQuantityWithRealValuedArray()
        @test canInstanciateSimpleQuantityWithBaseUnit()
        @test canInstanciateSimpleQuantityWithUnitFactor()
    end
end

function canInstanciateSimpleQuantityWithRealValue()
    value = TestingTools.generateRandomReal()
    unit = TestingTools.generateRandomUnit()
    return _testInstanciation(value, unit)
end

function _testInstanciation(value, unit::AbstractUnit)
    pass = false
    try
        SimpleQuantity(value, unit)
        pass = true
    catch
    end
    return pass
end

function canInstanciateSimpleQuantityWithRealValuedArray()
    value = TestingTools.generateRandomReal(dim=(2,3))
    unit = TestingTools.generateRandomUnit()
    return _testInstanciation(value, unit)
end

function canInstanciateSimpleQuantityWithBaseUnit()
    value = TestingTools.generateRandomReal()
    baseUnit = TestingTools.generateRandomBaseUnit()
    return _testInstanciation(value, baseUnit)
end

function canInstanciateSimpleQuantityWithUnitFactor()
    value = TestingTools.generateRandomReal()
    unitFactor = TestingTools.generateRandomUnitFactor()
    return _testInstanciation(value, unitFactor)
end

end # module
