module PortfolioController
  using Genie.Sessions, Genie.Router, Genie.Requests
  using Genie.Renderer.Html
  include("../../helpers/random.jl")

  struct PortfolioProject
    id::String
    title::String
    cost::String
    desc::String
    imgs
  end
  

  function portfolioPage()
    Sessions.set!(Sessions.session(Requests.payload()), :current_page, :portfolio_page)

    project_dirs = filter(isdir, readdir("./public/img/landscaping/portfolio", sort=false, join=true))

    projects = []
    for (i,p) in enumerate(project_dirs)
      info = split(basename(p), '_')
      title = info[1]
      cost = length(info) >= 2 ? info[2] : ""
      imgs = filter(x->isfile(x) && !endswith(x, "txt"), readdir(p, sort=false, join=true))

      # replace the "./public" part of the path with "/"
      imgs = map(x->joinpath("/", splitpath(x)[3:end]...), imgs)

      # load description if it exists
      desc = ""
      try
        desc = isfile(joinpath(p, "desc.txt")) ? read(joinpath(p,"desc.txt"), String) : ""
      catch
        desc = ""
      end
      

      push!(projects, PortfolioProject(repr(i), title, cost, desc, imgs))
    end

    # imgs = [joinpath("/img/landscaping/carosel",basename(p)) for p in imgs]

    html(:portfolio, :portfolio, activePage=activePage, projects=projects)
  end
end
