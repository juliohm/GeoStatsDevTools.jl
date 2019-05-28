# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    boundgrid(spatialdata, dims)

Returns a `RegularGrid` of given `dims` covering all the
locations in `spatialdata`.
"""
function boundgrid(spatialdata::AbstractSpatialData{T,N}, dims::Dims{N}) where {N,T<:Real}
  @assert all(dims .> 0) "dimensions must be positive"

  start  = fill(typemax(T), N)
  finish = fill(typemin(T), N)

  for ind in 1:npoints(spatialdata)
    x = coordinates(spatialdata, ind)
    for d in 1:N
      x[d] < start[d] && (start[d] = x[d])
      x[d] > finish[d] && (finish[d] = x[d])
    end
  end

  RegularGrid(tuple(start...), tuple(finish...), dims=dims)
end
