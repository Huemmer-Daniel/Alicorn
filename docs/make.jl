using Documenter
using Alicorn

const MANUAL = ["manual/basic_usage.md", "manual/advanced_usage.md"]
const REFERENCE = ["reference/units.md", "reference/dimensions.md", "reference/quantities.md", "reference/index.md"]
const PAGES = [
    "Home" => "index.md",
    "Manual" => MANUAL,
    "Reference" => REFERENCE
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

deploydocs(
    repo = "github.com/Huemmer-Daniel/Alicorn.jl.git",
    versions = nothing
)
