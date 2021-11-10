module ScheduleVisitFormController
  # Build something great
  #

  import Gmail: buildEmail, sendEmail
  using Messages
  using Genie.Renderer.Html
  using Genie.Router, Genie.Renderer, Genie.Requests, Genie.Sessions
  using Dates

  function scheduleVisitForm()
    f=payload(:first, "")
    l=payload(:last, "")
    s=payload(:street, "")
    c=payload(:city, "Madison")
    html(:scheduleViitForm, :scheduleVisitForm, first=f, last=l, street=s, city=c)
  end

  function scheduleVisitSubmit()
    try
      first = payload(:first)
      last = payload(:last)
      mi = payload(:mi)
      phone = payload(:phone)
      email = payload(:email)
      contact_preference = payload(:contact_preference)
      message = payload(:msg)

      date = payload(:date, today())
      city = payload(:city)
      state = payload(:state)
      street = payload(:street)
      reason = payload(:reason)

      # msg = Message(first=first, last=last, mi=mi, phone=phone, email=email, contact_preference=contact_preference, message=message)
      # save!(msg)

      # TODO send email
      subject = "Visit Request From: $first $last for $reason"
      msg_body =  "$first $last\ncontact preference: $(contact_preference == String(:email) ? email : format_phone_string(phone)) \nrequested date:  $date \n address: $street $city , $state \n\n $message"
      r = sendEmail(buildEmail("lawncare@recultivate.net", msg_body, subject=subject))

      return redirect(Sessions.get(Sessions.session(Router.params()), :current_page))

    catch e
      flash("contact form failed")
      @warn e
    finally
      return redirect(Sessions.get(Sessions.session(Router.params()), :current_page))
    end
  end
end
