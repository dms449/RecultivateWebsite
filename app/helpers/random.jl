
"""
if the provided symbol is the the same as the current_page symbol then return 
the string "active". This is used from within html.jl files to add the 'active' 
class to items
"""
function activePage(pageSymbol::Symbol)
  cp = Genie.Sessions.get(Genie.Sessions.session(Genie.Router.@params), :current_page)
  return cp == pageSymbol ? "active-item" : ""
end
