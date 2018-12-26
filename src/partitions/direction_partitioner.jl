# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

@doc raw"""
    DirectionPartitioner(direction; atol=20., btol=.95)

A method for partitioning spatial data along a given `direction` with
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
struct DirectionPartitioner{T<:Real,N} <: AbstractPartitioner
  direction::NTuple{N,T}
  atol::Float64
  btol::Float64
end

DirectionPartitioner(direction; atol=20., btol=.95) =
  DirectionPartitioner{eltype(direction),length(direction)}(direction, atol, btol)

function partition(spatialdata::AbstractSpatialData{T,N},
                   partitioner::DirectionPartitioner{T,N}) where {N,T<:Real}
  # angle tolerance in radians
  θtol = deg2rad(partitioner.atol)

  # normalized direction
  u = MVector{N,T}(partitioner.direction)
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

      if θ < θtol && l*sin(θ) < partitioner.btol
        push!(subset, i)
        inserted = true
        break
      end
    end

    if !inserted
      push!(subsets, [i])
    end
  end

  SpatialPartition(spatialdata, subsets)
end
