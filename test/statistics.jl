@testset "Statistics" begin
  grid2D = RegularGrid{Float64}(3,3)
  realizations = Dict(:value => [i*ones(npoints(grid2D)) for i in 1:3])
  solution2D = SimulationSolution(grid2D, realizations)
  
  @testset "Mean" begin
    mean2D = mean(solution2D)
    @test mean2D.domain == solution2D.domain
    @test mean2D.values[:value][1] == 2.
    
    # show methods
    @test sprint(show, mean2D) == "2D Mean"
    @test sprint(show, MIME"text/plain"(), mean2D) == "2D Mean\n  domain: 3×3 RegularGrid{Float64,2}\n  variables: value"
  end
    
  @testset "Variance" begin
    variance2D = var(solution2D)
    @test variance2D.domain == solution2D.domain
    @test variance2D.values[:value][1] == 1.
    
    # show methods
    @test sprint(show, variance2D) == "2D Variance"
    @test sprint(show, MIME"text/plain"(), variance2D) == "2D Variance\n  domain: 3×3 RegularGrid{Float64,2}\n  variables: value"
  end
    
  @testset "Quantile" begin
    # scalar probability
    p = 0.5
    quantile2D = quantile(solution2D, p)
    @test quantile2D.domain == solution2D.domain
    @test quantile2D.values[:value][1] == 2.
        
    # vector of probabilities
    ps = [0., 0.5, 1.]
    quantiles2D = quantile(solution2D, ps)
    @test eltype(quantiles2D) <: GeoStatsDevTools.Quantile
    
    # show methods
    @test sprint(show, quantile2D) == "2D Quantile"
    @test sprint(show, MIME"text/plain"(), quantile2D) == "2D Quantile\n  domain: 3×3 RegularGrid{Float64,2}\n  variables: value"
  end
end