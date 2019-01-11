# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    UniformPartitioner(k, [shuffle])

A method for partitioning spatial data uniformly into `k` subsets
of approximately equal size. Optionally `shuffle` the data (default
to true).
"""
struct UniformPartitioner <: AbstractPartitioner
  k::Int
  shuffle::Bool
end

UniformPartitioner(k::Int) = UniformPartitioner(k, true)

function partition(spatialdata::AbstractSpatialData{T,N},
                   partitioner::UniformPartitioner) where {N,T<:Real}
  npts = npoints(spatialdata)
  inds = partitioner.shuffle ? shuffle(1:npts) : collect(1:npts)
  subsets = collect(Iterators.partition(inds, npts ÷ partitioner.k))

  SpatialPartition(spatialdata, subsets)
end
