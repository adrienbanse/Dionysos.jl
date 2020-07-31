include("../src/abstraction.jl")

module TestMain

using Test
using Main.Abstraction
AB = Main.Abstraction

sleep(0.1) # used for good printing
println("Started test")

@testset "SymbolicModel" begin
x0 = (0.0, 0.0)
h = (1.0, 2.0)
X_grid = AB.NewGridSpaceHash(x0, h)
Y_sub = AB.NewSubSet(X_grid)
AB.add_to_subset_by_ref!(Y_sub, 10)
AB.add_to_subset_by_ref!(Y_sub, 45)
display(Y_sub)

u0 = (0.0,)
h = (0.5,)
U_grid = AB.NewGridSpaceHash(u0, h)

sym_model = AB.NewSymbolicModelHash(X_grid, U_grid, X_grid)
AB.add_to_symmodel_by_refs!(sym_model, 5, 6, 9)
AB.add_to_symmodel_by_refs!(sym_model, 5, 6, 10)
AB.add_to_symmodel_by_refs!(sym_model, 5, 7, 45)
AB.add_to_symmodel_by_refs!(sym_model, 15, 6, 45)
AB.add_to_symmodel_by_refs!(sym_model, 5, 6, 5)
AB.add_to_symmodel_by_refs!(sym_model, 15, 7, 45)
display(sym_model)

zref_coll = AB.get_gridspace_reftype(X_grid)[]
uref_coll = AB.get_gridspace_reftype(U_grid)[]

AB.add_images_by_xref_uref!(zref_coll, sym_model, 5, 6)
display(zref_coll)
@test length(zref_coll) == 3
AB.add_images_by_xref_uref!(zref_coll, sym_model, 15, 6)
display(zref_coll)
AB.add_images_by_xref_uref!(zref_coll, sym_model, 15, 5)
display(zref_coll)
@test length(zref_coll) == 4

AB.add_inputs_by_xref_ysub!(uref_coll, sym_model, 5, Y_sub)
display(uref_coll)
@test length(uref_coll) == 1
AB.add_inputs_by_xref_ysub!(uref_coll, sym_model, 15, Y_sub)
display(uref_coll)
@test length(uref_coll) == 3
AB.add_to_subset_by_ref!(Y_sub, 9)
AB.add_to_subset_by_ref!(Y_sub, 5)
AB.add_inputs_by_xref_ysub!(uref_coll, sym_model, 5, Y_sub)
display(uref_coll)
@test length(uref_coll) == 5
end

sleep(0.1) # used for good printing
println("End test")

end  # module TestMain