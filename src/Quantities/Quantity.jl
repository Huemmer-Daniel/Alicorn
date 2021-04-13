export Quantity
@doc raw"""
    Quantity{T} <: AbstractQuantity

A physical quantity consisting of... TODO
"""
mutable struct Quantity{T} <: AbstractQuantity
    value::T
    dimension::Dimension
    internalUnits::InternalUnits
end

## External constructors

function Quantity(simpleQuantity::SimpleQuantity, internalUnits::InternalUnits)
    dimension = dimensionOf(simpleQuantity)
    internalUnit = internalUnitForDimension(dimension, internalUnits)
    unitlessQuantity = inBasicSIUnits(simpleQuantity / internalUnit)
    internalValue = valueOfUnitless(unitlessQuantity)
    return Quantity(internalValue, dimension, internalUnits)
end

function internalUnitForDimension(dimension, internalUnits)
    Mexp = dimension.massExponent
    Lexp = dimension.lengthExponent
    Texp = dimension.timeExponent
    Iexp = dimension.currentExponent
    Θexp = dimension.temperatureExponent
    Nexp = dimension.amountExponent
    Jexp = dimension.luminousIntensityExponent

    Munit = internalUnits.mass
    Lunit = internalUnits.length
    Tunit = internalUnits.time
    Iunit = internalUnits.current
    θunit = internalUnits.temperature
    Nunit = internalUnits.amount
    Junit = internalUnits.luminousIntensity

    internalUnit = Munit^Mexp * Lunit^Lexp * Tunit^Texp * Iunit^Iexp * θunit^Θexp * Nunit^Nexp * Junit^Jexp
    return internalUnit
end
