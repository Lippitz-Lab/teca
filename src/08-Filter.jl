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

# ╔═╡ c25d3e07-a25a-4bab-9943-4353d8d0934d
let
	x =(0:0.01:1)
	aside(embed_display(plot(x, cos.(π/2 *x), legend=false, xlabel="norm. freq.", ylabel="|H|")))
end

# ╔═╡ 1c699dc7-0c8e-4ff3-8396-dcad50594251
using FFTW

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

# ╔═╡ 52494593-8b71-44de-9365-7890972f0e35
let
	x =(0:0.01:1)
	aside(embed_display(plot(x, (cos.(π/2 *x)).^2, legend=false, xlabel="norm. freq.", ylabel="|H|")))
end

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

# ╔═╡ e69f60d0-620b-4271-8612-42cccfcc6c70
using DSP

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

# ╔═╡ 048f044d-6ef0-44ba-bb8d-a6a5f4eb2674
aside([Resource("https://raw.githubusercontent.com/MarkusLippitz/teca/main/res/08-Filter/RC.png", (:width => 500)) md"*Schaltbild eines RC Filters*"])

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

# ╔═╡ abdfdbc2-5bb5-4a0e-8a1f-5cb733e16f42
using PlutoUI, Plots

# ╔═╡ d7132d3c-0b4f-4eee-93e3-53cff88d8864
aside(x) = PlutoUI.ExperimentalLayout.aside(x);

# ╔═╡ 19032436-b4e1-4c7b-9d05-2c4e94725973
TableOfContents(title="Inhalt")

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
