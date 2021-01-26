push!(LOAD_PATH,"../src/")

using Documenter
using Alicorn

const REFERENCE = ["reference/units.md", "reference/quantities.md"]

const PAGES = [
    "Home" => "index.md",
    "Reference" => REFERENCE,
    "Basic Usage" => "usage/usage.md"
]

makedocs(
    sitename = "Alicorn.jl",
    authors = "Daniel Hümmer",
    pages = PAGES
)
