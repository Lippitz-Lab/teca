### A Pluto.jl notebook ###
# v0.18.1

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 66770476-bd70-4651-8f5d-e50aef554f16
begin
	import Pkg
	Pkg.activate("../PlutoDeployment")
	Pkg.instantiate()
end

# ╔═╡ b1cfebc4-9a0e-11ec-1a55-e519f246f211
using PlutoUI

# ╔═╡ 8b2ac827-d21e-44ef-9d52-f5bb4c722f15
using PlutoSliderServer

# ╔═╡ 74ff5f30-f087-4ad3-a42a-2a875d7d9b2f
begin
	PREPATH = "teca"
	#@skip_as_script PREPATH = ""
end

# ╔═╡ 2851e16b-4df4-47a0-b613-429e8defa8b1
@bind regenerate Button("Regenerate!")

# ╔═╡ a73a0b60-7d8c-49d5-99c9-285fe76a87a9
const PROJECT_ROOT = let
	regenerate
	joinpath(@__DIR__, "..") |> normpath
end

# ╔═╡ 45e9cb59-5c98-4a0b-8bea-36c42b55f548
output_dir = let
	PROJECT_ROOT
	joinpath(PROJECT_ROOT, "build")
end

# ╔═╡ b6e42808-cf90-4100-821c-c745033d49e3
source_dir = let
	joinpath(PROJECT_ROOT, "src")
end

# ╔═╡ 105ded88-e956-4765-b7c8-20234f9e5260
cache_dir = let
	joinpath(PROJECT_ROOT, "pluto_state_cache")
end

# ╔═╡ 3900e40c-c736-4bf4-b41e-f2a5c8714bb3
begin
	regenerate
	cp(source_dir,output_dir; force=true)
	export_directory(output_dir)
end

# ╔═╡ Cell order:
# ╠═66770476-bd70-4651-8f5d-e50aef554f16
# ╠═b1cfebc4-9a0e-11ec-1a55-e519f246f211
# ╠═8b2ac827-d21e-44ef-9d52-f5bb4c722f15
# ╠═74ff5f30-f087-4ad3-a42a-2a875d7d9b2f
# ╠═2851e16b-4df4-47a0-b613-429e8defa8b1
# ╠═a73a0b60-7d8c-49d5-99c9-285fe76a87a9
# ╠═45e9cb59-5c98-4a0b-8bea-36c42b55f548
# ╠═b6e42808-cf90-4100-821c-c745033d49e3
# ╠═105ded88-e956-4765-b7c8-20234f9e5260
# ╠═3900e40c-c736-4bf4-b41e-f2a5c8714bb3
