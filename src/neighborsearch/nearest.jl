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
  locations::Vector{Int}
end

function NearestNeighborSearcher(domain::AbstractDomain, K::Int,
                                 metric::Metric, locations::AbstractVector{Int})
  @assert 1 ≤ K ≤ length(locations) "number of neighbors must be smaller than number of data locations"
  @assert length(locations) ≤ npoints(domain) "number of data locations must be smaller than number of points"
  kdtree = KDTree(coordinates(domain, locations), metric)
  NearestNeighborSearcher{typeof(kdtree)}(kdtree, K, locations)
end

function search!(neighbors::AbstractVector{Int},
                 xₒ::AbstractVector{T},
                 searcher::NearestNeighborSearcher,
                 mask::AbstractVector{Bool}) where {T<:Real,N}
  inds, _ = knn(searcher.kdtree, xₒ, searcher.K, true)
  path = view(searcher.locations, inds)

  nneigh = 0
  @inbounds for loc in path
    if mask[loc]
      nneigh += 1
      neighbors[nneigh] = loc
    end
  end

  nneigh
end
