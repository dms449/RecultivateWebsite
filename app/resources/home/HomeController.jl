module HomeController

  using Genie.Renderer.Html
  using Genie.Sessions, Genie.Requests, Genie.Router
  import GeneralUtils: format_phone_string
  

  function homePage()
    Sessions.set!(Sessions.session(Router.params()), :current_page, :home_page)
    html(:home, :home)
  end
end
