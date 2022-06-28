### A Pluto.jl notebook ###
# v0.19.4

using Markdown
using InteractiveUtils

# ╔═╡ 238209b9-b380-459f-86c7-5b73ff69e7e7
using PlutoUI

# ╔═╡ f5450eab-0f9f-4b7f-9b80-992d3c553ba9
# DO NOT MODIFY, will be updated by update_navbar.jl
HTML("    <nav >\n    Vorbereitungen:\n\n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/index.html\"><em>Intro</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/software.html\"><em>Software</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/01-basic_syntax.html\"><em>Julia Basics</em></a> / \n\n<br>\nStatistik:\n\n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/02-beschreibende-statistik.html\"><em>Beschreibende Statistik</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/03-wahrscheinlichkeit.html\"><em>Wahrscheinlichkeit</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/04-schaetzung.html\"><em>Schätzung</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/05-messunsicherheit.html\"><em>Messunsicherheit</em></a> / \n\n<br>\nFourier-Transformation:\n\n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/06-Fourier-Transformation.html\"><em>Fourier-Transformation</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/07-Frequenzraum.html\"><em>Frequenzraum</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/08-Filter.html\"><em>Filter</em></a> / \n\n<br>\nMesstechnik:\n\n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/09-Rauschen.html\"><em>Rauschen</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/10-Detektoren.html\"><em>Detektoren</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/11-Lock-In.html\"><em>Lock-In-Verstärker</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/12-heterodyn.html\"><em>Heterodyn-Detektion</em></a> / \n\n<br>\n\n\n    </nav>\n\t")

# ╔═╡ 46112d95-89d9-427d-b825-3807d4f15d27
html"""<div>
<font size="7"><b>12 Homodyn- und Heterodyn-Detektion</b></font> </div>

<div><font size="5"> Markus Lippitz</font> </div>
<div><font size="5"> 27. Juni 2022 </font> </div>
"""

# ╔═╡ 705a5b52-96f3-11ec-11e9-45e1cd363a35
md"""
**Ziele:** Sie können *erklären*, wann und wie ein Interferometer hilft, rauscharm
zu messen
- homodyne und heterodyne Detektion in der Nachrichtentechnik
-  homodyne und heterodyne Detektion in der Optik 
- Schrotrauschen in Interferometern

**Literatur:** Horowitz/Hill Kap. 13.14–20
"""

# ╔═╡ 2f71a18f-fad3-4ecf-8c8e-eefbbdb008bd
md"""
# Nachrichtentechnik

Wir beginnen mit einem Exkurs in die Nachrichtentechnik, die die benutzen Vokabeln geprägt hat. Wie können wir Information, beispielsweise ein Radio-Programm, über eine längere Distanz übertragen?

Im Folgenden meint 'Signal' dieses Radio-Programm, also eine zeitlich variable Amplitude $a(t)$, deren Bandbreite begrenzt ist, weil Sprache oder Musik nur in einem gewissen Frequenzintervall stattfindet (ca. 100 Hz bis 5 KHz). Dieses Signal wird über einen 'Kanal' übertragen. Das kann optisch in einer Glasfaser oder als Radiosignal geschehen. Dazu wird das Signal auf einen 'Träger' aufmoduliert. Die Lichtwelle (bei 300 THz) oder die Radiowelle (bei 100 kHz bis 100 MHz) transportiert ja an sich keine Information. Erst durch Ändern ihrer Amplitude oder Frequenz wird Information übertragen.

Durch die Modulation wird das Frequenzspektrum des Trägers breiter, in erster Näherung um $\pm$ die Bandbreite des Signals. Verschiedene Träger-Frequenzen müssen also passenden Abstand einhalten, damit die Signale sich nicht gegenseitig beeinflussen.

"""

# ╔═╡ 335bef32-3e5e-407c-82ca-5f7c2c26f0b5
md"""
## Amplitudenmodulation

Die einfachste Methode ist die Amplitudenmodulation. Man ändert die Amplitude einer Radiowelle oder die Helligkeit eines Laserstrahls proportional zu zum Signal $a(t)$. Dabei muss man berücksichtigen, dass $a(t)$ negativ werden könnte, zählt also einen passende offset $o$ hinzu. Damit erhalten wir für für die ausgesandt Wellenform $w(t)$
```math
 w(t) = \left[o + a(t) \right] \, \cos (\omega_c \, t)
```
mit der Träger-Kreisfrequenz $\omega_c$. Das Spektrum $W(\omega)$ besteht als aus dem des Signals $A(\omega)$ symmetrisch über- und unterhalb der Trägerfrequenz $\omega_c$.

Die Erzeugung eines solchen amplitudenmodulierten Wellenform ist technisch einfach. Man kann beispielsweise den Verstärkungsfaktor bzw. die Versorgungsspannung eines Verstärkers modulieren.
"""

# ╔═╡ c7f25ac2-fa2e-4868-b291-425811b24c52
md"""
## Demodulation

Um das Signal aus einer amplituden-modulierten Wellenform wiederzugewinnen, muss man zunächst die empfangene Wellenform verstärken. Dies geschieht also bei der Trägerfrequenz $\omega_c$ und in einem gewissen Frequenzintervall darum herum. Wenn diese Verstärker-Bandbreite gerade der Signal-Bandbreite entspricht, dann wären alle anderen Kanäle unterdrückt und man hätte $w(t)$ wiedergewonnen. Gleichrichten und Tiefpass-filtern liefert dann $o + a(t)$. Hochpass-Filtern entfernt $o$ und man behält $a(t)$.

Leider erfordert dies im Radio-Empfänger einen genau abstimmbaren Verstärker bzw. eigentlich eine Kette von Verstärkern, die für jeden Kanal, jeden Sender neu abgestimmt werden müssten. Das ist technisch schwierig.

"""

# ╔═╡ 62b3923d-f1b6-4319-8a99-afc3c5c25ad5
md"""
## Heterodyne Detektion (historisch)

Die Idee der Heterodyn-Detektion geht zurück auf dem [Empfang von Morse-Code](https://en.wikipedia.org/wiki/Superheterodyne_receiver#Heterodyne) und entstand um 1905. Wenn nicht ein Träger amplitudenmoduliert wurde, sondern zwei nahe benachbarte Träger-Frequenzen, dann kann man diese beiden Frequenz im Empfänger miteinander mischen. Bei passender Wahl ist die Differenzfrequenz im hörbaren Frequenzbereich (z.B. bei 3 kHz).
"""

# ╔═╡ 45e1edbd-af2b-4e91-a7ba-8eeade872c96
md"""
## Super-Heterodyne Detektion

Der heutzutage quasi immer verwendete Superheterodyn-Empfänger verwendet einen lokalen Oszillator bei $\omega_{LO}$ statt der zweiten Trägerfrequenz. Und der Frequenzunterschied $\omega_{IF} = \omega_c - \omega_{LO}$ ist *supersonic*, also deutlich höher als hörbar. Dei Vorsilbe *super* lässt man aber gerne weg.
"""

# ╔═╡ 54c71647-520a-4d0d-a64f-d3f39e0cf6e2
md"""
$(Resource("https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Superheterodyne_receiver_block_diagram_2.svg/512px-Superheterodyne_receiver_block_diagram_2.svg.png", (:height => 200))) *Blockdiagramm eines typischen Superheterodyn-Empfängers. Rot sind die Teile, die das eingehende Hochfrequenzsignal (HF) verarbeiten; grün sind die Teile, die auf der Zwischenfrequenz (ZF) arbeiten, während die blauen Teile auf der Modulationsfrequenz (Audio) arbeiten. Aus [wikipedia](https://en.wikipedia.org/wiki/Heterodyne#/media/File:Superheterodyne_receiver_block_diagram_2.svg)*
"""

# ╔═╡ 6a79b216-b8cb-4447-b20d-334905c1c899
md"""
Die Antenne empfängt das gesamte Frequenzspektrum, das durch eine RF-Filter zunächst nur grob vorgefiltert wird. Der lokale Oszillator ist um die Frequenz $\omega_{if}$ gegenüber der gewünschten Trägerfrequenz $\omega_{S1}$ verstimmt. Nach dem Mischen (und grober Tiefpass-Filterung) bleiben nur wenige Kanäle übrig. Der schmalbandige IF-Filter behält dann nur noch den einen Kanal. Dieser kann dann wie gewöhnlich demoduliert werden.

Der Vorteil ist, dass der schmalbandige Filter bei IF bei einer technisch angenehmen Frequenz betrieben werden kann. Bei hohen Radiofrequenzen sind Filter etc. technisch viel aufwändiger. Und nur der grobe RF-Filter muss an den Kanal angepasst werden. Der selektive IF-Filter bleibt konstant.
"""

# ╔═╡ 930f49b6-60cc-43a2-8ef4-6802c8f47c01
md"""
## Homodyne Detektion

Ein Nachteil der Superheterodyn-Technik ist der Zwischenschritt über die IF-Frequenz. Man hat versucht, das konzeptionell einfacher zu bauen, indem man gleich auf die Frequenz Null herunter mischt. Das ist die homodyne Detektion bzw. der [Direktmischempfänger](https://de.wikipedia.org/wiki/Direktmischempf%C3%A4nger) und sehr ähnlich dem Lock-In-Verstärker. Schaltungstechnisch hat sich das nicht durchgesetzt, aber in moderner Digitaltechnik wird dies oft implementiert, beispielsweise in *software defined radio* ([SDR](https://en.wikipedia.org/wiki/Software-defined_radio)).

"""

# ╔═╡ 897c3e7a-d5b3-48d1-9f74-1b7df9aafa35
md"""
## Frequenzmodulation

Neben der Amplitudenmodulation (AM) ist die Frequenzmodulation (FM) eigentlich bedeutsamer. Das Signal $a(t)$ wird auf die Frequenz der Trägerwelle moduliert. Die gesendete Wellenform ist also
```math
w_{FM}(t) = \cos \left( \omega_c t + \omega_\Delta \, \int_0^t a(\tau) d\tau \right)
```
bzw. analog die Phasenmodulation  (PM)
```math
w_{PM}(t) = \cos \left( \omega_c t + \omega_\Delta \, a(t)  \right)
```
"""

# ╔═╡ 6ad17be2-6765-4a25-a2a6-6ef212cef4eb
md"""
Lassen Sie uns  annehmen, dass das Signal nur aus einem Ton bei $\omega_m$ besteht, also $a(t) =  \cos \omega_m t$. Dann wird das Integral $\sin (\omega_m t) / \omega_m$ und somit
```math
w_{FM}(t) = \cos \left( \omega_c t + \frac{\omega_\Delta}{\omega_m} \, \sin (\omega_m t)\right)
```
Den Term 
```math
h = \frac{\omega_\Delta}{\omega_m}
```
nennt man **Modulations-Index**. Die Amplitude der einzelnen Frequenz-Komponenten folgt damit Bessel-Funktionen $J_k(h)$
```math
w_{FM}(t) = \cos \left( \omega_c t + h \, \sin (\omega_m t)\right)
= \sum_{k=-\infty}^\infty J_k(h) \, \cos ( \, [\omega_c + k \omega_m] \, t)
```
Die Anzahl der **Seitenbänder**  bei $k\neq 0$ entspricht ungefähr dem Wert des Modulations-Indexes $h$.
"""

# ╔═╡ 40c4add3-1ab8-4da1-8ebe-0bab8e1d24d7
md"""
Zur Detektion eignet sich auch ein Superheterodyn-Detektor. Der Verstärker im IF-Bereich wird so ausgelegt, dass er sättigt, also immer die gleiche Amplitude liefert, egal wie stark das Eingangssignal war. Danach braucht es noch einen Detektor, der die instantane Frequenz bestimmt, beispielsweise eine *phase locked loop* ([PLL](https://de.wikipedia.org/wiki/Phasenregelschleife)).
"""

# ╔═╡ 0dbc08ef-1c03-4f6f-88a0-18b7c19fa9b1
md"""
# Optische Signale

Radiowellen und Licht sind beides elektromagnetische Wellen, nur in verschiedenem Frequenzbereich. Die Konzepte der Nachrichtentechnik lassen sich deswegen zumindest teilweise übertragen.
"""

# ╔═╡ cda6bbea-4650-4c9a-87de-9763f25e1cd7
md"""
### Amplitudenmodulation

Wenn das Experiment eine Amplitudenmodulation $a(t)$ bewirkt, dann ist das Lichtfeld nach dem Experiment
```math
E_S(t) = E_0 \, [1 + a(t) ] \, e^{i \omega_0 t}
```
und der lokale Oszillator 
```math
E_{LO}(t) = E_{LO} \,  \,  e^{i \omega_0 t + \Delta \phi}
```
Der Photostrom ist damit 
```math
I(t) \propto \left| E_S(t) + E_{LO}(t) \right|^2
```
"""

# ╔═╡ 591de8fc-94a9-4430-8098-a72e59e77629
md"""
Betrachten wir zunächst den Fall ohne lokalen Oszillator, also $E_{LO} = 0$. Dann ist
```math
I(t) \propto |E_0|^2 [1 + a][1+ a^\star] = |E_0|^2 \, [1  + 2 \Re \{a(t)\} + |a(t)|^2] \approx  |E_0|^2 \, [1  + 2 \Re \{a(t)\}]
```
Wir sind ja nur an kleinen Signalen, also $a(t) \ll 1$ interessiert.
"""

# ╔═╡ 4d7ecda5-a8aa-4839-97ee-a87d73114c03
md"""
Mit lokalen Oszillator wird dies zu
```math
I(t) \propto \left| E_0 [1 + a(t)] + E_{LO} e^{i\Delta \phi} \right|^2
```
Interessant ist der Fall von einem sehr starken lokalen Oszillator, also $E_{LO} \gg E_0$. Damit wird
```math
I(t) \approx |E_{LO}|^2 \, [1  + 2 \Re \{a(t) \, e^{-i \Delta \phi} \}]
```

Der Effekt des lokalen Oszillators ist also zum Einen, die Signal-Amplitude zu erhöhen ohne mehr Lichtleistung durch das Experiment schicken zu müssen, falls die Probe beispielsweise nur eine gewisse Intensität toleriert. Zum Anderen kommt $\Delta \phi$ also Freiheitsgrad hinzu. Man kann somit also nicht nur den Realteil von $a(t)$ detektieren, sondern auch den Imaginärteil bze. eine durch die Probe hervorgerufene Phasenverschiebung.

Im Prinzip kann man aber auch schon die '1' in obigen Gleichungen als lokalen Oszillator verstehen. Quasi alle optischen Messungen beinhalten immer auch Licht, dass nicht durch das Experiment tangiert wurde, eben den '1'-Term. Dieses Licht interferiert immer am Detektor mit dem '$a(t)$'-Term, so dass immer eine homodyne Detektion vorliegt, solange man nicht besondere Vorkehrungen trifft.
"""

# ╔═╡ 9b7ae5b7-02f1-42c2-bfac-0dfa8b23c255
md"""
> Sie wollen ein kleines SIgnal $a(t)$ detektieren, dass sie zwischen $a=0$ und $a=a_0$ schalten können. Untersuchen Sie den Einfluss verschiedener Rausch-Quellen auf das SNR, und ob daran interferometrische Detektion etwas ändert / ändert kann.
"""

# ╔═╡ 2f9db9e2-8120-45b4-8839-5a74b0cd0b95
md"""
### Frequenzmodulation

Der Effekt des Experiments sei, dass eine zusätzliche optische Frequenz im Signal-Arm erscheint, die etwas gegenüber der eigentlichen Trägerfrequenz verschieben ist (dazu unten mehr). Das elektrische Feld nach dem Experiment ist also
```math
E_S = E_0 \left[ e^{i \omega_0 t} + a(t) e^{i (\omega + \Delta \omega) t} \right]
```
Der lokale Oszillator vergrößert wieder die Feldamplitude bei der Frequenz $\omega_0$ und liefert den Freiheitsgrad der Phase. Unabhängig davon findet man mit und ohne Referenzarm einen Term, der proportional zu 
```math
\Re \left( e^{i \Delta \omega t} \right)
```
ist, also Kosinus-förmig mit $\Delta \omega$ oszilliert.
"""

# ╔═╡ e7c85170-32d4-4831-9bf4-f1fa1beafda6
md"""
## Bsp. zu Optische Heterodyn-Detektion

Manchmal möchte man die Amplitude und Phase einer Frequenzkomponente im Lichtfeld bestimmen, die um eine RF-Frequenz gegenüber der Trägerwelle verschoben ist. Als Beispiel diskutiere ich hier ein Experiment zum optischen Vier-Wellen-Mischen

Wolfgang Langbein and Brian Patton: *Heterodyne spectral interferometry for multidimensional nonlinear spectroscopy of individual quantum systems.*  [Opt. Lett. 31, 1151-1153 (2006)](https://doi.org/10.1364/OL.31.001151)
"""

# ╔═╡ 279d0c8b-8798-49b5-aacf-28cf24b88067
md"""
### Vier-Wellen-Mischen

Vier-Wellen-Mischen ist ein nichtlinearer optischer Effekt, bei dem  drei optische Wellen eine neue, vierte Welle erzeugen,  zu dieser gemischt werden. Ausgangspunkt ist dabei eine nichtlineare optische Polarisation dritter Ordnung
```math
P^{(3)} = \chi^{(3)} \, E_1(t) \, E_2(t) \, E_3(t)
```
Jedes der 3 Felder $E_i$ kann eine eigener Frequenz $\omega_i$ haben. Da
```math
2 \cos x = e^{i x} + e^{-i x}
```
tauchen sowohl positive als auch negative Frequenzen auf. Im Prinzip gibt es also $2^3 = 8$ Mischprodukte, die unterschiedlichen physikalischen Ursprung haben. In diesen Artikel ist man an dem mit den Vorzeichen $(-++)$ interessiert. Weiterhin wählt das Experiment $E_2 = E_3$. Die zu analysierenden Frequenz ist also
```math
\omega_4 = -\omega_1 + 2 \omega_2 
```
"""

# ╔═╡ 5dd3ad80-05d7-473c-bd24-0681401c6de6
md"""
### AOM als Frequenz-Schieber

Im Experiment bestehen die Felder $E_i$ aus Laserpulsen, und deren zeitliche Reihenfolge ist relevant. Dazu wird ein Laserstrahl in 2 Teile aufgeteilt und jeder Teil durch einen *Akusto-Optischen Modulator* (AOM) geschickt. Hier wird der Strahl an einem Ultraschall-Gitter gebeugt. Dabei wird jede Bergungsordnung $\pm k$ um $k$ mal die Ultraschallfrequenz $\Omega$ frequenzverschoben (sonst würde die Energieerhaltung nicht zusammen mit der Impulserhaltung gelten). Damit ist also
```math
\omega_k = \omega_{laser} + k \Omega
```
Die einzelnen $\omega_i$ von oben basieren also alle auf dem gleichen $\omega_{laser}$, sind jedoch in zwei verschiedenen AOM um zwei verschiedene $\Omega_{AOM}$ verschoben.
"""

# ╔═╡ 859e2f65-c352-42e4-b93c-a8555b72beb0
md"""
### Heterodyn-Detektion 

Das Mischprodukt $\omega_4$ liegt wieder in der Nähe von $\omega_{laser}$ (so ist der Prozess ausgewählt). Wo genau hängt aber von den $\Omega_{AOM}$ ab. Jetzt kommt die Heterodyn-Detektion zum Einsatz. An einem ditten AOM bei der Frequenz  $\Omega_D$  treffen sich der Strahl $E_4$ von der Probe und ein Refrenz-Strahl $E_R$ dirket vom Laser. Der Winkel zwsicehn deb beiden Strahl enspricht gerade dem Beugubgswinkel. Die Ordnung +1  von $E_4$ geht also in die gleoiche Rcihung wie die Nullte Ordnung von $E_R$ bzw. die Ordnung -1 von $E_R$ überlagert sich mit $E_4$. Ingesamt begkommt mal also
```math
E_a = E_R + E_4 e^{i \Omega_D t} \quad \text{und} \quad E_b = E_R e^{-i \Omega_D t} + E_4 
```
Das Spektromteer misst Intesnitäten, also zB
```math
I_a \propto |E_a|^2 = |E_R|^2 + |E_4|^2 + 2 \Re \left\{ E_R^\star \, E_4   \, e^{i \Omega_D t}  \right\}
```
und mittelt diese über die Integarionszeit. Der dritte Term oszilliert in $t$ und mittelt sich so weg, wenn nicht gerade alle Frequenzen sich gegenseitig aufheben, also gerade $\omega_4 = \omega_{laser} - \Omega_D$. Wenn man dann och $I_a - I_b$ betarchtet, dann heben sich die konstanten ertsbn beiden terme gerade weg.
"""

# ╔═╡ e21750ab-95e5-4ae2-a596-53dcd04de064
TableOfContents(title="Inhalt")

# ╔═╡ 8096a364-ef4a-4dea-b362-f61735a23956
aside(x) = PlutoUI.ExperimentalLayout.aside(x);

# ╔═╡ 730ce393-de75-4147-933b-62e092400bf6
md"""
$(aside([Resource("https://upload.wikimedia.org/wikipedia/commons/thumb/0/06/How_superheterodyne_receiver_works.svg/1200px-How_superheterodyne_receiver_works.svg.png") md"*Funktionsweise eines Superheterodyn-Empfängers*. Aus [wikipedia](https://en.wikipedia.org/wiki/Superheterodyne_receiver#/media/File:How_superheterodyne_receiver_works.svg) "]))
"""

# ╔═╡ 140c248e-51f1-4eac-91d3-2b0d599ba11f
md"""
## Optische Homodyn-Detektion

Man kan ein Interferometer als Variante der Homodyn-Detektion betrachten.$(aside([Resource("https://upload.wikimedia.org/wikipedia/commons/0/08/HomodyneDetection2.png", (:width => 200)) md"*Interferometer*. Aus [wikipedia](https://en.wikipedia.org/wiki/Homodyne_detection) "])) Im Unterschied zu Nachrichtentechnik müssen lokaler Oszillator und Trägerwelle von gleichen Laser abgeleitet werden, damit sie phasenstabil genug sind. Die Trennung geschieht im ersten Strahlteiler. Im Signal-Arm (hier senkrecht) bewirkt das Experiment dann eine Amplituden- oder Frequenzmodulation des Trägers. Am zweiten Strahlteiler werden beide Arme wieder überlagert. Die Photodiode liefert einen Strom proportional zum Quadrat der Gesamt-Feldstärke und dient somit gleichzeitig als Mischer und auch Tiefpass-Filter, weil die doppelte optische Frequenz jenseits der elektrischen Bandbreite liegt.
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.39"
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
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

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
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

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
git-tree-sha1 = "0044b23da09b5608b4ecacb4e5e6c6332f833a7e"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.3.2"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "8d1f54886b9037091edf146b517989fc4a09efec"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.39"

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

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

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
# ╟─46112d95-89d9-427d-b825-3807d4f15d27
# ╟─705a5b52-96f3-11ec-11e9-45e1cd363a35
# ╟─2f71a18f-fad3-4ecf-8c8e-eefbbdb008bd
# ╟─335bef32-3e5e-407c-82ca-5f7c2c26f0b5
# ╟─c7f25ac2-fa2e-4868-b291-425811b24c52
# ╟─62b3923d-f1b6-4319-8a99-afc3c5c25ad5
# ╟─45e1edbd-af2b-4e91-a7ba-8eeade872c96
# ╟─54c71647-520a-4d0d-a64f-d3f39e0cf6e2
# ╟─730ce393-de75-4147-933b-62e092400bf6
# ╟─6a79b216-b8cb-4447-b20d-334905c1c899
# ╟─930f49b6-60cc-43a2-8ef4-6802c8f47c01
# ╟─897c3e7a-d5b3-48d1-9f74-1b7df9aafa35
# ╟─6ad17be2-6765-4a25-a2a6-6ef212cef4eb
# ╟─40c4add3-1ab8-4da1-8ebe-0bab8e1d24d7
# ╟─0dbc08ef-1c03-4f6f-88a0-18b7c19fa9b1
# ╟─140c248e-51f1-4eac-91d3-2b0d599ba11f
# ╟─cda6bbea-4650-4c9a-87de-9763f25e1cd7
# ╟─591de8fc-94a9-4430-8098-a72e59e77629
# ╟─4d7ecda5-a8aa-4839-97ee-a87d73114c03
# ╟─9b7ae5b7-02f1-42c2-bfac-0dfa8b23c255
# ╟─2f9db9e2-8120-45b4-8839-5a74b0cd0b95
# ╟─e7c85170-32d4-4831-9bf4-f1fa1beafda6
# ╟─279d0c8b-8798-49b5-aacf-28cf24b88067
# ╟─5dd3ad80-05d7-473c-bd24-0681401c6de6
# ╟─859e2f65-c352-42e4-b93c-a8555b72beb0
# ╠═238209b9-b380-459f-86c7-5b73ff69e7e7
# ╠═e21750ab-95e5-4ae2-a596-53dcd04de064
# ╠═8096a364-ef4a-4dea-b362-f61735a23956
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
