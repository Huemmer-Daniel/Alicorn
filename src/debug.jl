using Alicorn

ucat = UnitCatalogue() ;
a = [3.5, 4.6] * ucat.tesla ;
io = IOBuffer();

show(io, "text/plain", a)
generatedString = String(take!(io))
