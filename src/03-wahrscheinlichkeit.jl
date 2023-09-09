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

# ╔═╡ e19a8fb0-1814-4b09-bb64-2fa1df689659
html"""<div>
<font size="7"><b>3 Wahrscheinlichkeit</b></font> </div>

<div><font size="5"> Markus Lippitz </font> </div>
<div><font size="5"> 2. Mai 2022 </font> </div>
"""

# ╔═╡ 4a5520a2-bf90-40da-8b64-dea62aeeb5c7
md"""
**Ziele** Sie können eine Sequenz von 'Zufallszahlen' in Julia
 *erzeugen*, die einer gegebenen Verteilung genügen.

-   diskrete Verteilungen: Binomial, Poisson

-   stetige Verteilungen: Normal, Log-Normal

-  Satz von Bayes

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

# ╔═╡ bc02dd02-f593-4c9d-a4e2-955546bb0a2a
using Random

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

# ╔═╡ 48be7ee0-179a-4bdf-8f15-660f31c17111
using Plots, StatsBase

# ╔═╡ ec2dbc61-97a0-4ab1-ba98-b67e54afff08
plot(StatsBase.fit(Histogram, hundert, range(0,7; step=0.1)),leg=false)

# ╔═╡ 0be5ce70-fe75-48e1-bce9-dda7cbe4c3e0
md"""
Wie man sieht ist der Würfel ein Beispiel für eine diskrete Zufallsvariable, die nur endlich viele Werte annehmen kann. Die Temperatur im letzten Kapitel würde man als kontinuierliche Zufallsvariable modellieren, da sie (vor der digitalen Erfassung) unendlich viele Werte annehmen kann.
"""

# ╔═╡ 7b2d63dc-8a2b-4b35-bb9a-d1dea9c6b2df
md"""
# Unabhängige Ereignisse

Zwei Messungen, Versuche oder Ereignisse nennt man unabhängig, 
wenn der Ausgang des einen keinen Einfluss auf den anderen hat. Wenn man mit zwei Würfeln würfelt, ist das Ergebnis des einen Würfels unabhängig vom anderen. Wenn man aber Kugeln aus einer Urne zieht, ohne diese wieder zurück zu legen, dann beeinflusst die erste Ziehung die Wahrscheinlichkeitsverteilung der zweiten Ziehung.
$(aside([Resource("https://raw.githubusercontent.com/MarkusLippitz/teca/main/res/03-Wahrscheinlichkeit/unabhaengig.png", (:height => 150))  md"*Schnittmenge zweier **unabhängiger** Ereignisse*"]))  

"""

# ╔═╡ eb16cc8a-37ef-46b4-aee4-59ce70cd5019
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

Wir betrachten zwei Ereignisse $A$ und $B$ aus dem gleichen Wahrscheinlichkeitsraum $\Omega$.   $(aside([Resource("https://raw.githubusercontent.com/MarkusLippitz/teca/main/res/03-Wahrscheinlichkeit/abhaengig.png", (:height => 150))  md"*Schnittmenge zweier **abhängiger** Ereignisse*"]))  

Wir kennen die einzelnen 
Wahrscheinlichkeiten $P(A)$ und $P(B)$. Wie ändert sich die Wahrscheinlichkeit für das Ereignis $B$, wenn wir wissen, dass Ereignis $A$ eingetreten ist? Dies beantwortet die bedingte Wahrscheinlichkeit $P(B | A)$ ('B unter der Voraussetzung A'). Aus geometrischen Überlegungen ergibt sich
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

$(aside([Resource("https://raw.githubusercontent.com/MarkusLippitz/teca/main/res/03-Wahrscheinlichkeit/corona.png", (:height => 250))  md"*Baumdiagramm zum Corona-Test*"]) ) 

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

# ╔═╡ 20aaac5b-3b6d-4448-89c1-00485bc4a129
using Distributions

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

# ╔═╡ fb032133-bc1a-41d7-a4f7-549522ee0198
md"""
Wir folgen hier dem Regentropfen-Beispiel von Stahel und betrachten eine Kachel der Größe Eins. Auf dieser Kachel markieren wir einen Bereich der Fläche $\lambda < 1$. Der erste Regentropfen fällt auf diese Kachel. Die Wahrscheinlichkeit, dass er im markieren Bereich landet, beträgt $\lambda$.  $(aside([Resource("https://raw.githubusercontent.com/MarkusLippitz/teca/main/res/03-Wahrscheinlichkeit/poisson.png", (:height => 100))  md"*Kacheln und Regentropfen*"]) ) 
"""

# ╔═╡ 6216d01f-ea57-4022-bd6f-7881385e8592
md"""
Nun gehen wir zu $n$ Kacheln über und lassen insgesamt genausoviele Tropfen auf die Kacheln fallen. Die Anzahl Treffer im markierten Bereich der ersten Kachel ist wie oben binomialverteilt, nämlich 
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

# ╔═╡ 415d2c7d-b4a3-4565-99ed-9b04e6569b73
using PlutoUI,  LinearAlgebra

# ╔═╡ 0f7f1008-8d24-4a17-bf0c-5e361328e118
aside(s) =  PlutoUI.ExperimentalLayout.aside(s);

# ╔═╡ e7f7f02a-b6cc-4f77-adbb-515a5bb45a45
TableOfContents(title="Inhalt")

# ╔═╡ Cell order:
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
# ╟─eb16cc8a-37ef-46b4-aee4-59ce70cd5019
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
# ╟─fb032133-bc1a-41d7-a4f7-549522ee0198
# ╟─6216d01f-ea57-4022-bd6f-7881385e8592
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
# ╠═415d2c7d-b4a3-4565-99ed-9b04e6569b73
# ╠═0f7f1008-8d24-4a17-bf0c-5e361328e118
# ╠═e7f7f02a-b6cc-4f77-adbb-515a5bb45a45
