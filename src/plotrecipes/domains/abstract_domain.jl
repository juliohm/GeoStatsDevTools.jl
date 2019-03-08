# ------------------------------------------------------------------
# Licensed under the ISC License. See LICENCE in the project root.
# ------------------------------------------------------------------

@recipe function f(domain::AbstractDomain)
  @series begin
    PointSet(coordinates(domain))
  end
end
