### A Pluto.jl notebook ###
# v0.19.0

using Markdown
using InteractiveUtils

# ╔═╡ f5450eab-0f9f-4b7f-9b80-992d3c553ba9
# DO NOT MODIFY, will be updated by update_navbar.jl
HTML("    <nav >\n    Vorbereitungen:\n\n<a class=\"sidebar-nav-item\" href=\"index.html\"><em>Intro</em></a> / \n<a class=\"sidebar-nav-item\" href=\"software.html\"><em>Software</em></a> / \n<a class=\"sidebar-nav-item\" href=\"01-basic_syntax.html\"><em>Julia Basics</em></a> / \n\n<br>\nStatistik:\n\n<a class=\"sidebar-nav-item\" href=\"02-beschreibende-statistik.html\"><em>Beschreibende Statistik</em></a> / \n<a class=\"sidebar-nav-item\" href=\"03-wahrscheinlichkeit.html\"><em>Wahrscheinlichkeit</em></a> / \n<a class=\"sidebar-nav-item\" href=\"04-schaetzung.html\"><em>Schätzung</em></a> / \n<a class=\"sidebar-nav-item\" href=\"05-messunsicherheit.html\"><em>Messunsicherheit</em></a> / \n\n<br>\nFourier-Transformation:\n\n<a class=\"sidebar-nav-item\" href=\"06-Fourier-Transformation.html\"><em>Fourier-Transformation</em></a> / \n<a class=\"sidebar-nav-item\" href=\"07-Frequenzraum.html\"><em>Frequenzraum</em></a> / \n<a class=\"sidebar-nav-item\" href=\"08-Filter.html\"><em>Filter</em></a> / \n\n<br>\nMesstechnik:\n\n<a class=\"sidebar-nav-item\" href=\"09-Rauschen.html\"><em>Rauschen</em></a> / \n<a class=\"sidebar-nav-item\" href=\"10-Detektoren.html\"><em>Detektoren</em></a> / \n<a class=\"sidebar-nav-item\" href=\"11-Lock-In.html\"><em>Lock-In-Verstärker</em></a> / \n<a class=\"sidebar-nav-item\" href=\"12-heterodyn.html\"><em>Heterodyn-Detektion</em></a> / \n\n<br>\n\n\n    </nav>\n\t")

# ╔═╡ 0fd5d456-f0ae-403c-a0d3-b5f6f1d44069
md"""
# Skript zur Vorlesung 'Messmethoden'

Dies ist das interaktive Skript zur Vorlesung 'Messmethoden' im Sommersemester 2022 an der Universität Bayreuth. Es gibt den Inhalt [interaktiv](https://markuslippitz.github.io/teca/) oder als [Quelltext](https://github.com/MarkusLippitz/teca). Inspririert ist das alles von [Computational Thinking](https://computationalthinking.mit.edu) am MIT. Die Interaktivität stammt von [Pluto.jl](https://github.com/fonsp/Pluto.jl) basierend auf [Julia](https://julialang.org/).
"""

# ╔═╡ 0f13efe6-dab7-4ea5-9540-9b23fe271a35
md"""
Wenn Sie dem Kurs an der Universität Bayreuth folgen, dann finden Sie organisatorische Hinweise im zugehörigen [elearning-Kurs](https://elearning.uni-bayreuth.de/course/view.php?id=33351).
"""

# ╔═╡ 81a2d186-4e74-4c37-a4af-8226541beaad
md"""
## Bücher, Links und andere hilfreiche Quellen
"""

# ╔═╡ 4f06db2e-dbe1-45f6-98a9-ebf211554b73
md"""

### Links zu Julia 

- [Fastrack to Julia](https://juliadocs.github.io/Julia-Cheat-Sheet/) cheatsheet.
- [MATLAB-Julia-Python comparative cheatsheet](https://cheatsheets.quantecon.org/) by [QuantEcon group](https://quantecon.org)
- [Plots.jl cheatsheet](https://github.com/sswatson/cheatsheets/blob/master/plotsjl-cheatsheet.pdf)
"""

# ╔═╡ 7858c4bd-116c-4c9e-855a-e42111d288ac
md"""
### Statistik und Datenanalyse

- **Werner Stahel: Statistische Datenanalyse** (bib, [ebook](https://dx.doi.org/10.1007/978-3-322-96962-0))
- Philip Bevington, Keith Robinson: Data reduction and error analysis (bib)
- Stuart Meyer: Data analysis for scientists and engineers (bib)
- Martin Erdmann, Thomas Hebbeker: Experimentalphysik 5 (bib)
- Claude Pruneau: Data analysis techniques (bib)
- Roland Waldi: Statistische Datenanalyse ([ebook](https://dx.doi.org/10.1007/978-3-662-47145-6))
- Steven Skiena: Data Science Design Manual ([ebook](https://dx.doi.org/10.1007/978-3-319-55444-0))
- John Taylor: An introduction to error analysis (bib)
- Wolfgang Tschirk: Statistik: Klassisch oder Bayes ([ebook](https://dx.doi.org/10.1007/978-3-642-54385-2))
- William H. Press et al.: Numerical recipes (bib)
- Les Kirkup, Bob Frenkel: An Introduction to Uncertainty in Measurement using the GUM (bib)
- Wolfgang Schenk, Friedrich Kremer: Physikalisches Praktikum (bib, [ebook](https://dx.doi.org/10.1007/978-3-658-00666-2))
- Yoni Nazarathy, Hayden Klok: Statistics with Julia ([ebook](https://dx.doi.org/10.1007/978-3-030-70901-3), [git](https://github.com/StatisticalRethinkingJulia/StatisticsWithJuliaPlutoNotebooks.jl) )
-  Richard McElreath: Lecture series & Book Statistical Rethinking ([git](https://github.com/rmcelreath/stat_rethinking_2022), [youtube](https://www.youtube.com/playlist?list=PLDcUM9US4XdMROZ57-OIRtIK0aOynbgZN))
- Captain Bayes at TU Graz ([mooc](https://imoox.at/course/bayes22), [pluto](https://pluto-bayes.tugraz.at/Odyssey.html))
"""

# ╔═╡ 6d676e27-7b61-43bb-aeda-4c701fcbf7da
md"""

### Signale im Zeit- und Frequenzraum

- **Tilman Butz: Fourier-Transformation für Fußgänger** (dt, engl), (bib, [ebook](https://dx.doi.org/10.1007/978-3-8348-8295-0))
- Helmut Ulrich, Hubert Weber: Laplace-, Fourier- und z-Transformation (bib, [ebook](https://dx.doi.org/10.1007/978-3-658-03450-4))
- Martin Meyer: Signalverarbeitung (bib, [ebook](https://dx.doi.org/10.1007/978-3-658-02612-7))
- Eugene Hecht: Optik (bib, [ebook](https://dx.doi.org/10.1515/9783110526653))
- Saleh / Teich: Fundamentals of Photonics (bib, [ebook](https://dx.doi.org/10.1002/0471213748))

"""

# ╔═╡ c51820c6-66da-4422-aafc-fa3d28eb40c9
md"""

###  Schwache optische Signale

- Paul Horowitz, Winfield Hill: The art of electronics (bib)
- R. Müller: Rauschen (bib)
- Alfons Blum: elektronisches Rauschen (bib)
- Handbook of optics (bib)
- Saleh / Teich: Fundamentals of Photonics (bib, [ebook](https://dx.doi.org/10.1002/0471213748))
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
# ╟─81a2d186-4e74-4c37-a4af-8226541beaad
# ╟─4f06db2e-dbe1-45f6-98a9-ebf211554b73
# ╟─7858c4bd-116c-4c9e-855a-e42111d288ac
# ╟─6d676e27-7b61-43bb-aeda-4c701fcbf7da
# ╟─c51820c6-66da-4422-aafc-fa3d28eb40c9
# ╟─710d0ae5-fac8-4a47-8901-64fa23de051f
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
