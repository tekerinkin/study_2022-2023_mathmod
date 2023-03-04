using DifferentialEquations
using Plots

function ode_fn_1(du, u, p, t)
    x, y = u
    du[1] = y
    du[2] = -2*x
end

t_begin = 0.0
t_end = 44
tspan = (t_begin, t_end)

#Initial condition
x_init = 1.5
y_init = 1.1

prob1 = ODEProblem(ode_fn_1, [x_init, y_init], tspan)

sol1 = solve(prob1, Tsit5(), reltol=1e-16, abstol=1e-16)
x_sol_1 = [u[1] for u in sol1.u]
y_sol_1 = [u[2] for u in sol1.u]

plot(x_sol_1, y_sol_1, 
    linewidth = 2,
    title = "Фазовый портрет №1",
    xaxis = "x",
    yaxis = "y",
    legend = false)
savefig("report/image/First.png")

unction ode_fn_2(du, u, p, t)
    x, y = u
    du[1] = y
    du[2] = -3*x - 3*y 
end

t_begin = 0.0
t_end = 44
tspan = (t_begin, t_end)

#Initial condition
x_init = 1.5
y_init = 1.1

prob1 = ODEProblem(ode_fn_2, [x_init, y_init], tspan)

sol1 = solve(prob1, Tsit5(), reltol=1e-16, abstol=1e-16)
x_sol_1 = [u[1] for u in sol1.u]
y_sol_1 = [u[2] for u in sol1.u]

plot(x_sol_1, y_sol_1, 
    linewidth = 2,
    title = "Фазовый портрет №2",
    xaxis = "x",
    yaxis = "y",
    legend = false)

savefig("report/image/Second.png")

function ode_fn_3(du, u, p, t)
    x, y = u
    du[1] = y
    du[2] = -3*x - 3*y - sin(4*t)
end

t_begin = 0.0
t_end = 44
tspan = (t_begin, t_end)

#Initial condition
x_init = 1.5
y_init = 1.1

prob1 = ODEProblem(ode_fn_3, [x_init, y_init], tspan)

sol1 = solve(prob1, Tsit5(), reltol=1e-16, abstol=1e-16)
x_sol_1 = [u[1] for u in sol1.u]
y_sol_1 = [u[2] for u in sol1.u]

plot(x_sol_1, y_sol_1, 
    linewidth = 2,
    title = "Фазовый портрет №3",
    xaxis = "x",
    yaxis = "y",
    legend = false)
savefig("report/image/Third.png")