# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

@recipe function f(solution::SimulationSolution{<:PointSet}; variables=nothing)
  # retrieve domain geometry
  sdomain = domain(solution)
  dim = ndims(sdomain)

  # valid variables
  validvars = sort(collect(keys(solution.realizations)))

  # plot all variables by default
  variables == nothing && (variables = validvars)
  @assert variables ⊆ validvars "invalid variable name"

  # number of realizations
  nreals = length(solution.realizations[variables[1]])

  # plot layout: at most 3 realizations per variable
  N = min(nreals, 3)
  layout := (length(variables), N)

  # select realizations at random
  inds = sample(1:nreals, N, replace=false)

  # shared plot attributes
  legend --> false

  # retrieve coordinates
  X = coordinates(sdomain)

  for (i,var) in enumerate(variables)
    reals = solution.realizations[var][inds]

    # find value limits across realizations
    minmax = extrema.(reals)
    vmin = minimum(first.(minmax))
    vmax = maximum(last.(minmax))

    for (j,real) in enumerate(reals)
      if dim == 1
        @series begin
          subplot := (i-1)*N + j
          seriestype := :scatter
          title --> string(var, " $j")
          X[1,:], real
        end
      elseif dim == 2
        @series begin
          subplot := (i-1)*N + j
          seriestype := :scatter
          color := real
          markercolor --> :bluesreds
          clims --> (vmin, vmax)
          aspect_ratio --> :equal
          title --> string(var, " $j")
          X[1,:], X[2,:]
        end
      elseif dim == 3
        @series begin
          subplot := (i-1)*N + j
          seriestype := :scatter
          color = real
          markercolor --> :bluesreds
          clims --> (vmin, vmax)
          aspect_ratio --> :equal
          title --> string(var, " $j")
          X[1,:], X[2,:], X[3,:]
        end
      else
        error("cannot plot solution in more than 3 dimensions")
      end
    end
  end
end
