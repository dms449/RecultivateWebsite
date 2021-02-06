using HTTP
using JSON

struct Address
  street::String
  city::String
  state::String
end

addrToHttp(addr::Address) = "$(replace(addr.street, " "=>"+"))+$(addr.city),$(addr.state)" 

# define the home address
const HOME = Address("1004 Arnold Rd", "Madison", "AL")
API_KEY = ""

"""

"""
function load_key(path="recultivate_google_api_key.txt")
  open(path, "r") do io
    API_KEY = read(io, String)
  end
  if (API_KEY == "")
    @warn "Failed to load api key at `$path`"
  end
end

"""
get the distance between two addresses. 

Assumes driving
"""
function queryDistance(origin::Address, dst::Address) 
  if (API_KEY == "") load_key() end
  return HTTP.request("GET", "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=$(addrToHttp(origin))&destinations=$(addrToHttp(dst))&key=$API_KEY")
end

"""
Get the distance between home and an address
"""
queryDistance(dest::Address) = queryDistance(HOME, dest)

"""
Extract the number of minutes (rounded down to the nearest minute)
"""
function getDistanceMins(response::HTTP.Messages.Response)
  j = JSON.parse(String(response.body))
  seconds = j["rows"][1]["elements"][1]["duration"]["value"]
  return floor(seconds/60)
end


