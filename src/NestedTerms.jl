module NestedTerms

using StatsModels
import StatsModels: Schema, width, terms, ColumnTable, modelcols
export process_nt

mutable struct NestedTerm{Ts} <: AbstractTerm
    terms::Ts
end

StatsModels.width(ts::NestedTerm) = prod(width(t) for t in ts.terms)
StatsModels.terms(t::NestedTerm)  = terms(t.terms)
function StatsModels.apply_schema(it::NestedTerm, schema::Schema, Mod::Type)
    NestedTerm(apply_schema(it.terms, schema, Mod))
end

function process_nt(formula::FormulaTerm)
    FormulaTerm(formula.lhs, ft2nt.(formula.rhs))
end

function ft2nt(term)
    if term isa FunctionTerm && term.f == in 
        return NestedTerm((term.args[1], term.args[2]))
    end
    return term
end

function StatsModels.modelcols(t::NestedTerm, d::ColumnTable)
    fac   = t.terms[1].sym
    nfac  = t.terms[2].sym
    clist = unique(zip(d[nfac], d[fac]))
    dellist = Vector{eltype(clist)}(undef, 0)
    for l in t.terms[2].contrasts.levels
        ind = findfirst(x-> x[1] == l, clist)
        push!(dellist, clist[ind])
        deleteat!(clist, ind)
    end
    n = length(clist)
    lvldict = Dict(k => v for (k, v) in zip(clist, 1:n))

    mxs = length(d[fac])
    mx = zeros(mxs, n)
    for i in 1:mxs
        val = (d[nfac][i], d[fac][i]) 
        if !(val in dellist)
            ind = lvldict[val] 
            mx[i, ind] = 1.0
        end
    end
    mx
end


end
