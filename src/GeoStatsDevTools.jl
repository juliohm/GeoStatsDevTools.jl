# ------------------------------------------------------------------
# Copyright (c) 2017, Júlio Hoffimann Mendes <juliohm@stanford.edu>
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

__precompile__()

module GeoStatsDevTools

using Distances
using Distributions
using DataFrames
using CSV

# won't be neeeded in Julia v0.7
using Parameters

# extend result_type and pairwise for theoretical variograms
import Distances: result_type, pairwise

importall GeoStatsBase

# spatial data
include("spatialdata/geodataframe.jl")

# domains
include("domains/regular_grid.jl")
include("domains/point_collection.jl")

# domain navigation
include("paths.jl")
include("neighborhoods.jl")

# distances and distributions
include("distances.jl")
include("distributions.jl")

# variograms
include("empirical_variograms.jl")
include("theoretical_variograms.jl")

# helper functions
include("utils.jl")

# helper macros
include("macros.jl")

export
  # spatial data
  GeoDataFrame,
  readtable,

  # domains
  RegularGrid,
  PointCollection,
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

  # empirical variograms
  EmpiricalVariogram,

  # theoretical variograms
  AbstractVariogram,
  GaussianVariogram,
  ExponentialVariogram,
  MaternVariogram,
  SphericalVariogram,
  CubicVariogram,
  PentasphericalVariogram,
  PowerVariogram,
  SineHoleVariogram,
  CompositeVariogram,
  isstationary,
  pairwise,

  # helper functions
  bounding_grid,

  # helper macros
  @estimsolver,
  @simsolver

end # module
