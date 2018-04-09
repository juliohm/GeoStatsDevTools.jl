# ------------------------------------------------------------------
# Copyright (c) 2018, Júlio Hoffimann Mendes <juliohm@stanford.edu>
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    GeoGridData(data, origin, spacing)

Regularly spaced `data` georeferenced with `origin` and `spacing`.
The `data` argument is a dictionary mapping variable names to Julia
arrays with the actual data.

`NaN` or `missing` values in the Julia arrays are interpreted as
non-valid. They can be used to mask the variables on the grid.

## Examples

Given `poro` and `perm` two 2-dimensional Julia arrays containing
values of porosity and permeability, the following code can be used
to georeference the data:

```julia
julia> data = Dict(:porosity => poro, :permeability => perm)
julia> GeoGridData(data, [0.,0.,0.], [1.,1.,1.])
```

Alternatively, one can omit `origin` and `spacing` for default
values of zeros and ones:

```julia
julia> GeoGridData{Float64}(data)
```
"""
struct GeoGridData{T<:Real,N} <: AbstractSpatialData
  data::Dict{Symbol,<:AbstractArray}
  origin::NTuple{N,T}
  spacing::NTuple{N,T}

  # state fields
  dims::Dims{N}

  function GeoGridData{T,N}(data, origin, spacing) where {N,T<:Real}
    sizes = [size(array) for array in values(data)]
    @assert length(unique(sizes)) == 1 "data dimensions must be the same for all variables"
    @assert length(sizes[1]) == N "inconsistent number of dimensions for given origin/spacing"
    @assert all(spacing .> 0) "spacing must be positive"
    new(data, origin, spacing, sizes[1])
  end
end

GeoGridData(data::Dict{Symbol,<:AbstractArray}, origin::Vector{T}, spacing::Vector{T}) where {T<:Real} =
  GeoGridData{T,length(origin)}(data, (origin...), (spacing...))

GeoGridData{T}(data::Dict{Symbol,<:AbstractArray{<:Any,N}}) where {N,T<:Real} =
  GeoGridData{T,N}(data, (zeros(T,N)...), (ones(T,N)...))

coordinates(geodata::GeoGridData{T,N}) where {T<:Real,N} = Dict(Symbol("x$i") => T for i=1:N)

variables(geodata::GeoGridData) = Dict(var => eltype(array) for (var,array) in geodata.data)

npoints(geodata::GeoGridData) = prod(geodata.dims)

function coordinates(geodata::GeoGridData{T,N}, idx::Int) where {N,T<:Real}
  intcoords = ind2sub(geodata.dims, idx)
  [geodata.origin[i] + (intcoords[i] - 1)*geodata.spacing[i] for i=1:N]
end

value(geodata::GeoGridData, idx::Int, var::Symbol) = geodata.data[var][idx]

function Base.view(geodata::GeoGridData{T,N}, inds::AbstractVector{Int}) where {N,T<:Real}
  # find top left and bottom right of view
  imin = fill(typemax(Int), N)
  imax = fill(typemin(Int), N)
  for ind in inds
    intcoords = ind2sub(geodata.dims, ind)
    for i=1:N
      if intcoords[i] < imin[i]
        imin[i] = intcoords[i]
      end
      if intcoords[i] > imax[i]
        imax[i] = intcoords[i]
      end
    end
  end

  # view the underlying data
  data = Dict((var, view(array, [imin[i]:imax[i] for i=1:N]...)) for (var,array) in geodata.data)

  # new origin and same spacing
  origin  = [geodata.origin[i] + (imin[i] - 1)*geodata.spacing[i] for i=1:N]
  spacing = [geodata.spacing...]

  GeoGridData(data, origin, spacing)
end

# ------------
# IO methods
# ------------
function Base.show(io::IO, geodata::GeoGridData{T,N}) where {N,T<:Real}
  dims = join(geodata.dims, "×")
  print(io, "$dims GeoGridData{$T,$N}")
end

function Base.show(io::IO, ::MIME"text/plain", geodata::GeoGridData{T,N}) where {N,T<:Real}
  println(io, geodata)
  println(io, "  origin:  ", geodata.origin)
  println(io, "  spacing: ", geodata.spacing)
  println(io, "  variables")
  for (var, array) in geodata.data
    println(io, "    └─$var ($(eltype(array)))")
  end
end
