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

"""
get the distance between two addresses. 

Assumes driving
"""
function queryDistance(origin::Address, dst::Address) 
  # global API_KEY
  return HTTP.request("GET", "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=$(addrToHttp(origin))&destinations=$(addrToHttp(dst))&key=$(Main.RecultivateNet.API_KEY)")
end

"""
Get the distance between home and an address
"""
queryDistance(dest::Address) = queryDistance(HOME, dest)




