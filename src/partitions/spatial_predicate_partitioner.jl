# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    SpatialPredicatePartitioner(predicate)

A method for partitioning spatial data based on a `predicate`. Given
two coordinates `x` and `y`, the value `predicate(x,y)` informs whether
or not the points belong to the same subset.
"""
struct SpatialPredicatePartitioner <: AbstractPartitioner
  predicate::Function
end

function partition(spatialdata::AbstractSpatialData{T,N},
                   partitioner::SpatialPredicatePartitioner) where {N,T<:Real}
  # pre-allocate memory for coordinates
  x = MVector{N,T}(undef)
  y = MVector{N,T}(undef)

  subsets = Vector{Vector{Int}}()
  for i in 1:npoints(spatialdata)
    coordinates!(x, spatialdata, i)

    inserted = false
    for subset in subsets
      coordinates!(y, spatialdata, subset[1])

      if partitioner.predicate(x, y)
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
