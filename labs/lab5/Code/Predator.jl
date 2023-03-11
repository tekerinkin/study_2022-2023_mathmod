using Plots
  using DifferentialEquations

  function ode_fn_1(du, u, p, t)
    x, y = u
    du[1] = -0.59*x + 0.058*x*y
    du[2] = 0.57*y - 0.056*x*y
  end

  t_begin = 0.0
  t_end = 44
  tspan = (t_begin, t_end)

  #Initial condition
  x_init = 8
  y_init = 18

  prob1 = ODEProblem(ode_fn_1, [x_init, y_init], tspan)

  sol1 = solve(prob1, Tsit5(), reltol=1e-16, abstol=1e-16)
  x_sol_1 = [u[1] for u in sol1.u]
  y_sol_1 = [u[2] for u in sol1.u]

  plot(x_sol_1, y_sol_1, 
      linewidth = 2,
      title = "Зависиость числа хищников от числа жертв",
      xaxis = "x",
      yaxis = "y",
      legend = false)
  savefig("report/image/x_y.png")

  plot(sol1.t, x_sol_1, 
    linewidth = 2,
    title = "Изменение числа хищников",
    xaxis = "t",
    yaxis = "x(t)",
    label = "Число хищников x(t)",
    legend = true)
  savefig("report/image/x.png")

  plot(sol1.t, y_sol_1, 
    linewidth = 2,
    title = "Изменение числа хищников",
    xaxis = "t",
    yaxis = "y(t)",
    label = "Число хищников y(t)",
    legend = true)
  savefig("report/image/y.png")
