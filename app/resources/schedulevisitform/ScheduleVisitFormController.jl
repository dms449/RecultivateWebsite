module ScheduleVisitFormController
  # Build something great
  #

  using Genie.Renderer.Html
  using Genie.Router, Genie.Renderer

  function scheduleVisitForm()
    html(:scheduleVisitForm, :scheduleVisitForm)
  end

  function scheduleVisitSubmit()
    open("$(@params(:first)).txt", "w") do io
      write(io, @params(:last))
     end;
     redirect(:lawncare)
  end

end
