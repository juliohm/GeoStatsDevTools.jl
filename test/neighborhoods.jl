@testset "Neighborhoods" begin
  @testset "CubeNeighborhood" begin
    grid1D = RegularGrid{Float64}(100)
    neigh1 = CubeNeighborhood(grid1D, .5)
    @test neigh1(1) == [1]

    grid2D = RegularGrid{Float64}(100,100)
    neigh1 = CubeNeighborhood(grid2D, 1.)
    @test neigh1(1) == [1,2,101,102]
    neigh2 = CubeNeighborhood(grid2D, 2.)
    @test neigh2(1) == [1,2,3,101,102,103,201,202,203]

    grid3D = RegularGrid{Float64}(100,100,100)
    neigh1 = CubeNeighborhood(grid3D, .5)
    @test neigh1(1) == [1]

    grid4D = RegularGrid{Float64}(10,20,30,40)
    neigh1 = CubeNeighborhood(grid4D, .5)
    @test neigh1(1) == [1]

    ps2D = PointSet([0. 1. 0. 1.; 0. 0. 1. 1.])
    neigh1 = CubeNeighborhood(ps2D, 1.)
    @test neigh1(1) == [1,2,3,4]
  end

  @testset "BallNeighborhood" begin
    grid1D = RegularGrid{Float64}(100)
    neigh1 = BallNeighborhood(grid1D, .5)
    @test neigh1(1) == [1]

    grid2D = RegularGrid{Float64}(100,100)
    neigh1 = BallNeighborhood(grid2D, 1.)
    @test neigh1(1) == [1,2,101]
    neigh2 = BallNeighborhood(grid2D, .5)
    @test neigh2(1) == [1]

    grid3D = RegularGrid{Float64}(100,100,100)
    neigh1 = BallNeighborhood(grid3D, .5)
    @test neigh1(1) == [1]

    grid4D = RegularGrid{Float64}(10,20,30,40)
    neigh1 = BallNeighborhood(grid4D, .5)
    @test neigh1(1) == [1]

    ps2D = PointSet([0. 1. 0. 1.; 0. 0. 1. 1.])
    neigh1 = BallNeighborhood(ps2D, 1.)
    @test neigh1(1) == [1,2,3]
  end

  @testset "CylinderNeighborhood" begin
    # TODO
  end
end
