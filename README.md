# NestedTerms.jl

Nested term concept package.

## Install 

```julia
import Pkg
Pkg.add(url = "https://github.com/PharmCat/NestedTerms.jl.git")
```

## Example

```
using NestedTerms
using StatsModels, CSV, DataFrames, CategoricalArrays

rds = CSV.File(joinpath(dirname(pathof(NestedTerms)), "..", "test", "csv",  "rds12x2.csv")) |> DataFrame # DataFrame with nested factor Subject(Sequence)

transform!(rds, :Sequence => categorical, renamecols=false)
transform!(rds, :Subject => categorical, renamecols=false)

# Nested term exploit function term in @formula macros
formula = @formula(Var ~ (Subject in Sequence))

# Replace FunctionTerm to NestedTerm
formula = NestedTerms.process_nt(formula)

# Make schema and apply_schema 
sch    = schema(formula, rds)
as     = apply_schema(formula, sch) $ upper level factor not added to the formula (but it shoud be there)

# Get model matrix for nested term 
rmf, lmf = modelcols(as, rds)
```

## Unsolvable problems

Can't get real `coefnames` and `levels` until `modelcols` not called. `apply_schema` not able to modify NestedTerm because have no appropriate information. 