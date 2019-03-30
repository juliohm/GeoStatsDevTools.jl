# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

function Base.getindex(solution::EstimationSolution{<:RegularGrid}, var::Symbol)
  sz = size(solution.domain)
  M = reshape(solution.mean[var], sz)
  V = reshape(solution.variance[var], sz)
  (mean=M, variance=V)
end

function digest(solution::EstimationSolution{<:RegularGrid})
  Base.depwarn("digest(solution) is deprecated, use solution[:var] instead", :digest)
  # solution variables
  variables = keys(solution.mean)

  # get the size of the grid
  sz = size(solution.domain)

  # build dictionary pairs
  pairs = []
  for var in variables
    M = reshape(solution.mean[var], sz)
    V = reshape(solution.variance[var], sz)

    push!(pairs, var => Dict(:mean => M, :variance => V))
  end

  # output dictionary
  Dict(pairs)
end
