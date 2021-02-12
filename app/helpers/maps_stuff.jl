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
  global API_KEY
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
  global API_KEY
  if (API_KEY == "") load_key() end
  return HTTP.request("GET", "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=$(addrToHttp(origin))&destinations=$(addrToHttp(dst))&key=$API_KEY")
end

"""
Get the distance between home and an address
"""
queryDistance(dest::Address) = queryDistance(HOME, dest)



