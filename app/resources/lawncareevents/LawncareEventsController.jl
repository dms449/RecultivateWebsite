module LawncareEventsController
  using Genie.Renderer.Html
  using Genie.Sessions
  using Genie.Requests
  using Genie.Router, Genie.Renderer
  using LawncareEvents
  using TimeRecords
  using SearchLight
  using Contractors
  using Dates


  function create()
    try
      date_ = Date(payload(:date), DateFormat("y-m-d"))
      lp_id = parse(Int, payload(:lawncare_property_id))
      cost_ = parse(Float32, payload(:cost))
      hours_ = parse(Float32, payload(:hours))
      trip_id_ = parse(Int, payload(:trip_id))
      notes_ = payload(:notes, "")

      error = ""
      if ( 24 < hours_< 0)
        @warn "Hours must be between 0 - 24"
        return redirect(:dashboard)
      end


      if (error == "")
        le = LawncareEvent(date=date_, lawncare_property_id=lp_id, cost=cost_, hours=hours_, trip_id=trip_id_, notes=notes_)
        save!(le)
      end
    catch e
      @warn e
    finally
      return redirect(:dashboard)
    end
  end

end
