# push!(LOAD_PATH,"../src/")

using Documenter
using Alicorn

const REFERENCE = ["reference/units.md", "reference/quantities.md"]

const PAGES = [
    "Home" => "index.md",
    "Reference" => REFERENCE,
    "Basic Usage" => "usage/usage.md"
]

DocMeta.setdocmeta!(Alicorn, :DocTestSetup, :(using Alicorn); recursive=true)

const FORMAT = Documenter.HTML( sidebar_sitename = false, assets = ["assets/favicon.ico"] )

makedocs(
    modules  = [Alicorn],
    clean    = true,
    doctest  = true,
    strict   = true,
    format   = FORMAT,
    sitename = "Alicorn.jl",
    authors  = "Daniel Hümmer",
    pages    = PAGES
)
