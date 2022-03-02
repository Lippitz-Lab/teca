### A Pluto.jl notebook ###
# v0.18.0

using Markdown
using InteractiveUtils

# ╔═╡ 1842a8aa-5819-4719-8d73-02206be09594
md"""
# Wahrscheinlichkeit (4)

 Begriffe,
Pseudozufallszahlen

"""

# ╔═╡ 8a0285b2-bb39-4103-99b3-69ff20a6d2ad
md"""
Lesen Sie im STAHEL das Kapitel 4 „Wahrscheinlichkeit“.


Zur Kontrolle: Haben Sie die folgenden Begriffe verstanden?

Was ist ein Elementarereignis  ? Betrachten Sie Würfeln als typ. „Experiment“
Was ist ein Ereignis, was der Ereignisraum? 
Kombinationen / Operatoren von Teilmengen: 𝐴∪𝐵,  𝐴∩𝐵, 〖  𝐴〗^∁ ?
Eigenschaften eines W‘keits-Modells:   𝑃⟨𝐴⟩≥0
									  𝑃⟨Ω⟩=1
									  𝑃⟨𝐴∪𝐵⟩=𝑃⟨𝐴⟩+𝑃⟨𝐵⟩, 𝑚𝑖𝑡 𝐴∩𝐵=∅
Disjunkte Ereignisse?
Was ist der Unterschied zwischen Elementarereignis, Zufallsvariable X und Zufallszahl?

Wie lautet die Formel für die W‘keit eines Ereignisses 𝐶 mit 𝑃⟨𝐶⟩ unter der Bedingung, dass Ereignis 𝐴 eingetreten ist? Machen Sie sich das entsprechende „Venn-Diagramm“ klar.

Was ist der Satz von Bayes?
"""

# ╔═╡ d71f97d7-bd45-439c-b48d-ced754d9e340
md"""
### Pseudozufallszahlengenerator
"""

# ╔═╡ b9247124-6b5e-458e-82d7-6b12817fb8c2
md"""
### Uniform verteilte Zufallszahlen in MATLAB
"""

# ╔═╡ b8d81a45-cbcb-48ff-9d51-a4a370aaf59e
md"""
*Aufagbe 4*
Zeichnen Sie einen Smiley in einer 2D-Matrix. 
Definieren Sie das Gesicht als Kreis mit dem Wert 0.7, Rest=1, zwei Augen=1 und einen Mund =0.4 (ähnlich der Abb. unten).

Wählen Sie als Colormap ‚hot‘ unter Edit->Colormap; 
Tools->Standard-Colormaps->hot.

Fügen Sie eine Farbskala hinzu (Insert->Colorbar)
"""

# ╔═╡ 35616b3b-b42d-4c79-b04a-c5affcdda055
md"""
*Aufagbe 5*
Erzeugen Sie gleichverteilte Zufallszahlen in zwei Dimensionen zwischen 0..1.

Zählen Sie, wie häufig die Zahlen innerhalb eines Viertel-Kreises mit Radius r=1 liegen und bestimmen Sie die relative Häufigkeit für eine von Ihnen gewählte Gesamtanzahl. 

Multiplizieren Sie Ihr Ergebnis mit 4. Welche Zahl erhalten Sie näherungsweise?

Fügen Sie die Zahl an beliebiger Stelle in Ihr Smiley-Bild hinzu, exportieren Sie es als 
.png und schicken es mir zu.

"""

# ╔═╡ d248bf7a-4fa5-4778-aada-429f9c79eaad
md"""


## Wahrscheinlichkeitsverteilungen (5)
"""

# ╔═╡ 4a5520a2-bf90-40da-8b64-dea62aeeb5c7
md"""
[Ziel:]{.smallcaps} Ich kann eine Sequenz von ‚Zufallszahlen' in GNU
octave *erzeugen*, die einer gegebenen Verteilung genügen.

-   diskrete Verteilungen: Binomial, Poisson

-   stetige Verteilungen: Normal, Log-Normal

-   zentraler Grenzwertsatz
"""

# ╔═╡ b8b5eeac-5934-4085-9202-9b1d2ad40208
md"""
[Weitere Aufgaben:]{.smallcaps}

-   Erzeugen sie Paare von ‚Zufallszahlen', deren 2D Verteilung ein
    Elefant beschreibt. Betrachten sie das Mittel über N dieser Paare.
    Vergleichen sie es mit ihrer Erwartung.
"""

# ╔═╡ 9277a2d9-08b9-4362-83f4-bf9e5fde004c
md"""
[Literatur:]{.smallcaps} Stahel Kap. 5 & 6, Bevington Kap. 2, Meyer Kap.
22--25

"""

# ╔═╡ c9f64fe6-2943-41fd-a4e6-4077a659af78
md"""
GH: Bedingte W’keiten, Stat. Verteilungen: Bernoulli, Binomial.  



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
# ╠═1842a8aa-5819-4719-8d73-02206be09594
# ╠═8a0285b2-bb39-4103-99b3-69ff20a6d2ad
# ╠═d71f97d7-bd45-439c-b48d-ced754d9e340
# ╠═b9247124-6b5e-458e-82d7-6b12817fb8c2
# ╠═b8d81a45-cbcb-48ff-9d51-a4a370aaf59e
# ╠═35616b3b-b42d-4c79-b04a-c5affcdda055
# ╠═d248bf7a-4fa5-4778-aada-429f9c79eaad
# ╠═4a5520a2-bf90-40da-8b64-dea62aeeb5c7
# ╠═b8b5eeac-5934-4085-9202-9b1d2ad40208
# ╠═9277a2d9-08b9-4362-83f4-bf9e5fde004c
# ╠═c9f64fe6-2943-41fd-a4e6-4077a659af78
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
