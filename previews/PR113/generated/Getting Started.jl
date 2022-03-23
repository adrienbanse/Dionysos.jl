using Dionysos
using StaticArrays
using LinearAlgebra
using PyPlot

include("../../../src/plotting.jl")

const AB = Dionysos.Abstraction;

rectX = AB.HyperRectangle(SVector(-2, -2), SVector(2, 2));
rectU = AB.HyperRectangle(SVector(-5), SVector(5));

x0 = SVector(0.0, 0.0);
h = SVector(1.0/5, 1.0/5);
Xgrid = AB.GridFree(x0, h);

domainX = AB.DomainList(Xgrid);
AB.add_set!(domainX, rectX, AB.INNER)

u0 = SVector(0.0);
h = SVector(1.0/5);
Ugrid = AB.GridFree(u0, h);
domainU = AB.DomainList(Ugrid);
AB.add_set!(domainU, rectU, AB.INNER);

tstep = 0.1;
nsys=10; # Runge-Kutta pre-scaling


A = SMatrix{2,2}(0.0, 1.0,
                -3.0, 1.0);
B = SMatrix{2,1}(0.0, 1.0);

F_sys = let A = A
    (x,u) -> A*x + B*u
end;

ngrowthbound=10; # Runge-Kutta pre-scaling
A_diag = diagm(diag(A));
A_abs = abs.(A) - abs.(A_diag) + A_diag
L_growthbound = x -> abs.(A)

measnoise = SVector(0.0, 0.0);
sysnoise = SVector(0.0, 0.0);

contsys = AB.NewControlSystemGrowthRK4(tstep, F_sys, L_growthbound, sysnoise,
                                       measnoise, nsys, ngrowthbound);

symmodel = AB.NewSymbolicModelListList(domainX, domainU);

AB.compute_symmodel_from_controlsystem!(symmodel, contsys)

xpos = AB.get_pos_by_coord(Xgrid, SVector(1.1, 1.3))
upos = AB.get_pos_by_coord(Ugrid, SVector(-1))

x = AB.get_coord_by_pos(Xgrid, xpos)
u = AB.get_coord_by_pos(Ugrid, upos)

post = Int[]
AB.compute_post!(post, symmodel.autom, symmodel.xpos2int[xpos], symmodel.upos2int[upos])

domainPostx = AB.DomainList(Xgrid);
for pos in symmodel.xint2pos[post]
    AB.add_pos!(domainPostx,pos)
end

PyPlot.pygui(true)
fig = PyPlot.figure()

ax = PyPlot.axes(aspect = "equal")
ax.set_xlim(-2, 2)
ax.set_ylim(-2, 2)

vars = [1, 2];
Plot.domain!(ax, vars, domainX, fc = "white")
Plot.cell!(ax, vars, Xgrid, xpos, fc = "blue")
Plot.domain!(ax, vars, domainPostx, fc = "green")

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

