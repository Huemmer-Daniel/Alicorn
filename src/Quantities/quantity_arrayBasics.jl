## eltype
Base.eltype(q::SimpleQuantity{T}) where T = SimpleQuantity{T}
Base.eltype(q::SimpleQuantityArray{T}) where T = SimpleQuantity{T}
Base.eltype(q::Quantity{T}) where T = Quantity{T}
Base.eltype(q::QuantityArray{T}) where T = Quantity{T}


## copy
Base.copy(q::SimpleQuantity) = SimpleQuantity(copy(q.value), q.unit)
Base.deepcopy(q::SimpleQuantity) = SimpleQuantity(deepcopy(q.value), q.unit)

Base.copy(q::SimpleQuantityArray) = SimpleQuantityArray(copy(q.value), q.unit)
Base.deepcopy(q::SimpleQuantityArray) = SimpleQuantityArray(deepcopy(q.value), q.unit)

Base.copy(q::Quantity) = Quantity(copy(q.value), q.dimension, q.internalUnits)
Base.deepcopy(q::Quantity) = Quantity(deepcopy(q.value), q.dimension, q.internalUnits)

Base.copy(q::QuantityArray) = QuantityArray(copy(q.value), q.dimension, q.internalUnits)
Base.deepcopy(q::QuantityArray) = QuantityArray(deepcopy(q.value), q.dimension, q.internalUnits)


## axes
# axes(::AbstractQuantityType) falls back to size
# axes(::AbstractQuantityType, ::Integer) already define for SimpleQuantityArray and QuantityArray through AbstractArray
Base.axes(q::AbstractQuantity, d::Integer) = axes(q.value, d)


## ndims
# already define for SimpleQuantityArray and QuantityArray through AbstractArray
Base.ndims(q::AbstractQuantity) = 0


## length
# already define for SimpleQuantityArray and QuantityArray through AbstractArray
Base.length(q::AbstractQuantity) = 1


## firstindex
# firstindex(::AbstractQuantityArray) falls back to axes
Base.firstindex(q::AbstractQuantity) = 1
Base.firstindex(q::AbstractQuantity, d::Integer) = 1


## lastindex
# lastindex(::AbstractQuantityArray) falls back to axes
Base.lastindex(q::AbstractQuantity) = 1
Base.lastindex(q::AbstractQuantity, d::Integer) = 1


## IteratorSize
Base.IteratorSize(q::AbstractQuantity) = Base.HasShape{0}()


## keys
# already define for SimpleQuantityArray and QuantityArray through AbstractArray
Base.keys(q::AbstractQuantity) = Base.OneTo(1)


## get
# already define for SimpleQuantityArray and QuantityArray through AbstractArray
Base.get(q::AbstractQuantity, i::Integer, default) = isone(i) ? q : default
Base.get(q::AbstractQuantity, ind::Tuple, default) = all(isone, ind) ? q : default


## first
# already define for SimpleQuantityArray and QuantityArray through AbstractArray
# define fast version for scalar quantities
Base.first(q::AbstractQuantity) = q


## last
# already define for SimpleQuantityArray and QuantityArray through AbstractArray
# define fast version for scalar quantities
Base.last(q::AbstractQuantity) = q

## deleteat!
function Base.deleteat!(q::SimpleQuantityVector, inds)
    deleteat!(q.value, inds)
    return q
end

function Base.deleteat!(q::QuantityVector, inds)
    deleteat!(q.value, inds)
    return q
end

## repeat
function Base.repeat(q::SimpleQuantityArray; inner=nothing, outer=nothing)
    array = q.value
    repeatedArray = repeat(array; inner=inner, outer=outer)
    return SimpleQuantityArray( repeatedArray, q.unit )
end

function Base.repeat(q::SimpleQuantityArray, counts...)
    return repeat(q, outer=counts)
end

function Base.repeat(q::QuantityArray; inner=nothing, outer=nothing)
    array = q.value
    repeatedArray = repeat(array; inner=inner, outer=outer)
    return QuantityArray(repeatedArray, q.dimension, q.internalUnits )
end

function Base.repeat(q::QuantityArray, counts...)
    return repeat(q, outer=counts)
end

## iterate
Base.iterate(q::ScalarQuantity) = (q,nothing)
Base.iterate(q::ScalarQuantity, state) = nothing
