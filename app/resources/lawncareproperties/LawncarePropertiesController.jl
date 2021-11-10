module LawncarePropertiesController
  # Build something great
  #
  using LawncareProperties
  using Genie.Renderer.Html
  using Genie.Router, Genie.Renderer, Genie.Sessions, Genie.Requests
  using SearchLight
  using Properties
  using DataFrames
  using DbTools
  using Persons
  using Groups


  function index()
    Sessions.set!(Sessions.session(Requests.payload()), :current_page, :lawncareproperties_index)
    lp_id = payload(:lp_id)
    println(lp_id)
    if (lp_id != nothing)

    end
    lawn_prop_df = SearchLight.query(lawncare_properties_query) 
    groups = SearchLight.query("SELECT id FROM groups").id
    return html(:lawncareproperties, :lawncareproperties_index, layout=:employee, lp=nothing, property=nothing, properties=all(Property), group=nothing, groups=all(Group), payment_methods=["cash", "card","check"], lawn_properties=collect(eachrow(lawn_prop_df)))
  end

  function clients_index()
    lawn_prop_df = SearchLight.query(lawncare_properties_query) 
    return html()

  end

  function edit()
    try
      lp = SearchLight.findone(LawncareProperty, id=payload(:lp_id))
      property = SearchLight.findone(Property, id=lp.property_id)
      return html(:lawncareproperties, :lawncareproperty_form, layout=:employee, lp=lp, property=property, properties=all(Property), groups=[1,2], payment_methods=instances(PaymentMethods))
    catch e
      @warn e
      return redirect(:lawncare_properties_index)
    end

  end


  function new()
    return html(:lawncareproperties, :lawncareproperty_form, layout=:employee, lp=nothing, properties=all(Property), groups=[1,2], payment_methods=instances(PaymentMethods))
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
      @warn e
    finally
      redirect(:lawncare_properties_index)
    end
  end

  function update()
    try
      lp = SearchLight.find(LawncareProperty, id=payload(:lp_id))

      lp.property_id = parse(Int, payload(:property_id))
      lp.active = parse(Bool, payload(:active))
      lp.weeks_between_visits = parse(Int, payload(:weeks))
      lp.group_id = parse(Int, payload(:group_id))
      lp.cost = parse(Float32, payload(:cost))
      lp.payment_method = payload(:payment_method)
      lp.deck_height = parse(Float32, payload(:deck_height))
      lp.weedeat = parse(Bool, payload(:weedeat))
      lp.edge = parse(Bool, payload(:edge))
      lp.blow = parse(Bool, payload(:blow))
                           
      save!(lp)
    catch e
      println(e)
    finally
      redirect(Sessions.get(Sessions.session(Router.params()), :lawncare_properties_index))
    end
    
  end
end
