module ContactFormController
  # Build something great

  using Genie.Renderer.Html
  using Genie.Sessions
  using Genie.Router, Genie.Renderer


  function contactForm()
    return html(:contactForm, :contactForm)
  end

  function contactSubmit()

    open("data/myfile.txt", "w") do io
      write(io, Router.params(:msg))
    end

    redirect(Sessions.get(Sessions.session(Router.params), :current_page))
  end
end
