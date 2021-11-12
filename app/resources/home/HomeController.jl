module HomeController

  using Genie.Renderer.Html
  using Genie.Sessions, Genie.Requests, Genie.Router
  import GeneralUtils: format_phone_string
  

  function homePage()
    Sessions.set!(Sessions.session(Requests.payload()), :current_page, :home_page)
    html(:home, :homepage)
  end
end
