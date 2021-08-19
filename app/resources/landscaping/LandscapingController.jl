module LandscapingController


  using Genie.Sessions, Genie.Router, Genie.Requests
  using Genie.Renderer.Html
  import GeneralUtils: activePage

  function landscapingPage()
    Sessions.set!(Sessions.session(Requests.payload()), :current_page, :landscaping_page)

    imgs = filter(isfile, readdir("./public/img/landscaping/carosel", sort=false, join=true))

    # replace the "./public" part of the path with "/"
    imgs = map(x->joinpath("/", splitpath(x)[3:end]...), imgs)
    html(:landscaping, :landscaping, activePage=activePage, imgs=imgs)
  end


  # function landscapingPortfolioPage()
  #   html(:landscapingPortfolio, :landscapingPortfolio, activePage=activePage, imgs=imgs)
  # end
end
