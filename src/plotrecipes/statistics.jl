# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

@recipe function f(statistic::SpatialStatistic; variables=nothing)
  # retrieve underlying domain
  sdomain = statistic.domain

  # valid variables
  validvars = sort(collect(keys(statistic.values)))

  # plot all variables by default
  variables == nothing && (variables = validvars)
  @assert variables ⊆ validvars "invalid variable name"

  # shared plot specs
  layout --> length(variables)

  for (i, var) in enumerate(variables)
    @series begin
      subplot := i
      title --> string(var)
      legend --> false
      sdomain, statistic.values[var]
    end
  end
end
