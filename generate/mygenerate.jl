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

# ╔═╡ b1cfebc4-9a0e-11ec-1a55-e519f246f211
using PlutoUI

# ╔═╡ 8b2ac827-d21e-44ef-9d52-f5bb4c722f15
using PlutoSliderServer

# ╔═╡ 0967d313-a66c-426a-a490-a6b042a5e569
using Pluto, Random, UUIDs

# ╔═╡ 2aea0831-439a-4990-8386-be3c7989a516
using JSON3

# ╔═╡ efbf794d-2f1b-46dd-8a38-61bcdfeeecb5
using HypertextLiteral


# ╔═╡ 3b3e4eae-4325-43ea-887c-efe97059da09
using Pluto: without_pluto_file_extension


# ╔═╡ 66770476-bd70-4651-8f5d-e50aef554f16
begin
	#import Pkg
	#Pkg.activate("../PlutoDeployment")
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
	export_directory(output_dir; Export_cache_dir=cache_dir)
end

# ╔═╡ 824d6ebb-0304-426c-895c-c028e9ed169e
begin

		# read original notebook
		notebook = Pluto.load_notebook_nobackup(joinpath(output_dir, "index.jl"))
	new_path = joinpath(output_dir, "index_neu.jl")
		notebook.path = new_path

		# generate UUIDs deterministically to avoid changing the notebook hash 
		my_rng = Random.MersenneTwister(123)

		# generate code for the header
		header_code = "HTML(testetddddds)"
		first_cell = Pluto.Cell(
			code = header_code,
			code_folded = false,
			cell_id=uuid4(my_rng)
		)

		# insert into the notebook
		notebook.cells_dict[first_cell.cell_id] = first_cell
		pushfirst!(notebook.cell_order, first_cell.cell_id)

		# needs more work, as "save_notebook" iterates over
		collect(topological_order(notebook))

		# save to file
		Pluto.save_notebook(notebook)

end

# ╔═╡ b4e170bb-6e3a-4b31-bdfb-06bcfb013571
import StructTypes

# ╔═╡ d3c3af9e-826c-449c-87eb-971cc8ce9170
begin
	Base.@kwdef struct Section
	    name::String
	    notebook_path::String
	end
		StructTypes.StructType(::Type{Section}) = StructTypes.Struct()
	
end

# ╔═╡ 81dc2ebd-411c-4077-9a38-8548f9025b99
begin
Base.@kwdef struct Chapter
	title::String
	contents::Vector{Section}=Section[]
end
	StructTypes.StructType(::Type{Chapter}) = StructTypes.Struct()
end

# ╔═╡ 55465619-ebc3-4b37-8157-d86486588b63
book_model = JSON3.read(read("./book_model.json", String), Vector{Chapter})


# ╔═╡ b569d05f-4012-4b2e-be2b-73a6362249fd
flatmap(args...) = vcat(map(args...)...)


# ╔═╡ 2d361358-596b-432d-9691-868041132b57
function navbar(book_model)
    @htl("""
    <nav >
    $(map(enumerate(book_model)) do (chapter_number, chap)
		@htl("""
		<div class="course-section">Modul $(chapter_number): $(chap.title)</div>
		
		$(map(enumerate(chap.contents)) do (section_number, section)

			notebook_name = 
				basename(without_pluto_file_extension(section.notebook_path))
			notebook_id = (without_pluto_file_extension(section.notebook_path))
			
		    @htl("""
		    <a class="sidebar-nav-item {{ispage /$notebook_name/}}active{{end}}" href="$notebook_id/"><b>$(chapter_number).$(section_number)</b> - <em>$(section.name)</em></a>
		    """)
		end)
		""")
	end)

    </nav>
	""")
end

# ╔═╡ 71607b55-5c76-4a67-9039-b32a85121d4c
navbar(book_model)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
JSON3 = "0f8b85d8-7281-11e9-16c2-39a750bddbf1"
Pluto = "c3e4b0f8-55cb-11ea-2926-15256bba5781"
PlutoSliderServer = "2fc8631c-6f24-4c5b-bca7-cbb509c42db4"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Random = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
StructTypes = "856f2bd8-1eba-4b0a-8007-ebc267875bd4"
UUIDs = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[compat]
HypertextLiteral = "~0.9.3"
JSON3 = "~1.9.2"
Pluto = "~0.18.1"
PlutoSliderServer = "~0.3.5"
PlutoUI = "~0.7.35"
StructTypes = "~1.8.1"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.2"
manifest_format = "2.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.AbstractTrees]]
git-tree-sha1 = "03e0550477d86222521d254b741d470ba17ea0b5"
uuid = "1520ce14-60c1-5f80-bbc7-55ef81b5835c"
version = "0.3.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BetterFileWatching]]
deps = ["Deno_jll", "JSON"]
git-tree-sha1 = "0d7ee0a1acad90d544fa87cc3d6f463e99abb77a"
uuid = "c9fd44ac-77b5-486c-9482-9798bd063cc6"
version = "0.1.5"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Configurations]]
deps = ["ExproniconLite", "OrderedCollections", "TOML"]
git-tree-sha1 = "79e812c535bb9780ba00f3acba526bde5652eb13"
uuid = "5218b696-f38b-4ac9-8b61-a12ec717816d"
version = "0.16.6"

[[deps.DataAPI]]
git-tree-sha1 = "cc70b17275652eb47bc9e5f81635981f13cea5c8"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.9.0"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Deno_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "244309ef7003f30c7a5fe571f6b860c6b032b691"
uuid = "04572ae6-984a-583e-9378-9577a1c2574d"
version = "1.16.3+0"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ae13fcbc7ab8f16b0856729b050ef0c446aa3492"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.4.4+0"

[[deps.ExproniconLite]]
git-tree-sha1 = "8b08cc88844e4d01db5a2405a08e9178e19e479e"
uuid = "55351af7-c7e9-48d6-89ff-24e801d99491"
version = "0.6.13"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.FromFile]]
deps = ["Requires"]
git-tree-sha1 = "625b50a8f5ae8520be86f191420bc8b970b24907"
uuid = "ff7dd447-1dcb-4ce3-b8ac-22a812192de7"
version = "0.1.3"

[[deps.FuzzyCompletions]]
deps = ["REPL"]
git-tree-sha1 = "efd6c064e15e92fcce436977c825d2117bf8ce76"
uuid = "fb4132e2-a121-4a70-b8a1-d5b831dcdcc2"
version = "0.5.0"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Git]]
deps = ["Git_jll"]
git-tree-sha1 = "d7bffc3fe097e9589145493c08c41297b457e5d0"
uuid = "d7ba0133-e1db-5d97-8f8c-041e4b3a1eb2"
version = "1.2.1"

[[deps.GitHubActions]]
deps = ["JSON", "Logging"]
git-tree-sha1 = "56e01ec63d13e1cf015d9ff586156eae3cc7cd6f"
uuid = "6b79fd1a-b13a-48ab-b6b0-aaee1fee41df"
version = "0.1.4"

[[deps.Git_jll]]
deps = ["Artifacts", "Expat_jll", "Gettext_jll", "JLLWrappers", "LibCURL_jll", "Libdl", "Libiconv_jll", "OpenSSL_jll", "PCRE2_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "6e93d42b97978709e9c941fa43d0f01701f0d290"
uuid = "f8c6e375-362e-5223-8a59-34ff63f689eb"
version = "2.34.1+0"

[[deps.HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "0fa77022fe4b511826b39c894c90daf5fce3334a"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.17"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.IniFile]]
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.JSON3]]
deps = ["Dates", "Mmap", "Parsers", "StructTypes", "UUIDs"]
git-tree-sha1 = "7d58534ffb62cd947950b3aa9b993e63307a6125"
uuid = "0f8b85d8-7281-11e9-16c2-39a750bddbf1"
version = "1.9.2"

[[deps.LeftChildRightSiblingTrees]]
deps = ["AbstractTrees"]
git-tree-sha1 = "b864cb409e8e445688bc478ef87c0afe4f6d1f8d"
uuid = "1d6d02ad-be62-4b6b-8a6d-2f90e265016e"
version = "0.1.3"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "Random", "Sockets"]
git-tree-sha1 = "1c38e51c3d08ef2278062ebceade0e46cefc96fe"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.0.3"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.MsgPack]]
deps = ["Serialization"]
git-tree-sha1 = "a8cbf066b54d793b9a48c5daa5d586cf2b5bd43d"
uuid = "99f44e22-a591-53d1-9472-aa23ef4bd671"
version = "1.1.0"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "648107615c15d4e09f7eca16307bc821c1f718d8"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.13+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "13468f237353112a01b2d6b32f3d0f80219944aa"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.2.2"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.Pluto]]
deps = ["Base64", "Configurations", "Dates", "Distributed", "FileWatching", "FuzzyCompletions", "HTTP", "InteractiveUtils", "Logging", "Markdown", "MsgPack", "Pkg", "REPL", "RelocatableFolders", "Sockets", "Tables", "UUIDs"]
git-tree-sha1 = "c97f4548e903d132342a6f5998554f507d0b2578"
uuid = "c3e4b0f8-55cb-11ea-2926-15256bba5781"
version = "0.18.1"

[[deps.PlutoSliderServer]]
deps = ["Base64", "BetterFileWatching", "Configurations", "Distributed", "FromFile", "Git", "GitHubActions", "HTTP", "Logging", "Pkg", "Pluto", "SHA", "Sockets", "TOML", "TerminalLoggers", "UUIDs"]
git-tree-sha1 = "dd581e8ec86d860e3668f48d439a0522ef274e3f"
uuid = "2fc8631c-6f24-4c5b-bca7-cbb509c42db4"
version = "0.3.5"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "85bf3e4bd279e405f91489ce518dedb1e32119cb"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.35"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "de893592a221142f3db370f48290e3a2ef39998f"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.4"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.ProgressLogging]]
deps = ["Logging", "SHA", "UUIDs"]
git-tree-sha1 = "80d919dee55b9c50e8d9e2da5eeafff3fe58b539"
uuid = "33c8b6b6-d38a-422a-b730-caa89a2f386c"
version = "0.1.4"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "cdbd3b1338c72ce29d9584fdbe9e9b70eeb5adca"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "0.1.3"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StructTypes]]
deps = ["Dates", "UUIDs"]
git-tree-sha1 = "d24a825a95a6d98c385001212dc9020d609f2d4f"
uuid = "856f2bd8-1eba-4b0a-8007-ebc267875bd4"
version = "1.8.1"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "TableTraits", "Test"]
git-tree-sha1 = "bb1064c9a84c52e277f1096cf41434b675cd368b"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.6.1"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.TerminalLoggers]]
deps = ["LeftChildRightSiblingTrees", "Logging", "Markdown", "Printf", "ProgressLogging", "UUIDs"]
git-tree-sha1 = "62846a48a6cd70e63aa29944b8c4ef704360d72f"
uuid = "5d786b92-1e48-4d6f-9151-6b4477ca9bed"
version = "0.1.5"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "1acf5bdf07aa0907e0a37d3718bb88d4b687b74a"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.12+0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╠═66770476-bd70-4651-8f5d-e50aef554f16
# ╠═b1cfebc4-9a0e-11ec-1a55-e519f246f211
# ╠═8b2ac827-d21e-44ef-9d52-f5bb4c722f15
# ╠═2851e16b-4df4-47a0-b613-429e8defa8b1
# ╠═a73a0b60-7d8c-49d5-99c9-285fe76a87a9
# ╠═45e9cb59-5c98-4a0b-8bea-36c42b55f548
# ╠═b6e42808-cf90-4100-821c-c745033d49e3
# ╠═105ded88-e956-4765-b7c8-20234f9e5260
# ╠═3900e40c-c736-4bf4-b41e-f2a5c8714bb3
# ╠═824d6ebb-0304-426c-895c-c028e9ed169e
# ╠═0967d313-a66c-426a-a490-a6b042a5e569
# ╠═d3c3af9e-826c-449c-87eb-971cc8ce9170
# ╠═81dc2ebd-411c-4077-9a38-8548f9025b99
# ╠═55465619-ebc3-4b37-8157-d86486588b63
# ╠═b4e170bb-6e3a-4b31-bdfb-06bcfb013571
# ╠═2aea0831-439a-4990-8386-be3c7989a516
# ╠═b569d05f-4012-4b2e-be2b-73a6362249fd
# ╠═71607b55-5c76-4a67-9039-b32a85121d4c
# ╠═2d361358-596b-432d-9691-868041132b57
# ╠═efbf794d-2f1b-46dd-8a38-61bcdfeeecb5
# ╠═3b3e4eae-4325-43ea-887c-efe97059da09
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
