module HomeController

  using Genie.Renderer.Html
  using Genie.Sessions, Genie.Requests, Genie.Router
  include("../../helpers/random.jl")
  

  function homePage()
    Sessions.set!(Sessions.session(Requests.payload()), :current_page, :home_page)
    #sess = Sessions.session(Genie.Requests.payload())
    #Sessions.set!(sess, :current_page, Router.get_route(:home_page))
    #println("Current page = $(Sessions.get(sess, :current_page))")
    html(:home, :home, activePage=activePage)
  end
end
