# ------------------------------------------------------------------
# Copyright (c) 2017, Júlio Hoffimann Mendes <juliohm@stanford.edu>
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

module GeoStatsDevTools

using Printf
using Random
using Distances
using Distributions
using LinearAlgebra
using DataFrames
using StaticArrays
using Parameters
using RecipesBase
using CSV

using GeoStatsBase

# implement methods for spatial data
import GeoStatsBase: coordinates, variables, npoints, value

# implement methods for spatial domain
import GeoStatsBase: coordinates!, npoints, nearestlocation

# spatial data
include("spatialdata/geodataframe.jl")
include("spatialdata/point_set_data.jl")
include("spatialdata/regular_grid_data.jl")
include("spatialdata/structured_grid_data.jl")

# spatial domain
include("domains/point_set.jl")
include("domains/regular_grid.jl")

# domain navigation
include("paths.jl")
include("neighborhoods.jl")

# distances and distributions
include("distances.jl")
include("distributions.jl")

# utilities
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
  PointSetData,
  RegularGridData,
  StructuredGridData,
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
