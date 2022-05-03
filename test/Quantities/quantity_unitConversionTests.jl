module quantity_unitConversionTests

using Alicorn
using Test
using ..TestingTools

const ucat = UnitCatalogue()
const defaultInternalUnits = InternalUnits()
const intu2 = InternalUnits(length=2*ucat.meter)
const lengthDim = Dimension(L=1)
const dimless = Dimension()

function run()
    @testset "quantity_unitConversion" begin
        # inUnitsOf
        @test inUnitsOf_implemented_forSimpleQuantity()
        test_inUnitsOf_ErrorsForMismatchedUnits_forSimpleQuantity()

        @test inUnitsOf_implemented_forQuantity()
        test_inUnitsOf_ErrorsForMismatchedUnits_forQuantity()

        @test inUnitsOf_implemented_forSimpleQuantityArray()
        test_inUnitsOf_ErrorsForMismatchedUnits_forSimpleQuantityArray()

        @test inUnitsOf_implemented_forQuantityArray()
        test_inUnitsOf_ErrorsForMismatchedUnits_forQuantityArray()

        # valueInUnitsOf
        @test valueInUnitsOf_implemented_forSimpleQuantity()
        test_valueInUnitsOf_ErrorsForMismatchedUnits_forSimpleQuantity()
        @test valueInUnitsOf_implemented_forSimpleQuantity_forSimpleQuantityAsTargetUnit()

        @test valueInUnitsOf_implemented_forQuantity()
        test_valueInUnitsOf_ErrorsForMismatchedUnits_forQuantity()
        @test valueInUnitsOf_implemented_forQuantity_forSimpleQuantityAsTargetUnit()

        @test valueInUnitsOf_implemented_forSimpleQuantityArray()
        test_valueInUnitsOf_ErrorsForMismatchedUnits_forSimpleQuantityArray()
        @test valueInUnitsOf_implemented_forSimpleQuantityArray_forSimpleQuantityAsTargetUnit()

        @test valueInUnitsOf_implemented_forQuantityArray()
        test_valueInUnitsOf_ErrorsForMismatchedUnits_forQuantityArray()
        @test valueInUnitsOf_implemented_forQuantityArray_forSimpleQuantityAsTargetUnit()

        # inInternalUnitsOf
        @test inInternalUnitsOf_implemented_forQuantity()
        @test inInternalUnitsOf_implemented_forQuantityArray()

        # inBasicSIUnits
        @test inBasicSIUnits_implemented_forSimpleQuantity()
        @test inBasicSIUnits_implemented_forQuantity()
        @test inBasicSIUnits_implemented_forSimpleQuantityArray()
        @test inBasicSIUnits_implemented_forQuantityArray()

        # valueOfDimensionless
        @test valueOfDimensionless_implemented_forSimpleQuantity()
        test_valueOfDimensionless_ErrorsIfNotUnitless_forSimpleQuantity()

        @test valueOfDimensionless_implemented_forQuantity()
        test_valueOfDimensionless_ErrorsIfNotUnitless_forQuantity()

        @test valueOfDimensionless_implemented_forSimpleQuantityArray()
        test_valueOfDimensionless_ErrorsIfNotUnitless_forSimpleQuantityArray()

        @test valueOfDimensionless_implemented_forQuantityArray()
        test_valueOfDimensionless_ErrorsIfNotUnitless_forQuantityArray()
    end
end

## inUnitsOf

function _check_inUnitsOf_examples(examples::Array)
    correct = true
    for (quantity, unit, correctFields) in examples
        returnedQuantity = inUnitsOf(quantity, unit)
        correct &= _check_inUnitsOf_example(returnedQuantity, correctFields)
    end
    return correct
end

function _check_inUnitsOf_example(simpleQuantity::Union{SimpleQuantity, SimpleQuantityArray}, correctFields::Dict{String,Any})
    correctValue = (simpleQuantity.value == correctFields["value"])
    correctUnit = (simpleQuantity.unit == correctFields["unit"])
    correctType = isa(simpleQuantity.value, correctFields["value type"])
    return correctValue && correctUnit && correctType
end

function inUnitsOf_implemented_forSimpleQuantity()
    examples = _getExamplesFor_inUnitsOf_forSimpleQuantity()
    return _check_inUnitsOf_examples(examples)
end

function _getExamplesFor_inUnitsOf_forSimpleQuantity()
    sq1 = SimpleQuantity{Float32}(1, Alicorn.unitlessUnit )
    unit1 = Alicorn.unitlessUnit
    correctFields1 = Dict([
        ("value", Float32(1)),
        ("unit", Unit(unit1)),
        ("value type", Float32)
    ])

    sq2 = SimpleQuantity{Int32}(7, ucat.meter)
    unit2 = ucat.milli*ucat.meter
    correctFields2 = Dict([
        ("value", Int32(7000)),
        ("unit", Unit(unit2)),
        ("value type", Int32)
    ])

    sq3 = SimpleQuantity{Int32}(2, (ucat.milli * ucat.second)^2)
    unit3 = ucat.second^2
    correctFields3 = Dict([
        ("value", Float64(2e-6)),
        ("unit", Unit(unit3)),
        ("value type", Float64)
    ])

    electronvoltInBasicSI = ucat.electronvolt.prefactor
    sq4 = SimpleQuantity{Float64}(1, ucat.joule)
    unit4 = ucat.electronvolt
    correctFields4 = Dict([
        ("value", Float64(1/electronvoltInBasicSI)),
        ("unit", Unit(unit4)),
        ("value type", Float64)
    ])

    sq5 = SimpleQuantity{Int64}(5, Alicorn.unitlessUnit)
    unit5 = Alicorn.unitlessUnit
    correctFields5 = Dict([
        ("value", Int64(5)),
        ("unit", Unit(unit5)),
        ("value type", Int64)
    ])

    examples = [
        (sq1, unit1, correctFields1),
        (sq2, unit2, correctFields2),
        (sq3, unit3, correctFields3),
        (sq4, unit4, correctFields4),
        (sq5, unit5, correctFields5)
    ]
    return examples
end

function test_inUnitsOf_ErrorsForMismatchedUnits_forSimpleQuantity()
    simpleQuantity = 7 * Alicorn.meter
    mismatchedUnit = Alicorn.second
    expectedError = Alicorn.Exceptions.DimensionMismatchError("dimensions of the quantity and the desired unit do not agree")
    @test_throws expectedError inUnitsOf(simpleQuantity, mismatchedUnit)
end

function inUnitsOf_implemented_forQuantity()
    examples = _getExamplesFor_inUnitsOf_forQuantity()
    return _check_inUnitsOf_examples(examples)
end

function _getExamplesFor_inUnitsOf_forQuantity()
    q1 = Quantity{Int32}(5, dimless, defaultInternalUnits)
    unit1 = Alicorn.unitlessUnit
    correctFields1 = Dict([
        ("value", Int32(5)),
        ("unit", Unit(unit1)),
        ("value type", Int32)
    ])

    q2 = Quantity{UInt32}(700, Dimension(L=1), InternalUnits(length=1*(ucat.centi*ucat.meter)))
    unit2 = ucat.milli*ucat.meter
    correctFields2 = Dict([
        ("value", UInt32(7000)),
        ("unit", Unit(unit2)),
        ("value type", UInt32)
    ])

    q3 = Quantity{Float32}(2, Dimension(T=2), InternalUnits(time=1*(ucat.milli * ucat.second)))
    unit3 = ucat.second^2
    correctFields3 = Dict([
        ("value", Float32(2e-6)),
        ("unit", Unit(unit3)),
        ("value type", Float32)
    ])

    examples = [
        (q1, unit1, correctFields1),
        (q2, unit2, correctFields2),
        (q3, unit3, correctFields3)
    ]
    return examples
end

function test_inUnitsOf_ErrorsForMismatchedUnits_forQuantity()
    quantity = Quantity(7, Dimension(L=1), defaultInternalUnits)
    mismatchedUnit = Alicorn.second
    expectedError = Alicorn.Exceptions.DimensionMismatchError("dimensions of the quantity and the desired unit do not agree")
    @test_throws expectedError inUnitsOf(quantity, mismatchedUnit)
end

function inUnitsOf_implemented_forSimpleQuantityArray()
    examples = _getExamplesFor_inUnitsOf_forSimpleQuantityArray()
    return _check_inUnitsOf_examples(examples)
end

function _getExamplesFor_inUnitsOf_forSimpleQuantityArray()
    sqArray1 = SimpleQuantityArray{Float32}(ones(2,2), Alicorn.unitlessUnit )
    unit1 = Alicorn.unitlessUnit
    correctFields1 = Dict([
        ("value", Array{Float32}( ones(2,2) )),
        ("unit", Unit(unit1)),
        ("value type", Array{Float32})
    ])

    sqArray2 = SimpleQuantityArray{Int32}([7; 3], ucat.meter )
    unit2 = ucat.milli * ucat.meter
    correctFields2 = Dict([
        ("value", Array{Int32}( [7000; 3000] )),
        ("unit", Unit(unit2)),
        ("value type", Array{Int32})
    ])

    sqArray3 = SimpleQuantityArray{Int32}([2], (ucat.milli * ucat.second)^2 )
    unit3 = ucat.second^2
    correctFields3 = Dict([
        ("value", Array{Float64}( [2e-6] )),
        ("unit", Unit(unit3)),
        ("value type", Array{Float64})
    ])

    electronvoltInBasicSI = ucat.electronvolt.prefactor
    sqArray4 = SimpleQuantityArray{Float64}(ones(2,2), ucat.joule)
    unit4 = ucat.electronvolt
    correctFields4 = Dict([
        ("value", Array{Float64}( (1/electronvoltInBasicSI) * ones(2,2) )),
        ("unit", Unit(unit4)),
        ("value type", Array{Float64})
    ])

    sqArray5 = SimpleQuantityArray{Int64}([5 2], Alicorn.unitlessUnit)
    unit5 = Alicorn.unitlessUnit
    correctFields5 = Dict([
        ("value", Array{Int64}( [5 2] )),
        ("unit", Unit(unit5)),
        ("value type", Array{Int64})
    ])

    examples = [
        (sqArray1, unit1, correctFields1),
        (sqArray2, unit2, correctFields2),
        (sqArray3, unit3, correctFields3),
        (sqArray4, unit4, correctFields4),
        (sqArray5, unit5, correctFields5)
    ]
    return examples
end

function test_inUnitsOf_ErrorsForMismatchedUnits_forSimpleQuantityArray()
    sqArray = [7, 2] * Alicorn.meter
    mismatchedUnit = Alicorn.second
    expectedError = Alicorn.Exceptions.DimensionMismatchError("dimensions of the quantity and the desired unit do not agree")
    @test_throws expectedError inUnitsOf(sqArray, mismatchedUnit)
end

function inUnitsOf_implemented_forQuantityArray()
    examples = _getExamplesFor_inUnitsOf_forQuantityArray()
    return _check_inUnitsOf_examples(examples)
end

function _getExamplesFor_inUnitsOf_forQuantityArray()
    qArray1 = QuantityArray{Int32}(ones(2,2), dimless, defaultInternalUnits)
    unit1 = Alicorn.unitlessUnit
    correctFields1 = Dict([
        ("value", Array{Int32}(ones(2,2))),
        ("unit", Unit(unit1)),
        ("value type", Array{Int32})
    ])

    qArray2 = QuantityArray{UInt32}([700], Dimension(L=1), InternalUnits(length=1*(ucat.centi*ucat.meter)))
    unit2 = ucat.milli*ucat.meter
    correctFields2 = Dict([
        ("value", Array{UInt32}([7000])),
        ("unit", Unit(unit2)),
        ("value type", Array{UInt32})
    ])

    qArray3 = QuantityArray{Float32}([2], Dimension(T=2), InternalUnits(time=1*(ucat.milli * ucat.second)))
    unit3 = ucat.second^2
    correctFields3 = Dict([
        ("value", Array{Float32}([2e-6])),
        ("unit", Unit(unit3)),
        ("value type", Array{Float32})
    ])

    examples = [
        (qArray1, unit1, correctFields1),
        (qArray2, unit2, correctFields2),
        (qArray3, unit3, correctFields3)
    ]
    return examples
end

function test_inUnitsOf_ErrorsForMismatchedUnits_forQuantityArray()
    qArray = QuantityArray([7, 2], Dimension(L=1), defaultInternalUnits)
    mismatchedUnit = Alicorn.second
    expectedError = Alicorn.Exceptions.DimensionMismatchError("dimensions of the quantity and the desired unit do not agree")
    @test_throws expectedError inUnitsOf(qArray, mismatchedUnit)
end


## valueInUnitsOf

function _check_valueInUnitsOf_examples(examples::Array)
    correct = true
    for (quantity, unit, correctFields) in examples
        returnedValue = valueInUnitsOf(quantity, unit)
        correct &= _check_valueInUnitsOf_example(returnedValue, correctFields)
    end
    return correct
end

function _check_valueInUnitsOf_example(value::Union{Number, Array}, correctFields::Dict{String,Any})
    correctValue = (value == correctFields["value"])
    correctType = isa(value, correctFields["value type"])
    return correctValue && correctType
end

function valueInUnitsOf_implemented_forSimpleQuantity()
    examples = _getExamplesFor_valueInUnitsOf_forSimpleQuantity()
    return _check_valueInUnitsOf_examples(examples)
end

function _getExamplesFor_valueInUnitsOf_forSimpleQuantity()
    sq1 = SimpleQuantity{Float32}(1, Alicorn.unitlessUnit )
    unit1 = Alicorn.unitlessUnit
    correctFields1 = Dict([
        ("value", Float32(1)),
        ("value type", Float32)
    ])

    sq2 = SimpleQuantity{Int32}(7, ucat.meter)
    unit2 = ucat.milli*ucat.meter
    correctFields2 = Dict([
        ("value", Int32(7000)),
        ("value type", Int32)
    ])

    sq3 = SimpleQuantity{Int32}(2, (ucat.milli * ucat.second)^2)
    unit3 = ucat.second^2
    correctFields3 = Dict([
        ("value", Float64(2e-6)),
        ("value type", Float64)
    ])

    electronvoltInBasicSI = ucat.electronvolt.prefactor
    sq4 = SimpleQuantity{Float64}(1, ucat.joule)
    unit4 = ucat.electronvolt
    correctFields4 = Dict([
        ("value", Float64(1/electronvoltInBasicSI)),
        ("value type", Float64)
    ])

    sq5 = SimpleQuantity{Int64}(5, Alicorn.unitlessUnit)
    unit5 = Alicorn.unitlessUnit
    correctFields5 = Dict([
        ("value", Int64(5)),
        ("value type", Int64)
    ])

    examples = [
        (sq1, unit1, correctFields1),
        (sq2, unit2, correctFields2),
        (sq3, unit3, correctFields3),
        (sq4, unit4, correctFields4),
        (sq5, unit5, correctFields5)
        ]
end

function test_valueInUnitsOf_ErrorsForMismatchedUnits_forSimpleQuantity()
    simpleQuantity = SimpleQuantity(7, Alicorn.meter)
    mismatchedUnit = Alicorn.second
    expectedError = Alicorn.Exceptions.DimensionMismatchError("dimensions of the quantity and the desired unit do not agree")
    @test_throws expectedError valueInUnitsOf(simpleQuantity, mismatchedUnit)
end

function valueInUnitsOf_implemented_forSimpleQuantity_forSimpleQuantityAsTargetUnit()
    examples = _getExamplesFor_valueInUnitsOf_forSimpleQuantity_forSimpleQuantityAsTargetUnit()
    return _check_valueInUnitsOf_examples(examples)
end

function _getExamplesFor_valueInUnitsOf_forSimpleQuantity_forSimpleQuantityAsTargetUnit()
    sq1 = SimpleQuantity{Float32}(1, Alicorn.unitlessUnit )
    sqAsUnit1 = 3 * Alicorn.unitlessUnit
    correctFields1 = Dict([
        ("value", Float32(1/3)),
        ("value type", Float32)
    ])

    sq2 = SimpleQuantity{Int32}(7, ucat.meter)
    sqAsUnit2 = 2 * (ucat.milli*ucat.meter)
    correctFields2 = Dict([
        ("value", Int32(3500)),
        ("value type", Int32)
    ])

    sq3 = SimpleQuantity{Int32}(2, (ucat.milli * ucat.second)^2)
    sqAsUnit3 = 2 * ucat.second^2
    correctFields3 = Dict([
        ("value", Float64(1e-6)),
        ("value type", Float64)
    ])

    sq4 = SimpleQuantity{Float64}(6, Alicorn.unitlessUnit)
    sqAsUnit4 = -3 * Alicorn.unitlessUnit
    correctFields4 = Dict([
        ("value", Float64(-2)),
        ("value type", Float64)
    ])

    examples = [
        (sq1, sqAsUnit1, correctFields1),
        (sq2, sqAsUnit2, correctFields2),
        (sq3, sqAsUnit3, correctFields3),
        (sq4, sqAsUnit4, correctFields4)
        ]

    return examples
end

function valueInUnitsOf_implemented_forQuantity()
    examples = _getExamplesFor_valueInUnitsOf_forQuantity()
    return _check_valueInUnitsOf_examples(examples)
end

function _getExamplesFor_valueInUnitsOf_forQuantity()
    q1 = Quantity{Int32}(5, dimless, defaultInternalUnits)
    unit1 = Alicorn.unitlessUnit
    correctFields1 = Dict([
        ("value", Int32(5)),
        ("value type", Int32)
    ])

    q2 = Quantity{Int32}(700, Dimension(L=1), InternalUnits(length=1*(ucat.centi*ucat.meter)))
    unit2 = ucat.milli*ucat.meter
    correctFields2 = Dict([
        ("value", Int32(7000)),
        ("value type", Int32)
    ])

    q3 = Quantity{Int64}(2, Dimension(T=2), InternalUnits(time=1*(ucat.milli * ucat.second)))
    unit3 = ucat.second^2
    correctFields3 = Dict([
        ("value", Float64(2e-6)),
        ("value type", Float64)
    ])

    examples = [
        (q1, unit1, correctFields1),
        (q2, unit2, correctFields2),
        (q3, unit3, correctFields3)
        ]

    return examples
end

function test_valueInUnitsOf_ErrorsForMismatchedUnits_forQuantity()
    quantity = Quantity(7, Dimension(L=1), InternalUnits(length=1*ucat.meter))
    mismatchedUnit = Alicorn.second
    expectedError = Alicorn.Exceptions.DimensionMismatchError("dimensions of the quantity and the desired unit do not agree")
    @test_throws expectedError valueInUnitsOf(quantity, mismatchedUnit)
end

function valueInUnitsOf_implemented_forQuantity_forSimpleQuantityAsTargetUnit()
    examples = _getExamplesFor_valueInUnitsOf_forQuantity_forSimpleQuantityAsTargetUnit()
    return _check_valueInUnitsOf_examples(examples)
end

function _getExamplesFor_valueInUnitsOf_forQuantity_forSimpleQuantityAsTargetUnit()
    q1 = Quantity{Int32}(5, dimless, defaultInternalUnits)
    sqAsUnit1 = 3 * Alicorn.unitlessUnit
    correctFields1 = Dict([
        ("value", Float64(5/3)),
        ("value type", Float64)
    ])

    q2 = Quantity{Int32}(700, Dimension(L=1), InternalUnits(length=1*(ucat.centi*ucat.meter)))
    sqAsUnit2 = 2 * ucat.milli*ucat.meter
    correctFields2 = Dict([
        ("value", Int32(3500)),
        ("value type", Int32)
    ])

    q3 = Quantity{Float32}(2, Dimension(T=2), InternalUnits(time=1*(ucat.milli * ucat.second)))
    sqAsUnit3 = 10 * (ucat.second^2)
    correctFields3 = Dict([
        ("value", Float32(2e-7)),
        ("value type", Float32)
    ])

    examples = [
        (q1, sqAsUnit1, correctFields1),
        (q2, sqAsUnit2, correctFields2),
        (q3, sqAsUnit3, correctFields3)
        ]

    return examples
end

function valueInUnitsOf_implemented_forSimpleQuantityArray()
    examples = _getExamplesFor_valueInUnitsOf_forSimpleQuantityArray()
    return _check_valueInUnitsOf_examples(examples)
end

function _getExamplesFor_valueInUnitsOf_forSimpleQuantityArray()
    sqArray1 = SimpleQuantityArray{Float32}(ones(2,2), Alicorn.unitlessUnit )
    unit1 = Alicorn.unitlessUnit
    correctFields1 = Dict([
        ("value", Array{Float32}(ones(2,2))),
        ("value type", Array{Float32})
    ])

    sqArray2 = SimpleQuantityArray{Int32}([7; 3], ucat.meter)
    unit2 = ucat.milli*ucat.meter
    correctFields2 = Dict([
        ("value", Array{Int32}([7000; 3000])),
        ("value type", Array{Int32})
    ])

    sqArray3 = SimpleQuantityArray{Int32}([2], (ucat.milli * ucat.second)^2)
    unit3 = ucat.second^2
    correctFields3 = Dict([
        ("value", Array{Float64}([2e-6])),
        ("value type", Array{Float64})
    ])

    sqArray4 = SimpleQuantityArray{Float64}( [5 2], Alicorn.unitlessUnit)
    unit4 = Alicorn.unitlessUnit
    correctFields4 = Dict([
        ("value", Array{Float64}([5 2])),
        ("value type", Array{Float64})
    ])

    examples = [
        (sqArray1, unit1, correctFields1),
        (sqArray2, unit2, correctFields2),
        (sqArray3, unit3, correctFields3),
        (sqArray4, unit4, correctFields4)
        ]
end

function test_valueInUnitsOf_ErrorsForMismatchedUnits_forSimpleQuantityArray()
    sqArray = [7, 2] * Alicorn.meter
    mismatchedUnit = Alicorn.second
    expectedError = Alicorn.Exceptions.DimensionMismatchError("dimensions of the quantity and the desired unit do not agree")
    @test_throws expectedError valueInUnitsOf(sqArray, mismatchedUnit)
end

function valueInUnitsOf_implemented_forSimpleQuantityArray_forSimpleQuantityAsTargetUnit()
    examples = _getExamplesFor_valueInUnitsOf_forSimpleQuantityArray_forSimpleQuantityAsTargetUnit()
    return _check_valueInUnitsOf_examples(examples)
end

function _getExamplesFor_valueInUnitsOf_forSimpleQuantityArray_forSimpleQuantityAsTargetUnit()
    sqArray1 = SimpleQuantityArray{Float32}([1], Alicorn.unitlessUnit )
    sqAsUnit1 = 3 * Alicorn.unitlessUnit
    correctFields1 = Dict([
        ("value", Array{Float32}([1/3])),
        ("value type", Array{Float32})
    ])

    sqArray2 = SimpleQuantityArray{Int32}([7], ucat.meter)
    sqAsUnit2 = 2 * (ucat.milli*ucat.meter)
    correctFields2 = Dict([
        ("value", Array{Int32}([3500])),
        ("value type", Array{Int32})
    ])

    sqArray3 = SimpleQuantityArray{Int32}([2], (ucat.milli * ucat.second)^2)
    sqAsUnit3 = 2 * ucat.second^2
    correctFields3 = Dict([
        ("value", Array{Float64}([1e-6])),
        ("value type", Array{Float64})
    ])

    sqArray4 = SimpleQuantityArray{Float64}([6; 12], Alicorn.unitlessUnit)
    sqAsUnit4 = 3 * Alicorn.unitlessUnit
    correctFields4 = Dict([
        ("value", Array{Float64}([2; 4])),
        ("value type", Array{Float64})
    ])

    examples = [
        (sqArray1, sqAsUnit1, correctFields1),
        (sqArray2, sqAsUnit2, correctFields2),
        (sqArray3, sqAsUnit3, correctFields3),
        (sqArray4, sqAsUnit4, correctFields4)
        ]

    return examples
end

function valueInUnitsOf_implemented_forQuantityArray()
    examples = _getExamplesFor_valueInUnitsOf_forQuantityArray()
    return _check_valueInUnitsOf_examples(examples)
end

function _getExamplesFor_valueInUnitsOf_forQuantityArray()
    q1 = QuantityArray{Int32}(ones(2,2), dimless, defaultInternalUnits)
    unit1 = Alicorn.unitlessUnit
    correctFields1 = Dict([
        ("value", Array{Int32}(ones(2,2))),
        ("value type", Array{Int32})
    ])

    q2 = QuantityArray{Int32}([700], Dimension(L=1), InternalUnits(length=1*(ucat.centi*ucat.meter)))
    unit2 = ucat.milli*ucat.meter
    correctFields2 = Dict([
        ("value", Array{Int32}([7000])),
        ("value type", Array{Int32})
    ])

    q3 = QuantityArray{Int64}([2], Dimension(T=2), InternalUnits(time=1*(ucat.milli * ucat.second)))
    unit3 = ucat.second^2
    correctFields3 = Dict([
        ("value", Array{Float64}([2e-6])),
        ("value type", Array{Float64})
    ])

    examples = [
        (q1, unit1, correctFields1),
        (q2, unit2, correctFields2),
        (q3, unit3, correctFields3)
        ]

    return examples
end

function test_valueInUnitsOf_ErrorsForMismatchedUnits_forQuantityArray()
    qArray = QuantityArray([7, 2] * Alicorn.meter, defaultInternalUnits)
    mismatchedUnit = Alicorn.second
    expectedError = Alicorn.Exceptions.DimensionMismatchError("dimensions of the quantity and the desired unit do not agree")
    @test_throws expectedError valueInUnitsOf(qArray, mismatchedUnit)
end

function valueInUnitsOf_implemented_forQuantityArray_forSimpleQuantityAsTargetUnit()
    examples = _getExamplesFor_valueInUnitsOf_forQuantityArray_forSimpleQuantityAsTargetUnit()
    return _check_valueInUnitsOf_examples(examples)
end

function _getExamplesFor_valueInUnitsOf_forQuantityArray_forSimpleQuantityAsTargetUnit()
    q1 = QuantityArray{Int32}(ones(2,2), dimless, defaultInternalUnits)
    sqAsUnit1 = 2 * Alicorn.unitlessUnit
    correctFields1 = Dict([
        ("value", Array{Float64}(ones(2,2) / 2 )),
        ("value type", Array{Float64})
    ])

    q2 = QuantityArray{Int32}([700], Dimension(L=1), InternalUnits(length=1*(ucat.centi*ucat.meter)))
    sqAsUnit2 = 2 * ucat.milli*ucat.meter
    correctFields2 = Dict([
        ("value", Array{Int32}([3500])),
        ("value type", Array{Int32})
    ])

    q3 = QuantityArray{Float32}([2], Dimension(T=2), InternalUnits(time=1*(ucat.milli * ucat.second)))
    sqAsUnit3 = 10 * (ucat.second^2)
    correctFields3 = Dict([
        ("value", Array{Float32}([2e-7])),
        ("value type", Array{Float32})
    ])

    examples = [
        (q1, sqAsUnit1, correctFields1),
        (q2, sqAsUnit2, correctFields2),
        (q3, sqAsUnit3, correctFields3)
        ]

    return examples
end


## inInternalUnitsOf

function _check_inInternalUnitsOf_examples(examples::Array)
    correct = true
    for (quantity, internalUnits, correctFields) in examples
        returnedQuantity = inInternalUnitsOf(quantity, internalUnits)
        correct &= _check_inInternalUnitsOf_example(returnedQuantity, correctFields)
    end
    return correct
end

function _check_inInternalUnitsOf_example(quantity::Union{Quantity, QuantityArray}, correctFields::Dict{String,Any})
    correctValue = (quantity.value == correctFields["value"])
    correctDimension = (quantity.dimension == correctFields["dimension"])
    correctInternalUnits = (quantity.internalUnits == correctFields["internal units"])
    correctType = isa(quantity.value, correctFields["value type"])
    return correctValue && correctDimension && correctInternalUnits && correctType
end

function inInternalUnitsOf_implemented_forQuantity()
    examples = _getExamplesFor_inInternalUnitsOf_implemented_forQuantity()
    return _check_inInternalUnitsOf_examples(examples)
end

function _getExamplesFor_inInternalUnitsOf_implemented_forQuantity()
    quantity1 = Quantity{Int32}(5, dimless, defaultInternalUnits )
    intUnits1 = defaultInternalUnits
    correctFields1 = Dict([
        ("value", Int32(5)),
        ("dimension", dimless),
        ("internal units", intUnits1),
        ("value type", Int32)
    ])

    quantity2 = Quantity{Int32}(1, dimless, defaultInternalUnits )
    intUnits2 = intu2
    correctFields2 = Dict([
        ("value", Int32(1)),
        ("dimension", dimless),
        ("internal units", intUnits2),
        ("value type", Int32)
    ])

    quantity3 = Quantity{Float32}(5, lengthDim, defaultInternalUnits )
    intUnits3 = intu2
    correctFields3 = Dict([
        ("value", Float32(2.5)),
        ("dimension", lengthDim),
        ("internal units", intUnits3),
        ("value type", Float32)
    ])

    quantity4 = Quantity{Int32}(5, lengthDim, intu2 )
    intUnits4 = defaultInternalUnits
    correctFields4 = Dict([
        ("value", Int32(10)),
        ("dimension", lengthDim),
        ("internal units", intUnits4),
        ("value type", Int32)
    ])

    examples = [
        (quantity1, intUnits1, correctFields1),
        (quantity2, intUnits2, correctFields2),
        (quantity3, intUnits3, correctFields3),
        (quantity4, intUnits4, correctFields4)
    ]
    return examples
end

function inInternalUnitsOf_implemented_forQuantityArray()
    examples = _getExamplesFor_inInternalUnitsOf_implemented_forQuantityArray()
    return _check_inInternalUnitsOf_examples(examples)
end

function _getExamplesFor_inInternalUnitsOf_implemented_forQuantityArray()
    quantity1 = QuantityArray{Int32}([1 2], dimless, defaultInternalUnits )
    intUnits1 = defaultInternalUnits
    correctFields1 = Dict([
        ("value", Array{Int32}([1 2])),
        ("dimension", dimless),
        ("internal units", intUnits1),
        ("value type", Array{Int32})
    ])

    quantity2 = QuantityArray{Int32}([2; 3], dimless, defaultInternalUnits )
    intUnits2 = intu2
    correctFields2 = Dict([
        ("value", Array{Int32}([2; 3])),
        ("dimension", dimless),
        ("internal units", intUnits2),
        ("value type", Array{Int32})
    ])

    quantity3 = QuantityArray{Int32}([5, 7], lengthDim, defaultInternalUnits )
    intUnits3 = intu2
    correctFields3 = Dict([
        ("value", Array{Float64}([2.5, 3.5])),
        ("dimension", lengthDim),
        ("internal units", intUnits3),
        ("value type", Array{Float64})
    ])

    quantity4 = QuantityArray{Int32}([5, 7], lengthDim, intu2 )
    intUnits4 = defaultInternalUnits
    correctFields4 = Dict([
        ("value", Array{Int32}([10, 14])),
        ("dimension", lengthDim),
        ("internal units", intUnits4),
        ("value type", Array{Int32})
    ])

    examples = [
        (quantity1, intUnits1, correctFields1),
        (quantity2, intUnits2, correctFields2),
        (quantity3, intUnits3, correctFields3),
        (quantity4, intUnits4, correctFields4)
    ]
    return examples
end


## inBasicSIUnits

function _check_inBasicSIUnits_examples(examples::Array)
    correct = true
    for (quantity, correctFields) in examples
        returnedQuantity = inBasicSIUnits(quantity)
        correct &= _check_inBasicSIUnits_example(returnedQuantity, correctFields)
    end
    return correct
end

function _check_inBasicSIUnits_example(quantity::Union{SimpleQuantity, SimpleQuantityArray}, correctFields::Dict{String,Any})
    correctValue = (quantity.value == correctFields["value"])
    correctUnit = (quantity.unit == correctFields["unit"])
    correctType = isa(quantity.value, correctFields["value type"])
    return correctValue && correctUnit && correctType
end

function inBasicSIUnits_implemented_forSimpleQuantity()
    examples = _getExamplesFor_inBasicSIUnits_forSimpleQuantity()
    return _check_inBasicSIUnits_examples(examples)
end

function _getExamplesFor_inBasicSIUnits_forSimpleQuantity()
    sq1 = SimpleQuantity{Float32}(1, Alicorn.unitlessUnit )
    correctFields1 = Dict([
        ("value", Float32(1)),
        ("unit", Unit(Alicorn.unitlessUnit)),
        ("value type", Float32)
    ])

    sq2 = SimpleQuantity{Int64}(1, ucat.meter)
    correctFields2 = Dict([
        ("value", Int64(1)),
        ("unit", Unit(ucat.meter)),
        ("value type", Int64)
    ])

    sq3 = SimpleQuantity{Float64}(4.2, ucat.joule)
    correctFields3 = Dict([
        ("value", Float64(4.2)),
        ("unit", Unit(Alicorn.kilogram * ucat.meter^2 / ucat.second^2)),
        ("value type", Float64)
    ])

    sq4 = SimpleQuantity{Float64}(-4.5, (ucat.mega * ucat.henry)^2)
    correctFields4 = Dict([
        ("value", Float64(-4.5e12)),
        ("unit", Unit(Alicorn.kilogram^2 * Alicorn.meter^4 * Alicorn.second^-4 * Alicorn.ampere^-4)),
        ("value type", Float64)
    ])

    sq5 = SimpleQuantity{Float32}(0.5, ucat.hour)
    unit5 = Alicorn.unitlessUnit
    correctFields5 = Dict([
        ("value", Float32(1800)),
        ("unit", Unit(ucat.second)),
        ("value type", Float32)
    ])

    examples = [
        (sq1, correctFields1),
        (sq2, correctFields2),
        (sq3, correctFields3),
        (sq4, correctFields4),
        (sq5, correctFields5)
        ]

    return examples
end

function inBasicSIUnits_implemented_forQuantity()
    examples = _getExamplesFor_inBasicSIUnits_forQuantity()
    return _check_inBasicSIUnits_examples(examples)
end

function _getExamplesFor_inBasicSIUnits_forQuantity()
    q1 = Quantity{Int32}(1, dimless, defaultInternalUnits)
    correctFields1 = Dict([
        ("value", Int32(1)),
        ("unit", Unit(Alicorn.unitlessUnit)),
        ("value type", Int32)
    ])

    q2 = Quantity{Int32}(500, lengthDim, InternalUnits(length=2*ucat.milli*ucat.meter))
    correctFields2 = Dict([
        ("value", Int32(1)),
        ("unit", Unit(ucat.meter)),
        ("value type", Int32)
    ])

    q3 = Quantity{Float64}(4.2, lengthDim, intu2)
    correctFields3 = Dict([
        ("value", Float64(8.4)),
        ("unit", Unit(ucat.meter)),
        ("value type", Float64)
    ])

    examples = [
        (q1, correctFields1),
        (q2, correctFields2),
        (q3, correctFields3)
        ]

    return examples
end

function inBasicSIUnits_implemented_forSimpleQuantityArray()
    examples = _getExamplesFor_inBasicSIUnits_forSimpleQuantityArray()
    return _check_inBasicSIUnits_examples(examples)
end

function _getExamplesFor_inBasicSIUnits_forSimpleQuantityArray()
    sqArray1 = SimpleQuantityArray{Float32}(ones(2,2), Alicorn.unitlessUnit)
    correctFields1 = Dict([
        ("value", Array{Float32}(ones(2,2))),
        ("unit", Unit(Alicorn.unitlessUnit)),
        ("value type", Array{Float32})
    ])

    sqArray2 = SimpleQuantityArray{Int32}(ones(2,2), Alicorn.meter)
    correctFields2 = Dict([
        ("value", Array{Int32}(ones(2,2))),
        ("unit", Unit(ucat.meter)),
        ("value type", Array{Int32})
    ])

    sqArray3 = SimpleQuantityArray{Float64}([4.2], ucat.joule)
    correctFields3 = Dict([
        ("value", Array{Float64}([4.2])),
        ("unit", Unit(Alicorn.kilogram * ucat.meter^2 / ucat.second^2)),
        ("value type", Array{Float64})
    ])

    sqArray4 = SimpleQuantityArray{Float32}([-4.5, 2], (ucat.mega * ucat.henry)^2)
    correctFields4 = Dict([
        ("value", Array{Float32}([-4.5e12, 2e12] )),
        ("unit", Unit(Alicorn.kilogram^2 * Alicorn.meter^4 * Alicorn.second^-4 * Alicorn.ampere^-4)),
        ("value type", Array{Float32})
    ])

    sqArray5 = SimpleQuantityArray{Int32}([1 2], ucat.hour)
    unit5 = Alicorn.unitlessUnit
    correctFields5 = Dict([
        ("value", Array{Int32}([3600 7200])),
        ("unit", Unit(ucat.second)),
        ("value type", Array{Int32})
    ])

    examples = [
        (sqArray1, correctFields1),
        (sqArray2, correctFields2),
        (sqArray3, correctFields3),
        (sqArray4, correctFields4),
        (sqArray5, correctFields5)
        ]

    return examples
end

function inBasicSIUnits_implemented_forQuantityArray()
    examples = _getExamplesFor_inBasicSIUnits_forQuantityArray()
    return _check_inBasicSIUnits_examples(examples)
end

function _getExamplesFor_inBasicSIUnits_forQuantityArray()
    qArray1 = QuantityArray{Float32}(ones(2,2), dimless, defaultInternalUnits)
    correctFields1 = Dict([
        ("value", Array{Float32}(ones(2,2))),
        ("unit", Unit(Alicorn.unitlessUnit)),
        ("value type", Array{Float32})
    ])

    qArray2 = QuantityArray{Int32}([2 3], lengthDim, intu2)
    correctFields2 = Dict([
        ("value", Array{Int32}([4 6])),
        ("unit", Unit(ucat.meter)),
        ("value type", Array{Int32})
    ])

    qArray3 = QuantityArray{Float64}([4.2], Dimension(M=1, L=2, T=-2), defaultInternalUnits)
    correctFields3 = Dict([
        ("value", Array{Float64}([4.2])),
        ("unit", Unit(Alicorn.kilogram * ucat.meter^2 / ucat.second^2)),
        ("value type", Array{Float64})
    ])

    examples = [
        (qArray1, correctFields1),
        (qArray2, correctFields2),
        (qArray3, correctFields3)
        ]

    return examples
end

## valueOfDimensionless

function _check_valueOfDimensionless_examples(examples::Array)
    correct = true
    for (quantity, correctFields) in examples
        returnedValue = valueOfDimensionless(quantity)
        correct &= _check_valueOfDimensionless_example(returnedValue, correctFields)
    end
    return correct
end

function _check_valueOfDimensionless_example(value::Union{Number, Array{<:Number}}, correctFields::Dict{String,Any})
    correctValue = (value == correctFields["value"])
    correctType = isa(value, correctFields["value type"])
    return correctValue && correctType
end

function valueOfDimensionless_implemented_forSimpleQuantity()
    examples = _getExamplesFor_valueOfDimensionless_forSimpleQuantity()
    return _check_valueOfDimensionless_examples(examples)
end

function _getExamplesFor_valueOfDimensionless_forSimpleQuantity()
    sq1 = SimpleQuantity{Float32}(7)
    correctFields1 = Dict([
        ("value", Float32(7)),
        ("value type", Float32)
    ])

    sq2 = SimpleQuantity{Int32}(7, ucat.meter * (ucat.centi * ucat.meter)^-1 )
    correctFields2 = Dict([
        ("value", Int32(700)),
        ("value type", Int32)
    ])

    examples = [
        (sq1, correctFields1),
        (sq2, correctFields2)
        ]

    return examples
end

function test_valueOfDimensionless_ErrorsIfNotUnitless_forSimpleQuantity()
    simpleQuantity = 7 * Alicorn.meter
    expectedError = Alicorn.Exceptions.DimensionMismatchError("quantity is not dimensionless")
    @test_throws expectedError valueOfDimensionless(simpleQuantity)
end

function valueOfDimensionless_implemented_forQuantity()
    examples = _getExamplesFor_valueOfDimensionless_forQuantity()
    return _check_valueOfDimensionless_examples(examples)
end

function _getExamplesFor_valueOfDimensionless_forQuantity()
    q1 = Quantity{Float32}(7, dimless, defaultInternalUnits)
    correctFields1 = Dict([
        ("value", Float32(7)),
        ("value type", Float32)
    ])

    q2 = Quantity{Int32}(7, dimless, intu2 )
    correctFields2 = Dict([
        ("value", Int32(7)),
        ("value type", Int32)
    ])

    examples = [
        (q1, correctFields1),
        (q2, correctFields2)
        ]

    return examples
end

function test_valueOfDimensionless_ErrorsIfNotUnitless_forQuantity()
    quantity = Quantity(7, lengthDim, defaultInternalUnits)
    expectedError = Alicorn.Exceptions.DimensionMismatchError("quantity is not dimensionless")
    @test_throws expectedError valueOfDimensionless(quantity)
end

function valueOfDimensionless_implemented_forSimpleQuantityArray()
    examples = _getExamplesFor_valueOfDimensionless_forSimpleQuantityArray()
    return _check_valueOfDimensionless_examples(examples)
end

function _getExamplesFor_valueOfDimensionless_forSimpleQuantityArray()
    sqArray1 = SimpleQuantityArray{Float32}([7, 5])
    correctFields1 = Dict([
        ("value", Array{Float32}([7, 5])),
        ("value type", Array{Float32})
    ])

    sqArray2 = SimpleQuantityArray{Int32}([7, -2], ucat.meter * (ucat.centi * ucat.meter)^-1 )
    correctFields2 = Dict([
        ("value", Array{Int32}([700, -200])),
        ("value type", Array{Int32})
    ])

    examples = [
        (sqArray1, correctFields1),
        (sqArray2, correctFields2)
        ]

    return examples
end

function test_valueOfDimensionless_ErrorsIfNotUnitless_forSimpleQuantityArray()
    sqArray = [7] * Alicorn.meter
    expectedError = Alicorn.Exceptions.DimensionMismatchError("quantity is not dimensionless")
    @test_throws expectedError valueOfDimensionless(sqArray)
end

function valueOfDimensionless_implemented_forQuantityArray()
    examples = _getExamplesFor_valueOfDimensionless_forQuantityArray()
    return _check_valueOfDimensionless_examples(examples)
end

function _getExamplesFor_valueOfDimensionless_forQuantityArray()
    qArray1 = QuantityArray{Float32}([7, 5], dimless, defaultInternalUnits)
    correctFields1 = Dict([
        ("value", Array{Float32}([7, 5])),
        ("value type", Array{Float32})
    ])

    qArray2 = QuantityArray{Int32}([7, -3], dimless, intu2 )
    correctFields2 = Dict([
        ("value", Array{Int32}([7, -3])),
        ("value type", Array{Int32})
    ])

    examples = [
        (qArray1, correctFields1),
        (qArray2, correctFields2)
        ]

    return examples
end

function test_valueOfDimensionless_ErrorsIfNotUnitless_forQuantityArray()
    qArray = QuantityArray([7], lengthDim, defaultInternalUnits)
    expectedError = Alicorn.Exceptions.DimensionMismatchError("quantity is not dimensionless")
    @test_throws expectedError valueOfDimensionless(qArray)
end

end # module
