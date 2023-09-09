### A Pluto.jl notebook ###
# v0.19.26

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

# ╔═╡ c58f76d9-45e8-4d72-9bce-f69321ee64d4
html"""<div>
<font size="7"><b>2 Beschreibende Statistik</b></font> </div>

<div><font size="5"> Markus Lippitz </font> </div>
<div><font size="5"> 2. Mai 2022 </font> </div>
"""

# ╔═╡ f4be8945-c54d-4162-8ee1-2fe3cfb078f1
md"""
**Ziele** Sie können Methoden der beschreibenden Statistik
*anwenden* und in Julia *implementieren*, um Aussagen über
Datensätze zu treffen.

-   Mittelwert und Standardabweichung

-   Momente

-   Korrelation und Kovarianz

**Literatur**  Stahel Kap. 2 & 3, Bevington Kap. 1
"""

# ╔═╡ dad2a7b0-f900-4a77-b7a3-b2b49d38ce14
md"""
# Überblick

Durch eine *Messung* erhalten wir uns einen Messwert einer physikalischen Größe. Wir können die Messung bei ansonsten unveränderten Bedingungen wiederholen und erhalten viele Messwerte, die nur im idealisierten Fall identisch sind. Diese Menge von Messwerten wird in der Statistik *Stichprobe* genannt. In diesem Kapitel versuchen wir zunächst, Aussagen über diese Stichprobe zu machen. Eigentlich wollen wir aber natürlich etwas über die Wirklichkeit sagen können. Der Schluss von den Messwerten auf die  Natur wird in der Statistik *Schätzung* genannt. Das ist dann Inhalt eines späteren Kapitels.

"""

# ╔═╡ 8cd8d8ea-5ece-4eec-8e46-13a52aed1d3a
md"""
# Temperaturverlauf

Als konkretes Beispiel betrachten wir den Temperaturverlauf am 1. August 2021 in einem unserer (klimatisierten) Labore. In einer idealen Welt wäre die Temperatur genau $21^\circ$C, aber natürlich ändert sie sich im Laufe des Tages. Diese Zeitabhängigkeit ignorieren wir zunächst und betrachten dies als wiederholte Messung bei unveränderten Bedingungen. 
"""

# ╔═╡ dcba4d9e-89d9-4fac-820a-fb24da9b1916
md"""
Zunächst laden wir den Datensatz. Hilfreich sind dabei die Pakete DataFrames und CSV.
"""

# ╔═╡ 049ea5c2-b2e9-4524-965e-0db726134f1d
using DataFrames, CSV

# ╔═╡ 52f64c20-a045-4ee6-a307-f50af60eae49
md"""
Dann laden wir die Datei in die Variable 'datensatz'. Die Spalten sind durch ein Tab ('\t') getrennt und die ersten 4 Zeilen beinhalten einen Datumsstempel, der uns hier nicht interessiert.
"""

# ╔═╡ 1868cca5-3cfb-4376-8468-d13831366cc9
datensatz = CSV.read(download("https://raw.githubusercontent.com/MarkusLippitz/teca/main/res/02-beschreibende-statistik/Temperatur_1_0_05_1_Tag_210801.dat"), DataFrame; delim='\t', header=5)

# ╔═╡ 436b8f12-d833-42ec-b85c-31eb96ad862a
md"""
Unsere Stichprobe sei die Ist-Temperatur
"""

# ╔═╡ 70e91e6e-864a-4e9a-ab7d-c592833c1f59
stichprobe = datensatz.Tist

# ╔═╡ 9ec97d94-274a-43e0-ae46-aa89d6149f0b
md"""
# Grafische Darstellung

Typischerweise ist es nicht sehr sinnvoll, alle Werte der Stichprobe in der Reihenfolge ihrer Messung darzustellen. Hier tun wir es trotzdem. 
"""

# ╔═╡ 88143e8d-1a08-4aca-9f42-63c39c8ec0e9
md"""
Wir benutzen hier die Plots-Bibliothek und das interaktive plotly-backend
"""

# ╔═╡ ed832ad1-62f1-4ef6-a5d3-12e6bd2b60cd
using PlotlyBase,Plots

# ╔═╡ d2ec129a-e27e-46fe-a066-6883cab53aab
plot(stichprobe, xlabel="Laufende Nummer des Messung", ylabel="T_ist (deg C)", legend=false)

# ╔═╡ 1213593e-89dc-44a7-94e9-9868bd08c715
md"""
Auf den ersten Blick funktioniert die Klimaanlage ganz gut. Es ist keine systematische Variation zu erkennen.
"""

# ╔═╡ fe5d30f7-74f8-4b4b-b604-ee2d30fe8f33
md"""
## Histogramm

Relevanter ist die Darstellung der Stichprobe als Histogramm. Man zählt, wie oft ein Wert innerhalb eines Intervalls, einer _Klasse_, vorkommt und zeichnet Balken entsprechender Höhe und Breite.
"""

# ╔═╡ 10c78be3-c1a3-4808-b136-189ddba7e53f
Plots.histogram(stichprobe, xlabel="T_ist (deg C)", ylabel="Anzahl", legend=false)

# ╔═╡ 23509c7d-9e69-4f25-9839-ea9785cb7b75
md"""
Da scheint eine gewisse Präferenz für Temperaturen im Abstand von ca. 0.02 Grad zu sein, wo immer das herkommt.
"""

# ╔═╡ dc930a35-3705-40bd-9832-b13b084da3f1
md"""
Wichtig ist bei Histogrammen, dass das Integral über die x-Achse die Gesamtzahl der Messwerte bzw. eine Wahrscheinlichkeit von 1 ergibt. Das wird insbesondere dann relevant, wenn man unterschiedlich breite Klassen kombinieren möchte, weil beispielsweise am Rand nur wenige Ereignisse sind. Effektiv löst man dabei die Grenze zwischen den Klassen auf. Der neue Balken hat den Mittelwert der alten als Höhe, nicht seine Summe!

Das ist allerdings für die Histogramm-Funktion aus 'Plots' zu kompliziert. Wir benutzten 'StatsBase'.
"""

# ╔═╡ 22592e54-a24b-446d-bde0-93ec4c802b9b
using StatsBase
# Man muss im Folgenden das "StatsBase." nicht mit schreiben. Ich tue es hier, um deutlich zu machen, wo die Funktion her kommt

# ╔═╡ 51626ee2-e509-4cae-9f0e-1cf448b5b5e0
@bind left_bin_width  Slider( 0.005: 0.005 : 0.1; default= 0.02, show_value = true)

# ╔═╡ dbc3c042-3bb8-492c-810a-a3caf45ff794
@bind histo_mode Radio(["pdf", "density", "probability", "none"], default="none")

# ╔═╡ 532ab0aa-bc85-49b7-a577-124109ab53a1
let
	# Histogram with variable bin size on left half
	bins_l = range(20.88, 21; step=left_bin_width)
	bins_r = range(21, 21.1; step=0.005)
	h1 = StatsBase.fit(Histogram, stichprobe, [bins_l; bins_r])
	h1 = LinearAlgebra.normalize(h1,mode=Symbol(histo_mode))

	# for comparison: histogram with fixed, small bin size
	h2 = StatsBase.fit(Histogram, stichprobe, range(20.88, 21.1; step=0.005))
	h2 = LinearAlgebra.normalize(h2,mode=Symbol(histo_mode))

	# adjust label according to normalization
	yaxis =  Dict([ (:none, "Anzahl"), 
					(:pdf, "WK-Dichte (1/deg C)"), 
					(:probability, "Wahrscheinlichkeit"), 
					(:density, "Anzahl (1/deg C)")] )

	# overlay both histograms
	plot(h2, legend=false )
	plot!(h1, fillopacity=0.7, xlabel="T_ist (deg C)", 
			ylabel=yaxis[Symbol(histo_mode)])
end

# ╔═╡ 1f7dc3da-ab8d-4bc5-8bba-ee1d82d6b7a4
md"""
### Histogramme selbst gemacht
"""

# ╔═╡ 975e9fa8-d627-40a7-96ec-206b7e4809c7
let
	binsize = 0.005
	edges = range(20.9, 21.1; step=binsize)
	counts = zeros(length(edges))
	
	for id = 1:length(edges)-1
		edge_low = edges[id]
		edge_high = edges[id+1]
		counts[id] = count(x -> edge_low <= x <edge_high , stichprobe)
	end
	
	Plots.bar(edges .+ binsize/2, counts, 
		xlabel="T_ist (deg C)", ylabel="Anzahl", legend=false)
end

# ╔═╡ 610cd280-d3b8-47c9-ad6e-4fb1577a6c4c
md"""
# Rang und kumulative Verteilungsfunktion
"""

# ╔═╡ 00ec87d6-4b4d-42d7-a315-885ef16649a6
md"""
Unsere Stichprobe besteht aus den Werten $x_i$ mit dem laufenden Index $i = 1 \dots n$. Wir können die $x_i$ der Größe nach sortieren und bezeichnen dann mit $x_{[i]}$ den $i$-ten Eintrag nach Sortierung. Also ist $x_{[1]}$ die kleinste Zahl und $x_{[n]}$ die größte.
"""

# ╔═╡ 3980b93b-dca5-41e8-9db5-b9ec5bb06b86
md"""
In Julia ist die zuerst gemessene Zahl
"""

# ╔═╡ 447f26d1-41f1-4fe1-aa5c-004ec9d18a36
stichprobe[1]

# ╔═╡ 0a755560-a580-41f2-9327-724882fb154f
md"""
und die letzte Zahl ist
"""

# ╔═╡ c7d415fc-9564-4f8b-b503-ae09f9d17bb9
stichprobe[end]

# ╔═╡ cdcd6224-6964-4774-a941-ff67c65d0568
md"""
Die drittletzte ist
"""

# ╔═╡ 3b5ce183-9dc1-452f-aa7c-d1f35ad6614f
stichprobe[end-2]

# ╔═╡ c21b3673-2c16-4e28-b155-9e9ec54ca84f
md"""
Wir können die Stichprobe sortieren und direkt auf die sortierte Liste zugreifen, zB die zweitgrößte Zahl ist
"""

# ╔═╡ fded84d1-cb5b-4b51-940c-3772594e3aeb
sort(stichprobe)[end-1]

# ╔═╡ f20230a5-2fe9-4907-b5e4-13a98482eb56
md"""
Der **Rang** (engl. rank) einer Zahl gibt an, wie wievielt-kleinste Zahl sie ist. Das schreibt man als $\text{Rang}(x_i)$. 
Es gibt [verschiedene Methoden](https://en.wikipedia.org/wiki/Ranking#Strategies_for_assigning_rankings) damit umzugehen, dass ein Wert mehrfach vorkommt.

"""

# ╔═╡ 25b6f838-a496-4b4e-a456-478d4eb1b536
x = [3.4, 6.1, 1.2, 7.8, 3.4];

# ╔═╡ 98330947-bb95-4f2e-a380-991891a3328b
md"""
Man ignoriert einfach, dass manche Zahlen doppelt vorkommen
"""

# ╔═╡ 84dc49a5-642f-42d1-8520-a1f338991531
StatsBase.ordinalrank(x)

# ╔═╡ cb609ac3-0e0c-4db2-abb3-528371c46c46
md"""
oder wie bei Olympia
"""

# ╔═╡ 7e8bf5e0-284e-478c-89e1-08ffee174e13
StatsBase.competerank(x)

# ╔═╡ 51c2555f-7040-4f56-840c-5e9462561d31
md"""
Oft erhalten alle identischen Zahlen den gleichen Rang, und zwar den Mittelwert der von ihnen belegten Ränge.
"""

# ╔═╡ 12a9d1d8-a5ca-4500-a804-183821a9d026
StatsBase.tiedrank(x)

# ╔═╡ 73c659cb-22df-460b-97ea-ddccb2ebb1bb
md"""
Die **empirische kumulative Verteilungsfunktion** (engl. empirical cumulative distribution function, ecdf) ordnet jedem Wert $x$  den  Anteil der Wert $x_i$ zu, die kleiner oder gleich $x$ sind. 
```math
 F(x) = \frac{1}{n} \, \text{Anzahl} \, \left(i | x_i \le x \right)
```
Der Graph dieser Funktion $F(x)$ zeigt Stufen mit Ecken an den Koordinaten $(x_{[k]}, (k-1)/n)$ und  $(x_{[k]}, k/n)$.
"""

# ╔═╡ eff8db42-396e-4570-8244-6c5cadd7d92e
md"""
In Julia erzeugt 'ecdf' eine Funktion, wie wir aufrufen können.
"""

# ╔═╡ b19f652c-ec11-457d-8566-3aa53d3f6c71
ecdf_x = StatsBase.ecdf(x);

# ╔═╡ 284bb169-bdaf-416a-8f5d-7fd53689913d
let
	u = range(0, 10; step=0.001)
	plot(u, ecdf_x(u), xlabel="x", ylabel="F(x)", legend=false)
	# zum Vergleich 'von Hand'
	scatter!(sort(x),  (1:length(x)) / length(x))
	scatter!(sort(x), ((1:length(x)) .- 1) / length(x))
end

# ╔═╡ 5ae473fc-320d-4b75-8052-311fc074b5d9
md"""
Für die Labortemperatur ist dies
"""

# ╔═╡ c3284711-b881-496d-b9ad-68d4865d60d2
let
	u = range(20.88, 21.12; step=0.0001)
	plot(u, StatsBase.ecdf(stichprobe)(u), xlabel="Temperatur T (deg C)", ylabel="F(T)", legend=false)
end

# ╔═╡ ba05d98f-605f-4c2f-a4bd-be91af6d60c8
md"""
# Kennzahlen 

Mit einigen Kennzahlen können wir die Stichprobe beschreiben. Die bekannteste ist sicherlich der **Mittelwert** (engl. mean), Durchschnitt oder Schwerpunkt
```math
\bar{x} = \frac{1}{n} \sum_{i=1}^{n} x_i
```
"""

# ╔═╡ a5e5dfb3-81cc-4365-8036-c5b6444df798
md"""
In Julia ist das
"""

# ╔═╡ d17a2490-23a1-43ca-bf93-a26f08e8dbd5
StatsBase.mean(stichprobe)

# ╔═╡ 7df3ac3b-f6cd-4a43-9803-7cff9d544332
md"""
oder
"""

# ╔═╡ f44f734c-4e33-4e3d-992c-d212e3925832
sum(stichprobe) / length(stichprobe)

# ╔═╡ 7108dfab-f3f0-4c83-ba59-e5cb7307418c
md"""
Manchmal ist der **Median** oder Zentralwert aussagekräftiger. Das ist der mittlere Wert einer geordneten Stichprobe, also 
```math
\text{med}_i \left< x_i \right> = x_{[ (n+1)/2]} \quad \text{bzw.} \quad =\frac{1}{2} \left( x_{[n/2]} +  x_{[(n/2) +1]} \right)
```
Der Median ist weniger anfällig gegen Ausreißer. Selbst wenn man den größten Wert der Stichprobe mit 100 multipliziert, ändert sich der Median nicht, der Mittelwert aber schon.
"""

# ╔═╡ 606efab3-a405-4cd5-a717-901a966da04c
md"""
In Julia
"""

# ╔═╡ cb17d0e7-3e69-4279-83c8-15e5a92815c2
StatsBase.median(stichprobe)

# ╔═╡ ebe77f7a-b85b-409d-b57c-786354a385bc
md"""
oder 'von Hand'. Die Division liefert einen Fließkomma-Zahl, die erst in ein Integrer gewandelt werden muss, bevor sie als Index verwendet werden kann.
"""

# ╔═╡ 50779ec0-0cc2-420d-9337-89240cd31548
sort(stichprobe)[Int32(length(stichprobe)/2)]

# ╔═╡ e249afb3-2028-4b9e-828b-e757f2f27ee4
md"""
Analog zum Median kann man die sortierte Stichprobe an anderen Stellen als der Mitte auslesen. Das untere bzw. obere  **Quartil**  liest den Wert bei $1/4$ bzw. $3/4$. **Perzentile** lesen bei $p$ Prozent aus. Allgemein nennt man diese Maße [Quantile](https://de.wikipedia.org/wiki/Empirisches_Quantil).
"""

# ╔═╡ 11d40f7a-2c4c-4d64-843e-50824e19d10b
md"""
Das 2%-Perzentil unseres Datensatzes ist
"""

# ╔═╡ 11394695-2a1c-4192-be2f-32a5250d0edc
StatsBase.percentile(stichprobe, 2)

# ╔═╡ 29959a13-a44b-49c9-86a1-c54c64403ebd
md"""
Die Quartilen sind 
"""

# ╔═╡ df8a3bc3-3980-4522-8a19-ee7264ea442e
StatsBase.nquantile(stichprobe, 4)

# ╔═╡ 0f017280-7a66-49f3-81a7-70dcba51a6a7
md"""
wobei die beiden 'äußeren' Werte das Minimum und das Maximum des Datensatzes angeben
"""

# ╔═╡ cd7b6262-004e-47bc-bacc-c23088a154b9
minimum(stichprobe), maximum(stichprobe)

# ╔═╡ a45c2888-98fe-42fc-b9ca-f307efb6831f
md"""
Die **Varianz** ist ein Maß für die Streuung der Datenpunkte
```math
\text{var} = \frac{1}{n-1} \sum_{i=1}^n \, (x_i - \bar{x})^2 = 
\frac{1}{n-1} \left[ \sum_{i=1}^n x_i^2 -\frac{1}{n} \left( \sum_{i=1}^n x_i \right) ^2 \right]
```
Die **Standardabweichung** ist die Wurzel der Varianz
```math
 \sigma = \sqrt{\text{var}} = \sqrt{\frac{1}{n-1} \sum_{i=1}^n \, (x_i - \bar{x})^2}
```
Man beachte den Term $n-1$ in dieser Definition. Es gibt eine sehr ähnliche Definition mit $n$ an Stelle von $n-1$, nur dass dann auch $\bar{x}$ durch $\mu$ ersetzt ist. Doch dazu mehr in dem Kapitel über Schätzer.
"""

# ╔═╡ f6fc5b01-6ea3-411f-bf12-878a4638bc01
md"""
In Julia 'von Hand' ist die Standardabweichung unsere Stichprobe
"""

# ╔═╡ 22e24d5a-5f53-4c38-ab48-fe3de8589057
sqrt(sum( (stichprobe .- mean(stichprobe)).^2) / (length(stichprobe)-1))

# ╔═╡ 8a0f6def-dfb6-4aca-a440-dfda31dd232c
md"""
Es geht auch mit der 'eingebauten' Funktion 'std'. Durch 'corrected' kann man zwischen der Variante $n-1$ (true) und $n$ (false) umschalten.
"""

# ╔═╡ d50a9c8b-08d8-4fcf-a2da-0c1cb0ff4021
std([1,2,3], corrected=false), sqrt(2/3) , std([1,2,3], corrected=true)

# ╔═╡ fa6d85be-0f22-438b-99b0-ec714ef2b514
md"""
oder aus 'StatsBase' Mittelwert und Standardabweichung in einem Aufwasch
"""

# ╔═╡ 9a681882-c8bd-4c99-979e-ca632e37e173
StatsBase.mean_and_std( [1,2,3], corrected=true)

# ╔═╡ b6921ce5-7144-484b-96e0-5276eb244b36
md"""
Man kann die Definition der Varianz ausbauen zu  allgemeinen **statistischen Momenten**. Das dritte Moment ist die **Schiefe** (engl. skewness) 
```math
\frac{1}{n} \sum \left( \frac{x_i - \bar{x}}{\sigma} \right)^3
```
und das vierte die  **Wölbung** (engl. kurtosis)
```math
\frac{1}{n} \sum \left( \frac{x_i - \bar{x}}{\sigma} \right)^4
```
Durch die Division durch die Standardabweichung sind diese Momente einheitenfrei.
"""

# ╔═╡ d879445f-3379-4b82-8fbe-05354de4b7a7
md"""
In Julia
"""

# ╔═╡ e2018d1a-52ed-427b-9f1b-d6c50a1f18a5
StatsBase.skewness(stichprobe), StatsBase.kurtosis(stichprobe)

# ╔═╡ fcdde392-2566-4d03-a759-b736f5a26455
md"""
## Kennzahlen klassierter Daten
"""

# ╔═╡ cc65205c-776a-4dbb-b8d3-625d268a24ef
md"""
Schon beim Histogramm hatten wir Daten in Klassen eingeteilt. Alle Messwerte, die in ein gewisses Temperatur-Intervall gefallen sind, zählten zum gleichen Balken des Histogramms. Manchmal möchte man solche klassierte Daten weiter verarbeiten, manchmal liegen Daten auch direkt nur klassiert vor. Ein Beispiel ist die Notenverteilung einer Klausur. Die Noten können dabei nur wenige verschiedene Werte annehmen.
"""

# ╔═╡ be18fc94-6a7a-4959-8f02-9bc118969d18
md"""
Auch aus klassierten Daten kann man die oben besprochenen Kennzahlen berechnen. Sei $c_l$ die Grenze der Klassen, und somit $z_l = (c_{l-1} + c_l) /2$ die Mitten der Klassen. Beim Übergang zu klassierten Daten ersetzt man in den Gleichen oben jedes $x_i$ durch 'seine' Klassenmitte $z_{l(i)}$, summiert also weiterhin über $i$. Dabei sind dann natürlich viele $z_{l(i)}$ identisch, so dass man diese Teilsummen ausklammern kann und durch die Anzahl $h_l$ der Werte in der Klasse $l$ ersetzen kann.
"""

# ╔═╡ 07e79d80-b780-44e2-869a-5e97bcd075c1
md"""
Ausgeschrieben ergibt sich für den **Mittelwert**
```math
\bar{x} \approx \frac{1}{n} \sum_l h_l z_l
```
und die **Varianz**
```math
\text{var} \approx \frac{1}{n-1} \sum_l h_l (z_l - \bar{x})^2 = 
\frac{1}{n-1} \left( \sum_l h_l z_l^2  - n\bar{x}^2 \right) 
```
weil $\sum_l h_l = n$.
"""

# ╔═╡ ed6f00d8-9ade-47ca-86f6-7018f40426a2
md"""
# Boxplot

Wenn man verschiedene Stichproben auf einen Blick vergleichen will, dann ist der 'boxplot' hilfreich. Er zeichnet eine Kiste vom  oberen zum unteren Quartil mit einem Strich beim Median. Die 'Fehlerbalken' haben typischerweise die Länge von 1.5 mal der Kistenhöhe, werden aber zum nächstgelegenen Wert nach 'innen' gerundet. Alle weiter außen liegenden Werte werden eingezeichnet.
"""

# ╔═╡ bedcae55-ad81-485a-872e-6cafb82bde86
using StatsPlots

# ╔═╡ 816438b7-4fc0-4581-a7a0-b375ec4e88be
 StatsPlots.boxplot(datensatz.Tist, ylabel = "Temperatur (deg. C)", legend=false, xaxis=false)

# ╔═╡ 59832eb9-b4fa-4a5b-97a0-d96f532e82cc
md"""
So kann man gut mehrere Verteilungen vergleichen.
"""

# ╔═╡ 4de3b412-3ad3-448b-8f38-ea6ca09ce337
StatsPlots.boxplot([ datensatz.Tist, datensatz.Kuelhlluft,  datensatz.Zuluft], ylabel = "Temperatur (deg. C)",  xticks = (1:3, ["T ist", "Kühlluft", "Zuluft"]), legend=false)

# ╔═╡ 0e889909-9ded-438f-bdd5-4989eb6cdddf
md"""
# Mehrdimensionale Daten
"""

# ╔═╡ af438416-7d6f-44b3-980e-cd6823688008
md"""
Oft werden mit einer Beobachtung, einer Messung mehrere Größen gemessen. Damit erhält man mehrdimensionale oder multivariate Daten.

Im Prinzip war schon unser Temperatur-Beispiel von oben mehrdimensional, da wir zu jedem Zeitpunkt nicht nur die Raumtemperatur, sondern auch Temperaturen an anderen Stellen vorliegen hatten. Die hatten wir bisher ignoriert. Nun nehmen wir sie hinzu, und auch noch die gleichzeitige Messung der gleichen Größen in anderen Räumen.
"""

# ╔═╡ 64fe649e-9b17-451f-8d3f-7112514bb7fe
md"""
Wir laden vier Dateien in eine gemeinsame Variable
"""

# ╔═╡ 11affb9f-2d9a-47a4-9cb1-2e6ead3de727
begin 
	räume = ["1_0_05_1","1_0_05_3","2_0_08","3_0_07"]
	files = ["https://raw.githubusercontent.com/MarkusLippitz/teca/main/res/02-beschreibende-statistik/Temperatur_$(r)_Tag_210801.dat" for r in räume]
	datensätze = CSV.read.(download.(files), DataFrame; delim='\t', header=5)
	# man beachte den Punkt in "read.(download" und den in "download.(files" !
	# -> Wende alles auf alle Eintröge in "räume" an
end;

# ╔═╡ aa04f999-0979-47a3-8694-7de7df4ebf21
md"""
Zunächst stellen wir wieder die Daten als Funktion der Zeit dar. Die erste Ziffer der Raumnummer bezeichnet das Gebäudeteil im BGI. In Bauteil 1 scheint die Zuluft im Sommer merklich warm zu werden, in den Bauteilen 2 und 3 nicht.
"""

# ╔═╡ 8997748b-bcd3-44e6-aecb-e003a3ed0a12
begin
	plot()  # generate empty plot
	for i in 1:length(räume) # plot 4 traces on top of each other
	   plot!(datensätze[i].Time, datensätze[i].Zuluft, label=räume[i]) 
	end
	plot!() # show last plot
end

# ╔═╡ 6becffb6-1810-4c21-8d81-28cb2021cdfe
md"""
In einem **Streudiagramm** stellt man eine Größe gegenüber der anderen dar, um so Zusammenhänge zu erkennen. Wenn die Punkte sehr dicht liegen reduziert das die Aussagekraft. Hier ist einfach nur jeder 50. Datenpunkt gezeichnet.
"""

# ╔═╡ 30c6734d-4aad-4065-8604-7e3d91fa59fb
let
	dec = 50
	plot([20.9, 23.8], [20.9, 23.8], label="Diagonale")
	Plots.scatter!(datensätze[1].Zuluft[1:dec:end], datensätze[2].Zuluft[1:dec:end], 
		label="1 vs 2",  markersize=2, markerstrokewidth=0)
	Plots.scatter!(datensätze[3].Zuluft[1:dec:end], datensätze[4].Zuluft[1:dec:end],  
		label="3 vs 4",markersize=2, markerstrokewidth=0, 
		xlabel="Zuluft A", ylabel="Zuluft B",aspect_ratio=:equal,)
end

# ╔═╡ a844007c-4e7d-4c47-b7e8-4ae39e9c0f02
md"""
Alternativ kann man ein zweidimensionales Histogramm zeichnen, und die Anzahl pro bin farbkodieren.
"""

# ╔═╡ e908d5e3-563b-4982-8e5b-5e642bb62ef0
Plots.histogram2d(datensätze[3].Zuluft, datensätze[4].Zuluft, bins=100,aspect_ratio=:equal, xlabel="Zuluft 3", ylabel="Zuluft 4", colorbar_title="Anzahl")

# ╔═╡ 2b1f9027-176f-46f9-981e-387042dddb2b
md"""
# Produktmomenten-Korrelation
"""

# ╔═╡ f5d85c34-d26d-4e72-b64d-5baa966555db
md"""
Eine Kennzahl für den Zusammenhang zwischen zwei Messgrößen ist die *Korrelation*, von der es verschiedene Varianten gibt.
"""

# ╔═╡ 39dd4490-fbce-43c2-b216-721e73613281
md"""
Zunächst normieren wir die einzelnen Messwerte so, dass deren Mittelwert 0 und deren Standardabweichung 1 beträgt. Wir definieren also
```math
\tilde{x}_i = \frac{x_i - \bar{x}}{\sigma_x}
```
und analog für die zweite Größe $y_i$. Wenn nun $\tilde{x}_i$ und $\tilde{y}_i$ beide gleichzeitig positiv, oder beide gleichzeitig negativ sind, dann entspricht dies einem gewissen positiven Zusammenhang zwischen $x_i$ und $y_i$. Ein einfaches Maß für diesen Zusammenhang ist das Produkt $\tilde{x}_i \tilde{y}_i$, also 
```math
r_{xy} = \frac{1}{n-1} \sum_i \tilde{x}_i \tilde{y}_i
```

"""

# ╔═╡ 5799aa7b-ef1c-430e-8739-b755c6e743ad
md"""
Dies ist die (einfache) **Korrelation**, oder  auch *Produktmomenten-Korrelation nach Pearson*. Wir können das noch etwas umformen
```math
r_{xy} = \frac{\text{var}_{xy}}{\sigma_x \sigma_y} \quad \text{mit} \quad  \text{var}_{xy} = \frac{1}{n-1} \sum_i (x_i - \bar{x})(y_i - \bar{y})
```
Die Kovarianz $\text{var}_{xy}$  ist sehr analog zur Varianz, nur das das Quadrat einer Größe durch das Produkt von zwei Größen ersetzt wird.
"""

# ╔═╡ b68d6412-2656-43f3-a393-10e325b35d24
md"""
Einfache Spezialfälle sind $x_i = y_i$, was $r_{xy} = 1$ ergibt. Falls ein linearer Zusammenhang besteht  in der Art $y_i = a + b x_i$, dann ist ebenfalls $r_{xy} = 1$, falls $b>0$, und $r_{xy} = -1$, falls $b<0$. Die Produktmomenten-Korrelation  misst also die Stärke des linearen Zusammenhangs.
"""

# ╔═╡ 510f698a-dee9-4e67-9ade-57289689f189
md"""
In Julia ist geht das via StatsBase
"""

# ╔═╡ f7d815df-8c7c-4994-9f4a-5d3697bac3ca
StatsBase.cor(datensätze[3].Zuluft, datensätze[4].Zuluft)

# ╔═╡ 7847ec0b-df92-4dd0-abe9-37dc8eae5b56
StatsBase.cor(datensätze[1].Zuluft, datensätze[2].Zuluft)

# ╔═╡ ab22c5f2-908e-4bbf-a67a-4b1157a10023
md"""
oder von Hand
"""

# ╔═╡ e7281c97-750b-473b-9860-e786a44e26a0
let
	x = datensätze[3].Zuluft
	y = datensätze[4].Zuluft
	(m_x, σ_x) =  StatsBase.mean_and_std( x, corrected=true)
	(m_y, σ_y) =  StatsBase.mean_and_std( y, corrected=true)
	xt = (x .- m_x) ./ σ_x
	yt = (y .- m_y) ./ σ_y
	cor = sum( xt .* yt) / (length(xt)-1)
end

# ╔═╡ 80e3d9db-e6e9-4e64-9a28-123141079edb
md"""
**Achtung** Diese Produktmomenten-Korrelation misst nur die Stärke eines linearen Zusammenhangs. Es können noch andere Zusammenhänge höherer Ordnung vorhanden sein, die bei gleichem $r_{xy}$ sehr verschiedene Streudiagramme bewirken! Die Korrelation ist nicht robust gegen Ausreißer.
"""

# ╔═╡ 79810bad-ceb4-42a0-8b16-53f25004250b
md"""
# Rangkorrelation
"""

# ╔═╡ 7ca6a708-e123-406a-9987-ad52f9323224
md"""
Ähnlich zum Unterschied zwischen Mittelwert und Median, kann man auch eine Korrelation nicht zwischen den Werten an sich, sondern zwischen den Rängen berechnen. Hier spielen Ausreißer dann quais keine Rolle mehr.
"""

# ╔═╡ 58a063d6-6dd3-4e08-abe7-357e96d5eac9
md"""
Analog definieren wir die Spearmansche Rangkorrelation
```math
r_{xy}^\text{(Sp)} = \frac{\text{var}_\text{Rang(x) Rang(y)}}{\sigma_\text{Rang(x)} \sigma_\text{Rang(y)}} 
```
"""

# ╔═╡ eaff35b0-be07-495d-9aec-92f1f64a2b22
md"""
Der Mittelwert aller Ränge ist 
```math
\bar{\text{Rang}(x)}  = \frac{1 + 2 + \dots + n}{n} = \frac{n+1}{2}
```
Die Standardabweichung ist **XXX TODO** und die Kovarianz
```math
\text{var}_\text{Rang(x) Rang(y)} = \frac{1}{n-1} \sum_i \left( \text{Rang}(x_i) - \frac{n-1}{2} \right)\left( \text{Rang}(y_i) - \frac{n-1}{2} \right)
```
Zusammen ergibt das
```math
r_{xy}^\text{(Sp)} = 1 - \frac{6}{n(n^2 -1)} \sum_i ( \text{Rang}(x_i)  -  \text{Rang}(y_i) )^2
```
"""

# ╔═╡ c100060d-1a84-47a6-bcdd-0105e23190d9
md"""
In Julia ist das
"""

# ╔═╡ 288f3592-ab4c-434b-a882-5708959543ef
StatsBase.corspearman(datensätze[3].Zuluft, datensätze[4].Zuluft)

# ╔═╡ 47f61db3-26fe-4dee-9bc9-438434a94530
StatsBase.corspearman(datensätze[1].Zuluft, datensätze[2].Zuluft)

# ╔═╡ 8e1ad6b0-07ec-4d6d-baed-33046cb539dc
md"""
## Achtung

- Eine Korrelation ist keine Kausalität. Nur weil etwas korreliert ist, heißt das noch nicht, dass es einen interessanten Grund dafür gibt. Die Größe der Storchenpopulation in Deutschland ist sicherlich mit der Geburtenrate der letzten 50 Jahre korreliert.

- Korrelationen können auch entstehen, in dem man beide Größen $x$ und $y$ mit einer gemeinsamen Größe $z$ normiert. Dann ist ggf. $x/z$ mit $y/z$ korreliert, obwohl $x$ nicht mit $y$ korreliert ist.
"""

# ╔═╡ d6660328-b1af-4c1b-94d4-48c58858f166
md"""
# Lineare Regression
"""

# ╔═╡ 6715ac8c-207c-4ec1-8b8d-c7e7ff5d8a6c
md"""
Auch eine lineare Regression sucht nach einem linearen Zusammenhang zwischen $x_i$ und $y_i$. Der Unterschied liegt in der Interpretation der $x_i$. Bei der Korrelation waren die $x_i$ und die $y_i$ völlig gleichberechtigt. Es ist ja sogar $r_{xy} =  r_{yx}$. Bei einer linearen regression nimmt man die $x_i$ als 'unabhängige Variable' oder 'Ausgangsgröße' an. Diese Werte im Experiment vorgegeben, sind fest und fehlerfrei bekannt. Die $y_i$ sind die 'Zielgröße', der 'Messwert'. Die Aufgabe der linearen Regression ist es, aus bekanntem $x$ ein noch zu messendes $y$ vorherzusagen. B
"""

# ╔═╡ 99734a5a-f5f7-4168-9232-653802efaced
md"""
Bei der linearen Regression suchen wir die Parameter $(a,b)$ einer Funktion 
```math
f(x) = a + b x
```
so dass die Abweichung zwischen vorhergesagtem Wert $f(x_i)$ und gemessenen Wert $y_i$ möglichst klein wird. Dazu betrachten wir die *Residuen*
```math
\Delta_i (a,b) = y_i - (a + b x_i)
```

"""

# ╔═╡ 80a96166-c072-4e5f-991e-9400ae506959
md"""
Ein oft verwendetes Maß ist die Summe der Quadrate der Abweichungen (*Methode der kleinsten Quadrate*)
```math
Q(a,b) = \sum_i [\Delta_i(a,b)]^2
```
"""

# ╔═╡ a6d27afc-3984-4262-87e8-85eee8928560
md"""
Wir wollen $Q(a,b)$ minimieren, suchen also Nullstellen der Ableitungen nach $a$ und $b$. Man findet (siehe z.B. Stahel)
```math
b = r_{xy} \frac{\sigma_y}{\sigma_x} \quad \text{und} \quad a = \bar{y} - b \bar{x}
```
"""

# ╔═╡ 1270488f-b477-4385-86eb-46d4f5955d7f
md"""
Man erkennt den Zusammenhang zwischen Regression und Korrelation durch das Auftauchen von $r_{xy}$.
"""

# ╔═╡ 12fc470d-34cc-4ef2-9f56-cd3daf740818
md"""
In Julia geht das beispielsweise über das Anpassen eines Polynoms 1. Grades
"""

# ╔═╡ f03912ab-9f15-46fb-87f9-b7f38d7c61e1
using Polynomials

# ╔═╡ 5283eb9f-c65e-4aaa-aa2a-3e4624cce6f9
Polynomials.fit(datensätze[3].Zuluft, datensätze[4].Zuluft, 1)

# ╔═╡ dafcdb72-fbcd-4602-93f4-ed3df42ac060
md"""
oder 'von Hand'
"""

# ╔═╡ 00fd8596-437c-4a02-b6b1-d61c92931e3f
let
	x = datensätze[3].Zuluft
	y = datensätze[4].Zuluft
	(m_x, σ_x) =  StatsBase.mean_and_std( x, corrected=true)
	(m_y, σ_y) =  StatsBase.mean_and_std( y, corrected=true)
	r_xy = StatsBase.cor(x,y)

	b = r_xy * σ_y  / σ_x
	a = m_y - b * m_x
	(a,b)
end

# ╔═╡ 4cc419da-89a8-4f12-b94c-881b4c1ba20e
md"""
Oder ganz allgemein über einen 'least square fit' (kleinste Quadrate [der Residuen])
"""

# ╔═╡ 69726543-b247-44ce-b5e3-1672e9b5b3a1
using LsqFit

# ╔═╡ 1749f0c5-ae4b-47e7-8733-e719d1386933
let
	x = datensätze[3].Zuluft
	y = datensätze[4].Zuluft
	model(x, p) = p[1]  .+ p[2] .* x  # Zielfunktion
	p0 = [0.5, 0.5]  # Start-Parameter
	fit = LsqFit.curve_fit(model, x, y, p0)
	fit.param
end

# ╔═╡ 2ee624de-2124-4f5e-82e6-46fd1c7dc62b
using PlutoUI,  LinearAlgebra

# ╔═╡ d326a92d-23b2-43d4-b984-c51b9dd6a905
TableOfContents(title="Inhalt")

# ╔═╡ Cell order:
# ╟─c58f76d9-45e8-4d72-9bce-f69321ee64d4
# ╟─f4be8945-c54d-4162-8ee1-2fe3cfb078f1
# ╟─dad2a7b0-f900-4a77-b7a3-b2b49d38ce14
# ╟─8cd8d8ea-5ece-4eec-8e46-13a52aed1d3a
# ╟─dcba4d9e-89d9-4fac-820a-fb24da9b1916
# ╠═049ea5c2-b2e9-4524-965e-0db726134f1d
# ╟─52f64c20-a045-4ee6-a307-f50af60eae49
# ╠═1868cca5-3cfb-4376-8468-d13831366cc9
# ╟─436b8f12-d833-42ec-b85c-31eb96ad862a
# ╠═70e91e6e-864a-4e9a-ab7d-c592833c1f59
# ╟─9ec97d94-274a-43e0-ae46-aa89d6149f0b
# ╟─88143e8d-1a08-4aca-9f42-63c39c8ec0e9
# ╠═ed832ad1-62f1-4ef6-a5d3-12e6bd2b60cd
# ╠═d2ec129a-e27e-46fe-a066-6883cab53aab
# ╟─1213593e-89dc-44a7-94e9-9868bd08c715
# ╟─fe5d30f7-74f8-4b4b-b604-ee2d30fe8f33
# ╠═10c78be3-c1a3-4808-b136-189ddba7e53f
# ╟─23509c7d-9e69-4f25-9839-ea9785cb7b75
# ╟─dc930a35-3705-40bd-9832-b13b084da3f1
# ╠═22592e54-a24b-446d-bde0-93ec4c802b9b
# ╠═51626ee2-e509-4cae-9f0e-1cf448b5b5e0
# ╠═dbc3c042-3bb8-492c-810a-a3caf45ff794
# ╠═532ab0aa-bc85-49b7-a577-124109ab53a1
# ╟─1f7dc3da-ab8d-4bc5-8bba-ee1d82d6b7a4
# ╠═975e9fa8-d627-40a7-96ec-206b7e4809c7
# ╟─610cd280-d3b8-47c9-ad6e-4fb1577a6c4c
# ╟─00ec87d6-4b4d-42d7-a315-885ef16649a6
# ╟─3980b93b-dca5-41e8-9db5-b9ec5bb06b86
# ╠═447f26d1-41f1-4fe1-aa5c-004ec9d18a36
# ╟─0a755560-a580-41f2-9327-724882fb154f
# ╠═c7d415fc-9564-4f8b-b503-ae09f9d17bb9
# ╟─cdcd6224-6964-4774-a941-ff67c65d0568
# ╠═3b5ce183-9dc1-452f-aa7c-d1f35ad6614f
# ╟─c21b3673-2c16-4e28-b155-9e9ec54ca84f
# ╠═fded84d1-cb5b-4b51-940c-3772594e3aeb
# ╟─f20230a5-2fe9-4907-b5e4-13a98482eb56
# ╠═25b6f838-a496-4b4e-a456-478d4eb1b536
# ╟─98330947-bb95-4f2e-a380-991891a3328b
# ╠═84dc49a5-642f-42d1-8520-a1f338991531
# ╟─cb609ac3-0e0c-4db2-abb3-528371c46c46
# ╠═7e8bf5e0-284e-478c-89e1-08ffee174e13
# ╟─51c2555f-7040-4f56-840c-5e9462561d31
# ╠═12a9d1d8-a5ca-4500-a804-183821a9d026
# ╟─73c659cb-22df-460b-97ea-ddccb2ebb1bb
# ╟─eff8db42-396e-4570-8244-6c5cadd7d92e
# ╠═b19f652c-ec11-457d-8566-3aa53d3f6c71
# ╠═284bb169-bdaf-416a-8f5d-7fd53689913d
# ╟─5ae473fc-320d-4b75-8052-311fc074b5d9
# ╠═c3284711-b881-496d-b9ad-68d4865d60d2
# ╟─ba05d98f-605f-4c2f-a4bd-be91af6d60c8
# ╟─a5e5dfb3-81cc-4365-8036-c5b6444df798
# ╠═d17a2490-23a1-43ca-bf93-a26f08e8dbd5
# ╟─7df3ac3b-f6cd-4a43-9803-7cff9d544332
# ╠═f44f734c-4e33-4e3d-992c-d212e3925832
# ╟─7108dfab-f3f0-4c83-ba59-e5cb7307418c
# ╟─606efab3-a405-4cd5-a717-901a966da04c
# ╠═cb17d0e7-3e69-4279-83c8-15e5a92815c2
# ╟─ebe77f7a-b85b-409d-b57c-786354a385bc
# ╠═50779ec0-0cc2-420d-9337-89240cd31548
# ╟─e249afb3-2028-4b9e-828b-e757f2f27ee4
# ╟─11d40f7a-2c4c-4d64-843e-50824e19d10b
# ╠═11394695-2a1c-4192-be2f-32a5250d0edc
# ╟─29959a13-a44b-49c9-86a1-c54c64403ebd
# ╠═df8a3bc3-3980-4522-8a19-ee7264ea442e
# ╟─0f017280-7a66-49f3-81a7-70dcba51a6a7
# ╠═cd7b6262-004e-47bc-bacc-c23088a154b9
# ╟─a45c2888-98fe-42fc-b9ca-f307efb6831f
# ╟─f6fc5b01-6ea3-411f-bf12-878a4638bc01
# ╠═22e24d5a-5f53-4c38-ab48-fe3de8589057
# ╟─8a0f6def-dfb6-4aca-a440-dfda31dd232c
# ╠═d50a9c8b-08d8-4fcf-a2da-0c1cb0ff4021
# ╟─fa6d85be-0f22-438b-99b0-ec714ef2b514
# ╠═9a681882-c8bd-4c99-979e-ca632e37e173
# ╟─b6921ce5-7144-484b-96e0-5276eb244b36
# ╟─d879445f-3379-4b82-8fbe-05354de4b7a7
# ╠═e2018d1a-52ed-427b-9f1b-d6c50a1f18a5
# ╟─fcdde392-2566-4d03-a759-b736f5a26455
# ╟─cc65205c-776a-4dbb-b8d3-625d268a24ef
# ╟─be18fc94-6a7a-4959-8f02-9bc118969d18
# ╟─07e79d80-b780-44e2-869a-5e97bcd075c1
# ╟─ed6f00d8-9ade-47ca-86f6-7018f40426a2
# ╠═bedcae55-ad81-485a-872e-6cafb82bde86
# ╠═816438b7-4fc0-4581-a7a0-b375ec4e88be
# ╟─59832eb9-b4fa-4a5b-97a0-d96f532e82cc
# ╠═4de3b412-3ad3-448b-8f38-ea6ca09ce337
# ╟─0e889909-9ded-438f-bdd5-4989eb6cdddf
# ╟─af438416-7d6f-44b3-980e-cd6823688008
# ╟─64fe649e-9b17-451f-8d3f-7112514bb7fe
# ╠═11affb9f-2d9a-47a4-9cb1-2e6ead3de727
# ╟─aa04f999-0979-47a3-8694-7de7df4ebf21
# ╠═8997748b-bcd3-44e6-aecb-e003a3ed0a12
# ╟─6becffb6-1810-4c21-8d81-28cb2021cdfe
# ╠═30c6734d-4aad-4065-8604-7e3d91fa59fb
# ╟─a844007c-4e7d-4c47-b7e8-4ae39e9c0f02
# ╠═e908d5e3-563b-4982-8e5b-5e642bb62ef0
# ╟─2b1f9027-176f-46f9-981e-387042dddb2b
# ╟─f5d85c34-d26d-4e72-b64d-5baa966555db
# ╟─39dd4490-fbce-43c2-b216-721e73613281
# ╟─5799aa7b-ef1c-430e-8739-b755c6e743ad
# ╟─b68d6412-2656-43f3-a393-10e325b35d24
# ╟─510f698a-dee9-4e67-9ade-57289689f189
# ╠═f7d815df-8c7c-4994-9f4a-5d3697bac3ca
# ╠═7847ec0b-df92-4dd0-abe9-37dc8eae5b56
# ╟─ab22c5f2-908e-4bbf-a67a-4b1157a10023
# ╠═e7281c97-750b-473b-9860-e786a44e26a0
# ╟─80e3d9db-e6e9-4e64-9a28-123141079edb
# ╟─79810bad-ceb4-42a0-8b16-53f25004250b
# ╟─7ca6a708-e123-406a-9987-ad52f9323224
# ╟─58a063d6-6dd3-4e08-abe7-357e96d5eac9
# ╟─eaff35b0-be07-495d-9aec-92f1f64a2b22
# ╟─c100060d-1a84-47a6-bcdd-0105e23190d9
# ╠═288f3592-ab4c-434b-a882-5708959543ef
# ╠═47f61db3-26fe-4dee-9bc9-438434a94530
# ╟─8e1ad6b0-07ec-4d6d-baed-33046cb539dc
# ╟─d6660328-b1af-4c1b-94d4-48c58858f166
# ╟─6715ac8c-207c-4ec1-8b8d-c7e7ff5d8a6c
# ╟─99734a5a-f5f7-4168-9232-653802efaced
# ╟─80a96166-c072-4e5f-991e-9400ae506959
# ╟─a6d27afc-3984-4262-87e8-85eee8928560
# ╟─1270488f-b477-4385-86eb-46d4f5955d7f
# ╟─12fc470d-34cc-4ef2-9f56-cd3daf740818
# ╠═f03912ab-9f15-46fb-87f9-b7f38d7c61e1
# ╠═5283eb9f-c65e-4aaa-aa2a-3e4624cce6f9
# ╟─dafcdb72-fbcd-4602-93f4-ed3df42ac060
# ╠═00fd8596-437c-4a02-b6b1-d61c92931e3f
# ╟─4cc419da-89a8-4f12-b94c-881b4c1ba20e
# ╠═69726543-b247-44ce-b5e3-1672e9b5b3a1
# ╠═1749f0c5-ae4b-47e7-8733-e719d1386933
# ╠═2ee624de-2124-4f5e-82e6-46fd1c7dc62b
# ╠═d326a92d-23b2-43d4-b984-c51b9dd6a905
