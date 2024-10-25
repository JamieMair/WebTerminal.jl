module WebTerminal
using Pkg
using Pkg.Artifacts

function ttyd_path()
    if Sys.isapple()
        @info "Running on macOS. Checking for installed `ttyd`..."
        ttyd_path = Sys.which("ttyd")
        if isnothing(ttyd_path)
            error("`ttyd` was not found in your system. `ttyd` cannot be automatically installed for macOS and requires manual installation. Make sure `ttyd` is installed using either `brew install ttyd` or `sudo port install ttyd` (follow the GitHub page for more details - `https://github.com/tsl0922/ttyd`). ")
        end
        @info "Found `ttyd` at: $(ttyd_path)"
        return ttyd_path
    end

    rootpath = artifact"WebTerminal"
    file = joinpath(rootpath, "bin", "ttyd")
    return file
end

function default_project_dir()
    return joinpath(homedir(), ".juliawebterminal")
end

function setup_project_env(project_dir)
    Pkg.activate(project_dir)
    Pkg.instantiate()
    try
        eval(Meta.parse("import WebTerminal"))
        Pkg.update("WebTerminal", preserve=Pkg.PRESERVE_ALL)
        Pkg.precompile()
    catch
        Pkg.add(url="https://github.com/JamieMair/WebTerminal.jl", rev="main")
    end
    
end

function start(; port::Int = 3000, threads=Threads.nthreads(), project_dir = default_project_dir())
    setup_project_env(project_dir)

    path = ttyd_path()

    cmd = Cmd(`$(path) --writable --port=$(port) julia --project="$(project_dir)" --threads=$(threads)`, dir=project_dir)
    @info "Running server, press \"Ctrl+C\" to stop the server."
    Base.run(cmd, wait=true)
    return nothing
end

end
