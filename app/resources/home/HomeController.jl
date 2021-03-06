module HomeController

  using Genie.Renderer.Html
  using Genie.Sessions, Genie.Requests, Genie.Router
  include("../../helpers/random.jl")
  

  function homePage()
    Sessions.set!(Sessions.session(Requests.payload()), :current_page, :home_page)
    html(:home, :home, activePage=activePage)
  end
end
