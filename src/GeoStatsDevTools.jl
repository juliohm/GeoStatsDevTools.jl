# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

module GeoStatsDevTools

using Reexport
using Random
using StatsBase
using Distances
using LinearAlgebra
using StaticArrays
using NearestNeighbors
using RecipesBase
using CSV

@reexport using Distributions

using GeoStatsBase

# implement methods for spatial objects
import GeoStatsBase: domain, variables, value

# implement methods for spatial statistics
import Statistics: mean, var, quantile

# spatial weighting
include("weighting.jl")

# neighborhood search
include("neighborsearch.jl")

# utilities
include("utils.jl")

# spatial statistics
include("statistics.jl")

# plot recipes
include("plotrecipes/partitions.jl")
include("plotrecipes/weighting.jl")

export
  # weighting
  WeightedSpatialData,
  BlockWeighter,
  weight,

  # neighborhood search
  NearestNeighborSearcher,
  LocalNeighborSearcher,
  search!,

  # utilities
  readgeotable,

  # statistics
  mean, var,
  quantile

end
