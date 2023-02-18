using DifferentialEquations
using Plots

#изначальное расстояние между катером и лодкой
k = 8.1

phi = 3*pi/4

#Правая часть дифф.уравнения
ode_fn(r, p, t) = r/sqrt(9.24)

f(t) = t*tan(phi)

t_begin = 0.0
t_end = pi
tspan_1 = (t_begin, t_end)

tspan_2 = (-pi, 0)

boot_values = fill(sqrt(2)/2,4)

#начальное условие
r_01 = k/2.2
r_02 = k/3.2

prob1 = ODEProblem(ode_fn, r_01, tspan_1)
sol1 = solve(prob1, Tsit5(), reltol=1e-8, abstol=1e-8)

prob2 = ODEProblem(ode_fn, r_02, tspan_2)
sol2 = solve(prob2, Tsit5(), reltol=1e-8, abstol=1e-8)

plot(proj = :polar,
     sol1.t,
     linewidth = 2,
     title = "График погони #1",
     label = "Траектория катера",
     color =:red,
     legend = true)

plot!(boot_values, collect(0:3), linewidth = 2, label="Траектория движения лодки",
color =:blue,
legend=true)

savefig("report/image/chase_1.png")

#=plot(proj = :polar,
     sol2.t,
     linewidth = 2,
     title = "График погони #2",
     label = "Траектория катера",
     color =:red,
     legend = true)

plot!(boot_values, collect(0:3), linewidth = 2, label="Траектория движения лодки",
color =:blue,
legend=true)

savefig("report/image/chase_2.png")

=#