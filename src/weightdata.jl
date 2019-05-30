# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    WeightedSpatialData(spatialdata, weights)

Assign `weights` for each point in `spatialdata`.
"""
struct WeightedSpatialData{T<:Real,N,S<:AbstractSpatialData{T,N},V} <: AbstractSpatialData{T,N}
  spatialdata::S
  weights::Vector{V}
end

domain(d::WeightedSpatialData) = domain(d.spatialdata)

variables(d::WeightedSpatialData) = variables(d.spatialdata)

value(d::WeightedSpatialData, ind::Int, var::Symbol) = value(d.spatialdata, ind, var)

mean(d::WeightedSpatialData, v::Symbol) = mean(values(d, v), weights(d.weights))
mean(d::WeightedSpatialData) = Dict(v => mean(d, v) for (v,V) in variables(d))

var(d::WeightedSpatialData, v::Symbol) = var(values(d, v), weights(d.weights),
                                             mean=mean(d, v), corrected=false)
var(d::WeightedSpatialData) = Dict(v => var(d, v) for (v,V) in variables(d))

quantile(d::WeightedSpatialData, v::Symbol, p) = quantile(values(d, v), weights(d.weights), p)
quantile(d::WeightedSpatialData, p) = Dict(v => quantile(d, v, p) for (v,V) in variables(d))
