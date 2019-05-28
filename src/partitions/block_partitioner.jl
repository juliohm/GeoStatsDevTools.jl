# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    BlockPartitioner(side)

A method for partitioning spatial objects in N-dimensional space
into blocks of given `side`.
"""
struct BlockPartitioner{T<:Real} <: AbstractPartitioner
  side::T
end

function partition(object::AbstractSpatialObject{T,N},
                   partitioner::BlockPartitioner) where {N,T<:Real}
  # find coordinates of top left and bottom right corners
end
