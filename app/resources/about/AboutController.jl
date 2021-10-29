module AboutController
  # Build something great

  using Genie.Renderer.Html
  using Genie.Sessions, Genie.Requests

  function aboutPage()
    Sessions.set!(Sessions.session(Requests.payload()), :current_page, :about_page)
    #set!(session(Genie.Requests.payload()), :current_page, get_route(:about_page))
    html(:about, :about)

  end

end
