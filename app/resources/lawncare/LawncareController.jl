module LawncareController
  using Genie.Renderer.Html
  using Genie.Sessions: session
  using Genie.Requests, Genie.Router
  include("../../helpers/maps_stuff.jl")

  #TODO limit number of requests for estimates for each device  per day
  #TODO address autocompletion (https://developers.google.com/maps/documentation/javascript/places-autocomplete)
  #TODO verify address is valid before calculating estimate
  #TODO add warning div for error messages
  #TODO Improve form layout and styling for estimate calculator
  #TODO 'schedule a visit' button
  #TODO route should include the fields for the form


  function lawncarePage()
    #set!(session(Genie.Requests.payload()), :current_page, get_route(:lawncare_page))
    street=payload(:street, "")
    city=payload(:city, "Madison")
    #state=payload(:state, "")
    acres=payload(:acres, "0.25")


    est = ""
    est_warn = ""

    # try to parse the acres
    acre_num = 0.0
    try
      acre_num = parse(Float32, acres)
    catch e
      est_warn = "Invalid `acres` entry."
    end

    # if no errors have occured yet
    if (est_warn == "")
      #est, est_warn = getEstimate(acre_num, Address(street, city, "AL"))
    end

    html(:lawncare, :lawncare, street=street, city=city, acres=acres, estimate=est, estimate_warning=est_warn)
  end


  """
  Returns the String dollar value and any error message
  """
  function getEstimate(acres::Float32, address::Address)
    # parse the JSON body of the HTTP response
    response_data = JSON.parse(String(queryDistance(address).body))

    # verify response is ok (did we successfully make a query?)
    if (response_data["status"] == "OK")

      # get the first item (Will I ever need anything other than this??)
      item = response_data["rows"][1]["elements"][1]

      # is this element ok? (was it able to locate and calculate for the provided address)
      if (item["status"] == "OK")
        mins = floor(item["duration"]["value"]/60)
        return "$(20*(acres - 0.25)^2 + mins + 35)", ""
      else 
        @warn item["status"]
        return "∞", item["status"]
      end
    else 
      @warn response_data["error_message"]
      return "∞", response_data["error_message"]
    end
  end



  """
  Check for the following issues

  * Empty values
  * invalid city, state (find an api for verifying address?)
  * check that the  0.0 < acres < 5.0
  """
  function checkPayload(payload::Dict)::String
    
  end
end

