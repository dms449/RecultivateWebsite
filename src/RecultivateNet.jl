module RecultivateNet

using Logging, LoggingExtras

function main()
  Base.eval(Main, :(const UserApp = RecultivateNet))

  include(joinpath("..", "genie.jl"))

  Base.eval(Main, :(const Genie = RecultivateNet.Genie))
  Base.eval(Main, :(using Genie))
end; main()

end
