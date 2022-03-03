### A Pluto.jl notebook ###
# v0.18.1

using Markdown
using InteractiveUtils

# ╔═╡ f5450eab-0f9f-4b7f-9b80-992d3c553ba9
# DO NOT MODIFY, will be updated by update_navbar.jl
HTML("    <nav >\n    Vorbereitungen:\n\n<a class=\"sidebar-nav-item {{ispage /index/}}active{{end}}\" href=\"index/\"><em>Intro</em></a> / \n<a class=\"sidebar-nav-item {{ispage /software/}}active{{end}}\" href=\"software/\"><em>Software</em></a> / \n<a class=\"sidebar-nav-item {{ispage /links/}}active{{end}}\" href=\"links/\"><em>Hints</em></a> / \n<a class=\"sidebar-nav-item {{ispage /01-basic_syntax/}}active{{end}}\" href=\"01-basic_syntax/\"><em>Julia Basics</em></a> / \n\n<br>\nStatistik:\n\n<a class=\"sidebar-nav-item {{ispage /02-beschreibende-statistik/}}active{{end}}\" href=\"02-beschreibende-statistik/\"><em>Beschreibende Statistik</em></a> / \n<a class=\"sidebar-nav-item {{ispage /03-wahrscheinlichkeit/}}active{{end}}\" href=\"03-wahrscheinlichkeit/\"><em>Wahrscheinlichkeit</em></a> / \n<a class=\"sidebar-nav-item {{ispage /04-messunsicherheit/}}active{{end}}\" href=\"04-messunsicherheit/\"><em>Messunsicherheit</em></a> / \n<a class=\"sidebar-nav-item {{ispage /05-schaetzung/}}active{{end}}\" href=\"05-schaetzung/\"><em>Schätzung</em></a> / \n\n<br>\nFourier-Transformation:\n\n<a class=\"sidebar-nav-item {{ispage /06-Fourier-Transformation/}}active{{end}}\" href=\"06-Fourier-Transformation/\"><em>Fourier-Transformation</em></a> / \n<a class=\"sidebar-nav-item {{ispage /07-Frequenzraum/}}active{{end}}\" href=\"07-Frequenzraum/\"><em>Frequenzraum</em></a> / \n<a class=\"sidebar-nav-item {{ispage /08-Filter/}}active{{end}}\" href=\"08-Filter/\"><em>Filter</em></a> / \n\n<br>\nMesstechnik:\n\n<a class=\"sidebar-nav-item {{ispage /09-Rauschen/}}active{{end}}\" href=\"09-Rauschen/\"><em>Rauschen</em></a> / \n<a class=\"sidebar-nav-item {{ispage /10-Detektoren/}}active{{end}}\" href=\"10-Detektoren/\"><em>Detektoren</em></a> / \n<a class=\"sidebar-nav-item {{ispage /11-Lock-In/}}active{{end}}\" href=\"11-Lock-In/\"><em>Lock-In-Verstärler</em></a> / \n<a class=\"sidebar-nav-item {{ispage /12-heterodyn/}}active{{end}}\" href=\"12-heterodyn/\"><em>Heterodyn-Detektrion</em></a> / \n\n<br>\nReste:\n\n<a class=\"sidebar-nav-item {{ispage /99-newton_method/}}active{{end}}\" href=\"99-newton_method/\"><em>Newton Method</em></a> / \n\n<br>\n\n\n    </nav>\n\t")

# ╔═╡ d98ac7ca-96f2-11ec-0d44-b7943badb165
md"""
# Frequenzraum

## Fourier-Transformation numerisch

[Ziel:]{.smallcaps} Ich kann GNU octave benutzen, um Signale im
Frequenzraum zu *analysieren*.

-   Fast Fourier Transform FFT

-   Frequenzachse

-   Abtastrate, Länge und 'zero padding'

-   FT typischer Funktionen

[Weitere Aufgaben:]{.smallcaps}

-   Signale transformieren und im Fourier-Raum filtern

[Literatur:]{.smallcaps} Butz Kap. 4, Horowitz / Hill, Kap. 1.08, 7.20,
15.18
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
# ╠═d98ac7ca-96f2-11ec-0d44-b7943badb165
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
