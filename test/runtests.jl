# TODO Reenable once https://github.com/sisl/CUDD.jl/issues/15#issuecomment-719958808 is resolved
#include("BDD/BDD.jl")
#include("BDD/test_inttupleset.jl")
include("gol_lazar_belta.jl")
include("./Abstraction/test_griddomain.jl")
include("./Abstraction/test_controlsystemgrowth.jl")
include("./Abstraction/test_controlsystemlinearized.jl")
include("./Abstraction/test_automaton.jl")
include("./Abstraction/test_symbolicmodel.jl")
include("./Abstraction/test_fromcontrolsystemgrowth.jl")
include("./Abstraction/test_fromcontrolsystemlinearized.jl")
include("./Abstraction/test_controller.jl")
include("./Abstraction/test_controllerreach.jl")
include("./Abstraction/test_controllersafe.jl")
