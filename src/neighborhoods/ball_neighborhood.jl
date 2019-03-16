# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    BallNeighborhood(domain, radius)

A ball neighborhood of a given `radius` on a spatial `domain`.
"""
struct BallNeighborhood{D<:AbstractDomain,M<:Metric} <: AbstractNeighborhood{D}
  # input fields
  domain::D
  radius
  metric::M

  # state fields
  kdtree::KDTree

  function BallNeighborhood{D,M}(domain, radius, metric) where {D<:AbstractDomain,M<:Metric}
    @assert radius > 0 "radius must be positive"
    @assert typeof(radius) == coordtype(domain) "radius and domain coordinate type must match"

    # fit search tree
    kdtree = KDTree(coordinates(domain), metric)

    new(domain, radius, metric, kdtree)
  end
end

BallNeighborhood(domain::D, radius, metric::M=Euclidean()) where {D<:AbstractDomain,M<:Metric} =
  BallNeighborhood{D,M}(domain, radius, metric)

function (neigh::BallNeighborhood)(location::Int)
  xₒ = coordinates(neigh.domain, location)
  inrange(neigh.kdtree, xₒ, neigh.radius, true)
end

function isneighbor(neigh::BallNeighborhood, xₒ::AbstractVector, x::AbstractVector)
  evaluate(neigh.metric, xₒ, x) ≤ neigh.radius
end

# ------------
# IO methods
# ------------
function Base.show(io::IO, neigh::BallNeighborhood)
  r = neigh.radius
  print(io, "BallNeighborhood($r)")
end

function Base.show(io::IO, ::MIME"text/plain", neigh::BallNeighborhood)
  println(io, "BallNeighborhood")
  println(io, "  radius: ", neigh.radius)
  println(io, "  metric: ", neigh.metric)
end
