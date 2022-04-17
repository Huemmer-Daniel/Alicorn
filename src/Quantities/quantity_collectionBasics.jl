Base.iterate(q::ScalarQuantity) = (q,nothing)
Base.iterate(q::ScalarQuantity, state) = nothing

Base.length(q::ScalarQuantity) = length(q.value)
