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
    Base.length(path)

Return the length of a `path`.
"""
Base.length(p::AbstractPath) = npoints(p.domain)

"""
    Base.eltype(::Type{P})

Return element type of path type `P`.
"""
Base.eltype(::Type{P}) where {P<:AbstractPath} = Int

#------------------
# IMPLEMENTATIONS
#------------------
include("paths/simple_path.jl")
include("paths/random_path.jl")
