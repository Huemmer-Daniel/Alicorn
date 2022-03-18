"""
    AbstractQuantity{T,N} <: AbstractArray{T,N}

Abstract supertype for all array-valued quantities of dimension `N` and with
elements of type `T`.
"""
abstract type AbstractQuantityArray{T,N} <: AbstractArray{T,N} end

"""
    AbstractQuantityVector{T}

Abstract supertype for one-dimensional array-valued quantities with elements of
type `T`.

Alias for `AbstractQuantityArray{T,1}`.
"""
const AbstractQuantityVector{T} = AbstractQuantityArray{T,1}

"""
    AbstractQuantityMatrix{T}

Abstract supertype for two-dimensional array-valued quantities with elements of
type `T`.

Alias for `AbstractQuantityArray{T,2}`.
"""
const AbstractQuantityMatrix{T} = AbstractQuantityArray{T,2}

"""
    VectorQuantity{T}

Type union representing one-dimensional arrays with elements of type `T`, with
or without a physical unit.

Alias for `Union{Vector{T}, AbstractQuantityArray{T, 1}} where T<:Number`.
"""
const VectorQuantity{T} = Union{Vector{T}, AbstractQuantityArray{T, 1}} where T<:Number

"""
    MatrixQuantity{T}

Type union representing two-dimensional arrays with elements of type `T`, with
or without a physical unit.

Alias for `Union{Matrix{T}, AbstractQuantityArray{T, 2}} where T<:Number`.
"""
const MatrixQuantity{T} = Union{Matrix{T}, AbstractQuantityArray{T, 2}} where T<:Number

"""
    ArrayQuantity{T,N}

Type union representing `N`-dimensional arrays with elements of type `T`, with
or without a physical unit.

Alias for `Union{Array{T,N}, AbstractQuantityArray{T,N}} where {T<:Number, N}`.
"""
const ArrayQuantity{T,N} = Union{Array{T,N}, AbstractQuantityArray{T,N}} where {T<:Number, N}
