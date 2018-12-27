# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    SourcePath(domain, sources)

A path over a spatial `domain` that starts at given source
locations `sources` and progresses outwards.
"""
struct SourcePath{D<:AbstractDomain} <: AbstractPath{D}
  domain::D
  sources::Vector{Int}

  # state fields
  path::Vector{Int}

  function SourcePath{D}(domain, sources) where {D<:AbstractDomain}
    @assert all(1 .≤ sources .≤ npoints(domain)) "sources must be valid locations"
    @assert length(unique(sources)) == length(sources) "non-unique sources"
    @assert length(sources) ≤ npoints(domain) "more sources than points in domain"

    # pre-compute path from sources
    path = path_from_sources(domain, sources)

    new(domain, sources, path)
  end
end

SourcePath(domain, sources) = SourcePath{typeof(domain)}(domain, sources)

Base.iterate(p::SourcePath, state=1) = state > npoints(p.domain) ? nothing : (p.path[state], state + 1)

function path_from_sources(domain::RegularGrid, sources::AbstractVector{Int})
  # retrieve domain specs
  sz = size(domain)
  nd = ndims(domain)
  npts = npoints(domain)

  # breadth-first search
  frontier = copy(sources)
  opened = Set{Int}()

  # pre-allocate memory for result
  path = Vector{Int}(undef, npts)

  counter = 0
  while !isempty(frontier)
    # pop first location
    location = frontier[1]
    deleteat!(frontier, 1)

    # add location to path and opened set
    counter += 1
    path[counter] = location
    push!(opened, location)

    # lookup nearest neighbors
    center = CartesianIndices(sz)[location]
    start  = @. max(center.I - 1, 1)
    finish = @. min(center.I + 1, sz)

    crange = CartesianIndices(ntuple(i -> start[i]:finish[i], nd))

    for loc in LinearIndices(sz)[crange]
      if loc ∉ frontier && loc ∉ opened
        push!(frontier, loc)
      end
    end
  end

  path
end
