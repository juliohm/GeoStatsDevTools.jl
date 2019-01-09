# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    AbstractNeighborSearcher

A method for searching neighbors in a spatial domain given a reference point.
"""
abstract type AbstractNeighborSearcher end

"""
    search!(neighbors, domain, location, searcher)

Update `neighbors` of `location` in the `domain` with `searcher`,
and return number of neighbors found.
"""
search!(neighbors::AbstractVector{Int}, domain::AbstractDomain{T,N}, location::Int,
        searcher::AbstractNeighborSearcher) where {T<:Real,N} =
  search!(neighbors, domain, location, searcher, trues(npoints(domain)))

"""
    search!(neighbors, domain, location, searcher, mask)

Update `neighbors` of `location` in the `domain` with `searcher` and `mask`,
and return number of neighbors found.
"""
search!(neighbors::AbstractVector{Int}, domain::AbstractDomain{T,N}, location::Int,
        searcher::AbstractNeighborSearcher, mask::AbstractVector{Bool}) where {T<:Real,N} =
  search!(neighbors, domain, coordinates(domain, location), searcher, mask)

"""
    search!(neighbors, domain, xₒ, searcher)

Update `neighbors` of coordinates `xₒ` in the `domain` with `searcher`,
and return number of neighbors found.
"""
search!(neighbors::AbstractVector{Int}, domain::AbstractDomain{T,N}, xₒ::AbstractVector{T},
        searcher::AbstractNeighborSearcher) where {T<:Real,N} =
  search!(neighbors, domain, xₒ, searcher, trues(npoints(domain)))

"""
    search!(neighbors, domain, xₒ, searcher, mask)

Update `neighbors` of coordinates `xₒ` in the `domain` with the `searcher` and `mask`, and
return number of neighbors found.
"""
search!(::AbstractVector{Int}, ::AbstractDomain{T,N}, ::AbstractVector{T},
        ::AbstractNeighborSearcher, ::AbstractVector{Bool}) where {T<:Real,N} = error("not implemented")

#------------------
# IMPLEMENTATIONS
#------------------
include("neighborsearch/nearest.jl")
include("neighborsearch/local.jl")
