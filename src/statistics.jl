abstract type AbstractStatistic end

struct Mean{D<:AbstractDomain} <: AbstractStatistic
   domain::D
   values::Dict{Symbol, Vector} 
end

Mean(domain, values) = Mean{typeof(domain)}(domain, values)

function Mean(solution::SimulationSolution)
    # solution variables
    variables = collect(keys(solution.realizations))

    # output dictionary
    values = Dict(var => mean(solution.realizations[var]) for var in variables)
    
    Mean(solution.domain, values)
end

mean(solution::SimulationSolution) = Mean(solution)

function digest(statistic::Mean{<:RegularGrid})
  # solution variables
  variables = collect(keys(statistic.values))

  # get the size of the grid
  sz = size(statistic.domain)

  Dict(var => reshape(statistic.values[var], sz) for var in variables)
end


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