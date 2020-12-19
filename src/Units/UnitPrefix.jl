using ..Utils

export UnitPrefix
struct UnitPrefix
    name::String
    symbol::String
    value::Real

    function UnitPrefix(;name::String,symbol::String,value::Real)
        Utils.assertIsFinite(value)
        Utils.assertNameIsValidSymbol(name)
        new(name, symbol, value)
    end
end

function Base.show(io::IO, prefix::UnitPrefix)
    output = _generatePrettyPrintingOutput(prefix)
    print(io,output)
end

function _generatePrettyPrintingOutput(prefix::UnitPrefix)
    name = prefix.name
    symbol = prefix.symbol
    value = prefix.value
    valueString = Utils.prettyPrintScientificNumber(value, sigdigits=3)
    return "UnitPrefix $name ($symbol) of value " * valueString
end
