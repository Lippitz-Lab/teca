### A Pluto.jl notebook ###
# v0.19.26

using Markdown
using InteractiveUtils

# ╔═╡ c0fb4b16-f2af-40e3-a01e-35414bf95b9a
html"""<div>
<font size="7"><b>11 Lock-In Verstärker</b></font> </div>

<div><font size="5"> Markus Lippitz</font> </div>
<div><font size="5"> 16. Juni 2022 </font> </div>
"""

# ╔═╡ 5cdbcc8c-96f3-11ec-3e70-45ed796a8b3d
md"""
**Ziele** Sie können *erklären*, wie ein Lock-in Verstärker funktioniert und ihn zur Messung kleiner Signal *benutzen*.

- Lock-in Verstärker

- Seitenbänder bei Amplituden-Modulation

- Boxcar averager

**Literatur** Horowitz/Hill Kap. 15.12--15, [Tutorial](http://support.bentham.co.uk/support/solutions/articles/13000036065-lock-in-amplifier-tutorial) von Bentham Instruments
 
"""

# ╔═╡ a70e05af-8ddb-4181-ae49-c503af5231e5
md"""
# Überblick

Ein Lock-In-Verstärker (engl. lock-in amplifier, LIA) sollte besser phasen-empfindlicher Detektor genannt werden. Der 'Verstärker' selbst ist deutlich unwichtiger als die Phasen-Empfindlichkeit.  Mit einem Lock-In-Verstärker kann man ein Signal in einem sehr schmalen Frequenzintervall detektieren (ähnlich einem schmalen Bandpass-Filter). Man ist aber zusätzlich auch sensitiv auf die Phasenlage des Signal relativ zu einer Referenzphase. 


"""

# ╔═╡ 957916f2-c8a6-4a9e-a84d-851c5a7f8784
md"""
# Motivation

## Kontinuierliches Signal

Wir betrachten eine kontinuierlich leuchtende Lichtquelle, deren Leistung wir durch eine Photodiode detektieren und den Photostrom verstärken und messen. Solange das Signal groß ist, geht das problemlos. Wenn das Signal jedoch klein ist, dann spielt das Rauschen des Photodetektors und mögliche Störquellen eine Rolle.
$(aside([Resource("https://raw.githubusercontent.com/MarkusLippitz/teca/main/res/11-Lock-In/setup_1.png", (:height => 100))  md"*Detektion eines kontinuierlichen Signals*"]) ) 

> Skizzieren Sie das zu erwartende Rauschspektrum der Lichtquelle sowie des Photodetektors mit und ohne eingeschaltete Lichtquelle.
"""

# ╔═╡ 010d3676-e41c-4f27-8640-36908c66117e
md"""
## Moduliertes Signal

Die Dinge werden etwas besser, wenn wir die Lichtquelle modulieren. Wir können beispielsweise die Stromversorgung periodisch mit der Frequenz $f_m$ ein- und ausschalten, oder einen mechanischen Zerhacker (engl. [chopper](https://en.wikipedia.org/wiki/Optical_chopper)) verwenden, der periodisch den Strahl unterbricht. Dadurch verschieben wir die interessanten Frequenzen des Signals nach $f_m$.$(aside([Resource("https://raw.githubusercontent.com/MarkusLippitz/teca/main/res/11-Lock-In/setup_2.png", (:height => 120))  md"*Detektion eines modulierten Signals durch Bandpass-Filterung und Gleichrichtung*"]) ) 


> Gegeben sei das Frequenz-Spektrum $S(\omega)$ der unmodulierten Lichtquelle (z.B. aus ihrer Skizze oben). Der Chopper multipliziert den zeitlichen Verlauf $s(t)$ mit einer Rechteck-Funktion, die gleich lang den Wert '1' und den Wert '0' zeigt und die Frequenz $f_m$ besitzt. Berechnen Sie das Frequenz-Spektrum $M(\omega)$ nach dem Chopper, was also von der Photodiode detektiert wird.
"""

# ╔═╡ efc79d57-5813-4064-8bb7-d8de71e3e8c7
md"""
Die Photodiode detektiert in diesem Fall ein moduliertes Signal. Die interessierende Größe ist die Amplitude des Frequenzkomponente bei $f_m$. Eine naheliegende Möglichkeit ist, das elektrische Signal der Photodiode durch einen Bandpassfilter bei der Frequenz $f_m$ zu filtern und danach gleichzurichten.

Das ist machbar, hat aber einige Nachteile
- Die Güte $Q = \Delta \omega / \omega$ eines Filters ist limitiert. Bei hohen Frequenzen $\omega$ kann also die Bandbreite $\Delta \omega$ nicht beliebig schmal werden. Man würde aber gerne ein sehr kleines $\Delta \omega$ verwenden, um möglichst viel Rauschen zu unterdrücken.

- Falls die Modulationsfrequenz $f_m$ zeitlich driftet, weil beispielsweise der Motor nicht immer exakt gleich schnell läuft, dann liegt das Signal nicht mehr in der Mitte des Filter-Passbandes und es wird abgeschwächt. Frequenz-Drifts des Motors erscheinen also als Amplitudenänderung des Signals

- Ein Gleichrichter liefert nur positive Spannungen. Auch ohne Signal wird daher das immer vorhandene Rauschen um einen positiven Wert zentriert sein, nicht um die Null. Dieser statische Rausch-Beitrag ist von einem kleinen echten Signal nicht zu unterscheiden.

"""

# ╔═╡ 4f348530-7b3c-47b8-b7f2-804abe1a5e9b
md"""
## Phasen-empfindliche Detektion

Ein phasen-empfindlicher Detektor löst diese Probleme. Wir betrachten zwei Varianten:

### Schalter = Demodulation mit Rechteck

Wir detektieren und verstärken unser Signal weiterhin mit einem Photodetektor. Dann jedoch folgt kein Bandpass-Filter, sondern ein Schalter, mit dem wir periodisch mit der Frequenzen $f_r$ das Vorzeichen des Signal ändern, also mit einer Rechteck-Funktion multiplizieren, die zwischen '1' und '-1' oszilliert. Danach folgt ein Tiefpass-Filter und wir messen die Amplitude des Signals.$(aside([Resource("https://raw.githubusercontent.com/MarkusLippitz/teca/main/res/11-Lock-In/setup_3.png", (:height => 120))  md"*Phasenempfindliche Detektion durch Umschalten*"]) ) 

Der Trick ist, dass wir die Referenz-Frequenz $f_r$ der Demodulation gleich der der Modulation $f_m$ wählen und zwar phasenstarr. Es geht also ein Kabel vom Chopper und eines von der Diode zum Lock-In-Verstärker.

> Warum ist es nicht möglich, einfach nur beide Frequenz auf den gleichen Wert zu stellen?

Wenn die uns interessierende Frequenzkomponente im Diodensignal in Phase ist mit dem Referenzsignal, dann werden die negativen Halbwellen mit '-1' multipliziert und umgeklappt, so dass nach der Tiefpass-Filterung ein Wert übrig bleibt. Wenn aber beispielsweise kein Signal anliegt, sondern nur Rauschen um die Null herum, dann wird ein Teil des Rauschens invertiert. Dessen Mittelwert ist aber weiterhin zentriert um die Null.

Die Bandbreite dieses 'synchronen Filters' ist durch die Zeitkonstante $T$ des Tiefpass-Filters gegeben. Die kann aber beliebig lang sein, unabhängig von $f_m$, so dass beliebig schmale Filter erzeugt werden können.
"""

# ╔═╡ ba02ba73-8e4e-4b9b-8ddf-8c39bdd8ff8f
md"""
### Mixer = Demodulation mit Kosinus

Alternativ kann man an Stelle des Schalters auch einen Mixer verwenden, also ein elektronisches  Bauteil, dessen Ausgangssignal dem Produkt seiner beiden Eingangsignale entspricht. Wir erzeugen also aus dem Diodensignal $m(t)$ und einer cosinus-förmigen Referenz-Wellenform $r(t)$ ein Signal 
```math
u(t) = m(t) \times r(t)
```

> Ausgehend von obigem Diodensignal $M(\omega)$, wie sieht $U(\omega)$ aus? 
"""

# ╔═╡ c68ab966-1535-465c-bde0-fe7e49e7d4fa
md"""
Analog kann man auch obige Schalter-Variante in Frequenzraum beschreiben.$(aside([Resource("https://raw.githubusercontent.com/MarkusLippitz/teca/main/res/11-Lock-In/setup_4.png", (:height => 120))  md"*Phasenempfindliche Detektion durch Mischen*"]) ) 
"""

# ╔═╡ 9cba2b6b-c64a-4303-9872-a1e2e2724085
md"""
Typischerweise demoduliert man sowohl mit einem Kosinus als auch einen Sinus (das nennt man manchmal 'dual phase'), und erzeugt nach Tiefpass-Filterung zwei Signale $x(t)$ und $y(t)$. Aus diesen kann man dann die Amplitude $R = \sqrt{x^2 + y^2}$ und den Phasenwinkel $\phi = \text{atan}(y/x)$ berechnen.

> Sei 
> ```math 
> m(t) = a \cos (f_m t + \phi_m)
> ```
> und 
> ```math
> r(t) = \cos (f_r t + \phi_r) \quad \text{bzw.} \quad \sin (...)
> ```
> Geben Sie eine Gleichung für das detektierte Signal $x(t)$ und $y(t)$ an.


"""

# ╔═╡ 89d0ad35-b026-4fdc-9e26-42cfcb7b4cd4
md"""
### Frage

> Wenn man mit einem Chopper den Lichtstrahl moduliert, ist es dann geschickter mit einem Rechteck oder einem Cosinus zu demodulieren? In welchen Fällen ist dies andersrum?
"""

# ╔═╡ 55b7cd8d-9129-4639-bd6a-2edebb92964b
md"""
# Simulator

Einen Lock-In-Verstärker kann man mit reiner analoger Schaltungstechnik aufbauen (und das wird auch noch so [verkauft](https://www.thinksrs.com/products/sr2124124.html)). Oder man digitalisiert das Signal mit einem Analog-zu-Digital-Wandler und verarbeitet alles digital. In beiden Fällen arbeitet der LIA kontinuierlich. Zu jedem Zeitschritt wird ein Wert eingelesen und (ggf. mit etwas Verzögerung) der zugehörige demodulierte Wert ausgegeben.

Im Folgenden bespreche ich einen Simulator, der der Einfachheit halber auf ganzen Datensätzen arbeitet, dieses Wissen um die Zukunft des Signals aber nicht benutzt.
"""

# ╔═╡ c18f1769-6569-4e9d-8ff7-df10e4ddd63b
md"""
Wir definieren den zeitlichen Abstand $dt$ der Messwerte und eine Zeitachse.
"""

# ╔═╡ 240fae85-4a05-4ec7-b8aa-62d6afba4a76
begin
	dt = 0.001
	t = (0:dt:10)
end;

# ╔═╡ 91ac18b3-2063-4ffd-a295-f85bf47e75b2
md"""
Wir erzeugen ein Kosinus-förmiges Signal mit der Frequenz $f_0$, der Phase $d\phi$ der Amplitude $A$, das wir aber erst bei $t=1$s einschalten. Zusätzliche gibt es weißes (= spektral flaches) Rauschen mit der Standard-Abweichung 1. Die Photodiode detektiert die Summe von beiden.
"""

# ╔═╡ b1e023c5-8c51-42a4-994d-331ceb468e3c
begin
	f0 = 10
	dϕ = 0.5
	A = zeros(length(t))
	A[t .> 1] .= 2   # switch on at t=1 sec
	
	signal = A .* (1 .+ cos.(2π * t * f0 .+ dϕ))
	rauschen = randn(length(signal))
	dunkelstrom = 1
	
	diode = signal .+ rauschen .+ dunkelstrom
end;

# ╔═╡ 362c1186-db1d-44f3-8747-9e07cd748d62
plot(t[t .< 2], diode[t .< 2], 
	xlabel="Zeit (s)", ylabel="Diodenstrom (arb.u.)", 
	legend= false, title="Die ersten 2 Sekunden der Messung")

# ╔═╡ 572f9f71-85bc-4360-bcc6-0a058a68c56a
md"""
Jetzt bauen wir einen Lock-In-Verstärker.

Zunächst erzeugen wir zwei um 90 Grade phasenverschobene Referenz-Wellenformen bei der Frequenz $f_0$ von oben.
"""

# ╔═╡ d778736a-2992-4cde-bb4a-2e85cbe75028
begin
	refx = cos.(2π * t * f0)
	refy = sin.(2π * t * f0)

	plot(t[t .< 2], refx[t .< 2])
	aside(embed_display(plot!(t[t .< 2], refy[t .< 2], 
		leg=false, xlabel="Zeit", ylabel="ref")))
end

# ╔═╡ 5cf6a40e-a387-4e86-ad66-775e0921ab19
md"""
Dann mischen wir das Diodensignal mit den Referenz-Wellenformen
"""

# ╔═╡ 29e2ef64-425f-412f-87c6-09e1654d9579
begin
	xm = diode .* refx
	ym = diode .* refy

	plot(t[t .< 2], xm[t .< 2])
	aside(embed_display(plot!(t[t .< 2], ym[t .< 2], 
		leg=false, xlabel="Zeit", ylabel="misch")))
end

# ╔═╡ 9e015338-4ba0-4f33-900a-ad13e1a685e5
md"""
Schließlich nutzen wir einen Tiefpass-Filter aus 'DSP'. Der Faktor 2 korrigiert den Leistungsverlust durch das Abschneiden der Summenfrequenzen. 
"""

# ╔═╡ e21e6c24-b92a-4c0f-983a-a4b4d0ad3713
begin
	using DSP
	f_LP = 2
	myfilter = digitalfilter( Lowpass(f_LP; fs= 1/dt), Butterworth(4))
	x = 2 .* filt(myfilter, xm)
	y = 2 .* filt(myfilter, ym)
end;

# ╔═╡ e1946e51-417a-4b50-8ecd-bf8d779fdf7e
md"""
Insgesamt sieht das gemessene Signal dann so aus
"""

# ╔═╡ 1b1abd5a-a62f-4111-8317-072dbfb10b23
begin
	plot(t,x, label="x")
	plot!(t,y, label="y", xlabel="Zeit (s)", ylabel="Ausgang des LIA")
	plot!(t, A, label="A orig.")
end

# ╔═╡ 82782168-4965-4b9c-a3ee-3fec56bb0218
md"""
Die Werte von $x$ und $y$ erreichen $A$ nicht, weil wir eine Phasenverschiebung $d\phi$ vorgegeben hatten. Wir berechnen jetzt also $R$ und $\phi$
"""

# ╔═╡ 478209a0-8dd3-4c73-ac70-f397c9af6079
begin
	R = sqrt.(x.^2 + y.^2)
	phi = -1 .* atan.(y,x)
	
	 plot(t,R, label="R", layout=(2,1))
	plot!(t,A, label="A orig.", xlabel="Zeit (s)", ylabel="Amplitude")
	plot!(t, phi, label="phi", subplot=2)
	plot!(t, dϕ .+ t .* 0, label="phi orig.", subplot=2, ylabel="Phase (rad)")
end

# ╔═╡ 9862fa3a-3c20-4740-ab04-b6834481471f
md"""
### Rauschen

In dem hier simulierten Fall haben wir das Rauschen als konstant in Frequenzraum angenommen, mit $\sigma = 1$
"""

# ╔═╡ 3b241d94-e717-4179-9792-f4905563642f
std(rauschen) 

# ╔═╡ 1fc49ee2-26ff-4d94-9db1-552c355674bf
md"""
Die Sample-Rate $dt$ ist 1ms, die Nyquist-Frequenz also 500 Hz. Weil gelten muss
```math
\int_{f>0} | \text{Rauschen} (f)|^2 \, df = \sigma^2
```
ist also die spektrale Rauschdichte
```math
\text{Rauschen}(f) = \frac{\sigma}{\sqrt{500 \,Hz}} = \text{const.}
```
"""

# ╔═╡ c2e4966b-cfab-4999-8bff-66107ddefd8b
md"""
Unser Filter hat eine NEBW von $(round(nebw; digits=1)) Hz 
"""

# ╔═╡ d77b8d30-6af4-4d97-9b43-115dc72187d0
begin
	H = freqresp(myfilter, (0:0.0001:pi))
	df_filter_resp = 1 ./ (2 * length(H) * dt)
	nebw = sum(abs.(H).^2) * df_filter_resp
end

# ╔═╡ 514b46f8-8914-48ba-a61b-a436d30ca762
md"""
Durch das Tiefpass-Filtern sollte das Rauschen also um den Faktor $\sqrt{NEBW/f_\text{Nyq.}}$ zurück gehen, was auch so geschieht:
"""

# ╔═╡ 666d35d2-c043-4740-b6f3-59c44809c8ff
fnyq= 1/ (2 * dt);

# ╔═╡ 457072f5-ac8d-4bc6-ab2b-e184e1d9501d
(std(filt(myfilter, rauschen)), std(rauschen) * sqrt(nebw / fnyq) )

# ╔═╡ 3a5929b8-9145-4bfc-bcf8-997166f72394
md"""
Das Rauschen des LIA-Ausgangs ist durch die Rauschdichte im Filter-Passband gegeben, also auch um den Faktor $\sqrt{NEBW/f_\text{Nyq.}}$ reduziert. Wenn man $R$ statt $x$ oder $y$ betrachtet, kommt durch Fehlerfortpflanzung noch ein Faktor $\sqrt{2}$ dazu. (Wir schneiden hier die ersten 5 Sekunden ab.)
"""

# ╔═╡ 2c9e8538-28e1-45d3-b30d-2a1bfec8974b
std(R[t .> 5]) / sqrt(nebw / fnyq)

# ╔═╡ 5faa60fa-9c05-480d-b740-be3a7f133fd1
md"""
# Boxcar averaging

Alternativ zu einem Lock-In-Verstärker kann man auch boxcar averaging machen. Ein gepulster Laser produziert kurze Lichtpulse (ca. ps bis ns) in periodischen Abständen (ca. kHz). Dann kann man den Photostrom der Photodiode über kurze Intervalle entsprechend der Pulslänge integrieren, und in den langen Intervallen zwischen den Laserpulsen ignorieren. Dies tut ein [boxcar averager](https://en.wikipedia.org/wiki/Boxcar_averager). 

Man kann dies als Variante des Lock-in-Verstärker sehen, auch wenn es technologisch anders gelöst ist. Im Prinzip aber demoduliert man das Signal mit einer Rechteck-Referenzwelle, nur dass diese jetzt nicht wie oben gleich lang 1 und -1 zeigt, sondern die '1'-Phasen viel kürzer sind.

Technisch integriert man das Signal während der '1'-Phasen und mittelt dann über viele dieser Phasen. Die '-1'-Phasen ignoriert man oder beschafft sich eine andere Hintergrund-Messung.
"""

# ╔═╡ 80aff572-e704-4211-910c-657deedc9736
md"""
# Beispiel SR 830

Lock-In Verstärker SR830 von Stanford Research
- [Manual](https://www.thinksrs.com/downloads/pdfs/manuals/SR830m.pdf)
- [website](https://www.thinksrs.com/products/sr810830.html)
"""

# ╔═╡ b697daab-2f6f-4dbe-aacf-96c685392a9e
using PlutoUI

# ╔═╡ b3e9fa91-5201-4cfc-af17-cc499b436450
using Plots, StatsBase, FFTW

# ╔═╡ f8613b48-c51f-40fb-83b3-672c1069df39
TableOfContents(title="Inhalt")

# ╔═╡ 23b2f50e-5d41-411f-847e-95a71dcde261
aside(x) = PlutoUI.ExperimentalLayout.aside(x);

# ╔═╡ Cell order:
# ╟─c0fb4b16-f2af-40e3-a01e-35414bf95b9a
# ╟─5cdbcc8c-96f3-11ec-3e70-45ed796a8b3d
# ╟─a70e05af-8ddb-4181-ae49-c503af5231e5
# ╟─957916f2-c8a6-4a9e-a84d-851c5a7f8784
# ╟─010d3676-e41c-4f27-8640-36908c66117e
# ╟─efc79d57-5813-4064-8bb7-d8de71e3e8c7
# ╟─4f348530-7b3c-47b8-b7f2-804abe1a5e9b
# ╟─ba02ba73-8e4e-4b9b-8ddf-8c39bdd8ff8f
# ╟─c68ab966-1535-465c-bde0-fe7e49e7d4fa
# ╟─9cba2b6b-c64a-4303-9872-a1e2e2724085
# ╟─89d0ad35-b026-4fdc-9e26-42cfcb7b4cd4
# ╟─55b7cd8d-9129-4639-bd6a-2edebb92964b
# ╟─c18f1769-6569-4e9d-8ff7-df10e4ddd63b
# ╠═240fae85-4a05-4ec7-b8aa-62d6afba4a76
# ╟─91ac18b3-2063-4ffd-a295-f85bf47e75b2
# ╠═b1e023c5-8c51-42a4-994d-331ceb468e3c
# ╠═362c1186-db1d-44f3-8747-9e07cd748d62
# ╟─572f9f71-85bc-4360-bcc6-0a058a68c56a
# ╠═d778736a-2992-4cde-bb4a-2e85cbe75028
# ╟─5cf6a40e-a387-4e86-ad66-775e0921ab19
# ╠═29e2ef64-425f-412f-87c6-09e1654d9579
# ╟─9e015338-4ba0-4f33-900a-ad13e1a685e5
# ╠═e21e6c24-b92a-4c0f-983a-a4b4d0ad3713
# ╟─e1946e51-417a-4b50-8ecd-bf8d779fdf7e
# ╠═1b1abd5a-a62f-4111-8317-072dbfb10b23
# ╟─82782168-4965-4b9c-a3ee-3fec56bb0218
# ╠═478209a0-8dd3-4c73-ac70-f397c9af6079
# ╟─9862fa3a-3c20-4740-ab04-b6834481471f
# ╠═3b241d94-e717-4179-9792-f4905563642f
# ╟─1fc49ee2-26ff-4d94-9db1-552c355674bf
# ╟─c2e4966b-cfab-4999-8bff-66107ddefd8b
# ╠═d77b8d30-6af4-4d97-9b43-115dc72187d0
# ╟─514b46f8-8914-48ba-a61b-a436d30ca762
# ╠═666d35d2-c043-4740-b6f3-59c44809c8ff
# ╠═457072f5-ac8d-4bc6-ab2b-e184e1d9501d
# ╟─3a5929b8-9145-4bfc-bcf8-997166f72394
# ╠═2c9e8538-28e1-45d3-b30d-2a1bfec8974b
# ╟─5faa60fa-9c05-480d-b740-be3a7f133fd1
# ╟─80aff572-e704-4211-910c-657deedc9736
# ╠═b697daab-2f6f-4dbe-aacf-96c685392a9e
# ╠═b3e9fa91-5201-4cfc-af17-cc499b436450
# ╠═f8613b48-c51f-40fb-83b3-672c1069df39
# ╠═23b2f50e-5d41-411f-847e-95a71dcde261
