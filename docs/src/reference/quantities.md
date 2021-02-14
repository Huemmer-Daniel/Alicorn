```@meta
DocTestSetup = quote
    using Alicorn
end
```

# Quantities

#### Contents

```@contents
Pages = ["quantities.md"]
```

## Overview

## Abstract Supertypes

```@docs
AbstractQuantity
```

#### Interface of AbstractQuantity

The following functions are considered part of the interface of `AbstractQuantity` and need to be extended for all concrete subtypes of `AbstractQuantity`:

```@docs
Base.:(==)(::AbstractQuantity, ::AbstractQuantity)
inUnitsOf(::AbstractQuantity, ::AbstractUnit)
inBasicSIUnits(::AbstractQuantity)
Base.:*(::AbstractQuantity, ::AbstractUnit)
Base.:/(::AbstractQuantity, ::AbstractUnit)
Base.:+(::AbstractQuantity, ::AbstractQuantity)
Base.:-(::AbstractQuantity, ::AbstractQuantity)
Base.:*(::AbstractQuantity, ::AbstractQuantity)
Base.:/(::AbstractQuantity, ::AbstractQuantity)
Base.inv(::AbstractQuantity)
Base.:^(::AbstractQuantity, ::Real)
Base.sqrt(::AbstractQuantity)
```

## SimpleQuantity

```@docs
SimpleQuantity
Base.:(==)(::SimpleQuantity, ::SimpleQuantity)
Base.:*(::Any, ::AbstractUnit)
Base.:/(::Any, ::AbstractUnit)
```

```@meta
DocTestSetup = nothing
```
