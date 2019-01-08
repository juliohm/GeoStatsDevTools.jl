# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

"""
    ShiftIterator(itr, offset)

Return an iterator that produces the same results of `itr`
but shifted by an `offset` that can be positive or negative.
"""
struct ShiftIterator{I}
  itr::I
  offset::Int
  length::Int
  start::Int
end

function ShiftIterator(itr, offset)
  _, s = iterate(itr)
  start = s - 1
  len = length(itr)
  off = offset ≥ 0 ? offset : len + offset
  ShiftIterator{typeof(itr)}(itr, off, len, start)
end

function Base.iterate(itr::ShiftIterator, state=1)
  if state > itr.length
    nothing
  else
    s = ((state + itr.offset - 1) % itr.length) + itr.start
    item, _ = iterate(itr.itr, s)
    item, state + 1
  end
end

Base.length(itr::ShiftIterator) = itr.length
