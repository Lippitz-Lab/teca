### A Pluto.jl notebook ###
# v0.19.0

using Markdown
using InteractiveUtils

# ╔═╡ e93ef54a-4a0b-4ed1-a476-e980224934bf
using PlutoUI

# ╔═╡ f5450eab-0f9f-4b7f-9b80-992d3c553ba9
# DO NOT MODIFY, will be updated by update_navbar.jl
HTML("    <nav >\n    Vorbereitungen:\n\n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/index.html\"><em>Intro</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/software.html\"><em>Software</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/01-basic_syntax.html\"><em>Julia Basics</em></a> / \n\n<br>\nStatistik:\n\n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/02-beschreibende-statistik.html\"><em>Beschreibende Statistik</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/03-wahrscheinlichkeit.html\"><em>Wahrscheinlichkeit</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/04-schaetzung.html\"><em>Schätzung</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/05-messunsicherheit.html\"><em>Messunsicherheit</em></a> / \n\n<br>\nFourier-Transformation:\n\n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/06-Fourier-Transformation.html\"><em>Fourier-Transformation</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/07-Frequenzraum.html\"><em>Frequenzraum</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/08-Filter.html\"><em>Filter</em></a> / \n\n<br>\nMesstechnik:\n\n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/09-Rauschen.html\"><em>Rauschen</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/10-Detektoren.html\"><em>Detektoren</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/11-Lock-In.html\"><em>Lock-In-Verstärker</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/12-heterodyn.html\"><em>Heterodyn-Detektion</em></a> / \n\n<br>\n\n\n    </nav>\n\t")

# ╔═╡ d0a1d87c-10a3-41f7-947a-32f4262001a2
html"""<div>
<font size="7"><b>9 Rauschen</b></font> </div>

<div><font size="5"> Markus Lippitz</font> </div>
<div><font size="5"> 2. Mai 2022 </font> </div>
"""

# ╔═╡ 262685e2-96f3-11ec-15c6-5f0a5e79b66b
md"""
**Ziel** Sie können den Ursprung von Rauschquellen in optischen
Messungen *identifizieren*.

-   Rauschen-Spektren: 1/f, weiß

-   Physikalischer Ursprung von Rauschen: Schrot, thermisch

-   Leistungsabhängigkeit

-   Maße für Signalamplituden: pp, RMS, Leistung

**Weitere Aufgaben**

-   Temperaturabhängigkeit von Widerstandsrauschen.

**Literatur** Horowitz / Hill, Kap. 7.18--21, Müller:
Rauschen,
"""

# ╔═╡ 4a39a01c-0001-4297-8e3e-230ad8bdaccb
md"""
# Überblick

Rauschen beschreibt die zeitliche Fluktuation einer Messgröße um ihren
Mittelwert. Hier werden wir verschiedene Aspekte des Verlaufs im Zeit-
und Frequenzraum sowie des physikalischen Ursprungs betrachten. Rauschen
wird in verschiedenen Büchern zur Elektronik am Rande betrachtet
(beispielsweise Horowitz / Hill: Art of Electronics). Details finden
sich in R. Müller: Rauschen (Springer Verlag) und A. Blum:
Elektronisches Rauschen (Teubner Verlag).
"""

# ╔═╡ a2ea1556-2426-49d3-ac21-732a0831742d
md"""
# Beschreibung im Zeitbereich  

Eine Größe $A(t)$ schwankt um ihren zeitlichen Mittelwert
$\left< A \right>$, also $A(t) = \left< A \right> + a(t)$. Zur
Beschreibung von $a$ bzw. $A$ werden die Methoden zur Beschreibung von
Zufallsvariablen benutzt, wie beispielsweise in Stahel: Statistischer
Datenanalyse dargestellt. Nur auf wenige soll hier gesondert eingegangen
werden.
"""

# ╔═╡ 485cb4fb-1346-44e5-9153-e2c1e5cc3209
md"""
## Schwankungsquadrat (root mean square value)  

Die Standard-Abweichung $\sigma = \sqrt{ \left< a(t) ^2 \right> }$, also
die Wurzel aus dem Mittelwert der quadratischen Abweichung, ist ein
gutes Maß für die Amplitude des Rauschens und wird im Englischen 'root
mean square (rms) value' genannt.

Oft muss die Amplitude von Rauschen mit der eines bekannten Signals
verglichen werden. Der rms-Wert einer Sinus-Oszillation
$a \sin (\omega t)$ ist $a/\sqrt{2}$, der eines Rechteck-Signals der
Amplitude $\pm a$ ist $a$. Oft wird die Amplitude des Signals auch als
Spitze-Spitze-Wert (peak-peak) angegeben, der bei dieser Definition
jeweils $2a$ ist.
"""

# ╔═╡ 805130c8-8019-4ad0-b2b1-80a4743cb09b
md"""
## Zufällige Folge von Impulsen  

Oft findet man Signale, die aus einer zufälligen Folge von identischen
Impulsen bestehen. Jeder Impuls hat den zeitlichen Verlauf $g(\tau)$.
Das Gesamt-Signal ist dann
```math
A(t) = \sum_i  g(t - t_i) = g(\tau)  \otimes  \sum_i \delta(t - t_i)
```
wobei $t_i$ die Ankunftszeit des i-ten Pulses ist. Dies lässt sich auch
schreiben als Faltung der Impulsform in einer Sequenz von Delta-Pulsen.

In einem Zeitintervall der Länge $T$ seien $n = z  \, T$ Pulse zu
finden. $z$ ist also die zeitliche Impulsdichte. Diese Zahl $n$ folgt
einer Poisson-Verteilung, wie wir sie für solche Zählungen von seltenen
Ereignissen erwarten. Damit kennen wir die Varianz der Impulsdichte, die
in der Poisson-Verteilung dem Erwartungswert entspricht. Für das Quadrat
des rms-Werts gilt damit
```math
\sigma^2 =  n \, \left< g(\tau)^2 \right> = z \,   \int g(\tau)^2 \, d \tau  \quad .
```
"""

# ╔═╡ a3bbfe35-cddb-4f3c-a97e-b5e900b61f50
md"""
# Beschreibung im Frequenzbereich 

Parsevals Theorem verknüpft das Betrags-Quadrat, also die Leistung,
eines Signals im Zeitraum mit dem im Frequenzraum (Butz, eq. 2.53)
```math
\int | f(t) |^2 dt = \frac{1}{2 \pi } 
   \int | F(\omega ) |^2 d \omega
``` 
wobei $f$ und $F$
Fourier-Transformierte voneinander sind. Das Betrags-Quadrat der
Fourier-Transformierten von $a(t)$ wird spektrale Leistungsdichte des
Rauschens $W(f)$ genannt. Es gilt (Müller, eq. 2.1)
```math
\int_{f > 0} W(f) \, df = \left< a(t)^2 \right>
``` 
Der Unterschied
zwischen $a$ und $A$ liefert nur einen zeitliche konstanten Wert und
damit einen Beitrag bei $f=0$, also
```math
\int_{f \ge 0} W(f) \, df = \left< A(t)^2 \right> \quad .
``` 
Sehr oft
interessiert Rauschen nur in einem schmalen Frequenzintervall der Breite
$B$, in dem es quasi konstant ist:
```math
\int_{f \in B} W(f) \, df =   W(f_0) \, B =  \left< a(t)^2 \right>|_B \quad .
```
"""

# ╔═╡ 8e66bbcc-7f58-44bd-bddc-450a2323edc3
md"""
## Einheiten 

Wenn die Messgröße $A$ die Einheit $V$ oder $W$ hat, so ist dies
ebenfalls die Einheit von $a$ und der Standard-Abweichung $\sigma$. Die
spektrale Leistungsdichte $W(f)$ hat dann aber die Einheit $V^2 / Hz$
bzw. $W^2 / Hz$. Eine zur Standard-Abweichung analoge Größe
$\sigma_B = \sqrt{ W(f_0) \, B }$ hat dann damit die Einheit
$V/\sqrt{Hz}$ bzw. $W/\sqrt{Hz}$. Diese etwas ungewöhnliche Einheit
$\sqrt{Hz}$ hat die gleiche Wurzel, die auch bei der Reduktion des
Fehlers durch mehrfaches Messen auftaucht: Wenn man $N$ Messungen macht,
dann reduziert sich der Fehler des Mittelwerts nur um $\sqrt{N}$. Für
$N$ Messungen benötigt man $N$ mal länger, also ist die Bandbreite der
Messung um den Faktor $N$ kleiner.
"""

# ╔═╡ b3f90972-efe4-49c6-8688-839f75633d75
md"""
## Zufällige Folge von Impulsen 

Auf die Überlegungen im Zeitraum aufbauend kann man vom Einzel-Puls im
Zeitraum $g(\tau)$ zu seiner Fourier-Transformierten $G(f)$ übergehen.
Damit ergibt sich für die Leistungsdichte
```math
W(f) = 2 \, z \, | G(f) |^2
``` 
Der Faktor $2$ rührt daher, dass die
Integrale über $W$ auf positive Frequenzen beschränkt sind.
"""

# ╔═╡ ea766c9f-1bf3-46e7-ac37-cb4ab7550468
md"""
# Thermisches Rauschen 

Die Elektronen in einem Leiter besitzen thermische Energie in Form von
kinetischer Energie
```math
\frac{1}{2} \, m \, v_x^2 = \frac{1}{2} \, k T  \quad .
``` 
Dadurch
fluktuiert die Potentialdifferenz zwischen zwei beliebigen Flächen des
Leiters. Man kann zeigen (Müller, Kap. 3), dass für das
Schwankungsquadrat der Spannung $U$ im Frequenzintervall $B$ gilt
```math
\left< u(t)^2 \right>|_B = 4 \, kT \, R \, B
``` 
wobei $R$ den
Widerstand des Leiter-Stücks bezeichnet. Der Mittelwert von $U$ ist
natürlich Null, aber die Größes des Rauschens hängt von der Temperatur
und dem Widerstand ab. Die spektrale Rausch-Leistungsdichte ist von der
Frequenz unabhängig (weiß) bis hin zu Frequenzen, die durch die mittlere
Zeit zwischen zwei Stößen der Elektronen gegeben sind ($\tau \approx 10$
fs bzw. $f \approx 100$ THz). Das Einzel-Ereignis 'Elektron tritt durch
Fläche' ist so kurz, dass seine Fourier-Transformierte sehr breit ist.
"""

# ╔═╡ c18a5b32-b466-4c8b-b5f4-5a65f1b2eca0
md"""
# Schrotrauschen 

Elektrischer Strom besteht aus einer Vielzahl einzelner Elektronen, ein
Lichtstrahl aus vielen einzelnen Photonen. Es gibt allerdings nur ganze
Elektronen und Photonen. Durch diese 'Körnigkeit' entsteht Rauschen im
elektrischen Strom bzw. in der Lichtleistung.

Im Zeitintervall $T$ passieren $n$ Elektronen der Ladung $e$ eine
Querschnittsfläche. Dies ergibt den Strom $I = n \, e / T$. Beim Zählen
von seltenen Ereignissen erwarten wir eine Poisson-Verteilung. Das
Schwankungsquadrat der Anzahl $n$ ist damit ebenfalls $n$. Für de Strom
gilt damit
```math
\left< i^2 \right>|_B = \left( \frac{\sqrt{n} \, e}{T} \right)^2 =  \frac{I \, e}{T}  = 2 I \, e \, B
```
wobei eine sampling Zeit von $T$ zu einer Nyqusit-Frequenz
$B = 1 / (2 T)$ führt. Diese Herleitung gilt für jedes
Frequenz-Intervall der Breite $B$, nicht nur für das hier benutzte
Intervall $[0, B]$.
"""

# ╔═╡ 2cd8ff94-3c1f-47ff-8255-9ebb9a27e686
md"""
Analog gilt für das Rauschen $p$ eines Lichtstrahls der Leistung $P$
bestehend aus Photonen der Energie $h \nu$
```math
\left< p^2 \right>|_B  =  2 P \, h\nu \, B
``` 
Auch Schrotrauschen ist
spektral flach bis zur Grenzfrequenz, die durch die zeitliche Form des
Einzel-Ereignisses bestimmt ist. Diese Grenze wird nur in wirklich sehr
besonderen Ausnahmen erreicht.

Schrotrauschen ist ein Poisson-artiger Prozess. Darum skaliert die
Rausch-Amplitude wie die Wurzel der Leistung bzw. des Stromes. Für große
Leistungen / Ströme wird der relative Anteil des Rauschens also
geringer.
"""

# ╔═╡ 92c2aff9-2683-4362-8179-cf60ed7bf879
md"""
# 1/f-Rauschen 

1/f-Rauschen (engl. auch 'flicker noise') ist ein Sammelbegriff für
verschiedene physikalische Rauschquellen, die alle zu einer
Frequenzabhängigkeit der Form $1/f$ führen. Dieses Rauschen ist so weit
verbreitet, dass der genaue physikalische Ursprung selten interessiert.
Es gibt Modelle für verschiedene Prozesse, die zu 1/f-Rauschen führen
(siehe zB. Müller). Kein Modell kann aber jede Quelle erklären.
"""

# ╔═╡ 2e9369d2-9cd8-47b5-91cc-dea782eda247
md"""
Bisher haben wir Elementarereignisse betrachtet, wie sehr kurz sind.
Dadurch ist die betrachtete Frequenz immer kleiner als die
Grenzfrequenz, die sich aus dem Einzelpuls ergibt. Dies führte zu weißem
(flachem) Rauschen. Wenn die Elementarereignisse viel langsamer als die
Beobachtungszeit sind, dann fällt die spektrale Leistungsdichte $W(f)$
wie $1/f^2$. In einem Übergangsbereich, wenn die Dauer der
Elementarereignisse in etwa der Beobachtungszeit entspricht, ergibt sich
$W(f) \propto 1/f$. Es gibt nun häufig Situationen, in denen die Dauer
der Elementarereignisse über ein sehr breites Zeitintervall verteilt
ist. Ein Beispiel ist das Ereignis 'Elektron wird aus Fallenzustand in
Halbleiter angeregt'. Damit erhält man also für quasi alle
Beobachtungszeiten die Situation, dass $W(f) \propto 1/f$ ist. Ähnliche
Argumente lassen sich für andere physikalische Prozesse finden.
"""

# ╔═╡ c1ce9b11-fa3f-4634-a45a-dcb910f432f3
md"""
1/f-Rauschen ist also immer vorhanden. Die Frage ist die nach seiner
Stärke relativ zu den auch immer vorhandenen anderen, spektral flachen
Prozessen. Unterhalb einer bestimmten Grenzfrequenz wird das
Rausch-Spektrum also durch $1/f$-Prozesse dominiert, oberhalb durch
Schrotrauschen und thermisches Rauschen.
"""

# ╔═╡ d5b9eee1-59b2-46b5-933d-507385f74024
md"""
# Leistungsabhängigkeit 

Wie skalieren die einzelnen Rausch-Prozesse mit dem Mittelwert der
beobachteten Größe? Welche Form hat also $f(x)$ in
```math
\sqrt{ \left< a^2 \right> |_B} = f\left( \left< A \right> \right) \quad .
```

Thermisches Rauschen hängt nicht vom Strom durch den Leiter ab. Wir
hatten es für einen Strom-freien Leiter 'hergeleitet'. In diesem Fall
ist also $f(x) =$const.
"""

# ╔═╡ 34ef0881-8df5-42df-a82c-e9715ac23009
md"""
Schrotrauschen ist ein Poisson-Prozess. Die Standard-Abweichung
entspricht der Wurzel aus dem Erwartungswert, also $f(x) = \sqrt{x}$.

Bei $1/f$-Rauschen können wir uns eine Quelle vorstellen, deren
Amplitude durch Abschwächen eines Ausgangswerts eingestellt wird. Damit
ändert sich aber die Amplitude der Quelle und die Amplitude des
Rauschens der Quelle im gleichen Maße, also $f(x) = x \cdot$ const. Es
ist eine Besonderheit von Schrot-artigen Prozessen, dass dies für diese
*nicht* gilt.

"""

# ╔═╡ d8faa994-c2b3-4475-a259-d478fcac0398
TableOfContents(title="Inhalt")

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.38"
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

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

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

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

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

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "1285416549ccfcdf0c50d4997a94331e88d68413"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.3.1"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "670e559e5c8e191ded66fa9ea89c97f10376bb4c"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.38"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

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

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

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

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

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
# ╟─f5450eab-0f9f-4b7f-9b80-992d3c553ba9
# ╟─d0a1d87c-10a3-41f7-947a-32f4262001a2
# ╟─262685e2-96f3-11ec-15c6-5f0a5e79b66b
# ╟─4a39a01c-0001-4297-8e3e-230ad8bdaccb
# ╟─a2ea1556-2426-49d3-ac21-732a0831742d
# ╟─485cb4fb-1346-44e5-9153-e2c1e5cc3209
# ╟─805130c8-8019-4ad0-b2b1-80a4743cb09b
# ╟─a3bbfe35-cddb-4f3c-a97e-b5e900b61f50
# ╟─8e66bbcc-7f58-44bd-bddc-450a2323edc3
# ╟─b3f90972-efe4-49c6-8688-839f75633d75
# ╟─ea766c9f-1bf3-46e7-ac37-cb4ab7550468
# ╟─c18a5b32-b466-4c8b-b5f4-5a65f1b2eca0
# ╟─2cd8ff94-3c1f-47ff-8255-9ebb9a27e686
# ╟─92c2aff9-2683-4362-8179-cf60ed7bf879
# ╟─2e9369d2-9cd8-47b5-91cc-dea782eda247
# ╟─c1ce9b11-fa3f-4634-a45a-dcb910f432f3
# ╟─d5b9eee1-59b2-46b5-933d-507385f74024
# ╟─34ef0881-8df5-42df-a82c-e9715ac23009
# ╠═e93ef54a-4a0b-4ed1-a476-e980224934bf
# ╠═d8faa994-c2b3-4475-a259-d478fcac0398
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
