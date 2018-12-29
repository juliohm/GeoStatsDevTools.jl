struct SpatialStatistic{D<:AbstractDomain}
  domain::D
  values::Dict{Symbol,Vector} 
end

SpatialStatistic(domain, values) = SpatialStatistic{typeof(domain)}(domain, values)

function mean(solution::SimulationSolution)
  # output dictionary
  values = Dict(variable => mean(real) for (variable, real) in solution.realizations)
    
  SpatialStatistic(solution.domain, values)
end

function var(solution::SimulationSolution)
  # output dictionary
  values = Dict(variable => var(real) for (variable, real) in solution.realizations)
    
  SpatialStatistic(solution.domain, values)
end

function quantile(solution::SimulationSolution, p::Real)
  # output dictionary
  values = Dict{Symbol,Vector}()
  
  # loop over solution realizations
  for (variable, real) in solution.realizations
    # pixelwise slices
    slices = [getindex.(real, i) for i in 1:npoints(solution.domain)]
    values[variable] = quantile.(slices, p)
  end
    
  SpatialStatistic(solution.domain, values)
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
