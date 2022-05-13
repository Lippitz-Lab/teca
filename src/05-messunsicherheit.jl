### A Pluto.jl notebook ###
# v0.19.4

using Markdown
using InteractiveUtils

# ╔═╡ 49b9386e-2eb0-41e5-97a9-1da882abd4f6
using Distributions, Plots

# ╔═╡ 2b794068-00e4-47b3-b082-7fba3c3adb9e
using PlutoUI

# ╔═╡ f5450eab-0f9f-4b7f-9b80-992d3c553ba9
# DO NOT MODIFY, will be updated by update_navbar.jl
HTML("    <nav >\n    Vorbereitungen:\n\n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/index.html\"><em>Intro</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/software.html\"><em>Software</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/01-basic_syntax.html\"><em>Julia Basics</em></a> / \n\n<br>\nStatistik:\n\n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/02-beschreibende-statistik.html\"><em>Beschreibende Statistik</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/03-wahrscheinlichkeit.html\"><em>Wahrscheinlichkeit</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/04-schaetzung.html\"><em>Schätzung</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/05-messunsicherheit.html\"><em>Messunsicherheit</em></a> / \n\n<br>\nFourier-Transformation:\n\n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/06-Fourier-Transformation.html\"><em>Fourier-Transformation</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/07-Frequenzraum.html\"><em>Frequenzraum</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/08-Filter.html\"><em>Filter</em></a> / \n\n<br>\nMesstechnik:\n\n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/09-Rauschen.html\"><em>Rauschen</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/10-Detektoren.html\"><em>Detektoren</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/11-Lock-In.html\"><em>Lock-In-Verstärker</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/12-heterodyn.html\"><em>Heterodyn-Detektion</em></a> / \n\n<br>\n\n\n    </nav>\n\t")

# ╔═╡ 82598f44-f996-4be0-a420-ef7f6748d1d7
html"""<div>
<font size="7"><b>5 Messunsicherheit</b></font> </div>

<div><font size="5"> Markus Lippitz</font> </div>
<div><font size="5"> 6. Mai 2022 </font> </div>
"""

# ╔═╡ 2b3ac165-b309-4f18-b28b-18a5aa2c529a
md"""


**Ziele** Sie können verschiedene Arten von Messunsicherheiten
*unterscheiden*, sowie den Formalismus ihrer Zusammenführung *erklären*
und *anwenden*.

-   Bayes Statistik und die Bedeutung von 'Wahrscheinlichkeit': Abzählen
    von Ereignissen oder Unwissen.

-   Formalismus des 'Guide to the expression of uncertainty in
    measurement' (GUM)

-   Kombination von Unsicherheiten, auch bekannt als Fehlerfortpflanzung

"""

# ╔═╡ 194d4005-0890-4dbb-907f-ec7aac5c5fc7
md"""
**Literatur** Stahel Kap. 4, Tschirk Kap. 2 & 7, Kirkup &
Frenkel Kap.4--10, Schenk & Kremer Kap. EF.3
"""

# ╔═╡ 503d28ba-ec06-47c6-bd7c-13450e83e70c
md"""
# Fehler und Unsicherheiten

Es ist sinnvoll, zwischen Fehlern und Unsicherheiten zu unterscheiden.
Fehler sollte man vermeiden. Unsicherheiten sind nie zu vermeiden,
können aber reduziert werden.
"""

# ╔═╡ 4cc2fdf9-f03f-4e3f-9f10-a1115c884ff5
md"""
**Grobe Fehler** sind beispielsweise offensichtliche Fehlbedienungen des Messgeräts und
manifestieren sich durch eine deutliche Abweichung des gemessenen Werts
vom erwarteten Messwert. Solche Fehler sollte man natürlich vermeiden.
Falls sie doch auftreten und bemerkt werden, dann wiederholt man
wahrscheinlich am einfachsten die Messung oder schließt zumindest diesen
Messwert von der weiteren Analyse aus.
"""

# ╔═╡ c1c96736-4e97-4efa-915c-f9933572c137
md"""
**Systematische Fehler** sind eine Umschreibung dafür, dass der Messprozess nicht ganz so
einfach, so ideal ist, wie man zunächst denken könnte. Eine Waage zeigt
einen von Null verschiedenen Wert an, auch wenn keine Masse aufgelegt
ist. Ein Maßstab dehnt sich mit der Temperatur aus. Diese und ähnliche
Komplikationen berücksichtigt man durch eine passende Erweiterung des
Modells, das die Messung beschreibt. Danach sollten diese Fehler keine
Rolle mehr spielen, falls doch, dann beschreiben systematische Fehler
mangelndes Verständnis des Messprozesses und sind häufig erst im
Rückblick zu erkennen. Gute Experimente zeichnen sich dadurch aus, dass
systematische Fehler vollständig behandelt werden.
"""

# ╔═╡ b12ba649-965e-4778-8a8b-5c52b7bb7319
md"""
**Unsicherheiten** sind aber nie zu vermeiden. Sie können verschiedene Ursachen habe. Jede
Waage zeigt das Gewicht nur mit einer endlichen Anzahl Stellen an,
beispielsweise $m=12.3$g. Das wahre Gewicht kann damit aber immer noch
im Intervall $12.25$g -- $12.35$g liegen. Wiederholte Messungen unter
konstanten Bedingungen können abweichende, leicht schwankende Ergebnisse
liefern. Dieses Rauschen ist ein Zeichen dafür, dass die Bedingungen
technisch oder auch grundsätzlich nicht exakt kontrolliert werden
können. Wieviel Atome in der nächsten Sekunde einen Alpha-Zerfall machen
unterliegt nicht unserer Kontrolle.
"""

# ╔═╡ 1f606df6-ff05-442f-b163-5d6186ec49af
md"""
Wie beschreibt man nun solche Unsicherheiten? Welchen Einfluss haben
Unsicherheiten der Messgrößen auf daraus berechnete Werte? Wie
berücksichtigt man dabei Unsicherheiten, die man selbst bestimmt, und
solche, die beispielsweise in Datenblättern dokumentiert sind? Person A
entwickelt eine Waage und dokumentiert deren Unsicherheit. Person B
benutzt diese Waage, um die Dichte von Ethanol zu messen, und
dokumentiert die Unsicherheit in der Dichte. Person C benutzt diese
gemessene Dichte (und deren Unsicherheit), um die Viskosität (und deren
Unsicherheit) zu bestimmen. Unsicherheiten müssen also konsistent und
vergleichbar dokumentiert werden, und es muss ein Verfahren geben,
Unsicherheiten aus verschiedenen Quellen in ein Berechnung einfließen zu
lassen.
"""

# ╔═╡ db28dc51-f417-459e-a0eb-b93dced3cc25
md"""
Ein solches Verfahren wird im **'Guide to the Expression of Uncertainty in
Measurement' (GUM)** des *Bureau International des Poids et Mesures*
beschrieben und ist Industriestandard in der Metrologie. Es
standardisiert und modifiziert damit teilweise das, was in der Physik
unter 'Fehlerrechnung' verstanden wurde. Ein wesentlicher Punkt ist,
dass systematische Fehler gar nicht betrachtet werden (diese sind ja zu
vermeiden) und Unsicherheiten nach dem Weg zu ihrer Bestimmung als Typ A
(statistisch) und Typ B (Datenblatt) klassifiziert werden. Der
wissenschafts-philosophisch interessante Punkt ist die gleichberechtigte
Behandlung und Zusammenfassung dieser beiden Typen Unsicherheiten.
Unsicherheiten von Typ A benutzen den Wahrscheinlichkeitsbegriff der
klassischen Statistik (frequentistisch, also durch Abzählen bestimmt).
Typ B Unsicherheiten sind geprägt von dem Bayes'schen
Wahrscheinlichkeitsbegriff, der den Grad unserer persönlichen
Überzeugung, unseres Wissens beschreibt. Die meisten Wissenschaftler:innen
lösen dieses Problem pragmatisch, ebenso wie der GUM, und ignorieren
diesen Unterschied außerhalb philosophischer Diskussionen.
"""

# ╔═╡ 13858297-cad0-42a6-aa3e-1b25f4811434
md"""
Folgende Quellen beschreiben GUM

- [**JCGM 100:2008**](https://www.bipm.org/documents/20126/2071204/JCGM_100_2008_E.pdf/cb0ef43f-baa5-11cf-3f85-4dcd86f77bd6?version=1.9&t=1641292658931&download=true) Dokument 100 aus dem Jahr 2008 des Joint Committee for Guides in
    Metrology mit dem Titel 'Evaluation of measurement data --- Guide to
    the expression of uncertainty in measurement'. Dies ist der zentrale
    Text mit vielen Anhängen, allerdings nicht einfach zu lesen.

- [**JCGM 104:2009**](https://www.bipm.org/documents/20126/2071204/JCGM_104_2009.pdf/19e0a96c-6cf3-a056-4634-4465c576e513?version=1.12&t=1641293439338&download=true) Dokument 104 aus dem Jahr 2009 des Joint Committee for Guides in
    Metrology mit dem Titel 'Evaluation of measurement data -- An
    introduction to the \"Guide to the expression of uncertainty in
    measurement\" and related documents'. Von diesem Text gibt es auch
    eine deutsche Übersetzung. Diese Einführung ist etwas besser zu
    lesen als \[JCGM 100:2008\], aber immer noch sehr formal
    geschrieben.

- [**Kirkup / Frenkel**](https://doi.org/10.1017/CBO9780511755538) Das Buch 'An Introduction to Uncertainty in Measurement using the
    GUM' von Les Kirkup und Bob Frenkel gibt auf ca. 200 Seiten eine
    sehr gut lesbare Einführung in dieses Thema. Hier werden auch alle
    Beziehungen hergeleitet, auf die in diesem Tutorial nur verwiesen
    wird. Auch zeigen die Autoren viele Beispiele.
"""

# ╔═╡ 55150760-9de7-449f-96b3-ee5275c30378
md"""
# Bestimmung der Messunsicherheit
"""

# ╔═╡ f9182cc9-95f0-43b7-b302-bc508739bce7
Resource("https://raw.githubusercontent.com/MarkusLippitz/teca/main/res/04-Messunsicherheit/workflow_std.png", (:width => 500))

# ╔═╡ bd5bff60-209f-4fe1-adea-a1289dd3a952
md"""
*Schema zur Bestimmung der Messunsicherheit nach GUM, aus JCGM104:2009, dt*
"""

# ╔═╡ 4d08ccd2-0ce3-4466-a0d2-8806d2469de3
md"""
Als erstes betrachten wir das Verfahren, mit dem nach GUM die
Messunsicherheit eines Ergebnisses aus den Standard-Abweichungen der
Eingangswerte berechnet wird. Dies ist sehr nahe an der traditionellen
Fehlerrechnung. Die Abbildung zeigt ein Schema dieses Verfahrens. Dieses
Verfahren wird dann in den folgenden Abschnitten durch Einführung des
Überdeckungsintervalls und Verallgemeinerung auf andere
Wahrscheinlichkeitsverteilungen als die Normalverteilung erweitert.
"""

# ╔═╡ f32c0f08-4425-4ae3-ae39-77950a42d9ba
md"""
## Messfunktion
"""

# ╔═╡ 90d83d12-3ba7-4158-9ebb-53db69477c30
md"""
Selten interessiert der gemessene Wert direkt, sondern verschiedene
gemessene Werte sollen zu einem Ausgangswert verknüpft werden. Man
bestimmt beispielsweise Masse und Geschwindigkeit, um daraus die
kinetische Energie zu berechnen. Diesen Zusammenhang zwischen den
Eingangswerten $X_i$ und dem Ausgangswert $Y$ beschriebt die
Messfunktion $$Y = f(X_1, ... , X_n) \quad.$$ Dabei bezeichnen große
Buchstaben jeweils den 'wahren', idealen Wert, der nie gemessen sondern
immer nur geschätzt werden kann. Die Messfunktion $f$ beruht immer
direkt auf den gemessenen Größen, nicht auf Zwischenergebnissen, da nur
so berücksichtigt werden kann, wenn eine Messung an verschiedenen
Stellen der Funktion eingeht, und so ihre Fehler korreliert sind. Auch
umfasst die Messfunktion nicht nur den idealen, 'Lehrbuch-artigen'
Zusammenhang zwischen Messgrößen und Ausgangswert, sondern auch alle
Korrekturen, die notwendig sind, um systematische Fehler zu beseitigen.
Im Beispiel der kinetischen Energie wäre dies also nicht
```math
E = \frac{1}{2} \, m \, v^2 \quad \quad \text{(kleine Buchstaben hier aus Gewohnheit)}
```
sondern beispielsweise
```math
E = \frac{1}{2} \, \alpha  \, (m  - m_0) \, \left( \frac{ \beta \, (L - L_0)}{\gamma \, (t_1 - t_2)} \right)^2
\quad .
```
Dabei berücksichtigen die Faktoren $\alpha, \beta, \gamma$ die
Abweichung in der Kalibration der Masse-, Länge- und Zeit-Messung, sowie
$m_0$ und $x_0$ die Abweichung der Nullpunktslage.
"""

# ╔═╡ 7816bc0a-0841-4c8a-8d80-68a4c98b46a4
md"""
## Schätzwerte der Eingangswerte

Die 'wahren' Eingangswerte $X_i$ der Messfunktion kennt man nie. Man
kann sich aber Schätzwerte $x_i$ dieser Werte beschaffen. Notfalls ist
der Wert der einzigen Messung der Schätzwert $x_i$. Wenn eine Messung
mehrmals unter identischen Bedingungen wiederholt durchgeführt werden
kann, dann ist der Mittelwert aus diesem Datensatz ein guter Schätzwert.
Auch schriftliche Aufzeichnungen wie Datenblätter liefern Schätzwerte
der Eingangswerte. Die oben genannten Faktoren $\alpha, \beta, \gamma$
zur Abweichung in der Kalibration werden wohl typischerweise mit dem
Wert Eins geschätzt, falls nicht ein Gerät fehl-kalibriert ist.
"""

# ╔═╡ 86db8681-d992-46d3-9e8d-5f9f1e8f3740
md"""
## Schätzwert des Ergebnisses

Den Schätzwert des Ergebnisses $y$ erhält man, in dem man die
Schätzwerte der Eingangswerte $x_i$ in die Messfunktion einsetzt
```math
y = f(x_1, ... , x_n) \quad .
```
Der hier beschriebe Formalismus
behandelt also nur ein Ergebnis pro Experiment. Wenn zwei oder mehr
Ergebnisse aus einem gemeinsamen Datensatz gewonnen werden sollen, dann
würde auch die Kovarianz dieser Ergebnisse interessieren. Dies ist ein
fortgeschritteneres Thema, ebenso wie die hier nicht berücksichtige
Kovarianzen zwischen den Eingangswerten $x_i$.
"""

# ╔═╡ 9fb5ee72-ad5e-41c2-a5ad-36f4ebaab0dd
md"""
## Standard-Messunsicherheit der Eingangswerte

Die Standard-Messunsicherheit $u(x_i)$ eines Eingangswerte $x_i$ ist die
Standard-Abweichung seiner Wahrscheinlichkeitsverteilung. In den letzten Kapiteln hatten wir das mit $\sigma_x$ bezeichnet. Man muss also
durch Messen (Typ A) oder andere Quellen (Typ B) die
Wahrscheinlichkeitsverteilung bestimmen und daraus dann die
Standard-Abweichung.
"""

# ╔═╡ aa1542f5-4714-4ba7-a1aa-6655aae865f5
md"""
##### Typ A: Wahrscheinlichkeitsverteilung messen
Unsicherheiten vom Typ A werden durch statistische Methoden ermittelt.
Beispielsweise wird eine Messung wiederholt durchgeführt. Als Wert des
Größe kann dann der Mittelwert dieser Messungen dienen, als Unsicherheit
die Standardabweichung der Einzelmessung oder des Mittelwerts.
Aufwändigere Auswerteverfahren sind denkbar, beispielsweise um eine
darunter liegende Drift zu bereinigen oder eine Größe und deren
Unsicherheit per Regression zu bestimmen. Zentral sind hier aber die
statistischen Methoden, die Auswertung eines Datensatzes.
"""

# ╔═╡ 85384832-b3be-4596-81ed-ad1c1789495f
md"""
Wiederholte, unabhängige Messungen $x_{i,k}$ bei ansonsten konstanten
Bedingungen liefern die Wahrscheinlichkeitsverteilung und somit $u(x_i)$
```math
u(x_i) = \sqrt{\frac{1}{n -1}  \, \sum_{k= 1}^{n} \left( x_{i,k} - \bar{x_i} \right)^2} 
\quad \text{mit} \quad 
\bar{x_i}= \frac{1}{n}  \, \sum_{k= 1}^{n}  x_{i,k}
```
Ebenso liefert die
lineare Regression oder andere Methoden der kleinsten Quadrate eine
Standard-Abweichung und somit die Messunsicherheit.
"""

# ╔═╡ 982de6ca-876c-43a7-9a01-683255ae5770
md"""
##### Typ B: Wahrscheinlichkeitsverteilung aus anderen Quellen
Unsicherheiten vom Typ B sind nicht über statistische Methoden
zugänglich. Beispiele sind die endliche Auflösung einer Waage oder die
tabellierte Messunsicherheit eines Multimeters. In diesen Fällen
bestimmt man die Spannung über einem Widerstand eben nicht mit 10
verschiedenen Multimetern und benutzt dann Statistik, um Aussagen zu
treffen, sondern man benutzt aufgeschriebene, dokumentierte Angaben zur
Unsicherheit. Diese Art Unsicherheit beschreibt nicht das Ergebnis von
Abzähl-Prozessen, sondern unser Nicht-Wissen über den 'wahren' Wert.
Natürlich liegt dieser aufgeschriebenen Unsicherheit ein Messprozess,
eine Kalibration zu grunde, die aber nicht von uns, sondern vom
Hersteller durchgeführt wurde. Das Erstellen des Datenblatts durch den
Hersteller verwandelt also Typ A Unsicherheiten in Typ B Unsicherheiten.
Das Ziel des GUM ist, dies so zu gestalten, dass beide Arten von
Unsicherheiten später wieder miteinander verrechnet werden können.

Typische andere Quellen sind Datenblätter, Kalibrationsdokumente, aber
auch Fachkenntnis. Aus diesen wird dann die Standard-Messunsicherheit
berechnet.
"""

# ╔═╡ b6c0233f-1f1d-4908-b653-3f8811b099bb
md"""
Idealerweise ist die vollständige **Wahrscheinlichkeitsverteilung
angegeben**, die der Hersteller eines Geräts sicherlich im
Kalibrationsprozess einmal ermittelt hat. In diesem Fall berechnen wir
die Standard-Messunsicherheit als Standard-Abweichung dieser Verteilung.
"""

# ╔═╡ 75e6cc50-f628-4034-b071-b948d9a71f01
md"""
Das **Überdeckungsintervall** $[-a, a]$ (auch Konfidenzintervall) gibt einen Bereich an, in dem der
'wahre' Wert mit angegebener Wahrscheinlichkeit (meist 95%) zu finden
ist (siehe letztes Kapitel).
Hier ermitteln wir daraus die Standard-Messunsicherheit, indem wir eine
Normalverteilung annehmen. Im Fall eines 95%-Intervalls ($2 \sigma$)
beträgt sie $u = a /2$.
"""

# ╔═╡ fc4ffcb4-5bcc-44d2-a9ef-abeb0b83b45d
md"""
Bei manchen Geräten, beispielsweise Multimetern, ist eine **Toleranz** in
der Form $a = n$ digits $+ x$% des Vollausschlags angegeben. Der 'wahre'
Wert sollte also in einem Intervall der Breite $[-a, a]$ liegen. Solch
eine rechteckige Verteilung hat die Standard-Abweichung
$u = a / \sqrt{3}$.
"""

# ╔═╡ a15f1cf4-652b-495a-bf32-2bfcea969e69
md"""
**Ablesen digitaler Anzeigen:**
Selbst wenn keine Toleranz angegeben ist, so gilt doch mindestens
$a = 0.5$ digits, da keine Aussage über nicht dargestellte Stellen
gemacht werden kann. Somit wird hier ebenfalls $u = a / \sqrt{3}$.
"""

# ╔═╡ 8b8553c2-42c0-4bad-a133-f9b88506e827
md"""
**Fachkenntnis:**
Das Zählen einzelner Ereignisse, beispielsweise die Anzahl Photonen in
einem Lichtstrahl, liefert oft eine Poisson-Verteilung. Bei einem
Mittelwert von $\lambda$ ist in diesem Fall die
Standard-Messunsicherheit $u = \sqrt{\lambda}$.
"""

# ╔═╡ 28ae896d-c7a4-40a6-b620-3d14e9a171db
md"""
##### Kombination von Typ A und Typ B

Man sollte auch prüfe, ob nicht beide Quellen A und B zur
Messunsicherheit beitragen. Wenn beispielsweise die Standard-Abweichung
aus mehreren Messungen nach Typ A bestimmt wird, jede Einzelmessung aber
eine nicht zu vernachlässigende Messunsicherheit nach Typ B hat. In
diesem Fall addieren sich die Varianzen. Für die
Standard-Messunsicherheit gilt also
```math
u_{\text{gesamt}} = \sqrt{ u_{A}^2  + u_{B}^2 } \quad .
```
Als
Daumenregel kann man annehmen, dass dieser Fall relevant wird, wenn das
Verhältnis der beiden Messunsicherheiten kleiner als drei ist.
"""

# ╔═╡ 423d2616-9ab4-42db-ac03-fb634a3bd2d9
md"""
##### Unsicherheit der Einzelmessung oder des Mittelwerts

An dieser Stelle können wir jetzt auch diskutieren, ob bei der
Messunsicherheit nach Typ A eigentlich die Unsicherheit der
Einzelmessung $u_{\text{einzel}}$ oder die des Mittelwerts aus $n$
Messungen, also $u_{\text{mittel}} = u_{\text{einzel}} / \sqrt{n}$,
relevant ist.

Mit der Reduktion der Messunsicherheit über Mittelwertbildung muss man
sehr vorsichtig sein. Sie verlangt, dass alle einzelnen Messungen
unabhängig voneinander sind. Dies ist beispielsweise nicht mehr der
Fall, wenn eine Drift die gesamte Messung überlagert, oder die einzelnen
Messungen schneller erfolgte, als die Messbandbreite erlaubt. Selbst im
idealen Fall reduziert die Mittelwertbildung zwar die Unsicherheit nach
Typ A, aber nicht die nach Typ B, so dass irgendwann Typ B überwiegt.
"""

# ╔═╡ 665bdacc-7330-4840-a200-c2ae44a9f371
md"""
## Empfindlichkeits-Koeffizienten

Um den Einfluss der Messunsicherheit der Eingangswerte auf den
Ausgangswert zu ermitteln, betrachtet man die partielle Ableitung der
Messfunktion $Y = f(X_1, ... , X_n)$ nach den 'wahren' Werten $X_i$ an
der Stelle des Schätzwerts der Eingangswerte $x_i$. Man entwickelt also
$f$ in einer Taylor-Reihe und bricht diese bereits nach dem ersten Glied
ab. Man linearisiert also $f$ in der Nähe der $x_i$. Die einzelnen
Koeffizienten dieser Taylor-Reihe, die partiellen Ableitungen, werden in
diesem Zusammenhang Empfindlichkeits-Koeffizienten genannt
```math
c_i = \left. \frac{\partial f(X_1, ... , X_n) }{\partial X_i} \right|_{X_1 = x_1, ... , X_n = x_n} \quad .
```
Es ist hilfreich, die Größenordnung der Produkte aus Messunsicherheit
$u(x_i)$ und Empfindlichkeits-Koeffizient $c_i$, also $|c_i| u(x_i)$, zu
betrachten. Im idealen Fall sind diese alle von gleicher Größenordnung.
Wenn nicht, dann lohnt es sich, Arbeit in den größten Term zu
investieren. Entweder um dort die Messunsicherheit $u(x_i)$ zu
reduzieren, oder das Messverfahren so zu ändern, dass sich $f$ so
ändert, dass $|c_i|$ kleiner wird. Der relative Beitrag von
$|c_i| u(x_i)$, also 
```math
\frac{|c_i| u(x_i)}{\sum_k |c_k| u(x_k)}
```
wird
Messunsicherheits-Budget genannt.
"""

# ╔═╡ 7288c7a1-f7e1-4750-b233-ca520737316e
md"""
## Standard-Messunsicherheit des Ergebnisses

Die Standard-Messunsicherheit des Ergebnisses ergibt sich analog der
Gauss'schen Fehlerfortpflanzung zu
```math
u(y) = \sqrt{ \left( c_1 u(x_1) \right)^2  + ... +  \left( c_n u(x_n) \right)^2    }
 \quad .
```
"""

# ╔═╡ 04bde4a4-242d-4640-b950-9e3fa5b1536e
md"""
# Überdeckungsintervall

Bis hier hin haben wir einen Schätzwert für den
Ausgangswert $y$ der Messung sowie für seine Standard-Messunsicherheit
$u(y)$ ermittelt. Die Frage ist jetzt, welche Aussage wir über den
'wahren' Wert $Y$ machen können. Das Ziel ist es, ein Intervall
anzugeben, in dem der 'wahre' Wert $Y$ mit einer bestimmten
Wahrscheinlichkeit liegt. Dieses Intervall wird Überdeckungsintervall oder Konfidenzintervall
genannt.
"""

# ╔═╡ 0bdb7433-a309-4448-b7ce-5683ddb46a95
Resource("https://raw.githubusercontent.com/MarkusLippitz/teca/main/res/04-Messunsicherheit/workflow_ausf.png", (:width => 500))

# ╔═╡ 235f57fd-c0f9-4dda-a30f-98e3bb64a6ac
md"""
*Schema zur Bestimmung des Überdeckungsintervalls  nach GUM, aus JCGM104:2009, dt. Der linke obere Bereich wurde schon im vorangegangenen Abschnitt besprochen*
"""

# ╔═╡ 276be9a6-95d8-48b6-94bc-d035767d62b5
md"""
Das Problem ist, dass wir insbesondere von der Messunsicherheit $u(y)$
nur einen Schätzwert haben. Dass $y$ nur ein Schätzwert von $Y$ ist,
stellt kein Problem dar, denn wir kennen die
Wahrscheinlichkeitsverteilung des Abstandes $y - Y$. Diese Abstand ist
normalverteilt
```math
\frac{y - Y}{\sigma  /\sqrt{n}} = \mathcal{N}(0,1) \quad .
```
Dies
setzt aber voraus, dass man den 'wahren' Wert der Standardabweichung
$\sigma$ kennt. $n$ bezeichnet hier die Anzahl der Werte, aus denen $y$
ermittelt wurde.
"""

# ╔═╡ 68dca4d6-634e-4a6f-8e84-1d66d7df2775
md"""
Falls statt dem 'wahren' Wert $\sigma$ nur der Schätzwert $u(y)$ bekannt
ist, dann folgt der normierte Abstand $y-Y$ einer Student'sche
t-Verteilung, die im Grenzwert großer $n$ in die Normalverteilung
übergeht 
```math
\frac{y - Y}{u(y)  /\sqrt{n}} = t_n  \quad 
 \overset{n \rightarrow \infty}{\longrightarrow} \quad
 \mathcal{N}(0,1) \quad .
```
Die Student'sche t-Verteilung besitzt die
Wahrscheinlichkeitsdichte
```math
t_n(x) = \alpha \left(1 + \frac{x^2}{n} \right)^{- (n+1)/2}
```
wobei
der Faktor $\alpha$ die Normierung sicherstellt. Für kleine $n$ ist sie breiter als die Normalverteilung. Diese Verteilung wird
es uns ermöglichen, ein Überdeckungsintervall anzugeben.

"""

# ╔═╡ df9d5a69-6e16-46af-8233-1e91461f321b
let
	x = range(-5, 5; length=100)
	plot(x,pdf.(TDist(1),x), label="n=1")
	plot!(x,pdf.(TDist(3),x),  label="n=3")
	plot!(x,pdf.(TDist(10),x),  label="n=10")
	plot!(x,pdf.(TDist(100),x), xlabel="x", ylabel="WK Dichte", label="n=100", title="Student'sche t-Verteilung")
	scatter!(x,pdf.(Normal(),x),  label="normal", markersize=2)
end

# ╔═╡ c5daeba2-6d0a-46af-a238-970fe54eb9b3
md"""

## Freiheitsgrade

Der Freiheitsgrad $\nu_i$ beschreibt die Anzahl an Einzelmessungen, die
zu einem Schätzwert $x_i$ eines Eingangswerts $X_i$ beigetragen haben.
Er ist ein Maß für das Vertrauen in die Schätzung der
Standard-Messunsicherheit $u(x_i)$.
"""

# ╔═╡ a97057a0-acad-487e-8ac9-8cc0701350bc
md"""
Für Messunsicherheiten vom *Typ A* gilt
```math
\nu_i = \text{<Anzahl Messungen>} - \text{<Anzahl ermittelte Parameter>}  \quad .
```
Wenn aus $n$ Messungen der Schätzwert $x_i$ als Mittelwert berechnet
wurde, so ist $\nu_i = n -1$. Damit ist $\nu_i = 0$, falls nur ein Wert
gemessen wurde. Bei einer lineare Regression werden beispielsweise
Steigung und Achsenabschnitt ermittelt, also zwei
Parameter bestimmt. Wenn nun $x_i$ aus der Steigung bestimmt wird, so
ist $\nu_i = n -2$, da die Information aus einer weiteren Messung schon
für den Achsenabschnitt verwendet wurde.
"""

# ╔═╡ 289bf2e3-545a-4f46-9a33-eb09adc8839f
md"""
Für Messunsicherheiten vom *Typ B* ist manchmal die mit dieser
Unsicherheit verknüpften Anzahl an Freiheitsgraden $\nu$ ebenfalls
tabelliert. Wenn das nicht der Fall ist, dann lässt sich Überlegungen
zur Varianz der Varianz einer Normalverteilung folgende Beziehung
herleiten
```math
\nu_i = \frac{1}{2} \left( \frac{\Delta u(x_i)}{u(x_i)} \right)^{-2}
```
wobei $\Delta u(x_i)$ die Unsicherheit in der Unsicherheit des
Eingangswerts $x_i$ bezeichnet. $\Delta u(x_i)$ ergibt sich
beispielsweise aus der Anzahl der dargestellten Stellen bei tabellierten
$u(x_i)$. Oder man nimmt an, dass das bei einem Multimeter angegeben
Toleranz-Intervall so groß ist, dass außerhalb liegende Werte praktisch
unmöglich sind. In diesem Fall ist die die Unsicherheit exakt bekannt,
damit $\Delta u(x_i) = 0$ und $\nu_i = \infty$. Dies stellt kein Problem
dar.
"""

# ╔═╡ b5a0ad91-b02f-4efa-9f5e-9ed9c4562235
md"""
## Effektive Freiheitsgrade

Wir kennen nun die Freiheitsgrade $\nu_i$ der Eingangsgrößen. Wir
benötigen aber die Freiheitsgrade der Ausgangsgröße bzw. ihrer
Messunsicherheit, um den Faktor in der Student'schen t-Verteilung einzusetzen. Die **Welch-Satterthwaite-Gleichung** liefert eine
Abschätzung für die effektive Anzahl an Freiheitsgraden
$\nu_{\text{eff}}$, die der Messunsicherheit $u(y)$ des Ausgangsgröße
$y$ zugeordnet werden kann:
```math
\nu_{\text{eff}} = \frac{u(y)^4}{\sum_{i=1}^n \frac{c_i^4 \, u(x_i)^4}{\nu_i}}
\ll \sum_{i=1}^n \nu_i
 \quad  .
```
Dabei wird $\nu_{\text{eff}}$ auf die nächste ganze Zahl
abgerundet. Wenn eine Eingangsgröße $x_k$ entweder eine große
Standard-Messunsicherheit $c_k \, u(x_k)$ besitzt oder eine kleine Anzahl
Freiheitsgrade $\nu_k$ oder beides, dann dominiert diese Größe die
Anzahl der effektiven Freiheitsgrade $\nu_{\text{eff}} \approx \nu_k$.
"""

# ╔═╡ 8f9effb9-3a85-4137-81ca-dbf67d11ad83
md"""
## Überdeckungswahrscheinlichkeit

Man muss sich für eine Wahrscheinlichkeit entscheiden, mit der der
'wahre' Wert in dem Überdeckungsintervall liegen soll. Typische Werte
sind verknüpft mit den Integralen über die Normalverteilung innerhalb
einer $\pm k \cdot \sigma$ Umgebung, oder gerundete Werte davon. Am
häufigsten findet sich das 95% Intervall.


| $k$ |  $P$    |  |   $P$  | $k$|
|:--- | :-------|:--- |-----: | :----- |
| 1   |  68.27    |  | 66  |  0.954 | 
|  2  |   95.45    | | 95  |  1.960 |
|  3  |   99.73    |  | 99  |  2.576 |

*Wahrscheinlichkeit $P$ in Prozent, bei einer Normalverteilung
  innerhalb einer $k \sigma$ Umgebung zu liegen. Das 95% Intervall mit
  $k=1.96$ ist am weitesten verbreitet.*


"""

# ╔═╡ 5338fe8c-3358-4d93-b407-ba0a3e063d31
let
	k = (1,2,3)
	P = [cdf.(Normal(), s) - cdf.(Normal(), -s) for s in k]
end

# ╔═╡ 95b1b54d-cabb-486e-a6f8-215bc18c095b
let
	p = (66, 95, 99)
	k = [-quantile.(Normal(), (1 - q/100)/2)  for q in p]
end

# ╔═╡ 2466be2c-590f-428e-bdb1-5ba1c389adf7
md"""
## Erweiterungsfaktor

Der Erweiterungsfaktor $k$ bestimmt die Grenzen des
Überdeckungsintervalls, in dem der 'wahre' Wert mit der gewünschten
Wahrscheinlichkeit zu finden ist. Das Intervall hat dann die Form
$[y - k \cdot u(y), y + k \cdot u(y)]$. Der Wert von $k$ ergibt sich aus
dem Integral über die Student'sche t-Verteilung, so dass
```math
\int_{- k}^{+ k} t_\nu(x) \, dx = \text{gewünschte Wahrscheinlichkeit} \quad .
```
Diese Wert hängt natürlich von der Anzahl $\nu_{\text{eff}}$ der
effektiven Freiheitsgrade ab, die in die Messung eingeflossen sind. Für
sehr großes $\nu_{\text{eff}}$ nimmt $k$ die bekannten Werte aus der
Normalverteilung an. Hier ein paar Werte für $k$ bei einem 95%-Intervall
"""

# ╔═╡ b45db50f-e336-4552-9003-0bb31ac56cdb
let
	nu = (1, 2, 3, 4, 5, 10, 20, 1e10)
	p = 95
	k = [-quantile(TDist(n), (1 - p/100)/2)  for n in nu]
end

# ╔═╡ a366a4c2-71c3-4999-8bd5-782870fbafa9
md"""
## Erweiterte Messunsicherheit

Die erweiterte Messunsicherheit ist die Standard-Messunsicherheit $u(y)$
multipliziert mit dem Erweiterungsfaktor $k$
$$U = k \cdot u(y) \quad .$$
"""

# ╔═╡ 4ff70a42-a9c4-45de-911c-9f06057d8286
md"""
## Überdeckungsintervall

Das Überdeckungsintervall beträgt $[y \pm U]$ =
$[y - k \cdot u(y), y + k \cdot u(y)]$. Der 'wahre' Werte $Y$ liegt in
diesem Intervall mit der oben festgelegten Wahrscheinlichkeit.
"""

# ╔═╡ a3e5d870-f11d-4b9b-a384-d055b6df8232
md"""
# Andere Wahrscheinlichkeitsverteilungen und Monte-Carlo-Simulationen

coming soon \...
see [MonteCarloMeasurements.jl](https://baggepinnen.github.io/MonteCarloMeasurements.jl/stable/)
"""

# ╔═╡ 8de57df0-5d80-4fa3-be75-ccf03db5a21d
TableOfContents(title="Inhalt")

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Distributions = "31c24e10-a181-5473-b8eb-7969acd0382f"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
Distributions = "~0.25.53"
Plots = "~1.27.5"
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

[[deps.Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "af92965fb30777147966f58acb05da51c5616b5f"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.3"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.Calculus]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f641eb0a4f00c343bbc32346e1217b86f3ce9dad"
uuid = "49dc2e85-a5d0-5ad3-a950-438e2897f1b9"
version = "0.5.1"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "9950387274246d08af38f6eef8cb5480862a435f"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.14.0"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "bf98fa45a0a4cee295de98d4c1462be26345b9a1"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.2"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "12fc73e5e0af68ad3137b886e3f7c1eacfca2640"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.17.1"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[deps.Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "96b0bc6c52df76506efc8a441c6cf1adcb1babc4"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.42.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[deps.DataAPI]]
git-tree-sha1 = "cc70b17275652eb47bc9e5f81635981f13cea5c8"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.9.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3daef5523dd2e769dad2365274f760ff5f282c7d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.11"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.DensityInterface]]
deps = ["InverseFunctions", "Test"]
git-tree-sha1 = "80c3e8639e3353e5d2912fb3a1916b8455e2494b"
uuid = "b429d917-457f-4dbc-8f4c-0cc954292b1d"
version = "0.4.0"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Distributions]]
deps = ["ChainRulesCore", "DensityInterface", "FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SparseArrays", "SpecialFunctions", "Statistics", "StatsBase", "StatsFuns", "Test"]
git-tree-sha1 = "5a4168170ede913a2cd679e53c2123cb4b889795"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.53"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "b19534d1895d702889b219c382a6e18010797f0b"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.6"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.DualNumbers]]
deps = ["Calculus", "NaNMath", "SpecialFunctions"]
git-tree-sha1 = "5837a837389fccf076445fce071c8ddaea35a566"
uuid = "fa6b7ba4-c1ee-5f82-b5fc-ecf0adba8f74"
version = "0.6.8"

[[deps.EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3f3a2501fa7236e9b911e0f7a588c657e822bb6d"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.3+0"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bad72f730e9e91c08d9427d5e8db95478a3c323d"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.4.8+0"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "Pkg", "Zlib_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "d8a578692e3077ac998b50c0217dfd67f21d1e5f"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.0+0"

[[deps.FillArrays]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "Statistics"]
git-tree-sha1 = "246621d23d1f43e3b9c368bf3b72b2331a27c286"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "0.13.2"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "51d2dfe8e590fbd74e7a842cf6d13d8a2f45dc01"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.6+0"

[[deps.GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "RelocatableFolders", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "af237c08bda486b74318c8070adb96efa6952530"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.64.2"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "cd6efcf9dc746b06709df14e462f0a3fe0786b1e"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.64.2+0"

[[deps.GeometryBasics]]
deps = ["EarCut_jll", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "83ea630384a13fc4f002b77690bc0afeb4255ac9"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.2"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "a32d672ac2c967f3deb8a81d828afc739c838a06"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.68.3+2"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "0fa77022fe4b511826b39c894c90daf5fce3334a"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.17"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.HypergeometricFunctions]]
deps = ["DualNumbers", "LinearAlgebra", "SpecialFunctions", "Test"]
git-tree-sha1 = "65e4589030ef3c44d3b90bdc5aac462b4bb05567"
uuid = "34004b35-14d8-5ef3-9330-4cdb6864b03a"
version = "0.3.8"

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

[[deps.IniFile]]
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "91b5dcf362c5add98049e6c29ee756910b03051d"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.3"

[[deps.IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[deps.IterTools]]
git-tree-sha1 = "fa6287a4469f5e048d763df38279ee729fbd44e5"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.4.0"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b53380851c6e6664204efb2e62cd24fa5c47e4ba"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.2+0"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "Printf", "Requires"]
git-tree-sha1 = "6f14549f7760d84b2db7a9b10b88cd3cc3025730"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.14"

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

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "7739f837d6447403596a75d19ed01fd08d6f56bf"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.3.0+3"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "c9551dd26e31ab17b86cbd00c2ede019c08758eb"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.3.0+1"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "58f25e56b706f95125dcb796f39e1fb01d913a71"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.10"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "Random", "Sockets"]
git-tree-sha1 = "1c38e51c3d08ef2278062ebceade0e46cefc96fe"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.0.3"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NaNMath]]
git-tree-sha1 = "737a5957f387b17e74d4ad2f440eb330b39a62c5"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.0"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ab05aa4cc89736e95915b01e7279e61b1bfe33b8"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.14+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.PCRE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b2a7af664e098055a7529ad1a900ded962bca488"
uuid = "2f80f16e-611a-54ab-bc61-aa92de5b98fc"
version = "8.44.0+0"

[[deps.PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "e8185b83b9fc56eb6456200e873ce598ebc7f262"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.7"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "621f4f3b4977325b9128d5fae7a8b4829a0c2222"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.2.4"

[[deps.Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "8162b2f8547bc23876edd0c5181b27702ae58dce"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.0.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "bb16469fd5224100e422f0b027d26c5a25de1200"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.2.0"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "88ee01b02fba3c771ac4dce0dfc4ecf0cb6fb772"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.27.5"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "670e559e5c8e191ded66fa9ea89c97f10376bb4c"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.38"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "d3538e7f8a790dc8903519090857ef8e1283eecd"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.5"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "c6c0f690d0cc7caddb74cef7aa847b824a16b256"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+1"

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "78aadffb3efd2155af139781b8a8df1ef279ea39"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.4.2"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RecipesBase]]
git-tree-sha1 = "6bf3f380ff52ce0832ddd3a2a7b9538ed1bcca7d"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.2.1"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase"]
git-tree-sha1 = "dc1e451e15d90347a7decc4221842a022b011714"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.5.2"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "cdbd3b1338c72ce29d9584fdbe9e9b70eeb5adca"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "0.1.3"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "bf3188feca147ce108c76ad82c2792c57abe7b1f"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.7.0"

[[deps.Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "68db32dff12bb6127bac73c209881191bf0efbb7"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.3.0+0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "5ba658aeecaaf96923dce0da9e703bd1fe7666f9"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.1.4"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "4f6ec5d99a28e1a749559ef7dd518663c5eca3d5"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.4.3"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "c3d8ba7f3fa0625b062b82853a7d5229cb728b6b"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.2.1"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "8977b17906b0a1cc74ab2e3a05faa16cf08a8291"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.16"

[[deps.StatsFuns]]
deps = ["ChainRulesCore", "HypergeometricFunctions", "InverseFunctions", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "72e6abd6fc9ef0fa62a159713c83b7637a14b2b8"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "0.9.17"

[[deps.StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "57617b34fa34f91d536eb265df67c2d4519b8b98"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.5"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "5ce79ce186cc678bbb5c5681ca3379d1ddae11a1"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.7.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unzip]]
git-tree-sha1 = "34db80951901073501137bdbc3d5a8e7bbd06670"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.1.2"

[[deps.Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "1acf5bdf07aa0907e0a37d3718bb88d4b687b74a"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.12+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e45044cd873ded54b6a5bac0eb5c971392cf1927"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.2+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "ece2350174195bb31de1a63bea3a41ae1aa593b6"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "0.9.1+5"
"""

# ╔═╡ Cell order:
# ╟─f5450eab-0f9f-4b7f-9b80-992d3c553ba9
# ╟─82598f44-f996-4be0-a420-ef7f6748d1d7
# ╟─2b3ac165-b309-4f18-b28b-18a5aa2c529a
# ╟─194d4005-0890-4dbb-907f-ec7aac5c5fc7
# ╟─503d28ba-ec06-47c6-bd7c-13450e83e70c
# ╟─4cc2fdf9-f03f-4e3f-9f10-a1115c884ff5
# ╟─c1c96736-4e97-4efa-915c-f9933572c137
# ╟─b12ba649-965e-4778-8a8b-5c52b7bb7319
# ╟─1f606df6-ff05-442f-b163-5d6186ec49af
# ╟─db28dc51-f417-459e-a0eb-b93dced3cc25
# ╟─13858297-cad0-42a6-aa3e-1b25f4811434
# ╟─55150760-9de7-449f-96b3-ee5275c30378
# ╟─f9182cc9-95f0-43b7-b302-bc508739bce7
# ╟─bd5bff60-209f-4fe1-adea-a1289dd3a952
# ╟─4d08ccd2-0ce3-4466-a0d2-8806d2469de3
# ╟─f32c0f08-4425-4ae3-ae39-77950a42d9ba
# ╟─90d83d12-3ba7-4158-9ebb-53db69477c30
# ╟─7816bc0a-0841-4c8a-8d80-68a4c98b46a4
# ╟─86db8681-d992-46d3-9e8d-5f9f1e8f3740
# ╟─9fb5ee72-ad5e-41c2-a5ad-36f4ebaab0dd
# ╟─aa1542f5-4714-4ba7-a1aa-6655aae865f5
# ╟─85384832-b3be-4596-81ed-ad1c1789495f
# ╟─982de6ca-876c-43a7-9a01-683255ae5770
# ╟─b6c0233f-1f1d-4908-b653-3f8811b099bb
# ╟─75e6cc50-f628-4034-b071-b948d9a71f01
# ╟─fc4ffcb4-5bcc-44d2-a9ef-abeb0b83b45d
# ╟─a15f1cf4-652b-495a-bf32-2bfcea969e69
# ╟─8b8553c2-42c0-4bad-a133-f9b88506e827
# ╟─28ae896d-c7a4-40a6-b620-3d14e9a171db
# ╟─423d2616-9ab4-42db-ac03-fb634a3bd2d9
# ╟─665bdacc-7330-4840-a200-c2ae44a9f371
# ╟─7288c7a1-f7e1-4750-b233-ca520737316e
# ╟─04bde4a4-242d-4640-b950-9e3fa5b1536e
# ╟─0bdb7433-a309-4448-b7ce-5683ddb46a95
# ╟─235f57fd-c0f9-4dda-a30f-98e3bb64a6ac
# ╟─276be9a6-95d8-48b6-94bc-d035767d62b5
# ╟─68dca4d6-634e-4a6f-8e84-1d66d7df2775
# ╠═df9d5a69-6e16-46af-8233-1e91461f321b
# ╠═49b9386e-2eb0-41e5-97a9-1da882abd4f6
# ╟─c5daeba2-6d0a-46af-a238-970fe54eb9b3
# ╟─a97057a0-acad-487e-8ac9-8cc0701350bc
# ╟─289bf2e3-545a-4f46-9a33-eb09adc8839f
# ╟─b5a0ad91-b02f-4efa-9f5e-9ed9c4562235
# ╟─8f9effb9-3a85-4137-81ca-dbf67d11ad83
# ╠═5338fe8c-3358-4d93-b407-ba0a3e063d31
# ╠═95b1b54d-cabb-486e-a6f8-215bc18c095b
# ╟─2466be2c-590f-428e-bdb1-5ba1c389adf7
# ╠═b45db50f-e336-4552-9003-0bb31ac56cdb
# ╟─a366a4c2-71c3-4999-8bd5-782870fbafa9
# ╟─4ff70a42-a9c4-45de-911c-9f06057d8286
# ╟─a3e5d870-f11d-4b9b-a384-d055b6df8232
# ╠═2b794068-00e4-47b3-b082-7fba3c3adb9e
# ╠═8de57df0-5d80-4fa3-be75-ccf03db5a21d
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
