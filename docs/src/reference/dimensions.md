```@meta
DocTestSetup = quote
    using Alicorn
end
```

# Dimensions

The `Dimensions` submodule is concerned with representing and manipulating physical dimensions.

Unless stated otherwise, all types, functions, and constants defined in the submodule are exported to the global scope.


```@docs
Dimension
```
#### Methods manipulating Dimensions

```@docs
Base.:*(::Number, ::Dimension)
Base.:*(::Dimension, ::Dimension)
Base.:/(::Dimension, ::Dimension)
Base.inv(::Dimension)
Base.:^(::Dimension, ::Number)
Base.:sqrt(::Dimension)
Base.:cbrt(::Dimension)
```

```@meta
DocTestSetup = nothing
```
