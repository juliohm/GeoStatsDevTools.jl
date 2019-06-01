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
  side = partitioner.side

  bounds     = extent(object)
  lowerleft  = first.(bounds)
  upperright = last.(bounds)

  @assert minimum(upperright .- lowerleft) ≥ side "block side is too large"

  center = @. (lowerleft + upperright) / 2
  Δleft  = @. ceil(Int, (center  - lowerleft) / side)
  Δright = @. ceil(Int, (upperright - center) / side)

  origin  = @. center - Δleft*side
  nblocks = @. Δleft + Δright

  subsets = [Int[] for i in 1:prod(nblocks)]

  coords  = MVector{N,T}(undef)
  linear = LinearIndices(Dims(nblocks))
  for j in 1:npoints(object)
    coordinates!(coords, object, j)
    icoords = floor.(Int, (Tuple(coords) .- origin) ./ side) .+ 1
    i = linear[icoords...]
    append!(subsets[i], j)
  end

  filter!(!isempty, subsets)

  SpatialPartition(object, subsets)
end
