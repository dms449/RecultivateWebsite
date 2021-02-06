module HomeController

  using Genie.Renderer.Html
  using Genie.Sessions: session, set!
  using Genie.Router

  

  function homePage()
    #set!(session(Genie.Requests.payload()), :current_page, get_route(:home_page))
    html(:home, :home)
  end
end
