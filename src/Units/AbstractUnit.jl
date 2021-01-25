export AbstractUnit
abstract type AbstractUnit <: AbstractUnitElement end

## 1. Generic functions
# these functions need to work for all implementations of AbstractUnit

# generic multiplication and division
function Base.:*(abstractUnit1::AbstractUnit, abstractUnit2::AbstractUnit)
    return convertToUnit(abstractUnit1) * convertToUnit(abstractUnit2)
end

function Base.:/(abstractUnit1::AbstractUnit, abstractUnit2::AbstractUnit)
    return convertToUnit(abstractUnit1) / convertToUnit(abstractUnit2)
end

# implementations of AbstractUnit act as scalars in broadcasting by default
Base.broadcastable(abstractUnit::AbstractUnit) = Ref(abstractUnit)


## 2. Interface
# the following functions need to be overloaded for concrete implementations of
# AbstractUnit

export convertToUnit
function convertToUnit(abstractUnit::AbstractUnit)::Unit
    subtype = typeof(abstractUnit)
    error("subtype $subtype of AbstractUnit misses an implementation of the convertToUnit function")
end

function Base.:*(unitPrefix::UnitPrefix, abstractUnit::AbstractUnit)
    subtype = typeof(abstractUnit)
    error("subtype $subtype of AbstractUnit misses an implementation of multiplication with UnitPrefix")
end

function Base.inv(abstractUnit::AbstractUnit)
    subtype = typeof(abstractUnit)
    error("subtype $subtype of AbstractUnit misses an implementation of the Base.inv function")
end

function Base.:^(abstractUnit::AbstractUnit, exponent::Real)
   subtype = typeof(abstractUnit)
   error("subtype $subtype of AbstractUnit misses an implementation of the Base.^ function")
end

function Base.:sqrt(abstractUnit::AbstractUnit)
   subtype = typeof(abstractUnit)
   error("subtype $subtype of AbstractUnit misses an implementation of the Base.sqrt function")
end

export convertToBasicSI
function convertToBasicSI(abstractUnit::AbstractUnit)
   subtype = typeof(abstractUnit)
   error("subtype $subtype of AbstractUnit misses an implementation of the convertToBasicSI function")
end

export convertToBasicSIAsExponents
function convertToBasicSIAsExponents(abstractUnit::AbstractUnit)
   subtype = typeof(abstractUnit)
   error("subtype $subtype of AbstractUnit misses an implementation of the convertToBasicSIAsExponents function")
end
