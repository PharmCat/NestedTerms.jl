using NestedTerms
using Test
using StatsModels, CSV, DataFrames, CategoricalArrays, LinearAlgebra

@testset "NestedTerms.jl" begin
    rds = CSV.File(joinpath(dirname(pathof(NestedTerms)), "..", "test", "csv",  "rds12x2.csv")) |> DataFrame

    transform!(rds, :Sequence => categorical, renamecols=false)
    transform!(rds, :Subject => categorical, renamecols=false)

    formula = @formula(Var ~ (Subject in Sequence))

    formula = NestedTerms.process_nt(formula)
    sch    = schema(formula, rds)
    as     = apply_schema(formula, sch)
    rmf, lmf = modelcols(as, rds)

    @test size(lmf) == (36,16)
    @test rank(lmf) == 16
end
