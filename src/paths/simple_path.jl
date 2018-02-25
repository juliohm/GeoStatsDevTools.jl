# ------------------------------------------------------------------
# Copyright (c) 2017, Júlio Hoffimann Mendes <juliohm@stanford.edu>
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    SimplePath(domain)

A simple (or default) path on a spatial `domain`.
"""
struct SimplePath{D<:AbstractDomain} <: AbstractPath{D}
  domain::D
end
Base.start(p::SimplePath)       = 1
Base.next(p::SimplePath, state) = state, state + 1
Base.done(p::SimplePath, state) = state == npoints(p.domain) + 1
