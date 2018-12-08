@testset "Partitions" begin
  @testset "DirectionalPartition" begin
    geodata = RegularGridData{Float64}(Dict(:z => rand(3,3)))

    # basic checks on small regular grid data
    partition = DirectionalPartition(geodata, (1.,0.))
    @test subsets(partition) == [[1,2,3], [4,5,6], [7,8,9]]

    partition = DirectionalPartition(geodata, (0.,1.))
    @test subsets(partition) == [[1,4,7], [2,5,8], [3,6,9]]

    partition = DirectionalPartition(geodata, (1.,1.))
    @test subsets(partition) == [[1,5,9], [2,6], [3], [4,8], [7]]

    partition = DirectionalPartition(geodata, (1.,-1.))
    @test subsets(partition) == [[1], [2,4], [3,5,7], [6,8], [9]]

    # opposite directions produce same partition
    dir1 = (rand(), rand()); dir2 = .-dir1
    partition1 = DirectionalPartition(geodata, dir1)
    partition2 = DirectionalPartition(geodata, dir2)
    @test subsets(partition1) == subsets(partition2)

    # partition of arbitrarily large regular grid always
    # returns the "lines" and "columns" of the grid
    for n in [10,100,200]
      geodata = RegularGridData{Float64}(Dict(:z => rand(n,n)))

      partition = DirectionalPartition(geodata, (1.,0.))
      @test subsets(partition) == [collect((i-1)*n+1:i*n) for i in 1:n]
      ns = [GeoStatsDevTools.npoints(dataview) for dataview in partition]
      @test all(ns .== n)

      partition = DirectionalPartition(geodata, (0.,1.))
      @test subsets(partition) == [collect(i:n:n*n) for i in 1:n]
      ns = [GeoStatsDevTools.npoints(dataview) for dataview in partition]
      @test all(ns .== n)
    end
  end
end
