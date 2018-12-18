# ------------------------------------------------------------------
# Copyright (c) 2018, Júlio Hoffimann Mendes <juliohm@stanford.edu>
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

@doc raw"""
    DirectionalPartition(spatialdata, direction; atol=20., btol=.95)

A partition of `spatialdata` along a given `direction` with
angle tolerance `atol` in degrees and bandwidth tolerance `btol`.
```
      ________________
     /        | btol
    /         |             ILLUSTRATION OF DIRECTION TOLERANCES
    ----------------->
    \ ) atol
     \________________
```
"""
struct DirectionalPartition{S<:AbstractSpatialData} <: AbstractPartition
  spatialdata::S
  subsets::Vector{Vector{Int}}
end

function DirectionalPartition(spatialdata::AbstractSpatialData{T,N},
                              direction::NTuple{N,T}; atol=20., btol=.95) where {N,T<:Real}
  # angle tolerance in radians
  θtol = deg2rad(atol)

  # normalized direction
  u = MVector{N,T}(direction)
  normalize!(u)

  # pre-allocate memory for coordinates
  x = MVector{N,T}(undef)
  y = MVector{N,T}(undef)

  subsets = Vector{Vector{Int}}()
  for i in 1:npoints(spatialdata)
    coordinates!(x, spatialdata, i)

    inserted = false
    for subset in subsets
      coordinates!(y, spatialdata, subset[1])
      @. y = x - y
      l = norm(y)
      @. y = y / l

      θ = acos(u ⋅ y)
      θ > π/2 && (θ = π - θ)

      if θ < θtol && l*sin(θ) < btol
        push!(subset, i)
        inserted = true
        break
      end
    end

    if !inserted
      push!(subsets, [i])
    end
  end

  DirectionalPartition{typeof(spatialdata)}(spatialdata, subsets)
end
