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
      group_id_ = parse(Int, payload(:group_id))
      notes_ = payload(:notes, "")

      error = ""
      if (hours_ % 0.25 != 0.0)
        @warn "Hours must be a multiple of 0.25 (15 minutes)"
        return redirect(:dashboard)
      end


      if (error == "")
        le = LawncareEvent(date=date_, lawncare_property_id=lp_id, cost=cost_, hours=hours_, group_id=group_id_, notes=notes_)
        save!(le)

        # create time records for any contractors 
        # contractors = collect(eachrow(SearchLight.query(contractors_sql)))
        for c in all(Contractor)

          # test if this contractor id was present in the payload as a field
          if Symbol("i$(c.id.value)") ∈ keys(postpayload())
            t = TimeRecord(type=1, project_id=le.id.value, contractor_id=c.id.value, hours=hours_, date=date_, notes=notes_)
            save!(t)
          end
        end
      end
    catch e
      @warn e
    finally
      return redirect(:dashboard)
    end
  end

end
