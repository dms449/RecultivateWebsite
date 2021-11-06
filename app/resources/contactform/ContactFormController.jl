module ContactFormController
  # Build something great

  import Gmail: buildEmail, sendEmail
  import GeneralUtils: format_phone_string
  using Genie.Renderer.Html, Genie.Flash
  using Genie.Sessions
  using Genie.Router, Genie.Renderer, Genie.Sessions, Genie.Requests
  using SearchLight
  using Messages
  using ViewHelper


  function new()
    return html(:contactForm, :contactForm)
  end

  function contactFormSubmit()

    try

      first = payload(:first)
      last = payload(:last)
      mi = payload(:mi)
      phone = payload(:phone)
      email = payload(:email)
      contact_preference = payload(:contact_preference)
      message=payload(:msg)

      # msg = Message(first=first, last=last, mi=mi, phone=phone, email=email, contact_preference=contact_preference, message=message)
      # save!(msg)

      # TODO send email
      subject = "Contact Request From: $first $last"
      msg_body =  "$first $last\n$(msg.contact_preference == String(:email) ? email : format_phone_string(phone)) \n $(message)"
      @info "Message: \n'SUBJECT: $subject'"
      r = sendEmail(buildEmail("lawncare@recultivate.net", msg_body, subject=subject))

      return redirect(Sessions.get(Sessions.session(Router.params()), :current_page))

    catch e
      @warn e
    finally
      return redirect(Sessions.get(Sessions.session(Router.params()), :current_page))
    end
  end
end
