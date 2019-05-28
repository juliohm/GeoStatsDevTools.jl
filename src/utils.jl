# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    readgeotable(args; coordnames=[:x,:y,:z], kwargs)

Read data from disk using `CSV.read`, optionally specifying
the columns `coordnames` with spatial coordinates.

The arguments `args` and keyword arguments `kwargs` are
forwarded to the `CSV.read` function, please check their
documentation for more details.

This function returns a [`GeoDataFrame`](@ref) object.
"""
readgeotable(args...; coordnames=[:x,:y,:z], kwargs...) =
  GeoDataFrame(CSV.read(args...; kwargs...), coordnames)

"""
    boundgrid(object, dims)

Returns a `RegularGrid` of given `dims` covering all the
locations in spatial `object`.
"""
function boundgrid(object::AbstractSpatialObject{T,N}, dims::Dims{N}) where {N,T<:Real}
  start, finish = coordextrema(object)
  RegularGrid(tuple(start...), tuple(finish...), dims=dims)
end
