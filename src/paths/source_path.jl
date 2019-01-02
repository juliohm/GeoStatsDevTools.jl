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

    # coordinate matrix for source points
    S = coordinates(domain, sources)

    # fit search tree
    kdtree = KDTree(S)

    # coordinate matrix for all other points
    others = setdiff(1:npoints(domain), sources)
    X = coordinates(domain, others)

    # compute distances to sources
    _, dists = knn(kdtree, X, length(sources), true)

    path = vcat(sources, view(others, sortperm(dists)))

    new(domain, sources, path)
  end
end

SourcePath(domain, sources) = SourcePath{typeof(domain)}(domain, sources)

Base.iterate(p::SourcePath, state=1) = state > npoints(p.domain) ? nothing : (p.path[state], state + 1)
