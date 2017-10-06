## Copyright (c) 2017, Júlio Hoffimann Mendes <juliohm@stanford.edu>
##
## Permission to use, copy, modify, and/or distribute this software for any
## purpose with or without fee is hereby granted, provided that the above
## copyright notice and this permission notice appear in all copies.
##
## THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
## WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
## MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
## ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
## WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
## ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
## OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

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
    databounds = extrema(X, 2)

    for i in 1:N
      xmin, xmax = databounds[i]
      xmin < bottomleft[i] && (bottomleft[i] = xmin)
      xmax > upperright[i] && (upperright[i] = xmax)
    end
  end

  spacing = [(upperright[i] - bottomleft[i]) / dims[i] for i in 1:N]

  RegularGrid(dims, bottomleft, spacing)
end
