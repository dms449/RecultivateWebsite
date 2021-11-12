module GeneralUtils

using Genie
using Genie.Sessions, Genie.Requests
using Genie.Router
import Base: @kwdef

export isActivePage
export @activePage
export cities
export payment_methods
export getImgsFromDir, Img
export format_phone_string


@kwdef mutable struct Img
  path::AbstractString = "not_a_path"
  title::String = ""
  desc::String = ""
end


cities = ["huntsville", "madison"]
payment_methods = ["cash", "card", "check"]

function format_phone_string(phone_string::String)
  rs = r"^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$"
  # rs = r"^\s*((?<country>:\+)(?<area>(\d{1,3})))(?<exchange>[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4}))(?<subscriber>: *x(\d+))(?<ex>\s*)$"
  m = match(rs, phone_string) 
  if m== nothing
    @info "str '$phone_string' is not a valid phone number format"
    return nothing
  else
    return "($(m[:2])) $(m[:3])-$(m[:4])"
  end
end

function getImgsFromDir(imgdir::AbstractString; extensions=[".jpg", ".png"])
  imgs = filter(x->isfile(x) && (splitext(x)[end] ∈ extensions), readdir(imgdir, sort=false, join=true))
  imgs = map(x->Img(path=joinpath("/", splitpath(x)[3:end]...)), imgs)
  return imgs
end


"""
if the provided symbol is the the same as the current_page symbol then return 
the string "active". This is used from within html.jl files to add the 'active' 
class to items
"""
function isActivePage(pageSymbol::Symbol)
  cp = Genie.Sessions.get(Genie.Sessions.session(Requests.payload()), :active_page)
  return cp == pageSymbol ? "active-item" : ""
end


macro activePage(ex)
  # local route_symbol = nothing
  # for arg in ex.args
  #   if typeof(arg) == Expr
  #     if arg.head == :kw && arg.args[1]==:named
  #       route_symbol = arg.args[2]
  #     end
  #   end
  # end
  dump(ex)
  # return :(Sessions.set!(Sessions.session(Router.params()), :active_page, route_symbol))
  return ex
end

end
