@testset "Spatial data" begin
  data3D   = readgeotable(joinpath(datadir,"data3D.tsv"), delim='\t')
  missdata = readgeotable(joinpath(datadir,"missing.tsv"), delim='\t', coordnames=[:x,:y])

  # basic checks
  @test coordinates(data3D) == Dict(var => Float64 for var in [:x,:y,:z])
  @test variables(data3D) == Dict(:value => Float64)
  @test npoints(data3D) == 100
  X, z = valid(data3D, :value)
  @test size(X,2) == 100
  @test length(z) == 100

  # missing data and NaN
  X, z = valid(missdata, :value)
  @test size(X) == (2,1)
  @test length(z) == 1

  # show methods
  rawdata = DataFrame(x=[1,2,3],y=[4,5,6])
  geodata = GeoDataFrame(rawdata, [:x,:y])
  @test sprint(show, geodata) == "3×2 GeoDataFrame (x and y)"
  @test sprint(show, MIME"text/plain"(), geodata) == "3×2 GeoDataFrame (x and y)\n\n│ Row │ x     │ y     │\n│     │ Int64 │ Int64 │\n├─────┼───────┼───────┤\n│ 1   │ 1     │ 4     │\n│ 2   │ 2     │ 5     │\n│ 3   │ 3     │ 6     │"
  @test sprint(show, MIME"text/html"(), geodata) == "3×2 GeoDataFrame (x and y)\n<table class=\"data-frame\"><thead><tr><th></th><th>x</th><th>y</th></tr><tr><th></th><th>Int64</th><th>Int64</th></tr></thead><tbody><p>3 rows × 2 columns</p><tr><th>1</th><td>1</td><td>4</td></tr><tr><th>2</th><td>2</td><td>5</td></tr><tr><th>3</th><td>3</td><td>6</td></tr></tbody></table>"
end


