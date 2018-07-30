# ------------------------------------------------------------------
# Copyright (c) 2017, Júlio Hoffimann Mendes <juliohm@stanford.edu>
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    CubeNeighborhood(domain, radius)

A cube (∞-norm ball) neighborhood with a given `radius` on a spatial `domain`.
"""
struct CubeNeighborhood{D<:AbstractDomain} <: AbstractNeighborhood{D}
  domain::D
  radius # we cannot use coordtype(D) here yet in Julia v0.6

  function CubeNeighborhood{D}(domain, radius) where {D<:AbstractDomain}
    @assert radius > 0 "neighborhood radius must be positive"
    @assert typeof(radius) == coordtype(domain) "radius and domain coordinate type must match"

    new(domain, radius)
  end
end

CubeNeighborhood(domain::D, radius) where {D<:AbstractDomain} = CubeNeighborhood{D}(domain, radius)

function (neigh::CubeNeighborhood{<:RegularGrid})(location::Int)
  # grid size
  sz = size(neigh.domain)
  sp = spacing(neigh.domain)
  nd = ndims(neigh.domain)

  # cube center in multi-dimensional index format
  center = CartesianIndices(sz)[location]

  # number of units to reach the sides of the cube
  units = ntuple(i -> @inbounds(return floor(Int, neigh.radius / sp[i])), nd)

  # cube spans from top left to bottom right
  topleft     = ntuple(i -> @inbounds(return max(center[i] - units[i], 1)), nd)
  bottomright = ntuple(i -> @inbounds(return min(center[i] + units[i], sz[i])), nd)

  # number of points in the cube
  ncubepoints = prod(bottomright[i] - topleft[i] + 1 for i=1:nd)

  # pre-allocate memory
  neighbors = Vector{Int}(undef, ncubepoints)

  if nd == 1
    n = 1
    for i=topleft[1]:bottomright[1]
      @inbounds neighbors[n] = i
      n += 1
    end
  elseif nd == 2
    n = 1
    nx = sz[1]
    for j=topleft[2]:bottomright[2], i=topleft[1]:bottomright[1]
      @inbounds neighbors[n] = i + nx*(j-1)
      n += 1
    end
  elseif nd == 3
    n = 1
    nx = sz[1]
    nxny = sz[1]*sz[2]
    for k=topleft[3]:bottomright[3], j=topleft[2]:bottomright[2], i=topleft[1]:bottomright[1]
      @inbounds neighbors[n] = i + nx*(j-1) + nxny*(k-1)
      n += 1
    end
  else # higher dimensions
    irange = CartesianIndices(ntuple(i -> topleft[i]:bottomright[i], nd))

    for (n,idx) in enumerate(irange)
      @inbounds neighbors[n] = LinearIndices(sz)[idx.I...]
    end
  end

  neighbors
end

function (neigh::CubeNeighborhood{<:PointSet})(location::Int)
  # retrieve domain
  ndomain = neigh.domain

  # center in real coordinates
  xₒ = coordinates(ndomain, location)

  # pre-allocate memory for neighbors coordinates
  x = MVector{ndims(ndomain),coordtype(ndomain)}()

  neighbors = Vector{Int}()
  for loc in 1:npoints(ndomain)
    coordinates!(x, ndomain, loc)
    norm(x .- xₒ, Inf) ≤ neigh.radius && push!(neighbors, loc)
  end

  neighbors
end
