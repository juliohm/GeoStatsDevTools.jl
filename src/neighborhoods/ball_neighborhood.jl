# ------------------------------------------------------------------
# Copyright (c) 2017, Júlio Hoffimann Mendes <juliohm@stanford.edu>
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    BallNeighborhood(domain, radius)

A ball neighborhood of a given `radius` on a spatial `domain`.
"""
struct BallNeighborhood{D<:AbstractDomain} <: AbstractNeighborhood{D}
  # input fields
  domain::D
  radius # we cannot use coordtype(D) here yet in Julia v0.6

  # state fields
  cube::CubeNeighborhood{D}

  function BallNeighborhood{D}(domain, radius) where D<:AbstractDomain
    @assert radius > 0 "radius must be positive"
    @assert typeof(radius) == coordtype(domain) "radius and domain coordinate type must match"

    # cube of same radius
    cube = CubeNeighborhood(domain, radius)

    new(domain, radius, cube)
  end
end

BallNeighborhood(domain::D, radius) where {D<:AbstractDomain} = BallNeighborhood{D}(domain, radius)

function (neigh::BallNeighborhood{<:RegularGrid})(location::Int)
  # retrieve domain
  ndomain = neigh.domain

  # get neighbors in cube of same radius
  cneighbors = neigh.cube(location)

  # coordinates of the center
  xₒ = coordinates(ndomain, location)

  # pre-allocate memory for neighbors coordinates
  x = MVector{ndims(ndomain),coordtype(ndomain)}()

  # discard neighbors outside of sphere
  neighbors = Vector{Int}()
  for neighbor in cneighbors
    coordinates!(x, ndomain, neighbor)

    # compute ||x-xₒ||^2
    sum² = zero(eltype(x))
    for i=1:ndims(ndomain)
      sum² += (x[i] - xₒ[i])^2
    end

    sum² ≤ neigh.radius^2 && push!(neighbors, neighbor)
  end

  neighbors
end

function (neigh::BallNeighborhood{<:PointCollection})(location::Int)
  # retrieve domain
  ndomain = neigh.domain

  # center in real coordinates
  xₒ = coordinates(ndomain, location)

  # pre-allocate memory for neighbors coordinates
  x = MVector{ndims(ndomain),coordtype(ndomain)}()

  neighbors = Vector{Int}()
  for loc in 1:npoints(ndomain)
    coordinates!(x, ndomain, loc)
    norm(x .- xₒ) ≤ neigh.radius && push!(neighbors, loc)
  end

  neighbors
end
