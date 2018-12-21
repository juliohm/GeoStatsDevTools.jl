# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    SpatialPartition

A partition of spatial data.
"""
struct SpatialPartition{S<:AbstractSpatialData}
  spatialdata::S
  subsets::Vector{Vector{Int}}
end

SpatialPartition(spatialdata, subsets) =
  SpatialPartition{typeof(spatialdata)}(spatialdata, subsets)

"""
    subsets(partition)

Return the subsets of indices in spatial data
that make up the `partition`.
"""
subsets(partition::SpatialPartition) = partition.subsets

"""
    Base.iterate(partition)

Iterate the partition returning views of spatial data.
"""
function Base.iterate(partition::SpatialPartition, state=1)
  if state > length(partition.subsets)
    nothing
  else
    view(partition.spatialdata, partition.subsets[state]), state + 1
  end
end

"""
    Base.length(partition)

Return the number of subsets in `partition`.
"""
Base.length(partition::SpatialPartition) = length(partition.subsets)

"""
    AbstractPartitioner

A method for partitioning spatial data.
"""
abstract type AbstractPartitioner end

"""
    partition(spatialdata, partitioner)

Partition `spatialdata` with partition method `partitioner`.
"""
partition(::AbstractSpatialData, ::AbstractPartitioner) = error("not implemented")

#------------------
# IMPLEMENTATIONS
#------------------
include("partitions/predicate_partition.jl")
include("partitions/directional_partition.jl")
include("partitions/planar_partition.jl")
include("partitions/hierarchical_partition.jl")
