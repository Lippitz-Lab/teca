### A Pluto.jl notebook ###
# v0.19.26

using Markdown
using InteractiveUtils

# ╔═╡ 46112d95-89d9-427d-b825-3807d4f15d27
html"""<div>
<font size="7"><b>12 Homodyn- und Heterodyn-Detektion</b></font> </div>

<div><font size="5"> Markus Lippitz</font> </div>
<div><font size="5"> 29. Juni 2022 </font> </div>
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

# ╔═╡ 730ce393-de75-4147-933b-62e092400bf6
md"""
$(aside([Resource("https://upload.wikimedia.org/wikipedia/commons/thumb/0/06/How_superheterodyne_receiver_works.svg/1200px-How_superheterodyne_receiver_works.svg.png") md"*Funktionsweise eines Superheterodyn-Empfängers*. Aus [wikipedia](https://en.wikipedia.org/wiki/Superheterodyne_receiver#/media/File:How_superheterodyne_receiver_works.svg) "]))
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

# ╔═╡ 140c248e-51f1-4eac-91d3-2b0d599ba11f
md"""
## Optische Homodyn-Detektion

Man kan ein Interferometer als Variante der Homodyn-Detektion betrachten.$(aside([Resource("https://upload.wikimedia.org/wikipedia/commons/0/08/HomodyneDetection2.png", (:width => 200)) md"*Interferometer*. Aus [wikipedia](https://en.wikipedia.org/wiki/Homodyne_detection) "])) Im Unterschied zu Nachrichtentechnik müssen lokaler Oszillator und Trägerwelle von gleichen Laser abgeleitet werden, damit sie phasenstabil genug sind. Die Trennung geschieht im ersten Strahlteiler. Im Signal-Arm (hier senkrecht) bewirkt das Experiment dann eine Amplituden- oder Frequenzmodulation des Trägers. Am zweiten Strahlteiler werden beide Arme wieder überlagert. Die Photodiode liefert einen Strom proportional zum Quadrat der Gesamt-Feldstärke und dient somit gleichzeitig als Mischer und auch Tiefpass-Filter, weil die doppelte optische Frequenz jenseits der elektrischen Bandbreite liegt.
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
Jedes der 3 Felder $E_i$ kann eine eigener Frequenz $\omega_i$ haben. Die nichtlinear e Polarisation $P^{(3)}$ strahlt ein viertes Feld ab, dessen Frequenz die Summe der einzelnen Frequenzen ist.
Da
```math
2 \cos x = e^{i x} + e^{-i x}
```
tauchen sowohl positive als auch negative Frequenzen auf. Im Prinzip gibt es also $2^3 = 8$ Mischprodukte, die unterschiedlichen physikalischen Ursprung haben. In diesen Artikel ist man an dem mit den Vorzeichen $(-++)$ interessiert. Weiterhin wählt das Experiment $E_2 = E_3$. Die zu analysierenden Frequenz ist also
```math
\omega_4 = -\omega_1 + 2 \omega_2 
```
"""

# ╔═╡ f89b3eeb-84bd-499f-a106-0878942430f6
md"""
$(Resource("https://raw.githubusercontent.com/MarkusLippitz/teca/main/res/12-heterodyn/setup.png", (:height => 400))) *Schema des Aufbaus von Langbein und Patton.*
"""

# ╔═╡ 5dd3ad80-05d7-473c-bd24-0681401c6de6
md"""
### AOM als Frequenz-Schieber

Im Experiment bestehen die Felder $E_i$ aus Laserpulsen, und deren zeitliche Reihenfolge ist relevant. Dazu wird ein Laserstrahl in 2 Teile aufgeteilt und jeder Teil durch einen *Akusto-Optischen Modulator* (AOM) geschickt. Hier wird der Strahl an einem Ultraschall-Gitter gebeugt. Dabei wird jede Beugungsordnung $k = 0, \pm 1, \pm2, \dots $ um $k$ mal die Ultraschallfrequenz $\Omega$ frequenzverschoben (sonst würde die Energieerhaltung nicht zusammen mit der Impulserhaltung gelten). Damit ist also
```math
\omega_k = \omega_{laser} + k \Omega
```
Die einzelnen $\omega_i$ von oben basieren also alle auf dem gleichen $\omega_{laser}$, sind jedoch in zwei verschiedenen AOM um zwei verschiedene $\Omega_{AOM}$ verschoben.
"""

# ╔═╡ 859e2f65-c352-42e4-b93c-a8555b72beb0
md"""
### Heterodyn-Detektion 

Das Mischprodukt $\omega_4$ liegt wieder in der Nähe von $\omega_{laser}$ (so ist der Prozess ausgewählt). Wo genau hängt aber von den $\Omega_{AOM}$ ab. Jetzt kommt die Heterodyn-Detektion zum Einsatz. An einem dritten AOM bei der Frequenz  $\Omega_D$  treffen sich der Strahl $E_4$ von der Probe und ein Referenz-Strahl $E_R$ direkt vom Laser. Der Winkel zwischen den beiden Strahl entspricht gerade dem Beugungswinkel. Die Ordnung +1  von $E_4$ geht also in die gleiche Richtung wie die Nullte Ordnung von $E_R$ bzw. die Ordnung -1 von $E_R$ überlagert sich mit $E_4$. Insgesamt bekommt mal also
```math
E_a = E_R + E_4 e^{i \Omega_D t} \quad \text{und} \quad E_b = E_R e^{-i \Omega_D t} + E_4 
```
Das Spektrometer misst Intensitäten, also z.B.
```math
I_a \propto |E_a|^2 = |E_R|^2 + |E_4|^2 + 2 \Re \left\{ E_R^\star \, E_4   \, e^{i \Omega_D t}  \right\}
```
und mittelt diese über die Integrationszeit. Der dritte Term oszilliert in $t$ und mittelt sich so weg, wenn nicht gerade alle Frequenzen sich gegenseitig aufheben, also gerade $\omega_4 = \omega_{laser} - \Omega_D$. Wenn man dann noch $I_a - I_b$ betrachtet, dann heben sich die konstanten ersten beiden Terme gerade weg. 

So ist man in der Lage, Amplitude und Phase von $E_4$ (und damit von dem gewählten $P^{(3)})$) zu detektieren. Das Spektrometer sorgt dafür, dass man nicht nur die Gesamtintensität, sondern auch noch deren spektralen Verlauf kennt. Im dem Artikel wird so die Kopplung zwischen verschiedenen Zuständen eines Quantenpunkts untersucht.
"""

# ╔═╡ 238209b9-b380-459f-86c7-5b73ff69e7e7
using PlutoUI

# ╔═╡ e21750ab-95e5-4ae2-a596-53dcd04de064
TableOfContents(title="Inhalt")

# ╔═╡ 8096a364-ef4a-4dea-b362-f61735a23956
aside(x) = PlutoUI.ExperimentalLayout.aside(x);

# ╔═╡ Cell order:
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
# ╟─e7c85170-32d4-4831-9bf4-f1fa1beafda6
# ╟─279d0c8b-8798-49b5-aacf-28cf24b88067
# ╟─f89b3eeb-84bd-499f-a106-0878942430f6
# ╟─5dd3ad80-05d7-473c-bd24-0681401c6de6
# ╟─859e2f65-c352-42e4-b93c-a8555b72beb0
# ╠═238209b9-b380-459f-86c7-5b73ff69e7e7
# ╠═e21750ab-95e5-4ae2-a596-53dcd04de064
# ╠═8096a364-ef4a-4dea-b362-f61735a23956
