# ------------------------------------------------------------------
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
  # grid specs
  sz = size(neigh.domain)
  sp = spacing(neigh.domain)
  nd = ndims(neigh.domain)

  # cube center in Cartesian index format
  center = CartesianIndices(sz)[location]

  # number of units to reach the sides of the cube
  units  = @. floor(Int, neigh.radius / sp)

  # cube spans from top left to bottom right
  start  = @. max(center.I - units, 1)
  finish = @. min(center.I + units, sz)

  # number of points in the cube
  npoints = prod(@. finish - start + 1)

  # pre-allocate memory
  neighbors = Vector{Int}(undef, npoints)

  if nd == 1
    n = 1
    for i=start[1]:finish[1]
      @inbounds neighbors[n] = i
      n += 1
    end
  elseif nd == 2
    n = 1
    nx = sz[1]
    for j=start[2]:finish[2], i=start[1]:finish[1]
      @inbounds neighbors[n] = i + nx*(j-1)
      n += 1
    end
  elseif nd == 3
    n = 1
    nx = sz[1]
    nxny = sz[1]*sz[2]
    for k=start[3]:finish[3], j=start[2]:finish[2], i=start[1]:finish[1]
      @inbounds neighbors[n] = i + nx*(j-1) + nxny*(k-1)
      n += 1
    end
  else # higher dimensions
    irange = CartesianIndices(ntuple(i -> start[i]:finish[i], nd))

    for (n, ind) in enumerate(irange)
      @inbounds neighbors[n] = LinearIndices(sz)[ind]
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
  x = MVector{ndims(ndomain),coordtype(ndomain)}(undef)

  neighbors = Vector{Int}()
  for loc in 1:npoints(ndomain)
    coordinates!(x, ndomain, loc)
    norm(x .- xₒ, Inf) ≤ neigh.radius && push!(neighbors, loc)
  end

  neighbors
end
