module LawncareController
  using Genie.Renderer.Html
  using Genie.Requests, Genie.Router
  include("helpers/maps_stuff.jl")


  function lawncarePage(estimate=0.0)
    println("current estimate = $estimate")
    html(:lawncare, :lawncare, estimate=estimate)
  end

  function getEstimate(acres, address)
    response = queryDistance(address)
    #if (#SOMETHING)
    #else
    mins = getDistanceMins(response)

    return 30+ 20*parse(Float32, acres) + mins
  end


  function calculateEstimate()
  #route("/lawncare", method=POST, named=:calculate_estimate) do
    #println( "Estimate for $(@params(:acres)) located at $(@params(:address))")
    current_estimate = getEstimate(@params(:acres), @params(:address))
    lawncarePage(current_estimate)
  end
end
