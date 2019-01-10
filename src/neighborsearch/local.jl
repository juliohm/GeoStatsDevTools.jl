# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    LocalNeighborSearcher(domain, K, neighborhood, path)

A search method that finds at most `K` neighbors in
`neighborhood` of `domain` with a search `path`.
"""
struct LocalNeighborSearcher{N<:AbstractNeighborhood,P,V<:AbstractVector} <: AbstractNeighborSearcher
  neigh::N
  K::Int
  path::P
  offset::Int
  buff::V
end

function LocalNeighborSearcher(domain::AbstractDomain, K::Int,
                               neigh::AbstractNeighborhood,
                               path::AbstractPath, offset::Int)
  @assert 1 ≤ K ≤ npoints(domain) "number of neighbors must be in interval [1, npoints(domain)]"

  # pre-allocate memory for coordinates
  buff = MVector{ndims(domain),coordtype(domain)}(undef)

  LocalNeighborSearcher{typeof(neigh),typeof(path),typeof(buff)}(neigh, K, path, offset, buff)
end

function search!(neighbors::AbstractVector{Int},
                 domain::AbstractDomain{T,N}, xₒ::AbstractVector{T},
                 searcher::LocalNeighborSearcher,
                 mask::AbstractVector{Bool}) where {T<:Real,N}
  x = searcher.buff
  path = ShiftedPath(searcher.path, searcher.offset)

  nneigh = 0
  for loc in path
    if mask[loc]
      coordinates!(x, domain, loc)
      if isneighbor(searcher.neigh, xₒ, x)
        nneigh += 1
        neighbors[nneigh] = loc
      end
    end
    nneigh == searcher.K && break
  end

  nneigh
end
