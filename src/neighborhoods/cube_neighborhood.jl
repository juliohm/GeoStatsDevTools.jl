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
  nd = ndims(neigh.domain)

  # cube center in multi-dimensional index format
  center = ind2sub(sz, location)

  # number of units to reach the sides of the cube
  units = [floor(Int, neigh.radius / sp) for sp in spacing(neigh.domain)]

  # cube spans from top left to bottom right
  topleft     = [max(center[i] - units[i],     1) for i=1:nd]
  bottomright = [min(center[i] + units[i], sz[i]) for i=1:nd]

  # number of points in the cube
  ncubepoints = prod(bottomright[i] - topleft[i] + 1 for i=1:nd)

  # pre-allocate memory
  neighbors = Vector{Int}(ncubepoints)

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
    istart = CartesianIndex(tuple(topleft...))
    iend   = CartesianIndex(tuple(bottomright...))
    irange = CartesianRange(istart, iend)

    for (n,idx) in enumerate(irange)
      @inbounds neighbors[n] = sub2ind(sz, idx.I...)
    end
  end

  neighbors
end

function (neigh::CubeNeighborhood{<:PointCollection})(location::Int)
  # retrieve domain
  ndomain = neigh.domain

  # center in real coordinates
  xₒ = coordinates(ndomain, location)

  neighbors = Int[]
  for loc in 1:npoints(ndomain)
    x = coordinates(ndomain, loc)
    norm(x .- xₒ, Inf) ≤ neigh.radius && push!(neighbors, loc)
  end

  neighbors
end
