```@meta
DocTestSetup = quote
    using Alicorn
end
```

# Dimensions

```@docs
Dimension
Base.:*(::Number, ::Dimension)
Base.:+(::Dimension, ::Dimension)
dimensionOf(::AbstractUnit)
dimensionOf(::AbstractQuantity)
dimensionOf(::AbstractQuantityArray)
```

```@meta
DocTestSetup = nothing
```
