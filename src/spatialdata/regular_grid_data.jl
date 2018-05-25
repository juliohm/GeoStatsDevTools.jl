# ------------------------------------------------------------------
# Copyright (c) 2018, Júlio Hoffimann Mendes <juliohm@stanford.edu>
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    RegularGridData(data, origin, spacing)

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
julia> RegularGridData(data, [0.,0.,0.], [1.,1.,1.])
```

Alternatively, one can omit `origin` and `spacing` for default
values of zeros and ones:

```julia
julia> RegularGridData{Float64}(data)
```
"""
struct RegularGridData{T<:Real,N} <: AbstractSpatialData
  data::Dict{Symbol,<:AbstractArray}
  origin::NTuple{N,T}
  spacing::NTuple{N,T}

  # state fields
  dims::Dims{N}

  function RegularGridData{T,N}(data, origin, spacing) where {N,T<:Real}
    sizes = [size(array) for array in values(data)]
    @assert length(unique(sizes)) == 1 "data dimensions must be the same for all variables"
    @assert length(sizes[1]) == N "inconsistent number of dimensions for given origin/spacing"
    @assert all(spacing .> 0) "spacing must be positive"
    new(data, origin, spacing, sizes[1])
  end
end

RegularGridData(data::Dict{Symbol,<:AbstractArray}, origin::Vector{T}, spacing::Vector{T}) where {T<:Real} =
  RegularGridData{T,length(origin)}(data, (origin...), (spacing...))

RegularGridData{T}(data::Dict{Symbol,<:AbstractArray{<:Any,N}}) where {N,T<:Real} =
  RegularGridData{T,N}(data, (zeros(T,N)...), (ones(T,N)...))

coordinates(geodata::RegularGridData{T,N}) where {T<:Real,N} = Dict(Symbol("x$i") => T for i=1:N)

variables(geodata::RegularGridData) = Dict(var => eltype(array) for (var,array) in geodata.data)

npoints(geodata::RegularGridData) = prod(geodata.dims)

function coordinates(geodata::RegularGridData{T,N}, ind::Int) where {N,T<:Real}
  intcoords = ind2sub(geodata.dims, ind)
  [geodata.origin[i] + (intcoords[i] - 1)*geodata.spacing[i] for i=1:N]
end

value(geodata::RegularGridData, ind::Int, var::Symbol) = geodata.data[var][ind]

function Base.view(geodata::RegularGridData{T,N}, inds::AbstractVector{Int}) where {N,T<:Real}
  # coordinate names
  coordnames = [Symbol("x$i") for i=1:N]

  # view the underlying data
  varcols = Dict(var => view(array, inds) for (var,array) in geodata.data)
  dfvars = DataFrame(varcols)

  # retrieve coordinates
  coords = Matrix{T}(length(inds), N)
  for ind in inds
    coords[ind,:] .= coordinates(geodata, ind)
  end
  dfcoords = DataFrame(coords, coordnames)

  # create full dataframe
  data = hcat(dfvars, dfcoords)

  GeoDataFrame(data, coordnames)
end

# ------------
# IO methods
# ------------
function Base.show(io::IO, geodata::RegularGridData{T,N}) where {N,T<:Real}
  dims = join(geodata.dims, "×")
  print(io, "$dims RegularGridData{$T,$N}")
end

function Base.show(io::IO, ::MIME"text/plain", geodata::RegularGridData{T,N}) where {N,T<:Real}
  println(io, geodata)
  println(io, "  origin:  ", geodata.origin)
  println(io, "  spacing: ", geodata.spacing)
  println(io, "  variables")
  for (var, array) in geodata.data
    println(io, "    └─$var ($(eltype(array)))")
  end
end
