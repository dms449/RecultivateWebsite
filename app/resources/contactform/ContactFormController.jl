module ContactFormController
  # Build something great

  using Genie.Renderer.Html
  using Genie.Sessions
  using Genie.Router, Genie.Renderer, Genie.Sessions, Genie.Requests
  using SearchLight
  using Messages


  function new()
    return html(:contactForm, :contactForm)
  end

  function contactFormSubmit()

    try
      msg = Message(
                    first = payload(:first),
                    last = payload(:last),
                    mi = payload(:mi),
                    phone = payload(:phone),
                    email = payload(:email),
                    contact_preference = payload(:contact_preference),
                    message=payload(:msg))
      save!(msg)

      redirect(Sessions.get(Sessions.session(Router.params()), :current_page))

    catch e
      @warn e
    finally
      redirect(Sessions.get(Sessions.session(Router.params()), :current_page))
    end
  end
end
