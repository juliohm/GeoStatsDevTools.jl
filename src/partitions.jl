# ------------------------------------------------------------------
# Copyright (c) 2018, Júlio Hoffimann Mendes <juliohm@stanford.edu>
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    AbstractPartition

A partition of spatial data.
"""
abstract type AbstractPartition end

"""
    subsets(partition)

Return the subsets of indices in spatial data
that make up the `partition`.
"""
subsets(partition::AbstractPartition) = partition.subsets

"""
    Base.iterate(partition)

Iterate the partition returning views of spatial data.
"""
function Base.iterate(partition::AbstractPartition, state=1)
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
Base.length(partition::AbstractPartition) = length(partition.subsets)

#------------------
# IMPLEMENTATIONS
#------------------
include("partitions/directional_partition.jl")
