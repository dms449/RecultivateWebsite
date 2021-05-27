module LandscapingController


  using Genie.Sessions, Genie.Router, Genie.Requests
  using Genie.Renderer.Html
  include("../../helpers/random.jl")

  function landscapingPage()
    Sessions.set!(Sessions.session(Requests.payload()), :current_page, :landscaping_page)

    imgs = filter(isfile, readdir("./public/img/landscaping/carosel", sort=false, join=true))
    imgs = [joinpath("/img/landscaping/carosel",basename(p)) for p in imgs]
    html(:landscaping, :landscaping, activePage=activePage, imgs=imgs)
  end


  function landscapingPortfolioPage()
    html(:landscapingPortfolio, :landscapingPortfolio, activePage=activePage, imgs=imgs)
  end
end
