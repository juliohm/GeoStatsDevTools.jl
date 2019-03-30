# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

function Base.getindex(solution::SimulationSolution{<:RegularGrid}, var::Symbol)
  sz = size(solution.domain)
  [reshape(real, sz) for real in solution.realizations[var]]
end

function digest(solution::SimulationSolution{<:RegularGrid})
  Base.depwarn("digest(solution) is deprecated, use solution[:var] instead", :digest)
  # solution variables
  variables = collect(keys(solution.realizations))

  # get the size of the grid
  sz = size(solution.domain)

  # build dictionary pairs
  pairs = []
  for var in variables
    reals = map(r -> reshape(r, sz), solution.realizations[var])
    push!(pairs, var => reals)
  end

  # output dictionary
  Dict(pairs)
end
