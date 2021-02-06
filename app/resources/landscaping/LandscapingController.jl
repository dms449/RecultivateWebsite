module LandscapingController


  using Genie.Sessions: session, set!
  using Genie.Renderer.Html

  function landscapingPage()
    #set!(session(Genie.Requests.payload()), :current_page, get_route(:landscaping_page))
    html(:landscaping, :landscaping)
  end
end
