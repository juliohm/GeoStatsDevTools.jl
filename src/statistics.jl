abstract type AbstractStatistic end

struct Mean{D<:AbstractDomain} <: AbstractStatistic
  domain::D
  values::Dict{Symbol,Vector} 
end

function Mean(solution::SimulationSolution)
  # output dictionary
  values = Dict(variable => mean(real) for (variable, real) in solution.realizations)
    
  Mean{typeof(solution.domain)}(solution.domain, values)
end

mean(solution::SimulationSolution) = Mean(solution)

struct Variance{D<:AbstractDomain} <: AbstractStatistic
  domain::D
  values::Dict{Symbol,Vector} 
end

function Variance(solution::SimulationSolution)
  # output dictionary
  values = Dict(variable => var(real) for (variable, real) in solution.realizations)
    
  Variance{typeof(solution.domain)}(solution.domain, values)
end

var(solution::SimulationSolution) = Variance(solution)

struct Quantile{D<:AbstractDomain} <: AbstractStatistic
  domain::D
  p::Float64
  values::Dict{Symbol,Vector}
end

function Quantile(solution::SimulationSolution, p::Real)
  # function returning vector of slices
  slices(x) = [getindex.(x, i) for i in 1:npoints(solution.domain)]
  
  # output dictionary
  values = Dict{Symbol,Vector}()
  
  # loop over solution realizations
  for (variable, real) in solution.realizations
    values[variable] = quantile.(slices(real), p)
  end
    
  Quantile{typeof(solution.domain)}(solution.domain, p, values)
end

quantile(solution::SimulationSolution, p::Real) = Quantile(solution, p)

quantile(solution::SimulationSolution, ps::AbstractVector) = [quantile(solution, p) for p in ps]

# ------------
# IO methods
# ------------
function Base.show(io::IO, statistic::Mean)
  dim = ndims(statistic.domain)
  print(io, "$(dim)D Mean")
end

function Base.show(io::IO, statistic::Variance)
  dim = ndims(statistic.domain)
  print(io, "$(dim)D Variance")
end

function Base.show(io::IO, statistic::Quantile)
  dim = ndims(statistic.domain)
  print(io, "$(dim)D Quantile")
end

function Base.show(io::IO, ::MIME"text/plain", statistic::AbstractStatistic)
  println(io, statistic)
  println(io, "  domain: ", statistic.domain)
  print(  io, "  variables: ", join(keys(statistic.values), ", ", " and "))
end
