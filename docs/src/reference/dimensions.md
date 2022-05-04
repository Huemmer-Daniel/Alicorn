```@meta
DocTestSetup = quote
    using Alicorn
end
```

# Dimensions

The `Dimensions` submodule is concerned with defining and manipulating physical dimensions.

```@docs
Dimension
Base.:*(::Number, ::Dimension)
Base.inv(::Dimension)
Base.:*(::Dimension, ::Dimension)
Base.:/(::Dimension, ::Dimension)
Base.:^(::Dimension, ::Number)
Base.:sqrt(::Dimension)
Base.:cbrt(::Dimension)
```

```@meta
DocTestSetup = nothing
```
