# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    SpatialStatistic{D}

A spatial statistic on a spatial domain of type `D`.
"""
struct SpatialStatistic{D<:AbstractDomain}
  domain::D
  values::Dict{Symbol,Vector}
end

SpatialStatistic(domain, values) = SpatialStatistic{typeof(domain)}(domain, values)

"""
    mean(solution)

Mean of simulation `solution`.
"""
function mean(solution::SimulationSolution)
  values = Dict(variable => mean(reals) for (variable, reals) in solution.realizations)
  SpatialStatistic(solution.domain, values)
end

"""
    var(solution)

Variance of simulation `solution`.
"""
function var(solution::SimulationSolution)
  values = Dict(variable => var(reals) for (variable, reals) in solution.realizations)
  SpatialStatistic(solution.domain, values)
end

"""
    quantile(solution, p)

p-quantile of simulation `solution`.
"""
function quantile(solution::SimulationSolution, p::Real)
  values = []
  for (variable, reals) in solution.realizations
    quantiles = map(1:npoints(solution.domain)) do location
      slice = getindex.(reals, location)
      quantile(slice, p)
    end
    push!(values, variable => quantiles)
  end

  SpatialStatistic(solution.domain, Dict(values))
end

quantile(solution::SimulationSolution, ps::AbstractVector) = [quantile(solution, p) for p in ps]

# ------------
# IO methods
# ------------
function Base.show(io::IO, statistic::SpatialStatistic)
  dim = ndims(statistic.domain)
  print(io, "$(dim)D SpatialStatistic")
end

function Base.show(io::IO, ::MIME"text/plain", statistic::SpatialStatistic)
  println(io, statistic)
  println(io, "  domain: ", statistic.domain)
  print(  io, "  variables: ", join(keys(statistic.values), ", ", " and "))
end
