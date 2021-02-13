module ScheduleVisitFormController
  # Build something great
  #

  using Genie.Renderer.Html
  using Genie.Router, Genie.Renderer, Genie.Requests

  function scheduleVisitForm()
    f=payload(:first, "")
    l=payload(:last, "")
    s=payload(:street, "")
    c=payload(:city, "Madison")
    html(:scheduleVisitForm, :scheduleVisitForm, first=f, last=l, street=s, city=c)
  end

  function scheduleVisitSubmit()
    f=payload(:first, "")
    l=payload(:last, "")
    open("schedule_visit-$l_$f.txt", "w") do io
      write(io, @params(:msg))
     end;
     redirect(:lawncare)
  end

end
