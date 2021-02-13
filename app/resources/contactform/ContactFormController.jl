module ContactFormController
  # Build something great

  using Genie.Renderer.Html
  using Genie.Sessions
  using Genie.Router, Genie.Renderer


  #currentPage::Symbol

  function contactSubmit()

    open("data/myfile.txt", "w") do io
      write(io, @params(:msg))
    end;

    redirect(:home_page)
  end
end
