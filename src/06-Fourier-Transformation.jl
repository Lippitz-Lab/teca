### A Pluto.jl notebook ###
# v0.19.26

using Markdown
using InteractiveUtils

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

# ╔═╡ 265087fe-4cda-4f6b-aa7a-e1668d6601e2
using PlutoUI

# ╔═╡ a8d8f494-cdbd-4276-b9ea-ab04a00b0f3e
TableOfContents(title="Inhalt")

# ╔═╡ Cell order:
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
