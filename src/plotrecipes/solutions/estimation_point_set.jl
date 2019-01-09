# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

@recipe function f(solution::EstimationSolution{<:PointSet}; variables=nothing)
  # retrieve domain geometry
  sdomain = domain(solution)
  dim = ndims(sdomain)

  # valid variables
  validvars = sort(collect(keys(solution.mean)))

  # plot all variables by default
  variables == nothing && (variables = validvars)
  @assert variables ⊆ validvars "invalid variable name"

  # plot layout: mean and variance for each variable
  layout := (length(variables), 2)

  # shared plot attributes
  legend --> false

  for (i,var) in enumerate(variables)
    X = coordinates(sdomain)
    μ  = solution.mean[var]
    σ² = solution.variance[var]

    if dim == 1
      @series begin
        subplot := 2i - 1
        seriestype := :scatter
        title --> string(var, " mean")
        X[1,:], μ
      end
      @series begin
        subplot := 2i
        seriestype := :scatter
        title --> string(var, " variance")
        X[1,:], σ²
      end
    elseif dim == 2
      @series begin
        subplot := 2i - 1
        seriestype := :scatter
        color := μ
        markercolor --> :bluesreds
        aspect_ratio --> :equal
        title --> string(var, " mean")
        X[1,:], X[2,:]
      end
      @series begin
        subplot := 2i
        seriestype := :scatter
        color := σ²
        markercolor --> :bluesreds
        aspect_ratio --> :equal
        title --> string(var, " variance")
        X[1,:], X[2,:]
      end
    elseif dim == 3
      @series begin
        subplot := 2i - 1
        seriestype := :scatter
        color := μ
        markercolor --> :bluesreds
        aspect_ratio --> :equal
        title --> string(var, " mean")
        X[1,:], X[2,:], X[3,:]
      end
      @series begin
        subplot := 2i
        seriestype := :scatter
        color := σ²
        markercolor --> :bluesreds
        aspect_ratio --> :equal
        title --> string(var, " variance")
        X[1,:], X[2,:], X[3,:]
      end
    else
      error("cannot plot solution in more than 3 dimensions")
    end
  end
end
