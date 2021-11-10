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
  using LawncareTrips

  function index()
    # get lawncare properties
    lp_df = SearchLight.query(lawncare_properties_query)
    lp_df = lp_df[lp_df.active .== 1,:]
    lps = collect(eachrow(lp_df))

    # get contractors
    c_df = collect(eachrow(SearchLight.query(contractors_query)))

    # get mygroup. i.e. the group associated with this person
    mygroup=nothing
    
    return html(:lawncaretrips, :lawncaretrips_index, layout=:employee, lawn_properties=lps, td=today(), groups=all(Group), contractors=c_df, group=mygroup, trips=all(LawncareTrip))
  end

  function edit()
    try
      lawcare_properties = collect(eachrow(SearchLight.query(lawn_events_query)))
      c_df = collect(eachrow(SearchLight.query(contractors_query)))
      trip = SearchLight.findone(LawncareTrip, id=payload(:lt_id))
      stops = SearchLight.query("SELECT * FROM lawncareevents WHERE trip_id=$(payload(:id))")
      time_records = SearchLight.query("SELECT * FROM timerecords WHERE type=1 AND project_id=$(payload(:id))")
      return html(:lawncaretrips, :lawncare_trip_form, layout=:employee, trip=trip, stops=stops, time_records=time_records, groups=all(Group), contractors=c_df)
    catch e
      @warn e
      redirect(Sessions.get(Sessions.session(Router.params()), :properties_index))
    end
  end

  function new()
    c_df = collect(eachrow(SearchLight.query(contractors_query)))
    return html(:lawncaretrips, :lawncaretrip_form, layout=:employee, trip=nothing, stops=[], time_records=[], groups=all(Group), contractors=c_df)
  end

  function create()
    try
      date_ = Date(payload(:date), DateFormat("y-m-d"))
      hours_ = parse(Float32, payload(:hours))
      group_id_ = parse(Int, payload(:group_id))

      error = ""
      if ( 24 < hours_< 0)
        @warn "Hours must be between 0 - 24"
        return redirect(:lawncare_trips_index)
      end
      lt = LawncareTrip(date=date_, hours=hours_, group_id=group_id_)
      save!(lt)
      @info "created LawncareTrip: $lt"


      # for each lawncare property specified, create a lawncare event
      for prop_id in parse.(Int, split(payload(:property_ids), " ")[1:end-1])
         
        prop_cost = parse(Float32, payload(Symbol("$(prop_id)cost")))
        prop_hours = parse(Float32, payload(Symbol("$(prop_id)hours")))
        prop_notes = payload(Symbol("$(prop_id)notes"))

        le = LawncareEvent(lawncare_property_id=prop_id, cost=prop_cost, hours=prop_hours, trip_id=lt.id.value, notes=prop_notes)
        save!(le)
        @info "created LawncareEvent: $le"

      end


      # create time records for any contractors 
      # contractors = collect(eachrow(SearchLight.query(contractors_query)))
      for c in all(Contractor)

        # test if this contractor id was present in the payload as a field
        if Symbol("i$(c.id.value)") ∈ keys(postpayload())
          t = TimeRecord(type=1, project_id=lt.id.value, contractor_id=c.id.value, hours=hours_, date=date_)
          save!(t)
          @info "created TimeRecord: $t"
        end
      end

    catch e
      @warn e
    finally
      return redirect(:lawncare_trips_index)
    end
  end

  function update()
    try
      trip = SearchLight.findone(LawncareTrip, id=payload(:lt_id))

      # person.first = payload(:first)
      # person.last = payload(:last)
      # person.mi = payload(:mi)
      # person.phone = payload(:phone)
      # person.email = payload(:email)
      # person.contact_preference = payload(:contact_preference)

      # TODO Check for errors or duplicates
                           
      # save!(person)
    catch e
      @warn e
    finally
      redirect(:lawncare_trips_index)
    end
  end

end
