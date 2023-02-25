using DifferentialEquations
using Plots

function ode_fn_1(du, u, p, t)
    x, y = u
    du[1] = -0.301*x - 0.7*y + sin(20*t) + 1
    du[2] = -0.502*x*y - 0.4*y + cos(20*t) + 1
end

t_begin = 0.0
t_end = 0.001
tspan = (t_begin, t_end)

#Initial condition
x_init = 39800
y_init = 21400

prob1 = ODEProblem(ode_fn_1, [x_init, y_init], tspan)

sol1 = solve(prob1, Tsit5(), reltol=1e-16, abstol=1e-16)
x_sol_1 = [u[1] for u in sol1.u]
y_sol_1 = [u[2] for u in sol1.u]

plot(sol1.t, x_sol_1, 
     linewidth=2,
     title = "Модель боевых действий №2",
     xaxis="Время",
     yaxis="Численность армий",
     label="Армия X",
     legend=true)

plot!(sol1.t, y_sol_1,
      linewidht = 2,
      label = "Армия Y",
      legend = true)

savefig("image/model2.png")

function ode_fn(du, u, p, t)
    x, y = u
    du[1] = -0.42*x - 0.68*y + sin(5*t+1)
    du[2] = -0.59*x - 0.43*y + cos(5*t+2)
end

t_begin = 0.0
t_end = 1.5
tspan = (t_begin, t_end)

#Initial condition
x_init = 39800
y_init = 21400

prob = ODEProblem(ode_fn, [x_init, y_init], tspan)

sol = solve(prob, Tsit5(), reltol=1e-8, abstol=1e-8)
x_sol = [u[1] for u in sol.u]
y_sol = [u[2] for u in sol.u]

plot(sol.t, x_sol,
     linewidth=2,
     title = "Модель боевых действий №1",
     xaxis="Время",
     yaxis="Численность армий",
     label="Армия X",
     legend=true)

plot!(sol.t, y_sol,
      linewidht = 2,
      label = "Армия Y",
      legend = true)
savefig("image/model1.png")
