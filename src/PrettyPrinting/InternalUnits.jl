function Base.show(io::IO, internalUnits::InternalUnits)
    output = generatePrettyPrintingOutput(internalUnits)
    print(io, output)
end

generatePrettyPrintingOutput(internalUnits::InternalUnits) = "InternalUnits\n" * generateStringRepresentation(internalUnits)

function generateStringRepresentation(internalUnits::InternalUnits)
    massString              = " mass unit:               " * generatePrettyPrintingOutput(internalUnits.mass) * "\n"
    lengthString            = " length unit:             " * generatePrettyPrintingOutput(internalUnits.length) * "\n"
    timeString              = " time unit:               " * generatePrettyPrintingOutput(internalUnits.time) * "\n"
    currentString           = " current unit:            " * generatePrettyPrintingOutput(internalUnits.current) * "\n"
    temperatureString       = " temperature unit:        " * generatePrettyPrintingOutput(internalUnits.temperature) * "\n"
    amountString            = " amount unit:             " * generatePrettyPrintingOutput(internalUnits.amount) * "\n"
    luminousIntensityString = " luminous intensity unit: " * generatePrettyPrintingOutput(internalUnits.luminousIntensity)

    return massString * lengthString * timeString * currentString * temperatureString * amountString * luminousIntensityString
end

function generateShortStringRepresentation(internalUnits::InternalUnits, dimension::Dimension)
    isFirstElement = true

    (isFirstElement, massString) = _generateShortString(internalUnits.mass, dimension.massExponent, isFirstElement)
    (isFirstElement, lengthString) = _generateShortString(internalUnits.length, dimension.lengthExponent, isFirstElement)
    (isFirstElement, timeString) = _generateShortString(internalUnits.time, dimension.timeExponent, isFirstElement)
    (isFirstElement, currentString) = _generateShortString(internalUnits.current, dimension.currentExponent, isFirstElement)
    (isFirstElement, temperatureString) = _generateShortString(internalUnits.temperature, dimension.temperatureExponent, isFirstElement)
    (isFirstElement, amountString) = _generateShortString(internalUnits.amount, dimension.amountExponent, isFirstElement)
    (isFirstElement, luminousIntensityString) = _generateShortString(internalUnits.luminousIntensity, dimension.luminousIntensityExponent, isFirstElement)

    prettyString = massString * lengthString * timeString * currentString * temperatureString * amountString * luminousIntensityString

    if isempty(prettyString)
        prettyString = "1"
    end

    return prettyString
end

function _generateShortString(internalUnit::SimpleQuantity, dimensionExponent::Real, isFirstElement::Bool)
    if dimensionExponent == 0
        return (isFirstElement, "")
    else
        separator = isFirstElement ? "" : ", "
        return (false, separator * generatePrettyPrintingOutput(internalUnit) )
    end
end
