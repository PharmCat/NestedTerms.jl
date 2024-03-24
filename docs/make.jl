using NestedTerms
using Documenter

DocMeta.setdocmeta!(NestedTerms, :DocTestSetup, :(using NestedTerms); recursive=true)

makedocs(;
    modules=[NestedTerms],
    authors="Vladimir Arnautov",
    repo="https://github.com/PharmCat/NestedTerms.jl/blob/{commit}{path}#{line}",
    sitename="NestedTerms.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://PharmCat.github.io/NestedTerms.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/PharmCat/NestedTerms.jl",
    devbranch="main",
)
