module PropertiesController

  using Properties
  using Persons
  using DbTools
  using DataFrames
  using SearchLight
  using Genie.Router, Genie.Renderer, Genie.Sessions, Genie.Requests
  using Genie.Renderer.Html
  import GeneralUtils: activePage

  function index()
    Sessions.set!(Sessions.session(Requests.payload()), :current_page, :properties_index)
    properties_df = SearchLight.query(properties_query) |> DataFrame
    return html(:properties, :properties_index, layout=:employee, person=Person(), property=Property(), persons=all(Person), properties=collect(eachrow(properties_df)), activePage=activePage)
  end

  function edit()
    try
      property = SearchLight.find(Property, id=payload(:id))[1]
      person = SearchLight.find(Person, id=property.person_id)[1]
      return html(:properties, :property_form, layout=:employee, person=person, property=property, persons=all(Person), activePage=activePage)
    catch e
      println(e)
      redirect(Sessions.get(Sessions.session(Router.params()), :properties_index))
    end

  end

  function update()
    try
      property = SearchLight.find(Property, id=payload(:id))[1]

      property.address = payload(:address)
      property.city = payload(:city)
      property.zip = payload(:zip)
      property.acres = parse(Float32, payload(:acres))
      property.person_id = parse(Int, payload(:person_id))
      # lp.property_id = parse(Int, payload(:property_id)),
      # lp.active = parse(Bool, payload(:active)),
      # lp.weeks_between_visits = parse(Int, payload(:weeks)),
      # lp.group_id = parse(Int, payload(:group_id)),
      # lp.cost = parse(Float32, payload(:cost)),
      # lp.payment_method = payload(:payment_method),
      # lp.deck_height = parse(Float32, payload(:deck_height)),
      # lp.weedeat = parse(Bool, payload(:weedeat)),
      # lp.edge = parse(Bool, payload(:edge)),
      # lp.blow = parse(Bool, payload(:blow))
                           
      save!(property)
    catch e
      println(e)
    finally
      redirect(Sessions.get(Sessions.session(Router.params()), :properties_index))
    end
  end

end
