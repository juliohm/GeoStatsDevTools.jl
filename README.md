# GeoStatsDevTools.jl

[![][travis-img]][travis-url] [![][julia-pkg-img]][julia-pkg-url] [![][codecov-img]][codecov-url]

This package contains developer tools for the [GeoStats.jl](https://github.com/juliohm/GeoStats.jl)
framework. It is intended to be used in conjunction with [GeoStatsBase.jl](https://github.com/juliohm/GeoStatsBase.jl)
to speed up the development of new solvers. A quick overview of the tools defined in the package is
provided, as well as a short example of usage.

## Contents

- [Developer tools](#developer-tools)
  - [Solver macros](#solver-macros)
  - [Domain navigation](#domain-navigation)
  - [Mapping spatial data](#mapping-spatial-data)
- [Solver example](#solver-example)
- [Asking for help](#asking-for-help)

### Developer tools

#### Solver macros

To define a new solver with the same interface of built-in solvers such as `Kriging` and `SeqGaussSim`, the developer
can use solver macros:

```julia
@estimsolver MySolver begin
  @param variogram = GaussianVariogram()
  @param mean # no default parameter
  @global verbose = true
end
```

The `@estimsolver` macro defines a new estimation solver `MySolver`, a parameter type `MySolverParam`, and an outer constructor that accepts parameters for each variable as well as global parameters.

Similarly, simulation solvers can be created with the `@simsolver` macro.

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

In this framework, spatial data and domain types are disconnected from each other for many reasons:

- To enable agressive parallelism and to avoid expensive data copies
- To give developers the power of deciding when and where data is to be copied
- To enable higher-level comparison schemes such as cross-validation

To map spatial data onto a domain, we introduce the notion of mappers. The `SimpleMapper` type can be used
to find the mapping from domain locations to data locations for a given variable:

```julia
# construct a problem mapping data onto domain using SimpleMapper (default)
problem = EstimationProblem(..., mapper=SimpleMapper())

# get the mapping for the `:precipitation` variable
mapping = datamap(problem, :precipitation)

for (loc, datloc) in mapping
  println("Domain location $loc has data at spatial data index $datloc")
end
```

### Solver example

For illustration purposes, we write an estimation solver that, for each location of the domain, assigns the
2-norm of the coordinates as the mean and the ∞-norm as the variance:

```julia
importall GeoStatsBase
using GeoStatsDevTools

@estimsolver NormSolver begin
  @param pmean = 2
  @param pvar  = Inf
end

function solve(problem::EstimationProblem, solver::NormSolver)
  pdomain = domain(problem)

  # results for each variable
  μs = []; σs = []

  for (var,V) in variables(problem)
    # get user parameters
    if var in keys(solver.params)
      varparams = solver.params[var]
    else
      varparams = NormSolverParam()
    end

    # allocate memory
    varμ = Vector{V}(npoints(pdomain))
    varσ = Vector{V}(npoints(pdomain))

    for location in SimplePath(pdomain)
      x = coordinates(pdomain, location)

      varμ[location] = norm(x, varparams.pmean)
      varσ[location] = norm(x, varparams.pvar)
    end

    push!(μs, var => varμ)
    push!(σs, var => varσ)
  end

  EstimationSolution(pdomain, Dict(μs), Dict(σs))
end
```
![NormSolver](docs/NormSolver.png)

### Asking for help

If you have any questions, please contact our community on the [gitter channel](https://gitter.im/JuliaEarth/GeoStats.jl).

[travis-img]: https://travis-ci.org/juliohm/GeoStatsDevTools.jl.svg?branch=master
[travis-url]: https://travis-ci.org/juliohm/GeoStatsDevTools.jl

[julia-pkg-img]: http://pkg.julialang.org/badges/GeoStatsDevTools_0.7.svg
[julia-pkg-url]: http://pkg.julialang.org/?pkg=GeoStatsDevTools

[codecov-img]: https://codecov.io/gh/juliohm/GeoStatsDevTools.jl/branch/master/graph/badge.svg
[codecov-url]: https://codecov.io/gh/juliohm/GeoStatsDevTools.jl
