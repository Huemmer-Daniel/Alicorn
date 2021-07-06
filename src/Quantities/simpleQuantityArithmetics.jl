SimpleQuantityType = Union{SimpleQuantity, SimpleQuantityArray}
DimensionlessType = Union{Number, AbstractArray{<:Number}}

## Multiplication

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

# method documented as part of the AbstractQuantity interface
function multiplication(sQuantity1::SimpleQuantityType, sQuantity2::SimpleQuantityType)
    productValue = sQuantity1.value * sQuantity2.value
    productUnit = sQuantity1.unit * sQuantity2.unit
    return  productValue * productUnit
end

# method documented as part of the AbstractQuantity interface
function multiplication(sQuantity::SimpleQuantityType, dimless::DimensionlessType)
    productValue = sQuantity.value * dimless
    productUnit = sQuantity.unit
    return productValue * productUnit
end

# method documented as part of the AbstractQuantity interface
function multiplication(dimless::DimensionlessType, sQuantity::SimpleQuantityType)
    productValue = dimless * sQuantity.value
    productUnit = sQuantity.unit
    return productValue * productUnit
end

## Division

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

# method documented as part of the AbstractQuantity interface
function division(sQuantity1::SimpleQuantityType, sQuantity2::SimpleQuantityType)
    quotientValue = sQuantity1.value / sQuantity2.value
    quotientUnit = sQuantity1.unit / sQuantity2.unit
    return  quotientValue * quotientUnit
end

# method documented as part of the AbstractQuantity interface
function division(sQuantity::SimpleQuantityType, dimless::DimensionlessType)
    quotientValue = sQuantity.value / dimless
    quotientUnit = sQuantity.unit
    return quotientValue * quotientUnit
end

# method documented as part of the AbstractQuantity interface
function division(dimless::DimensionlessType, sQuantity::SimpleQuantityType)
    quotientValue = dimless / sQuantity.value
    quotientUnit = inv(sQuantity.unit)
    return quotientValue * quotientUnit
end

## Inverse division

Base.:\(a::SimpleQuantity, b::SimpleQuantity) = inverseDivision(a, b)
Base.:\(a::SimpleQuantity, b::Number) = inverseDivision(a, b)
Base.:\(a::Number, b::SimpleQuantity) = inverseDivision(a, b)
Base.:\(a::SimpleQuantity, b::Array{<:Number}) = inverseDivision(a, b)
Base.:\(a::Array{<:Number}, b::SimpleQuantity) = inverseDivision(a, b)

# method documented as part of the AbstractQuantity interface
function inverseDivision(sQuantity1::SimpleQuantityType, sQuantity2::SimpleQuantityType)
    quotientValue = sQuantity1.value \ sQuantity2.value
    quotientUnit = sQuantity2.unit / sQuantity1.unit
    return  quotientValue * quotientUnit
end

# method documented as part of the AbstractQuantity interface
function inverseDivision(sQuantity::SimpleQuantityType, dimless::DimensionlessType)
    quotientValue = dimless / sQuantity.value
    quotientUnit = inv(sQuantity.unit)
    return quotientValue * quotientUnit
end

# method documented as part of the AbstractQuantity interface
function inverseDivision(dimless::DimensionlessType, sQuantity::SimpleQuantityType)
    quotientValue = sQuantity.value / dimless
    quotientUnit = sQuantity.unit
    return quotientValue * quotientUnit
end
