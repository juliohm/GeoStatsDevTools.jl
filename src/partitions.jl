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
    iterate(partition)

Iterate the partition returning views of spatial data.
"""
function Base.iterate(partition::AbstractPartition, state=1)
  if state > length(partition.subsets)
    nothing
  else
    view(partition.spatialdata, partition.subsets[state]), state + 1
  end
end

#------------------
# IMPLEMENTATIONS
#------------------
include("partitions/directional_partition.jl")
