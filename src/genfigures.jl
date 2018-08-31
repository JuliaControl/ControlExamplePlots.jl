using Plots

# Regenerate the test figures
function genfigures()
    funcs, refs, eps = getexamples()
    (s,) = size(funcs)
    for i = 1:s
        info(refs[i])
        png(funcs[i](), refs[i])
    end
end
