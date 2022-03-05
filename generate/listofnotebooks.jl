### A Pluto.jl notebook ###
# v0.18.1

using Markdown
using InteractiveUtils

# ╔═╡ 63f7719e-1c33-4ee6-8a18-393875c1e759
using Markdown: withtag, htmlesc

# ╔═╡ 7e2a2bba-9bdd-11ec-00b3-0b2764d1458b
const toc_js = """

const clickHandler = (event) => {
	const path = (event.path || event.composedPath())
	const toc = path.find(elem => elem?.classList?.contains?.("toc-toggle"))
	if (toc) {
		event.stopImmediatePropagation()
		toc.closest(".plutoui-toc").classList.toggle("hide")
	}
}
document.addEventListener("click", clickHandler)

"""

# ╔═╡ e2d7213b-f6f5-4a99-be73-b347a2df4023
const toc_css = """
.plutoui-toc.aside {
	position:fixed;
	left: 1rem;
	top: 5rem;
	width: min(80vw, 300px);
	padding: 10px;
	border: 3px solid rgba(0, 0, 0, 0.15);
	border-radius: 10px;
	box-shadow: 0 0 11px 0px #00000010;
	/* That is, viewport minus top minus Live Docs */
	max-height: calc(100vh - 5rem - 56px);
	overflow: auto;
	z-index: 40;
	background: white;
	transition: transform 300ms cubic-bezier(0.18, 0.89, 0.45, 1.12);
}
.plutoui-toc.aside.hide {
	transform: translateX(calc(-100% + 28px));
}
.plutoui-toc.aside.hide .open-toc,
.plutoui-toc.aside:not(.hide) .closed-toc,
.plutoui-toc:not(.aside) .closed-toc {
	display: none;
}
@media (prefers-reduced-motion) {
  .plutoui-toc.aside {
    transition-duration: 0s;
  }
}
.toc-toggle {
	cursor: pointer;
	padding: 1em;
	margin: -1em;
    margin-right: 0em;
    padding-right: 0em;
	float: right;
}
.plutoui-toc header {
	display: block;
	font-size: 1.5em;
	margin-top: -0.1em;
	margin-bottom: 0.4em;
	padding-bottom: 0.4em;
	margin-left: 0;
	margin-right: 0;
	font-weight: bold;
	border-bottom: 2px solid rgba(0, 0, 0, 0.15);
}
.plutoui-toc section .toc-row {
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
	padding-bottom: 2px;
}
.highlight-pluto-cell-shoulder {
	background: rgba(0, 0, 0, 0.05);
	background-clip: padding-box;
}
.plutoui-toc section a {
	text-decoration: none;
	font-weight: normal;
	color: gray;
}
.plutoui-toc section a:hover {
	color: black;
}
.plutoui-toc.indent section a.H1 {
	font-weight: 700;
	line-height: 1em;
}
.plutoui-toc.indent section a.H1 {
	padding-left: 0px;
}
.plutoui-toc.indent section a.H2 {
	padding-left: 10px;
}
.plutoui-toc.indent section a.H3 {
	padding-left: 20px;
}
.plutoui-toc.indent section a.H4 {
	padding-left: 30px;
}
.plutoui-toc.indent section a.H5 {
	padding-left: 40px;
}
.plutoui-toc.indent section a.H6 {
	padding-left: 50px;
}
"""

# ╔═╡ 2c62fded-eaf8-4815-8204-ddffb65de9a7
const toc_html = toc -> """
<nav class="plutoui-toc aside indent">
	<header>$(toc.title) 
     <span class="toc-toggle open-toc" >📖</span>
     <span class="toc-toggle closed-toc" >📕</span>
	</header>
	<section><span><div class="toc-row"><span><a class="H1" href="#dd66864e-52c9-448b-8b38-c6306834951c">Hallo</a></span></div><div class="toc-row"><span><a class="H2" href="#dd66864e-52c9-448b-8b38-c6306834951c">sonstwas</a></span></div></span></section>
</nav>"""

# ╔═╡ fcb2677d-a0cd-478d-9f3b-8eb2ae12695d
begin
	"""Generate Table of Contents using Markdown cells. Headers h1-h6 are used. 
	# Keyword arguments:
	`title` header to this element, defaults to "Table of Contents"
	`indent` flag indicating whether to vertically align elements by hierarchy
	`depth` value to limit the header elements, should be in range 1 to 6 (default = 3)
	`aside` fix the element to right of page, defaults to true
	# Examples:
	```julia
	TableOfContents()
	TableOfContents(title="Experiments 🔬")
	TableOfContents(title="📚 Table of Contents", indent=true, depth=4, aside=true)
	```
	"""
	Base.@kwdef struct ListOfNotebooks
		title::AbstractString="List of Notebooks"
		indent::Bool=true
		depth::Integer=3
		aside::Bool=true
	end
	function Base.show(io::IO, ::MIME"text/html", toc::ListOfNotebooks)
		withtag(io, :script) do
			print(io, toc_js)
		end
		withtag(io, :style) do
			print(io, toc_css)
		end
		withtag(io, :body) do
			print(io, toc_html(toc))
		end
	end
end

# ╔═╡ b2f9ff6f-713c-4095-8d80-3aafc7ce9ee7
ListOfNotebooks()

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Markdown = "d6f4376e-aef5-505a-96c1-9c027394607a"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.2"
manifest_format = "2.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
"""

# ╔═╡ Cell order:
# ╠═7e2a2bba-9bdd-11ec-00b3-0b2764d1458b
# ╠═e2d7213b-f6f5-4a99-be73-b347a2df4023
# ╠═2c62fded-eaf8-4815-8204-ddffb65de9a7
# ╠═fcb2677d-a0cd-478d-9f3b-8eb2ae12695d
# ╠═b2f9ff6f-713c-4095-8d80-3aafc7ce9ee7
# ╠═63f7719e-1c33-4ee6-8a18-393875c1e759
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
