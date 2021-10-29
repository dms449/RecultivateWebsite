module PersonsController
  using Persons
  using DbTools
  using DataFrames
  using SearchLight
  using Genie.Router, Genie.Renderer, Genie.Sessions, Genie.Requests
  using Genie.Renderer.Html
  using Users
  using GenieAuthentication
  export current_user
  # current_user() = findone(Users.User, id = get_authentication())
  # using GenieAuthentication: current_user
  
    

  # Build something great
  function index()
    # Sessions.set!(Sessions.session(Requests.payload()), :current_page, :persons_index)

    # println("current user = $current_user()")
    # persons = all(Person)

    return html(:persons, :persons_index, layout=:employee)
  end

  lawncare_clients = "SELECT * FROM persons 
  INNER JOIN 
    (SELECT DISTINCT(p.person_id)
      FROM properties p 
      INNER JOIN lawncareproperties lp ON lp.property_id=p.id) AS x ON persons.id=x.person_id
    "


  function clients_index()
    clients = SearchLight.query(lawncare_clients)

    persons=all(Person)


  end

  function edit()
    try
      person = SearchLight.findone(Person, id=payload(:person_id))
      if person == nothing 
        @warn "No Person with id=$(payload(:id))"
        # Throw error
      else
        return html(:persons, :person_form, layout=:employee, person=person)
      end
    catch e
      @warn e
      redirect(:persons_index)
    end
  end

  function new()
    return html(:persons, :person_form, layout=:employee)
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
      save!(person)
    catch e
      @warn e
    finally
      redirect(:persons_index)
    end
  end

  function update()
    try
      person = SearchLight.findone(Person, id=payload(:person_id))

      person.first = payload(:first)
      person.last = payload(:last)
      person.mi = payload(:mi)
      person.phone = payload(:phone)
      person.email = payload(:email)
      person.contact_preference = payload(:contact_preference)

      # TODO Check for errors or duplicates
                           
      save!(person)
    catch e
      @warn e
    finally
      redirect(Sessions.get(Sessions.session(Router.params())), :persons_index)
    end
  end
end
