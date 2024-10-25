module WebTerminal

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

end
