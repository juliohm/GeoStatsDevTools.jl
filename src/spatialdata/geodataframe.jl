# ------------------------------------------------------------------
# Copyright (c) 2017, Júlio Hoffimann Mendes <juliohm@stanford.edu>
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    GeoDataFrame(data, coordnames)

A dataframe object `data` with additional metadata for tracking
the columns `coordnames` that represent spatial coordinates.

## Examples

If the data was already loaded in a normal DataFrame `data`,
and there exists columns named `x`, `y` and `z`, wrap the
data and specify the column names:

```julia
julia> GeoDataFrame(data, [:x,:y,:z])
```

Alternatively, load the data directly into a `GeoDataFrame` object
by using the method [`readgeotable`](@ref).

### Notes

This type is a lightweight wrapper over Julia's DataFrame types.
No additional storage is required other than a vector of symbols
with the columns names representing spatial coordinates.

"""
struct GeoDataFrame{DF<:AbstractDataFrame} <: AbstractSpatialData
  data::DF
  coordnames::Vector{Symbol}

  function GeoDataFrame{DF}(data, coordnames) where {DF<:AbstractDataFrame}
    @assert coordnames ⊆ names(data) "coordnames must contain valid column names"
    new(data, coordnames)
  end
end

GeoDataFrame(data, coordnames) = GeoDataFrame{typeof(data)}(data, coordnames)

function coordinates(geodata::GeoDataFrame)
  rawdata = geodata.data
  cnames = geodata.coordnames
  ctypes = Missings.T.(eltypes(rawdata[cnames]))

  Dict(var => T for (var,T) in zip(cnames,ctypes))
end

function variables(geodata::GeoDataFrame)
  rawdata = geodata.data
  cnames = geodata.coordnames
  vnames = [var for var in names(rawdata) if var ∉ cnames]
  vtypes = Missings.T.(eltypes(rawdata[vnames]))

  Dict(var => T for (var,T) in zip(vnames,vtypes))
end

npoints(geodata::GeoDataFrame) = nrow(geodata.data)

function coordinates(geodata::GeoDataFrame, ind::Int)
  rawdata = geodata.data
  cnames = geodata.coordnames

  [rawdata[ind,cname] for cname in cnames]
end

value(geodata::GeoDataFrame, ind::Int, var::Symbol) = geodata.data[ind,var]

Base.view(geodata::GeoDataFrame, inds::AbstractVector{Int}) =
  GeoDataFrame(view(geodata.data, inds), geodata.coordnames)

# ------------
# IO methods
# ------------
function Base.show(io::IO, geodata::GeoDataFrame)
  dims = join(size(geodata.data), "×")
  cnames = join(geodata.coordnames, ", ", " and ")
  print(io, "$dims GeoDataFrame ($cnames)")
end

function Base.show(io::IO, ::MIME"text/plain", geodata::GeoDataFrame)
  println(io, geodata)
  show(io, geodata.data, allcols=true, rowlabel=:Row, summary=false)
end

function Base.show(io::IO, ::MIME"text/html", geodata::GeoDataFrame)
  println(io, geodata)
  show(io, MIME"text/html"(), geodata.data)
end
