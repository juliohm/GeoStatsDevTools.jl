# ------------------------------------------------------------------
# Copyright (c) 2018, Júlio Hoffimann Mendes <juliohm@stanford.edu>
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    PlanarPartition(spatialdata, normal; tol=1e-6)

A partition of `spatialdata` into a family of hyperplanes defined
by a `normal` direction. Two points `x` and `y` belong to the same
hyperplane when `(x - y) ⋅ normal ≈ 0`. `tol` is the tolerance used
in the comparison with zero.
"""
struct PlanarPartition{S<:AbstractSpatialData} <: AbstractPartition
  spatialdata::S
  subsets::Vector{Vector{Int}}
end

function PlanarPartition(spatialdata::AbstractSpatialData{T,N},
                         normal::NTuple{N,T}; tol=1e-6) where {N,T<:Real}
  # normalized normal
  n = MVector{N,T}(normal)
  normalize!(n)

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
      normalize!(y)

      if isapprox(y ⋅ n, 0., atol=tol)
        push!(subset, i)
        inserted = true
        break
      end
    end

    if !inserted
      push!(subsets, [i])
    end
  end

  PlanarPartition{typeof(spatialdata)}(spatialdata, subsets)
end
