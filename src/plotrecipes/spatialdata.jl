# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

@recipe function f(spatialdata::AbstractSpatialData; variables=nothing)
  # retrieve underlying domain
  sdomain = extract_domain(spatialdata)

  # valid variables
  validvars = sort(collect(keys(GeoStatsBase.variables(spatialdata))))

  # plot all variables by default
  variables == nothing && (variables = validvars)
  @assert variables ⊆ validvars "invalid variable name"

  for (i, var) in enumerate(variables)
    # retrieve valid values
    vals = map(1:npoints(spatialdata)) do ind
      if isvalid(spatialdata, ind, var)
        value(spatialdata, ind, var)
      else
        NaN
      end
    end
    @series begin
      subplot := i
      title --> string(var)
      legend --> false
      sdomain, vals
    end
  end
end

# extract the underlying domain of a given spatial data type
extract_domain(spatialdata::AbstractSpatialData) = PointSet(coordinates(spatialdata))
extract_domain(spatialdata::RegularGridData) =
  RegularGrid(size(spatialdata), origin(spatialdata), spacing(spatialdata))
