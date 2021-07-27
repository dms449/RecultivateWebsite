module LawncareController
  using Genie.Renderer.Html
  using Genie.Sessions, Genie.Requests, Genie.Router
  include("../../helpers/google_maps.jl")
  include("../../helpers/lawncare_equation.jl")
  include("../../helpers/random.jl")

  #TODO limit number of requests for estimates for each device  per day
  #TODO address autocompletion (https://developers.google.com/maps/documentation/javascript/places-autocomplete)
  #TODO verify address is valid before calculating estimate
  #TODO add warning div for error messages
  #TODO Improve form layout and styling for estimate calculator
  #TODO 'schedule a visit' button
  #TODO route should include the fields for the form

  struct Item
    name::String
    desc::String
    value::Float32
  end


  function lawncarePage()
    Sessions.set!(Sessions.session(Requests.payload()), :current_page, :lawncare_page)
    #set!(session(Genie.Requests.payload()), :current_page, get_route(:lawncare_page))
    street=payload(:street, "")
    city=payload(:city, "madison")
    #state=payload(:state, "")
    acres=payload(:acres, "0.25")
    repeat=payload(:repeat, "1")


    est = ""
    warnings = [] 
    items = []

    # try to parse the acres
    acre_num = 0.0
    try
      acre_num = parse(Float32, acres)
    catch e
      push!(warnings, "Invalid `acres` entry.")
    end

    # try to parse the acres
    try
      repeat_num = parse(Int, repeat)
      if repeat_num >1 
        push!(items, Item("Discount", "scheduled for $repeat_num  month", -5.0))
      end
    catch e
      push!(warnings, "Invalid `repeat` entry. (This shouldn't be possible)")
    end

    # if no errors have occured yet
    if (isempty(warnings))
      est, warning = getEstimate(acre_num, Address(street, city, "AL"))
      push!(items, Item("Basic Lawncare", "a description", est))
      if warning != "" push!(warnings, warning) end
    end

    html(:lawncare, :lawncare, activePage=activePage, street=street, city=city, acres=acres, items=items, warnings=warnings)
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
        return cost(acres, mins), ""
      else 
        @warn item["status"]
        return 0, item["status"]
      end
    else 
      @warn response_data["error_message"]
      return 0, response_data["error_message"]
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

  """
  The cost function for calculating a lawncare estimate
  """
  function cost(acres, mins)
    return lawncare_cost_eq(acres, mins)
  end
end

