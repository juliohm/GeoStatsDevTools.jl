# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    PlanePartitioner(normal; tol=1e-6)

A method for partitioning spatial data into a family of hyperplanes defined
by a `normal` direction. Two points `x` and `y` belong to the same
hyperplane when `(x - y) ⋅ normal < tol`.
"""
struct PlanePartitioner{T<:Real,N} <: AbstractPartitioner
  normal::NTuple{N,T}
  tol::Float64
end

PlanePartitioner(normal; tol=1e-6) =
  PlanePartitioner{eltype(normal),length(normal)}(normal, tol)

function partition(spatialdata::AbstractSpatialData{T,N},
                   partitioner::PlanePartitioner{T,N}) where {N,T<:Real}
  # normalized normal
  n = MVector{N,T}(partitioner.normal)
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

      if abs(y ⋅ n) < partitioner.tol
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
