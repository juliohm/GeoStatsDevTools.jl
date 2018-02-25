# ------------------------------------------------------------------
# Copyright (c) 2017, Júlio Hoffimann Mendes <juliohm@stanford.edu>
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    RandomPath(domain)

A random path on a spatial `domain`.
"""
struct RandomPath{D<:AbstractDomain} <: AbstractPath{D}
  domain::D
  permut::Vector{Int}

  function RandomPath{D}(domain, permut) where {D<:AbstractDomain}
    @assert length(permut) == npoints(domain) "incorrect dimension"
    new(domain, permut)
  end
end
RandomPath(domain) = RandomPath{typeof(domain)}(domain, randperm(npoints(domain)))
Base.start(p::RandomPath)       = Base.start(p.permut)
Base.next(p::RandomPath, state) = Base.next(p.permut, state)
Base.done(p::RandomPath, state) = Base.done(p.permut, state)
