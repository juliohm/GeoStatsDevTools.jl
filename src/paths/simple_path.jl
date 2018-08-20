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

Base.iterate(p::SimplePath, state=1) = state > npoints(p.domain) ? nothing : (state, state + 1)
