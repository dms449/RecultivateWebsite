module LawncareController
  using Genie.Renderer.Html
  using Genie.Requests, Genie.Router
  include("../../helpers/maps_stuff.jl")

  #TODO limit number of requests for estimates for each device  per day
  #TODO address autocompletion (https://developers.google.com/maps/documentation/javascript/places-autocomplete)
  #TODO verify address is valid before calculating estimate
  #TODO add warning div for error messages
  #TODO Improve form layout and styling for estimate calculator
  #TODO 'schedule a visit' button
  #TODO route should include the fields for the form



  """

  """
  function lawncarePage(est=0.0, est_warn="")
    html(:lawncare, :lawncare, estimate=est, estimate_warning=est_warn)
  end

  """
  
  """
  function getEstimate(acres, address::Address)
    response = queryDistance(address)
    # TODO make sure response is valid
    #if (#SOMETHING)
    #else
    mins = getDistanceMins(response)

    return 20*(parse(Float32, acres) - 0.25)^2 + mins + 35
  end


  """
  
  """
  function calculateEstimate()
    println( "Estimate for $(@params(:acres)) located at $(@params(:street)), $(@params(:city)), $(@params(:state))")

    warn = ""
    estimate = 0.0

    warn = checkPostPayload(postpayload())

    # calculate the estimate if all of the necessary fields are filled
    if (warn == "")
      estimate = getEstimate(@params(:acres), Address(@params(:street), @params(:city), @params(:state)))
    end

    # reload the page
    lawncarePage(estimate, warn)
  end


  """
  Check for the following issues

  * Empty values
  * invalid city, state (find an api for verifying address?)
  * check that the  0.0 < acres < 5.0
  """
  function checkPostPayload(payload::Dict)::String
  #TODO
  end
end

