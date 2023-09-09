using Pluto

function GetFileExtension(filename)
    return filename[findlast(isequal('.'),filename):end]
end

dir = abspath(joinpath(pwd(), "..", "src"))

files = readdir(dir)

jlfiles = files[GetFileExtension.(files) .== ".jl"]

@. Pluto.reset_notebook_environment(joinpath(dir, jlfiles))

import PlutoPDF
@. PlutoPDF.pluto_to_pdf(joinpath(dir, jlfiles))

using PlutoStaticHTML

bopts = BuildOptions(dir);

oopts = OutputOptions(; append_build_context=false);

build_notebooks(bopts, jlfiles, oopts);


md"""
Dann an der Konsole

pandoc -f html+tex_math_dollars+tex_math_single_backslash -t latex --standalone 02-beschreibende-statistik.html > 02c.tex
"""
