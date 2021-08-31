module DashboardController

  # Build something great
  using Genie.Renderer.Html
  using Genie.Sessions
  using Genie.Router, Genie.Renderer, Genie.Sessions, Genie.Requests
  using SearchLight
  using Properties
  using DataFrames
  using DbTools
  using Dates
  using LawncareEvents
  import GeneralUtils: activePage

  export get_properties_due


  function get_properties_due()
    td = today()
    week_begin = td - Dates.Day(dayofweek(td)%7)
    week_end = week_begin + Dates.Day(6)

    df = SearchLight.query(lawn_events_sql)
    df = df[df.active .== 1,:]
    new_properties = df[ismissing.(df.last_visit),:]
    others = dropmissing(df, :last_visit) 
    properties_due = others[((week_end.-others.last_visit) .÷ 7) .>= Dates.Day.(others.weeks_between_visits), :]
    return vcat(new_properties, properties_due)
  end



  function build_client_string(df::DataFrame)
    return df.first .* " " .* df.last .* " - " .* df.address .* ", " .* df.city
  end


  function dashboard()
    Sessions.set!(Sessions.session(Requests.payload()), :current_page, :employee_dashboard)
    # properties_due = properties_due(conn).address
    properties_due = collect(eachrow(get_properties_due()))
    error = payload(:error, "")

    # get all groups
    groups = collect(unique(SearchLight.query("select `group_id` from contractors").group_id))
    return html(:dashboard, :dashboard, layout=:employee, properties_due=properties_due, td=today(), groups=groups, error=error, activePage=activePage)
  end


end
