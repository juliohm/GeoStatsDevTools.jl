# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

#------------------------
# WEIGHTED SPATIAL DATA
#------------------------
mean(d::WeightedSpatialData, v::Symbol) = mean(values(d, v), weights(d.weights))
mean(d::WeightedSpatialData) = Dict(v => mean(d, v) for (v,V) in variables(d))

var(d::WeightedSpatialData, v::Symbol) = var(values(d, v), weights(d.weights),
                                             mean=mean(d, v), corrected=false)
var(d::WeightedSpatialData) = Dict(v => var(d, v) for (v,V) in variables(d))

quantile(d::WeightedSpatialData, v::Symbol, p) = quantile(values(d, v), weights(d.weights), p)
quantile(d::WeightedSpatialData, p::Real) = Dict(v => quantile(d, v, p) for (v,V) in variables(d))
quantile(d::WeightedSpatialData, ps::AbstractVector{Real}) = Dict(v => quantile(d, v, ps) for (v,V) in variables(d))

#---------------
# SPATIAL DATA
#---------------
mean(d::AbstractSpatialData, w::AbstractWeighter) = mean(weight(d, w))
mean(d::AbstractSpatialData, blockside::Real) = mean(d, BlockWeighter(blockside))
mean(d::AbstractSpatialData) = mean(d, median_distance(d))

var(d::AbstractSpatialData, w::AbstractWeighter) = var(weight(d, w))
var(d::AbstractSpatialData, blockside::Real) = var(d, BlockWeighter(blockside))
var(d::AbstractSpatialData) = var(d, median_distance(d))

quantile(d::AbstractSpatialData, p::Real, w::AbstractWeighter) = quantile(weight(d, w), p)
quantile(d::AbstractSpatialData, ps::AbstractVector{Real}, w::AbstractWeighter) = quantile(weight(d, w), ps)
quantile(d::AbstractSpatialData, p::Real, blockside::Real) = quantile(weight(d, BlockWeighter(blockside)), p)
quantile(d::AbstractSpatialData, ps::AbstractVector{Real}, blockside::Real) = quantile(weight(d, BlockWeighter(blockside)), ps)
quantile(d::AbstractSpatialData, p::Real) = quantile(d, p, median_distance(d))
quantile(d::AbstractSpatialData, ps::AbstractVector{Real}) = quantile(d, ps, median_distance(d))

function median_distance(d::AbstractSpatialData)
  N = npoints(d)
  n = min(N, 100)
  inds = unique(rand(1:N, n))
  X = coordinates(d, inds)
  D = pairwise(Euclidean(), X, dims=2)
  median(D)
end
