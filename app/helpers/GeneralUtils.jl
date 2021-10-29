module GeneralUtils

using Genie
using Genie.Sessions, Genie.Requests

export isActivePage
export cities
export payment_methods

cities = ["huntsville", "madison"]
payment_methods = ["cash", "card", "check"]


"""
if the provided symbol is the the same as the current_page symbol then return 
the string "active". This is used from within html.jl files to add the 'active' 
class to items
"""
function isActivePage(pageSymbol::Symbol)
  cp = Genie.Sessions.get(Genie.Sessions.session(Genie.Requests.payload()), :current_page)
  return cp == pageSymbol ? "active-item" : ""
end



end
