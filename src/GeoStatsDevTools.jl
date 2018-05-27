# ------------------------------------------------------------------
# Copyright (c) 2017, Júlio Hoffimann Mendes <juliohm@stanford.edu>
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

__precompile__()

module GeoStatsDevTools

using Distances
using Distributions
using DataFrames
using StaticArrays
using CSV
using RecipesBase

# won't be neeeded in Julia v0.7
using Parameters

importall GeoStatsBase

# spatial data
include("spatialdata/geodataframe.jl")
include("spatialdata/regular_grid_data.jl")

# domains
include("domains/point_set.jl")
include("domains/regular_grid.jl")

# domain navigation
include("paths.jl")
include("neighborhoods.jl")

# distances and distributions
include("distances.jl")
include("distributions.jl")

# helper functions
include("utils.jl")

# helper macros
include("macros.jl")

# digest solutions
include("solutions/estimation_solution.jl")
include("solutions/simulation_solution.jl")

# plot recipes
include("plotrecipes/hscatter.jl")
include("plotrecipes/solutions/estimation_point_set.jl")
include("plotrecipes/solutions/simulation_point_set.jl")
include("plotrecipes/solutions/estimation_regular_grid.jl")
include("plotrecipes/solutions/simulation_regular_grid.jl")

export
  # spatial data
  GeoDataFrame,
  RegularGridData,
  readtable,

  # domains
  PointSet,
  RegularGrid,
  origin,
  spacing,

  # paths
  SimplePath,
  RandomPath,

  # neighborhoods
  CubeNeighborhood,
  BallNeighborhood,

  # distances
  Ellipsoidal,
  evaluate,

  # distributions
  EmpiricalDistribution,
  quantile,
  cdf,

  # helper functions
  bounding_grid,

  # helper macros
  @estimsolver,
  @simsolver

end # module
