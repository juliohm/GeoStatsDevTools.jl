@testset "Statistics" begin
  grid2D = RegularGrid{Float64}(3,3)
  realizations = Dict(:value => [i*ones(npoints(grid2D)) for i in 1:3])
  solution2D = SimulationSolution(grid2D, realizations)

  # mean
  mean2D = mean(solution2D)
  @test mean2D.domain == solution2D.domain
  @test mean2D.values[:value][1] == 2.

  # variance
  variance2D = var(solution2D)
  @test variance2D.domain == solution2D.domain
  @test variance2D.values[:value][1] == 1.

  # quantile (scalar)
  p = 0.5
  quantile2D = quantile(solution2D, p)
  @test quantile2D.domain == solution2D.domain
  @test quantile2D.values[:value][1] == 2.

  # quantile (vector)
  ps = [0.0, 0.5, 1.0]
  quantiles2D = quantile(solution2D, ps)
  @test eltype(quantiles2D) <: GeoStatsDevTools.SpatialStatistic

  # show methods
  @test sprint(show, mean2D) == "2D SpatialStatistic"
  @test sprint(show, MIME"text/plain"(), mean2D) == "2D SpatialStatistic\n  domain: 3×3 RegularGrid{Float64,2}\n  variables: value"
end
