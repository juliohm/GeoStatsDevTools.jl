@testset "Paths" begin
  grid = RegularGrid{Float64}(100,100)

  for path in [SimplePath(grid), RandomPath(grid)]
    @test length(path) == 100*100
  end

  @testset "SimplePath" begin
    path = SimplePath(grid)
    @test collect(path) == collect(1:100*100)
  end

  @testset "RandomPath" begin
    path = RandomPath(grid)
    @test all(1 .≤ collect(path) .≤ 100*100)
  end

  @testset "SourcePath" begin
    # TODO
  end
end
