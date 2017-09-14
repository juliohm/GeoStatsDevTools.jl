## Copyright (c) 2017, Júlio Hoffimann Mendes <juliohm@stanford.edu>
##
## Permission to use, copy, modify, and/or distribute this software for any
## purpose with or without fee is hereby granted, provided that the above
## copyright notice and this permission notice appear in all copies.
##
## THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
## WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
## MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
## ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
## WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
## ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
## OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

"""
    @metasolver solver solvertype body

A helper macro to create a solver named `solver` of type `solvertype`
with parameters specified in `body`.

## Examples

Create a solver with parameters `mean` and `variogram` for each variable
of the problem, and a global parameter that specifies whether or not
to use the GPU:

```julia
julia> @metasolver MySolver AbstractSimulationSolver begin
  @param mean = 0.
  @param variogram = GaussianVariogram()
  @global gpu = false
end
```

### Notes

This macro is not intended to be used directly, see other macros defined
below for estimation and simulation solvers.
"""
macro metasolver(solver, solvertype, body)
  # discard any content that doesn't start with @param or @global
  content = filter(arg -> arg.head == :macrocall, body.args)

  # lines starting with @param refer to variable parameters
  vparams = filter(p -> p.args[1] == Symbol("@param"), content)
  vparams = map(p -> p.args[2], vparams)

  # lines starting with @global refer to global solver parameters
  gparams = filter(p -> p.args[1] == Symbol("@global"), content)
  gparams = map(p -> p.args[2], gparams)

  # add default value of `nothing` if necessary
  vparams = map(p -> p isa Symbol ? :($p = nothing) : p, vparams)
  gparams = map(p -> p isa Symbol ? :($p = nothing) : p, gparams)

  # replace Expr(:=, a, 2) by Expr(:kw, a, 2) for valid kw args
  gparams = map(p -> Expr(:kw, p.args...), gparams)

  # keyword names
  gkeys = map(p -> p.args[1], gparams)

  # solver parameter type
  solverparam = Symbol(solver,"Param")

  esc(quote
    $Parameters.@with_kw_noshow struct $solverparam
      __dummy__ = nothing
      $(vparams...)
    end

    @doc (@doc $solverparam) (
    struct $solver <: $solvertype
      params::Dict{Symbol,$solverparam}

      $(gkeys...)

      function $solver(params::Dict{Symbol,$solverparam}, $(gkeys...))
        new(params, $(gkeys...))
      end
    end)

    function $solver(params...; $(gparams...))
      # build dictionary for inner constructor
      dict = Dict{Symbol,$solverparam}()

      # convert named tuples to solver parameters
      for (varname, varparams) in params
        kwargs = [k => v for (k,v) in zip(keys(varparams), varparams)]
        push!(dict, varname => $solverparam(; kwargs...))
      end

      $solver(dict, $(gkeys...))
    end
  end)
end

"""
    @estimsolver solver body

A helper macro to create a estimation solver named `solver` with parameters
specified in `body`. For examples, please check the documentation for
`@metasolver`.
"""
macro estimsolver(solver, body)
  esc(quote
    GeoStatsDevTools.@metasolver $solver GeoStatsBase.AbstractEstimationSolver $body
  end)
end

"""
    @estimsolver solver body

A helper macro to create a simulation solver named `solver` with parameters
specified in `body`. For examples, please check the documentation for
`@metasolver`.
"""
macro simsolver(solver, body)
  esc(quote
    GeoStatsDevTools.@metasolver $solver GeoStatsBase.AbstractSimulationSolver $body
  end)
end
