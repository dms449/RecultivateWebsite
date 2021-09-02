module PersonsController
  using Persons
  using DbTools
  using DataFrames
  using SearchLight
  using Genie.Router, Genie.Renderer, Genie.Sessions, Genie.Requests
  using Genie.Renderer.Html
  import GeneralUtils: activePage

  I = 10

  # Build something great
  function index()
    pgn = parse(Int32, payload(:pgn, "1"))
    Sessions.set!(Sessions.session(Requests.payload()), :current_page, :persons_index)
    # properties_df = SearchLight.query("SELECT * FROM persons") |> DataFrame
    persons = all(Person)
    num_pages = (length(persons) ÷ I) + 1

    if num_pages < pgn < 1
      @warn "invalid page number. pages range from 1-$num_pages"
      pgn = pgn < 1 ? 1 : num_pages
    end

    # get the index range for this page
    idx2 = pgn == num_pages ? length(persons) : pgn*I+1
    idx1 = (pgn*I+1-I)
    return html(:persons, :persons_index, layout=:employee, num_pages=num_pages, pgn=pgn, persons=persons[idx1:idx2], activePage=activePage)
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
