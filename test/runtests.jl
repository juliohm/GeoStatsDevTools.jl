using GeoStatsDevTools
using GeoStatsBase
using Distances: Euclidean, Chebyshev
using DataFrames: DataFrame
using Plots; gr(size=(600,400))
using VisualRegressionTests
using Test, Pkg

# list of maintainers
maintainers = ["juliohm"]

# environment settings
istravis = "TRAVIS" ∈ keys(ENV)
ismaintainer = "USER" ∈ keys(ENV) && ENV["USER"] ∈ maintainers
datadir = joinpath(@__DIR__,"data")

if ismaintainer
  Pkg.add("Gtk")
  using Gtk
end

# list of tests
testfiles = [
  "distances.jl",
  "distributions.jl",
  "spatialdata.jl",
  "domains.jl",
  "partitions.jl",
  "paths.jl",
  "neighborhoods.jl",
  "mappers.jl",
  "problems.jl",
  "utils.jl",
  "statistics.jl"
]

@testset "GeoStatsDevTools.jl" begin
  for testfile in testfiles
    include(testfile)
  end
end
