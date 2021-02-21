export InternalUnits
struct InternalUnits
    massUnit::SimpleQuantity
    lengthUnit::SimpleQuantity
    timeUnit::SimpleQuantity
    currentUnit::SimpleQuantity
    temperatureUnit::SimpleQuantity
    amountUnit::SimpleQuantity
    luminousIntensityUnit::SimpleQuantity

    function InternalUnits(;
        massUnit::SimpleQuantity = 1 * kilogram,
        lengthUnit::SimpleQuantity = 1 * meter,
        timeUnit::SimpleQuantity = 1 * second,
        currentUnit::SimpleQuantity = 1 * ampere,
        temperatureUnit::SimpleQuantity = 1 * kelvin,
        amountUnit::SimpleQuantity = 1 * mol,
        luminousIntensityUnit::SimpleQuantity = 1 * candela
        )
        units = (massUnit, lengthUnit, timeUnit, currentUnit, temperatureUnit, amountUnit, luminousIntensityUnit)
        return new(units...)
    end
end
