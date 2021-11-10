using Test
using Maps


@testset "maps" begin

  @test HOME = Address("1004 Arnold Rd", "Madison", "AL")

  addr2 = Address("105 Chadrick Dr", "Madison", "AL")
  near_resp = JSON.parse(HTTP.payload(queryDistance(addr2)), dicttype=Dict{Symbol, Any})

  @test near_resp[:status] == "OK"
  @test near_resp[:rows][1][:elements][1][:distance][:value] == 8460
  @test split(near_resp[:destination_addresses][1], ",")[1] == addr2.street

end
