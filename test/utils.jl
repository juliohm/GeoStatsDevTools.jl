@testset "Utilities" begin
  @test_throws ArgumentError readgeotable("doesnotexist.csv")

  grid = boundgrid(data1D, (100,))
  @test coordinates(grid, 1) == [0.]
  @test coordinates(grid, 100) == [100.]
end
