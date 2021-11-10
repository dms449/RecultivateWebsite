module EditLawncareController
  using Properties
  using Clients
  using Persons
  using LawncareProperties
  
  # Build something great
  function get_properties_due()
    td = today()
    week_begin = td - Dates.Day(dayofweek(td)%7)
    week_end = week_begin + Dates.Day(6)

    lawn_prop_df = SearchLight.query(lawncare_properties_query) |> DataFrame
    lawn_records_df = SearchLight.query(last_record_query) |> DataFrame
    df = hcat(lawn_prop_df, lawn_records_df)

    df = df[df.active .== 1,:]
    df = df[((week_end.-df.last_visit) .÷ 7) .>= Dates.Day.(df.weeks_between_visits), :]
  end

  function edit_lawncare_page()
    # properties_due = properties_due(conn).address
    properties_due = get_properties_due()
    return html(:dashboard, :dashboard, layout=:employee, properties_due=properties_due)
  end

  function add_lawncare_property_submit()
    
  end

end


