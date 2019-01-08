@testset "Iterators" begin
  # positive and negative shifts
  p = SimplePath(RegularGrid{Float64}(3,3))
  @test collect(ShiftIterator(p,  0)) == collect(1:9)
  @test collect(ShiftIterator(p,  1)) == vcat(collect(2:9), [1])
  @test collect(ShiftIterator(p, -1)) == vcat([9], collect(1:8))
end
