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

# ╔═╡ b3511771-d307-4e33-8406-e561bfe72958
using Distributions, StatsBase, LinearAlgebra, Plots

# ╔═╡ ea9b0a84-3b02-433a-b5df-d1b76b16ceaf
using PlutoUI

# ╔═╡ b1c02d6f-d50d-43cb-a01b-08ae7f4fb30d
using StatsPlots

# ╔═╡ 764a07f5-e3ab-4db3-a5be-5728aab422bb
using Optim

# ╔═╡ 959d1081-f82d-4070-8fef-3aab85cfe440
TableOfContents(title="Inhalt")

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
