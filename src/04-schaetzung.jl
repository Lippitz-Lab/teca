### A Pluto.jl notebook ###
# v0.19.22

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

# ╔═╡ b3511771-d307-4e33-8406-e561bfe72958
using Distributions, StatsBase, LinearAlgebra, Plots

# ╔═╡ ea9b0a84-3b02-433a-b5df-d1b76b16ceaf
using PlutoUI

# ╔═╡ b1c02d6f-d50d-43cb-a01b-08ae7f4fb30d
using StatsPlots

# ╔═╡ 764a07f5-e3ab-4db3-a5be-5728aab422bb
using Optim

# ╔═╡ 8f76e7fd-7481-40ff-8e54-e31aab7eff1f
html"""<div>
<font size="7"><b>4 Schätzung</b></font> </div>

<div><font size="5"> Markus Lippitz </font> </div>
<div><font size="5"> 10. Mai 2022 </font> </div>
"""

# ╔═╡ 73429f7a-96f1-11ec-2061-8f45c81fe4bc
md"""
**Ziele:** Sie können die Parameter eines Modells *schätzen*, das
einen Datensatz beschreibt.

-   Punktschätzung: chi-quadrat, maximum likelihood

-   Intervallschätzung

-   Regression

**Weitere Aufgaben:**

-   Sie detektieren in einem Intervall von 1 Sekunde 10 Photonen. Wie
    hell ist die Lichtquelle mit 95% Wahrscheinlichkeit?

-   Erzeugen sie eine Summe von 2 P-Verteilungen und schätzen /
    bestimmen die Parameter durch verschiedene Methoden. Vergleichen sie
    die ‚wahren' Parameter mit den geschätzten Parametern und deren
    geschätzten Fehlern.

**Literatur:** Stahel Kap. 7, 9, 13, Bevington Kap. 4, 6--8,
Meyer Kap. 29,30,32,33

"""

# ╔═╡ 0725692b-4deb-4ede-b8c6-e66744a2d5e1
md"""
# Überblick

'Schätzen' nennt man es in der Statistik, wenn man aufgrund von gemessenen Daten in einer Stichprobe eine Aussage über die Wirklichkeit macht. In der Physik würde man das 'die Parameter eines Modells bestimmen' nennen. Schon in der Gauss'schen Fehlerfortpflanzung hatten Sie gesehen, dass oft ein Intervall von Werten die Daten ähnlich gut beschreibt. Die Bestimmung dieses Intervalls nennt man 'Intervall-Schätzung'. Schließlich will man manchmal die Frage beantworten, ob eine gewissen Menge an Messwerten vereinbar ist mit einem gewissen Parameter. Ist der Würfel gezinkt, wenn 5 mal hintereinander die 6 gewürfelt wird? Diese Frage beantworten statistische Tests.
"""

# ╔═╡ aa901300-3e70-442a-a44e-5425232d824f
md"""
# Punktschätzung

Wir haben also eine Stichprobe, können mit diesen Daten alles mögliche anstellen, und möchten auf Eigenschaften der Ausgangs-Verteilung schließen. Wir  könnten beispielsweise  das arithmetische  Mittel aller Werte der Stichprobe berechnen und  dies  als Schätzwert für den  Parameter $\mu$ der Normalverteilung nehmen. Man sagt, das arithmetische Mittel $\bar{X}$ ist ein 'Schätzer' für $\mu$. Schätzer von Variablen bezeichnet man mit einem Hut über der Variablen, also hier $\hat{\mu}$. Diese  sind natürlich selbst wiederum Zufallsvariablen und gehorchen einer Verteilung.
"""

# ╔═╡ 03f44fb9-fb3c-4980-a11b-ece24df033ab
md"""
## Bias
"""

# ╔═╡ 79bf9534-1ab8-4c82-aa79-179cd53d2847
md"""
Wann ist ein Schätzer  gut?  Wie  kann man verschiedene Schätzer  für die gleiche Variable vergleichen?  Wir möchten erreichen, dass de Schätzung $T$ möglichst nahe am wirklichen Wert $\theta$ liegt, und die Abweichungen dazwischen rein zufällig sind. Ein Maß für die Abweichung ist der **mittlere quadratische Fehler** (mean square error, mse)
```math
\mathcal{E}\left< (T- \theta)^2 \right>
```
Das kann man umschreiben als
```math
\mathcal{E}\left< ( (T - \mathcal{E}\left<T\right> )  +  (\mathcal{E}\left<T\right> - \theta) )^2 \right> =
\mathcal{E}\left< ( u+v )^2 \right> 
```
Der Term mit $u^2$ ist die Varianz von $T$, der Term mit $2uv$ verschwindet, weil $\mathcal{E}\left< T - \mathcal{E}\left< T \right> \right> = 0$, und der Term mit $v^2$ beleibt, so dass
```math
\mathcal{E}\left< (T- \theta)^2 \right> = \text{var}\left<T\right> + (\mathcal{E}\left< T \right> - \theta)^2
```
Hier ist der zweite Term der *systematische Fehler* oder bias des Schätzers. Selbst durch ausgiebiges Messen wird $T$ niemals $\theta$ erreichen, wenn dieser Term nicht Null ist. Ein Schätzer heist 'erwartungstreu', 'biasfrei' oder 'unbiased', wenn dieser Term verschwindet.
"""

# ╔═╡ ecc16765-be51-46bb-afb2-8c4c434fe112
md"""
### Bsp. Halbwertszeit $\lambda$ einer Exponentialverteilung
"""

# ╔═╡ be8cb8b4-6ad0-43c1-bf9f-25d1cac5f1e6
md"""
Als Beispiel betrachten wir die Exponentialverteilung
```math
f(x) = \lambda e^{- \lambda x}
```
Wir ziehen $n$ Zufallszahlen aus dieser Verteilung und wollen daraus den Parameter $\lambda$ bestimmen. Die Halbwertszeit $\tau$ der Verteilung, also $f(\tau) = \lambda/2$ ist erreicht bei $x=\ln 2 / \lambda$, daher der Name der Parameters.

Wir vergleichen als Schätzer die Mittelwertbildung und die Bildung des Medians. Letzterer muss noch durch $\ln 2$ geteilt werden. Für die 'wahre' Verteilung gilt $\lambda =1$.
"""

# ╔═╡ aa19a7f1-2855-4e70-b31b-6db499756ad2
@bind n_mittel Slider(1:10; show_value=true)

# ╔═╡ c2ebc3e1-f9a9-42fd-9b25-82e29739ae49
@bind schaetzer Radio(["median", "mean" ], default="median")

# ╔═╡ 763b6b51-43c2-41a6-95e2-05d429b990ef
let
	N_Z = 1000    # Anzahl Punkte in Z-Verteilung
	x = range(0,3; step=0.1)
	
	zufall = rand(Exponential(1),  N_Z, n_mittel) # exponentialverteilt, λ=1
	if (schaetzer == "median")
    	lambda_hat = median(zufall; dims=2) / log(2) # median along n_mittel
	else
		lambda_hat = mean(zufall; dims=2) # mean along n_mittel
	end
	bias = mean(lambda_hat) - 1 ;
	
	h1 = StatsBase.fit(Histogram, vec(lambda_hat), x)  # histogram
	plot( h1, legend=false, 
		title="'$(schaetzer)', bias = $(bias)", 
		xlabel="geschätztes λ")  
	
end

# ╔═╡ 2414e501-b353-4ae5-8898-440e8b1bd6ec
md"""
Zunächst einmal sieht man, dass bei kleinem $n$ beide Schätzer deutlich streuen.
Beide Schätzer sind für große $n$ erwartungstreu, bias free. Für kleines $n$ besitzt aber der Median einen deutlichen bias.
"""

# ╔═╡ fc6bbfe2-aa23-4df9-8506-48e956068b8d
md"""
## Schätzung der Varianz

Jetzt kommen wir endlich zu dem komischen Faktor $\frac{1}{n-1}$ bei der Schätzung der Varianz.

Wir hatten schon immer definiert, dass
```math
\hat{\text{var}} =  \hat{\sigma^2} = \frac{1}{n-1} \left( \sum_i X_i^2 - n \bar{X}^2  \right)
```
Der Erwartungswert davon ist
```math
\mathcal{E}\left<\hat{\sigma^2}  \right> = \frac{1}{n-1} \left( \sum_i \mathcal{E}\left<X_i^2\right> - n \mathcal{E}\left<\bar{X}^2\right>  \right)
```
Wir nehmen an, dass $\mathcal{E}\left<X_i  \right> = 0$. Falls das nicht der Fall sein sollte, könnten wir immer die $X_i$  verschieben, ohne die Varianz zu ändern. Damit ist  $\mathcal{E}\left<X_i^2  \right> = \sigma^2$ und  $\mathcal{E}\left<\bar{X}^2  \right> = \sigma^2/n$. Insgesamt bekommen wir
```math
\mathcal{E}\left<\hat{\sigma^2}  \right> = \frac{1}{n-1} \left( \sum_i \mathcal{E}\left<X_i^2\right> - n \mathcal{E}\left<\bar{X}^2\right>  \right)
= \frac{1}{n-1} \left( n \sigma^2 - n \frac{1}{n}\sigma^2 \right) = \sigma^2
```
"""

# ╔═╡ e5af4b30-e6a5-4f40-94c3-6e5cb878a9c4
md"""
Die mit dem Faktor $\frac{1}{n-1}$ definierte (empirische) Varianz $\hat{\sigma}$ ist also ein erwartungstreuer Schätzer der Varianz $\sigma$ einer Verteilung. Der Vor-Faktor ist notwendig, um bias free zu sein. Dies ist unabhängig von der Verteilung, aus der die $X_i$ gezogen sind. Über die haben wir hier keine Annahme gemacht.

Im nächsten Kapitel werden wir das aus dem Gesichtspunkt der Freiheitsgrade noch einmal betrachten. Bei $n$ Messwerten haben wir $n$ Freiheitsgarde. Einen davon verbrauchen wir zur Bestimmung des Mittelwerts $\mu$. Damit sind nur noch $n-1$ übrig, die in die Varianz eingehen.
"""

# ╔═╡ 3264f3db-450b-4000-ac29-2637c7354f9a
md"""
# Maximum Likelihood Methode

Schätzer liefern als einen Schätzwert für den Parameter einer Wahrscheinlichkeitsverteilung auf Basis von gegebenen Messwerten. Aber wie kommt man an einen Schätzer, wenn es nicht gerade der Mittelwert ist? Dieses Problem löst die Maximum Likelihood Methode (ungefähr 'Methode der größten Plausibilität'). Wie wir weiter unten sehen werden ist sie die Basis für die Bestimmung von Modell-Parameter über 'kleinste Quadrate', aber vielfältiger bzw. mit weniger Voraussetzungen einsetzbar.
"""

# ╔═╡ 655f1aa1-7397-45c5-973e-6a690f9807ff
md"""
Wir folgen hier dem **Beispiel** von Stahel, Kapitel 7.4. Wir führen ein Experiment durch, werfen eine Münze o.ä. Dies gelingt mit einer Wahrscheinlichkeit $p$. Wir führen das so oft durch, bis es einmal misslingt. Die Wahrscheinlichkeit, dass es nach dem Versuch $x$ misslingt ist geometrisch verteilt, also
```math
P\left<X=x\right> = (1-p)\, p^x
```
Wenn wir feststellen, dass der Versuch nach $x=3$ geglückten Durchgängen zum erstem mal misslungen ist, was können wir dann über $p$ sagen?
"""

# ╔═╡ af361979-28e4-467c-aa46-be1891c7b6b8
md"""
Die Idee ist, die Rolle von Parameter $p$ und Variable $x$ zu vertauschen. Wir betrachten also $x$ als Parameter, schließlich kennen wir $x=$, und $p$ als freie Variable. In der folgenden Grafik folgen wir also einer Zeile konstanten $x$. Der plausibelste Wert von $p$ ist der, der die Wahrscheinlichkeit $P$ maximiert, bei gegebenen $x$. Das kann man in diesem Fall analytisch tun,
```math
\hat{p} = \frac{x}{x+1}
```
ist aber auch sonst immer numerisch möglich.
"""

# ╔═╡ 6d96d826-b9ed-4ac3-a81b-37b0930932ee
let
	p = range(0, 1; length=100)
	xs = range(0, 10)
	
	plot3d()
	for x in xs
		wk = @. ((1 - p) * p^x)
		plot3d!(x .+ zeros(size(p)), p, wk)
	end
	plot3d!(xlabel="x", ylabel="p", zlabel="Wahrscheinlichkeit",legend=false)
end

# ╔═╡ fa903c76-bdb8-4cab-9933-485998b5279f
md"""
Das geht natürlich nicht nur mit einem Messwert $x$, sondern auch wenn mehrere $x_i$ gemessen wurden. Dann müssen wir die Gesamt-Plausibilität als Funktion des Parameters $\theta$ maximieren, also
```math
P_\theta\left<X_1=x_1, X_2=x_2, \dots X_n=x_n \right> = \prod p_\theta\left<x_i\right>
```
Das wird einfacher, wenn man auf beiden Seiten den Logarithmus zieht. So erhält man die Log-Likelihood-Funktion $L$
```math
L\left<x_1, x_2 \dots x_n ; \theta \right> = \sum \ln p_\theta\left<x_i\right>
```
Wir maximieren also  $L\left<x_1, x_2 \dots x_n ; \theta \right> $ durch Variation des Parameter(-Satzes) $\theta$. Das gefundene $\theta$ ist dann der plausibelste Parameter, der die gemessenen $x_i$ beschreibt.
"""

# ╔═╡ 55ba0ba0-96d0-4248-82fb-f9b8509fa0b8
md"""
## Bsp: Photonen zählen

Betrachten wir als Beispiel einen sehr schwachen Laserstrahl. Wir messen in $n$ aufeinander folgenden Zeit-Intervallen die Zahl der Photonen $x_i$ und wollen daraus den Mittelwert $\lambda$ der zugrundeliegenden Poisson-Verteilung bestimmen.
"""

# ╔═╡ bcef0d0b-45eb-4866-84eb-4b0444afdd2b
begin
	n = 3
	λ_true = 5
	data = rand(Poisson(λ_true), n)

	# calcluate pdf  at given λ for each element of 'data' and sum log values
	L(λ_est) = sum(log.(pdf.(Poisson(λ_est), data))) 
	
	λ_est_range = range(0,2 * λ_true; length=1000)
	plot(λ_est_range, @. L(λ_est_range); legend=false, 
		xlabel="λ estimated", ylabel="log likelihood")

	res = Optim.optimize(x -> -1 .* L(x), 0, 1e3) # minimize -L
	scatter!([res.minimizer], [-1 .* res.minimum]) # mark maximum
end

# ╔═╡ abf2f5d6-7ea8-4752-8a80-9ad66670e458
md"""
Natürlich ist in diesem Fall der Mittelwert auch ein guter Schätzer.
"""

# ╔═╡ 2249131d-b137-486d-a9d3-503a1bd6876e
mean(data), res.minimizer

# ╔═╡ 91a2d24f-b139-4f61-9609-1618d491b68e
md"""

### Lineare Regresssion bei Poisson-Verteilung

Eine Stärke der Maximum-Likelihood Methode ist, dass auch andere Verteilungen als die Normalverteilung verwendet werden können, beispielsweise die Poisson-Verteilung. Unser Modell sei weiterhin $y_0 = a + b \, x$, aber die Wahrscheinlichkeit, einen Wert $y_i$ zu finden folge einer Poisson-Verteilung mit $\lambda = y_0 = a + b \, x$, also
```math
 P_i = \frac{\lambda^{y_i}}{y_i !} \exp ( - \lambda) = \frac{(a + b x_i)^{y_i}}{y_i !} \exp ( - (a + b x_i)) \quad.
```
Damit wird 
```math
\mathcal{L}(a,b) = \sum \left(y_i \log (a + b x_i) \right) -
 \sum \left(a + b x_i \right) + \text{const.}
```
Diese Funktion wird maximal, wenn 
```math
\begin{aligned}
N  &=& \sum \frac{y_i}{a + b x_i} \\
\sum x_i &=&  \frac{x_i \, y_i}{a + b x_i}
\end{aligned}
```
gleichzeitig erfüllt sind. Eine Lösung für $a$, $b$ findet sich nur numerisch.

"""

# ╔═╡ c001f17b-7a94-433c-8fee-d4e4975e5e0c
md"""
# Methode der kleinsten Quadrate

Wir hatten schon im Kapitel zur beschreibenden Statistik die Methode der kleinsten Quadrate erwähnt. Man kann ein Modell an Daten anpassen, indem man die Parameter des Modells so variiert, dass die Summe der quadratischen Abweichung zwischen Modell und Daten minimal wird. Bei gegebenen $x_i$ und gemessenen $y_i$ sucht man also Parameter $\theta$ eines Modells $y = f(x_i; \theta)$ so dass
```math
\text{Summe der Residuen} = \sum_i \left( y_i - f(x_i; \theta) \right)^2
```
minimal wird.
"""

# ╔═╡ 6860ac98-2744-4889-a477-f9f9137c2221
md"""
Warum funktioniert das? Die Begründung liefer die Maximum Likelihood Methode. Aus dieser Sichtweise beschreibt das Modell $f(x_i; \theta)$ den Erwartungswert einer Normalverteilung mit der Standardabweichung $\sigma$, die für alle Messpunkte identisch ist. Die Wahrscheinlichkeit, einen Wert $y_i$ zu messen, obwohl das Modell doch $f(x_i; \theta)$ vorhersagt, ist also
```math
p_\theta(x_i) = c \, e^{- \frac{(y_i - f(x_i; \theta))^2}{\sigma^2}}
```
Der Vorfaktor $c$ normiert die Verteilung, ist aber für alle $i$ identisch, so dass wir ihn bei der Optimierung vernachlässigen können. Die Log-Likelihood Funktion ist dann
```math
L\left<x_1, x_2 \dots x_n ; \theta \right> = \sum \ln p_\theta\left<x_i\right>
=  - \frac{c}{\sigma^2} \, \sum_i (y_i - f(x_i; \theta))^2 
```
Wir maximieren $L$, minimieren also die Summe der Residuen. Die Methode der kleinsten Quadrate ist also die Maximum Likelihood Methode unter der Annahme einer Normalverteilung der (konstanten) Messunsicherheit.
"""

# ╔═╡ 9b612cf5-0c99-4e70-b070-f7c0e7f7f151
md"""
Die erste Konsequenz ist, dass wir eine variable Messunsicherheit $\sigma_i$ berücksichtigen können, in dem wir 
```math
\text{Summe der gewichteten Residuen} = \chi^2 = \sum_i \frac{\left( y_i - f(x_i; \theta) \right)^2}{\sigma_i^2}
```
minimieren.
"""

# ╔═╡ 5f5e0319-a22b-41f9-bc29-058645411b1d
md"""
Die zweite Konsequenz ist, dass wir die Verteilung der Messunsicherheit im Auge behalten müssen. Sollte es begründete Zweifel an deren Normalverteilung geben, dann sollte man von der Methode der kleinsten Quadrate Abstand nehmen und direkt die Maximum Likelihood Methode anwenden. Dies ist beispielsweise der Fall, wenn ein Modell an Photonenzahlen angepasst werden soll, und die typischen Photonenzahlen unterhalb von ungefähr 10 liegen. Deren Fehler ist dann gerade Poisson-verteilt.
"""

# ╔═╡ f7d16791-425b-42c3-bffb-45518dc88d79
md"""
## Bsp. Modell an Photonen-Zahlen anpassen

Beim [zeitkorrelierten Einzelphotonenzählen](https://de.wikipedia.org/wiki/Zeitkorrelierte_Einzelphotonenz%C3%A4hlung) bestimmt man die Anzahl an detektierten Fluoreszenz-Photonen eines Moleküls als Funktion des zeitlichen Abstands zum anregenden Laserpuls. Typische Abstände liegen im Bereich von einer Nanosekunde und sind durch die Lebenszeit des angeregten Zustands im Molekül bestimmt. Die Idee ist, diesen dadurch zu bestimmen. Man findet einen exponentiellen Abfall der Zählereignisse mit dem zeitlichen Abstand zur Anregung. Die Zerfallskonstante ist gerade die Lebenszeit des Zustands.

Das Modell ist also
```math
f(t; \tau, c_{fl}, c_{bg}) = c_{fl} \, e^{- t / \tau} + c_{bg}
```
wobei $t$ die Zeit zwischen Laserpuls und Detektion des Photons ist und $\tau$ die Lebenszeit des angeregten Zustands beschreibt. Die beiden $c_i$ bestimmen den Helligkeit des Moleküls und die des Untergrunds, beispielsweise aufgrund von Raumlicht oder der Dunkelzählrate des Detektors.

Die gemessene Photonenzahl in einem Intervall $[t, t+dt]$ ist also Poisson-Verteilt um einen Mittelwert, der durch $f$ gegeben ist.
"""

# ╔═╡ 1868b86a-c26e-4f76-b6d2-9c1143159bd9
begin
	t = range(0, 10; step= 0.1)
	
	f(t, τ, c_fl, c_bg) = c_fl * exp(- t / τ) + c_bg
	f(p::Vector) = f.(t, p[1], p[2], p[3])
	
	p_model = [2, 10, 2]
	data_p = rand.(Poisson.(f(p_model)))

	lower = zeros(size(p_model))
	upper = 1 ./ lower # = inf
	initial = ones(size(p_model))
	
	L(p::Vector) = -1 .* sum(log.(pdf.(Poisson.(f(p)),data_p)))
	res_MLE = optimize(L,  lower, upper, initial, Fminbox(NelderMead()))
	
	chisq(p::Vector) = sum((data_p .- f(p)).^2 )
	res_quadrate = optimize(chisq,  lower, upper, initial, Fminbox(NelderMead()))
	
	plot(t, f(p_model), yaxis=:log10, label="ideal model")
	plot!(t, map(x -> iszero(x) ? NaN : x, data_p), # clip zero values for log plot
		yaxis=:log10, xlabel="delay time t", ylabel="counts / intervall", label="data")
	plot!(t, f(res_quadrate.minimizer), yaxis=:log10, label="chisq model")
	plot!(t, f(res_MLE.minimizer), yaxis=:log10, label="MLE model")
end

# ╔═╡ 3dc0acfb-c45a-4f4c-a91e-b4be3aa07bf9
res_quadrate.minimizer

# ╔═╡ 6a7e4c76-82ab-45d1-96ba-aac67308d289
res_MLE.minimizer

# ╔═╡ 09c25e45-55c5-458e-a867-d901eb9b64a8
md"""
Da hatte ich den Unterschied dramatischer in Erinnerung
"""

# ╔═╡ f52a564f-af2c-4be1-81e8-7124c2339bea
md"""
# Intervallschätzung

Mit der Punktschätzung haben wir den plausibelsten Wert des Parameters gefunden, der die Verteilung beschreibt, aus der unsere Messdaten gezogen wurden. Nun geht es um die Frage, welche anderen Werte dieser Parameter auch noch annehmen könnte. Wir sind also auf der Suche nach einem Intervall, in dem der wirkliche Parameter dann mit einer gewissen Wahrscheinlichkeit liegen wird. Dieses Intervall nennt man **Konfidenzintervall**.
"""

# ╔═╡ c5b024ed-11c4-4f01-a7f3-00ee90069cef
md"""
## Bsp. geometrische Verteilung
"""

# ╔═╡ 0a9bdba3-ee54-48fb-9c2b-2efc9f305385
md"""
Betrachten wir noch einmal als Beispiel die geometrische Verteilung von oben. Mit der Wahrscheinlichkeit $p$ gelingt ein Versuch, nach $x$ Versuchen tritt zum ersten mal ein Misserfolg auf. Die Wahrscheinlichkeit für einen Misserfolg nach $x$ Versuchen ist also 
```math
P\left<X=x\right> = (1-p)\, p^x
```
Wir messen einen Misserfolg nach $x=3$ versuchen. Wie oben gesehen ist der plausibelste Parameter 
```math
\hat{p} = \frac{x}{x+1} = \frac{3}{4}
```
Wir suchen eine untere ($p_u$) und obere ($p_o$) Intervallgrenze, die jeweils eine Funktion des gemessenen Wertes $x$ ist, so dass der wahre Parameter $p$ mit 95% Wahrscheinlichkeit in diesem Intervall liegt, also 
```math
\mathcal{P}\left< p_u(x) < p < p_o(x) \right> = 0.95
```
unabhängig vom wahren $p$ und ggf. auch anderen Parametern der Verteilung. Das Gleichheitszeichen wird manchmal als 'gleich oder etwas größer' interpretiert. Insbesondere bei diskreten Verteilungen ist ein Gleichheit nicht zu erreichen.
"""

# ╔═╡ 86619b3f-3284-4f76-acbf-a196bb072433
md"""
Man kann die Intervallgrenze auf verschiedenem Weg bekommen, siehe bspw. [wikipedia](https://en.wikipedia.org/wiki/Confidence_interval). Hier folgen wir wiederum Stahel und benutzen ein Ergebnis aus dem Test von Hypothesen. Ohne das hier näher zu begründen drehen wir wieder Variable und Parameter um. Wir wählen die obere Grenze des Intervalls so, dass unser Messwert $x$ auf der *unteren* 2.5%-Perzentil liegt, also  
```math
P_{p_o}\left<X \le x\right> = 2.5 \%
```
Die kumulative Dichtefunktion beträgt also $0.025$ bzw $1 - 0.025$ an der unteren bzw oberen Intervallgrenze. In Julia finden wir diese Grenz-Parameter über eine Nullstellensuche:
"""

# ╔═╡ 5dc9be6a-54da-49b8-8cf5-87567bc6563c
function grenzen(x)
	# in Julia, p is defined as (1-p) compared to our eq. above ...
	# seach for p, so that cdf crosses 2.5% 
	r = optimize(p -> (cdf(Geometric(1-p), x) -  0.025).^2, 0, 1)
	oben = r.minimizer
	if (x >= 1)
		r = optimize(p -> (cdf(Geometric(1-p), x-1) -  (1- 0.025)).^2, 0, 1)
		unten = r.minimizer
	else
		unten = 0
	end
	return unten, oben
end;

# ╔═╡ 09e27d74-c105-425c-b49f-9f2465fe663c
grenzen(3)

# ╔═╡ 8ab6a87e-5666-472f-8030-273ced222459
md"""
Testweise summieren wir die Wahrscheinlichkeiten für die Fälle $0-3$ bzw. $3-\infty$ erfolgreiche Versuche bei dem gegebenen $p_u$ und $p_o$, um sicherzugehen, dass jeweils 2.5% außerhalb liegen.
"""

# ╔═╡ 30fd1867-c9aa-468e-b7cb-9531e9471831
let
	xm = 3
	(plow, phigh) = grenzen(xm)  
	wk_below = sum([pdf.(Geometric(1-plow) ,x) for x = (xm:20)])
	wk_high =  sum([pdf.(Geometric(1-phigh),x)  for x = (0:xm)])	
	wk_below, wk_high
end

# ╔═╡ d598adfa-2b05-4a53-bf6d-f1e58ea271cd
md"""
Dies sind die drei charakteristischen Verteilungen, wenn wir $x=3$ gemessen haben. Die Plausibelste ist die mit $p=3/4$, die anderen beiden sind die Grenzfälle.
"""

# ╔═╡ c3e717bf-acaa-4ea7-8bff-01853fdf8a58
let
	xm = 3
	(plow, phigh) = grenzen(xm)  
	plikely = xm ./ (xm +1)

	xr = 6;
	xs = range(0, xr)
 
	groupedbar( [pdf.(Geometric(1-p),x) for x in xs, p in [plow, plikely, phigh]] , xticks=(1:xr+1, string.(0:xr)), xlabel="x", label = ["low" "likely" "high"])	
end

# ╔═╡ d38d7b54-bec0-48b5-a897-2393a365c1c7
md"""
Als Funktion des gemessenen $x$ sieht das Intervall so aus
"""

# ╔═╡ e323af6a-2e7b-4fca-af22-a72989da9d4c
let
	xs = range(1,10)
	plot([grenzen(x)[1] for x in xs], label="untere Grenze")
	plot!([grenzen(x)[2] for x in xs], label="obere Grenze")
	plot!([x / (x+1) for x in xs], label="wahrscheinlichste", xlabel="gemessenes x", ylabel="p",legend=:bottomright)
end

# ╔═╡ e8907f01-43c0-4742-a3d0-f0b87aa1c323
md"""
## Test der Intervallgrenzen
"""

# ╔═╡ 320ae62b-f132-4898-a2ab-3bd20a7de7f3
md"""
Lassen sie uns das noch einmal andersrum betrachten. Wir geben uns eine geometrische Verteilung mit bekanntem $p$ vor, ziehen daraus eine Zufallszahl $x$ und schätzen aufgrund dieser Zahl die Grenzen des Konfidenzintervalls. In 95% der Fälle müsste unser vorgegebenes $p$ in diesem Intervall liegen, in 5% der Fälle nicht.
"""

# ╔═╡ 7b74afe2-eafd-4db0-8f1f-a8e123c40d6f
let
	p_true = 0.75
	n = 10000
	data = rand(Geometric(1-p_true), n)
	grenz = [grenzen(x) for x in data]
	n_innerhalb= count(g -> (g[1] < p_true < g[2]), grenz) 
	p_ausserhalb = 1 - n_innerhalb/n
end

# ╔═╡ 616fc902-e302-45b9-b184-e9035d7e780c
md"""
Unsere Intervallgrenzen sind etwas zu groß. Zu selten liegt der wahre Wert außerhalb der Grenzen. Dies ist ein Problem bei diskreten Verteilungen. Hier sind die Messwerte diskret,und damit notgedrungen  auch die berechneten Grenzen des Konfidenzintervalls. Dadurch kann man die Wahrscheinlichkeit nicht exakt auf den gewünschten Wert einstellen.
"""

# ╔═╡ 3a9a738f-8e7f-437e-9410-067121f00c0e
md"""
## Normalverteilung

Wenn man die Verteilungsfunktion kennt, kann man die Grenzen des Konfidenzintervalls wie oben gezeigt berechnen. Oft ist die Verteilung eine Normalverteilung. Dies nimmt man notfalls auch an, wenn man es nicht besser weiss.

Im ersten Kapitel hatten wir uns schon die Integrale über $[\mu - n \sigma, \mu + n \sigma]$ angeschaut
"""

# ╔═╡ d4b47ed9-4082-4732-97ef-39500584eaaa
[cdf(Normal(0, 1), n) - cdf(Normal(0, 1), -n) for n in (1,2,3)]

# ╔═╡ 3eed2b8a-c56f-45c6-b796-b7e0f8d69a1e
md"""
Ein $\pm\2\sigma$-Intervall beinhaltet also 95.45% der Fälle. Eigentlich suchen wir ja ein Intervall mit genau 95%. Das liegt aber in der Nähe, nämlich bei $\pm 1.96 \sigma$, siehe den 'Minimizer' hier
"""

# ╔═╡ b1c45b8b-8818-4417-afa3-dc4f207b44a6
optimize( n -> ( cdf(Normal(0, 1), n) - cdf(Normal(0, 1), -n) - 0.95).^2, 0,3)

# ╔═╡ 4c426122-22bc-4ccf-ac1c-ffe3f1ee68fc
md"""
Ein Problem ist hier, dass die Standardabweichung $\sigma$ hier die **wahre** Standardabweichung ist. Wir kennen aber typischerweise nur eine **geschätzte** Standardabweichung, die wir auf Grundlage unserer Messwerte schätzen müssen. Diesen zusätzlichen Faktor diskutieren wir im nächsten Kapitel.
"""

# ╔═╡ 2124df9e-9c06-46da-acc0-299ff9854e45
md"""
## Bsp. Gauß'sche Fehlerrechnung

Die Gauß'sche Fehlerrechnung kann als Methode der Intervallschätzung gesehen werden. Wir haben mehrere Messwerte $y_i$ an Stellen $x_i$, die wir durch ein Modell $f(x; p_j)$ mit den Parametern $p_j$ beschreiben wollen. Wir finden die $p_j$, indem wir die quadratische Abweichung minimieren, also nach den $p_j$ ableiten und Null setzen, also
```math
\frac{\partial}{\partial p_j} \sum_i (y_i - f(x_i; p_k))^2 = 0
```
So erhalten wir ein Gleichungssystem zur Bestimmung der $p_j$, das wir lösen.
"""

# ╔═╡ 91d436f1-166a-4d08-b376-2f365b56bece
md"""
Das Konfidenzintervall um diese optimalen $p_j$ erhalten wir durch Gauß'sche Fehlerfortpflanzung durch dieses Gleichungssystem: Die Unsicherheit $\sigma_j$ im Paramter $p_j$ ist die partielle Ableitung des Parameters nach allen Messwerten $y_i$ multipliziert mit deren Unsicherheit $\sigma_i$, und alles quadratisch addiert, also
```math
\sigma_j^2 = \sum_i \sigma_i^2 \left(  \frac{\partial p_j}{\partial y_i} \right)^2
```
Dabei haben wir die Bestimmungsgleichung für die $p_j$ in der Nähe der optimalen $p_j$ linearisiert, weil nur die erste Ableitung eingeht.
"""

# ╔═╡ 050f5698-8419-422a-b0ff-5cca01881e64
md"""
Als Beispiel betrachetn wir jetzt eine Gerade
```math
y = a + b x
```

Die Koeffizienten werden bestimmt über
```math
\hat{b} = cor_{xy} \,  \frac{\sigma_y}{\sigma_x}  \quad \text{und} \quad
	\hat{a} = \bar{y} - \hat{b} \bar{x} 
```
wobei $\sigma_x$ bzw.  $\sigma_y$ die Standardabweichung über alle Werte $x_i$ bzw. $y_i$ ist und $cor_{xy}$ der Korrealtions-Koeffizient (siehe auch Kapitel 2).

Unter der Annahme von identischen Unsicherheiten in allen Messwerten ist ein guter Schätzer der Unsicherheit des einzelnen Messpunkts die mittlere quadratische Abweichung zum Modell, also
```math
\hat{\sigma} = \frac{1}{N-2} \sum_i \left( y_i - (\hat{a} + \hat{b} x_i) \right)^2
```
Die 2 in $N-2$ stammt von den zwei durch $\hat{a}$ und $\hat{b}$ verbrauchten Freiheitsgarden der Messung, analog zur Schätzung der Standardabweichung oben.

Damit bekommt man durch Fehlerfortpflanzung (siehe Bevington Kap 6.4 und Stahel Kap. 13.2)
```math
\hat{\sigma_a} = \hat{\sigma} \, \sqrt{\frac{\sum x_i^2}{\Delta}}
\quad \text{und} \quad
\hat{\sigma_b} = \hat{\sigma} \,  \sqrt{\frac{N}{\Delta}} =  \frac{\hat{\sigma}}{\sigma_x} \,  \frac{1}{\sqrt{ N-1}} 
```
mit $\Delta = \sigma_x^2 \,  N (N-1)$.

In Julia ist das
"""

# ╔═╡ ed9157d6-ca3c-4440-9b68-e6954999e231
let
	a_true = 1
	b_true = 2
	σ_true = 1
	x = range(1, 20)
	N = length(x)
	y_true = a_true .+ b_true .* x
	y = rand(Normal(0, σ_true), N) .+ y_true

	# estimate (a,b) from data
	b = cor(x,y) * std(y)  / std(x)
	a = mean(y) - b * mean(x)
	y_fit = a .+ b .* x

	# estimate σ, Bevington eq. 6.15
	σ = sqrt(sum( (y .- (a .+ b.* x)).^2)  / (N + 2))

	# estimate σ_a, σ_b, Bevington eq. 6.23
	d = std(x)^2 * N * (N-1)
	σ_a = σ * sqrt(sum(x.^2) / d)
	σ_b = σ * sqrt( N / d )

	#plot everything
	scatter(x,y)
	plot!(x, y_fit, legend=false)
	annotate!(10,10, "a: $(a_true) vs. $(round(a, digits=2)) +- $(round(σ_a, digits=2))")
	annotate!(10,7, "b: $(b_true) vs. $(round(b, digits=2)) +- $(round(σ_b, digits=2))")
end

# ╔═╡ bbd7467e-7f68-4446-b6aa-90730f8eb497
md"""
## Bedingung an $\chi^2$ 

Wir hatten oben gesehen, dass die Summe der gewichteten Residuen $\chi^2$ 
```math
\chi^2 = \sum_i \frac{(y_i - f(x_i; p))^2}{\sigma_i^2}
```
minimal wird für die wahrscheinlichsten Parameter $p$. Der Erwartungswert für dieses Minimum ist die Anzahl der Freiheitsgrade $\nu$ der Messung (Bevington, Kap. 4.4)
```math
\mathcal{E}(\chi^2) = \nu = n - n_c
```
wobei die Messung $n$ Datenpunkte umfasst und $n_c$ Parameter im Modell verwendet ('verbraucht') wurden. Manchmal definiert man 
```math
\chi_\nu^2 = \chi^2 / \nu \quad \text{mit} \quad \mathcal{E}(\chi_\nu^2) =1 
```
"""

# ╔═╡ a396e3c3-8082-404c-9d42-46aa77444ba5
md"""
Wie ändert sich $\chi^2$ mit den Parametern $p_j$? Die erste Ableitung ist nach Definition Null. Die zweite ist verknüpft mit der Unsicherheit $\sigma_j$ im Parameter $p_j$ (aus der Verbindung zur Log-Likelihood-Funktion $\mathcal{L}$, Bevington, eq. 8.10)
```math
\frac{\partial^2 \chi^2}{\partial p_j^2} = \frac{2}{\sigma_j^2}
```
bzw
```math
 \sigma_j^2 = \left( \frac{\partial^2 \mathcal{L}(p_j)}{\partial p_j^2} \right)^{-1}
```
oder andersherum
```math
 \mathcal{L}(p_j \pm \sigma_j) =  \mathcal{L}(p_j) - \frac{1}{2} 
```
Bei mehr als einem Parameter stellt die Kontur bei  $\mathcal{L}_{\text{max}} - 1/2$ also auch die Kovarianz der Unsicherheit in den  Parametern dar.
"""

# ╔═╡ 783b2d7a-f937-4bf9-a15c-380078bb27cc
md"""
## Bootstrapping

Wenn eine Normalverteilung der Unsicherheit nicht angenommen werden kann, beispielsweise bei Poisson-Verteilungen mit $\lambda < 10$, dann ist 'bootstrapping' die Lösung. Wikipedia schreibt 'selten auch Münchhausen-Methode genannt', aber genau das ist die Idee. Man zieht sich an den Haaren aus dem Sumpf!

Wir haben einen Datensatz aus $N$ Messwerten, die wir in $n$ Intervalle eines Histogramms einsortieren und mit unserem Modell des Histogramms vergleichen wollen. Histogramm-Balken-Höhen sind gezählte Ereignisse, also Poisson-verteilt. Wir passen an unser Histogramm ein Modell mittels der Maximum-Likelihood Methode an und bestimmen so die Parameter. Um die Unsicherheit in den Parametern zu bestimmen, erzeugen wir einen neuen Datensatz aus dem alten, originalen ('an dem Haaren aus dem Sumpf!'). Dazu ziehen wir zufällig  $N$ Werte aus dem originalen Datensatz *mit Zurücklegen*. Einzelne originale Messwerte können also mehrfach im neuen Datensatz vorkommen, aber der Gesamtumfang bleibt $N$. An diesen neuen Datensatz passen wir unser Modell wieder an und bestimmen wieder die Parameter. Dies wiederholen wir so oft, dass wir glauben, den zentralen Grenzwertsatz zu erfüllen, z.B. 100-mal. Die Unsicherheit der Parameter ergibt sich aus der Standardabweichung der Verteilung der so ermittelten 100 Varianten der Parameter. Details finden sich z.B. in Bevington & Robinson: Data reduction and error analysis, oder in Press et al. Numerical Recipes.

"""

# ╔═╡ 959d1081-f82d-4070-8fef-3aab85cfe440
TableOfContents(title="Inhalt")

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Distributions = "31c24e10-a181-5473-b8eb-7969acd0382f"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
Optim = "429524aa-4258-5aef-a3af-852621145aeb"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
StatsBase = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
StatsPlots = "f3b207a7-027a-5e70-b257-86293d7955fd"

[compat]
Distributions = "~0.25.80"
Optim = "~1.7.4"
Plots = "~1.38.3"
PlutoUI = "~0.7.49"
StatsBase = "~0.33.21"
StatsPlots = "~0.15.4"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.5"
manifest_format = "2.0"
project_hash = "0689bdc29f1d586804c82c99cbfcb6591370f477"

[[deps.AbstractFFTs]]
deps = ["ChainRulesCore", "LinearAlgebra"]
git-tree-sha1 = "69f7020bd72f069c219b5e8c236c1fa90d2cb409"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.2.1"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "0310e08cb19f5da31d08341c6120c047598f5b9c"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.5.0"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Arpack]]
deps = ["Arpack_jll", "Libdl", "LinearAlgebra", "Logging"]
git-tree-sha1 = "9b9b347613394885fd1c8c7729bfc60528faa436"
uuid = "7d9fca2a-8960-54d3-9f78-7d1dccf2cb97"
version = "0.5.4"

[[deps.Arpack_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "OpenBLAS_jll", "Pkg"]
git-tree-sha1 = "5ba6c757e8feccf03a1554dfaf3e26b3cfc7fd5e"
uuid = "68821587-b530-5797-8361-c406ea357684"
version = "3.5.1+1"

[[deps.ArrayInterfaceCore]]
deps = ["LinearAlgebra", "SnoopPrecompile", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "e5f08b5689b1aad068e01751889f2f615c7db36d"
uuid = "30b0a656-2188-435a-8636-2ec0e6a096e2"
version = "0.1.29"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.AxisAlgorithms]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "WoodburyMatrices"]
git-tree-sha1 = "66771c8d21c8ff5e3a93379480a2307ac36863f7"
uuid = "13072b0f-2c55-5437-9ae7-d433b7a33950"
version = "1.0.1"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BitFlags]]
git-tree-sha1 = "43b1a4a8f797c1cddadf60499a8a077d4af2cd2d"
uuid = "d1d4a3ce-64b1-5f1a-9ba4-7e7e69966f35"
version = "0.1.7"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "CompilerSupportLibraries_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
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
git-tree-sha1 = "c6d890a52d2c4d55d326439580c3b8d0875a77d9"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.15.7"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "844b061c104c408b24537482469400af6075aae4"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.5"

[[deps.Clustering]]
deps = ["Distances", "LinearAlgebra", "NearestNeighbors", "Printf", "Random", "SparseArrays", "Statistics", "StatsBase"]
git-tree-sha1 = "64df3da1d2a26f4de23871cd1b6482bb68092bd5"
uuid = "aaaa29a8-35af-508c-8bc3-b662a17a0fe5"
version = "0.14.3"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "9c209fb7536406834aa938fb149964b985de6c83"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.1"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Random", "SnoopPrecompile"]
git-tree-sha1 = "aa3edc8f8dea6cbfa176ee12f7c2fc82f0608ed3"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.20.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "600cc5508d66b78aae350f7accdb58763ac18589"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.10"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "fc08e5930ee9a4e03f84bfb5211cb54e7769758a"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.10"

[[deps.CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

[[deps.Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "00a2cccc7f098ff3b66806862d275ca3db9e6e5a"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.5.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.1+0"

[[deps.ConstructionBase]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "fb21ddd70a051d882a1686a5a550990bbe371a95"
uuid = "187b0558-2788-49d3-abe0-74a17ed4e7c9"
version = "1.4.1"

[[deps.Contour]]
git-tree-sha1 = "d05d9e7b7aedff4e5b51a029dced05cfb6125781"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.2"

[[deps.DataAPI]]
git-tree-sha1 = "e8119c1a33d267e16108be441a287a6981ba1630"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.14.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "d1fff3a548102f48987a52a2e0d114fa97d730f0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.13"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.DataValues]]
deps = ["DataValueInterfaces", "Dates"]
git-tree-sha1 = "d88a19299eba280a6d062e135a43f00323ae70bf"
uuid = "e7dc6d0d-1eca-5fa6-8ad6-5aecde8b7ea5"
version = "0.4.13"

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

[[deps.DiffResults]]
deps = ["StaticArraysCore"]
git-tree-sha1 = "782dd5f4561f5d267313f23853baaaa4c52ea621"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.1.0"

[[deps.DiffRules]]
deps = ["IrrationalConstants", "LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "c5b6685d53f933c11404a3ae9822afe30d522494"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.12.2"

[[deps.Distances]]
deps = ["LinearAlgebra", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "3258d0659f812acde79e8a74b11f17ac06d0ca04"
uuid = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
version = "0.10.7"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Distributions]]
deps = ["ChainRulesCore", "DensityInterface", "FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SparseArrays", "SpecialFunctions", "Statistics", "StatsBase", "StatsFuns", "Test"]
git-tree-sha1 = "74911ad88921455c6afcad1eefa12bd7b1724631"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.80"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.DualNumbers]]
deps = ["Calculus", "NaNMath", "SpecialFunctions"]
git-tree-sha1 = "5837a837389fccf076445fce071c8ddaea35a566"
uuid = "fa6b7ba4-c1ee-5f82-b5fc-ecf0adba8f74"
version = "0.6.8"

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
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "PCRE2_jll", "Pkg", "Zlib_jll", "libaom_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "74faea50c1d007c85837327f6775bea60b5492dd"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.2+2"

[[deps.FFTW]]
deps = ["AbstractFFTs", "FFTW_jll", "LinearAlgebra", "MKL_jll", "Preferences", "Reexport"]
git-tree-sha1 = "90630efff0894f8142308e334473eba54c433549"
uuid = "7a1cc6ca-52ef-59f5-83cd-3a7055c09341"
version = "1.5.0"

[[deps.FFTW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c6033cc3892d0ef5bb9cd29b7f2f0331ea5184ea"
uuid = "f5851436-0d7a-5f13-b9de-f02708fd171a"
version = "3.3.10+0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FillArrays]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "Statistics"]
git-tree-sha1 = "d3ba08ab64bdfd27234d3f61956c966266757fe6"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "0.13.7"

[[deps.FiniteDiff]]
deps = ["ArrayInterfaceCore", "LinearAlgebra", "Requires", "Setfield", "SparseArrays", "StaticArrays"]
git-tree-sha1 = "04ed1f0029b6b3af88343e439b995141cb0d0b8d"
uuid = "6a86dc24-6348-571c-b903-95158fe2bd41"
version = "2.17.0"

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

[[deps.ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions", "StaticArrays"]
git-tree-sha1 = "a69dd6db8a809f78846ff259298678f0d6212180"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.34"

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

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "d972031d28c8c8d9d7b41a536ad7bb0c2579caca"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.8+0"

[[deps.GR]]
deps = ["Artifacts", "Base64", "DelimitedFiles", "Downloads", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Preferences", "Printf", "Random", "Serialization", "Sockets", "TOML", "Tar", "Test", "UUIDs", "p7zip_jll"]
git-tree-sha1 = "9e23bd6bb3eb4300cb567bdf63e2c14e5d2ffdbc"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.71.5"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "aa23c9f9b7c0ba6baeabe966ea1c7d2c7487ef90"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.71.5+0"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE2_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "d3b3624125c1474292d0d8ed0f65554ac37ddb23"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.74.0+2"

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
deps = ["Base64", "CodecZlib", "Dates", "IniFile", "Logging", "LoggingExtras", "MbedTLS", "NetworkOptions", "OpenSSL", "Random", "SimpleBufferStream", "Sockets", "URIs", "UUIDs"]
git-tree-sha1 = "37e4657cd56b11abe3d10cd4a1ec5fbdb4180263"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "1.7.4"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.HypergeometricFunctions]]
deps = ["DualNumbers", "LinearAlgebra", "OpenLibm_jll", "SpecialFunctions", "Test"]
git-tree-sha1 = "709d864e3ed6e3545230601f94e11ebc65994641"
uuid = "34004b35-14d8-5ef3-9330-4cdb6864b03a"
version = "0.3.11"

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

[[deps.IniFile]]
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

[[deps.IntelOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d979e54b71da82f3a65b62553da4fc3d18c9004c"
uuid = "1d5cc7b8-4909-519e-a0f8-d0f5ad9712d0"
version = "2018.0.3+2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.Interpolations]]
deps = ["Adapt", "AxisAlgorithms", "ChainRulesCore", "LinearAlgebra", "OffsetArrays", "Random", "Ratios", "Requires", "SharedArrays", "SparseArrays", "StaticArrays", "WoodburyMatrices"]
git-tree-sha1 = "721ec2cf720536ad005cb38f50dbba7b02419a15"
uuid = "a98d9a8b-a2ab-59e6-89dd-64a1c18fca59"
version = "0.14.7"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "49510dfcb407e572524ba94aeae2fced1f3feb0f"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.8"

[[deps.IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLFzf]]
deps = ["Pipe", "REPL", "Random", "fzf_jll"]
git-tree-sha1 = "f377670cda23b6b7c1c0b3893e37451c5c1a2185"
uuid = "1019f520-868f-41f5-a6de-eb00f4b6a39c"
version = "0.1.5"

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

[[deps.KernelDensity]]
deps = ["Distributions", "DocStringExtensions", "FFTW", "Interpolations", "StatsBase"]
git-tree-sha1 = "9816b296736292a80b9a3200eb7fbb57aaa3917a"
uuid = "5ab0869b-81aa-558d-bb23-cbf5423bbe9b"
version = "0.6.5"

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
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "OrderedCollections", "Printf", "Requires"]
git-tree-sha1 = "2422f47b34d4b127720a18f86fa7b1aa2e141f29"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.18"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

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
git-tree-sha1 = "6f73d1dd803986947b2c750138528a999a6c7733"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.6.0+0"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c7cb1f5d892775ba13767a87c7ada0b980ea0a71"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+2"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "3eb79b0ca5764d4799c06699573fd8f533259713"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.4.0+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LineSearches]]
deps = ["LinearAlgebra", "NLSolversBase", "NaNMath", "Parameters", "Printf"]
git-tree-sha1 = "7bbea35cec17305fc70a0e5b4641477dc0789d9d"
uuid = "d3d80556-e9d4-5f37-9878-2ab0fcc64255"
version = "7.2.0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "45b288af6956e67e621c5cbb2d75a261ab58300b"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.20"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LoggingExtras]]
deps = ["Dates", "Logging"]
git-tree-sha1 = "cedb76b37bc5a6c702ade66be44f831fa23c681e"
uuid = "e6f89c97-d47a-5376-807f-9c37f3926c36"
version = "1.0.0"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MKL_jll]]
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "Pkg"]
git-tree-sha1 = "2ce8695e1e699b68702c03402672a69f54b8aca9"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2022.2.0+0"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "42324d08725e200c23d4dfb549e0d5d89dede2d2"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.10"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "MozillaCACerts_jll", "Random", "Sockets"]
git-tree-sha1 = "03a9b9718f5682ecb107ac9f7308991db4ce395b"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.1.7"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.0+0"

[[deps.Measures]]
git-tree-sha1 = "c13304c81eec1ed3af7fc20e75fb6b26092a1102"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.2"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "f66bdc5de519e8f8ae43bdc598782d35a25b1272"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.1.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.2.1"

[[deps.MultivariateStats]]
deps = ["Arpack", "LinearAlgebra", "SparseArrays", "Statistics", "StatsAPI", "StatsBase"]
git-tree-sha1 = "efe9c8ecab7a6311d4b91568bd6c88897822fabe"
uuid = "6f286f6a-111f-5878-ab1e-185364afe411"
version = "0.10.0"

[[deps.NLSolversBase]]
deps = ["DiffResults", "Distributed", "FiniteDiff", "ForwardDiff"]
git-tree-sha1 = "a0b464d183da839699f4c79e7606d9d186ec172c"
uuid = "d41bc354-129a-5804-8e4c-c37616107c6c"
version = "7.8.3"

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "a7c3d1da1189a1c2fe843a3bfa04d18d20eb3211"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.1"

[[deps.NearestNeighbors]]
deps = ["Distances", "StaticArrays"]
git-tree-sha1 = "2c3726ceb3388917602169bed973dbc97f1b51a8"
uuid = "b8a86587-4115-5ab1-83bc-aa920d37bbce"
version = "0.4.13"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Observables]]
git-tree-sha1 = "6862738f9796b3edc1c09d0890afce4eca9e7e93"
uuid = "510215fc-4207-5dde-b226-833fc4488ee2"
version = "0.5.4"

[[deps.OffsetArrays]]
deps = ["Adapt"]
git-tree-sha1 = "82d7c9e310fe55aa54996e6f7f94674e2a38fcb4"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.12.9"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSSL]]
deps = ["BitFlags", "Dates", "MozillaCACerts_jll", "OpenSSL_jll", "Sockets"]
git-tree-sha1 = "6503b77492fd7fcb9379bf73cd31035670e3c509"
uuid = "4d8831e6-92b7-49fb-bdf8-b643e874388c"
version = "1.3.3"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6e9dba33f9f2c44e08a020b0caf6903be540004"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.19+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Optim]]
deps = ["Compat", "FillArrays", "ForwardDiff", "LineSearches", "LinearAlgebra", "NLSolversBase", "NaNMath", "Parameters", "PositiveFactorizations", "Printf", "SparseArrays", "StatsBase"]
git-tree-sha1 = "1903afc76b7d01719d9c30d3c7d501b61db96721"
uuid = "429524aa-4258-5aef-a3af-852621145aeb"
version = "1.7.4"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.PCRE2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "efcefdf7-47ab-520b-bdef-62a2eaa19f15"
version = "10.40.0+0"

[[deps.PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "cf494dca75a69712a72b80bc48f59dcf3dea63ec"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.16"

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Parsers]]
deps = ["Dates", "SnoopPrecompile"]
git-tree-sha1 = "8175fc2b118a3755113c8e68084dc1a9e63c61ee"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.3"

[[deps.Pipe]]
git-tree-sha1 = "6842804e7867b115ca9de748a0cf6b364523c16d"
uuid = "b98c9c47-44ae-5843-9183-064241ee97a0"
version = "1.3.0"

[[deps.Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "1f03a2d339f42dca4a4da149c7e15e9b896ad899"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.1.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "SnoopPrecompile", "Statistics"]
git-tree-sha1 = "c95373e73290cf50a8a22c3375e4625ded5c5280"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.3.4"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "JLFzf", "JSON", "LaTeXStrings", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "Preferences", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "RelocatableFolders", "Requires", "Scratch", "Showoff", "SnoopPrecompile", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "0a3a23e0c67adf9433111467b0522077c596de58"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.38.3"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "eadad7b14cf046de6eb41f13c9275e5aa2711ab6"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.49"

[[deps.PositiveFactorizations]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "17275485f373e6673f7e7f97051f703ed5b15b20"
uuid = "85a6dd25-e78a-55b7-8502-1745935b8125"
version = "0.2.4"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "0c03844e2231e12fda4d0086fd7cbe4098ee8dc5"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+2"

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "de191bc385072cc6c7ed3ffdc1caeed3f22c74d4"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.7.0"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Ratios]]
deps = ["Requires"]
git-tree-sha1 = "dc84268fe0e3335a62e315a3a7cf2afa7178a734"
uuid = "c84ed2f1-dad5-54f0-aa8e-dbefe2724439"
version = "0.4.3"

[[deps.RecipesBase]]
deps = ["SnoopPrecompile"]
git-tree-sha1 = "261dddd3b862bd2c940cf6ca4d1c8fe593e457c8"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.3.3"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase", "SnoopPrecompile"]
git-tree-sha1 = "e974477be88cb5e3040009f3767611bc6357846f"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.6.11"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "90bc7a7c96410424509e4263e277e43250c05691"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "1.0.0"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "f65dcb5fa46aee0cf9ed6274ccbd597adc49aa7b"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.7.1"

[[deps.Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6ed52fdd3382cf21947b15e8870ac0ddbff736da"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.4.0+0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "f94f779c94e58bf9ea243e77a37e16d9de9126bd"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.1"

[[deps.SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "c02bd3c9c3fc8463d3591a62a378f90d2d8ab0f3"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.3.17"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "StaticArraysCore"]
git-tree-sha1 = "e2cc6d8c88613c05e1defb55170bf5ff211fbeac"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "1.1.1"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.SimpleBufferStream]]
git-tree-sha1 = "874e8867b33a00e784c8a7e4b60afe9e037b74e1"
uuid = "777ac1f9-54b0-4bf8-805c-2214025038e7"
version = "1.1.0"

[[deps.SnoopPrecompile]]
deps = ["Preferences"]
git-tree-sha1 = "e760a70afdcd461cf01a575947738d359234665c"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.3"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "a4ada03f999bd01b3a25dcaa30b2d929fe537e00"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.1.0"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "d75bda01f8c31ebb72df80a46c88b25d1c79c56d"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.1.7"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "StaticArraysCore", "Statistics"]
git-tree-sha1 = "6954a456979f23d05085727adb17c4551c19ecd1"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.5.12"

[[deps.StaticArraysCore]]
git-tree-sha1 = "6b7ba252635a5eff6a0b0664a41ee140a1c9e72a"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.0"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f9af7f195fb13589dd2e2d57fdb401717d2eb1f6"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.5.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "d1bf48bfcc554a3761a133fe3a9bb01488e06916"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.21"

[[deps.StatsFuns]]
deps = ["ChainRulesCore", "HypergeometricFunctions", "InverseFunctions", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "ab6083f09b3e617e34a956b43e9d51b824206932"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "1.1.1"

[[deps.StatsPlots]]
deps = ["AbstractFFTs", "Clustering", "DataStructures", "DataValues", "Distributions", "Interpolations", "KernelDensity", "LinearAlgebra", "MultivariateStats", "NaNMath", "Observables", "Plots", "RecipesBase", "RecipesPipeline", "Reexport", "StatsBase", "TableOperations", "Tables", "Widgets"]
git-tree-sha1 = "e0d5bc26226ab1b7648278169858adcfbd861780"
uuid = "f3b207a7-027a-5e70-b257-86293d7955fd"
version = "0.15.4"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.0"

[[deps.TableOperations]]
deps = ["SentinelArrays", "Tables", "Test"]
git-tree-sha1 = "e383c87cf2a1dc41fa30c093b2a19877c83e1bc1"
uuid = "ab02a1b2-a7df-11e8-156e-fb1833f50b87"
version = "1.2.0"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "c79322d36826aa2f4fd8ecfa96ddb47b174ac78d"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.10.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.1"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "94f38103c984f89cf77c402f2a68dbd870f8165f"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.11"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[deps.URIs]]
git-tree-sha1 = "ac00576f90d8a259f2c9d823e91d1de3fd44d348"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unzip]]
git-tree-sha1 = "ca0969166a028236229f63514992fc073799bb78"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.2.0"

[[deps.Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "ed8d92d9774b077c53e1da50fd81a36af3744c1c"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.21.0+0"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[deps.Widgets]]
deps = ["Colors", "Dates", "Observables", "OrderedCollections"]
git-tree-sha1 = "fcdae142c1cfc7d89de2d11e08721d0f2f86c98a"
uuid = "cc8bc4a8-27d6-5769-a93b-9d913e69aa62"
version = "0.6.6"

[[deps.WoodburyMatrices]]
deps = ["LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "de67fa59e33ad156a590055375a30b23c40299d3"
uuid = "efce3f68-66dc-5838-9240-27a6d6f5f9b6"
version = "0.5.5"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "93c41695bc1c08c46c5899f4fe06d6ead504bb73"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.10.3+0"

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
version = "1.2.12+3"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e45044cd873ded54b6a5bac0eb5c971392cf1927"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.2+0"

[[deps.fzf_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "868e669ccb12ba16eaf50cb2957ee2ff61261c56"
uuid = "214eeab7-80f7-51ab-84ad-2988db7cef09"
version = "0.29.0+0"

[[deps.libaom_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3a2ea60308f0996d26f1e5354e10c24e9ef905d4"
uuid = "a4ae2306-e953-59d6-aa16-d00cac43593b"
version = "3.4.0+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.1+0"

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
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"

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
git-tree-sha1 = "9ebfc140cc56e8c2156a15ceac2f0302e327ac0a"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "1.4.1+0"
"""

# ╔═╡ Cell order:
# ╟─8f76e7fd-7481-40ff-8e54-e31aab7eff1f
# ╟─73429f7a-96f1-11ec-2061-8f45c81fe4bc
# ╟─0725692b-4deb-4ede-b8c6-e66744a2d5e1
# ╟─aa901300-3e70-442a-a44e-5425232d824f
# ╟─03f44fb9-fb3c-4980-a11b-ece24df033ab
# ╟─79bf9534-1ab8-4c82-aa79-179cd53d2847
# ╟─ecc16765-be51-46bb-afb2-8c4c434fe112
# ╟─be8cb8b4-6ad0-43c1-bf9f-25d1cac5f1e6
# ╠═aa19a7f1-2855-4e70-b31b-6db499756ad2
# ╟─c2ebc3e1-f9a9-42fd-9b25-82e29739ae49
# ╠═763b6b51-43c2-41a6-95e2-05d429b990ef
# ╟─2414e501-b353-4ae5-8898-440e8b1bd6ec
# ╟─fc6bbfe2-aa23-4df9-8506-48e956068b8d
# ╟─e5af4b30-e6a5-4f40-94c3-6e5cb878a9c4
# ╟─3264f3db-450b-4000-ac29-2637c7354f9a
# ╟─655f1aa1-7397-45c5-973e-6a690f9807ff
# ╟─af361979-28e4-467c-aa46-be1891c7b6b8
# ╠═6d96d826-b9ed-4ac3-a81b-37b0930932ee
# ╟─fa903c76-bdb8-4cab-9933-485998b5279f
# ╟─55ba0ba0-96d0-4248-82fb-f9b8509fa0b8
# ╠═bcef0d0b-45eb-4866-84eb-4b0444afdd2b
# ╟─abf2f5d6-7ea8-4752-8a80-9ad66670e458
# ╠═2249131d-b137-486d-a9d3-503a1bd6876e
# ╟─91a2d24f-b139-4f61-9609-1618d491b68e
# ╟─c001f17b-7a94-433c-8fee-d4e4975e5e0c
# ╟─6860ac98-2744-4889-a477-f9f9137c2221
# ╟─9b612cf5-0c99-4e70-b070-f7c0e7f7f151
# ╟─5f5e0319-a22b-41f9-bc29-058645411b1d
# ╟─f7d16791-425b-42c3-bffb-45518dc88d79
# ╠═1868b86a-c26e-4f76-b6d2-9c1143159bd9
# ╠═3dc0acfb-c45a-4f4c-a91e-b4be3aa07bf9
# ╠═6a7e4c76-82ab-45d1-96ba-aac67308d289
# ╟─09c25e45-55c5-458e-a867-d901eb9b64a8
# ╟─f52a564f-af2c-4be1-81e8-7124c2339bea
# ╟─c5b024ed-11c4-4f01-a7f3-00ee90069cef
# ╟─0a9bdba3-ee54-48fb-9c2b-2efc9f305385
# ╟─86619b3f-3284-4f76-acbf-a196bb072433
# ╠═5dc9be6a-54da-49b8-8cf5-87567bc6563c
# ╠═09e27d74-c105-425c-b49f-9f2465fe663c
# ╟─8ab6a87e-5666-472f-8030-273ced222459
# ╠═30fd1867-c9aa-468e-b7cb-9531e9471831
# ╟─d598adfa-2b05-4a53-bf6d-f1e58ea271cd
# ╠═c3e717bf-acaa-4ea7-8bff-01853fdf8a58
# ╟─d38d7b54-bec0-48b5-a897-2393a365c1c7
# ╠═e323af6a-2e7b-4fca-af22-a72989da9d4c
# ╟─e8907f01-43c0-4742-a3d0-f0b87aa1c323
# ╟─320ae62b-f132-4898-a2ab-3bd20a7de7f3
# ╠═7b74afe2-eafd-4db0-8f1f-a8e123c40d6f
# ╟─616fc902-e302-45b9-b184-e9035d7e780c
# ╟─3a9a738f-8e7f-437e-9410-067121f00c0e
# ╠═d4b47ed9-4082-4732-97ef-39500584eaaa
# ╟─3eed2b8a-c56f-45c6-b796-b7e0f8d69a1e
# ╠═b1c45b8b-8818-4417-afa3-dc4f207b44a6
# ╟─4c426122-22bc-4ccf-ac1c-ffe3f1ee68fc
# ╟─2124df9e-9c06-46da-acc0-299ff9854e45
# ╟─91d436f1-166a-4d08-b376-2f365b56bece
# ╟─050f5698-8419-422a-b0ff-5cca01881e64
# ╠═ed9157d6-ca3c-4440-9b68-e6954999e231
# ╟─bbd7467e-7f68-4446-b6aa-90730f8eb497
# ╟─a396e3c3-8082-404c-9d42-46aa77444ba5
# ╟─783b2d7a-f937-4bf9-a15c-380078bb27cc
# ╠═b3511771-d307-4e33-8406-e561bfe72958
# ╠═ea9b0a84-3b02-433a-b5df-d1b76b16ceaf
# ╠═b1c02d6f-d50d-43cb-a01b-08ae7f4fb30d
# ╠═764a07f5-e3ab-4db3-a5be-5728aab422bb
# ╠═959d1081-f82d-4070-8fef-3aab85cfe440
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
