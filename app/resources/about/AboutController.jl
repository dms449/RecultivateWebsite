module AboutController
  # Build something great

  using Genie.Renderer.Html
  #using Genie.Sessions: session, set!

  function aboutPage()
    #set!(session(Genie.Requests.payload()), :current_page, get_route(:about_page))
    html(:about, :about)

  end

end
