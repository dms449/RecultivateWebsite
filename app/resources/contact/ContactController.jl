module ContactController
  # Build something great

  using Genie.Renderer.Html
  using Genie.Router, Genie.Renderer


  function contactPage()
    html(:contact, :contact)
  end

  function contact()
    open("myfile.txt", "w") do io
      write(io, @params(:msg))
     end;
  end
end
