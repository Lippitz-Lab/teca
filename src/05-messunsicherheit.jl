### A Pluto.jl notebook ###
# v0.19.26

using Markdown
using InteractiveUtils

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
Measurement' (GUM)** des [*Bureau International des Poids et Mesures*](https://www.bipm.org/en/committees/jc/jcgm/publications)
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

# ╔═╡ 49b9386e-2eb0-41e5-97a9-1da882abd4f6
using Distributions, Plots

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

# ╔═╡ dce58f00-78bf-424e-8f9f-35306266f0f3
md"""
[Uncertainty machine](https://www.nist.gov/itl/sed/topic-areas/measurement-uncertainty) des NIST
"""

# ╔═╡ 2b794068-00e4-47b3-b082-7fba3c3adb9e
using PlutoUI

# ╔═╡ 8de57df0-5d80-4fa3-be75-ccf03db5a21d
TableOfContents(title="Inhalt")

# ╔═╡ Cell order:
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
# ╟─dce58f00-78bf-424e-8f9f-35306266f0f3
# ╠═2b794068-00e4-47b3-b082-7fba3c3adb9e
# ╠═8de57df0-5d80-4fa3-be75-ccf03db5a21d
