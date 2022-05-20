### A Pluto.jl notebook ###
# v0.19.4

using Markdown
using InteractiveUtils

# ╔═╡ 265087fe-4cda-4f6b-aa7a-e1668d6601e2
using PlutoUI

# ╔═╡ f5450eab-0f9f-4b7f-9b80-992d3c553ba9
# DO NOT MODIFY, will be updated by update_navbar.jl
HTML("    <nav >\n    Vorbereitungen:\n\n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/index.html\"><em>Intro</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/software.html\"><em>Software</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/01-basic_syntax.html\"><em>Julia Basics</em></a> / \n\n<br>\nStatistik:\n\n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/02-beschreibende-statistik.html\"><em>Beschreibende Statistik</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/03-wahrscheinlichkeit.html\"><em>Wahrscheinlichkeit</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/04-schaetzung.html\"><em>Schätzung</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/05-messunsicherheit.html\"><em>Messunsicherheit</em></a> / \n\n<br>\nFourier-Transformation:\n\n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/06-Fourier-Transformation.html\"><em>Fourier-Transformation</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/07-Frequenzraum.html\"><em>Frequenzraum</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/08-Filter.html\"><em>Filter</em></a> / \n\n<br>\nMesstechnik:\n\n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/09-Rauschen.html\"><em>Rauschen</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/10-Detektoren.html\"><em>Detektoren</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/11-Lock-In.html\"><em>Lock-In-Verstärker</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/12-heterodyn.html\"><em>Heterodyn-Detektion</em></a> / \n\n<br>\n\n\n    </nav>\n\t")

# ╔═╡ 2409b1d9-065e-4a62-9172-aba9bf8a8836
html"""<div>
<font size="7"><b>6 Fourier-Transformation</b></font> </div>

<div><font size="5"> Markus Lippitz </font> </div>
<div><font size="5"> 13. Mai 2022 </font> </div>
"""

# ╔═╡ bc0bc1f4-96f2-11ec-26ff-c53449a3e782
md"""

**Ziele** Sie können für typische ein-dimensionale Funktionen
die Fourier-Transformierte intuitiv *vorhersagen*.

-   von der Fourier-Reihe zur Fourier-Transformation

-   FT typischer Funktionen

-   Produkt und Faltung von Funktionen

**weitere Aufgaben**

-   Synthetisieren sie eine Dreieck- / Rechteck-Funktion ‚von Hand'

**Literatur** Butz Kap. 1 & 2, Saleh/Teich Anhang A, Hecht
Kap.11, Horowitz / Hill, Kap. 15.18

"""

# ╔═╡ 87cc27e7-f022-459c-b18b-822db429a9ac
md"""

# Überblick

An vielen Stellen in der Physik ist es sinnvoll und hilfreich, einen intuitiven Zugang zur Fourier-Transformation zu haben.
Im Endeffekt muss man in der Experimentalphysik nur selten eine
Fourier-Transformation wirklich ausrechnen. Sehr oft reicht es, ein paar
oft vorkommende Fourier-Paare zu kennen und diese mit einfachen Regeln
zu kombinieren. Dies möchte ich hier kurz vorstellen. Eine sehr schöne
und viel detailliertere Darstellung findet sich in **Butz: Fourier-Transformation für Fußgänger**. Ich
folge hier seiner Notation.

Bevor wir zu den Fourier-Paaren kommen, müssen allerdings doch erst ein
paar Grundlagen gelegt werden.

"""

# ╔═╡ abaed463-1734-4801-9046-87d8b6fcf41a
md"""
# Fourier-Reihen: eine periodische Funktion und deren Fourier-Koeffizienten

Wir betrachten hier alles erst einmal eindimensional im Zeit- bzw.
Frequenzraum mit den Variablen $t$ und $\omega = 2 \pi \nu$. Die
Funktion $f(t)$ sei periodisch in der Zeit mit der Periodendauer $T$,
also $f(t) = f (t + T)$ Dann kann man diese als Fourier-Reihe
schreiben
```math
f(t) = \sum_{k=-\infty}^{\infty} \, C_k \, e^{i \, \omega_k \, t}
```
mit $\omega_k = \frac{2 \pi \, k}{T}$ und den
Fourier-Koeffizienten
```math
C_k = \frac{1}{T} \, \int_{-T/2}^{T/2} \, f(t) \, \, e^{-i \, \omega_k \, t} \, dt
```
Man beachte das negative Vorzeichen in der Exponentialfunktion im
Gegensatz zur Gleichung davor. Für reellwertige Funktionen $f(t)$ sind
'gegenüberliegende' $C_k$ konjugiert-komplex, also $C_k = C_{-k}^\star$.
Für $k<0$ sind die Frequenzen $\omega_k$ negativ, was aber kein Problem
darstellt. Der nullte Koeffizient $C_0$ ist also gerade der zeitliche
Mittelwert der Funktion $f(t)$.
"""

# ╔═╡ 31bb538c-f011-4c7c-904b-e4aaafa47fc1
md"""
# Eine beliebige Funktion und deren Fourier-Transformierte

Nun heben wir die Einschränkung auf periodische Funktionen $f(t)$ auf,
indem wir die Periodendauer $T$ gegen unendlich gehen lassen. Dadurch
wird aus der Summe ein Integral und die diskreten $\omega_k$ werden
kontinuierlich. Damit wird 
```math
\begin{aligned}
 F(\omega) = & \int_{-\infty}^{+\infty} \, f(t) \, e^{- i \omega\, t} \, dt \\
 f(t) = & \frac{1}{2 \pi } \int_{-\infty}^{+\infty} \, F(\omega) \, e^{+ i \omega\, t} \, d\omega \end{aligned}
```
Die erste Gleichung ist dabei die Hintransformation (minus-Zeichen im
Exponenten), die zweite die Rücktransformation (plus-Zeichen im
Exponenten). Die Symmetrie wird durch das $2 \pi$ gebrochen. Dies ist
aber notwendig, wenn man weiterhin $F(\omega = 0)$ als Mittelwert
behalten will. Alternativ könnte man das alles mit $\nu$ statt $\omega$
formulieren, hätte dann aber an viel mehr Stellen ein $2 \pi$, wenn auch
nicht vor dem Integral.
"""

# ╔═╡ e66de2f3-14e5-4fdc-8aab-8fe16e621393
md"""
## Nebenbemerkung: Delta-Funktion

Die Delta-Funktion kann geschrieben werden als
```math
\delta(x) = \lim_{a \rightarrow 0} f_a(x) \quad
   \text{mit} \quad
    f_a(x) = \left\{ \begin{matrix}
    a  & \text{falls } |x| < \frac{1}{2a} \\
    0 & \text{sonst}
    \end{matrix}
    \right.
```
oder als
```math
\delta(x)  = \frac{1}{2 \pi}  \int_{-\infty}^{+\infty} \, e^{+ i\, x \, y} \, dy
```
Eine wichtige Eigenschaft ist, dass die delta-Funktion einen Wert
selektiert, also
```math
\int_{-\infty}^{+\infty} \, \delta(x) \, f(x) \, dx = f(0)
```
"""

# ╔═╡ 1a6ceadb-ac9c-4ae5-bb27-de1e402d6769
md"""
# Wichtige Fourier-Paare

Es ist sehr oft ausreichend, die folgenden Paare von Funktionen und
deren Fourier-Transformierten zu kennen. Ich schreibe sie hier, Butz
folgend, als Paare in $t$ und $\omega$ (nicht $\nu = \omega / (2 \pi)$).
Genauso hätte man auch Paare in $x$ und $k$ schreiben können. Wichtig
ist dabei die Frage, ob ein $2 \pi$ in der Exponentialfunktion der
ebenen Welle auftaucht oder nicht. Also
```math
e^{i \omega t} \quad \text{und} \quad e^{i k x} \quad \text{, aber} \quad 
e^{i 2 \pi \nu t}
```

Weiterhin folge ich hier der oben gemachten Konvention zu asymmetrischen
Verteilung der $2 \pi$ zwischen Hin- und Rück-Transformation. Wenn man
die anders verteilt, dann ändern sich natürlich auch die Vorfaktoren.
Eine gute Übersicht über noch viel mehr Fourier-Paare in diversen
'$2 \pi$'-Konventionen findet sich in der englischen Wikipedia unter
'Fourier transform'. In deren Nomenklatur ist die hier benutzte
Konvention von Butz 'non-unitary, angular frequency'.
"""

# ╔═╡ c960650a-75e1-4408-a1a7-b820d6a5eae2
md"""
### Konstante und Delta-Funktion

Aus $f(t) = a$ wird $F(\omega) = a \, 2 \pi \, \delta(\omega)$ und aus
$f(t) = a \, \delta(t)$ wird $F(\omega) = a$. Das ist wieder das
asymmetrische $2 \pi$.
"""

# ╔═╡ 19db36cf-1341-4604-bfb4-2ecf0a72aaaf
md"""
### Rechteck und sinc

Aus der Rechteckfunktion der Breite $b$ wird ein sinc, der sinus
cardinalis. Also aus
```math
f(t) = \text{rect} _b (t) = \left\{ \begin{array}{ll}
 1 & \text{für} \quad |t| < b/2 \\
 0 & \text{sonst} \\
 \end{array}
 \right.
```
wird
```math
F(\omega) = b \,  \frac{\sin \omega b / 2}{\omega b /2} = b \, \text{sinc}( \omega b /2)
```
"""

# ╔═╡ 1d79a02e-2c16-4f99-9d79-202f9da55981
md"""
### Gauss

Die Gauss-Funktion bleibt unter Fourier-Transformation erhalten. Ihre
Breite geht in den reziproken Wert über. Also aus einer Gauss-Funktion
der Fläche Eins
```math
f(t) = \frac{1}{\sigma \sqrt{2 \pi}} \, e^{- \frac{1}{2} \left( \frac{t}{\sigma} \right)^2}
```
wird
```math
F(\omega) =  e^{- \frac{1}{2} \left( \sigma \, \omega \right) ^2  }
```
"""

# ╔═╡ f644d02e-e54d-4605-9aef-46910f2417ed
md"""
### (beidseitiger) Exponentialzerfall und Lorentz-Kurve

Aus einer sowohl zu positiven als auch zu negativen Zeiten exponentiell
abfallenden Kurve 
```math
f(t) = e^{- |t| / \tau}
```
wird die Lorentz-Kurve
```math
F(\omega) = \frac{2 \tau}{1 + \omega^2 \, \tau^2}
```
"""

# ╔═╡ 44c61b12-47c9-4490-8173-ddf38bab9518
md"""
### Einseitiger Exponentialzerfall

Als Nebenbemerkung hier der einseitige Exponentialzerfall, also
```math
f(t) = \left\{ \begin{array}{ll}
e^{- \lambda t } & \text{für} \quad t > 0 \\
 0 & \text{sonst} \\
 \end{array}
 \right.
```
Der wird zu 
```math
F(\omega) = \frac{1}{\lambda + i \, \omega}
```
ist also komplexwertig. Sein Betrags-Quadrat ist wieder eine
Lorentz-Funktion 
```math
| F(\omega)|^2 = \frac{1}{\lambda^2 +  \omega^2}
```
und die Phase ist $\phi = - \omega / \lambda$.
"""

# ╔═╡ 4876e93c-6221-4c17-8857-248e4809a987
md"""
### Eindimensionales Punktgitter

Eine äquidistante Kette von Punkten bzw. Delta-Funktionen geht bei
Fourier-Transformation wieder in eine solche über. Die Abstände nehmen
dabei den reziproken Wert an. Also aus
```math
f(t) = \sum_{n=-\infty}^{\infty} \, \delta (t - \Delta t \, n)
```
wird
```math
F(\omega) = \frac{2 \pi}{\Delta t} \, \sum_{n=-\infty}^{\infty} \, \delta \left(\omega - n\frac{2 \pi}{\Delta t} \right)
```
"""

# ╔═╡ 3bfa39ab-04c6-4bb7-8e35-41d77141b27c
md"""
# Sätze und Eigenschaften der Fourier-Transformation

Neben den Fourier-Paaren braucht man noch ein paar Eigenschaften der
Fourier-Transformation. Im Folgende seien $f(t)$ und $F(\omega)$
Fourier-konjugierte und ebenso $g$ und $G$.
"""

# ╔═╡ 74801d0d-6681-4cf3-97d1-5bd308a7ce92
md"""
### Linearität

Die Fourier-Transformation ist linear
```math
a \, f(t) + b \, g(t) \quad \leftrightarrow \quad 
a \, F(\omega) + b \, G(\omega)
```
"""

# ╔═╡ 7ecdf15c-5472-440a-bdaa-54cf0de991a3
md"""
### Verschiebung

Eine Verschiebung in der Zeit bedeutet eine Modulation in der Frequenz
und andersherum 
```math
\begin{aligned}
 f(t - a) & \quad \leftrightarrow \quad 
F(\omega) \, e^{-i \omega a} \\
 f(t) \, \, e^{-i \omega_0 t} &  \quad \leftrightarrow \quad 
F(\omega + \omega_0)  \end{aligned}
```
"""

# ╔═╡ 5c005863-f786-4ff7-a5b9-950da369436c
md"""
### Skalierung
```math
f( a \, t)  \quad \leftrightarrow \quad 
\frac{1}{|a|} \, F \left( \frac{\omega}{a} \right)
```
"""

# ╔═╡ 69352450-7c96-47bd-88f4-a905e119c1f3
md"""
### Faltung und Multiplikation

Die Faltung geht in ein Produkt über, und andersherum.
```math
f(t) \otimes g(t) = \int f(\zeta) g(t- \zeta) d\zeta 
 \quad \leftrightarrow \quad 
 F(\omega) \, G(\omega)
```
und 
```math
f(t) \,  g(t) 
 \quad \leftrightarrow \quad 
\frac{1}{2 \pi} \,  F(\omega) \otimes G(\omega)
```
"""

# ╔═╡ 2043b1ca-f6eb-43e0-96c7-b35bd81d14fc
md"""
### Parsevals Theorem

Die Gesamt-Leistung ist im Zeit- wie im Frequenzraum die gleiche
```math
\int |f(t) |^2 \, dt = \frac{1}{2 \pi} \, \int | F (\omega ) | ^2 \, d\omega
```
"""

# ╔═╡ 59f1f035-a9be-44d4-bd0f-d3f2b20af2a4
md"""
### Zeitliche Ableitungen
```math
\frac{d \, f(t)}{dt} 
 \quad \leftrightarrow \quad 
i \omega \,  F(\omega)
```
"""

# ╔═╡ 94891df8-79af-4849-8245-8cc06d3e76b8
md"""
# Beispiel: Beugung am Doppelspalt

Als Beispiel betrachten wir die Fourier-Transformierte eines
Doppelspalts, die gerade sein Beugungsbild beschreibt. Die Spalten haben
eine Breite $b$ und einem Mitten-Abstand $d$. Damit wird der Spalt
beschrieben durch eine Faltung der Rechteck-Funktion mit zwei
Delta-Funktionen im Abstand $d$
```math
f(x) = \text{rect} _b (x) \, \otimes \, \left( \delta (x - d/2) + \delta (x + d/2) \right)
```
Die Fourier-Transformierte der Rechteck-Funktion ist der $\text{sinc}$,
die der delta-Funktionen eine Konstante. Die Verschiebung im Ort bewirkt
allerdings eine Modulation im $k$-Raum. Aus der Summe der beiden
Delta-Funktionen wird also
```math
\mathcal{FT}\left\{ \delta (x - d/2) + \delta (x + d/2)  \right\} =
e^{-i k d/2} + e^{+i k d/2}  = 2 \cos ( k d/2)
```
Die Faltung mit der
Rechteck-Funktion geht über in eine Multiplikation mit dem
$\text{sinc}$. Zusammen erhalten wir somit
```math
\mathcal{FT}\left\{ f(x)  \right\} = b \frac{\sin (k b/2) }{kb/2} \, 2 \cos ( k d/2) = \frac{4}{k} \, \sin (k b/2) \,  \cos ( k d/2)
```
Die Intensität in Richtung $k$ ist dann das Betragsquadrat davon.
"""

# ╔═╡ 9efa0309-66a1-42a4-b426-7f37df6b6343
md"""
# Selbstkontrolle

## Zeitliche Verschiebung

- Skizzieren Sie Amplitude und Phase der FT eines zeitlichen Rechteckpulses, der um die zeitliche Null zentriert ist!

- Was ändert sich, wenn man den Puls zu positiven Zeiten verschiebt?
"""

# ╔═╡ ddf7074e-55a4-415a-be10-42e621e90d72
md"""
## Pulsfolge

Sie fragen sich, wie die Fourier-Transformierte (Betragsquadrat) einer unendlichen Folge von Rechteck-Pulsen aussieht und fangen an, danach im Internet zu suchen.
Ihre Kommilitonin entgegnet, das „sehe“ man doch sofort.
- Skizzieren Sie sich die Fourier-Transformierte.
- Erklären Sie wieso man das direkt herleiten könnte oder „sehen“ solle.
"""

# ╔═╡ de69cf55-8674-465b-8d12-498335e28673
md"""
## Lichtpuls

Stellen Sie sich einen „Lichtpuls“ vor als mathematische Konstruktion aus einer unendlich langen Cosinus-Schwingung, die der Lichtfrequenz entspricht. Den „Puls“ erhält man daraus, indem man die Welle mit einer zeitlich begrenzten Gausspuls-Einhüllenden (z.B. Halbwertsbreite von 10 Lichtschwingungen) multipliziert. 
- Skizzieren Sie die Konstruktion der Fouriertransformation im Spektralbereich
"""

# ╔═╡ d2425be8-db4f-4f84-b991-6bac1937e78e
md"""
# Zweidimensionale Fourier-Transformation

Wir können die Definition der Fourier-Transformation auf zwei und mehr
Dimensionen erweitern. Die konjugierten Variablen sind $(x,y)$ und
$(k_x, k_y)$, anstelle von $t$ und $\omega$. Der Wellenvektor
$k_i = 2\pi / \lambda_i$ enthält den Faktor von $2\pi$ wie in der
Kreisfrequenz $\omega$. Wir definieren 
```math
\begin{aligned}
  F(k_x, k_y) = & \iint_{-\infty}^{+\infty} \, f(x,y) \, e^{- i (k_x \, x + k_y \, y )} \, dx \, dy \\
  f(x,y) = & \frac{1}{(2 \pi )^2} \iint_{-\infty}^{+\infty} \, F(k_x, k_y) \,\, e^{+ i (k_x \, x + k_y \, y )}  \, dk_x \,dk_y \quad .
 \end{aligned}
```

Wenn wir die Funktion $f(x,y)$ in ein Produkt von eindimensionalen
Funktionen zerlegen können, dann ist die Fourier-Transformation einfach
das Produkt der einzelnen Fourier-Transformationen
```math
f(x,y) = g(x) \cdot h(y) \quad \leftrightarrow \quad 
  F(k_x, k_y) = G(k_x) \cdot H(k_y) \quad .
```

Ein Rechteck der Größe $a \times b$ wird in ein Produkt von
Sinc-Funktionen umgewandelt 
```math
\begin{aligned}
  (x,y) = & \text{rect} _a (x) \cdot \text{rect} _b (y) \\
  \leftrightarrow \quad  F(k_x, k_y) = & a b \, \text{sinc}( k_x a /2) \, \text{sinc}( k_y b /2) \quad .\end{aligned}
```

Ein Spezialfall davon ist die rotationssymmetrische zweidimensionale
Gaußsche Funktion 
```math
f(x,y) = 
  \frac{1}{2 \pi \sigma^2} \, e^{-  \frac{x^2 + y^2}{2 \sigma^2} }
  \quad \leftrightarrow \quad 
  F(k_x, k_y) = e^{- \frac{\sigma^2 }{2} \left(k_x^2 + k_y^2 \right)  } \quad .
```

Eine wichtige Funktion kann nicht in ein Produkt eindimensionaler
Funktionen zerlegt werden: eine Scheibe mit dem Radius $a$
```math
f(x,y)  = \left\{ 
    \begin{array}{ll}
    1 & \text{für} \quad x^2+y^2 < a \\
    0 & \text{sonst} \\
    \end{array}
    \right.
```
wird transformiert in
```math
F(k_x, k_y) = a \, \frac{J_1(\pi \, a \, \rho )}{\rho}
  \quad \text{width} \quad \rho = \sqrt{k_x^2 + k_y^2}
```
und der
(zylindrischen) Besselfunktion erster Art $J_1(x)$
```math
J_1(x) = \frac{1}{\pi} \int_0^\pi \cos (\tau - x \sin \tau) \,d\tau \quad ,
```
die das zylindrische Analogon einer Sinc-Funktion ist.

"""

# ╔═╡ a8d8f494-cdbd-4276-b9ea-ab04a00b0f3e
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
# ╟─2409b1d9-065e-4a62-9172-aba9bf8a8836
# ╟─bc0bc1f4-96f2-11ec-26ff-c53449a3e782
# ╟─87cc27e7-f022-459c-b18b-822db429a9ac
# ╟─abaed463-1734-4801-9046-87d8b6fcf41a
# ╟─31bb538c-f011-4c7c-904b-e4aaafa47fc1
# ╟─e66de2f3-14e5-4fdc-8aab-8fe16e621393
# ╟─1a6ceadb-ac9c-4ae5-bb27-de1e402d6769
# ╟─c960650a-75e1-4408-a1a7-b820d6a5eae2
# ╟─19db36cf-1341-4604-bfb4-2ecf0a72aaaf
# ╟─1d79a02e-2c16-4f99-9d79-202f9da55981
# ╟─f644d02e-e54d-4605-9aef-46910f2417ed
# ╟─44c61b12-47c9-4490-8173-ddf38bab9518
# ╟─4876e93c-6221-4c17-8857-248e4809a987
# ╟─3bfa39ab-04c6-4bb7-8e35-41d77141b27c
# ╟─74801d0d-6681-4cf3-97d1-5bd308a7ce92
# ╟─7ecdf15c-5472-440a-bdaa-54cf0de991a3
# ╟─5c005863-f786-4ff7-a5b9-950da369436c
# ╟─69352450-7c96-47bd-88f4-a905e119c1f3
# ╟─2043b1ca-f6eb-43e0-96c7-b35bd81d14fc
# ╟─59f1f035-a9be-44d4-bd0f-d3f2b20af2a4
# ╟─94891df8-79af-4849-8245-8cc06d3e76b8
# ╟─9efa0309-66a1-42a4-b426-7f37df6b6343
# ╟─ddf7074e-55a4-415a-be10-42e621e90d72
# ╟─de69cf55-8674-465b-8d12-498335e28673
# ╟─d2425be8-db4f-4f84-b991-6bac1937e78e
# ╠═265087fe-4cda-4f6b-aa7a-e1668d6601e2
# ╠═a8d8f494-cdbd-4276-b9ea-ab04a00b0f3e
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
