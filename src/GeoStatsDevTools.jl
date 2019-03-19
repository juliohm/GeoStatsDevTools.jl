# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

module GeoStatsDevTools

using Reexport
using Random
using Distances
using LinearAlgebra
using DataFrames
using StaticArrays
using NearestNeighbors
using RecipesBase
using CSV

@reexport using Distributions

using GeoStatsBase

# implement methods for spatial data
import GeoStatsBase: coordnames, coordinates!, variables, npoints, value

# implement methods for spatial domain
import GeoStatsBase: coordinates!, npoints, nearestlocation

# implement methods for solutions
import GeoStatsBase: digest

# implement methods for spatial statistics
import Statistics: mean, var, quantile

# spatial data
include("spatialdata/geodataframe.jl")
include("spatialdata/point_set_data.jl")
include("spatialdata/regular_grid_data.jl")
include("spatialdata/structured_grid_data.jl")

# spatial domain
include("domains/point_set.jl")
include("domains/regular_grid.jl")

# data partitions
include("partitions.jl")

# domain navigation
include("paths.jl")
include("neighborhoods.jl")

# neighborhood search
include("neighborsearch.jl")

# distances and distributions
include("distances.jl")
include("distributions.jl")

# utilities
include("utils.jl")

# digest solutions
include("solutions/estimation_solution.jl")
include("solutions/simulation_solution.jl")

# spatial statistics
include("statistics.jl")

# plot recipes
include("plotrecipes/spatialdata.jl")
include("plotrecipes/domains/point_set.jl")
include("plotrecipes/domains/regular_grid.jl")
include("plotrecipes/domains/abstract_domain.jl")
include("plotrecipes/partitions.jl")
include("plotrecipes/solutions/estimation.jl")
include("plotrecipes/solutions/simulation.jl")
include("plotrecipes/statistics.jl")

export
  # spatial data
  GeoDataFrame,
  PointSetData,
  RegularGridData,
  StructuredGridData,

  # domains
  PointSet,
  RegularGrid,
  origin,
  spacing,

  # partitions
  SpatialPartition,
  UniformPartitioner,
  BallPartitioner,
  PlanePartitioner,
  DirectionPartitioner,
  FunctionPartitioner,
  ProductPartitioner,
  HierarchicalPartitioner,
  partition,
  subsets,

  # paths
  SimplePath,
  RandomPath,
  SourcePath,
  ShiftedPath,

  # neighborhoods
  BallNeighborhood,
  CylinderNeighborhood,
  isneighbor,

  # neighborhood search
  NearestNeighborSearcher,
  LocalNeighborSearcher,
  search!,

  # distances
  Ellipsoidal,
  evaluate,

  # distributions
  EmpiricalDistribution,
  transform!,
  quantile,
  cdf,

  # utilities
  readgeotable,
  boundgrid,

  # statistics
  mean,
  var,
  quantile

end
