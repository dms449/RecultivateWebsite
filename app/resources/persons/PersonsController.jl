module PersonsController
  using Persons
  using DbTools
  using DataFrames
  using SearchLight
  using Genie.Router, Genie.Renderer, Genie.Sessions, Genie.Requests
  using Genie.Renderer.Html
  import GeneralUtils: activePage

  # Build something great
  function index()
    Sessions.set!(Sessions.session(Requests.payload()), :current_page, :persons_index)
    # properties_df = SearchLight.query("SELECT * FROM persons") |> DataFrame
    return html(:persons, :persons_index, layout=:employee, persons=all(Person), activePage=activePage)
  end

  function edit()
    try
      person = SearchLight.findone(Person, id=payload(:id))
      if person == nothing 
        @warn "No Person with id=$(payload(:id))"
        # Throw error
      else
        return html(:persons, :person_form, layout=:employee, person=person, activePage=activePage)
      end
    catch e
      @warn e
      redirect(:persons_index)
    end
  end

  function new()
    return html(:persons, :person_form, layout=:employee, activePage=activePage)
  end


  function create()
    try
      person = Person(
                      first = payload(:first),
                      last = payload(:last),
                      mi = payload(:mi),
                      phone = payload(:phone),
                      email = payload(:email),
                      contact_preference = payload(:contact_preference)
                      )
      save!(lp)
    catch e
      @warn e
    finally
      redirect(:persons_index)
    end
  end

  function update()
    try
      person = SearchLight.findone(Person, id=payload(:id))

      person.first = payload(:first)
      person.last = payload(:last)
      person.mi = payload(:mi)
      person.phone = payload(:phone)
      person.email = payload(:email)
      person.contact_preference = payload(:contact_preference)

      # TODO Check for errors or duplicates
                           
      save!(property)
    catch e
      @warn e
    finally
      redirect(:persons_index)
    end
  end
end
