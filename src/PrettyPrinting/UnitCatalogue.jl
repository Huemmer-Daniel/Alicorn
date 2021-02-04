function Base.show(io::IO, ucat::UnitCatalogue)
    output = _generatePrettyPrintingOutput(ucat)
    print(io, output)
end

function _generatePrettyPrintingOutput(ucat::UnitCatalogue)
    nrOfPrefixes = length(listUnitPrefixes(ucat))
    nrOfBaseUnits = length(listBaseUnits(ucat))
    prettyString = "UnitCatalogue providing\n $nrOfPrefixes unit prefixes\n $nrOfBaseUnits base units"
    return prettyString
end
