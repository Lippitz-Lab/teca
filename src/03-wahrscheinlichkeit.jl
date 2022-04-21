### A Pluto.jl notebook ###
# v0.19.0

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

# ╔═╡ bc02dd02-f593-4c9d-a4e2-955546bb0a2a
using Random

# ╔═╡ 48be7ee0-179a-4bdf-8f15-660f31c17111
using Plots, StatsBase

# ╔═╡ 20aaac5b-3b6d-4448-89c1-00485bc4a129
using Distributions

# ╔═╡ 415d2c7d-b4a3-4565-99ed-9b04e6569b73
using PlutoUI,  LinearAlgebra

# ╔═╡ f5450eab-0f9f-4b7f-9b80-992d3c553ba9
# DO NOT MODIFY, will be updated by update_navbar.jl
HTML("    <nav >\n    Vorbereitungen:\n\n<a class=\"sidebar-nav-item\" href=\"index.html\"><em>Intro</em></a> / \n<a class=\"sidebar-nav-item\" href=\"software.html\"><em>Software</em></a> / \n<a class=\"sidebar-nav-item\" href=\"01-basic_syntax.html\"><em>Julia Basics</em></a> / \n\n<br>\nStatistik:\n\n<a class=\"sidebar-nav-item\" href=\"02-beschreibende-statistik.html\"><em>Beschreibende Statistik</em></a> / \n<a class=\"sidebar-nav-item\" href=\"03-wahrscheinlichkeit.html\"><em>Wahrscheinlichkeit</em></a> / \n<a class=\"sidebar-nav-item\" href=\"04-schaetzung.html\"><em>Schätzung</em></a> / \n<a class=\"sidebar-nav-item\" href=\"05-messunsicherheit.html\"><em>Messunsicherheit</em></a> / \n\n<br>\nFourier-Transformation:\n\n<a class=\"sidebar-nav-item\" href=\"06-Fourier-Transformation.html\"><em>Fourier-Transformation</em></a> / \n<a class=\"sidebar-nav-item\" href=\"07-Frequenzraum.html\"><em>Frequenzraum</em></a> / \n<a class=\"sidebar-nav-item\" href=\"08-Filter.html\"><em>Filter</em></a> / \n\n<br>\nMesstechnik:\n\n<a class=\"sidebar-nav-item\" href=\"09-Rauschen.html\"><em>Rauschen</em></a> / \n<a class=\"sidebar-nav-item\" href=\"10-Detektoren.html\"><em>Detektoren</em></a> / \n<a class=\"sidebar-nav-item\" href=\"11-Lock-In.html\"><em>Lock-In-Verstärker</em></a> / \n<a class=\"sidebar-nav-item\" href=\"12-heterodyn.html\"><em>Heterodyn-Detektion</em></a> / \n\n<br>\n\n\n    </nav>\n\t")

# ╔═╡ e19a8fb0-1814-4b09-bb64-2fa1df689659
html"""<div>
<font size="7"><b>Wahrscheinlichkeit</b></font> </div>

<div><font size="5"> Markus Lippitz </font> </div>
<div><font size="5"> 25. März 2022 </font> </div>
"""

# ╔═╡ 4a5520a2-bf90-40da-8b64-dea62aeeb5c7
md"""
**Ziele** Sie können eine Sequenz von 'Zufallszahlen' in Julia
 *erzeugen*, die einer gegebenen Verteilung genügen.

-   diskrete Verteilungen: Binomial, Poisson

-   stetige Verteilungen: Normal, Log-Normal

-   zentraler Grenzwertsatz
"""

# ╔═╡ b8b5eeac-5934-4085-9202-9b1d2ad40208
md"""
**Weitere Aufgaben**

-   Erzeugen sie Paare von 'Zufallszahlen', deren 2D Verteilung ein
    Elefant beschreibt. Betrachten sie das Mittel über $N$ dieser Paare.
    Vergleichen sie es mit ihrer Erwartung.
"""

# ╔═╡ 9277a2d9-08b9-4362-83f4-bf9e5fde004c
md"""
**Literatur** Stahel Kap. 5 & 6, Bevington Kap. 2, Meyer Kap.
22--25

"""

# ╔═╡ ba95eeaa-d5f3-4032-ac9b-c28f7e23fc6a
md"""
# Überblick

Im letzten Kapitel haben wir die Stichprobe beschrieben. In diesem Kapitel geht es im die Verteilung, aus der die Stichprobe gezogen wurde. Das letzte Kapitel beschreibt also die Messwerte, dieses die Wirklichkeit. Im nächsten geht es dann darum, wie man von den Messwerten auf die Wirklichkeit kommt ('schätzt'). Die Kennzahlen sind sehr ähnlich. Im folgenden wird ein Hut über die Kennzahlen gesetzt, wenn es um die Stichprobe geht.

| Sichprobe                  | Verteilung (diskret)|  Verteilung (kont.)|
|:----------                 | :--------- | :--------- |
| relative Häufigkeit $r_k$  | Wahrscheinlichkeit $P\left<X=k\right>$ | Wahrscheinlichkeitsdichte $f\left<k\right>$ |
| Mittelwert $\bar{x} = \sum k r_k$  | Erwartungswert $\mathcal{E}\left<X\right> = \mu = \sum k P\left<X=k\right>$| Erwartungswert $\mathcal{E}\left<X\right> = \mu = \int k f\left<k\right> dk$|
| Varianz $\hat{\text{var}} = \frac{n}{n-1}  \sum (k - \bar{x})^2 r_k$| Varianz $\text{var}\left<X\right> = \sum (k - \mu)^2 P\left<X=k\right>$ | Varianz $\text{var}\left<X\right> = \int(k - \mu)^2 f\left<k\right> dk$ |
| Standardabweichung $\hat{\sigma} = \sqrt{\hat{\text{var}}}$ | Standardabweichung $\sigma = \sigma_X = \sqrt{\text{var}}$| Standardabweichung $\sigma = \sigma_X = \sqrt{\text{var}}$|
*gekürzt aus Stahel, Tabelle 5.3.b*

Zwei Punkte sind hierbei relevant: beim Übergang von diskreten zu kontinuierlichen Wahrscheinlichkeitsverteilungen muss man zu einer Wahrscheinlichkeits**dichte** übergehen. Und der (bislang) etwas merkwürdige Faktor $\frac{n}{n-1}$ tritt nur bei der Beschreibung der Stichprobe auf, nicht aber bei der von Verteilungen. Das wird sich im nächsten Kapitel klären.

"""

# ╔═╡ 7c903e39-fb09-4ab0-83e4-1034830f138b
md"""
# Grundbegriffe

Wir müssen zunächst einige Begriffe in Analogie zur Mengenlehre definieren. Für Details siehe Stahel, Kapitel 4.
"""

# ╔═╡ 9490ef1a-cab2-4b81-8ccb-385446d220be
md"""
| Symbol     | Mengenlehre | WK-Rechnung |
|:---------- | :--------- |:------------|
| $\omega$          | Element | Elementarereignis     |
| $A, B, \dots$       |Mengen |  Ereignisse |
| $\Omega$         |Grundmenge | sicheres Ereignis |
| $\emptyset$         |leere Menge | unmögliches Ereignis |
| $A \cup B$         |Vereinigung | $A$ oder $B$ (oder beides)|
| $A \cap B$         |Schnitt-M. | $A$ und $B$  |

*gekürzt aus Stahel, Tabelle 4.2.d*
"""

# ╔═╡ 67457022-5fc6-4ced-9490-9390bf4fa84f
md"""
Wir betrachten Wahrscheinlichkeiten als relative Häufigkeiten von Ereignissen. Das ist die Laplace'sche Definition der Wahrscheinlichkeiten
```math
\text{Wahrscheinlichkeiten} = \frac{\text{Anzahl günstige Fälle}}{\text{Anzahl mögliche Fälle}}
```

"""

# ╔═╡ 0b11c831-a09c-4978-a090-1eeb75fdc194
md"""

Damit ergeben sich für die Wahrscheinlichkeit $P$ einige grundlegende Beziehungen. Die Wahrscheinlichkeit eines Ereignisses kann nicht negativ sei:
```math
P\left<A\right> \ge 0 \quad \text{für alle } A
```
Die Wahrscheinlichkeit, dass irgend was eintritt, ist eins: 
```math
P\left<\Omega\right> = 1
```
 Wahrscheinlichkeiten addieren sich, falls die Ereignisse disjunkt sind:
```math
P\left<A \cup B\right> = P\left<A\right> + P\left<B\right> \quad \text{falls} \quad A \cap B = \emptyset
```
"""

# ╔═╡ 0b64feec-eb2d-479c-9bc5-d7de632730bf
md"""
Daraus folgt
```math
P\left<\emptyset\right> = 0 \quad ; \quad P\left<A\right> \le 1 \quad ; \quad P\left<A^C\right> = 1 - P\left<A\right>
```
"""

# ╔═╡ 50938628-d2c1-4f2f-b4ff-b4017a2b65df
md"""
# Beispiel Würfel

Für einen gewöhnlichen Würfel ist die Grundmenge 
```math
\Omega = \left\{ 1, 2, 3, 4, 5, 6 \right\}
```
Falls $A$ die Menge der gerade Würfen-Augen ist, dann ist $P(A) = 0.5$. 

Die Beobachtung eines Elementarereignisses $\omega$ bzw. das Resultat $X$ von einmal würfeln wird geschrieben als $X = \omega$. Die Variable $X$ nennt man **Zufallsvariable**. Beim Spiel 'Mensch ärgere dich' ist $X=6$ von zentraler Bedeutung, zumindest am Anfang des Spiels. Die Wahrscheinlichkeit davon wird geschrieben als $P(X=6) = 1/6$ bzw. oft auch kurz als $p_6 = 1/6$.
"""

# ╔═╡ 60a9f358-0c4b-4f87-abf0-8e39d7977981
md"""
# Zufallszahlen

Im Computer können wir 'würfeln', indem wir (Pseudo-)Zufallszahlen erzeugen. Diese Zahlen werden deterministisch erzeugt, entsprechen aber in allen Kriterien (beinahe) echtem Zufall.
"""

# ╔═╡ 0ee71dae-b8a5-43d5-995b-be7dbf7c93c6
md"""
In Julia geht das mit
"""

# ╔═╡ f30c68af-2e3f-45dc-a2d5-86edae8ffed1
md"""
Danach bekommt man bei jedem Aufruf eine neue, quasi-zufällige Zahl, beispielsweise im Intervall $(0,1)$
"""

# ╔═╡ 0cc2abe6-503d-4950-b67b-43026aecc5de
rand()

# ╔═╡ 6f394b61-928b-42f6-b955-4ff172aa7ee8
md"""
Probieren Sie einmal aus, obige Zelle mehrmals auszuführen!
"""

# ╔═╡ c846346f-8438-4cd5-ba9a-6afafd1e8473
md"""
Wir können auch die Grundmenge vorgeben. Ein Würfel bekommt man mit
"""

# ╔═╡ ab99ab48-2384-4fa7-94a9-aaf71fb37087
rand( (1,2,3,4,5,6) )

# ╔═╡ 77c5656d-1e6d-499f-8f8c-f65b759fdd79
md"""
100 mal würfeln entspricht
"""

# ╔═╡ 0ac9fb54-fac4-4af8-95d4-2301ec0f5be6
hundert= rand( (1,2,3,4,5,6) , 100)

# ╔═╡ ec2dbc61-97a0-4ab1-ba98-b67e54afff08
plot(StatsBase.fit(Histogram, hundert, range(0,7; step=0.1)),leg=false)

# ╔═╡ 0be5ce70-fe75-48e1-bce9-dda7cbe4c3e0
md"""
Wie man sieht ist der Würfel ein Beispiel für eine diskrete Zufallsvariable, die nur endlich viele Werte annehmen kann. Die Temperatur im letzten Kapitel würde man als kontinuierliche Zufallsvariable modellieren, da sie (vor der digitalen Erfassung) unendlich viele Werte annehmen kann.
"""

# ╔═╡ 7b2d63dc-8a2b-4b35-bb9a-d1dea9c6b2df
md"""
# Unabhängige Ereignisse

Zwei Messungen, Versuche oder Ereignisse nennt man unabhängig, wenn der Ausgang des einen keinen Einfluss auf den anderen hat. Wenn man mit zwei Würfeln würfelt, ist das Ergebnis des einen Würfels unabhängig vom anderen. Wenn man aber Kugeln aus einer Urne zieht, ohne diese wieder zurück zu legen, dann beeinflusst die erste Ziehung die Wahrscheinlichkeitsverteilung der zweiten Ziehung.
"""

# ╔═╡ b719d95d-c38d-4f4c-a80f-982e01100dad
md"""
Formal schreibt sich das als
```math
P(A \cap B) = P(A) \, P(B)
```
Die Wahrscheinlichkeit, dass $A$ *und* $B$ eintritt, ist das Produkt der Wahrscheinlichkeiten für $A$ und $B$.
"""

# ╔═╡ 6df6dcf1-6e38-42ba-b748-568cf50dd22b
md"""
Wir können das benutzen, um $\pi$ zu bestimmen: wir zeihen zwei Zufallszahlen und verstehen sie als Koordinate in einem Einheits-Quadrat. Der Anteil der Punkte mit Abstand kleiner 1 zum Ursprung ist $\pi/4$.
"""

# ╔═╡ 483f1c2e-f4ef-40dd-a70d-8ec000619167
begin 
	n = 100
	x_coord = rand(Float64, n)
	y_coord = rand(Float64, n)
	pi_guess = 4 / n * count(x -> x < 1 , @. sqrt(x_coord^2 +y_coord^2))
	
	scatter(x_coord, y_coord, leg=false, aspect_ratio=:equal)
	plot!( range(0,1;length=100), sqrt.(1 .- range(0,1;length=100).^2),
	title="pi ist ca. $(pi_guess)")
end

# ╔═╡ c46261d0-9e3c-40a0-abd3-daa881810fb7
md"""
# Bedingte Wahrscheinlichkeit

Wir betrachten zwei Ereignisse $A$ und $B$ aus dem gleichen Wahrscheinlichkeitsraum $\Omega$. Wir kennen die einzelnen Wahrscheinlichkeiten $P(A)$ und $P(B)$. Wie ändert sich die Wahrscheinlichkeit für das Ereignis $B$, wenn wir wissen, dass Ereignis $A$ eingetreten ist? Dies beantwortet die bedingte Wahrscheinlichkeit $P(B | A)$ ('B unter der Voraussetzung A'). Aus geometrischen Überlegungen ergibt sich
```math
P(B | A) = \frac{P(A \cap B)}{P(A)}
```
falls $P(A) \neq 0$.
"""

# ╔═╡ ade0180c-b79d-4cd0-b832-d64ba65924d7
md"""
Wir lösen das nach $P(A \cap B)$ auf und erhalten den *allgemeinen Multiplikationssatz*
```math
P(A \cap B) = P(B|A) \, P(A) = P(A | B) \,  P(B)
```
Das gilt auch, falls $P(A)$ oder $P(B)$ Null sind.
"""

# ╔═╡ 987fdd6a-a269-4f85-bcc4-e995df6ac9cd
md"""
Für unabhängige Ereignisse ist ja $P(A \cap B) = P(A) \, P(B)$, so dass 
```math
P(B | A) = \frac{P(A \cap B)}{P(A)} = P(B)
```
Das Eintreten von $A$ ändert nichts an der Wahrscheinlichkeit von $B$. Die bedingte Wahrscheinlichkeit ist gleich der unbedingten.

"""

# ╔═╡ bd5f753c-e2bc-4213-904a-1dd5b1299ef1
md"""
# Satz von Bayes

Wir stellen den allgemeinen Multiplikationssatz um und erhalten den *Satz von Bayes*
```math
 P(A | B) = \frac{  P(B|A) \, P(A)  }{ P(B) }
```
den man auch schreiben kann als
```math
 P(A | B) = \frac{  P(B|A) \, P(A)  }{ P(B|A) \, P(A)  + P(B|A^C) \, P(A^C) }
```
"""

# ╔═╡ 72ab96b0-66d2-468b-bf7d-336fde444357
md"""
Die Bedeutung des Satzes von Bayes liegt darin, die bedingte Wahrscheinlichkeit umzukehren. Man kennt $P(B|A)$, ist aber eigentlich an $P(A|B)$ interessiert. Diese sind nur dann identisch, wenn $A$ und $B$ gleich wahrscheinlich sind.
"""

# ╔═╡ 8febb962-3987-4b4b-82cb-ec13737dfb57
md"""
# Beispiel Corona-Test

Bei einem medizinischen Test ([binärer Klassifikator](https://de.wikipedia.org/wiki/Beurteilung_eines_bin%C3%A4ren_Klassifikators)) beobachtet man ein Ereignis $B$ = 'Test positiv' und ist daran interessiert, ob jemand beispielsweise mit Corona infiziert ist (Ereignis $A$ = 'wirklich infiziert'). Im Labor gemessen hat man das jedoch andersrum: Man wendete den Test bei vielen Leuten an, von den man wusste, ob sie infiziert sind oder nicht. Man hat also $P(B|A)$ bestimmt.

Lassen sie uns als Beispiel den mir gerade vorliegenden Test betrachten. Im Beipackzettel findet sich das Ergebnis der Studie

|            | infiziert| gesund | Summe |
|:---------- | :------- |:---------|:-----|
| Test +  | 190      | 1     | 191 |
| Test -  |11        |  403 | 414 |
| Summe     |201        |  404 | 605 |

"""

# ╔═╡ 6efa15a1-83ed-4113-9a8b-62c623b3637a
md"""
Die *Sensitivität* gibt die Wahrscheinlichkeit an, mit der ein infizierter Patient korrekt als infiziert (positiv) erkannt wird (= richtig-positiv), also
```math
P(\text{Test positiv} | \text{infiziert}) = \frac{P(A \cap B)}{P(B)} = \frac{190}{201} = 94.5\%
```
"""

# ╔═╡ 7ff3a939-11b1-46c6-a0b2-8a2a14db9bed
md"""
Die *Spezifität* gibt die Wahrscheinlichkeit an, mit der ein gesunder Patient korrekt als nicht infiziert (negativ) erkannt wird (= richtig-negativ) , also
```math
P(\text{Test negativ} | \text{gesund}) = \frac{P(A \cap B)}{P(B)} = \frac{403}{404} = 99.8\%
```
"""

# ╔═╡ 63a04045-e64e-472f-8784-6b810cb70d8a
md"""
Die Zahlen sehen ja alle gut aus, allerdings waren im Labor auch 201 von 605 Personen infiziert. Das sind viel mehr als in Wirklichkeit. Selbst eine kleine falsch-positiv-rate wird dominant, wenn die Infektion sehr selten ist (siehe [Prävalenzfehler](https://de.wikipedia.org/wiki/Pr%C3%A4valenzfehler)). Eigentlich interessiert uns ja $P(\text{infiziert } | \text{Test positiv})$. Dazu benutzen wir den Satz von Bayes und brauchen zunächst eine Annahme über die *a priori* (vorab) Wahrscheinlichkeit, infiziert zu sein. Also 
```math
P(\text{infiziert} | \text{ positiv}) = \frac{P( \text{positiv} | \text{infiziert} )  P( \text{infiziert} ) } { P( \text{positiv} | \text{infiziert} )  P( \text{infiziert} ) + P( \text{positiv} | \text{gesund} )  P( \text{gesund} )}
```

"""

# ╔═╡ 4bbc498d-cdf4-4da6-a8b3-bedd49a03ead
md"""
Mit $P( \text{positiv} | \text{gesund} ) = 1- P( \text{negativ} | \text{gesund} )$ und $P( \text{gesund} ) = 1 -  P( \text{infiziert} )$ haben wir alles was wir brauchen.
"""

# ╔═╡ e72f25d0-b6e8-4e63-b54e-64e4a261832e
@bind inzidenz Slider(0:1000; show_value=true, default=300 )

# ╔═╡ 7ff0257f-cbe2-47b5-9e07-02a001afa5f5
begin
	sens = 0.945
	spez = 0.998
	P_infiziert = inzidenz / 1e5
	
	# für weiter unten
	P_infiziert_negativ = (1-sens) * P_infiziert / ((1-sens) * P_infiziert + spez*(1-P_infiziert))
	
	P_infiziert_positiv = sens * P_infiziert / (sens * P_infiziert + (1-spez)*(1-P_infiziert))
end

# ╔═╡ 19a82202-7e1d-4773-a8ca-26d1c730f83c
md"""
Bei niedrigen Inzidenzen ist ein positiver Test also nicht gleichbedeutend mit einer Infektion. Bei hohen Inzidenzen aber schon.
"""

# ╔═╡ 7e5bf007-755c-40e9-9755-606691faa97d
md"""
Bei einer Inzidenz von $(inzidenz) pro 100 000 Einwohner sind von 10 000 Personen mit positiven Testresultaten $(round(P_infiziert_positiv*10000)) Personen infiziert. Gleichzeitig sind $(round(P_infiziert_negativ*10000)) Personen infiziert, obwohl der Test negativ ausgefallen ist.
"""

# ╔═╡ af791195-e61d-4324-95f6-a561b9f224d5
md"""
# Diskrete Wahrscheinlichkeitsverteilungen

## Binomialverteilung
"""

# ╔═╡ fdfcfe7e-e266-40ae-812e-633aee2a5093
md"""
Wir betrachten eine binäre Zufallsvariable $X$, die also nur zwei verschiedene Werte annehmen kann. Ein Beispiel könnte der Wurf einer Münze sein. Die Wahrscheinlichkeit für eine Eins sein $p$, also $P(X=1) = p$ und somit $P(X=0)= 1-p$. Dies nennt man die *Bernoulli-Verteilung*.
"""

# ╔═╡ 0e03b45f-1a25-4aa9-bb88-b1f4d447d61c
md"""
Wenn wir die Münze $n$ mal werfen und die Summe der 'Augen' bilden, so können Werte zwischen 0 und $n$ auftreten. Die Wahrscheinlichkeit für den Wert $x$ ist
```math
P(X=x) = \binom{n}{x} \, p^x \, (1-p)^{n-x}  = \mathcal{B}(n, p)
```
Um die Summe $x$ zu erhalten, müssen wir $x$ mal die Eins ziehen und und $n-x$ mal die Null. Da die Reihenfolge keine Rolle spielt geht der Binomialkoeffizient ein. Diese Verteilung nennt man daher Binomialverteilung. Sie beschreibt beispielsweise, wie viele Personen einer Gruppe in diesem Monat Geburtstag haben, wie viele von uns heute mit den linken Fuß aufgestanden sind, oder wie viele Fahrräder heute morgen einen Platten hatten. Wir zählen also 'positive' Ergebnisse in einer festgelegten Anzahl von Versuchen.


"""

# ╔═╡ 67862444-dcd4-47d5-b037-95d3c560c639
md"""
Der Erwartungswert der Binomialverteilung ist $np$. Die Varianz $n p (1-p)$. Die Summe von zwei Binomialverteilungen *mit gleichem $p$* ist wieder eine Binomialverteilung mit der Summe der  $n_i$. Falls sich die $p_i$ unterscheiden ist die Summe keine Binomialverteilung.
"""

# ╔═╡ 270d537e-2fa9-4c86-a774-13094ec235fa
md"""
In Julia können wir beispielsweise auf das Distributions-Paket zurückgreifen. Zur graphischen Darstellung zeigen wir die probability density function (pdf).
"""

# ╔═╡ 470ff3e3-b54a-4583-8f11-7168839466ee
Distributions.pdf(Distributions.Binomial(10, 0.4))

# ╔═╡ 24a76770-6089-49d3-81da-b89a7e770693
@bind p_binomial Slider(0:0.01:1; default=0.3, show_value=true)

# ╔═╡ 655e3df7-65eb-41b1-ade4-0ea2c8f6dda3
Plots.bar((0:10), pdf(Binomial(10, p_binomial)), leg=false)

# ╔═╡ b2c7d291-3020-4776-bc95-a65cbefe0228
md"""
## Poisson-Verteilung

In der Poisson-Verteilung zählen wir auch Ereignisse, allerdings ohne dass die Anzahl der Versuche $n$ der Binomialverteilung eine Rolle spielt. Ein Beispiel sind Klicks eines Geigerzählers pro Zeitintervall oder Regentropfen pro Fläche.

"""

# ╔═╡ f4118979-8e51-47b4-ab90-c49838be057e
md"""
Wir folgen hier dem Regentropfen-Beispiel von Stahel und betrachten eine Kachel der Größe Eins. Auf dieser Kachel markieren wir einen Bereich der Fläche $\lambda y 1$. Der erste Regentropfen fällt auf diese Kachel. Die Wahrscheinlichkeit, dass er im markieren Bereich landet, beträgt $\lambda$.

Nun gehen wir zu $n$ Kacheln über und lassen insgesamt genausoviele Tropfen auf die Kacheln fallen. Die aAnzahl Treffer im markierten Bereich der ersten Kachel ist wie oben binomialverteilt, nämlich 
```math
\mathcal{B}(n, \lambda/n) = \binom{n}{x} \, \left(\frac{\lambda}{n} \right)^x \, \left(1-\frac{\lambda}{n} \right)^{n-x} 
```
Die Idee hinter '$n$ Tropfen auf $n$ Kacheln' ist, dass wir im Mittel immer gleich lang warten müssen, bis ein Tropfen den markierten Bereich triff.

Die *Poisson-Verteilung* ist der Grenzwert davon für $n \rightarrow \infty$
```math
\mathcal{P}( \lambda)  = \lim_{n \rightarrow \infty} \mathcal{B}(n, \lambda/n) 
= \frac{\lambda^x}{x!} \, e^{- \lambda}
```
Beispiele sind alle vom Typ 'viele ($n$ groß) seltene ($\lambda /n$ klein) Ereignisse', z.B. Anzahl der Staubpartikel in der Luft oder Anzahl der Photonen in einem Laserstrahl.
"""

# ╔═╡ 2561cbbf-ed9b-4431-b147-037e7f1ea059
md"""
Der Erwartungswert der Poissonverteilung und die Varianz sind beide $\lambda$. Die Summe von zwei Poissonverteilungen mit den Parametern $\lambda_1$ und $\lambda_2$ ist wieder einer Poissonverteilung mit dem Parameter $\lambda_1 + \lambda_2$.
"""

# ╔═╡ 23588033-586a-480b-87c1-9f5c1c73eeb8
md"""
Die Poisson-Verteilung reicht bis ins Unendliche, ist also für jeden ganzzahligen Wert $x$ definiert. Daher müssen wir bei der Berechnung der probability density function ein Intervall mit angeben. Für große $\lambda$  (ab ca. 10) geht sie in die Normalverteilung über (siehe unten).
"""

# ╔═╡ d7a06eb0-3df4-48d8-b245-0b0af5aec685
@. pdf(Poisson(1.3), (0:5))

# ╔═╡ 9e63ed05-4e4c-40de-ae22-d5fa41b9a397
@bind λ_poisson Slider(0:0.2:5; default=0.4, show_value=true)

# ╔═╡ 015ff221-c280-45ac-a554-083e2547fb16
let
	x = (0:10)
	h =  @. pdf(Poisson(λ_poisson), x)
	bar(x,h; legend=false, xlabel="x", ylabel="Wahrscheinlichkeit")
end

# ╔═╡ c6a9da46-d67a-4fcc-b25b-b2b1ec0c8d5b
md"""
# Kontinuierliche Verteilungen

Bei kontinuierlichen Verteilungen macht die Beschreibung durch die Wahrscheinlichkeit für ein bestimmtes Ergebnis $x$ wenig Sinn, da der Wert $x$ nie wirklich exakt erreicht wird. $P(X=x)$ ist  nicht definiert oder Null. Wir betrachten daher die *kumulative Verteilungsfunktion*
```math
F(x) = P(X \le x)
```
und es gilt natürlich
```math
 P(a < X \le b) = F(b) - F(a)
```
Damit können wir aber eine *Wahrscheinlichkeitsdichte* $f$ definieren mit
```math
f(x) = F'(x)
```
die an die Stelle der alten Wahrscheinlichkeit $P$ tritt.
"""

# ╔═╡ 36e13b17-2a39-49b0-8f5e-71c6eb17679e
md"""
## Exponentialverteilung

Die Exponentialverteilung beschreibt die Wartezeit zwischen Ereignissen, die der Poisson-Verteilung folgen. Beispiele sind also der Abstand zwischen zwei Klicks des Geigerzählers oder zwischen zwei Photonen eines Laserstrahls. Sie hat die Form
```math
F(x) = 1 - e^{- \lambda x} \quad \text{für} \quad x \ge 0 \quad \text{sonst} \quad =0
```
Ihre Dichte ist
```math
f(x) =  \lambda e^{- \lambda x} \quad \text{für} \quad x \ge 0
```
"""

# ╔═╡ f42ba88f-0f0b-45a8-accf-080c10e5600b
md"""
Der Erwartungswert der Exponentialverteilung ist $1/\lambda$, die Varianz $1/\lambda^2$.
"""

# ╔═╡ 6c33fb5c-56e7-4062-8437-6e5a74aa7e34
@bind p_exponential Slider(0.1:0.1:1 ; default=0.4, show_value=true)

# ╔═╡ ea779cf4-628c-4594-8ad4-a756c8764bd4
let
 	x = range(0, 10; step=0.1)
	# the parameter is 1/λ
 	plot(x, pdf.(Exponential(1/p_exponential), x), legend=false, xlabel="x", ylabel="WK Dichte")
end

# ╔═╡ 570fa9e0-6a41-4284-ae00-2085d905f992
md"""
## Normalverteilung

Die Normalverteilung hat die Form einer Gauss-Funktion. Für die *Standard-Normalverteilung* ist die Wahrscheinlichkeitsdichte um die Null zentriert mit der Varianz 1, also
```math
f(x) = \frac{1}{\sqrt{2\pi}} \, e^{- x^2/2}
```
"""

# ╔═╡ 3d86ebd6-6ae9-4804-8fff-eafccaf82eaa
md"""
Andere Formen der Normalverteilung erhält man durch lineare Transformation. Sei $Z$ eine Zufallsvariable, die der Standard-Normalverteilung folgt, dann transformiert
```math
X = \mu + \sigma Z
```
hin zu einer Normalverteilung mit dem Erwartungswert $\mu$ und der Standardabweichung $\sigma$. Die Wahrscheinlichkeitsdichte ist dann also
```math
f(x) = \frac{1}{\sigma \, \sqrt{2\pi}} \, e^{- \frac{1}{2} (\frac{x - \mu}{\sigma})^2}
```

"""

# ╔═╡ 0c8f9387-896b-4e4b-ba07-b4494fabda23
@bind sigma_normal Slider(0.5:0.5:4, ; default=1, show_value=true)

# ╔═╡ 8746abb3-48c5-4a57-8721-60b54435d15a
let
 	x = range(-10, 10; step=0.1)
 	plot(x, pdf.(Normal(0, sigma_normal), x), legend=false, xlabel="x", ylabel="WK Dichte")
end

# ╔═╡ 5373a711-a823-4bc2-9183-0e2d0f485ac7
md"""
Die kumulative Verteilungsfunktion $F$ der Normalverteilung, also
```math
F(x) = \frac{1}{\sigma \, \sqrt{2\pi}} \int_{-\infty}^x \, e^{- \frac{1}{2} (\frac{y - \mu}{\sigma})^2} \, dy
```
nennt sich *error function*. Das Integral lasst sich nicht analytisch lösen. Wir brauchen es allerdings häufig, insbesondere um zu sagen, mit welcher Wahrscheinlichkeit ein Messwert innerhalb eines gewissen Intervalls liegt.
"""

# ╔═╡ e838eb36-9d4f-4d75-9ef6-a65276c60533
md"""
In Interval $\mu \pm$ 1, 2 oder 3 $\sigma$ liegen 68.3%, 95.5% oder 99.7% der Ereignisse. Oder in Julia
"""

# ╔═╡ 12701bce-4c4f-4ec3-b20c-2c06a54b6787
let
	sigmas = (1,2,3)
    @. cdf(Normal(0, 1), sigmas) - cdf(Normal(0, 1), - sigmas)
end

# ╔═╡ cb1347f3-89b3-46ed-a0e5-d85b255c37cc
md"""
Summen von Normalverteilungen sind wieder eine Normalverteilung. Dabei addieren sich die Mittelwerte und die Varianzen (nicht die Standardabweichungen), also
```math
 \mu_{sum} = \mu_1 + \mu_2 + \cdots \quad \text{und} \quad
 \sigma_{sum}^2 = \sigma_1^2 + \sigma_2^2 + \cdots
```
"""

# ╔═╡ 3d2a3ea3-2434-423a-9a6c-e7b31a4c28b2
md"""
### Beziehung zur Poisson-Verteilung

Die Poisson-Verteilung besitzt nur einen Parameter $\lambda$. Für große Werte von $\lambda$ geht sie in eine Normalverteilung mit dem Mittelwert $\mu = \lambda$ und der Standard-Abweichung $\sigma = \sqrt{\lambda}$ über.
"""

# ╔═╡ dbebf6b3-54d6-4aeb-a6a0-7d0c9c4ab01e
@bind lambda_vgl Slider(0:30; show_value=true, default=10)

# ╔═╡ 66cde5d5-ca2b-44e2-9b6c-8b731a2fa1ed
let
 	x = range(0, 30)
	plot(x, pdf.(Poisson(lambda_vgl), x) , label="Poisson")
 	plot!(x, pdf.(Normal(lambda_vgl, sqrt(lambda_vgl)), x), label="Normal",
		xlabel="x", ylabel="WK Dichte")
end

# ╔═╡ e7af08b6-77a8-4cf6-9d19-5244052f5877
md"""
### Log-Normalverteilung

Bei der Log-Normalverteilung ist der Logarithmus der Werte normalverteilt. Negative Werte treten also nicht auf und die Verteilung wird (auf einer linearen Achse) asymmetrisch.
"""

# ╔═╡ 36765066-f666-43b7-9418-beacd821e82e
let
 	x = range(0, 10; step=0.1)
 	plot(x, pdf.(LogNormal(1, 0.4), x), legend=false, xlabel="x", ylabel="WK Dichte")
end

# ╔═╡ 2c35fa4c-eb7f-4e24-b9c1-9ecceeabfe70
md"""
# Funktionen von Zufallsvariablen 

Nehmen wir an, dass wir wissen, eine Zufallsvariable $X$ entspringe einer der obigen Verteilungen. Welchen Aussagen können wir dann über die Verteilung der Werte von $g(X)$ machen? Wir wenden also die Funktion $g$ auf jede gezogenen Wert an und bilden daraus eine neue Verteilung. Die Log-Normalverteilung oben ist ein Beispiel: wir ziehen Zahlen aus einer Normalverteilung und wenden die Exponentialfunktion an.


"""

# ╔═╡ 2fe7d80e-1152-4c71-b73f-feb483a6ab8b
md"""
Der Erwartungswert von $g(X)$ ist näherungsweise die Funktion $g$ ausgewertet am Erwartungswert von $X$, also 
```math
\mathcal{E}(g(X)) \approx g(\mathcal{E}(X))
```
"""

# ╔═╡ cc3eb8f0-3a9d-4bc2-a678-fcfae2eea942
md"""
Die Beschreibung der Varianz von $g(X)$ ist Inhalt der **Gauss'schen Fehlerfortpflanzung**. Es gilt
```math
\text{var}( \alpha + \beta X) = \beta^2 \text{var}(X)
\quad
\text{bzw}
\quad
\sigma_{\alpha + \beta X} = \beta \, \sigma_X
```
bzw. allgemein für eine Variable 
```math
\sigma_{g(X)} \approx | g'(\mu)|  \sigma_X
```
Für Funktionen mehrere *unabhängiger* Variablen gilt
```math
\sigma_{g(X, Y)} \approx \sqrt{ \left(\frac{\partial g}{\partial X} \sigma_X \right)^2 +\left(\frac{\partial g}{\partial Y} \sigma_Y \right)^2 }
```
Im nächsten Kapitel werden wir darauf genauer eingehen.
"""

# ╔═╡ e31df594-146d-48d8-a8e0-8485fb1488d5
md"""
# Zentraler Grenzwertsatz

Warum ist die Normalverteilung 'normal'? Die Normalverteilung ist dadurch ausgezeichnet, dass sie im Grenzwert der Summe von vielen Zufallsvariablen entspricht, egal welcher Verteilung diese Zufallsvariablen entstammen.

Seien $X_1, X_2, X_i, \dots$ Zufallsvariablen aus der gleichen Verteilung mit dem Erwartungswert $\mu$ und der Standardabweichung $\sigma$. Diese Verteilung kann quasi beliebige Form haben. Wir betrachten als neue Zufallsvariable den Mittelwert über die ersten $n$ $X_i$ und nennen diese $\bar{X}$. Aus der Gauss'schen Fehlerfortpflanzung kennen wir Erwartungswert $\mathcal{E}(\bar{X})$ und Standardabweichung $\sigma_\bar{X}$, nämlich
```math
\mathcal{E}(\bar{X}) = \mu \quad \text{und} \quad \sigma_\bar{X} = \sigma_X / \sqrt{n}
```
"""

# ╔═╡ 67ace1ef-ff1c-4bf4-98bf-4a76cac54429
md"""
Jetzt interessiert uns die Form der Verteilung unserer neuen Zufallsvariable $\bar{X}$. Dazu standardisieren wir diese, skalieren also so zu einer dritten Zufallsvariablen $Z$, dass Erwartungswert Null und Standardabweichung Eins werden 
```math
Z = \frac{\bar{X} - \mu}{\sigma / \sqrt{n}}
```
"""

# ╔═╡ 6279a1d0-a496-4805-979b-a75e3774a089
md"""
Der Zentrale Grenzwertsatz besagt, dass sich die Verteilung von $Z$ mit steigender Mittelungszahl $n$ immer weiter einer Standard-Normalverteilung annähert.
"""

# ╔═╡ 44e80799-7380-4ff1-b0bc-f20b9f4e099f
@bind n_mittel Slider(1:10; show_value=true)

# ╔═╡ b01cca80-c3d5-4d4f-b737-893674d02af4
let
	N_Z = 1000    # Anzahl Punkte in Z-Verteilung
	x = range(-3,3; step=0.1)
	
	zufall = rand(Exponential(1),  N_Z, n_mittel) # exponentialverteilt, λ=1
    Xbar = sum(zufall; dims=2)  # sum along n_mittel
	Z = (Xbar .- n_mittel) ./ sqrt(n_mittel)  # hier ist σ=1 und μ=n_mittel
	
	h1 = StatsBase.fit(Histogram, vec(Z), x)  # histogram
	h1 = LinearAlgebra.normalize(h1, mode=:pdf) # normieren auf pdf
	plot( h1, label="Summe über exponential")  # plotten
	
	plot!(x, pdf.(Normal(),x), label="Standard-Normal")  # Normalverteilung zum Vgl
end

# ╔═╡ 1842a8aa-5819-4719-8d73-02206be09594
md"""
# Reste

- Gesetz der großen Zahlen
- Erzeugung von willk. verteilen Zufallszahlen

"""

# ╔═╡ e7f7f02a-b6cc-4f77-adbb-515a5bb45a45
TableOfContents(title="Inhalt")

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Distributions = "31c24e10-a181-5473-b8eb-7969acd0382f"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Random = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
StatsBase = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"

[compat]
Distributions = "~0.25.53"
Plots = "~1.27.5"
PlutoUI = "~0.7.38"
StatsBase = "~0.33.16"
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
git-tree-sha1 = "ad368663a5e20dbb8d6dc2fddeefe4dae0781ae8"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+0"

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
# ╟─e19a8fb0-1814-4b09-bb64-2fa1df689659
# ╟─4a5520a2-bf90-40da-8b64-dea62aeeb5c7
# ╟─b8b5eeac-5934-4085-9202-9b1d2ad40208
# ╟─9277a2d9-08b9-4362-83f4-bf9e5fde004c
# ╟─ba95eeaa-d5f3-4032-ac9b-c28f7e23fc6a
# ╟─7c903e39-fb09-4ab0-83e4-1034830f138b
# ╟─9490ef1a-cab2-4b81-8ccb-385446d220be
# ╟─67457022-5fc6-4ced-9490-9390bf4fa84f
# ╟─0b11c831-a09c-4978-a090-1eeb75fdc194
# ╟─0b64feec-eb2d-479c-9bc5-d7de632730bf
# ╟─50938628-d2c1-4f2f-b4ff-b4017a2b65df
# ╟─60a9f358-0c4b-4f87-abf0-8e39d7977981
# ╟─0ee71dae-b8a5-43d5-995b-be7dbf7c93c6
# ╠═bc02dd02-f593-4c9d-a4e2-955546bb0a2a
# ╟─f30c68af-2e3f-45dc-a2d5-86edae8ffed1
# ╠═0cc2abe6-503d-4950-b67b-43026aecc5de
# ╟─6f394b61-928b-42f6-b955-4ff172aa7ee8
# ╟─c846346f-8438-4cd5-ba9a-6afafd1e8473
# ╠═ab99ab48-2384-4fa7-94a9-aaf71fb37087
# ╟─77c5656d-1e6d-499f-8f8c-f65b759fdd79
# ╠═0ac9fb54-fac4-4af8-95d4-2301ec0f5be6
# ╠═48be7ee0-179a-4bdf-8f15-660f31c17111
# ╠═ec2dbc61-97a0-4ab1-ba98-b67e54afff08
# ╟─0be5ce70-fe75-48e1-bce9-dda7cbe4c3e0
# ╟─7b2d63dc-8a2b-4b35-bb9a-d1dea9c6b2df
# ╟─b719d95d-c38d-4f4c-a80f-982e01100dad
# ╟─6df6dcf1-6e38-42ba-b748-568cf50dd22b
# ╠═483f1c2e-f4ef-40dd-a70d-8ec000619167
# ╟─c46261d0-9e3c-40a0-abd3-daa881810fb7
# ╟─ade0180c-b79d-4cd0-b832-d64ba65924d7
# ╟─987fdd6a-a269-4f85-bcc4-e995df6ac9cd
# ╟─bd5f753c-e2bc-4213-904a-1dd5b1299ef1
# ╟─72ab96b0-66d2-468b-bf7d-336fde444357
# ╟─8febb962-3987-4b4b-82cb-ec13737dfb57
# ╟─6efa15a1-83ed-4113-9a8b-62c623b3637a
# ╟─7ff3a939-11b1-46c6-a0b2-8a2a14db9bed
# ╟─63a04045-e64e-472f-8784-6b810cb70d8a
# ╟─4bbc498d-cdf4-4da6-a8b3-bedd49a03ead
# ╠═e72f25d0-b6e8-4e63-b54e-64e4a261832e
# ╠═7ff0257f-cbe2-47b5-9e07-02a001afa5f5
# ╟─19a82202-7e1d-4773-a8ca-26d1c730f83c
# ╟─7e5bf007-755c-40e9-9755-606691faa97d
# ╟─af791195-e61d-4324-95f6-a561b9f224d5
# ╟─fdfcfe7e-e266-40ae-812e-633aee2a5093
# ╟─0e03b45f-1a25-4aa9-bb88-b1f4d447d61c
# ╟─67862444-dcd4-47d5-b037-95d3c560c639
# ╟─270d537e-2fa9-4c86-a774-13094ec235fa
# ╠═20aaac5b-3b6d-4448-89c1-00485bc4a129
# ╠═470ff3e3-b54a-4583-8f11-7168839466ee
# ╠═24a76770-6089-49d3-81da-b89a7e770693
# ╠═655e3df7-65eb-41b1-ade4-0ea2c8f6dda3
# ╟─b2c7d291-3020-4776-bc95-a65cbefe0228
# ╟─f4118979-8e51-47b4-ab90-c49838be057e
# ╟─2561cbbf-ed9b-4431-b147-037e7f1ea059
# ╟─23588033-586a-480b-87c1-9f5c1c73eeb8
# ╠═d7a06eb0-3df4-48d8-b245-0b0af5aec685
# ╠═9e63ed05-4e4c-40de-ae22-d5fa41b9a397
# ╠═015ff221-c280-45ac-a554-083e2547fb16
# ╟─c6a9da46-d67a-4fcc-b25b-b2b1ec0c8d5b
# ╟─36e13b17-2a39-49b0-8f5e-71c6eb17679e
# ╟─f42ba88f-0f0b-45a8-accf-080c10e5600b
# ╠═6c33fb5c-56e7-4062-8437-6e5a74aa7e34
# ╠═ea779cf4-628c-4594-8ad4-a756c8764bd4
# ╟─570fa9e0-6a41-4284-ae00-2085d905f992
# ╟─3d86ebd6-6ae9-4804-8fff-eafccaf82eaa
# ╠═0c8f9387-896b-4e4b-ba07-b4494fabda23
# ╠═8746abb3-48c5-4a57-8721-60b54435d15a
# ╟─5373a711-a823-4bc2-9183-0e2d0f485ac7
# ╟─e838eb36-9d4f-4d75-9ef6-a65276c60533
# ╠═12701bce-4c4f-4ec3-b20c-2c06a54b6787
# ╟─cb1347f3-89b3-46ed-a0e5-d85b255c37cc
# ╟─3d2a3ea3-2434-423a-9a6c-e7b31a4c28b2
# ╠═dbebf6b3-54d6-4aeb-a6a0-7d0c9c4ab01e
# ╠═66cde5d5-ca2b-44e2-9b6c-8b731a2fa1ed
# ╟─e7af08b6-77a8-4cf6-9d19-5244052f5877
# ╠═36765066-f666-43b7-9418-beacd821e82e
# ╟─2c35fa4c-eb7f-4e24-b9c1-9ecceeabfe70
# ╟─2fe7d80e-1152-4c71-b73f-feb483a6ab8b
# ╟─cc3eb8f0-3a9d-4bc2-a678-fcfae2eea942
# ╟─e31df594-146d-48d8-a8e0-8485fb1488d5
# ╟─67ace1ef-ff1c-4bf4-98bf-4a76cac54429
# ╟─6279a1d0-a496-4805-979b-a75e3774a089
# ╠═44e80799-7380-4ff1-b0bc-f20b9f4e099f
# ╠═b01cca80-c3d5-4d4f-b737-893674d02af4
# ╟─1842a8aa-5819-4719-8d73-02206be09594
# ╠═415d2c7d-b4a3-4565-99ed-9b04e6569b73
# ╠═e7f7f02a-b6cc-4f77-adbb-515a5bb45a45
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
