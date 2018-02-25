# ------------------------------------------------------------------
# Copyright (c) 2017, Júlio Hoffimann Mendes <juliohm@stanford.edu>
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    AbstractPath

A path on a spatial domain of type `D`.
"""
abstract type AbstractPath{D<:AbstractDomain} end

"""
    Base.start(path)

Return the start of the `path`.
"""
Base.start(::AbstractPath) = error("not implemented")

"""
    Base.next(path, state)

Advance in the `path` from current `state`.
"""
Base.next(::AbstractPath, state) = error("not implemented")

"""
    Base.done(path, state)

Return true if `state` is the end of the `path`.
"""
Base.done(::AbstractPath, state) = error("not implemented")

"""
    Base.length(path)

Return the length of a `path`.
"""
Base.length(p::AbstractPath) = npoints(p.domain)

#------------------
# IMPLEMENTATIONS
#------------------
include("paths/simple_path.jl")
include("paths/random_path.jl")
