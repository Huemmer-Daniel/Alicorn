SimpleQuantityType = Union{SimpleQuantity, SimpleQuantityArray}
DimensionlessType = Union{Number, AbstractArray{<:Number}}

## Unary operators

# methods documented as part of the AbstractQuantity interface
# scalar quantity
Base.:+(simpleQuantity::SimpleQuantity) = simpleQuantity
Base.:-(simpleQuantity::SimpleQuantity) = unaryMinus(simpleQuantity)
# array quantity
Base.:+(sqArray::SimpleQuantityArray) = sqArray
Base.:-(sqArray::SimpleQuantityArray) = unaryMinus(sqArray)

function unaryMinus(sQuantity::SimpleQuantityType)
    value = -sQuantity.value
    unit = sQuantity.unit
    return value * unit
end

## Multiplication

# methods documented as part of the AbstractQuantity interface
# salar quantity
Base.:*(a::SimpleQuantity, b::SimpleQuantity) = multiplication(a, b)
Base.:*(a::SimpleQuantity, b::Number) = multiplication(a, b)
Base.:*(a::Number, b::SimpleQuantity) = multiplication(a, b)
Base.:*(a::SimpleQuantity, b::Array{<:Number}) = multiplication(a, b)
Base.:*(a::Array{<:Number}, b::SimpleQuantity) = multiplication(a, b)
# array quantity
Base.:*(a::SimpleQuantityArray, b::SimpleQuantityArray) = multiplication(a, b)
Base.:*(a::SimpleQuantityArray, b::Array{<:Number}) = multiplication(a, b)
Base.:*(a::Array{<:Number}, b::SimpleQuantityArray) = multiplication(a, b)
Base.:*(a::SimpleQuantityArray, b::SimpleQuantity) = multiplication(a, b)
Base.:*(a::SimpleQuantity, b::SimpleQuantityArray) = multiplication(a, b)
Base.:*(a::SimpleQuantityArray, b::Number) = multiplication(a, b)
Base.:*(a::Number, b::SimpleQuantityArray) = multiplication(a, b)

function multiplication(sQuantity1::SimpleQuantityType, sQuantity2::SimpleQuantityType)
    productValue = sQuantity1.value * sQuantity2.value
    productUnit = sQuantity1.unit * sQuantity2.unit
    return  productValue * productUnit
end

function multiplication(sQuantity::SimpleQuantityType, dimless::DimensionlessType)
    productValue = sQuantity.value * dimless
    productUnit = sQuantity.unit
    return productValue * productUnit
end

function multiplication(dimless::DimensionlessType, sQuantity::SimpleQuantityType)
    productValue = dimless * sQuantity.value
    productUnit = sQuantity.unit
    return productValue * productUnit
end

## Division

# methods documented as part of the AbstractQuantity interface
# scalar quantity
Base.:/(a::SimpleQuantity, b::SimpleQuantity) = division(a, b)
Base.:/(a::SimpleQuantity, b::Number) = division(a, b)
Base.:/(a::Number, b::SimpleQuantity) = division(a, b)
Base.:/(a::SimpleQuantity, b::Array{<:Number}) = division(a, b)
Base.:/(a::Array{<:Number}, b::SimpleQuantity) = division(a, b)
# array quantity
Base.:/(a::SimpleQuantityArray, b::SimpleQuantityArray) = division(a, b)
Base.:/(a::SimpleQuantityArray, b::Array{<:Number}) = division(a, b)
Base.:/(a::Array{<:Number}, b::SimpleQuantityArray) = division(a, b)
Base.:/(a::SimpleQuantityArray, b::SimpleQuantity) = division(a, b)
Base.:/(a::SimpleQuantity, b::SimpleQuantityArray) = division(a, b)
Base.:/(a::SimpleQuantityArray, b::Number) = division(a, b)
Base.:/(a::Number, b::SimpleQuantityArray) = division(a, b)

function division(sQuantity1::SimpleQuantityType, sQuantity2::SimpleQuantityType)
    quotientValue = sQuantity1.value / sQuantity2.value
    quotientUnit = sQuantity1.unit / sQuantity2.unit
    return  quotientValue * quotientUnit
end

function division(sQuantity::SimpleQuantityType, dimless::DimensionlessType)
    quotientValue = sQuantity.value / dimless
    quotientUnit = sQuantity.unit
    return quotientValue * quotientUnit
end

function division(dimless::DimensionlessType, sQuantity::SimpleQuantityType)
    quotientValue = dimless / sQuantity.value
    quotientUnit = inv(sQuantity.unit)
    return quotientValue * quotientUnit
end

## Inverse division

# methods documented as part of the AbstractQuantity interface
# scalar quantity
Base.:\(a::SimpleQuantity, b::SimpleQuantity) = inverseDivision(a, b)
Base.:\(a::SimpleQuantity, b::Number) = inverseDivision(a, b)
Base.:\(a::Number, b::SimpleQuantity) = inverseDivision(a, b)
Base.:\(a::SimpleQuantity, b::Array{<:Number}) = inverseDivision(a, b)
Base.:\(a::Array{<:Number}, b::SimpleQuantity) = inverseDivision(a, b)
# array quantity
Base.:\(a::SimpleQuantityArray, b::SimpleQuantityArray) = inverseDivision(a, b)
Base.:\(a::SimpleQuantityArray, b::Array{<:Number}) = inverseDivision(a, b)
Base.:\(a::Array{<:Number}, b::SimpleQuantityArray) = inverseDivision(a, b)
Base.:\(a::SimpleQuantity, b::SimpleQuantityArray) = inverseDivision(a, b)
Base.:\(a::Number, b::SimpleQuantityArray) = inverseDivision(a, b)

function inverseDivision(sQuantity1::SimpleQuantityType, sQuantity2::SimpleQuantityType)
    quotientValue = sQuantity1.value \ sQuantity2.value
    quotientUnit = sQuantity2.unit / sQuantity1.unit
    return  quotientValue * quotientUnit
end

function inverseDivision(sQuantity::SimpleQuantityType, dimless::DimensionlessType)
    quotientValue = sQuantity.value \ dimless
    quotientUnit = inv(sQuantity.unit)
    return quotientValue * quotientUnit
end

function inverseDivision(dimless::DimensionlessType, sQuantity::SimpleQuantityType)
    quotientValue = dimless \ sQuantity.value
    quotientUnit = sQuantity.unit
    return quotientValue * quotientUnit
end

## Power

# methods documented as part of the AbstractQuantity interface
# scalar quantity
Base.:^(a::SimpleQuantity, b::Real) = power(a, b)
Base.:^(a::SimpleQuantity, b::Integer) = power(a, b)
# array quantity
Base.:^(a::SimpleQuantityArray, b::Real) = power(a, b)
Base.:^(a::SimpleQuantityArray, b::Integer) = power(a, b)

function power(sQuantity::SimpleQuantityType, exponent::Real)
    exponentiatedValue = (sQuantity.value)^exponent
    exponentiatedUnit = (sQuantity.unit)^exponent
    return exponentiatedValue * exponentiatedUnit
end

## Inverse

# methods documented as part of the AbstractQuantity interface
# scalar quantity
Base.:inv(a::SimpleQuantity) = inverse(a)
# array quantity
Base.:inv(a::SimpleQuantityArray) = inverse(a)

function inverse(sQuantity::SimpleQuantityType)
    inverseValue = inv(sQuantity.value)
    inverseUnit = inv(sQuantity.unit)
    return inverseValue * inverseUnit
end
