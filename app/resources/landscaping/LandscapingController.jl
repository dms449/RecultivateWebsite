module LandscapingController


  using GeneralUtils: getImgsFromDir
  using Genie.Sessions, Genie.Router, Genie.Requests
  using Genie.Renderer.Html


  #
  
  landscapingImgs() = getImgsFromDir("./public/img/landscaping/carosel")
  masonryImgs() = getImgsFromDir("./public/img/landscaping/masonry")


  function landscapingPage()
    Sessions.set!(Sessions.session(Router.params()), :current_page, :landscaping_page)
    html(:landscaping, :landscaping, context=@__MODULE__)
  end

end
