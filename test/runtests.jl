using GeoStatsDevTools
using GeoStatsBase
using DataFrames: DataFrame
using Plots; gr(size=(600,400))
# using VisualRegressionTests
using Test

# list of maintainers
maintainers = ["juliohm"]

# environment settings
istravis = "TRAVIS" ∈ keys(ENV)
ismaintainer = "USER" ∈ keys(ENV) && ENV["USER"] ∈ maintainers
datadir = joinpath(@__DIR__,"data")

# load data sets
data1D = readtable(joinpath(datadir,"data1D.tsv"), delim='\t', coordnames=[:x])
data2D = readtable(joinpath(datadir,"data2D.tsv"), delim='\t', coordnames=[:x,:y])
data3D = readtable(joinpath(datadir,"data3D.tsv"), delim='\t')
missdata  = readtable(joinpath(datadir,"missing.tsv"), delim='\t', coordnames=[:x,:y])
samples2D = readtable(joinpath(datadir,"samples2D.tsv"), delim='\t', coordnames=[:x,:y])

# list of tests
testfiles = [
  "distances.jl",
  "distributions.jl",
  "spatialdata.jl",
  "domains.jl",
  "paths.jl",
  "neighborhoods.jl",
  "mappers.jl",
  "problems.jl"
  # "plotrecipes.jl"
]

@testset "GeoStatsDevTools.jl" begin
  for testfile in testfiles
    include(testfile)
  end
end
