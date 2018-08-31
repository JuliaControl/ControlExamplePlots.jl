module ControlExamplePlots

using ControlSystems, Plots, VisualRegressionTests

include("genplots.jl")
include("genfigures.jl")

export genfigures

# The path has to be evaluated upon initial import
const __CONTROLEXAMPLEPLOTS_SOURCE_DIR__ = dirname(Base.source_path())

end # module
