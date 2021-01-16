module HomeController

  using Genie.Renderer.Html

  function homePage()
    html(:home, :home)
  end
end
