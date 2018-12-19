# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    StructuredGridData(data, X, Y, Z, ...)

Data spatially distributed on a structured grid where points are
georeferenced by coordinates `X`, `Y`, `Z`, ...

The `data` argument is a dictionary mapping variable names to Julia
arrays with the actual data.

## Examples

A very popular structured grid data format is NetCDF. Given 2D arrays
`LAT` and `LON` with coordinates and arrays with climate data `precipitation`,
`temperature`, the following code can be used to construct a structured grid:

```julia
julia> data = Dict(:precipitation => precipitation, :temperature => temperature)
julia> StructuredGridData(data, LAT, LON)
```
"""
struct StructuredGridData{T<:Real,N} <: AbstractSpatialData{T,N}
  data::Dict{Symbol,<:AbstractArray}
  coords::Matrix{T}

  # state fields
  dims::Dims{N}

  function StructuredGridData{T,N}(data, coords) where {N,T<:Real}
    sizes = [size(array) for array in values(data)]
    @assert length(unique(sizes)) == 1 "data dimensions must be the same for all variables"
    @assert prod(sizes[1]) == size(coords, 2) "data and coordinates arrays must have the same number of indices"

    new(data, coords, sizes[1])
  end
end

function StructuredGridData(data::Dict{Symbol,<:AbstractArray},
                            coordarrays::Vararg{<:AbstractArray{T},N}) where {N,T<:Real}
  sizes = [size(array) for array in coordarrays]
  @assert length(unique(sizes)) == 1 "coordinates arrays must have the same dimensions"

  coords = Matrix{T}(N, prod(sizes[1]))
  for (i, array) in enumerate(coordarrays)
    coords[i,:] .= array[:]
  end

  StructuredGridData{T,N}(data, coords)
end

coordinates(geodata::StructuredGridData{T,N}) where {N,T<:Real} = Dict(Symbol("x$i") => T for i=1:N)

variables(geodata::StructuredGridData) = Dict(var => eltype(array) for (var,array) in geodata.data)

npoints(geodata::StructuredGridData) = size(geodata.coords, 2)

function coordinates!(buff::AbstractVector{T}, geodata::StructuredGridData{T,N}, ind::Int) where {N,T<:Real}
  for i in 1:N
    @inbounds buff[i] = geodata.coords[i,ind]
  end
end

value(geodata::StructuredGridData, ind::Int, var::Symbol) = geodata.data[var][ind]

function Base.view(geodata::StructuredGridData{T,N}, inds::AbstractVector{Int}) where {N,T<:Real}
  data = Dict(var => view(array, inds) for (var,array) in geodata.data)
  coords = view(geodata.coords, :, inds)

  PointSetData(data, coords)
end

# ------------
# IO methods
# ------------
function Base.show(io::IO, geodata::StructuredGridData{T,N}) where {N,T<:Real}
  dims = join(geodata.dims, "×")
  print(io, "$dims StructuredGridData{$T,$N}")
end

function Base.show(io::IO, ::MIME"text/plain", geodata::StructuredGridData{T,N}) where {N,T<:Real}
  println(io, geodata)
  println(io, "  variables")
  varlines = ["    └─$var ($(eltype(array)))" for (var, array) in geodata.data]
  print(io, join(varlines, "\n"))
end
