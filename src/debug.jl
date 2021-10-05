using Alicorn
ucat = UnitCatalogue()

A = [1, 2] * ucat.meter
b = 1.5 * ucat.meter

A .< b
