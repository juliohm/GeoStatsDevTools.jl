# ------------------------------------------------------------------
# Copyright (c) 2017, Júlio Hoffimann Mendes <juliohm@stanford.edu>
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    PointCollection(coords)

A collection of points with coordinate matrix `coords`.
The number of rows is the dimensionality of the domain
whereas the number of columns is the number of points.
"""
struct PointCollection{T<:Real,N} <: AbstractDomain{T,N}
  coords::Matrix{T}

  function PointCollection{T,N}(coords) where {N,T<:Real}
    @assert !isempty(coords) "coordinates must be non-empty"
    new(coords)
  end
end

PointCollection(coords::AbstractMatrix{T}) where {T<:Real} =
  PointCollection{T,size(coords,1)}(coords)

npoints(pc::PointCollection) = size(pc.coords, 2)

function coordinates!(buff::AbstractVector{T}, pc::PointCollection{T,N},
                      location::Int) where {N,T<:Real}
  for i in 1:N
    @inbounds buff[i] = pc.coords[i,location]
  end
end

# ------------
# IO methods
# ------------
function Base.show(io::IO, pc::PointCollection{T,N}) where {N,T<:Real}
  dims = size(pc.coords, 1)
  npts = size(pc.coords, 2)
  print(io, "$dims×$npts PointCollection{$T,$N}")
end

function Base.show(io::IO, ::MIME"text/plain", pc::PointCollection{T,N}) where {N,T<:Real}
  println(io, pc)
  Base.showarray(io, pc.coords, false, header=false)
end
