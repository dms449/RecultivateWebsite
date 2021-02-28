using Plots
plotly()


"""

"""
function lawncare_cost_eq(acres, mins)::Float32
  #return 20*(acres-0.25)^2 + mins*(1.5+atan(mins-)) + 35
  return Float32(20*(acres-0.25)^2 + mins^(4/3) + 35)
end

function show()
  acres = 0.2:0.1:2.0
  mins = 0:1:30

  cost = zeros(length(acres), length(mins))
  for (i,a) in enumerate(acres)
    cost[i,:] = lawncare_cost_eq.(a, mins)
  end

  p1 = plot(acres, lawncare_cost_eq.(acres, 0), title="acres vs cost", xlabel="acres", ylabel=raw"$")
  p2 = plot(mins, lawncare_cost_eq.(0., mins), title="distance vs cost", xlabel="distance (mins)", ylabel=raw"$")
  p3 = heatmap(mins, acres, cost, title="Cost", xlabel="distance", ylabel="acres")
  l = @layout [a b ; c]
  plot(p1, p2, p3, layout=l, size=(1200, 800))
end
