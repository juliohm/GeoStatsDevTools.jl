# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    AbstractNeighborhood{D}

A neighborhood on a spatial domain of type `D`.
"""
abstract type AbstractNeighborhood{D<:AbstractDomain} end

# Neighborhoods are functor objects that can be evaluated
# at a given location:
#
# julia> neighborhood(location)
#
# The operator () returns the neighbors (as integers) and
# is implemented differently depending on the domain type.

#------------------
# IMPLEMENTATIONS
#------------------
include("neighborhoods/ball_neighborhood.jl")
include("neighborhoods/cylinder_neighborhood.jl")
