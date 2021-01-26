module LawncareController
  using Genie.Renderer.Html
  using Genie.Requests, Genie.Router
  const current_estimate = 0.0
  

  function lawncarePage(estimate=0.0)
    println("current estimate = $estimate")
    html(:lawncare, :lawncare, estimate=estimate)
  end

  function getEstimate(acres, address)
    return 30+ 20*parse(Float32, acres)
  end


  function calculateEstimate()
  #route("/lawncare", method=POST, named=:calculate_estimate) do
    #println( "Estimate for $(@params(:acres)) located at $(@params(:address))")
    current_estimate = getEstimate(@params(:acres), @params(:address))
    lawncarePage(current_estimate)
  end
end
