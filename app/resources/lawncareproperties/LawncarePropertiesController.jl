module LawncarePropertiesController
  # Build something great
  #
  using LawncareProperties
  import GeneralUtils: activePage
  using Genie.Renderer.Html
  using Genie.Router, Genie.Renderer, Genie.Sessions, Genie.Requests
  using SearchLight
  using Properties
  using DataFrames
  using DbTools
  using Persons



  function index()

    lawn_prop_df = SearchLight.query(lawncare_properties_query) |> DataFrame
    return html(:lawncareproperties, :lawncareproperties, layout=:employee, lawn_properties=collect(eachrow(lawn_prop_df)), activePage=activePage)
  end

  function edit()
    try
      lp = SearchLight.find(LawncareProperty, id=payload(:id))
      property = SearchLight.find(Property, id=lp.property_id)
      person = SearchLight.find(Person, id=lp.person_id)
    catch e
      println(e)
      redirect(Sessions.get(Sessions.session(Router.params()), :lawncare_properties_index))
    end

    return html(:lawncareproperties, :lawncareproperty_edit, layout=:employee, person=person, property=property, lp=lp, activePage=activePage)
  end


  function new()
    return html(:lawncareproperties, :lawncareproperty_new, layout=:employee, persons=all(Person), activePage=activePage)
  end


  function create()
    try
      lp = LawncareProperty(
                            property_id = parse(Int, payload(:property_id)),
                            active = parse(Bool, payload(:active)),
                            weeks_between_visits = parse(Int, payload(:weeks)),
                            group_id = parse(Int, payload(:group_id)),
                            cost = parse(Float32, payload(:cost)),
                            payment_method = payload(:payment_method),
                            deck_height = parse(Float32, payload(:deck_height)),
                            weedeat = parse(Bool, payload(:weedeat)),
                            edge = parse(Bool, payload(:edge)),
                            blow = parse(Bool, payload(:blow))
                           )
      save!(lp)
    catch e
      println(e)
    finally
      redirect(Sessions.get(Sessions.session(Router.params()), :lawncare_properties_index))
    end
  end

  function update()
    
  end
end
