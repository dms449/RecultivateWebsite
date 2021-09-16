module LawncareTripsController
  using Genie.Renderer.Html
  using Genie.Sessions
  using Genie.Requests
  using Genie.Router, Genie.Renderer
  using LawncareEvents
  using TimeRecords
  using SearchLight
  using Contractors
  using Dates
  using Groups
  using DbTools
  import GeneralUtils: activePage

  function index()
    df = SearchLight.query(lawncare_properties_query)
    df = df[df.active .== 1,:]
    lp = collect(eachrow(df))
    return html(:lawncaretrips, :lawncaretrips_index, layout=:employee, lawn_properties=lp, td=today(), groups=all(Group), trip=nothing, activePage=activePage)
  end

  function create()
    try
      date_ = Date(payload(:date), DateFormat("y-m-d"))
      hours_ = parse(Float32, payload(:hours))
      group_id_ = parse(Int, payload(:group_id))

      error = ""
      if ( 24 < hours_< 0)
        @warn "Hours must be between 0 - 24"
        return redirect(:dashboard)
      end


      if (error == "")
        lt = LawncareTrip(date=date_, hours=hours_, group_id=group_id_)
        save!(lt)

        # create time records for any contractors 
        # contractors = collect(eachrow(SearchLight.query(contractors_sql)))
        for c in all(Contractor)

          # test if this contractor id was present in the payload as a field
          if Symbol("i$(c.id.value)") ∈ keys(postpayload())
            t = TimeRecord(type=1, project_id=lt.id.value, contractor_id=c.id.value, hours=hours_, date=date_)
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
