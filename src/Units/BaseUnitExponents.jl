using ..Utils

export BaseUnitExponents
struct BaseUnitExponents
    kilogramExponent::Real
    meterExponent::Real
    secondExponent::Real
    ampereExponent::Real
    kelvinExponent::Real
    molExponent::Real
    candelaExponent::Real

    function BaseUnitExponents(; kg::Real=0, m::Real=0, s::Real=0, A::Real=0, K::Real=0, mol::Real=0, cd::Real=0 )
        _assertExponentsAreFinite([kg, m, s, A, K, mol, cd])
        new(kg, m, s, A, K, mol, cd)
    end
end

function _assertExponentsAreFinite(exponents)
    for exponent in exponents
        Utils.assertIsFinite(exponent)
    end
end

function Base.show(io::IO, baseUnitExp::BaseUnitExponents)
    output = _generatePrettyPrintingOutput(baseUnitExp)
    print(io,output)
end

function _generatePrettyPrintingOutput(baseUnitExp::BaseUnitExponents)
    exponents = _getExponentsAsArray(baseUnitExp)
    prettyString = _assemblePrettyString(exponents)
    return "BaseUnitExponents " * prettyString
end

function _getExponentsAsArray(baseUnitExp::BaseUnitExponents)
    exponents = [
    ("kg", baseUnitExp.kilogramExponent),
    ("m", baseUnitExp.meterExponent),
    ("s", baseUnitExp.secondExponent),
    ("A", baseUnitExp.ampereExponent),
    ("K", baseUnitExp.kelvinExponent),
    ("mol", baseUnitExp.molExponent),
    ("cd",  baseUnitExp.candelaExponent)
    ]
    return exponents
end

function _assemblePrettyString(exponents::Array)
    prettyString = ""
    for exp in exponents
        prettyString = _addPrettyFactor(prettyString, exp)
    end
    if prettyString == ""
        prettyString = "1"
    end
    return prettyString
end

function _addPrettyFactor(prettyString::String, exp::Tuple)
    (symbol, exponent) = exp

    if exponent == 0
        addString = ""
    elseif exponent == 1
        addString = "$symbol"
    else
        expString = Utils.prettyPrintScientificNumber(exponent, sigdigits=2)
        addString = "$symbol^$expString"
    end

    addString = _fixSpacingForPrettyFactor(prettyString, addString)
    return ( prettyString *= addString )
end

function _fixSpacingForPrettyFactor(prettyString::String, addString::String)
    if prettyString != "" && prettyString[end] != " " && addString != ""
        addString  = " " * addString
    end
    return addString
end
