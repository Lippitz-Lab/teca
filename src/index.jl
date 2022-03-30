### A Pluto.jl notebook ###
# v0.18.1

using Markdown
using InteractiveUtils

# ╔═╡ f5450eab-0f9f-4b7f-9b80-992d3c553ba9
# DO NOT MODIFY, will be updated by update_navbar.jl
HTML("    <nav >\n    Vorbereitungen:\n\n<a class=\"sidebar-nav-item {{ispage /index}}active{{end}}\" href=\"index\"><em>Intro</em></a> / \n<a class=\"sidebar-nav-item {{ispage /software}}active{{end}}\" href=\"software\"><em>Software</em></a> / \n<a class=\"sidebar-nav-item {{ispage /01-basic_syntax}}active{{end}}\" href=\"01-basic_syntax\"><em>Julia Basics</em></a> / \n\n<br>\nStatistik:\n\n<a class=\"sidebar-nav-item {{ispage /02-beschreibende-statistik}}active{{end}}\" href=\"02-beschreibende-statistik\"><em>Beschreibende Statistik</em></a> / \n<a class=\"sidebar-nav-item {{ispage /03-wahrscheinlichkeit}}active{{end}}\" href=\"03-wahrscheinlichkeit\"><em>Wahrscheinlichkeit</em></a> / \n<a class=\"sidebar-nav-item {{ispage /04-schaetzung}}active{{end}}\" href=\"04-schaetzung\"><em>Schätzung</em></a> / \n<a class=\"sidebar-nav-item {{ispage /05-messunsicherheit}}active{{end}}\" href=\"05-messunsicherheit\"><em>Messunsicherheit</em></a> / \n\n<br>\nFourier-Transformation:\n\n<a class=\"sidebar-nav-item {{ispage /06-Fourier-Transformation}}active{{end}}\" href=\"06-Fourier-Transformation\"><em>Fourier-Transformation</em></a> / \n<a class=\"sidebar-nav-item {{ispage /07-Frequenzraum}}active{{end}}\" href=\"07-Frequenzraum\"><em>Frequenzraum</em></a> / \n<a class=\"sidebar-nav-item {{ispage /08-Filter}}active{{end}}\" href=\"08-Filter\"><em>Filter</em></a> / \n\n<br>\nMesstechnik:\n\n<a class=\"sidebar-nav-item {{ispage /09-Rauschen}}active{{end}}\" href=\"09-Rauschen\"><em>Rauschen</em></a> / \n<a class=\"sidebar-nav-item {{ispage /10-Detektoren}}active{{end}}\" href=\"10-Detektoren\"><em>Detektoren</em></a> / \n<a class=\"sidebar-nav-item {{ispage /11-Lock-In}}active{{end}}\" href=\"11-Lock-In\"><em>Lock-In-Verstärker</em></a> / \n<a class=\"sidebar-nav-item {{ispage /12-heterodyn}}active{{end}}\" href=\"12-heterodyn\"><em>Heterodyn-Detektion</em></a> / \n\n<br>\n\n\n    </nav>\n\t")

# ╔═╡ 0fd5d456-f0ae-403c-a0d3-b5f6f1d44069
md"""
# Skript zur Vorlesung 'Messmethoden'

Dies ist das interaktive Skript zur Vorlesung 'Messmethoden' im Sommersemester 2022 an der Universität Bayreuth. Es gibt den Inhalt [interaktiv](https://markuslippitz.github.io/teca/) oder als [Quelltext](https://github.com/MarkusLippitz/teca). Inspririert ist das alles von [Computational Thinking](https://computationalthinking.mit.edu) am MIT. Die Interaktivität stammt von [Pluto.jl](https://github.com/fonsp/Pluto.jl) basierend auf [Julia](https://julialang.org/).
"""

# ╔═╡ 0f13efe6-dab7-4ea5-9540-9b23fe271a35
md"""
Wenn Sie dem Kurs an der Universität Bayreuth folgen, dann finden Sie organisatotische Hinweise im zugehörigen [elearning-Kurs](https://elearning.uni-bayreuth.de/course/view.php?id=33351).
"""

# ╔═╡ 4f06db2e-dbe1-45f6-98a9-ebf211554b73
md"""

## Links zu Julia 

- [Fastrack to Julia](https://juliadocs.github.io/Julia-Cheat-Sheet/) cheatsheet.
- [MATLAB-Julia-Python comparative cheatsheet](https://cheatsheets.quantecon.org/) by [QuantEcon group](https://quantecon.org)
- [Plots.jl cheatsheet](https://github.com/sswatson/cheatsheets/blob/master/plotsjl-cheatsheet.pdf)
"""

# ╔═╡ 710d0ae5-fac8-4a47-8901-64fa23de051f
html"""<style>
#launch_binder {
    display: none;
}
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
# ╟─0fd5d456-f0ae-403c-a0d3-b5f6f1d44069
# ╟─0f13efe6-dab7-4ea5-9540-9b23fe271a35
# ╟─4f06db2e-dbe1-45f6-98a9-ebf211554b73
# ╟─710d0ae5-fac8-4a47-8901-64fa23de051f
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
