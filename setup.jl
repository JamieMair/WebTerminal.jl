import Pkg;
Pkg.instantiate();
try
    eval(Meta.parse("import WebTerminal"));
    Pkg.update("WebTerminal", preserve=Pkg.PRESERVE_ALL);
catch
    Pkg.add(url="https://github.com/JamieMair/WebTerminal.jl", rev="main");
end;
Pkg.precompile();