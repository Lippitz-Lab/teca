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

# ╔═╡ f5450eab-0f9f-4b7f-9b80-992d3c553ba9
# DO NOT MODIFY, will be updated by update_navbar.jl
HTML("    <nav >\n    Vorbereitungen:\n\n<a class=\"sidebar-nav-item\" href=\"index.html\"><em>Intro</em></a> / \n<a class=\"sidebar-nav-item\" href=\"software.html\"><em>Software</em></a> / \n<a class=\"sidebar-nav-item\" href=\"01-basic_syntax.html\"><em>Julia Basics</em></a> / \n\n<br>\nStatistik:\n\n<a class=\"sidebar-nav-item\" href=\"02-beschreibende-statistik.html\"><em>Beschreibende Statistik</em></a> / \n<a class=\"sidebar-nav-item\" href=\"03-wahrscheinlichkeit.html\"><em>Wahrscheinlichkeit</em></a> / \n<a class=\"sidebar-nav-item\" href=\"04-schaetzung.html\"><em>Schätzung</em></a> / \n<a class=\"sidebar-nav-item\" href=\"05-messunsicherheit.html\"><em>Messunsicherheit</em></a> / \n\n<br>\nFourier-Transformation:\n\n<a class=\"sidebar-nav-item\" href=\"06-Fourier-Transformation.html\"><em>Fourier-Transformation</em></a> / \n<a class=\"sidebar-nav-item\" href=\"07-Frequenzraum.html\"><em>Frequenzraum</em></a> / \n<a class=\"sidebar-nav-item\" href=\"08-Filter.html\"><em>Filter</em></a> / \n\n<br>\nMesstechnik:\n\n<a class=\"sidebar-nav-item\" href=\"09-Rauschen.html\"><em>Rauschen</em></a> / \n<a class=\"sidebar-nav-item\" href=\"10-Detektoren.html\"><em>Detektoren</em></a> / \n<a class=\"sidebar-nav-item\" href=\"11-Lock-In.html\"><em>Lock-In-Verstärker</em></a> / \n<a class=\"sidebar-nav-item\" href=\"12-heterodyn.html\"><em>Heterodyn-Detektion</em></a> / \n\n<br>\n\n\n    </nav>\n\t")

# ╔═╡ 8f76e7fd-7481-40ff-8e54-e31aab7eff1f
html"""<div>
<font size="7"><b>Schätzung</b></font> </div>

<div><font size="5"> Markus Lippitz </font> </div>
<div><font size="5"> 25. März 2022 </font> </div>
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
Wir folgen hier dem Beispiel von Stahel, Kapitel 7.4. Wir führen ein Experiment durch, werfen eine Münze o.ä. Dies gelingt mit einer Wahrscheinlichkeit $p$. Wir führen das so oft durch, bis es einmal misslingt. Die Wahrscheinlichkeit, dass es bei Versuch $x$ misslingt ist geometrisch verteilt, also
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

# ╔═╡ c001f17b-7a94-433c-8fee-d4e4975e5e0c
md"""
# Methode der kleinsten Quadrate

Wir hatten schon im Kapitel zur beschriebenden statistik die Methode der kleinsten Quadrate erwähnt. Man kann ein Modell an Daten anpassen, indem man die Parameter des Modells so variiert, dass die Summe der qwuadratsichen Abweichung zwsichzen Modell und Daten minimal wird. Bei gegebenen $x_i$ und gemessenen $y_i$ sucht man also Parameter $\theta$ eines Modells $y = f(x_i; \theta)$ so dass
```math
\text{Summe der Residuen} = \sum_i \left( y_i - f(x_i; \theta) \right)^2
```
minimal wird.
"""

# ╔═╡ 6860ac98-2744-4889-a477-f9f9137c2221
md"""
Warum funktioniert das? Die Begründung liefer die Maximum Likelihood Methode. Aus dieser Sichtweise beschreibt das Modell $f(x_i; \theta)$ den Erwartungswert einer Normalverteilung mit der Standardabweching $\sigma$, die für alle Messpunkte identisch ist. Die Wahrscheinnloichkeit, einen Wert $y_i$ zu messen, obwogl das Modell dioch $f(x_i; \theta)$ vorhersagt, ist also
```math
p_\theta(x_i) = c \, e^{- \frac{(y_i - f(x_i; \theta))^2}{\sigma^2}}
```
Der Vorfaktor $c$ normioert die Verteilung, ist abver für alle $i$ identisch, so dass wir ihn bei der Optimierung vernachlössigen können. Die Log-Likelihood Funktion ist dann
```math
L\left<x_1, x_2 \dots x_n ; \theta \right> = \sum \ln p_\theta\left<x_i\right>
=  - \frac{c}{\sigma^2} \, \sum_i (y_i - f(x_i; \theta))^2 
```
Wir maxmimieren $L$, minimieren also die Summe der Resiuden. Die Methode der kleinsten Quadrate ist also die Maximum Likelihood Methode unter der Annahme einer Nornmalverteilung der (konstanten) Messunsicherheit.
"""

# ╔═╡ 9b612cf5-0c99-4e70-b070-f7c0e7f7f151
md"""
Die erste Konseqeunz ist, dass wir eine variable Messunsicherheit $\sigma_i$ berücksichtigen können, in dem wir 
```math
\text{Summe der gewichteten Residuen} = \chi^2 = \sum_i \frac{\left( y_i - f(x_i; \theta) \right)^2}{\sigma_i^2}
```
minimieren.
"""

# ╔═╡ 5f5e0319-a22b-41f9-bc29-058645411b1d
md"""
Die zweite Konsequenz ist, dass wir die Verteilung der Messunsicherheit im Auge behakten müssen. Sollte es begründete Zweifel an deren Normalverteilung geben, dann sollte man von der Methide der kleinsten Quadrate Abstand nehmen und direkt die Maximum Likelihood Methode anwenden. Dies ist beispielsweeise der Fall, wenn ein Modell an Photonenzahlen angepasst werden soll, und die typischen Photonenzahlen unterhabl un ungefähr 10 liegen. Deren Fehler ist dann gerade Poisson-verteilt.
"""

# ╔═╡ f7d16791-425b-42c3-bffb-45518dc88d79
md"""
## Bsp. Modell an Photonen-Zahlen anpassen

Beim [zeitkorelierten Einzelphotonenzählen](https://de.wikipedia.org/wiki/Zeitkorrelierte_Einzelphotonenz%C3%A4hlung) bestimmt man die Anzahl an deketeirten Fluoreszenz-Photonen eines Molelküls als Funktion des zeitlichen Abstands zum anregenden Laserpuls. Typische Abständei liegen im bereich von einer Nanosekunde und sind durch die Lebenbszeit des anregergten Zustands im Molekül bestimmt. Die Idee ist, diesen dadurch zu bestimmen. Man findet einen exponenztiellen Abfall der Zählereignisse mit dem zeitlichen Abdstand zur Anregung. Die Zerfallskonstante ist gearde die Lebebnszeit des Zustands.

Das Modell ist also
```math
f(t; \tau, c_{fl}, c_{bg}) = c_{fl} \, e^{- t / \tau} + c_{bg}
```
wobei $t$ die Zeit zwsichen Laserpuls und Detektion des Photons ist und $\tau$ die Lebenszeit des angregetne Zustanbds besxchreibt. Die beiden $c_i$ bestimmen den Helligkeit des Moleküls und die des Untergrunds, beuspilsweise aufgrund von Raumlicht oder der Dunekzählrate des Detektors.

Die gemessene Photonezahl in einem Intveall $[t, t+dt]$ ist also Poisson-Verteilt um einen Mittelwert, der druch $f$ gegeben ist.
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
Da hatte ich den Unterschied dramasticher in Erinnerung
"""

# ╔═╡ f52a564f-af2c-4be1-81e8-7124c2339bea
md"""
# Intervallschätzung

Mit der Punktschätzung haben wir den plasusibelsten Wert des Parameters gefunden, der die Verteilung beschreibt, aus der unsere Messdaten gezogen wurden. Nun geht es um die Frage, welche anderen Werte dieser Parameter auch noch annehmen könnte. Wir sind also auf der Suche nach einem Intervall, in dem der wirkliche Parameter dann mit einer gewissen Wahrschienlichkeit liegen wird. Dieses Intervall nennt man **Konfidenzintervall**
"""

# ╔═╡ c5b024ed-11c4-4f01-a7f3-00ee90069cef
md"""
## Bsp. geometrische Verteilung
"""

# ╔═╡ 0a9bdba3-ee54-48fb-9c2b-2efc9f305385
md"""
Betrachten wir noch einmal als Beipiel die geometrische Verteilung von oben. Mit der Wahtrscheinliochkeit $p$ gelingt ein Versuch, nach $x$ Versuchen tritt zum ersten mal ein Misserfolg auf. Die Wahrscheinlichkeit für einen Misserfolgt nach $x$ versuchen ist also 
```math
P\left<X=x\right> = (1-p)\, p^x
```
Wir messen einen Misserfolg nach $x=3$ versuchen. Wie oben gesehn ist der plausibelste Parameter 
```math
\hat{p} = \frac{x}{x+1} = \frac{3}{4}
```
Wir suchen eine untere ($p_u$) und obere ($p_o$) Intervallgrenze, die jeweils eine Funktion des gemessenen Wertes $x$ ist, so dass der wahre Parameter $p$ mit 95% Wahrscheibloichkeit in diesem Intervall liegt, also 
```math
\mathcal{P}\left< p_u(x) < p < p_o(x) \right> = 0.95
```
unabhängig vom wahren $p$ und ggf. auch anderen Paramtern der Verteilung. Das Gleichheitszeichen wird manchmal als 'gleich oder etwas größer' interpertiert. Inbesodnere bei disktreten Verteilungen ist ein Gleichheit nicht zu erreichen.
"""

# ╔═╡ 86619b3f-3284-4f76-acbf-a196bb072433
md"""
Man kann die Intervallgrenzen auf verschiedenem Weg bekommen, siehe bspw. [wikipedia](https://en.wikipedia.org/wiki/Confidence_interval). Hier folgen wir wiederum Stahel und benutuzen ein Erfgebnis aus dem Test von Hypothesen. Ohne das hier näher zu begründen drehen wir wieder Variable und Paramter um. Wir wählen die obere Grentze des Intervalls so, dass unser Messert $x$ auf der *unteren* 2.5%-Perzentil liegt, also  
```math
P_{p_o}\left<X \le x\right> = 2.5 \%
```
Die kumulative Dichtefunktion beträgt also $0.025$ bzw $1 - 0.025$ an der unteren bzw oberen Intervallgrenze. In Julia finden wir diese Grenz-Paramter über eine Nullstellensuche:
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
Testweise summieren wir die Wahrscheinlichkeiten für die Fälle $0-3$ bzw. $3-\infty$ erfolgrecihe Versuche bei dem gegebenen $p_u$ und $p_o$, um sicherzugehen, dass jeweils 2.5% außerhalb liegen.
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
Dies sind die drei charakteristiashcnr Verteilungen, wenn wir $x=3$ gemessen haben. Die Plausibelste ist die mit $p=3/4$, die anderen beiden sind die Grenzfälle.
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
Lassen sie uns das noch einmal andersrum betrachten. Wir geben uns eine geometrische Verteilung mit bekanntem $p$ vor, ziehen daraus eine Zufallszahl $x$ und schätzen aufgrund dieser Zahl die Grenzen des Konfidenzintervalls. In 95% der Fälle müsste unser vorgegebens $p$ in diesem Intervall liegen, in 5% der Fälle nicht.
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
Unsere Intervakllkgrenzen sind etwas zu groß. Zu selten liegt der wahre Wert außerhalb der Grenzen. Dies ist ein Problem bei diskreten Verteiulungebn. Hier sind die Messwerte diskret,und danit notgeruden auch die berechneten Grenzen des Konfidenzintervalls. Dadurch kann man die Wharscheiblichkjeit niciht exakt auf den gewpünschten Wert einstellen.
"""

# ╔═╡ 3a9a738f-8e7f-437e-9410-067121f00c0e
md"""
## Normalverteilung

Wenn man die Verteilungsfunktion kennt, kann man die Grenzen des Koinfidenzintervalls wie oben gezeigt berechnen. Oft ist die Verteilung eine Normalverteilung. Dies nimmt man notfalls auch an, wenn man es nicht besser weiss.

Im ersten Kapitel hatten wir uns schon die Integrale über $[\mu - n \sigma, \mu + n \sigma]$ angeschaut
"""

# ╔═╡ d4b47ed9-4082-4732-97ef-39500584eaaa
[cdf(Normal(0, 1), n) - cdf(Normal(0, 1), -n) for n in (1,2,3)]

# ╔═╡ 3eed2b8a-c56f-45c6-b796-b7e0f8d69a1e
md"""
Ein $\pm\2\sigma$-Intervall beinhaltet also 95.45% der Fälle. Eigentloich suchen wir ja ein Intervall mit genau 95%. Das liegt aber in der Nähe, nähmlich bei $\pm 1.96 \sigma$, siehe den 'Minimizer' hier
"""

# ╔═╡ b1c45b8b-8818-4417-afa3-dc4f207b44a6
optimize( n -> ( cdf(Normal(0, 1), n) - cdf(Normal(0, 1), -n) - 0.95).^2, 0,3)

# ╔═╡ 4c426122-22bc-4ccf-ac1c-ffe3f1ee68fc
md"""
Ein Problem ist hier, dass die Standardabweichung $\sigma$ hier die **wahre** Standardwbweihung ist. Wir kennen aber typisxcehrwesie nur eine **geschätzte** Standardabwecihung, die wir auf grundlage unserer messwerte schätzen müssen. Diesen zusätzliochen faktor disktutieren wir im nchsten Kapitel.
"""

# ╔═╡ 046e3c23-ba68-431c-abf0-222e7baa1696
md"""
## Bsp. Gauß'sche Fehlerrechung

Die Gauß'sche fehlerrechnung kann als Methide der Intervallschätzung gesehen werden. Wir haben mehrere Messwerte $x_i$, die wir durch ein Modell $f(x; p_j)$ mit den Parametern $p_j$ beschreiben wollen. Wir finden die $p_j$, indem wir die quadratische Abweichung minimieren, also nach den $p_j$ ableiten und Null setzen, also
```math
\frac{\partial}{\partial p_k} \sum_i (x_i - f(x_i; p_j))^2 = 0
```
So erhalten wir ein Gleichunsgystem zur Bestimmung der $p_j$, das wir lösen.

Das Konfideznzintervall um diese ootimalen $p_j$ erhlaten wir durch Gauß'sxche Fehlerforttplanuzung durch dieses Gleichungsystem. Dazu nehmen wir zum einen eine Normalverteilung bei den Messwerten $x_i$ an, zum naderen linearisieren wir die Bestimmungsgleichen in der Nähe der optimalen $p_j$. (Wenn man beides nicht machen will: siehe nächstes Kapitel)
"""

# ╔═╡ 050f5698-8419-422a-b0ff-5cca01881e64
md"""
Sei unser Modell eine Gerade
```math
y = a + b x
```

Die Koeffizienten werden bestimmt über
```math
\hat{b} = cor_{xy} \,  \frac{\sigma_y}{\sigma_x}  \quad \text{und} \quad
	\hat{a} = \bar{y} - \hat{b} \bar{x} 
```

Unter der Annahme von dientsichen Unsicherheiten in allen Messwerten ist ein guter Schätzer der Unsicherheit des einzelnen Messpunkts die mittlere quadratiusche Abweichung zum Modell, also
```math
\hat{\sigma} = \frac{1}{N-2} \sum_i \left( y_i - (\hat{a} + \hat{b} x_i) \right)^2
```
Die 2 in $N-2$ stammt von den zwei durch $\hat{a}$ udn $\hat{b}$ verbrauchten Freiheitsgarden der Messung, analog zur Schätzung der Standardabwechingung oben.

Damit bekommt man duerch Fehglerfortplöfanzung (siehe Bevoington Kap 6.4 udn Stahel Kap. 13.2)
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
Distributions = "~0.25.53"
Optim = "~1.6.2"
Plots = "~1.27.5"
PlutoUI = "~0.7.38"
StatsBase = "~0.33.16"
StatsPlots = "~0.14.33"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.2"
manifest_format = "2.0"

[[deps.AbstractFFTs]]
deps = ["ChainRulesCore", "LinearAlgebra"]
git-tree-sha1 = "6f1d9bc1c08f9f4a8fa92e3ea3cb50153a1b40d4"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.1.0"

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

[[deps.Arpack]]
deps = ["Arpack_jll", "Libdl", "LinearAlgebra", "Logging"]
git-tree-sha1 = "91ca22c4b8437da89b030f08d71db55a379ce958"
uuid = "7d9fca2a-8960-54d3-9f78-7d1dccf2cb97"
version = "0.5.3"

[[deps.Arpack_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "OpenBLAS_jll", "Pkg"]
git-tree-sha1 = "5ba6c757e8feccf03a1554dfaf3e26b3cfc7fd5e"
uuid = "68821587-b530-5797-8361-c406ea357684"
version = "3.5.1+1"

[[deps.ArrayInterface]]
deps = ["Compat", "IfElse", "LinearAlgebra", "Requires", "SparseArrays", "Static"]
git-tree-sha1 = "c933ce606f6535a7c7b98e1d86d5d1014f730596"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "5.0.7"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.AxisAlgorithms]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "WoodburyMatrices"]
git-tree-sha1 = "66771c8d21c8ff5e3a93379480a2307ac36863f7"
uuid = "13072b0f-2c55-5437-9ae7-d433b7a33950"
version = "1.0.1"

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

[[deps.Clustering]]
deps = ["Distances", "LinearAlgebra", "NearestNeighbors", "Printf", "SparseArrays", "Statistics", "StatsBase"]
git-tree-sha1 = "75479b7df4167267d75294d14b58244695beb2ac"
uuid = "aaaa29a8-35af-508c-8bc3-b662a17a0fe5"
version = "0.14.2"

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

[[deps.CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

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
deps = ["StaticArrays"]
git-tree-sha1 = "c18e98cba888c6c25d1c3b048e4b3380ca956805"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.0.3"

[[deps.DiffRules]]
deps = ["IrrationalConstants", "LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "dd933c4ef7b4c270aacd4eb88fa64c147492acf0"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.10.0"

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

[[deps.FFTW]]
deps = ["AbstractFFTs", "FFTW_jll", "LinearAlgebra", "MKL_jll", "Preferences", "Reexport"]
git-tree-sha1 = "505876577b5481e50d089c1c68899dfb6faebc62"
uuid = "7a1cc6ca-52ef-59f5-83cd-3a7055c09341"
version = "1.4.6"

[[deps.FFTW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c6033cc3892d0ef5bb9cd29b7f2f0331ea5184ea"
uuid = "f5851436-0d7a-5f13-b9de-f02708fd171a"
version = "3.3.10+0"

[[deps.FillArrays]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "Statistics"]
git-tree-sha1 = "246621d23d1f43e3b9c368bf3b72b2331a27c286"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "0.13.2"

[[deps.FiniteDiff]]
deps = ["ArrayInterface", "LinearAlgebra", "Requires", "SparseArrays", "StaticArrays"]
git-tree-sha1 = "56956d1e4c1221000b7781104c58c34019792951"
uuid = "6a86dc24-6348-571c-b903-95158fe2bd41"
version = "2.11.0"

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
git-tree-sha1 = "1bd6fc0c344fc0cbee1f42f8d2e7ec8253dda2d2"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.25"

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

[[deps.IfElse]]
git-tree-sha1 = "debdd00ffef04665ccbb3e150747a77560e8fad1"
uuid = "615f187c-cbe4-4ef1-ba3b-2fcf58d6d173"
version = "0.1.1"

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
deps = ["AxisAlgorithms", "ChainRulesCore", "LinearAlgebra", "OffsetArrays", "Random", "Ratios", "Requires", "SharedArrays", "SparseArrays", "StaticArrays", "WoodburyMatrices"]
git-tree-sha1 = "b15fc0a95c564ca2e0a7ae12c1f095ca848ceb31"
uuid = "a98d9a8b-a2ab-59e6-89dd-64a1c18fca59"
version = "0.13.5"

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

[[deps.KernelDensity]]
deps = ["Distributions", "DocStringExtensions", "FFTW", "Interpolations", "StatsBase"]
git-tree-sha1 = "591e8dc09ad18386189610acafb970032c519707"
uuid = "5ab0869b-81aa-558d-bb23-cbf5423bbe9b"
version = "0.6.3"

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

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

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

[[deps.LineSearches]]
deps = ["LinearAlgebra", "NLSolversBase", "NaNMath", "Parameters", "Printf"]
git-tree-sha1 = "f27132e551e959b3667d8c93eae90973225032dd"
uuid = "d3d80556-e9d4-5f37-9878-2ab0fcc64255"
version = "7.1.1"

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

[[deps.MKL_jll]]
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "Pkg"]
git-tree-sha1 = "e595b205efd49508358f7dc670a940c790204629"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2022.0.0+0"

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

[[deps.MultivariateStats]]
deps = ["Arpack", "LinearAlgebra", "SparseArrays", "Statistics", "StatsAPI", "StatsBase"]
git-tree-sha1 = "7008a3412d823e29d370ddc77411d593bd8a3d03"
uuid = "6f286f6a-111f-5878-ab1e-185364afe411"
version = "0.9.1"

[[deps.NLSolversBase]]
deps = ["DiffResults", "Distributed", "FiniteDiff", "ForwardDiff"]
git-tree-sha1 = "50310f934e55e5ca3912fb941dec199b49ca9b68"
uuid = "d41bc354-129a-5804-8e4c-c37616107c6c"
version = "7.8.2"

[[deps.NaNMath]]
git-tree-sha1 = "b086b7ea07f8e38cf122f5016af580881ac914fe"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.7"

[[deps.NearestNeighbors]]
deps = ["Distances", "StaticArrays"]
git-tree-sha1 = "ded92de95031d4a8c61dfb6ba9adb6f1d8016ddd"
uuid = "b8a86587-4115-5ab1-83bc-aa920d37bbce"
version = "0.4.10"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.Observables]]
git-tree-sha1 = "fe29afdef3d0c4a8286128d4e45cc50621b1e43d"
uuid = "510215fc-4207-5dde-b226-833fc4488ee2"
version = "0.4.0"

[[deps.OffsetArrays]]
deps = ["Adapt"]
git-tree-sha1 = "043017e0bdeff61cfbb7afeb558ab29536bbb5ed"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.10.8"

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

[[deps.Optim]]
deps = ["Compat", "FillArrays", "ForwardDiff", "LineSearches", "LinearAlgebra", "NLSolversBase", "NaNMath", "Parameters", "PositiveFactorizations", "Printf", "SparseArrays", "StatsBase"]
git-tree-sha1 = "bc0a748740e8bc5eeb9ea6031e6f050de1fc0ba2"
uuid = "429524aa-4258-5aef-a3af-852621145aeb"
version = "1.6.2"

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

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

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

[[deps.PositiveFactorizations]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "17275485f373e6673f7e7f97051f703ed5b15b20"
uuid = "85a6dd25-e78a-55b7-8502-1745935b8125"
version = "0.2.4"

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

[[deps.Ratios]]
deps = ["Requires"]
git-tree-sha1 = "dc84268fe0e3335a62e315a3a7cf2afa7178a734"
uuid = "c84ed2f1-dad5-54f0-aa8e-dbefe2724439"
version = "0.4.3"

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

[[deps.SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "6a2f7d70512d205ca8c7ee31bfa9f142fe74310c"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.3.12"

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

[[deps.Static]]
deps = ["IfElse"]
git-tree-sha1 = "87e9954dfa33fd145694e42337bdd3d5b07021a6"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "0.6.0"

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

[[deps.StatsPlots]]
deps = ["AbstractFFTs", "Clustering", "DataStructures", "DataValues", "Distributions", "Interpolations", "KernelDensity", "LinearAlgebra", "MultivariateStats", "Observables", "Plots", "RecipesBase", "RecipesPipeline", "Reexport", "StatsBase", "TableOperations", "Tables", "Widgets"]
git-tree-sha1 = "4d9c69d65f1b270ad092de0abe13e859b8c55cad"
uuid = "f3b207a7-027a-5e70-b257-86293d7955fd"
version = "0.14.33"

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

[[deps.Widgets]]
deps = ["Colors", "Dates", "Observables", "OrderedCollections"]
git-tree-sha1 = "505c31f585405fc375d99d02588f6ceaba791241"
uuid = "cc8bc4a8-27d6-5769-a93b-9d913e69aa62"
version = "0.6.5"

[[deps.WoodburyMatrices]]
deps = ["LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "de67fa59e33ad156a590055375a30b23c40299d3"
uuid = "efce3f68-66dc-5838-9240-27a6d6f5f9b6"
version = "0.5.5"

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
# ╟─046e3c23-ba68-431c-abf0-222e7baa1696
# ╟─050f5698-8419-422a-b0ff-5cca01881e64
# ╠═ed9157d6-ca3c-4440-9b68-e6954999e231
# ╠═b3511771-d307-4e33-8406-e561bfe72958
# ╠═ea9b0a84-3b02-433a-b5df-d1b76b16ceaf
# ╠═b1c02d6f-d50d-43cb-a01b-08ae7f4fb30d
# ╠═764a07f5-e3ab-4db3-a5be-5728aab422bb
# ╠═959d1081-f82d-4070-8fef-3aab85cfe440
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
