# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

@doc raw"""
    DirectionPartitioner(direction; atol=20., btol=.95)

A method for partitioning spatial objects along a given `direction`
with angle tolerance `atol` in degrees and bandwidth tolerance `btol`.
```
      ________________
     /        | btol
    /         |             ILLUSTRATION OF DIRECTION TOLERANCES
    ----------------->
    \ ) atol
     \________________
```
"""
struct DirectionPartitioner{T<:Real,N} <: AbstractSpatialFunctionPartitioner
  direction::SVector{N,T}
  atol::Float64
  btol::Float64
end

DirectionPartitioner(direction::NTuple{N,T}; atol=20., btol=.95) where {T<:Real,N} =
  DirectionPartitioner{T,N}(normalize(SVector(direction)), deg2rad(atol), btol)

(p::DirectionPartitioner)(x, y) = begin
  @. y = x - y
  l = norm(y)
  @. y = y / l

  θ = acos(p.direction ⋅ y)
  θ > π/2 && (θ = π - θ)

  θ < p.atol && l*sin(θ) < p.btol
end
