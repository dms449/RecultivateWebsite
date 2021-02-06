module ContactFormController
  # Build something great

  using Genie.Renderer.Html
  using Genie.Sessions
  using Genie.Router, Genie.Renderer


  #currentPage::Symbol

  function contactSubmit()

    open("myfile.txt", "w") do io
      write(io, @params(:msg))
    end;

    redirect(get(session(), :current_page))
  end
end
