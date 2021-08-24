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
    Sessions.set!(Sessions.session(Requests.payload()), :current_page, :lawncareproperties_index)
    lawn_prop_df = SearchLight.query(lawncare_properties_query) |> DataFrame
    return html(:lawncareproperties, :lawncareproperties_index, layout=:employee, lp=LawncareProperty(), property=Property(), properties=all(Property), groups=[1,2], payment_methods=["cash", "card","check"], lawn_properties=collect(eachrow(lawn_prop_df)), activePage=activePage)
  end

  function edit()
    try
      lp = SearchLight.find(LawncareProperty, id=payload(:id))[1]
      property = SearchLight.find(Property, id=lp.property_id)[1]
      @info "id=$(property.id) address = $(property.address)"
      return html(:lawncareproperties, :lawncareproperty_form, layout=:employee, lp=lp, property=property, properties=all(Property), groups=[1,2], payment_methods=instances(PaymentMethods), activePage=activePage)
    catch e
      println(e)
      return redirect(Sessions.get(Sessions.session(Router.params())), :lawncare_properties_index)
    end

  end


  function new()
    lp = LawncareProperty()

    return html(:lawncareproperties, :lawncareproperty_form, layout=:employee, lp=lp, properties=all(Property), groups=[1,2], payment_methods=instances(PaymentMethods), activePage=activePage)
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
    try
      lp = SearchLight.find(LawncareProperty, id=payload(:id))

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
                           
      # save!(lp)
    catch e
      println(e)
    finally
      redirect(Sessions.get(Sessions.session(Router.params()), :lawncare_properties_index))
    end
    
  end
end
