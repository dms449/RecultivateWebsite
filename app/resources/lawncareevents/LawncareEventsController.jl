module LawncareEventsController
  using Genie.Renderer.Html
  using Genie.Sessions
  using Genie.Requests
  using Genie.Router, Genie.Renderer
  using LawncareEvents
  using SearchLight
  using Dates


  function create()
    date_ = Date(payload(:date), DateFormat("y-m-d"))
    lp_id = parse(Int, payload(:lawncare_property_id))
    cost_ = parse(Float32, payload(:cost))
    hours_ = parse(Float32, payload(:hours))
    group_id_ = parse(Int, payload(:group_id))

    error = Missing
    if (hours_ % 0.25 != 0.0)
      error = "Hours must be a multiple of 0.25 (15 minutes)"
    end

    if (error == Missing)
      le = LawncareEvent(date=date_, lawncare_property_id=lp_id, cost=cost_, hours=hours_, group_id=group_id_)
      save!(le)
    end

    # TODO:
    # * if preferred payment method is card, send invoice. If cash, create cash transaction ?
    # * have option for notes
    # * show error msg somewhere if anything is wrong with entry

    # submit time records
    
    redirect(Sessions.get(Sessions.session(Router.params()), :current_page))
  end
end
