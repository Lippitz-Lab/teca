### A Pluto.jl notebook ###
# v0.18.1

using Markdown
using InteractiveUtils

# ╔═╡ f5450eab-0f9f-4b7f-9b80-992d3c553ba9
# DO NOT MODIFY, will be updated by update_navbar.jl
HTML("    <nav >\n    Vorbereitungen:\n\n<a class=\"sidebar-nav-item {{ispage /index}}active{{end}}\" href=\"index\"><em>Intro</em></a> / \n<a class=\"sidebar-nav-item {{ispage /software}}active{{end}}\" href=\"software\"><em>Software</em></a> / \n<a class=\"sidebar-nav-item {{ispage /links}}active{{end}}\" href=\"links\"><em>Hints</em></a> / \n<a class=\"sidebar-nav-item {{ispage /01-basic_syntax}}active{{end}}\" href=\"01-basic_syntax\"><em>Julia Basics</em></a> / \n\n<br>\nStatistik:\n\n<a class=\"sidebar-nav-item {{ispage /02-beschreibende-statistik}}active{{end}}\" href=\"02-beschreibende-statistik\"><em>Beschreibende Statistik</em></a> / \n<a class=\"sidebar-nav-item {{ispage /03-wahrscheinlichkeit}}active{{end}}\" href=\"03-wahrscheinlichkeit\"><em>Wahrscheinlichkeit</em></a> / \n<a class=\"sidebar-nav-item {{ispage /04-messunsicherheit}}active{{end}}\" href=\"04-messunsicherheit\"><em>Messunsicherheit</em></a> / \n<a class=\"sidebar-nav-item {{ispage /05-schaetzung}}active{{end}}\" href=\"05-schaetzung\"><em>Schätzung</em></a> / \n\n<br>\nFourier-Transformation:\n\n<a class=\"sidebar-nav-item {{ispage /06-Fourier-Transformation}}active{{end}}\" href=\"06-Fourier-Transformation\"><em>Fourier-Transformation</em></a> / \n<a class=\"sidebar-nav-item {{ispage /07-Frequenzraum}}active{{end}}\" href=\"07-Frequenzraum\"><em>Frequenzraum</em></a> / \n<a class=\"sidebar-nav-item {{ispage /08-Filter}}active{{end}}\" href=\"08-Filter\"><em>Filter</em></a> / \n\n<br>\nMesstechnik:\n\n<a class=\"sidebar-nav-item {{ispage /09-Rauschen}}active{{end}}\" href=\"09-Rauschen\"><em>Rauschen</em></a> / \n<a class=\"sidebar-nav-item {{ispage /10-Detektoren}}active{{end}}\" href=\"10-Detektoren\"><em>Detektoren</em></a> / \n<a class=\"sidebar-nav-item {{ispage /11-Lock-In}}active{{end}}\" href=\"11-Lock-In\"><em>Lock-In-Verstärler</em></a> / \n<a class=\"sidebar-nav-item {{ispage /12-heterodyn}}active{{end}}\" href=\"12-heterodyn\"><em>Heterodyn-Detektrion</em></a> / \n\n<br>\nReste:\n\n<a class=\"sidebar-nav-item {{ispage /99-newton_method}}active{{end}}\" href=\"99-newton_method\"><em>Newton Method</em></a> / \n\n<br>\n\n\n    </nav>\n\t")

# ╔═╡ c58f76d9-45e8-4d72-9bce-f69321ee64d4
md"""
# Beschreibende Statistik
"""

# ╔═╡ f9e6d230-2784-4b75-9ef5-08c4f6e7ffd2
md"""
## Beschreibende Statistik / Stichprobe (3)
"""

# ╔═╡ f4be8945-c54d-4162-8ee1-2fe3cfb078f1
md"""
[Ziel:]{.smallcaps} Ich kann Methoden der beschreibenden Statistik
*anwenden* und in GNU octave *implementieren*, um Aussagen über
Datensätze zu treffen.

-   Mittelwert und Standardabweichung

-   Momente

-   Korrelation und Kovarianz
"""

# ╔═╡ c3c5a68e-85ab-425d-a18b-084e13c5edb2
md"""
[Literatur:]{.smallcaps} Stahel Kap. 2 & 3, Bevington Kap. 1
"""

# ╔═╡ 2b7f8f96-8e25-4155-89f0-c060e1d4a12e
md"""
*Aufgabe 1*

Sie haben jetzt Zugriff auf den STAHEL „Statistische Datenanalyse“.
Lesen Sie zur Einführung im STAHEL die Kapitel 1 und 2 „Beschreibung eindimensionaler Stichproben“ (das klingt nach mehr, als es wirklich ist). Wichtig sind vor allem die mit schwarzen Balken am Rand markierten Abschnitte. 
"""

# ╔═╡ 88b5d4d2-9b4c-4f1b-841b-a18443e5e1d9
md"""
Zur Kontrolle: Haben Sie die folgenden Begriffe verstanden?
Was stellt man bei einem Histogramm genau dar? Wie verändern sich die y-Werte, wenn man die sog. Klassenbreite verdoppelt?
Was ist mit einer Stichprobe gemeint?
Was ist eine geordnete Stichprobe und der Rang einer Zahl xi  darin?
Wie berechnet man die kumulative Verteilungsfunktion? Wenn man sie von einer Notenverteilung (Noten 1 bis 6) einer Klausur bilden würde, was sagt ihr y-Wert z.B. zum x-Wert „Note=2“ aus? Ist es der Anteil y aller Klausuren, die schlechter oder besser als Note 2 sind? 
Was sind die beiden wichtigsten Kennzahlen einer statistischen Verteilung?
Ist der physikalische Schwerpunkt mathematisch dem Median oder dem Mittelwert verwandt?
Wie ist die Varianz, wie die Standardabweichung einer Stichprobe mathematisch definiert?
Was meint man mit der Aussage, diese beiden Streumaße seien nicht „robust“?
Bei welchem Wert liegt typischerweise die sogenannte Standard-Lage?
Mit welcher allgemeinen mathematischen Operation („Trick“) erzeugt man „nicht-schiefe“ Stichproben?
"""

# ╔═╡ 0bc863fa-9628-4f30-936f-6fed3a225ef1
md"""
*Aufgabe 2: Programmieraufgabe*


Erzeugen Sie einen Vektor mit Einträgen von 30 via 0.1 bis 100.
(for-loop oder einfacher mit passendem Befehl?)

Berechnen Sie den Mittelwert, den Median und die Standardabweichung der Einträge. Nutzen Sie die Formeln. Gibt es auch entsprechende Befehle?

Tragen Sie das Ergebnis bis Di. 27.4. zur Kontrolle im Elearing ein.
"""

# ╔═╡ b62b28cb-0450-4717-a37a-b41295fedaeb
md"""
*Aufgabe 3*

a) Lesen Sie das Kapitel 3 im STAHEL „Beschreibende Statistik  
    mehrdimensionaler Daten“

b) Betrachten Sie die rechts angegebenen Daten X,Y. (File Online)

Plotten Sie die Datenpunkte gegeneinander und 
legen Sie „per-Hand“ eine lineare Gerade durch die Daten mittels
->Insert->Line.
2. Bestimmen Sie die Regressionsgerade nach der Methode der Kleinsten Quadrate und plotten Sie sie mittels „hold on“ in die selbe Figure.
"""

# ╔═╡ a7d55631-51a3-4a0f-b4bd-5dc1b737c7bf
md"""
### Beschreibende Statistik mehrdimens. Daten

Korrelation (genauer: Produktmomenten-Korrelation): Maß für Stärke eines Zusammenhangs multivariater Stichproben. 

Am Beispiel für bivariate Stichprobe aus (𝑥_𝑖, 𝑦_𝑖)-s. Dazu: Standardisieren der Lage und Normieren der Streuung durch Standaradabweichung:  〖(𝑥_𝑖 ) ̃=(𝑥_𝑖−𝑥 ̅)/〖𝑠𝑑〗_𝑋  〗_ , entsprechend 𝑦_𝑖.

Als Gesamtmaß ergibt sich die Korrelation 𝑟_𝑋𝑌  aus allen Beiträgen: 

𝑟_𝑋𝑌=1/(𝑛−1) ∑_𝑖▒〖(𝑥_𝑖 ) ̃(𝑦_𝑖 ) ̃=𝑠_𝑋𝑌/(〖𝑠𝑑〗_𝑋 〖𝑠𝑑〗_𝑌 )〗

mit der Kovarianz: 𝑠_𝑋𝑌= 1/(𝑛−1) ∑_𝑖▒〖=(𝑥_𝑖−𝑥 ̅)(𝑦_𝑖−𝑦 ̅)〗
"""

# ╔═╡ 559038d5-e38c-4180-bf67-8a4f7533f0b7
md"""
### Wichtige Punkte bzgl. der Korrelation

Produktmomentenkorrelation ist Maß für linearen Zusammenhang!!
     Ggf. sind andere Korrelationen besser geeignet Zusammenhänge darzustellen   
     (z.B. Spearmansche Rankkorrelation: alg. monotone Zusammenhänge, diese ist    
     auch robuster) 

Korrelation und ihre Interpretation: hoher Korrelationswerte bedeutet nicht zwangsläufig ursächlicher Zusammenhang! 
Artefakte z.B. durch Inhomogenitäts-Korrelation: Zusammenhang von Merkmalen in inhomogenen Stichproben (Jahrgänge, Geschlechter,…) 
Schein-Korrelation: Durch Standardisierung durch dritte  (unkorrelierte) Größe Z entsteht formale Korrelation von X/Z und Y/Z ,
„Unsinn“-Korrelation: Vergleich zweier beliebiger linearer Daten-Trends liefert immer (wenn auch unsinnige) Korrelation (z.B. zeitliches Anwachsen von Storch-Zahl und Geburtenzahl zwischen 1900-1970).
"""

# ╔═╡ ba4ab3c1-bda6-4b6b-9821-2767cf57b4d4
md"""
### Regression

Fragestellung: 
Wie hängt hervorgehobene Zielgröße Y von Ausgangsgröße X ab (z.B. via Kausalzusammenhang)?
Wie kann für beliebigen Wert von X der entsprechende Wert aus Y vorhergesagt, bzw. prognostiziert werden?

"""

# ╔═╡ 89391ed9-32a0-45d4-ab08-5d3e5f591ba3
md"""
Grundidee: Funktioneller Zusammenhang zwischen X und Y:

𝑦_𝑖  ≈ℎ(𝑥_𝑖)

Einfachster & wichtigster Fall: lineare Funktion ℎ(𝑥_  )=𝑎+𝑏𝑥, 

mit  𝑎: Achsenabschnitt, 𝑏: Steigung.  
"""

# ╔═╡ 8f24de1d-6961-472b-ae44-47b8e413cb93
md"""

Die Abweichungen 𝑟_𝑖  (Residuen) einer Gerade mit 𝑎,𝑏 von den Messdaten ist:

𝑟_𝑖  ≈𝑦_𝑖−(𝑎+𝑏𝑥_𝑖)
"""

# ╔═╡ 514f184a-2d7a-4791-a668-353c42b559cb
md"""
### Methode der Kleinsten Quadrate (least squares)
"""

# ╔═╡ b3f27851-b77d-4907-9747-545d53348533
md"""
### Transformation von Daten
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
# ╠═c58f76d9-45e8-4d72-9bce-f69321ee64d4
# ╠═f9e6d230-2784-4b75-9ef5-08c4f6e7ffd2
# ╠═f4be8945-c54d-4162-8ee1-2fe3cfb078f1
# ╠═c3c5a68e-85ab-425d-a18b-084e13c5edb2
# ╠═2b7f8f96-8e25-4155-89f0-c060e1d4a12e
# ╠═88b5d4d2-9b4c-4f1b-841b-a18443e5e1d9
# ╠═0bc863fa-9628-4f30-936f-6fed3a225ef1
# ╠═b62b28cb-0450-4717-a37a-b41295fedaeb
# ╠═a7d55631-51a3-4a0f-b4bd-5dc1b737c7bf
# ╠═559038d5-e38c-4180-bf67-8a4f7533f0b7
# ╠═ba4ab3c1-bda6-4b6b-9821-2767cf57b4d4
# ╠═89391ed9-32a0-45d4-ab08-5d3e5f591ba3
# ╠═8f24de1d-6961-472b-ae44-47b8e413cb93
# ╠═514f184a-2d7a-4791-a668-353c42b559cb
# ╠═b3f27851-b77d-4907-9747-545d53348533
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
