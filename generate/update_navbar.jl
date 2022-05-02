### A Pluto.jl notebook ###
# v0.19.0

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

# ╔═╡ efbf794d-2f1b-46dd-8a38-61bcdfeeecb5
using HypertextLiteral

# ╔═╡ 0967d313-a66c-426a-a490-a6b042a5e569
using Pluto, Random, UUIDs

# ╔═╡ 4e6622ae-fc89-4dc6-9a96-a6516288eb48
using Pluto: without_pluto_file_extension

# ╔═╡ 2aea0831-439a-4990-8386-be3c7989a516
using JSON3

# ╔═╡ 74ff5f30-f087-4ad3-a42a-2a875d7d9b2f
begin
	PREPATH = "https://pluto.ep3.uni-bayreuth.de/teca/"
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

# ╔═╡ 3a271eb3-6ef0-42ff-87e9-ab402047fccf
md"""
## Bookmodel
"""

# ╔═╡ f4872bd3-c8d3-4518-b1c5-397b35f67475
book_model = JSON3.read(read("book_model.json"));

# ╔═╡ 2d361358-596b-432d-9691-868041132b57
function navbar(book_model)
    @htl("""
    <nav >
    $(map(enumerate(book_model)) do (chapter_number, chap)
		@htl("""
		$(chap.title):
		
		$(map(enumerate(chap.contents)) do (section_number, section)

			notebook_name = 
				basename(without_pluto_file_extension(section.notebook_path))
			notebook_id = (without_pluto_file_extension(section.notebook_path))
			
		    @htl("""
		    <a class="sidebar-nav-item" href="$(PREPATH)$(notebook_id).html"><em>$(section.name)</em></a> / 
		    """)
		end )
		<br>
		""")
	end)

    </nav>
	""")
end;

# ╔═╡ 0fec2dfd-54d7-4e81-86c2-17d36b7b4c3a
navbar(book_model)

# ╔═╡ 824d6ebb-0304-426c-895c-c028e9ed169e
function update_navbar(filename)
	
	# read original notebook
	notebook = Pluto.load_notebook(filename)
	#new_path = joinpath(output_dir, "index_neu.jl")
	#notebook.path = new_path
	
	navbar_code =  "HTML($(repr(string(navbar(book_model)))))" 
	prefix = "# DO NOT MODIFY, will be updated by update_navbar.jl"
	header_code =   prefix * "\n" * navbar_code
	
	firstcellcode = notebook.cells_dict[notebook.cell_order[1]].code

    if startswith(firstcellcode, prefix)
		# update / overwrite first cell
		notebook.cells_dict[notebook.cell_order[1]].code = header_code
		println("update")	
	else
		# add new first cell	
		# generate UUIDs deterministically to avoid changing the notebook hash 
		my_rng = Random.MersenneTwister(123)
	
		# generate code for the header
		first_cell = Pluto.Cell(
			code = header_code,
			code_folded = true,
			cell_id=uuid4(my_rng)
		)
	
		# insert into the notebook
		notebook.cells_dict[first_cell.cell_id] = first_cell
		pushfirst!(notebook.cell_order, first_cell.cell_id)
	
		notebook.topology = Pluto.NotebookTopology(;
								cell_order=Pluto.ImmutableVector( 
									map(i -> notebook.cells_dict[i], 
									notebook.cell_order)))
		println("new")
	end
	# save to file
	Pluto.save_notebook(notebook)
	
	#end
end

# ╔═╡ 619c777e-3c0b-4fd0-89ce-8fca7c35abf9
for ch in book_model
	for sec in ch.contents
		fn = joinpath(source_dir, sec.notebook_path)
		update_navbar(fn)
		println(fn)
	end
end

# ╔═╡ Cell order:
# ╠═66770476-bd70-4651-8f5d-e50aef554f16
# ╠═b1cfebc4-9a0e-11ec-1a55-e519f246f211
# ╠═efbf794d-2f1b-46dd-8a38-61bcdfeeecb5
# ╠═0967d313-a66c-426a-a490-a6b042a5e569
# ╠═4e6622ae-fc89-4dc6-9a96-a6516288eb48
# ╠═2aea0831-439a-4990-8386-be3c7989a516
# ╠═74ff5f30-f087-4ad3-a42a-2a875d7d9b2f
# ╠═2851e16b-4df4-47a0-b613-429e8defa8b1
# ╠═a73a0b60-7d8c-49d5-99c9-285fe76a87a9
# ╠═45e9cb59-5c98-4a0b-8bea-36c42b55f548
# ╠═b6e42808-cf90-4100-821c-c745033d49e3
# ╠═105ded88-e956-4765-b7c8-20234f9e5260
# ╟─3a271eb3-6ef0-42ff-87e9-ab402047fccf
# ╠═f4872bd3-c8d3-4518-b1c5-397b35f67475
# ╠═0fec2dfd-54d7-4e81-86c2-17d36b7b4c3a
# ╠═2d361358-596b-432d-9691-868041132b57
# ╠═824d6ebb-0304-426c-895c-c028e9ed169e
# ╠═619c777e-3c0b-4fd0-89ce-8fca7c35abf9
