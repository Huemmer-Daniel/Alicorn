SimpleQuantityType = Union{SimpleQuantity, SimpleQuantityArray}
DimensionlessType = Union{Number, AbstractArray{<:Number}}

## Multiplication

Base.:*(a::SimpleQuantity, b::SimpleQuantity) = multiplication(a, b)
Base.:*(a::SimpleQuantity, b::Number) = multiplication(a, b)
Base.:*(a::Number, b::SimpleQuantity) = multiplication(a, b)

Base.:*(a::SimpleQuantityArray, b::SimpleQuantityArray) = multiplication(a, b)
Base.:*(a::SimpleQuantity, b::SimpleQuantityArray) = multiplication(a, b)
Base.:*(a::SimpleQuantityArray, b::SimpleQuantity) = multiplication(a, b)
Base.:*(a::SimpleQuantityArray, b::Number) = multiplication(a, b)
Base.:*(a::Number, b::SimpleQuantityArray) = multiplication(a, b)

# method documented as part of the AbstractQuantity interface
function multiplication(sQuantity1::SimpleQuantityType, sQuantity2::SimpleQuantityType)
    productvalue = sQuantity1.value * sQuantity2.value
    productUnit = sQuantity1.unit * sQuantity2.unit
    return  productvalue * productUnit
end

# method documented as part of the AbstractQuantity interface
function multiplication(sQuantity::SimpleQuantityType, dimless::DimensionlessType)
    productvalue = sQuantity.value * dimless
    productUnit = sQuantity.unit
    return productvalue * productUnit
end

# method documented as part of the AbstractQuantity interface
function multiplication(dimless::DimensionlessType, sQuantity::SimpleQuantityType)
    productvalue = sQuantity.value * dimless
    productUnit = sQuantity.unit
    return productvalue * productUnit
end

# # method documented as part of the AbstractQuantity interface
# function Base.:*(number::Number, sqArray::SimpleQuantityArray)
#     productvalue = number * sqArray.value
#     productUnit = sqArray.unit
#     productQArray = SimpleQuantityArray(productvalue, productUnit)
#     return productQArray
# end
#
# # method documented as part of the AbstractQuantity interface
# function Base.:/(sqArray1::SimpleQuantityArray, sqArray2::SimpleQuantityArray)
#     quotientvalue = sqArray1.value / sqArray2.value
#     quotientUnit = sqArray1.unit / sqArray2.unit
#     quotientQArray = SimpleQuantityArray(quotientvalue, quotientUnit)
#     return quotientQArray
# end
#
# # method documented as part of the AbstractQuantity interface
# function Base.:/(sqArray::SimpleQuantityArray, simpleQuantity::SimpleQuantity)
#     quotientvalue = sqArray.value / simpleQuantity.value
#     quotientUnit = sqArray.unit / simpleQuantity.unit
#     quotientQArray = SimpleQuantityArray(quotientvalue, quotientUnit)
#     return quotientQArray
# end
