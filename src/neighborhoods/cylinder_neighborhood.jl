# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    CylinderNeighborhood(domain, radius, height)

A cylinder neighborhood with a given `radius` and `height` on a spatial `domain`.

### Notes

The `height` parameter is only half of the actual cylinder height.
"""
struct CylinderNeighborhood{D<:AbstractDomain} <: AbstractNeighborhood{D}
  domain::D
  radius
  height

  function CylinderNeighborhood{D}(domain, radius, height) where {D<:AbstractDomain}
    @assert radius > 0 "cylinder radius must be positive"
    @assert height > 0 "cylinder height must be positive"
    @assert typeof(radius) == coordtype(domain) "radius type must match coordinate type"
    @assert typeof(height) == coordtype(domain) "height type must match coordinate type"

    new(domain, radius, height)
  end
end

CylinderNeighborhood(domain::D, radius, height) where {D<:AbstractDomain} =
  CylinderNeighborhood{D}(domain, radius, height)

function (neigh::CylinderNeighborhood)(location::Int)
  # retrieve domain
  ndomain = neigh.domain

  # neighborhood specs
  r = neigh.radius
  h = neigh.height

  # center in real coordinates
  xₒ = coordinates(ndomain, location)

  # pre-allocate memory for neighbors coordinates
  x = MVector{ndims(ndomain),coordtype(ndomain)}(undef)

  neighbors = Vector{Int}()
  for loc in 1:npoints(ndomain)
    coordinates!(x, ndomain, loc)

    if abs(x[end] - xₒ[end]) ≤ h && norm(x[1:end-1] .- xₒ[1:end-1]) ≤ r
      push!(neighbors, loc)
    end
  end

  neighbors
end
