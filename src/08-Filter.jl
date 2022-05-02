### A Pluto.jl notebook ###
# v0.19.0

using Markdown
using InteractiveUtils

# ╔═╡ f5450eab-0f9f-4b7f-9b80-992d3c553ba9
# DO NOT MODIFY, will be updated by update_navbar.jl
HTML("    <nav >\n    Vorbereitungen:\n\n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/index.html\"><em>Intro</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/software.html\"><em>Software</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/01-basic_syntax.html\"><em>Julia Basics</em></a> / \n\n<br>\nStatistik:\n\n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/02-beschreibende-statistik.html\"><em>Beschreibende Statistik</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/03-wahrscheinlichkeit.html\"><em>Wahrscheinlichkeit</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/04-schaetzung.html\"><em>Schätzung</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/05-messunsicherheit.html\"><em>Messunsicherheit</em></a> / \n\n<br>\nFourier-Transformation:\n\n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/06-Fourier-Transformation.html\"><em>Fourier-Transformation</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/07-Frequenzraum.html\"><em>Frequenzraum</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/08-Filter.html\"><em>Filter</em></a> / \n\n<br>\nMesstechnik:\n\n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/09-Rauschen.html\"><em>Rauschen</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/10-Detektoren.html\"><em>Detektoren</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/11-Lock-In.html\"><em>Lock-In-Verstärker</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/12-heterodyn.html\"><em>Heterodyn-Detektion</em></a> / \n\n<br>\n\n\n    </nav>\n\t")

# ╔═╡ ff7880da-96f2-11ec-2d80-adc081faa710
md"""
# Filter


## Lineare, zeit-invariante Systeme

[Ziel:]{.smallcaps} Ich kann eine Transferfunktion *vermessen*.

-   Frequenzantwort, Impulsantwort

-   analoge und digitale Filter

[Weitere Aufgaben:]{.smallcaps}

-   Finden sie durch Filtern das Signal im Datensatz.

[Literatur:]{.smallcaps} Butz Kap. 5, Horowitz / Hill, Kap. 1.19

  
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.2"
manifest_format = "2.0"

[deps]
"""

# ╔═╡ Cell order:
# ╟─f5450eab-0f9f-4b7f-9b80-992d3c553ba9
# ╠═ff7880da-96f2-11ec-2d80-adc081faa710
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
