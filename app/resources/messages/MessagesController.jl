module MessagesController

  using Messages

  function index()

    return html(:messages, :messages_index, msgs=all(Message), layout=:employee, context=@__MODULE__)

  end
  # Build something great
end
