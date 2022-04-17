# copy
Base.copy(simpleQuantity::SimpleQuantity) = SimpleQuantity(copy(simpleQuantity.value), simpleQuantity.unit)
Base.deepcopy(simpleQuantity::SimpleQuantity) = SimpleQuantity(deepcopy(simpleQuantity.value), simpleQuantity.unit)

Base.copy(sqArray::SimpleQuantityArray) = SimpleQuantityArray(copy(sqArray.value), sqArray.unit)
Base.deepcopy(sqArray::SimpleQuantityArray) = SimpleQuantityArray(deepcopy(sqArray.value), sqArray.unit)

Base.copy(quantity::Quantity) = Quantity(copy(quantity.value), quantity.dimension, quantity.internalUnits)
Base.deepcopy(quantity::Quantity) = Quantity(deepcopy(quantity.value), quantity.dimension, quantity.internalUnits)

Base.copy(qArray::QuantityArray) = QuantityArray(copy(qArray.value), qArray.dimension, qArray.internalUnits)
Base.deepcopy(qArray::QuantityArray) = QuantityArray(deepcopy(qArray.value), qArray.dimension, qArray.internalUnits)
