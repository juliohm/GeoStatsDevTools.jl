# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    NearestNeighborSearcher(domain, K, [metric])

A search method that finds at most `K` nearest neighbors in `domain`
according to `metric` (default to `Euclidean()`).
"""
struct NearestNeighborSearcher{KD<:KDTree} <: AbstractNeighborSearcher
  kdtree::KD
  K::Int
end

function NearestNeighborSearcher(domain::AbstractDomain, K::Int, metric::Metric=Euclidean())
  @assert 1 ≤ K ≤ npoints(domain) "number of neighbors must be in interval [1, npoints(domain)]"
  kdtree = KDTree(coordinates(domain), metric)
  NearestNeighborSearcher{typeof(kdtree)}(kdtree, K)
end

function search!(neighbors::AbstractVector{Int},
                 domain::AbstractDomain{T,N}, xₒ::AbstractVector{T},
                 searcher::NearestNeighborSearcher,
                 mask::AbstractVector{Bool}) where {T<:Real,N}
  locs, _ = knn(searcher.kdtree, xₒ, searcher.K, true)

  # retain locations in mask
  nneigh = 0
  @inbounds for loc in locs
    if mask[loc]
      nneigh += 1
      neighbors[nneigh] = loc
    end
  end

  nneigh
end
