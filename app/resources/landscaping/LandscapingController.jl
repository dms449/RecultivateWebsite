module LandscapingController


  using Genie.Sessions, Genie.Router, Genie.Requests
  using Genie.Renderer.Html
  include("../../helpers/random.jl")

  function landscapingPage()
    Sessions.set!(Sessions.session(Requests.payload()), :current_page, :landscaping_page)
    html(:landscaping, :landscaping, activePage=activePage)
  end
end
