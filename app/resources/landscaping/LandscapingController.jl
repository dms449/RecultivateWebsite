module LandscapingController


  using Genie.Sessions, Genie.Router, Genie.Requests
  using Genie.Renderer.Html
  include("../../helpers/random.jl")

  function landscapingPage()
    Sessions.set!(Sessions.session(Requests.payload()), :current_page, :landscaping_page)

    imgs = filter(isfile, readdir("./public/img", sort=false, join=true))
    imgs = [joinpath("/img",basename(p)) for p in imgs]
    println(imgs)
    html(:landscaping, :landscaping, activePage=activePage, imgs=imgs)
  end
end
