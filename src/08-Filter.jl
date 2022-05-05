### A Pluto.jl notebook ###
# v0.19.0

using Markdown
using InteractiveUtils

# ╔═╡ abdfdbc2-5bb5-4a0e-8a1f-5cb733e16f42
using PlutoUI

# ╔═╡ f5450eab-0f9f-4b7f-9b80-992d3c553ba9
# DO NOT MODIFY, will be updated by update_navbar.jl
HTML("    <nav >\n    Vorbereitungen:\n\n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/index.html\"><em>Intro</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/software.html\"><em>Software</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/01-basic_syntax.html\"><em>Julia Basics</em></a> / \n\n<br>\nStatistik:\n\n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/02-beschreibende-statistik.html\"><em>Beschreibende Statistik</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/03-wahrscheinlichkeit.html\"><em>Wahrscheinlichkeit</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/04-schaetzung.html\"><em>Schätzung</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/05-messunsicherheit.html\"><em>Messunsicherheit</em></a> / \n\n<br>\nFourier-Transformation:\n\n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/06-Fourier-Transformation.html\"><em>Fourier-Transformation</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/07-Frequenzraum.html\"><em>Frequenzraum</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/08-Filter.html\"><em>Filter</em></a> / \n\n<br>\nMesstechnik:\n\n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/09-Rauschen.html\"><em>Rauschen</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/10-Detektoren.html\"><em>Detektoren</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/11-Lock-In.html\"><em>Lock-In-Verstärker</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/12-heterodyn.html\"><em>Heterodyn-Detektion</em></a> / \n\n<br>\n\n\n    </nav>\n\t")

# ╔═╡ 71b5a334-f720-4b16-85cf-b258c601b1de
html"""<div>
<font size="7"><b>8 Filter: lineare, zeit-invariante Systeme</b></font> </div>

<div><font size="5"> Markus Lippitz </font> </div>
<div><font size="5"> 2. Mai 2022 </font> </div>
"""

# ╔═╡ ff7880da-96f2-11ec-2d80-adc081faa710
md"""

**Ziel** Sie können eine Transferfunktion *vermessen*.

-   Frequenzantwort, Impulsantwort

-   analoge und digitale Filter

**Weitere Aufgaben**

-   Finden sie durch Filtern das Signal im Datensatz.

**Literatur** Butz Kap. 5, Horowitz / Hill, Kap. 1.19

  
"""

# ╔═╡ a4875723-76f9-4c43-a308-83ad2e1fd978
md"""
# Überblick
Wir betrachten allgemeine Eigenschaften eines linearen, Zeit-invarianten
Systems. Das System reagiert also *linear* auf das Eingangssignal
('doppelt so viel hilft doppelt so viel') und ist Zeit-invariant. Die
Antwort heute unterscheidet sich also nicht von der gestern. Diese
Anforderungen erfüllen viele Systeme, beispielsweise elektronische
Filter, getrieben Oszillatoren, dielektrische Materialien oder angeregte
Moleküle.

"""

# ╔═╡ 7b940ad9-ee37-41cb-b60b-80197712faf5
md"""
# Zeitliche Antwort

Auf einen Eingang $f(t)$ reagiert das System mit einer Antwort $y(t)$,
für die gilt
```math
y(t) = \int_{- \infty} ^{+ \infty} f(t') \, h(t - t') \, dt' \quad .
```
$y$ ist also die Faltung von $f$ mit $h$. Bei kausale Systemen darf die
Antwort jetzt nicht von einem Eingang in der Zukunft abhängen. $t'$ muss
also immer kleiner als $t$ sein. Dies erreicht man, in dem man fordert
```math
h ( t - t' < 0)  = 0 \quad .
``` 
Dabei wird $h$  die *Impulsantwort* genannt.
Wenn nämlich der Eingang eine Delta-Funktion ist $f(t) = \delta(t)$ dann
wird $y(t) = h(t)$. So lässt sich auch $h$ messen, indem man einen
möglichst delta-förmigen Impuls als Eingang verwendet und die Reaktion
darauf aufzeichnet.

"""

# ╔═╡ 44d9df84-a4bd-48ef-b470-4b0862f7c719
md"""
# Frequenz-Antwort  

Da $y(t)$ die Faltung von $f(t)$ mit $h(t)$ ist, gilt für die
Fourier-transformierte Frequenzantwort
```math
Y(\omega) = F(\omega) \, H(\omega)
``` 
wobei kleine Buchstaben durch FT
in große Buchstaben übergehen. $H(\omega)$ nennt sich
*Transferfunktion*. Man kann diese Funktion messen, in dem man
beispielsweise die Antwort auf Eingänge mit verschiedenen Frequenzen
misst. Alternativ kann man ein im Frequenzraum flaches, breites (=
'weißes') Spektrum anlegen und das Frequenz-Spektrum des Ausgangs
messen.

"""

# ╔═╡ 8787ecd7-ed54-469c-a748-19605c2dd665
md"""
# Kramers-Kronig-Beziehung 

Auch wenn $h(t)$ reelwertig ist, so wird $H(\omega)$ doch komplexwertig
sein, da $h(t)$ nicht gerade (cosinus-förmig) ist. Aus der Kausalität,
also $h ( t - t' < 0)  = 0$ folgt allerdings ein Zusammenhang zwischen
Real- und Imaginär-Teil von $H(\omega)$, die Kramers-Kronig-Beziehung.
Da dielektrische Materialien linear und Zeit-invariant sind, gibt es so
einen Zusammenhang zwischen Real- und Imaginär-Teil der dielektrischen
Funktion bzw. des Brechungsindexes
```math
\epsilon'(\omega) = 1 + \frac{2}{\pi} \, \mathcal{P}\int_0^{\infty} \frac{\Omega \, \epsilon''(\Omega) }{\Omega^2 - \omega^2}
```
und analog auch in die andere Richtung. $\mathcal{P}$ bezeichnet dabei
das Cauchy'sche Hauptwert-Integral, bei dem der Pol bei
$\Omega = \omega$ ausgenommen wird.

Analog kann man aus bekannten Amplitudenverlauf eines getriebenen
Oszillator seinen Phasenverlauf bestimmen und ungekehrt.

"""

# ╔═╡ 64410607-6541-4aae-95b1-e4d3fde884ce
md"""
## Kaskadierte Systeme 

Wenn mehrere lineare, Zeit-invariante Systeme hintereinander geschaltet
sind, also der Ausgang des einen als Eingang des anderen dient, dann ist
die Transferfunktion des Gesamtsystems das Produkt aller
Transferfunktionen (und daher von der Reihenfolge der Systeme
unabhängig). Die Gesamt-Impulsantwort ist also die Faltung aller
Einzel-Impulsantworten.

"""

# ╔═╡ 063afec8-4ec1-4ec7-87f0-890a86662875
md"""
# Entfaltung 

Limitierte Transferfunktionen bzw. nicht delta-förmige Impulsantworten
sind unpraktisch, aber allgegenwärtig. Gerne würde man sie nachträglich
rechnerisch aus der Messung beseitigen, um diese zu korrigieren. Das ist
aber nur sehr begrenzt möglich. Man könnte die im Zeitraum gemessenen
Größen Fourier-Transformieren und dann rechnen
```math
F_{exp}(\omega) = \frac{Y_{exp}(\omega)}{H(\omega)} \quad .
``` 
Das
Problem ist, dass bei limitiertem $H(\omega)$ dieses quasi Null ist für
manche Frequenzen. An diesen Frequenzen ist dann auch das gemessene
$Y(\omega)$ quasi Null und der wahre von Null verschiedene Wert von
$F(\omega)$ lässt sich nicht rekonstruieren. Wenn die Information einmal
weg ist, kann man sie nicht wieder beschaffen. In Bereichen, in denen
$H$ zwar klein, aber nicht Null ist, kann dieses Verfahren helfen,
solange der gemessene Wert von $Y$ gut genug, also rauscharm genug
bekannt ist.

Was man an dieser Stelle typischerweise macht, ist nicht die Daten um
die Messprozedur zu entfalten, sondern das Modell mit der Apparatur zu
falten, und dann gemessene $Y$ mit modellierten $Y$ zu vergleichen.

"""

# ╔═╡ f432282b-c46f-48c1-9f7b-d5cb35c31dbc
md"""
# RC-Tiefpass-Filter 

Wir betrachten auf verschiedene Weisen einen unbelasteten
RC-Tiefpass-Filter. Es wird also nur eine Spannung $U_{out}$ gemessen
und kein Strom $I_{out}$ fließt.

"""

# ╔═╡ 3eac92be-4058-4534-ae17-97833937e58a
md"""
# Komplexe Widerstände  

Der RC-Filter bildet einen Spannungsteiler aus zwei komplexen
Widerständen $Z_1= R$ und $Z_2 = 1 /( i \omega C)$. Damit ergibt sie die
Transferfunktion $H$ zu
```math
H = \frac{U_{out}}{U_{in}} = \frac{Z_2}{Z_1 + Z_2} = \frac{\frac{1}{i \omega C}}{R + \frac{1}{i \omega C}}
= \frac{\frac{1}{i \omega R  C}}{1 + \frac{1}{i \omega R C}}
```
"""

# ╔═╡ 5b287990-d893-416a-92d9-b44372f1651f
md"""
# Zeitliche Integration  

Alternativ kann man die Spannung $U_{out}$ auch aus der Ladung $Q$ des
Kondensators berechnen
```math
U_{out}(t) = \frac{Q(t)}{C} = \frac{1}{C} \int_{\tau < t} I(\tau) d\tau  =  \frac{1}{RC} \int_{\tau < t} U_{in}(\tau) - U_{out}(\tau) d\tau`
```
Für kleine $\Delta t$ mit quasi konstanten $U$ ergibt sich so
```math
U_{out}(t + \Delta t) =  U_{out}(t) + \frac{\Delta t}{R C } \left(U_{in}(t) - U_{out}(t) \right)
```
Nun seinen $x(n)$ und $y(n)$ die Zeitreihe der Spannungen, also
```math
x(n) = U_{in}(n \Delta t) \quad \text{und} \quad y(n) = U_{out}(n \Delta t)
```
also
```math
y(n+1) =  y(n) + \frac{\Delta t}{R C } \left( x(n) - y(n) \right)
```
oder umgeformt , inkl. Verschieben des Indexes um 1
```math
y(n) +  y(n-1)  \left(1 + \frac{\Delta t}{R C } \right) = 
 \frac{\Delta t}{R C }  x(n-1)
``` 
Mit dem Verschiebe-Operator $V^l$ aus
Butz Gleichung 5.19 lässt sich das schreiben als
```math
\left( 1 + V^{-1} \left(1 + \frac{\Delta t}{R C } \right) \right)  y(n)= 
 \frac{\Delta t}{R C }  V^{-1} x(n)
``` 
Die einzigen von Null
verschiedenen Filter-Koeffizienten sind also 
```math 
\begin{aligned}
a(-1)  &= & \frac{\Delta t}{R C }    \\
b(0) & =& 1 \\
b(-1) & = & 1 - \frac{\Delta t}{R C}   
\end{aligned}
```
"""

# ╔═╡ feda6789-451a-4c43-9c45-213a34bff474
md"""
Die $A(\omega)$ und $B(\omega)$ sind die entsprechenden
Fourier-Transformierten dieser Zeitreihen (Gl. 5.21 in Butz), also
```math
\begin{aligned}
A(\omega) & = & \sum a(n) \exp(n \,  i \omega \Delta t) = \frac{\Delta t}{R C }   \exp(- i \omega \Delta t) \\
B(\omega) & = & \sum b(n) \exp(n \,  i \omega \Delta t) = 1 + \left(1 - \frac{\Delta t}{R C } \right)   \exp(- i \omega \Delta t) 
\end{aligned}
```
"""

# ╔═╡ e8084197-163f-4221-90d8-a2ae614d2e73
md"""
Mit der Näherung
$\exp(- i \omega \Delta t)  = 1 / (1 +  i \omega \Delta t)$ ergibt sich
für die Transferfunktion $H(\omega)$
```math
H(\omega) = \frac{A(\omega)}{B(\omega)} = \frac{ \frac{\Delta t}{R C }  \cdot \frac{1}{1 +  i \omega \Delta t}}
{1 + \left(1 - \frac{\Delta t}{R C } \right)  \cdot \frac{1}{1 +  i \omega \Delta t}} 
\approx  \frac{\frac{1}{i \omega R  C}}{1 + \frac{1}{i \omega R C}}
```
Die letzte Näherung erfordert, dass $\Delta t / RC \ll 1$, also sehr
kleines $\Delta t$. Das Ergebnis stimmt also mit dem über die komplexen
Widerstände überein.
"""

# ╔═╡ a8cf52a2-1f52-4a20-9917-841253af3dbb
md"""
# Implementation in GNU octave / matlab 

Gleichung 5.19 aus Butz ist in GNU octave / Matlab in der function
`filter` implementiert. Als Argument verlangt sie, in dieser
Reihenfolge, die Koeffizienten $b(n)$ und $a(n)$ sowie die zu filternde
Zeitspur. Die Koeffizienten sind gespiegelt (rückwärts) von Null an hin
zu negativen Indizes. Mit $k = \Delta t / (R C)$ also

     out = filter( [1, 1-k], [0, k], in ) 

"""

# ╔═╡ d7132d3c-0b4f-4eee-93e3-53cff88d8864
aside(x) = PlutoUI.ExperimentalLayout.aside(x);

# ╔═╡ 048f044d-6ef0-44ba-bb8d-a6a5f4eb2674
aside([Resource("https://raw.githubusercontent.com/MarkusLippitz/teca/main/res/08-Filter/RC.png", (:width => 500)) md"*Schaltbild eines RC Filters*"])

# ╔═╡ 19032436-b4e1-4c7b-9d05-2c4e94725973
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
# ╟─71b5a334-f720-4b16-85cf-b258c601b1de
# ╟─ff7880da-96f2-11ec-2d80-adc081faa710
# ╟─a4875723-76f9-4c43-a308-83ad2e1fd978
# ╟─7b940ad9-ee37-41cb-b60b-80197712faf5
# ╟─44d9df84-a4bd-48ef-b470-4b0862f7c719
# ╟─8787ecd7-ed54-469c-a748-19605c2dd665
# ╟─64410607-6541-4aae-95b1-e4d3fde884ce
# ╟─063afec8-4ec1-4ec7-87f0-890a86662875
# ╟─f432282b-c46f-48c1-9f7b-d5cb35c31dbc
# ╟─048f044d-6ef0-44ba-bb8d-a6a5f4eb2674
# ╟─3eac92be-4058-4534-ae17-97833937e58a
# ╟─5b287990-d893-416a-92d9-b44372f1651f
# ╟─feda6789-451a-4c43-9c45-213a34bff474
# ╟─e8084197-163f-4221-90d8-a2ae614d2e73
# ╟─a8cf52a2-1f52-4a20-9917-841253af3dbb
# ╠═abdfdbc2-5bb5-4a0e-8a1f-5cb733e16f42
# ╠═d7132d3c-0b4f-4eee-93e3-53cff88d8864
# ╠═19032436-b4e1-4c7b-9d05-2c4e94725973
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
