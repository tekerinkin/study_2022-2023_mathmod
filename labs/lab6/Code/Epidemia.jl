using Plots
using DifferentialEquations

α = 0.01
β = 0.02
N = 10100
I_0 = 66
R_0 = 26

S_0 = N - I_0 - R_0

# I < I*
function ode_fn_1(du, u, p, t)
    x,y,z = u 
    du[1] = 0*x
    du[2] = -β*y
    du[3] = β*y
end

t_begin = 0.0
t_end = 200
tspan = (t_begin, t_end)

prob1 = ODEProblem(ode_fn_1, [S_0, I_0, R_0], tspan)

sol1 = solve(prob1, Tsit5(), reltol=1e-16, abstol=1e-16)
x_sol_1 = [u[1] for u in sol1.u]
y_sol_1 = [u[2] for u in sol1.u]
z_sol_1 = [u[3] for u in sol1.u]

plot(sol1.t, x_sol_1, 
    linewidth = 2,
    title = "Графики числа S(t), I(t), R(t) при I < I*",
    label = "S(t)",
    legend = true)
plot!(sol1.t, y_sol_1,
     linewidth = 2,
     label = "I(t)",
     legend = true)
plot!(sol1.t, z_sol_1, 
     linewidth = 2,
     label = "R(t)",
     legend = true)
savefig("report/image/1.png")

plot(sol1.t, y_sol_1,
     linewidth = 2,
     label = "I(t)",
     legend = true)
plot!(sol1.t, z_sol_1, 
     linewidth = 2,
     label = "R(t)",
     legend = true)
savefig("report/image/2.png")

function ode_fn_2(du, u, p, t)
    x,y,z = u 
    du[1] = -α*x
    du[2] = α*x-β*y
    du[3] = β*y
end

prob2 = ODEProblem(ode_fn_2, [S_0, I_0, R_0], tspan)

sol2 = solve(prob2, Tsit5(), reltol=1e-16, abstol=1e-16)
x_sol_2 = [u[1] for u in sol2.u]
y_sol_2 = [u[2] for u in sol2.u]
z_sol_2 = [u[3] for u in sol2.u]

plot(sol2.t, x_sol_2, 
    linewidth = 2,
    title = "Графики числа S(t), I(t), R(t) при I > I*",
    label = "S(t)",
    legend = true)
plot!(sol2.t, y_sol_2,
     linewidth = 2,
     label = "I(t)",
     legend = true)
plot!(sol2.t, z_sol_2, 
     linewidth = 2,
     label = "R(t)",
     legend = true)
savefig("report/image/3.png")
