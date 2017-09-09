# GeoStatsDevTools

[![][travis-img]][travis-url] [![][julia-pkg-img]][julia-pkg-url]

This package contains developer tools for the [GeoStats.jl](https://github.com/juliohm/GeoStats.jl)
framework. It is intended to be used in conjunction with [GeoStatsBase.jl](https://github.com/juliohm/GeoStatsBase.jl)
to speed up the development of new solvers. A quick overview of the tools defined in the package is
provided, as well as a short example of usage.

## Contents

- [Developer tools](#developer-tools)
  - [Domain navigation](#domain-navigation)
  - [Mapping spatial data](#mapping-spatial-data)
- [Solver example](#solver-example)

### Developer tools

#### Domain navigation

To navigate through all locations of a (finite) spatial domain, we introduce the concept of paths. This package
defines various path types including `SimplePath` and `RandomPath` that can be used for iteration over any domain:

```julia
# prints 1, 2, ..., npoints(domain)
for location in SimplePath(domain)
  println(location)
end
```

At a given location of a domain, we can query neighboring locations with the concept of neighborhoods. Various
neighborhood types such as `CubeNeighborhood` and `BallNeighborhood` can be used to find all locations within a
specified radius:

```julia
# define ball neighborhood with radius 10
neighborhood = Ballneighborhood(domain, 10.)

# find neighbors for all locations of the domain
for location in RandomPath(domain)
  neighbors = neighborhood(location)
end
```

#### Mapping spatial data

In GeoStats.jl, spatial data and domain types are disconnected from each other for many reasons:

- To enable agressive parallelism and to avoid expensive data copies
- To give developers the power of deciding when and where data is to be copied
- To enable higher-level comparison schemes such as cross-validation

To map spatial data onto a domain, we introduce the notion of mappers. The `SimpleMapper` type can be used
to find the mapping between locations in the domain and the data for a given variable:

```julia
# for each variable of the problem, map the data to the domain
mapper = SimpleMapper(data(problem), domain(problem), variables(problem))

# get the mapping for the `:precipitation` variable
precipdata = mapping(mapper, :precipitation)

for (location, value) in precipdata
  println("Precipitation at location: $value")
end
```

### Solver example

For illustration purposes, we write an estimation solver that, for each location of the domain, assigns the
2-norm of the coordinates as the mean and the ∞-norm as the variance:

```julia
importall GeoStatsBase
using GeoStatsDevTools

struct NormSolver <: AbstractEstimationSolver
  # optional parameters go there
end

function solve(problem::EstimationProblem, solver::NormSolver)
  pdomain = domain(problem)

  mean = Dict{Symbol,Vector}()
  variance = Dict{Symbol,Vector}()

  for (var,V) in variables(problem)
    varμ = Vector{V}(npoints(pdomain))
    varσ = Vector{V}(npoints(pdomain))

    for location in SimplePath(pdomain)
      x = coordinates(pdomain, location)

      varμ[location] = norm(x, 2)
      varσ[location] = norm(x, Inf)
    end

    push!(mean, var => varμ)
    push!(variance, var => varσ)
  end

  EstimationSolution(pdomain, mean, variance)
end
```
![NormSolver](docs/NormSolver.png)

[travis-img]: https://travis-ci.org/juliohm/GeoStatsDevTools.jl.svg?branch=master
[travis-url]: https://travis-ci.org/juliohm/GeoStatsDevTools.jl

[julia-pkg-img]: http://pkg.julialang.org/badges/GeoStatsDevTools_0.6.svg
[julia-pkg-url]: http://pkg.julialang.org/?pkg=GeoStatsDevTools
