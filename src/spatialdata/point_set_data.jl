# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    PointSetData(data, coords)

Spatial `data` georeferenced with coordinate matrix `coords`.
The `data` argument is a dictionary mapping variable names to Julia
arrays with the actual data.

See also: [`PointSet`](@ref)
"""
struct PointSetData{T<:Real,N} <: AbstractSpatialData{T,N}
  data::Dict{Symbol,<:AbstractArray}
  coords # AbstractMatrix

  function PointSetData{T,N}(data, coords) where {N,T<:Real}
    lens = [length(array) for array in values(data)]
    @assert all(lens .== size(coords, 2)) "data and coords must have the same number of points"
    new(data, coords)
  end
end

PointSetData(data::Dict{Symbol,<:AbstractArray}, coords::AbstractMatrix{T}) where {T<:Real} =
  PointSetData{T,size(coords,1)}(data, coords)

coordinates(geodata::PointSetData{T,N}) where {N,T<:Real} = Dict(Symbol("x$i") => T for i=1:N)

variables(geodata::PointSetData) = Dict(var => eltype(array) for (var,array) in geodata.data)

npoints(geodata::PointSetData) = size(geodata.coords, 2)

function coordinates!(buff::AbstractVector{T}, geodata::PointSetData{T,N}, ind::Int) where {N,T<:Real}
  for i in 1:N
    @inbounds buff[i] = geodata.coords[i,ind]
  end
end

value(geodata::PointSetData, ind::Int, var::Symbol) = geodata.data[var][ind]

function Base.view(geodata::PointSetData{T,N}, inds::AbstractVector{Int}) where {N,T<:Real}
  data = Dict(var => view(array, inds) for (var,array) in geodata.data)
  coords = view(geodata.coords, :, inds)

  PointSetData(data, coords)
end

# ------------
# IO methods
# ------------
function Base.show(io::IO, geodata::PointSetData{T,N}) where {N,T<:Real}
  npts = size(geodata.coords, 2)
  print(io, "$npts PointSetData{$T,$N}")
end

function Base.show(io::IO, ::MIME"text/plain", geodata::PointSetData{T,N}) where {N,T<:Real}
  println(io, geodata)
  println(io, "  variables")
  varlines = ["    └─$var ($(eltype(array)))" for (var, array) in geodata.data]
  print(io, join(varlines, "\n"))
end
