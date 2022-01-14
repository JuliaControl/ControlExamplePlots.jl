export genplots, getexamples, runplotgen

""" results = runplotgen()
Run full generation of the plots needed for the tests in ControlSystems.jl
"""
function runplotgen()
  funcs, refs, eps = getexamples()
  genplots(funcs, refs, eps=eps)
end

""" results = genplots(funcs, refs; eps, kwargs...)
Generate the plots needed for the tests in ControlSystems.jl
"""
function genplots(funcs, refs; eps=0.01*ones(length(refs)), kwargs...)
    ENV["MPLBACKEND"] = "Agg"
    results = Array{VisualRegressionTests.VisualTestResult,1}(undef, length(refs))
    #Run/generate tests
    for (i,ref) in enumerate(refs)
        testf(fn) = png(funcs[i](), fn)
        results[i] = test_images(VisualTest(testf, ref); tol=eps[i], kwargs...)
    end
    results
end

"""funcs, refs, eps = getexamples()
Get the example functions and locations of reference plots needed for the tests in ControlSystems.jl
"""
function getexamples()
    tf1 = tf([1],[1,1])
    tf2 = tf([1/5,2],[1,1,1])
    sys = [tf1 tf2]
    sysss = ss([-1 2; 0 1], [1 0; 1 1], [1 0; 0 1], [0.1 0; 0 -0.2])

    ws = 10.0 .^range(-2,stop=2,length=200)
    ts = 0:0.01:5
    bodegen() = begin
      setPlotScale("dB")
      bodeplot(sys,ws)
    end
    nyquistgen() = nyquistplot(sysss,ws)
    sigmagen() = sigmaplot(sysss,ws)
    #Only siso for now
    nicholsgen() = nicholsplot(tf1,ws)

    stepgen() = plot(step(sys, ts[end]), l=(:dash, 4))
    impulsegen() = plot(impulse(sys, ts[end]), l=:blue)
    L = lqr(sysss.A, sysss.B, [1 0; 0 1], [1 0; 0 1])
    lsimgen() = plot(lsim(sysss, (x,i)->-L*x, ts; x0=[1;2]))

    margingen() = marginplot([tf1, tf2], ws)
    gangoffourgen() = begin
      setPlotScale("log10");
      gangoffourplot(tf1, [tf(1), tf(5)])
    end
    pzmapgen() = pzmap(tf2, xlims=(-15,5))
    rlocusgen() = rlocusplot(tf2)

    plotsdir = joinpath(dirname(pathof(ControlExamplePlots)), "..", "src", "figures")
    refs = ["bode.png", "nyquist.png", "sigma.png", "nichols.png", "step.png",
            "impulse.png", "lsim.png", "margin.png", "gangoffour.png", "pzmap.png", "rlocus.png"]
    funcs = [bodegen, nyquistgen, sigmagen, nicholsgen, stepgen,
             impulsegen, lsimgen, margingen, gangoffourgen, pzmapgen, rlocusgen]
    eps = 0.001*ones(length(refs));
    funcs, map(s -> joinpath(plotsdir,s), refs), eps
end
