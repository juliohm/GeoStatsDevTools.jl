abstract type AbstractStatistic end

struct Mean{D<:AbstractDomain} <: AbstractStatistic
  domain::D
  values::Dict{Symbol, Vector} 
end

function Mean(solution::SimulationSolution)
  # output dictionary
  values = Dict(var => mean(real) for (var, real) in solution.realizations)
    
  Mean{typeof(solution.domain)}(solution.domain, values)
end

mean(solution::SimulationSolution) = Mean(solution)

struct Variance{D<:AbstractDomain} <: AbstractStatistic
  domain::D
  values::Dict{Symbol, Vector} 
end

function Variance(solution::SimulationSolution)
  # output dictionary
  values = Dict(var => var(real) for (var, real) in solution.realizations)
    
  Variance{typeof(solution.domain)}(solution.domain, values)
end

var(solution::SimulationSolution) = Variance(solution)

struct Quantile{D<:AbstractDomain, P<:Real}
  domain::D
  p::P
  values::Dict{Symbol, Vector}
end

function Quantile(solution::SimulationSolution, p::Real)
  # function returning vector of slices
  slices(x) = [getindex.(x, i) for i in 1:npoints(solution.domain)]
  
  # output dictionary
  values = Dict(var => quantile.(slices(real), p) for (var, real) in solution.realizations)
    
  Quantile{typeof(solution.domain), typeof(p)}(solution.domain, p, values)
end

quantile(solution::SimulationSolution, p::Real) = Quantile(solution, p)

quantile(solution::SimulationSolution, ps::AbstractArray) = [quantile(solution, p) for p in ps]


# ------------
# IO methods
# ------------

function Base.show(io::IO, statistic::Mean)
  dim = ndims(statistic.domain)
  print(io, "$(dim)D Mean")
end

function Base.show(io::IO, ::MIME"text/plain", statistic::Mean)
  println(io, statistic)
  println(io, "  domain: ", statistic.domain)
  print(  io, "  variables: ", join(keys(statistic.values), ", ", " and "))
end

function Base.show(io::IO, statistic::Variance)
  dim = ndims(statistic.domain)
  print(io, "$(dim)D Variance")
end

function Base.show(io::IO, ::MIME"text/plain", statistic::Variance)
  println(io, statistic)
  println(io, "  domain: ", statistic.domain)
  print(  io, "  variables: ", join(keys(statistic.values), ", ", " and "))
end

function Base.show(io::IO, statistic::Quantile)
  dim = ndims(statistic.domain)
  print(io, "$(dim)D Quantile")
end

function Base.show(io::IO, ::MIME"text/plain", statistic::Quantile)
  println(io, statistic)
  println(io, "  domain: ", statistic.domain)
  println(io, "  variables: ", join(keys(statistic.values), ", ", " and "))
  print(  io, "  probability: ", statistic.p)
end