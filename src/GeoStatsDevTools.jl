# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

module GeoStatsDevTools

using Random
using Distances
using Distributions
using LinearAlgebra
using DataFrames
using StaticArrays
using NearestNeighbors
using RecipesBase
using CSV

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
include("plotrecipes/solutions/estimation_point_set.jl")
include("plotrecipes/solutions/simulation_point_set.jl")
include("plotrecipes/solutions/estimation_regular_grid.jl")
include("plotrecipes/solutions/simulation_regular_grid.jl")

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
  PlanePartitioner,
  DirectionPartitioner,
  SpatialPredicatePartitioner,
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
