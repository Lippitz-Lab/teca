### A Pluto.jl notebook ###
# v0.19.26

using Markdown
using InteractiveUtils

# ╔═╡ d0a1d87c-10a3-41f7-947a-32f4262001a2
html"""<div>
<font size="7"><b>9 Rauschen</b></font> </div>

<div><font size="5"> Markus Lippitz</font> </div>
<div><font size="5"> 2. Juni 2022 </font> </div>
"""

# ╔═╡ 262685e2-96f3-11ec-15c6-5f0a5e79b66b
md"""
**Ziel** Sie können den Ursprung von Rauschquellen in optischen
Messungen *identifizieren*.

-   Rauschen-Spektren: 1/f, weiß

-   Physikalischer Ursprung von Rauschen: Schrot, thermisch

-   Leistungsabhängigkeit

-   Maße für Signalamplituden: pp, RMS, Leistung


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

# ╔═╡ 57efc663-192f-4e61-bed3-cd253facf421
using StatsBase

# ╔═╡ b1166151-2a64-4612-bb2d-10f43451fadc
let
	x = (0:0.001:2pi)
	y = sin.(x)
	std(y)
end

# ╔═╡ c29d90ab-c3c0-46d7-8848-43b26d821ada
let
	x = (0:0.001:2)
	y = [if (xi > 1)  1 else -1 end for xi in x]
	std(y)
end

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

# ╔═╡ 9fe95bb1-90b1-4f31-bcd5-f5b8fc428764
let
	L = 10000;  # length of time trace
	n = 15;  # number of events
	
	x = zeros(L)  # empty trace
	t_i = Int16.(round.(rand(n) .* L))  # random arrival times of events
	x[ t_i] .= 1  # here g(tau) = delta(tau- t_i)
	
	(var(x), n ./ L) # compare sigma^2 with n <g>
end

# ╔═╡ 837a2b4a-ba0d-43ec-8ea5-5bc9310d9ba7
md"""
### Selbsttest

Ändern Sie $g(\tau)$ in diesem Beispiel und erklären sie das Ergebnis.
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
natürlich Null, aber die Größe des Rauschens hängt von der Temperatur
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

# ╔═╡ 1079672f-c372-4df4-8a96-4f51d675df5e
let
	f = 10 .^ (0:0.1:10);
	W_1 = 1 ./ f
	W_2 = 1e-4;
	plot(f, W_1 .+ W_2, xaxis =:log, yaxis=:log, legend=false, xlabel="Frequenz", ylabel="Rauschdichte")
end

# ╔═╡ 127b2497-722f-42ab-9196-5d8f6d65cae7
md"""
### Selbsttest

Erzeugen Sie eine Sequenz von ca. 10 000 Zufallszahlen, deren Rauschdichte sowohl einen $1/f$ als auch einen konstanten Anteil hat.
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

# ╔═╡ 18216b75-2dc1-47b0-86de-240b3b1d094d
let
	P = 10 .^ (0:0.1:15);
	W_1 = 1
	W_2 = 1e-2 .* sqrt.(P)
	W_3 = 1e-7 .* P
	plot(P, W_1 .+ W_2 .+ W_3, xaxis =:log, yaxis=:log, legend=false, xlabel="Leistung", ylabel="Rauschen", linewidth=3)
	plot!(P, W_1 .+ zeros(size(P)))
	plot!(P, W_2)
	plot!(P, W_3)
end

# ╔═╡ 3e6d84e3-ed8a-470d-b85a-78c4797c1505
md"""
### Selbsttest

- Skizzieren Sie die Frequenzabhängigkeit der Rauschdichte an charakteristischen Punkten in obigem Diagramm.

- Erzeugen Sie mehrere,  'leistungsabhängige' Sequenzen von Zufallszahlen für diese Punkte.
"""

# ╔═╡ 8b2e767d-1283-41fc-8259-c6e23fbf124f
md"""
# Aufgabe: Oszilloskop

Berechnen Sie die effektive thermische Rauschspannung in einem 50 $\Omega$ Widerstand bei ca 17 °C (290 K) bei einer Messbandbreite von 20 MHz.

Mit welchem Signal-zu-Rausch-Verhältnis wird dann eine Sinus-Oszillation von 1 $\mu$V Amplitude gemessen?
"""

# ╔═╡ e93ef54a-4a0b-4ed1-a476-e980224934bf
using PlutoUI

# ╔═╡ d8faa994-c2b3-4475-a259-d478fcac0398
TableOfContents(title="Inhalt")

# ╔═╡ d7671b7d-0304-4b4b-906c-dab997dde3ed
using Plots

# ╔═╡ Cell order:
# ╟─d0a1d87c-10a3-41f7-947a-32f4262001a2
# ╟─262685e2-96f3-11ec-15c6-5f0a5e79b66b
# ╟─4a39a01c-0001-4297-8e3e-230ad8bdaccb
# ╟─a2ea1556-2426-49d3-ac21-732a0831742d
# ╟─485cb4fb-1346-44e5-9153-e2c1e5cc3209
# ╠═57efc663-192f-4e61-bed3-cd253facf421
# ╠═b1166151-2a64-4612-bb2d-10f43451fadc
# ╠═c29d90ab-c3c0-46d7-8848-43b26d821ada
# ╟─805130c8-8019-4ad0-b2b1-80a4743cb09b
# ╠═9fe95bb1-90b1-4f31-bcd5-f5b8fc428764
# ╟─837a2b4a-ba0d-43ec-8ea5-5bc9310d9ba7
# ╟─a3bbfe35-cddb-4f3c-a97e-b5e900b61f50
# ╟─8e66bbcc-7f58-44bd-bddc-450a2323edc3
# ╟─b3f90972-efe4-49c6-8688-839f75633d75
# ╟─ea766c9f-1bf3-46e7-ac37-cb4ab7550468
# ╟─c18a5b32-b466-4c8b-b5f4-5a65f1b2eca0
# ╟─2cd8ff94-3c1f-47ff-8255-9ebb9a27e686
# ╟─92c2aff9-2683-4362-8179-cf60ed7bf879
# ╟─2e9369d2-9cd8-47b5-91cc-dea782eda247
# ╟─c1ce9b11-fa3f-4634-a45a-dcb910f432f3
# ╠═1079672f-c372-4df4-8a96-4f51d675df5e
# ╟─127b2497-722f-42ab-9196-5d8f6d65cae7
# ╟─d5b9eee1-59b2-46b5-933d-507385f74024
# ╟─34ef0881-8df5-42df-a82c-e9715ac23009
# ╠═18216b75-2dc1-47b0-86de-240b3b1d094d
# ╟─3e6d84e3-ed8a-470d-b85a-78c4797c1505
# ╟─8b2e767d-1283-41fc-8259-c6e23fbf124f
# ╠═e93ef54a-4a0b-4ed1-a476-e980224934bf
# ╠═d8faa994-c2b3-4475-a259-d478fcac0398
# ╠═d7671b7d-0304-4b4b-906c-dab997dde3ed
