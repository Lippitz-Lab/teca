### A Pluto.jl notebook ###
# v0.19.4

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

# ╔═╡ 018cc916-0712-4bfc-9715-bf512c3930ab
using FFTW

# ╔═╡ 9cd7e35f-aa7f-465d-b4a2-343f65db63ac
using DSP

# ╔═╡ 317f4244-4748-48a8-b6ea-f5a7d09f8f0c
using StatsBase

# ╔═╡ 97a45280-804e-405a-afda-c220f21406b4
using  Colors, ImageShow, ImageIO

# ╔═╡ c3cb0bbb-fcc0-49f8-b66e-74ca7ac96108
using PlutoUI

# ╔═╡ 54daea9f-2c1e-4934-a666-b14b960bd45f
using Plots

# ╔═╡ f5450eab-0f9f-4b7f-9b80-992d3c553ba9
# DO NOT MODIFY, will be updated by update_navbar.jl
HTML("    <nav >\n    Vorbereitungen:\n\n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/index.html\"><em>Intro</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/software.html\"><em>Software</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/01-basic_syntax.html\"><em>Julia Basics</em></a> / \n\n<br>\nStatistik:\n\n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/02-beschreibende-statistik.html\"><em>Beschreibende Statistik</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/03-wahrscheinlichkeit.html\"><em>Wahrscheinlichkeit</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/04-schaetzung.html\"><em>Schätzung</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/05-messunsicherheit.html\"><em>Messunsicherheit</em></a> / \n\n<br>\nFourier-Transformation:\n\n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/06-Fourier-Transformation.html\"><em>Fourier-Transformation</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/07-Frequenzraum.html\"><em>Frequenzraum</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/08-Filter.html\"><em>Filter</em></a> / \n\n<br>\nMesstechnik:\n\n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/09-Rauschen.html\"><em>Rauschen</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/10-Detektoren.html\"><em>Detektoren</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/11-Lock-In.html\"><em>Lock-In-Verstärker</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/12-heterodyn.html\"><em>Heterodyn-Detektion</em></a> / \n\n<br>\n\n\n    </nav>\n\t")

# ╔═╡ aaa4db38-4e95-4d52-a316-67386c7393e6
html"""<div>
<font size="7"><b>7 Frequenzraum</b></font> </div>

<div><font size="5"> Markus Lippitz </font> </div>
<div><font size="5"> 20. Mai 2022 </font> </div>
"""

# ╔═╡ d98ac7ca-96f2-11ec-0d44-b7943badb165
md"""
**Ziele** Sie können Julia benutzen, um Signale im
Frequenzraum zu *analysieren*.

-   Fast Fourier Transform FFT

-   Frequenzachse

-   Abtastrate, Länge und 'zero padding'


**Weitere Aufgaben**

-   Signale transformieren und im Fourier-Raum filtern

**Literatur** Butz Kap. 4, Horowitz / Hill, Kap. 1.08, 7.20,
15.18
"""

# ╔═╡ b462d67d-e8fe-4970-8346-1561ab2e3fc7
md"""
# Diskrete FT: eine periodische Zahlenfolge und deren Fourier-Transformierte Zahlenfolge

Insbesondere wenn man mit einem Computer Messwerte erfasst und
auswertet, dann kennt man die gemessene Funktion $f(t)$ weder auf einer
kontinuierlichen Achse $t$, sondern nur zu diskreten Zeiten
$t_k = k \, \Delta t$, noch kennt man die Funktion von $t = - \infty$
bis $t = + \infty$. Als Ausgangspunkt hat man also nur eine Zahlenfolge
$f_k$ endlicher Länge.

Weil wir die Zahlenfolge außerhalb des gemessenen Intervalls nicht
kennen machen wir die Annahme, dass sie periodisch ist. Bei $N$
gemessenen Werte ist die Periodendauer also $T = N \Delta t$. Der
Einfachheit halber definieren wir auch $f_k = f_{k + N}$ und somit
$f_{-k} = f_{N - k}$ mit $k= 0, 1, \dots, N-1$. Damit wird die
Fourier-Transformation 
```math
 F_j =  \frac{1}{N} \, \sum_{k=0}^{N-1} \, f_k \, e^{- k \, j \, 2 \pi i / N } \\
```
und die inverse Fourier-Transformation
```math
f_k =   \sum_{j=0}^{N-1} \, F_j \, e^{+ k \,  j \, 2 \pi i / N } 
```
Diese Definition nach Butz ist wieder so, dass $F_0$ dem Mittelwert entspricht. 
Wegen $f_{-k} = f_{N - k}$ liegen die positiven Frequenzen mit
steigender Frequenz in der ersten Hälfte von $F_j$. Danach kommen die
negativen Frequenzen, beginnend bei der 'negativsten' Frequenz steigend
mit zur letzten Frequenz vor der Frequenz Null. Die maximal darstellbare
Frequenz ist also die Nyquist-Frequenz
```math
f_\text{Nyquist} = \frac{1}{2 \Delta t}
```
bzw. Nyquist-Kreis-Frequenz
```math
\Omega_\text{Nyquist} = \frac{\pi}{\Delta t}
```
Diese Frequenz ist also gerade so, dass wir zwei Samples pro Periode der Oszillation messen. Schnellere Oszillationen bzw. weniger Samples pro Periode sind nicht darstellbar. Schon bei $f_\text{Nyquist}$ ist der Imaginärteil immer Null, weil wir den Sinus gerade immer in Nulldurchgang sampeln.
"""

# ╔═╡ 8fe17b2a-356f-4fdb-b04b-a440402f3a12
md"""
Es ist je nach geradem oder ungeraden $N$ ein klein wenig aufwändig, die jeweiligen Frequenzen zu berechnen. Wir benutzen hier und im folgenden das Paket [FFTW](https://www.fftw.org/), das dies für uns erledigt.

Hier als Beispiel die Frequenzen bei $\Delta t = 1$ und 5 bzw 6 Elementen
"""

# ╔═╡ 6c5e00a0-2239-4ec8-a929-9bc695cae5b2
fftfreq(5)

# ╔═╡ 3a337cba-31b1-433d-adc0-857438731585
fftfreq(6)

# ╔═╡ 1ea381a9-5bf1-4a64-87fc-a89557b7c15b
md"""
# FFTW

In Julia können wir das Paket [FFTW](https://www.fftw.org/) benutzen. Dabei wechselt allerdings der Vorfaktor $1/N$ von der Hin- zur Rück-Transformation, also
```math
 F_j =   \sum_{k=0}^{N-1} \, f_k \, e^{- k \, j \, 2 \pi i / N } \\
```
und die inverse Fourier-Transformation
```math
f_k =  \frac{1}{N} \, \sum_{j=0}^{N-1} \, F_j \, e^{+ k \,  j \, 2 \pi i / N } 
```
In Gleichungen benutze ich (und Butz) mathematische Indizes (startend von Null). Julia zählt ab Eins, also ausnahmsweise hier zwei Gleichungen mit Julia-Indizes
```math
 F_\tilde{j} =   \sum_{\tilde{k}=1}^{N} \, f_\tilde{k} \, e^{- (\tilde{k}-1) \, (\tilde{j}-1) \, 2 \pi i / N } \\
```
und die inverse Fourier-Transformation
```math
f_\tilde{k} =  \frac{1}{N} \, \sum_{\tilde{j}=1}^{N} \, F_\tilde{j} \, e^{+ (\tilde{k}-1) \,  (\tilde{j}-1) \, 2 \pi i / N } 
```
"""

# ╔═╡ e8e9eeaa-7215-40c3-8da1-85619057fa24
md"""
Die Fourier-Transformierte einer Konstanten ist die Delta-Funktion, also ist nur das erste Element, also das bei $f=0$ von Null verscheiden und gleich der Summe der Werte im Zeitraum
"""

# ╔═╡ dd7bc6e1-8940-4cd6-aa51-6e5d5646c5f3
fft([1 1 1 1])

# ╔═╡ e1340e20-7e6a-4a2e-a2f1-7675339000f2
md"""
Die inverse FFT geht auch und beinhaltet hier das $1/N$
"""

# ╔═╡ f72a909a-40ef-4c8f-8ee3-e3a773e4b68a
ifft([1 0 0 0])

# ╔═╡ fc5c971a-6eb7-4fa4-be01-0744418ca9cd
md"""
## Wrapping & fftshift

Im nächsten Beispiel Fourier-transformieren wir einen Kosinus
"""

# ╔═╡ 26a9e690-48b0-4570-ad93-7f9313c9c56d
f_cos = cos.((0:7)./8 .* 2pi)

# ╔═╡ f2ffd762-9726-4c90-8f47-26e039c3bef6
md"""
In diesem Fall ist die FT rein reelwertig und wir ignorieren den Imaginärteil an der numerischen Rauschgrenze.
"""

# ╔═╡ 04d626a1-c7f3-407e-be0e-2dfe8d0fac79
F_cos = real.(fft(f_cos))

# ╔═╡ 69d0c072-8239-498e-9026-c5f7910de05f
md"""
Von Null verschieden sind die Werte beim Julia-Index 2 und 8, mathematisch also 1 und 7. Generell gilt bei reellen Ausgangswerten
```math
F_{N-j} = F_j^\star
```
Hier also $F_1 = F_7$
"""

# ╔═╡ 5168ba4e-e236-45ef-8720-b11ec082cfba
md"""
Es müssen zwei Werte von Null verschieden sein, weil
```math
 \cos(x) = \frac{1}{2} \left(e^{i x} + e^{-i x} \right)
```
"""

# ╔═╡ 80ed06c1-21bf-4d5d-be96-0ece54fb69f5
md"""
Die Position dieser zwei von Null verschiedenen Werte ist eine Folge der Definition der $F_k$: zunächst kommen alle positiven Frequenzen und dann alle negativen, oder
"""

# ╔═╡ 3e195fd3-9f69-4f27-8f93-c1f6346ce93a
fftfreq(length(f_cos))

# ╔═╡ 76561f01-fdf0-4e54-8d7b-3902833a0614
md"""
Zur Darstellung schöner ist es oft, wenn die Frequenz Null nicht am Rand sondern in der Mitte zwischen den positiven und negativen Frequenzen ist. Dies bewirkt fftshift bzw. rückwärts  ifftshift
"""

# ╔═╡ 37487ff0-e727-4f7f-83b6-5e12b3c93aaa
fftshift(fftfreq(length(f_cos)))

# ╔═╡ a9cd6620-e89d-4219-b96b-6a8ee44f0e1f
md"""
Damit können wir alles über der Frequenzachse darstellen
"""

# ╔═╡ 92d632ec-1f53-4fa5-bc1c-2aeddce63c37
plot(fftshift(fftfreq(length(f_cos))), fftshift(real(fft(f_cos))), xlabel="Frequenz (1/Dt)", ylabel="F_cos", leg=false)

# ╔═╡ ee83e070-5cfa-4335-87cb-b4d9614182c9
md"""
## Selbsttest

Ersetzen Sie den Cosinus durch einen Sinus in diesem Beispiel und erklären Sie das Ergebnis.
"""

# ╔═╡ b4f09614-bfa4-48a2-8f5a-8c73d8312146
md"""
# Sampling-Theorem

Wir brauchen mindestens zwei Samples pro Periode, um eine Funktion durch ihre Fourier-Koeffizienten darstellen zu können. Die Frequenzen müssen also unterhalb der Nyquist-Frequenz $f_\text{Nyquist}$ liegen mit
```math
f_\text{Nyquist} = \frac{1}{2 \Delta t} \quad .
```
Das Sampling-Theorem besagt, dass dies dann aber auch ausreichend ist.
"""

# ╔═╡ 3f313616-96e2-4ed2-95db-ba8f12dd98b3
md"""
Sei $f(t)$ eine bandbreiten-begrenzte Funktion, also $F(\omega)$ nur im Intervall $|\omega| \le \Omega_\text{Nyquist}$ von Null verschieden. Dann gilt das Sampling-Theorem (Beweis siehe Butz Kap.4.4)
```math
f(t) = \sum_{k=-\infty}^{\infty} \, f( k \Delta t) \, \text{sinc} \left( \Omega_\text{Nyquist} \cdot [t - k \Delta t] \right)
```
"""

# ╔═╡ 21cd702b-f125-4326-b15c-5ab1a68063aa
md"""
Es reicht also aus, $f$ alle $\Delta t$ zu samplen. An den Zeiten dazwischen ist $f$ durch die (unendlich lange) Summe der benachbarten Werte mal sinc vollständig beschrieben.

In der Messtechnik müssen wir also nur beispielsweise durch einen Filter sicherstellen, dass alle Frequenzen eines Signals unter $\Omega_\text{Nyquist}$ liegen, und unsere digitale Erfassung des Signals ist identisch mit dem Signal selbst.

Wenn wir aber zu selten samplen, bzw. doch höhere Frequenzen vorhanden sind, dann werden diese zu hohen Frequenz-Komponenten an der dann niedrigeren Nyquist-Frequenz gespiegelt und landen bei scheinbar niedrigeren Frequenzen. Dieses 'aliasing' verfälscht dann das Signal.
"""

# ╔═╡ e9da4158-8713-4ec1-9c86-f8fea01f475b
md"""
# Zero padding
"""

# ╔═╡ dbcd21a9-756b-414b-8972-a8e6b32a054e
md"""
Wir hatten ganz oben angefangen mit einer periodischen Zahlenfolge und deren Fourier-Transformation. Die Länge der Zahlenfolge war in den Beispielen immer so gewählt, dass dies gerade einem ganzzahligen Vielfachen der Periodendauer entsprach. Das geht aber natürlich in der Praxis nicht. Wir kennen in Zweifelsfall die Periodendauer des Signals nicht, oder nicht genau genug. Oder es sind sogar mehrere Signale mit unterschiedlicher Frequenz von Interesse.

Das Problem ist dann der Abschneide-Fehler, der zu Artefakten in der Fourier-Transformation führt.
"""

# ╔═╡ 0eb60e57-1fd1-4df8-866c-851a13bb765e
md"""
Stellen Sie in diesem Beispiel $n_\text{sample}$ so ein, dass der Fehler minimal wird!
"""

# ╔═╡ 1d0fd915-c0c2-41cd-a788-11ff2a054bce
md"""
Datenpunkte im Sample $n_\text{sample}$ $(@bind n_sample Slider(5:17; default=12, show_value=true))
"""

# ╔═╡ 4d9e9381-4510-4a61-84f2-ffc927e1b64c
let
	ts = 1/8
	time = (0:n_sample-1) .* ts;
	f_cos = cos.(2pi * time)

	time2 = (0:2 *n_sample-1) .* ts;
	f_cos2 = cos.(2pi * time2)
	
	plot(f_cos2, layout=(2,1), label="echte Fortsetzung")
	plot!([f_cos; f_cos], xlabel="Index", ylabel="f_cos", label="periodische Fortsetzung")
	plot!(fftshift(fftfreq(length(f_cos),1/ts)), 
		fftshift(real.(fft(f_cos)))./n_sample, 
		yrange=(-0.3,0.54), xrange=(-4,4), xlabel="Frequenz", ylabel="F_cos", leg=false,layout=(2,1), subplot=2)
	scatter!([-1, 1], [0.5, 0.5], subplot=2)
end

# ╔═╡ 62fe679c-b369-48af-8cc1-70f34c5b68ce
md"""
Der Ausweg ist **zero-padding**. Sei unsere eigentlich gemessene Signalfolge $f(t)$, die wir im Intervall $[-T, T]$ kennen. Nun tun wir so, als hätten wir statt dessen gemessen
```math
g(t) = f(t) \cdot w(t)
```
mit der Fensterfunktion $w(t)$
```math
w(t) = 1 \quad \text{für} \quad  -T < t < T \quad \text{sonst}  = 0
```
Damit können wir $g(t)$ über beliebig lange Zeiten 'messen', weil es ja quasi immer Null ist. Die Fourier-Transformierte ist aber
```math
G(\omega) = F(\omega) \otimes W(\omega)
```
mit 
```math
W(\omega)=  2T \,  \frac{\sin \omega T}{\omega T} = 2T \, \text{sinc}( \omega T)
```
"""

# ╔═╡ 42be164a-a8ea-4008-9e47-6adbf687fdeb
md"""
Wir verlängern also unseren Datensatz zu beiden Seiten mit Nullen. Der Effekt ist, dass wir die eigentliche Fourier-Transformation unseres Datensatzes falten mit einem $\text{sinc}$, dessen charakteristische Breite durch die eigentliche Messdauer bestimmt ist. Die Frequenzauflösung steigt dadurch also nicht. Vielmehr geschieht eine Art Interpolation im Fourier-Raum, die gerade die Artefakte des Abschneide-Fehlers beseitigt.
"""

# ╔═╡ 4a0111a9-afa5-4df7-9abe-73440ea10489
md"""
Wir betrachten den gleichen Datensatz wie oben, nur 'verlängern' wir ihn auf die 10-fache Länge. Dadurch hat der Abschneidefehler weniger Einfluss und der Peak liegt im Frequenzraum immer bei 1 Hz. Das erzeugt aber natürlich nicht mehr Auflösung. Nahe beieinander liegende Peaks können durch zero-padding nicht getrennt werden, nur die Position eines Peaks besser bestimmt werden.
"""

# ╔═╡ 29a55b4d-68cc-438f-af96-1269b1794791
md"""
Datenpunkte im Sample $(@bind n_sample2 Slider(5:18; default=12, show_value=true))
"""

# ╔═╡ c28fdbb7-7e95-45fe-a69f-e4149f8e4d6f
let
	ts = 1/8
	time = (0:n_sample2-1) .* ts;
	f_cos = cos.(2pi * time)
	F_cos = fft(f_cos)

	padded = [ f_cos; zeros(9 .* size(f_cos))]
	F_padded = fft(padded)
	
	scatter(fftshift(fftfreq(length(F_cos), 1/ts)), fftshift(abs.(F_cos))./n_sample2,
		yrange=(-0.1,0.6), xlabel="Frequenz", ylabel="F_cos", label="orginal")
	plot!(fftshift(fftfreq(length(F_padded), 1/ts)), fftshift(abs.(F_padded))./n_sample2, label="padded")
	scatter!([-1, 1], [0.5, 0.5], label="ideal")
end

# ╔═╡ fa42cdfd-21a7-4807-895b-f6956a94e50a
md"""
Typische Fensterfunktionen sind im Bereich $|x| = |t/T| < 1/2$
```math
\text{Kosinus} = \cos \pi x
```
```math
\text{Dreieck} = 1 - 2 |x|
```
```math
\text{Hanning} = \cos^2 \pi x
```
```math
\text{Hamming} = a + (1-a)\cos^2 \pi x \quad \text{in DSP.jl mit } a = 0.54
```
```math
\text{Gauss} = \exp \left( - \frac{1}{2} \frac{x^2}{\sigma^2} \right)
```
```math
\text{Kaiser-Bessel} = \frac{I_0(\pi \alpha \sqrt{1-4 x^2})}{I_0(\pi \alpha)} \quad \text{mit der modifizierten Bessel-Funktion } I_0
```
"""

# ╔═╡ 99bbe9f9-13fd-4f3b-8992-84025ccbe233
md"""
Fensterfunktion $(@bind window Select(["rect", "hanning", "hamming", "cosine",  "triang", "gaussian","kaiser"]; 	default="hanning")) , Parameter σ bei Gauss bzw. 1/α bei Kaiser $(@bind win_p NumberField(0.1:0.1:1, default=0.5))
"""

# ╔═╡ d3e33164-811d-4abd-b04f-8d72ab4959d9
let
	
	if  (window=="gaussian")
		expr = "DSP.Windows.$(window)(100, $(win_p); padding=1000)"
	else
		if (window=="kaiser") 
			expr = "DSP.Windows.$(window)(100, $(1/win_p); padding=1000)"
		else
			expr = "DSP.Windows.$(window)(100; padding=1000)"
		end
	end
	w = eval(Meta.parse(expr))
	
	x = fftshift(fftfreq(length(w)))
	fftabs(y) = fftshift(abs.(fft(y).^2))
	
	plot(w, layout=(2,1), title=window, xrange=(0,200), subplot=1, leg=false, xlabel="Zeit")
	plot!(x, fftabs(w), yaxis = (:log10,  (1e-7,Inf)), subplot=2, leg=false, xlabel="Frequenz")
end

# ╔═╡ 075311f1-ee81-4817-9b50-f82043a8d14f
md"""
Mit einem Fenster verkleinert man zwar die gemessenen Werte, macht die Fourier-Transformation aber glatter, weil der Übergang zum zero-Padding glatter wird. Damit erkennt man die Peaks bei $\pm 1$Hz auch schon bei sehr wenig gesampelten Punkten.
"""

# ╔═╡ dc62ff66-1b00-4f2c-911b-f45edd18edb7
md"""
Datenpunkte im Sample $(@bind n_sample3 Slider(5:22; default=12, show_value=true))
"""

# ╔═╡ 6c3e13d5-3dcf-4470-839b-e4057ef61fe7
let
	ts = 1/8
	time = (0:n_sample3-1) .* ts;
	f_cos = cos.(2pi * time)
	F_cos = fft(f_cos)

	padded = [ f_cos ; zeros(9 .* size(f_cos))]
	F_padded = fft(padded)
	
	window = DSP.Windows.hamming(length(f_cos))
	window = window .* 2
	windowed = [ f_cos .* window; zeros(9 .* size(f_cos))]
	F_windowed = fft(windowed)
	
	scatter(fftshift(fftfreq(length(F_cos), 1/ts)), fftshift(abs.(F_cos))./n_sample3,
		yrange=(-0.4,0.6), xlabel="Frequenz", ylabel="F_cos", label="orginal")
	plot!(fftshift(fftfreq(length(F_padded), 1/ts)), fftshift(abs.(F_padded))./n_sample3, label="padded")
	plot!(fftshift(fftfreq(length(F_windowed), 1/ts)), 
		fftshift(abs.(F_windowed))./n_sample3, label="windowed", linewidth = 4 )
	scatter!([-1, 1], [0.5, 0.5], label="ideal")
end

# ╔═╡ f13f364c-076b-41e9-95e4-bc45750bec4a
md"""
# Beispiel

aus Butz, Kapitel 3.10
"""

# ╔═╡ 27e978c0-063b-4b79-81c5-b05be2a2979c
md"""
Wir betrachten eine Summe aus 6 Kosinus-Funktionen mit teils sehr unterschiedlichen Amplituden $A_l$ und Frequenzen $f_l$. Wir samplen 256 Datenpunkte im Abstand von  $1/8$ der längsten Periode, also nur $8/3$ Datenpunkte pro Oszillation der höchsten vorkommenden Frequenz. Diese ist um 5 Größenordnungen schwächer als die niedrigste Frequenz. Trotzdem findet man diesen Peak durch ein passendes Fenster und zero-padding.
"""

# ╔═╡ 7a421503-9dd0-49c2-82b2-d709652ef4a9
md"""
Fensterfunktion $(@bind window2 Select(["rect", "hanning", "hamming", "cosine", "lanczos", "triang", "gaussian","kaiser"]; 	default="rect")) , Parameter σ bei Gauss bzw. 1/α bei Kaiser $(@bind win_p2 NumberField(0.1:0.1:1, default=0.5))
"""

# ╔═╡ 972b455a-0d20-4f1d-98df-28e9b219b148
let
	fl = [1 1.15   1.25   2     2.27      3]
	Al = [1 1e-2   1e-3  1e-3    1e-4   1e-5]
	
	dt = 1/8
	time = (-127:127).*dt;
	signal = [ sum(Al .* cos.(2pi .* fl .* t)) for t in time];

	if (window2=="gaussian")
		expr = "DSP.Windows.$(window2)($(length(signal)),$(win_p2))"
	else
		if (window2=="kaiser") 
			expr = "DSP.Windows.$(window2)($(length(signal)),$(1/win_p2))"
		else
			expr = "DSP.Windows.$(window2)($(length(signal)))"
		end
	end

	window = eval(Meta.parse(expr))
	windowed = [(signal.* window); zeros(15 .* size(signal))]
	F_windowed = abs.(fft(windowed))
	
	plot(fftshift(fftfreq(length(F_windowed), 1/dt)), 
		 fftshift(F_windowed)./maximum(F_windowed), 
		legend=false, yaxis=(:log, (1e-8, Inf)), xrange=(0, 4)	, title=window2)
	scatter!(fl, Al)
end

# ╔═╡ 77f4138a-0897-4153-b752-d938062d62ed
md"""
# Spielwiese: 2D FFT von Bildern
"""

# ╔═╡ f2189dbb-163e-40b9-bae4-65f7691a1bdd
md"""
Erlauben Sie ihrem Webbrowser, auf die Kamera zuzugreifen und nehmen Sie dann einen Schnappschuss auf! Zeigen Sie Ihrer Kamera einfache Muster und vergleichen Sie die Fourier-Transformierte mit Ihren Erwartungen.
"""

# ╔═╡ 9b933f4b-92bf-48b8-91f6-980ea65ea18c
md"""

"""

# ╔═╡ 008c6d5a-263a-4388-88bb-6521a9cb8aab
TableOfContents(title="Inhalt")

# ╔═╡ 8fc2995f-762b-40be-a396-95b6bd3b914c
aside(x) = PlutoUI.ExperimentalLayout.aside(x);

# ╔═╡ 8efe839c-a111-4810-a175-5365a55c4900
aside(embed_display(plot(f_cos, leg=false, xlabel="Index", ylabel="fcos")))

# ╔═╡ a0a36f9f-b1fb-4df1-9d19-d1c160d8a6ec
aside(embed_display(plot(F_cos, leg=false, xlabel="Index", ylabel="fcos")))

# ╔═╡ 99f6558e-8f7a-40e5-8c33-8fb377be0cca
md"""
# Windowing

Die Oszillationen im Spektrum im letzten Beispiel sind immer noch Artefakte. Eigentlich würde man ja zwei Delta-Funktionen bei $\pm 1$Hz erwarten. Sie sind eine Konsequenz des Rechteck-Fensters $w(t)$, das zum sinc in Frequenzraum führt. Das Rechteck-Fenster ist in dem Sinne natürlich, dass wir immer zu einen bestimmten Zeitpunkt anfangen und aufhören, zu messen. 

[Andere Fensterfunktionen](https://en.wikipedia.org/wiki/Window_function#A_list_of_window_functions) sind aber unter Umständen besser. Sie unterscheiden sich in der Breite des Peaks und im Abfall der Flanken. Leider muss man aber das eine gegen das andere einhandeln. Interessante Parameter sind die Breite des zentralen Peaks im Frequenzraum, gemessen als -3dB-Bandbreite, sowie die Seitenbandenunterdrückung in dB oder deren Abfall in dB/Oktave.
$(aside(md"dB = Dezibel = 10 log_10 x"))
"""

# ╔═╡ 1dfdcd5f-a35b-4297-ad7a-35c83206e181
md"""
Webcam routines from 
https://computationalthinking.mit.edu/Spring21/notebooks/week1/images.html
"""

# ╔═╡ 474eaefe-470d-46bf-bbb2-1f80773a85d2
function process_raw_camera_data(raw_camera_data)
	# the raw image data is a long byte array, we need to transform it into something
	# more "Julian" - something with more _structure_.
	
	# The encoding of the raw byte stream is:
	# every 4 bytes is a single pixel
	# every pixel has 4 values: Red, Green, Blue, Alpha
	# (we ignore alpha for this notebook)
	
	# So to get the red values for each pixel, we take every 4th value, starting at 
	# the 1st:
	reds_flat = UInt8.(raw_camera_data["data"][1:4:end])
	greens_flat = UInt8.(raw_camera_data["data"][2:4:end])
	blues_flat = UInt8.(raw_camera_data["data"][3:4:end])
	
	# but these are still 1-dimensional arrays, nicknamed 'flat' arrays
	# We will 'reshape' this into 2D arrays:
	
	width = raw_camera_data["width"]
	height = raw_camera_data["height"]
	
	# shuffle and flip to get it in the right shape
	reds = reshape(reds_flat, (width, height))' / 255.0
	greens = reshape(greens_flat, (width, height))' / 255.0
	blues = reshape(blues_flat, (width, height))' / 255.0
	
	# we have our 2D array for each color
	# Let's create a single 2D array, where each value contains the R, G and B value of 
	# that pixel
	
	RGB.(reds, greens, blues)
end

# ╔═╡ 44730fab-9238-4135-ae6e-43a114db810e
function camera_input(;max_size=150, default_url="https://i.imgur.com/SUmi94P.png")
"""
<span class="pl-image waiting-for-permission">
<style>
	
	.pl-image.popped-out {
		position: fixed;
		top: 0;
		right: 0;
		z-index: 5;
	}

	.pl-image #video-container {
		width: 250px;
	}

	.pl-image video {
		border-radius: 1rem 1rem 0 0;
	}
	.pl-image.waiting-for-permission #video-container {
		display: none;
	}
	.pl-image #prompt {
		display: none;
	}
	.pl-image.waiting-for-permission #prompt {
		width: 250px;
		height: 200px;
		display: grid;
		place-items: center;
		font-family: monospace;
		font-weight: bold;
		text-decoration: underline;
		cursor: pointer;
		border: 5px dashed rgba(0,0,0,.5);
	}

	.pl-image video {
		display: block;
	}
	.pl-image .bar {
		width: inherit;
		display: flex;
		z-index: 6;
	}
	.pl-image .bar#top {
		position: absolute;
		flex-direction: column;
	}
	
	.pl-image .bar#bottom {
		background: black;
		border-radius: 0 0 1rem 1rem;
	}
	.pl-image .bar button {
		flex: 0 0 auto;
		background: rgba(255,255,255,.8);
		border: none;
		width: 2rem;
		height: 2rem;
		border-radius: 100%;
		cursor: pointer;
		z-index: 7;
	}
	.pl-image .bar button#shutter {
		width: 3rem;
		height: 3rem;
		margin: -1.5rem auto .2rem auto;
	}

	.pl-image video.takepicture {
		animation: pictureflash 200ms linear;
	}

	@keyframes pictureflash {
		0% {
			filter: grayscale(1.0) contrast(2.0);
		}

		100% {
			filter: grayscale(0.0) contrast(1.0);
		}
	}
</style>

	<div id="video-container">
		<div id="top" class="bar">
			<button id="stop" title="Stop video">✖</button>
			<button id="pop-out" title="Pop out/pop in">⏏</button>
		</div>
		<video playsinline autoplay></video>
		<div id="bottom" class="bar">
		<button id="shutter" title="Click to take a picture">📷</button>
		</div>
	</div>
		
	<div id="prompt">
		<span>
		Enable webcam
		</span>
	</div>

<script>
	// based on https://github.com/fonsp/printi-static (by the same author)

	const span = currentScript.parentElement
	const video = span.querySelector("video")
	const popout = span.querySelector("button#pop-out")
	const stop = span.querySelector("button#stop")
	const shutter = span.querySelector("button#shutter")
	const prompt = span.querySelector(".pl-image #prompt")

	const maxsize = $(max_size)

	const send_source = (source, src_width, src_height) => {
		const scale = Math.min(1.0, maxsize / src_width, maxsize / src_height)

		const width = Math.floor(src_width * scale)
		const height = Math.floor(src_height * scale)

		const canvas = html`<canvas width=\${width} height=\${height}>`
		const ctx = canvas.getContext("2d")
		ctx.drawImage(source, 0, 0, width, height)

		span.value = {
			width: width,
			height: height,
			data: ctx.getImageData(0, 0, width, height).data,
		}
		span.dispatchEvent(new CustomEvent("input"))
	}
	
	const clear_camera = () => {
		window.stream.getTracks().forEach(s => s.stop());
		video.srcObject = null;

		span.classList.add("waiting-for-permission");
	}

	prompt.onclick = () => {
		navigator.mediaDevices.getUserMedia({
			audio: false,
			video: {
				facingMode: "environment",
			},
		}).then(function(stream) {

			stream.onend = console.log

			window.stream = stream
			video.srcObject = stream
			window.cameraConnected = true
			video.controls = false
			video.play()
			video.controls = false

			span.classList.remove("waiting-for-permission");

		}).catch(function(error) {
			console.log(error)
		});
	}
	stop.onclick = () => {
		clear_camera()
	}
	popout.onclick = () => {
		span.classList.toggle("popped-out")
	}

	shutter.onclick = () => {
		const cl = video.classList
		cl.remove("takepicture")
		void video.offsetHeight
		cl.add("takepicture")
		video.play()
		video.controls = false
		console.log(video)
		send_source(video, video.videoWidth, video.videoHeight)
	}
	
	
	document.addEventListener("visibilitychange", () => {
		if (document.visibilityState != "visible") {
			clear_camera()
		}
	})


	// Set a default image

	const img = html`<img crossOrigin="anonymous">`

	img.onload = () => {
	console.log("helloo")
		send_source(img, img.width, img.height)
	}
	img.src = "$(default_url)"
	console.log(img)
</script>
</span>
""" |> HTML
end


# ╔═╡ 3f9a3bc0-1063-44c9-9710-b81e5b528bd9
@bind webcam_data camera_input()

# ╔═╡ 49e196e2-c62e-40e2-b6d7-675640258885
snapshot = process_raw_camera_data(webcam_data)

# ╔═╡ 812372c8-82d7-4fee-8b0c-a9e22ae398c2
spatial_data = Real.(Gray.(snapshot));

# ╔═╡ 5133276a-8995-4ce9-a1f5-2c4caf116e20
freq_data = abs.(fftshift(fft(spatial_data .- mean(spatial_data) )));

# ╔═╡ dc548c88-d969-4eaf-8ddd-938f953fda1a
ft_snapshot = Gray.(freq_data ./ maximum(freq_data))

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Colors = "5ae59095-9a9b-59fe-a467-6f913c188581"
DSP = "717857b8-e6f2-59f4-9121-6e50c889abd2"
FFTW = "7a1cc6ca-52ef-59f5-83cd-3a7055c09341"
ImageIO = "82e4d734-157c-48bb-816b-45c225c6df19"
ImageShow = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
StatsBase = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"

[compat]
Colors = "~0.12.8"
DSP = "~0.7.5"
FFTW = "~1.4.6"
ImageIO = "~0.6.5"
ImageShow = "~0.3.6"
Plots = "~1.29.0"
PlutoUI = "~0.7.38"
StatsBase = "~0.33.16"
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

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.CEnum]]
git-tree-sha1 = "eb4cb44a499229b3b8426dcfb5dd85333951ff90"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.2"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "9950387274246d08af38f6eef8cb5480862a435f"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.14.0"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "1e315e3f4b0b7ce40feded39c73049692126cf53"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.3"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "7297381ccb5df764549818d9a7d57e45f1057d30"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.18.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "a985dc37e357a3b22b260a5def99f3530fb415d3"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.2"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "3f1f500312161f1ae067abe07d13b40f78f32e07"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.8"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[deps.Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "b153278a25dd42c65abbf4e62344f9d22e59191b"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.43.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[deps.DSP]]
deps = ["Compat", "FFTW", "IterTools", "LinearAlgebra", "Polynomials", "Random", "Reexport", "SpecialFunctions", "Statistics"]
git-tree-sha1 = "3e03979d16275ed5d9078d50327332c546e24e68"
uuid = "717857b8-e6f2-59f4-9121-6e50c889abd2"
version = "0.7.5"

[[deps.DataAPI]]
git-tree-sha1 = "fb5f5316dd3fd4c5e7c30a24d50643b73e37cd40"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.10.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "cc1a8e22627f33c789ab60b36a9132ac050bbf75"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.12"

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

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "b19534d1895d702889b219c382a6e18010797f0b"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.6"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

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

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "9267e5f50b0e12fdfd5a2455534345c4cf2c7f7a"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.14.0"

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
git-tree-sha1 = "b316fd18f5bc025fedcb708332aecb3e13b9b453"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.64.3"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "1e5490a51b4e9d07e8b04836f6008f46b48aaa87"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.64.3+0"

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

[[deps.Graphics]]
deps = ["Colors", "LinearAlgebra", "NaNMath"]
git-tree-sha1 = "1c5a84319923bea76fa145d49e93aa4394c73fc2"
uuid = "a2bd30eb-e257-5431-a919-1863eab51364"
version = "1.1.1"

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

[[deps.ImageBase]]
deps = ["ImageCore", "Reexport"]
git-tree-sha1 = "b51bb8cae22c66d0f6357e3bcb6363145ef20835"
uuid = "c817782e-172a-44cc-b673-b171935fbb9e"
version = "0.1.5"

[[deps.ImageCore]]
deps = ["AbstractFFTs", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Graphics", "MappedArrays", "MosaicViews", "OffsetArrays", "PaddedViews", "Reexport"]
git-tree-sha1 = "9a5c62f231e5bba35695a20988fc7cd6de7eeb5a"
uuid = "a09fc81d-aa75-5fe9-8630-4744c3626534"
version = "0.9.3"

[[deps.ImageIO]]
deps = ["FileIO", "IndirectArrays", "JpegTurbo", "LazyModules", "Netpbm", "OpenEXR", "PNGFiles", "QOI", "Sixel", "TiffImages", "UUIDs"]
git-tree-sha1 = "d9a03ffc2f6650bd4c831b285637929d99a4efb5"
uuid = "82e4d734-157c-48bb-816b-45c225c6df19"
version = "0.6.5"

[[deps.ImageShow]]
deps = ["Base64", "FileIO", "ImageBase", "ImageCore", "OffsetArrays", "StackViews"]
git-tree-sha1 = "b563cf9ae75a635592fc73d3eb78b86220e55bd8"
uuid = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
version = "0.3.6"

[[deps.Imath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "87f7662e03a649cffa2e05bf19c303e168732d3e"
uuid = "905a6f67-0a94-5f89-b386-d35d92009cd1"
version = "3.1.2+0"

[[deps.IndirectArrays]]
git-tree-sha1 = "012e604e1c7458645cb8b436f8fba789a51b257f"
uuid = "9b13fd28-a010-5f03-acff-a1bbcff69959"
version = "1.0.0"

[[deps.Inflate]]
git-tree-sha1 = "f5fc07d4e706b84f72d54eedcc1c13d92fb0871c"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.2"

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

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "336cc738f03e069ef2cac55a104eb823455dca75"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.4"

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

[[deps.JpegTurbo]]
deps = ["CEnum", "FileIO", "ImageCore", "JpegTurbo_jll", "TOML"]
git-tree-sha1 = "a77b273f1ddec645d1b7c4fd5fb98c8f90ad10a5"
uuid = "b835a17e-a41a-41e7-81f0-2f016b05efe0"
version = "0.1.1"

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
git-tree-sha1 = "46a39b9c58749eefb5f2dc1178cb8fab5332b1ab"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.15"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

[[deps.LazyModules]]
git-tree-sha1 = "f4d24f461dacac28dcd1f63ebd88a8d9d0799389"
uuid = "8cdb02fc-e678-4876-92c5-9defec4f444e"
version = "0.3.0"

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
git-tree-sha1 = "09e4b894ce6a976c354a69041a04748180d43637"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.15"

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

[[deps.MappedArrays]]
git-tree-sha1 = "e8b359ef06ec72e8c030463fe02efe5527ee5142"
uuid = "dbb5928d-eab1-5f90-85c2-b9b0edb7c900"
version = "0.4.1"

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

[[deps.MosaicViews]]
deps = ["MappedArrays", "OffsetArrays", "PaddedViews", "StackViews"]
git-tree-sha1 = "b34e3bc3ca7c94914418637cb10cc4d1d80d877d"
uuid = "e94cdb99-869f-56ef-bcf0-1ae2bcbe0389"
version = "0.3.3"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.MutableArithmetics]]
deps = ["LinearAlgebra", "SparseArrays", "Test"]
git-tree-sha1 = "4050cd02756970414dab13b55d55ae1826b19008"
uuid = "d8a4904e-b15c-11e9-3269-09a3773c0cb0"
version = "1.0.2"

[[deps.NaNMath]]
git-tree-sha1 = "b086b7ea07f8e38cf122f5016af580881ac914fe"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.7"

[[deps.Netpbm]]
deps = ["FileIO", "ImageCore"]
git-tree-sha1 = "18efc06f6ec36a8b801b23f076e3c6ac7c3bf153"
uuid = "f09324ee-3d7c-5217-9330-fc30815ba969"
version = "1.0.2"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.OffsetArrays]]
deps = ["Adapt"]
git-tree-sha1 = "e6c5f47ba51b734a4e264d7183b6750aec459fa0"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.11.1"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.OpenEXR]]
deps = ["Colors", "FileIO", "OpenEXR_jll"]
git-tree-sha1 = "327f53360fdb54df7ecd01e96ef1983536d1e633"
uuid = "52e1d378-f018-4a11-a4be-720524705ac7"
version = "0.3.2"

[[deps.OpenEXR_jll]]
deps = ["Artifacts", "Imath_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "923319661e9a22712f24596ce81c54fc0366f304"
uuid = "18a262bb-aa17-5467-a713-aee519bc75cb"
version = "3.1.1+0"

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

[[deps.PNGFiles]]
deps = ["Base64", "CEnum", "ImageCore", "IndirectArrays", "OffsetArrays", "libpng_jll"]
git-tree-sha1 = "e925a64b8585aa9f4e3047b8d2cdc3f0e79fd4e4"
uuid = "f57f5aa1-a3ce-4bc8-8ab9-96f992907883"
version = "0.3.16"

[[deps.PaddedViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "03a7a85b76381a3d04c7a1656039197e70eda03d"
uuid = "5432bcbf-9aad-5242-b902-cca2824c8663"
version = "0.5.11"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "1285416549ccfcdf0c50d4997a94331e88d68413"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.3.1"

[[deps.Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PkgVersion]]
deps = ["Pkg"]
git-tree-sha1 = "a7a7e1a88853564e551e4eba8650f8c38df79b37"
uuid = "eebad327-c553-4316-9ea0-9fa01ccd7688"
version = "0.1.1"

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
git-tree-sha1 = "d457f881ea56bbfa18222642de51e0abf67b9027"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.29.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "670e559e5c8e191ded66fa9ea89c97f10376bb4c"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.38"

[[deps.Polynomials]]
deps = ["LinearAlgebra", "MutableArithmetics", "RecipesBase"]
git-tree-sha1 = "ee0cfbea3d8a44f677d59f5df4677889c4d71846"
uuid = "f27b6e38-b328-58d1-80ce-0feddd5e7a45"
version = "3.0.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "d7a7aef8f8f2d537104f170139553b14dfe39fe9"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.7.2"

[[deps.QOI]]
deps = ["ColorTypes", "FileIO", "FixedPointNumbers"]
git-tree-sha1 = "18e8f4d1426e965c7b532ddd260599e1510d26ce"
uuid = "4b34888f-f399-49d4-9bb3-47ed5cae4e65"
version = "1.0.0"

[[deps.Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "c6c0f690d0cc7caddb74cef7aa847b824a16b256"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+1"

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

[[deps.Sixel]]
deps = ["Dates", "FileIO", "ImageCore", "IndirectArrays", "OffsetArrays", "REPL", "libsixel_jll"]
git-tree-sha1 = "8fb59825be681d451c246a795117f317ecbcaa28"
uuid = "45858cf5-a6b0-47a3-bbea-62219f50df47"
version = "0.1.2"

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
git-tree-sha1 = "bc40f042cfcc56230f781d92db71f0e21496dffd"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.1.5"

[[deps.StackViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "46e589465204cd0c08b4bd97385e4fa79a0c770c"
uuid = "cae243ae-269e-4f55-b966-ac2d0dc13c15"
version = "0.1.1"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "cd56bf18ed715e8b09f06ef8c6b781e6cdc49911"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.4.4"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "c82aaa13b44ea00134f8c9c89819477bd3986ecd"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.3.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "8977b17906b0a1cc74ab2e3a05faa16cf08a8291"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.16"

[[deps.StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "e75d82493681dfd884a357952bbd7ab0608e1dc3"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.7"

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

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TiffImages]]
deps = ["ColorTypes", "DataStructures", "DocStringExtensions", "FileIO", "FixedPointNumbers", "IndirectArrays", "Inflate", "OffsetArrays", "PkgVersion", "ProgressMeter", "UUIDs"]
git-tree-sha1 = "f90022b44b7bf97952756a6b6737d1a0024a3233"
uuid = "731e570b-9d59-4bfa-96dc-6df516fadf69"
version = "0.5.5"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

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

[[deps.libsixel_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "78736dab31ae7a53540a6b752efc61f77b304c5b"
uuid = "075b6546-f08a-558a-be8f-8157d0f608a5"
version = "1.8.6+1"

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
# ╟─aaa4db38-4e95-4d52-a316-67386c7393e6
# ╟─d98ac7ca-96f2-11ec-0d44-b7943badb165
# ╟─b462d67d-e8fe-4970-8346-1561ab2e3fc7
# ╟─8fe17b2a-356f-4fdb-b04b-a440402f3a12
# ╠═018cc916-0712-4bfc-9715-bf512c3930ab
# ╠═6c5e00a0-2239-4ec8-a929-9bc695cae5b2
# ╠═3a337cba-31b1-433d-adc0-857438731585
# ╟─1ea381a9-5bf1-4a64-87fc-a89557b7c15b
# ╟─e8e9eeaa-7215-40c3-8da1-85619057fa24
# ╠═dd7bc6e1-8940-4cd6-aa51-6e5d5646c5f3
# ╟─e1340e20-7e6a-4a2e-a2f1-7675339000f2
# ╠═f72a909a-40ef-4c8f-8ee3-e3a773e4b68a
# ╟─fc5c971a-6eb7-4fa4-be01-0744418ca9cd
# ╠═26a9e690-48b0-4570-ad93-7f9313c9c56d
# ╠═8efe839c-a111-4810-a175-5365a55c4900
# ╟─f2ffd762-9726-4c90-8f47-26e039c3bef6
# ╠═04d626a1-c7f3-407e-be0e-2dfe8d0fac79
# ╠═a0a36f9f-b1fb-4df1-9d19-d1c160d8a6ec
# ╟─69d0c072-8239-498e-9026-c5f7910de05f
# ╟─5168ba4e-e236-45ef-8720-b11ec082cfba
# ╟─80ed06c1-21bf-4d5d-be96-0ece54fb69f5
# ╠═3e195fd3-9f69-4f27-8f93-c1f6346ce93a
# ╟─76561f01-fdf0-4e54-8d7b-3902833a0614
# ╠═37487ff0-e727-4f7f-83b6-5e12b3c93aaa
# ╟─a9cd6620-e89d-4219-b96b-6a8ee44f0e1f
# ╠═92d632ec-1f53-4fa5-bc1c-2aeddce63c37
# ╟─ee83e070-5cfa-4335-87cb-b4d9614182c9
# ╟─b4f09614-bfa4-48a2-8f5a-8c73d8312146
# ╟─3f313616-96e2-4ed2-95db-ba8f12dd98b3
# ╟─21cd702b-f125-4326-b15c-5ab1a68063aa
# ╟─e9da4158-8713-4ec1-9c86-f8fea01f475b
# ╟─dbcd21a9-756b-414b-8972-a8e6b32a054e
# ╟─0eb60e57-1fd1-4df8-866c-851a13bb765e
# ╟─1d0fd915-c0c2-41cd-a788-11ff2a054bce
# ╠═4d9e9381-4510-4a61-84f2-ffc927e1b64c
# ╟─62fe679c-b369-48af-8cc1-70f34c5b68ce
# ╟─42be164a-a8ea-4008-9e47-6adbf687fdeb
# ╟─4a0111a9-afa5-4df7-9abe-73440ea10489
# ╟─29a55b4d-68cc-438f-af96-1269b1794791
# ╠═c28fdbb7-7e95-45fe-a69f-e4149f8e4d6f
# ╟─99f6558e-8f7a-40e5-8c33-8fb377be0cca
# ╟─fa42cdfd-21a7-4807-895b-f6956a94e50a
# ╠═9cd7e35f-aa7f-465d-b4a2-343f65db63ac
# ╟─99bbe9f9-13fd-4f3b-8992-84025ccbe233
# ╠═d3e33164-811d-4abd-b04f-8d72ab4959d9
# ╟─075311f1-ee81-4817-9b50-f82043a8d14f
# ╟─dc62ff66-1b00-4f2c-911b-f45edd18edb7
# ╠═6c3e13d5-3dcf-4470-839b-e4057ef61fe7
# ╟─f13f364c-076b-41e9-95e4-bc45750bec4a
# ╟─27e978c0-063b-4b79-81c5-b05be2a2979c
# ╟─7a421503-9dd0-49c2-82b2-d709652ef4a9
# ╠═972b455a-0d20-4f1d-98df-28e9b219b148
# ╟─77f4138a-0897-4153-b752-d938062d62ed
# ╠═317f4244-4748-48a8-b6ea-f5a7d09f8f0c
# ╠═97a45280-804e-405a-afda-c220f21406b4
# ╟─f2189dbb-163e-40b9-bae4-65f7691a1bdd
# ╠═3f9a3bc0-1063-44c9-9710-b81e5b528bd9
# ╠═49e196e2-c62e-40e2-b6d7-675640258885
# ╠═812372c8-82d7-4fee-8b0c-a9e22ae398c2
# ╠═5133276a-8995-4ce9-a1f5-2c4caf116e20
# ╠═dc548c88-d969-4eaf-8ddd-938f953fda1a
# ╟─9b933f4b-92bf-48b8-91f6-980ea65ea18c
# ╠═c3cb0bbb-fcc0-49f8-b66e-74ca7ac96108
# ╠═54daea9f-2c1e-4934-a666-b14b960bd45f
# ╠═008c6d5a-263a-4388-88bb-6521a9cb8aab
# ╠═8fc2995f-762b-40be-a396-95b6bd3b914c
# ╟─1dfdcd5f-a35b-4297-ad7a-35c83206e181
# ╟─474eaefe-470d-46bf-bbb2-1f80773a85d2
# ╟─44730fab-9238-4135-ae6e-43a114db810e
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
