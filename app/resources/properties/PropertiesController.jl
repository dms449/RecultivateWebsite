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
    return html(:properties, :properties_index, layout=:employee, persons=all(Person), properties=collect(eachrow(properties_df)), activePage=activePage)
  end

  function edit()
    try
      property = SearchLight.findone(Property, id=payload(:id))
      person = SearchLight.findone(Person, id=property.person_id)
      return html(:properties, :property_form, layout=:employee, person=person, property=property, persons=all(Person), activePage=activePage)
    catch e
      @warn e
      redirect(Sessions.get(Sessions.session(Router.params()), :properties_index))
    end
  end

  function new()
    return html(:properties, :property_form, layout=:employee, persons=all(Person), activePage=activePage)
  end


  function create()
    try
      property = Property(
                    address = payload(:address),
                    city = payload(:city),
                    state = payload(:state),
                    zip = payload(:zip),
                    person_id = parse(Int, payload(:person_id)),
                    acres = parse(Float32, payload(:acres))
                    )
      save!(property)
    catch e
      @warn e
    finally
      redirect(:properties_index)
    end
  end

  function update()
    try
      property = SearchLight.findone(Property, id=payload(:id))

      # TODO Check for errors or duplicates
      property.address = payload(:address)
      property.city = payload(:city)
      property.zip = payload(:zip)
      property.person_id = parse(Int, payload(:person_id))
      property.acres = parse(Float32, payload(:acres))
      save!(property)
    catch e
      println(e)
    finally
      redirect(:properties_index)
    end
  end

end
