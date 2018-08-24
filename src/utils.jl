# ------------------------------------------------------------------
# Copyright (c) 2017, Júlio Hoffimann Mendes <juliohm@stanford.edu>
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    bounding_grid(spatialdata, dimensions)

Returns a `RegularGrid` of given `dimensions` covering all the
locations in `spatialdata`.
"""
function bounding_grid(spatialdata::AbstractSpatialData, dims::Vector)
  # retrieve data coordinates
  datacoords = coordinates(spatialdata)
  N = length(datacoords)

  @assert length(dims) == N "dimensions must match number of coordinates in data"
  @assert all(dims .> 0) "dimensions must be positive"

  # determine coordinate type
  T = promote_type([T for (var,T) in datacoords]...)

  bottomleft = fill(typemax(T), N)
  upperright = fill(typemin(T), N)

  for (var,V) in variables(spatialdata)
    X, z = valid(spatialdata, var)
    databounds = extrema(X, dims=2)

    for i in 1:N
      xmin, xmax = databounds[i]
      xmin < bottomleft[i] && (bottomleft[i] = xmin)
      xmax > upperright[i] && (upperright[i] = xmax)
    end
  end

  spacing = [(upperright[i] - bottomleft[i]) / dims[i] for i in 1:N]

  RegularGrid(dims, bottomleft, spacing)
end
