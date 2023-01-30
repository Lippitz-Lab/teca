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

# ╔═╡ 1c699dc7-0c8e-4ff3-8396-dcad50594251
using FFTW

# ╔═╡ e69f60d0-620b-4271-8612-42cccfcc6c70
using DSP

# ╔═╡ abdfdbc2-5bb5-4a0e-8a1f-5cb733e16f42
using PlutoUI, Plots

# ╔═╡ 71b5a334-f720-4b16-85cf-b258c601b1de
html"""<div>
<font size="7"><b>8 Filter: lineare, zeit-invariante Systeme</b></font> </div>

<div><font size="5"> Markus Lippitz </font> </div>
<div><font size="5"> 23. Mai 2022 </font> </div>
"""

# ╔═╡ ff7880da-96f2-11ec-2d80-adc081faa710
md"""

**Ziel** Sie können einen Filter *designen* und *anwenden*

-   Frequenzantwort, Impulsantwort

-   analoge und digitale Filter

**Weitere Aufgaben**

-   Filtern Sie ein Audio-Signal! (see PortAudio.jl und SampledSignals.jl)

**Literatur** Butz Kap. 5, Horowitz / Hill, Kap. 1.19

  
"""

# ╔═╡ a4875723-76f9-4c43-a308-83ad2e1fd978
md"""
# Überblick
Wir betrachten allgemeine Eigenschaften eines linearen, Zeit-invarianten
Systems. Das System reagiert also *linear* auf das Eingangssignal
('doppelt so viel hilft doppelt so viel') und ist Zeit-invariant. Die
Antwort heute unterscheidet sich also nicht von der gestern. Diese
Anforderungen erfüllen viele Systeme, beispielsweise elektronische
Filter, getrieben Oszillatoren, dielektrische Materialien oder angeregte
Moleküle.

"""

# ╔═╡ 7b940ad9-ee37-41cb-b60b-80197712faf5
md"""
# Zeitliche Antwort

Auf einen Eingang $f(t)$ reagiert das System mit einer Antwort $y(t)$,
für die gilt
```math
y(t) = \int_{- \infty} ^{+ \infty} f(t') \, h(t - t') \, dt' \quad .
```
Dabei ist $y$ also die Faltung von $f$ mit $h$. Bei kausale Systemen darf die
Antwort jetzt nicht von einem Eingang in der Zukunft abhängen. $t'$ muss
also immer kleiner als $t$ sein. Dies erreicht man, in dem man fordert
```math
h ( t - t' < 0)  = 0 \quad .
``` 
Dabei wird $h$  die *Impulsantwort* genannt.
Wenn nämlich der Eingang eine Delta-Funktion ist $f(t) = \delta(t)$ dann
wird $y(t) = h(t)$. So lässt sich auch $h$ messen, indem man einen
möglichst delta-förmigen Impuls als Eingang verwendet und die Reaktion
darauf aufzeichnet.

"""

# ╔═╡ 44d9df84-a4bd-48ef-b470-4b0862f7c719
md"""
# Frequenz-Antwort  

Da $y(t)$ die Faltung von $f(t)$ mit $h(t)$ ist, gilt für die
Fourier-transformierte Frequenzantwort
```math
Y(\omega) = F(\omega) \, H(\omega)
``` 
wobei kleine Buchstaben durch FT
in große Buchstaben übergehen. $H(\omega)$ nennt sich
*Transferfunktion*. Man kann diese Funktion messen, in dem man
beispielsweise die Antwort auf Eingänge mit verschiedenen Frequenzen
misst. Alternativ kann man ein im Frequenzraum flaches, breites (=
'weißes') Spektrum anlegen und das Frequenz-Spektrum des Ausgangs
messen.

"""

# ╔═╡ 8787ecd7-ed54-469c-a748-19605c2dd665
md"""
## Kramers-Kronig-Beziehung 

Auch wenn $h(t)$ reelwertig ist, so wird $H(\omega)$ doch komplexwertig
sein, da $h(t)$ nicht gerade (Kosinus-förmig) ist. Aus der Kausalität,
also $h ( t - t' < 0)  = 0$ folgt allerdings ein Zusammenhang zwischen
Real- und Imaginär-Teil von $H(\omega)$, die Kramers-Kronig-Beziehung.
Da dielektrische Materialien linear und Zeit-invariant sind, gibt es so
einen Zusammenhang zwischen Real- und Imaginär-Teil der dielektrischen
Funktion bzw. des Brechungsindexes
```math
\epsilon'(\omega) = 1 + \frac{2}{\pi} \, \mathcal{P}\int_0^{\infty} \frac{\Omega \, \epsilon''(\Omega) }{\Omega^2 - \omega^2}
```
und analog auch in die andere Richtung. $\mathcal{P}$ bezeichnet dabei
das Cauchy'sche Hauptwert-Integral, bei dem der Pol bei
$\Omega = \omega$ ausgenommen wird.

Analog kann man aus bekannten Amplitudenverlauf eines getriebenen
Oszillator seinen Phasenverlauf bestimmen und umgekehrt.

"""

# ╔═╡ 64410607-6541-4aae-95b1-e4d3fde884ce
md"""
## Kaskadierte Systeme 

Wenn mehrere lineare, Zeit-invariante Systeme hintereinander geschaltet
sind, also der Ausgang des einen als Eingang des anderen dient, dann ist
die Transferfunktion des Gesamtsystems das Produkt aller
Transferfunktionen (und daher von der Reihenfolge der Systeme
unabhängig). Die Gesamt-Impulsantwort ist also die Faltung aller
Einzel-Impulsantworten.

"""

# ╔═╡ 063afec8-4ec1-4ec7-87f0-890a86662875
md"""
## Entfaltung 

Limitierte Transferfunktionen bzw. nicht delta-förmige Impulsantworten
sind unpraktisch, aber allgegenwärtig. Gerne würde man sie nachträglich
rechnerisch aus der Messung beseitigen, um diese zu korrigieren. Das ist
aber nur sehr begrenzt möglich. Man könnte die im Zeitraum gemessenen
Größen Fourier-Transformieren und dann rechnen
```math
F_{exp}(\omega) = \frac{Y_{exp}(\omega)}{H(\omega)} \quad .
``` 
Das
Problem ist, dass bei limitiertem $H(\omega)$ dieses quasi Null ist für
manche Frequenzen. An diesen Frequenzen ist dann auch das gemessene
$Y(\omega)$ quasi Null und der wahre von Null verschiedene Wert von
$F(\omega)$ lässt sich nicht rekonstruieren. Wenn die Information einmal
weg ist, kann man sie nicht wieder beschaffen. In Bereichen, in denen
$H$ zwar klein, aber nicht Null ist, kann dieses Verfahren helfen,
solange der gemessene Wert von $Y$ gut genug, also rauscharm genug
bekannt ist.

Was man an dieser Stelle typischerweise macht, ist nicht die Daten um
die Messprozedur zu entfalten, sondern das Modell mit der Apparatur zu
falten, und dann gemessene $Y$ mit modellierten $Y$ zu vergleichen.

"""

# ╔═╡ a1ea0f01-8b00-4a9d-96ed-9b6b753bbd48
md"""
# Reihenentwicklung der Transferfunktion


An Stelle von 
```math
y(t) = \int_{- \infty} ^{+ \infty} f(t') \, h(t - t') \, dt' 
= \int_{- \infty} ^{+ \infty} f(t- t') \, h(t') \, dt' 
```
hätten wir auch schreiben können (Butz, eq. 5.1)
```math
y(t)= \sum_{j=-k}^k a_j \, f^{[j]}(t) \quad \text{mit} \quad
f^{[j]}(t) = \frac{d^j f(t)}{dt^j}
```
wobei negatives $j$ entsprechende Integration bedeutet. Ausgeschrieben ist das
```math
y(t)= a_0 f(t) + a_1 \frac{d f(t)}{dt}  + a_2 \frac{d^2 f(t)}{dt^2} + \cdots
+ a_{-1} \int f(\tau) d\tau +  a_{-2} \iint f(\tau) d\tau d\tau' + \cdots 
```
Durch Fourier-Transformation wird daraus
```math
Y(\omega) = \sum_{j=-k}^k a_j  (i \omega)^j F(\omega)
```
oder 
```math
H(\omega) = \sum_{j=-k}^k a_j  (i \omega)^j 
```
Wir stellen also $H$ als Polynom in $\omega$ dar und die $a_j$ sind die Koeffizienten. Diese Koeffizienten bestimmen, aus welchen Ableitungen und Integralen von $f$ der Ausgang $y$ gebildet wird.
"""

# ╔═╡ e5fb42fa-f4c6-49f1-8003-32e636a55137
md"""
# Diskrete Datenreihe

Jetzt gehen wir über zu diskreten Samples $f_k$ im zeitlichen Abstand $\Delta t$. Wir können sowohl die Integral-Definition von $y$ diskretisieren, also ausgehen von 
```math
y(t) = \int_{- \infty} ^{+ \infty} f(t') \, h(t - t') \, dt' 
= \int_{- \infty} ^{+ \infty} f(t- t') \, h(t') \, dt' 
```
oder wir schreiben die Integrale und Differentiationen von 
```math
y(t)= \sum_{j=-k}^k a_j \, f^{[j]}(t) 
```
als Summen und Differenzen von aufeinanderfolgenden Elementen $f_k$. Egal wie, wir bekommen 
```math
y_k = \sum_{l=-L}^{L} a_l \, f_{k+l} = \sum_{l=-L}^{L} a_l \, V^l f_{k} 
```
mit dem Verschiebe-Operator $V^l$
```math
V^n \, f_k = f_{k+n}
```

Die Größe $L$ muss rein praktisch endlich sein, weil wir in diesem Universum nicht unendlich viele Werte $f_k$ speichern können. Wenn $h_n$ mit positiven $n$ von Null verschieden sind, dann ist die Impulsantwort $h$ *akausal*. Wir müssen in diesem Fall Werte von $f$ in der Zukunft kennen, um $y$ jetzt auszurechnen. Das geht technisch bedingt, in dem man beispielsweise $L$ Werte speichert und $y$ entsprechend verspätet ausgibt. Die Fourier-Transformation ist beispielsweise akausal.
"""

# ╔═╡ 392e83bb-73c2-4ecb-aaba-802ee315be10
md"""
Natürlich können wir das auch Fourier-Transformieren
```math
Y_j = H_j \, F_j
```
mit
```math
H_j = \sum_{l=-L}^L a_l \, e^{i \omega_j \, l \Delta t} \quad \text{und} \quad
\omega_j = 2 \pi j / (N \Delta t)
```
Die Anzahl $N$ der Elemente im Datensatz ist typischerweise viel größer als die Länge $L$ der Filter-Koeffizienten. Daher wird sehr oft die diskrete Natur der $\omega_j$ ignoriert und ein kontinuierliches $\omega$ geschrieben, also
```math
H(\omega) = \sum_{l=-L}^L a_l \, e^{i \omega \, l \Delta t} 
```
"""

# ╔═╡ 95c85f72-8097-420f-817a-9503f361ee38
md"""
# Beispiel: Tiefpass-Filter

Wir folgen weiterhin Butz und betrachten einen Tiefpass-Filter, der einfach durch Mittelwertbildung entsteht. Sei
```math
y_k = \frac{1}{2} \left( f_k + f_{k+1} \right)
```
also $a_0 = a_1 = 1/2$. Damit bekommen wir
```math
H(\omega) = \frac{1}{2} \left( 1 + e^{i \omega \Delta t} \right) \quad \text{bzw.} \quad |H(\omega)| = \cos \frac{\omega \Delta t}{2} = \cos \frac{\pi}{2} \frac{\omega}{\Omega_{Nyq.}}
```
"""

# ╔═╡ 9bd52ec5-8602-4fca-aef5-3aeef8b660eb
let
	f = randn(500)
	y = zeros(length(f))
	for k = 1:(length(f)-1)
		y[k] = 0.5 * (f[k] + f[k+1])
	end

	F = fftshift(fft(f))
	Y = fftshift(fft(y))
	H = Y ./ F
	omega = fftshift(fftfreq(length(f)))
	
	plot(f, label="orig", layout=2)
	plot!(y, label="filtered", xlabel="Zeit", subplot=1, xlims=(0, 50))

	plot!(omega, abs.(H), subplot=2, xlims=(0, 0.5), label="|H|", xlabel="Freq")
end

# ╔═╡ 8ab2d313-c1ee-4686-9ef3-9efe1516eff3
md"""
Der Filter filtert zwar wie erwartet, hat aber die unangenehme Eigenschaft, aus reelwertigen Eigaben komplexwertige Ausgaben zu machen. Das $f_{k+1}$ führt zu einer Phasenverschiebung. Wir können das symmetrischer machen, indem wir auch das Element $f_{k-1}$ mitnehmen, also 
```math
y_k = \frac{1}{3} \left(f_{k-1} + f_k + f_{k+1} \right)
```
und
```math
H(\omega) = \frac{1}{3} \left( e^{-i \omega \Delta t}  + 1 + e^{i \omega \Delta t} \right) = \frac{1}{3}  \left( 1 + 2 \cos \omega \Delta t \right)
```
Jetzt ist $H$ zwar rein reelwertig, aber leider negativ bei hohen Frequenzen. Schöner ist das mit 
```math
y_k = \frac{1}{4} \left(f_{k-1} + 2 f_k + f_{k+1} \right)
```
und
```math
H(\omega) = \frac{1}{4} \left( e^{-i \omega \Delta t}  + 2 + e^{i \omega \Delta t} \right) = \cos^2 \frac{ \omega \Delta t }{2} 
```
Dies ist die 'offizielle' Form des Tiefpassfilters.
"""

# ╔═╡ 16b66eef-fee4-4401-aba4-6ddd60bfcd2f
md"""
Der -3dB-Punkt, also $H(\omega) = 1/2$ liegt bei $\omega = \Omega_{Nyq} /2$
"""

# ╔═╡ f7cc8d1d-e168-4b69-a0d8-746cc07dcb19
md"""
## Hochpass-Filter

Analog kann man einen Hochpass-Filter erzeugen über 

```math
y_k = \frac{1}{4} \left(-f_{k-1} + 2 f_k  -f_{k+1} \right)
```
und
```math
H(\omega) = \frac{1}{4} \left( -e^{-i \omega \Delta t}  + 2  -e^{i \omega \Delta t} \right) = 1 - \cos^2 \frac{ \omega \Delta t }{2} 
```
Eine konstanten Funktion $f_k = c$ (für alle $k$) liefert eine Null am Ausgang, also $y_k = 0$. Nur hohe Frequenzen werden durchgelassen.
"""

# ╔═╡ e52fa5d6-f8a7-4a15-96a5-c1c1e132fcd6
let
	f = 1 .+ randn(500)
	y = zeros(length(f))
	for k = 2:(length(f)-1)
		y[k] = 0.25 * (- f[k-1] + 2 * f[k] - f[k+1])
	end

	F = fftshift(fft(f))
	Y = fftshift(fft(y))
	H = Y ./ F
	omega = fftshift(fftfreq(length(f)))
	
	plot(f, label="orig", layout=2)
	plot!(y, label="filtered", xlabel="Zeit", subplot=1, xlims=(0, 50))

	plot!(omega, real.(H) , subplot=2, xlims=(0, 0.5), label="H", xlabel="Freq")
end

# ╔═╡ 490aa263-a783-411b-997a-237fc5a14224
md"""
## Bandpass und Bandsperre

Bandpass-Filter lassen nur Frequenzen in einem Intervall durch. Bandsperren sind das Gegenteil, sperren also nur ein Frequenzband. Einfache Formen sind für den **Bandpass**
```math
y_k = \frac{1}{16} \left( - f_{k-2} + 2 f_k - f_{k+2} \right)
```
und die **Bandsperre**
```math
y_k = \frac{1}{16} \left( f_{k-2} + 14 f_k + f_{k+2} \right)
```
"""

# ╔═╡ aa7da284-0410-4e30-96c3-ff28fa794a8c
md"""
# Rekursive Filter

Die bis hier betrachteten Filter waren *nicht-rekursiv*, weil die berechneten $y_k$ nicht auch auf der Eingangsseite des Filters verwendet wurden. Diese Klasse der Filter heist auch *finite impulse response* oder FIR, weil eben die Impulsantwort $h$ immer finit (kleiner unendlich) bleibt. Die Filter sind angenehm, aber es ist manchmal aufwendig (brauch viele Elemente $a_l$), um eine gewünschte Transferfunktion $H$ zu erzeugen. In diesem Fällen sind *rekursive* Filter, also solche mit *infinite impulse response* (IIR) einfacher. Die Idee ist, $y_k$ auch auf der rechten Seite der Gleichung zu verwenden, also eine Art Rückkopplung einzubauen. Dies führt aber unter Umständen  zu einer Resonanz, einem instabilen Filter, oder eben Rückkopplungs-Pfeifen. 
"""

# ╔═╡ 47fd35ad-afda-4a52-a71f-9ce64527b749
md"""
Mathematisch ist das
```math
y_k = \sum_{l=-L}^{L} a_l \, V^l f_{k}  -  \sum_{m=-M}^{M} b_m \, V^m y_{k} 
```
wobei $m=0$ in der zweiten Summe ausgeschlossen ist, weil das ja schon links steht. Umsortiert ist das 
```math
 \sum_{m=-M}^{M} b_m \, V^m y_{k}  = \sum_{l=-L}^{L} a_l \, V^l f_{k}  
```
was jetzt auch $m=0$ beinhaltet.
"""

# ╔═╡ 342a137e-715e-4f6b-8b3d-bd293ff30549
md"""
Durch Fourier-Transformation erhalten wir
```math
B_j \, Y_j = A_j \, F_j
```
mit den $A_j$ definiert wie oben und den $B_j$ analog. Die Transferfunktion ist dann (wieder mit kontinuierlichem $\omega$)
```math
H(\omega) = \frac{A(\omega)}{B(\omega)}
```
Die Rückkopplung erzeugt Nullstellen (oder Pole) in $B(\omega)$ und damit eine Resonanz in $H$. Den Resonanz-freien Fall von oben erhalten wir durch $b_m = 0$ für $m \neq 0$, also $B(\omega) = \text{const.}$.
"""

# ╔═╡ a138c5d9-9aa9-4c2d-8e4b-ed26d2c2c19b
md"""
## Bsp. nochmal Tiefpass

Wir (bzw. Butz) verbessern den Tiefpass von oben durch etwas Rückkopplung
```math
y_k = \frac{1}{2} y_{k-1} +  \frac{1}{4} \left(f_{k-1} + 2 f_k + f_{k+1} \right)
```
bzw.
```math
\left(1 - \frac{1}{2} V^{-1} \right) y_k =  \frac{1}{4} \left(V^{-1} + 2  + V^{+1}  \right) f_k
```
Das ergibt
```math
H(\omega) = \frac{\cos^2 \omega \Delta t /2 }{1 - \frac{1}{2}e^{-i \omega \Delta t} } 
```
"""

# ╔═╡ f276c5ac-a9df-4046-9f83-dfa36216883a
md"""
Die grafische Darstellung machen wir jetzt nicht von Hand, sondern nehmen eine Bibliothek.
"""

# ╔═╡ 9eae8cd7-1cef-4b78-a8d4-d99d6011c535
md"""
# Filter in Julia via DSP.jl
"""

# ╔═╡ a132dcea-2c7f-4073-8091-06f6b9e8a40f
md"""
Das Paket [DSP.jl](https://docs.juliadsp.org/stable/filters/) implementiert alles was wir brauchen, um Filter darzustellen und anzuwenden. Werte in der Zukunft kennen wir natürlich nicht. Daher wird alles so verschoben, dass nie Indizes in die Zukunft verweisen und man gibt die Koeffizienten in der Reihenfolge $a_0$, $a_{-1}$, $a_{-2}$, etc. an ($b$ analog). Unser nicht-rekursiver Tiefpass von oben mit $a_0 = 2$ und $a_{\pm 1} = 1$ wird hier also $a = [1, 2,1 ]$ und $b = [1]$, also nur $y_k$ kommt vor. Durch das Verschieben ist dann in DSP.jl allerdings $H$ in diesem Fall nicht mehr reelwertig, sondern erhält einen Phasenfaktor. Der wird hier durch $e^{i \omega \Delta t}$ korrigiert.
"""

# ╔═╡ 75f54196-b367-4e16-912e-8f51fa8fe9d6
let
 	f = DSP.Filters.PolynomialRatio([1, 2, 1]./4, [1]) 
	H, w = freqresp(f)
	plot(w ./ pi, real.(H .* exp.(1im .* w)))

	x =(0:0.1:1)
	scatter!(x,  (cos.(π/2 *x)).^2, legend=false, xlabel="norm. freq.", ylabel="|H|")
end

# ╔═╡ f713bfb8-1e32-4558-aed2-c4669d230655
md"""
Nun ist es einfach, das rekursive Filter zu plotten. Wir sehen, dass der -3dB-Punkt bei niedrigeren Frequenzen liegt und der Verlauf steiler ist.
"""

# ╔═╡ ce4b058a-eb4a-42b2-a6a5-7eae4df8f6aa
let
 	f = DSP.Filters.PolynomialRatio([1, 2, 1]./4, [1, -1/2]) 
	H, w = freqresp(f)
	plot(w ./ pi, abs.(H), label="rekursiv")

	f = DSP.Filters.PolynomialRatio([1, 2, 1]./4, [1]) 
	H, w = freqresp(f)
	plot!(w ./ pi, abs.(H), label="nicht rekursiv")
end

# ╔═╡ f432282b-c46f-48c1-9f7b-d5cb35c31dbc
md"""
# RC-Tiefpass-Filter 

Nun verbinden wir das mit physikalischen, also elektrischen Filtern. Wir betrachten auf verschiedene Weisen einen unbelasteten
RC-Tiefpass-Filter. Es wird also nur eine Spannung $U_{out}$ gemessen
und kein Strom $I_{out}$ fließt.

"""

# ╔═╡ 3eac92be-4058-4534-ae17-97833937e58a
md"""
## Komplexe Widerstände  

Der RC-Filter bildet einen Spannungsteiler aus zwei komplexen
Widerständen $Z_1= R$ und $Z_2 = 1 /( i \omega C)$. Damit ergibt sie die
Transferfunktion $H$ zu
```math
H = \frac{U_{out}}{U_{in}} = \frac{Z_2}{Z_1 + Z_2} = \frac{\frac{1}{i \omega C}}{R + \frac{1}{i \omega C}}
= \frac{\frac{1}{i \omega R  C}}{1 + \frac{1}{i \omega R C}}
```
"""

# ╔═╡ 5b287990-d893-416a-92d9-b44372f1651f
md"""
## Zeitliche Integration  

Alternativ kann man die Spannung $U_{out}$ auch aus der Ladung $Q$ des
Kondensators berechnen
```math
U_{out}(t) = \frac{Q(t)}{C} = \frac{1}{C} \int_{\tau < t} I(\tau) d\tau  =  \frac{1}{RC} \int_{\tau < t} U_{in}(\tau) - U_{out}(\tau) d\tau
```
Für kleine $\Delta t$ mit quasi konstanten $U$ ergibt sich so
```math
U_{out}(t + \Delta t) =  U_{out}(t) + \frac{\Delta t}{R C } \left(U_{in}(t) - U_{out}(t) \right)
```
Nun seinen $x_n$ und $y_n$ die Zeitreihe der Spannungen, also
```math
x_n = U_{in}(n \Delta t) \quad \text{und} \quad y_n = U_{out}(n \Delta t)
```
also
```math
y_{n+1} =  y_n + \frac{\Delta t}{R C } \left( x_n - y_n \right)
```
oder umgeformt , inkl. Verschieben des Indexes um 1
```math
y_n +  y_{n-1}  \left(1 + \frac{\Delta t}{R C } \right) = 
 \frac{\Delta t}{R C }  x_{n-1}
``` 
Mit dem Verschiebe-Operator $V^l$ lässt sich das schreiben als
```math
\left( 1 + V^{-1} \left(1 + \frac{\Delta t}{R C } \right) \right)  y_n= 
 \frac{\Delta t}{R C }  V^{-1} x_n
``` 
Die einzigen von Null
verschiedenen Filter-Koeffizienten sind also 
```math 
\begin{aligned}
a_{-1}  &= & \frac{\Delta t}{R C }    \\
b_0 & =& 1 \\
b_{-1} & = & 1 - \frac{\Delta t}{R C}   
\end{aligned}
```
"""

# ╔═╡ feda6789-451a-4c43-9c45-213a34bff474
md"""
Die $A(\omega)$ und $B(\omega)$ sind diese Koffeizienten multipliziert mit $\exp(i k \omega \Delta t)$ also
```math
\begin{aligned}
A(\omega) & = & \sum a_n \exp(n \,  i \omega \Delta t) = \frac{\Delta t}{R C }   \exp(- i \omega \Delta t) \\
B(\omega) & = & \sum b_n \exp(n \,  i \omega \Delta t) = 1 + \left(1 - \frac{\Delta t}{R C } \right)   \exp(- i \omega \Delta t) 
\end{aligned}
```
"""

# ╔═╡ e8084197-163f-4221-90d8-a2ae614d2e73
md"""
Mit der Näherung
$\exp(- i \omega \Delta t)  = 1 / (1 +  i \omega \Delta t)$ ergibt sich
für die Transferfunktion $H(\omega)$
```math
H(\omega) = \frac{A(\omega)}{B(\omega)} = \frac{ \frac{\Delta t}{R C }  \cdot \frac{1}{1 +  i \omega \Delta t}}
{1 + \left(1 - \frac{\Delta t}{R C } \right)  \cdot \frac{1}{1 +  i \omega \Delta t}} 
\approx  \frac{\frac{1}{i \omega R  C}}{1 + \frac{1}{i \omega R C}}
```
Die letzte Näherung erfordert, dass $\Delta t / RC \ll 1$, also sehr
kleines $\Delta t$. Das Ergebnis stimmt also mit dem über die komplexen
Widerstände überein.
"""

# ╔═╡ a8cf52a2-1f52-4a20-9917-841253af3dbb
md"""
# Filter-Design 

Wie kommt man auf die Koeffizienten $a_i$ und $b_i$ bzw. wie verschaltet man Spulen, Kondensatoren und Widerstände, so dass sich eine gewünschte Filterfunktion einstellt. Dazu gibt es 'Kochrezepte', die Sie hier ausprobieren können. Relevante Größen sind die Steilheit der Flanke (roll-off) und die Welligkeit des transmittierten bzw. geblockten Bereichs (pass-band / stop-band ripple). Auch die Phasenfunktion ist unterschiedliche. Eine konstante Ableitung der Phase mit der Frequenz ergibt eine konstante Gruppengeschwindigkeit, also werden Pulse nicht verzerrt.
"""

# ╔═╡ 07478bab-97eb-4a63-b818-1dc0bc1f3c08
md"""
Filter-Typ $(@bind filtertyp Select(["Butterworth", "Chebyshev", "Elliptic"]; 	default="Butterworth"))
"""

# ╔═╡ 325dc892-aff5-4a5a-90bd-31e354880de1
begin
	responsetype = Lowpass(0.1)
	if (filtertyp == "Butterworth")
		designmethod = Butterworth(4)
	elseif (filtertyp == "Chebyshev")
		designmethod = Chebyshev2(4, 30)
	else
		designmethod = Elliptic(4,  2, 30)
	end

	myfilter = digitalfilter(responsetype, designmethod)
	
	H, w = freqresp(myfilter)
	plot(w ./ pi,abs.(H), layout=(2,1), subplot=1, leg=false, yaxis=(:log, (1e-3, 1.1)), ylabel = "|H|")
	plot!([0.1, 0.1], [1e-3 ,1], subplot=1)

	phi, w = phaseresp(myfilter)
	plot!(w./ pi, phi ./ pi, subplot=2, leg=false, xlabel="norm. Freq.", ylabel="Phasew / pi")
	plot!([0, 0.1], [0, -1], subplot=2)

end

# ╔═╡ 5576f4c2-7ad6-403a-b7f6-07b78114ef95
md"""
Dies sind die zugehörigen Koeffizienten $a$ und $b$
"""

# ╔═╡ 3b88fbb6-85f1-4176-8d46-4e5530f2e3e1
begin
	tf = convert(PolynomialRatio, myfilter)
	numerator_coefs = coefb(tf)
	denominator_coefs = coefa(tf)
	(numerator_coefs, denominator_coefs)
end

# ╔═╡ d77adb66-86fe-40ce-bbb8-0b8f50ffdf5e
md"""
# Filter anwenden

Die Funktion 'filt' wendet den Filter an
"""

# ╔═╡ 2006ae0f-02ad-42e0-a1ea-9f92d1488994
let
	f = randn(200)
	y = filt(myfilter, f)
	plot(f, label="orig")
	plot!(y, label="filtered", xlabel="Zeit")
end

# ╔═╡ 962c8477-4ebf-46aa-9953-c3b9fc98cca7
md"""
Hier sieht man auch, wie der Phasenverlauf den Puls verzerren kann (dazu weiter oben den Filter ändern).
"""

# ╔═╡ ee3f7ef3-72e4-4b21-9624-3151dd285ae0
let
	f = exp.(-1 .* (-50:200) .^ 2 ./ (10 .^ 2) )
	y = filt(myfilter, f)
	plot(f, label="orig")
	plot!(y, label="filtered", xlabel="Zeit", title="Gauss gefiltert mit $(filtertyp)")
end

# ╔═╡ d7132d3c-0b4f-4eee-93e3-53cff88d8864
aside(x) = PlutoUI.ExperimentalLayout.aside(x);

# ╔═╡ c25d3e07-a25a-4bab-9943-4353d8d0934d
let
	x =(0:0.01:1)
	aside(embed_display(plot(x, cos.(π/2 *x), legend=false, xlabel="norm. freq.", ylabel="|H|")))
end

# ╔═╡ 52494593-8b71-44de-9365-7890972f0e35
let
	x =(0:0.01:1)
	aside(embed_display(plot(x, (cos.(π/2 *x)).^2, legend=false, xlabel="norm. freq.", ylabel="|H|")))
end

# ╔═╡ 048f044d-6ef0-44ba-bb8d-a6a5f4eb2674
aside([Resource("https://raw.githubusercontent.com/MarkusLippitz/teca/main/res/08-Filter/RC.png", (:width => 500)) md"*Schaltbild eines RC Filters*"])

# ╔═╡ 19032436-b4e1-4c7b-9d05-2c4e94725973
TableOfContents(title="Inhalt")

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
DSP = "717857b8-e6f2-59f4-9121-6e50c889abd2"
FFTW = "7a1cc6ca-52ef-59f5-83cd-3a7055c09341"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
DSP = "~0.7.8"
FFTW = "~1.5.0"
Plots = "~1.38.3"
PlutoUI = "~0.7.49"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.5"
manifest_format = "2.0"
project_hash = "634643561ade2543ca54bcb9bd294c838972ff1b"

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

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

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

[[deps.Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "00a2cccc7f098ff3b66806862d275ca3db9e6e5a"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.5.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.1+0"

[[deps.Contour]]
git-tree-sha1 = "d05d9e7b7aedff4e5b51a029dced05cfb6125781"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.6.2"

[[deps.DSP]]
deps = ["Compat", "FFTW", "IterTools", "LinearAlgebra", "Polynomials", "Random", "Reexport", "SpecialFunctions", "Statistics"]
git-tree-sha1 = "da8b06f89fce9996443010ef92572b193f8dca1f"
uuid = "717857b8-e6f2-59f4-9121-6e50c889abd2"
version = "0.7.8"

[[deps.DataAPI]]
git-tree-sha1 = "e8119c1a33d267e16108be441a287a6981ba1630"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.14.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "d1fff3a548102f48987a52a2e0d114fa97d730f0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.13"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

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

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "49510dfcb407e572524ba94aeae2fced1f3feb0f"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.8"

[[deps.IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[deps.IterTools]]
git-tree-sha1 = "fa6287a4469f5e048d763df38279ee729fbd44e5"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.4.0"

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

[[deps.NaNMath]]
deps = ["OpenLibm_jll"]
git-tree-sha1 = "a7c3d1da1189a1c2fe843a3bfa04d18d20eb3211"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

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

[[deps.Polynomials]]
deps = ["LinearAlgebra", "RecipesBase"]
git-tree-sha1 = "c687954bd0b4b0508249fd36999f1b82456c2a10"
uuid = "f27b6e38-b328-58d1-80ce-0feddd5e7a45"
version = "3.2.3"

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

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

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

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "f94f779c94e58bf9ea243e77a37e16d9de9126bd"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.1"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

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

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.0"

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
# ╟─71b5a334-f720-4b16-85cf-b258c601b1de
# ╟─ff7880da-96f2-11ec-2d80-adc081faa710
# ╟─a4875723-76f9-4c43-a308-83ad2e1fd978
# ╟─7b940ad9-ee37-41cb-b60b-80197712faf5
# ╟─44d9df84-a4bd-48ef-b470-4b0862f7c719
# ╟─8787ecd7-ed54-469c-a748-19605c2dd665
# ╟─64410607-6541-4aae-95b1-e4d3fde884ce
# ╟─063afec8-4ec1-4ec7-87f0-890a86662875
# ╟─a1ea0f01-8b00-4a9d-96ed-9b6b753bbd48
# ╟─e5fb42fa-f4c6-49f1-8003-32e636a55137
# ╟─392e83bb-73c2-4ecb-aaba-802ee315be10
# ╟─95c85f72-8097-420f-817a-9503f361ee38
# ╠═c25d3e07-a25a-4bab-9943-4353d8d0934d
# ╠═1c699dc7-0c8e-4ff3-8396-dcad50594251
# ╠═9bd52ec5-8602-4fca-aef5-3aeef8b660eb
# ╟─8ab2d313-c1ee-4686-9ef3-9efe1516eff3
# ╠═52494593-8b71-44de-9365-7890972f0e35
# ╟─16b66eef-fee4-4401-aba4-6ddd60bfcd2f
# ╟─f7cc8d1d-e168-4b69-a0d8-746cc07dcb19
# ╠═e52fa5d6-f8a7-4a15-96a5-c1c1e132fcd6
# ╟─490aa263-a783-411b-997a-237fc5a14224
# ╟─aa7da284-0410-4e30-96c3-ff28fa794a8c
# ╟─47fd35ad-afda-4a52-a71f-9ce64527b749
# ╟─342a137e-715e-4f6b-8b3d-bd293ff30549
# ╟─a138c5d9-9aa9-4c2d-8e4b-ed26d2c2c19b
# ╟─f276c5ac-a9df-4046-9f83-dfa36216883a
# ╟─9eae8cd7-1cef-4b78-a8d4-d99d6011c535
# ╟─a132dcea-2c7f-4073-8091-06f6b9e8a40f
# ╠═e69f60d0-620b-4271-8612-42cccfcc6c70
# ╠═75f54196-b367-4e16-912e-8f51fa8fe9d6
# ╟─f713bfb8-1e32-4558-aed2-c4669d230655
# ╠═ce4b058a-eb4a-42b2-a6a5-7eae4df8f6aa
# ╟─f432282b-c46f-48c1-9f7b-d5cb35c31dbc
# ╟─048f044d-6ef0-44ba-bb8d-a6a5f4eb2674
# ╟─3eac92be-4058-4534-ae17-97833937e58a
# ╟─5b287990-d893-416a-92d9-b44372f1651f
# ╟─feda6789-451a-4c43-9c45-213a34bff474
# ╟─e8084197-163f-4221-90d8-a2ae614d2e73
# ╟─a8cf52a2-1f52-4a20-9917-841253af3dbb
# ╟─07478bab-97eb-4a63-b818-1dc0bc1f3c08
# ╠═325dc892-aff5-4a5a-90bd-31e354880de1
# ╟─5576f4c2-7ad6-403a-b7f6-07b78114ef95
# ╠═3b88fbb6-85f1-4176-8d46-4e5530f2e3e1
# ╟─d77adb66-86fe-40ce-bbb8-0b8f50ffdf5e
# ╠═2006ae0f-02ad-42e0-a1ea-9f92d1488994
# ╟─962c8477-4ebf-46aa-9953-c3b9fc98cca7
# ╠═ee3f7ef3-72e4-4b21-9624-3151dd285ae0
# ╠═abdfdbc2-5bb5-4a0e-8a1f-5cb733e16f42
# ╠═d7132d3c-0b4f-4eee-93e3-53cff88d8864
# ╠═19032436-b4e1-4c7b-9d05-2c4e94725973
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
