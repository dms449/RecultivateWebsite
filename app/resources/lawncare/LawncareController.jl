module LawncareController
  using Genie.Renderer.Html
  using Genie.Sessions, Genie.Requests, Genie.Router, Genie.Flash
  using Maps
  using JSON
  using ViewHelper
  using HTTP
  include("../../helpers/lawncare_equation.jl")

  #TODO limit number of requests for estimates for each device  per day
  #TODO address autocompletion (https://developers.google.com/maps/documentation/javascript/places-autocomplete)
  #TODO verify address is valid before calculating estimate
  #TODO add warning div for error messages
  #TODO Improve form layout and styling for estimate calculator
  #TODO 'schedule a visit' button
  #TODO route should include the fields for the form

  # a price item (or discount)
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
    state=payload(:state, "AL")
    acres=payload(:acres, "0.25")
    repeat=payload(:repeat, "1")

    warnings = [] 
    items = []

    # try to parse the acres
    acre_num = 0.0
    try
      acre_num = parse(Float32, acres)
    catch e
      # flash( "Invalid `acres` entry.")
      push!(warnings, "Invalid `acres` entry.")
    end

    # try to parse the acres
    try
      repeat_num = parse(Int, repeat)
      if repeat_num >1 
        push!(items, Item("Discount", "scheduled for $repeat_num  month", -5.0))
      end
    catch e
      # flash()
      push!(warnings, "Invalid `repeat` entry. (This shouldn't be possible)")
    end

    # if no errors have occured yet
    if (isempty(warnings) && street!="")
      est = 0.0

      # the address
      addr1 = Address(street, city, state)

      # query googlemaps distance matrix api
      response_data = JSON.parse(HTTP.payload(queryDistance(addr1), String))

      # verify response is ok (did we successfully make a query?)
      if (response_data["status"] == "OK")

        # get the address that google used as the dstination
        # NOTE: this may have been auto corrected by google to a significantly different address
        addr_temp = split(response_data["destination_addresses"][1], ",")
        street = addr_temp[1]
        city = addr_temp[2]
        state = split(addr_temp[3], " ")[1]

        # if its greater than 32 km ≈ 20 mi then it is too far
        if response_data["rows"][1]["elements"][1]["distance"]["value"] < 32000

          # get the first item (Will I ever need anything other than this??)
          item = response_data["rows"][1]["elements"][1]

          # is this element ok? (was it able to locate and calculate for the provided address)
          if (item["status"] == "OK")
            mins = floor(item["duration"]["value"]/60)
            est = cost(acre_num, mins)
            @info "mins=$mins acres=$acre_num est=$est"
          else 
            @warn item["status"]
          end

        else
          push!(warnings, "This address appears to be beyond our current service area. sorry.")
        end
      else 
        @warn response_data["error_message"]
      end

      push!(items, Item("Basic Lawncare", "a description", est))
    end


    if !isempty(items) && sum([each.value for each in items]) > 100
      push!(warnings, "Does this seem too high? These estimates are based on an algorithm and may be less accurate as the distance and size of the property increase. Feel free to contact us for clarification.")
    end

    html(:lawncare, :lawncare, street=street, city=city, acres=acres, items=items, warnings=warnings, context=@__MODULE__)
  end


  """
  Returns the String dollar value and any error message
  """
  function getEstimate(acres::Float32, address::Address)
    response_data = JSON.parse(HTTP.payload(queryDistance(address), String))

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

