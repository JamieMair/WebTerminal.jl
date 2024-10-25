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
    file_loc = joinpath(@__DIR__, "..", "setup.jl")
    cmd = Cmd(`julia --project=$(project_dir) --threads=auto "$(file_loc)"`, dir=project_dir)
    run(cmd, wait=true)
    nothing    
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
