### A Pluto.jl notebook ###
# v0.19.22

using Markdown
using InteractiveUtils

# ╔═╡ 8a6359c4-5064-45fb-89c3-8d9bd799e04e
using XLSX, DataFrames, Downloads

# ╔═╡ a880e78b-6a35-479b-ae53-6269347f1f70
using Unitful

# ╔═╡ b5bcc95c-05c5-4e9c-84ab-a04dc0cef191
using PlutoUI

# ╔═╡ 87c27d3d-a773-4fa6-b193-5e274c1cd733
using Plots

# ╔═╡ 0e6b72ce-38e4-4212-921e-1221d0740b7a
html"""<div>
<font size="7"><b>10 Detektoren</b></font> </div>

<div><font size="5"> Markus Lippitz</font> </div>
<div><font size="5"> 9. Juni 2022 </font> </div>
"""

# ╔═╡ 4580e946-96f3-11ec-38d9-bbfb594fb979
md"""
**Ziele** Sie können einen passenden Photodetektor *auswählen*.

-   Verstärkung und Quanteneffizienz

-   noise-equivalent bandwidth

-   noise-equivalent power



**Literatur** Horowitz/Hill Kap. 7.18--21, Handbook of Optics
I Kap. 18, Saleh/Teich Kap. 18 (2. Aufl.) bzw. 17 (1. Aufl.)

"""

# ╔═╡ 0254558d-a260-4763-a761-629a78e0d8dd
md"""
# Überblick

Wir behandeln hier Licht im sichtbaren Spektrum, also einer Wellenlänge  λ = 400 – 700 nm, bzw. einer Frequenz f = 430 – 750 THz

"""

# ╔═╡ 29db8930-3faa-4099-babc-67f942d5b276
md"""
Es gibt sehr viele Arten, Licht zu detektieren. Die Übersicht auf dem englischen [Wikipedia-Seite](https://en.wikipedia.org/wiki/Photodetector) ist ziemlich vollständig.

**Fotofilm** Belichtung führt zu bleibender chemischen Reaktion. Selbst einzelne Photonen können registriert werden. Dies war bis vor ca. 30 Jahren die Schlüsselmethode bzgl. Empfindlichkeit und räumlicher Auflösung.

**Thermisch** Idealerweise schwarzer Absorber. Die
      Temperaturdifferenz zur Umgebung wird in ein elektrisches Signal gewandelt.
      Wichtige Typen: Thermosäule (engl. Thermopile), Pyrodetektor (zeitliche Änderungen), Bolometer. Vorteile:
      Spektral Breitbandig, robust. Nachteile: langsame Anstiegszeit, Empfindlichkeit.

**Quanten-Sensoren** benutzen den Inneren oder äußeren Photoeffekt.
     Photomultiplier (-tube, PMT), Photoleiter, Photodioden. Einzelne Photonen können registriert werden, schnell, oft sub-µs. Je niederenergetischer das Photon, desto komplizierter die Detektion.
"""

# ╔═╡ 02923951-dce2-4941-be90-3b3cc0f764bb
md"""
In diesem Kapitel besprechen wir nur Quanten-Sensoren, im wesentlichen solche, die den inneren Photoeffekt benutzen. Wir folgendem dem Kapitel 17 bzw. 18 über Halbleiter-Photodetektoren in Saleh/Teich.
"""

# ╔═╡ 870cc18a-e47e-490a-9d23-b13211bb3f5f
md"""
# Der äußere Photoeffekt

Beim äußeren Photoeffekt wird ein Elektron im Material durch  Absorption eines Photons in ein freies Elektron überführt. In Metallen stammt dieses Elektron aus dem Leitungsband, und die Austrittsarbeit (engl. work function) $W$ muss überwunden werden. Die verbleibende (kinetische) Energie des Elektrons ist dann
```math
E_{max} = h \nu - W
```
Typische Werte für $W$ liegen im Bereich von einigen eV. Am niedrigsten ist sie bei Cäsium (Cs) mit $W_{Cs} \approx 2$ eV. Photokathoden aus Metall verlangen also blaue bis ultraviolette Photonen.

Bei Halbleitern ist das im Wesentlichen identisch. Das Elektron stammt dann aus dem Valenzband, da das Leitungsband quasi leer ist. Es muss die Energie der Bandlücke überwunden werden sowie die der Elektronen-Affinität $\chi$, also die Differenz der oberen Bandkante zum Vakuum. Insgesamt also
```math
E_{max} = h \nu - (E_g + \chi)
```
Für bestimmte Materialien ist $(E_g + \chi)$ aber relativ klein, z.B. bei NaKCsSb 
etwa 1.4 eV. Dieses Material bildet die oft benutzte S20-Photokathode.

der äußere Photoeffekt wird in PMTs benutzt. Licht fällt auf die Photokathode, ein Elektron wird freigesetzt und durch eine Potentialdifferenz hin zu einer ersten Elektrode beschleunigt. Dort werden weitere Elektronen herausgeschlagen, da das erste Elektron an dieser Stelle eine Energie hat, die viel größer als die des Photons ist. Die Elektronenzahl wid also multipliziert. Dieser Effekt wird mehrmals wiederholt. Man bekommt also einen messbaren Strom-Puls, der von einem einzigen Photon ausgelöst wurde, und etwa $10^7$ Elektronen pro Photon umfasst.

"""

# ╔═╡ d740d9cf-e23f-498e-a80e-316adbab448c
md"""
# Der innere Photoeffekt

Beim inneren Photoeffekt wird ein Elektron durch Absorption eines Photons vom Valenzband ins Leitungsband angehoben. Im Valenzband verbleibt ein Loch. Durch Anlegen einer Spannungen werden Loch und Elektron räumlich voneinander getrennt und ein Strom fließt. Das geschieht an der Grenze zwischen einem p- und einem n-dotierten Bereich in einer pn-Photodiode. 

Die Elektronen-Multiplikation des PMT kann man auch im Halbleiter nachbilden. Dabei wird eine starke Beschleunigungsspannung über die Grenzschicht angelegt. Man erhält einen lawinenartig ansteigenden Strom, der passend gestoppt werden muss. Dies ist die Lawinen-Photodiode (engl. avalanche photodiode, APD). Sie verstärkt den Strom gegenüber einer pn-Diode und so können einzelnen Photonen detektiert werden.
"""

# ╔═╡ d450fd59-076b-42a1-a8f8-57c769f017b2
md"""
# Parameter

## Quanteneffizienz

Die Quanteneffizienz $\eta$ beschreibt, mit welcher Wahrscheinlichkeit ein einzelnes Photon freie Ladungsträger erzeugt und so zum Photostrom beiträgt. $\eta$ liegt natürlich zwischen 0 und 1. Darin geht ein, mit welcher Wahrscheinlichkeit das Photon überhaupt im Material absorbiert wird (Reflexivität der Oberfläche, Absorption des Materials), und mit welcher Wahrscheinlichkeit dies zu einem passenden Ladungsträger führt.

In Halbleiter-Photodioden ist Quanteneffizienz $\eta$ wellenlängenabhängig. Bei zu großer Wellenlänge wird die Bandlücke $E_g$ nicht überwunden und $\eta \approx 0$. In Richtung kleiner Wellenlänge / großer Energie ist der Bereich dadurch limitiert, dass das Photon quasi nicht in das Material eindringt, an der Oberfläche absorbiert wid, dort aber in Fallenzuständen endet und nicht zum Strom beiträgt.- 

Typische Werte der Quanteneffizienz $\eta$ sind etwa 0.5 bis 0.9.

"""

# ╔═╡ 6ef1f1e8-7db9-4636-811a-0bd18303358d
md"""
## Empfindlichkeit

Die Empfindlichkeit (engl. responsivity) verknüpft den einfallenden Fluss an Photonen mit dem entstehenden Fluss an Elektronen, beschreibt also die  elektrische Stromantwort auf einfallende Lichtleistung $P$. Der Strom ist 
```math
 i_P = \eta e \Phi_{opt} = \frac{\eta \, e}{h \nu} \, P = R \, P
```
Die Empfindlichkeit $R$ hat die Einheit A/W
```math
 R = \frac{\eta \, e}{h \nu} = \eta \, \frac{\lambda}{1240 \, nm} A/W
```
Die Empfindlichkeit hängt linear von der Wellenlänge $\lambda$ ab, bei konstanter Quanteneffizienz. Dies hängt damit zusammen, dass ja eigentlich Photonen in Elektronen umgewandelt werden, und nicht optische Energie in Strom. Bei niedriger Wellenlänge bringt ein Photon viel Leistung mit; bei gleicher Lichtleistung $P$ bekommt man also relativ wenig Elektronen.

Typische Werte der Empfindlichkeit sind $R \approx 0.5 A/W$. 

"""

# ╔═╡ e99c3b8a-1942-4e07-ab27-2a44ff24eb96
md"""
### Beispiel: Silizium-Photodiode

FDS100, [Thorlabs](https://www.thorlabs.com/thorproduct.cfm?partnumber=FDS100)
bzw [hier](https://www.thorlabs.com/newgrouppage9.cfm?objectgroup_id=285) auf das '(i)' klicken.

"""

# ╔═╡ f0d38cf3-b3ed-49ef-a3ab-a4a3acb3ca18
FDS100 = DataFrame(XLSX.readtable(Downloads.download("https://www.thorlabs.com/images/popupImages/FDS100_Res_data.xlsx"),"Responsivity", "C:D"; first_row=2)...)

# ╔═╡ bf5e9bb0-1f21-4576-905d-b134b8c2762c
import PhysicalConstants.CODATA2018: c_0, h, e

# ╔═╡ f5313df1-f07c-4407-ac37-8e9a8b667414
begin
	λ = FDS100[!,"Wavelength (nm)"]
	R = FDS100[!,"Responsivity (A/W)"]

	η = 1
	Rmodel = @.  η * (e / (h * c_0 / (λ * 1u"nm")))
	Rmodel_AW = ustrip.(uconvert.(u"A/W", Rmodel))
	
	plot(λ, R, legend=false, xlabel="Wellenlänge (nm)", ylabel="Empfindlichkeit (A/W)")
	plot!(λ, Rmodel_AW)
end

# ╔═╡ 11d95dd8-dc96-4317-981b-b4c8bbeb6362
md"""
## Antwortzeit

Die Antwortzeit (engl. response time) beschreibt die Impulsantwort der Photodiode. Sie wird durch zwei Größen bestimmt: die Transit-Zeit und die RC-Zeitkonstante.

Die Transit-Zeit ist die Zeit, die benötigt wird, um alle Ladungsträger aus dem aktiven Bereich der Photodiode heraus zu bekommen. Wenn der aktive Bereich die Breite $w$ hat und die Ladungsträger mit der Geschwindigkeit $v(t)$ bewegt werden, dann ist der Strom
```math
i(t) = - \frac{Q}{w} \, v(t)
```
mit $Q=+e$ für Löcher und $Q=-e$ für Elektronen. Je kleiner der aktive Bereich, desto schneller also die Antwort der Diode. 

Die RC-Zeit entsteht dadurch, dass immer Widerstände $R$ und Kapazitäten $C$ vorhanden sind, selbst in der Diode allein. Dies führt dazu, dass obige Impulsantwort mit einem Exponentialgesetz zu falten ist
```math
h_{rc}(t) = \frac{1}{RC} e^{- \frac{t}{RC}}
```
"""

# ╔═╡ 8006880f-9f33-4a9b-9433-d4a31ab8502b
md"""
Für obige FDS100 gibt der Händler an: $C \approx 24$ pF und $\tau_{diode} \approx 10$ ns bei $R= 50 \Omega$
"""

# ╔═╡ 46cf25e2-f549-4997-95bf-fec87f6f3ced
let
	R = 50.0u"Ω"
	C = 24.0u"pF"
	tau = R * C |> u"ns"
end

# ╔═╡ 41bd75ea-907c-4db3-aac4-cffea61b6730
md"""
Die Impulsantwort wird also durch die Transit-Zeit dominiert.
"""

# ╔═╡ fdb400fb-d193-4fc4-8951-1d1d92741f08
md"""
## Kennlinie

Die Strom-Spannungs-Kennlinie einer Photodiode ist identisch der einer normalen Diode, zuzüglich einem Photostrom. Auch eine Solarzelle hat diese Kennlinie.
```math
i = i_s \left[ \exp \left( \frac{eV}{kT}   \right)  -1   \right] - i_p
```
mit dem Sättigungs(sperr)strom $i_s$, dem Photostrom $i_p$ und der Spannung $V$ (positiv in Durchlassrichtung)
"""

# ╔═╡ 1b091521-955d-4972-adb6-1d6e43a67e53
let
	x = (-3:0.1:3)
	I(p) = exp.(x) .- 1 .- p
	plot(x, I(0), label="dunkel")
	plot!(x, I(5), label="mittel")
	plot!(x, I(10), label="hell", xlabel="Spannung V", ylabel="Strom i",framestyle = :zerolines)
end

# ╔═╡ 185633a7-584b-4da0-83b1-5621446596f3
md"""
Man kann die Diode bei verschiedenen Arbeitspunkten betreiben, je nach angelegter Spannung. 'open circuit' lässt keinen Strom fließen, weil (quasi) keine Last anliegt. Dies sind Punkte mit $i=0$. 'short circuit' schließt die Diode kurz, ohne externe Spannung. Dies sind Punkte mit $V=0$. Eine Solarzelle betreibt man im rechten unteren Quadraten, also bei $V>0$ und $i < 0$, idealerweise so, dass $P = i V$ maximal wird.

Als Photodetektor will man einen linearen Verlauf zwischen dem einfallenden Photonenstrom und damit dem Photostrom $i_p$ und dem gemessenen Gesamtstrom $i$ erreichen. Man legt eine (negative) Bias-Spannung $V_B$ an und setzt $V = V_B. < 0$. Wenn ein Last-Widerstand vorhanden ist, dann ist $V = V_B + R_{Last} \, i$.

Im Beispiel oben wurde $V_B = -20$ V gewählt.
"""

# ╔═╡ d8bb6f1c-e9c8-4001-aed2-6c8fe7ae38f6
md"""
# Lawinenphotodioden

In einer Lawinenphotodioden (engl avalanche photo diode, APD) erzeugt ein Photon  durch sehr hohe interne Beschleunigungsspannung via Stoßionisation eine Kaskade von Ladungsträgerpaaren. Dies entspricht einer internen Verstärkung $G$. Man kann diese Dioden 'analog' betreiben, also nur den Strom messen, oder im Geiger-Modus. Dabei wird mit einer passenden Schaltung die hohe Leitfähigkeit während der Lawine 'gelöscht', so dass einzelne Impulse entstehen. Diese können dann gezählt werden, womit man im Endeffekt einzelne Photonen zählen kann.
"""

# ╔═╡ 572ef31f-fa6f-4edd-a308-de5120d425ad
md"""
# Rauschen in Photodetektoren

Verschiedene Quellen tragen zum Rauschen von Photodetektoren bei

- Photonen-Rauschen: Photonen unterliegen der Poisson-Statistik, so dass bei $n$ Photonen pro Zeitintervall die Standardabweichung $\sqrt{n}$ beträgt

- Photoelektronen-Rauschen: Die Quanteneffizienz $\eta$ ist immer kleiner 1. Damit entsteht zusätzliches Rauschen durch die 'Entscheidung', ob dieses Photon jetzt ein Elektron erzeugt oder nicht. Das ist äquivalent mit (und viel einfacher zu verstehen über) einer Reduktion des Photonenstroms von $n$ auf $\eta n$. Man ersetzt einen realen Detektor durch einen idealen plus vorgeschalteten abschwächenden optischen Filter.

- Verstärkungs-Rauschen: in APDs ist die Größe der Lawine stochastisch und bewirkt einen zusätzlichen Rauschbeitrag

- Elektronisches Rauschen: alle elektronische Bauteile wie Widerstände und Transistoren tragen zum Rauschen bei.

- Hintergrund-Rauschen: Manchmal ist der Hintergrund nicht dunkel. Ein abwesendes Signal führt also *nicht* zur Detektion einer Null. Dies ist ärgerlich und unangenehm und sollte durch Verändern des Aufbaus beseitigt werden.
"""

# ╔═╡ ac7a11b1-ef92-4990-abd5-4abbc09664ec
md"""
> See figure 18.6-1 in Saleh/Teich
"""

# ╔═╡ ad0d49ac-47b4-47fd-b64a-cab4a6052bca
md"""
## Signal-zu-Rauschen

Das Verhältnis von Signal-Amplitude zu Rauschen (engl. signal to noise ration, SNR) ist die zentrale Größe. Sie ist definiert als
```math
\text{SNR} = \frac{i}{\sigma_i} = \frac{n}{\sigma_n}
```
je nach dem, ob man einen Strom $i$ misst oder $n$ Photonen zählt. Manchmal, insbesondere in den Ingenieurwissenschaften, bezieht man sich auf detektierte Leistungen und nicht Amplituden, so auch in Saleh/Teich. Dann sind die rechten Seiten von obigen Gleichung quadriert.
"""

# ╔═╡ b6d4bf33-5e7b-42ae-8652-4c1992a38d5a
md"""
## Noise-Equivalent Power (NEP)

Die NEP ist die optische Leistung $P$, die zu einem SNR von 1 führt. Manchmal wird sie auch 'minimum detectable signal' genannt. Im Folgenden diskutieren wir das SNR.
"""

# ╔═╡ 8aa0f3f3-c57c-43c0-870c-1421a65dc252
md"""
## Photonen-Rauschen

Falls nur Photonen-Rauschen vorliegt, bzw. dies der dominante Anteil ist, dann ist es einfach, SNR und NEP auszurechnen. Bei $n$ detektierten Photonen beträgt die Standardabweichung $\sigma = \sqrt{n}$. Somit ist
```math
\text{SNR} = \frac{n}{\sqrt{n}} = \sqrt{n}
```
Ein SNR von 1 erhält man bei einem detektierten Photon ($n=1$) pro Zeitintervall.
"""

# ╔═╡ ed23907d-8627-40c4-8ebf-cb8879ffe3fd
let
	T = 1.0u"µs"
	λ = 620u"nm"
	P = h * c_0 / (λ * T) |> u"fW"
end

# ╔═╡ e31bd36e-6857-4bfb-a592-172515731ba4
md"""
Bei einer Integrationszeit von 1 µs und einer Wellenlänge von 620 nm beträgt die NEP also ca. 330 fW.
"""

# ╔═╡ 6f0580a1-71a9-4553-bce2-3bd116599644
md"""
## Rauschen in Photostrom

Wir können das genauso aus der Sicht eines Photostroms betrachten. Eine optische Leistung $P$ führt bei der Empfindlichkeit $R$ zu einem Strom $i  = R \, P$. Das Schrot-Rauschen auf einem Strom hat die Standardabweichung
```math
\sigma = \sqrt{2 i \, e B} =  \sqrt{2 R\,P \, e B}
```
mit der Bandbreite $B$. Also ist das SNR
```math
\text{SNR} = \sqrt{\frac{R \, P}{2  e B}}
```
(Jetzt wird auch deutlich, warum eine quadratische Definition des SNR sinnvoll sein kann). Die NEP ist dann unabhängig von quadratisch oder nicht 
```math
\text{NEP} = \frac{2  e B}{R}
```
"""

# ╔═╡ b0227416-4706-4444-a716-dd4a440f845e
let
	B = 500u"kHz"
	R = 0.5u"A/W"
	P = 2 * e * B / R |> u"fW"
end

# ╔═╡ cd024817-566b-450f-a7f5-f4c26616cdd6
md"""
Man beachte, dass die Bandbreite einer Messung mit Integrationszeit $T$ nur $1/2T$ ist.
"""

# ╔═╡ e05eb9eb-cfb3-4ccb-bd0b-43d9da0d792a
md"""
### Noise-equivalent bandwidth (NEBW)

Eine Nebenbemerkung zur Bandbreite $B$. Was wir hier benötigen, ist die 'Noise-equivalent bandwidth' NEBW. Der Frequenzverlauf der Transferfunktion des Detektionssystems geht vollständig ein, nicht nur die -3dB Grenzfrequenz des Filters. Es gilt
```math
\text{NEBW} = \int_0^\infty \left| \frac{H(f)}{H(0)} \right|^2 df
```

Für ein einfachen RC-Tiefpassfilter ist die Transferfunktion
```math
H(\omega) = \frac{1}{\sqrt{1  + (\tau \omega)^2}}
```
mit $\tau = R C$. Damit wird 
```math
\text{NEBW} = \frac{\pi}{2 \tau} 
```

Bei steileren Filtern (höheren Filter-Ordnungen) wird der Faktor $\pi/2$ zunehmend kleiner.
"""

# ╔═╡ 8314e09e-65da-4515-a62d-3041ad102cb6
let 
	df = 0.001
	f = (0:df:1000);
	H = @. 1 / sqrt(1 + f^2)
	(sum(H.^2) .* df , pi/2)
end

# ╔═╡ 7d7ce080-6e9c-46d4-9cdd-3f6e65ccc06e
md"""
## Verstärkungs-Rauschen

Wenn die Verstärkung durch den Lawinen-Prozess einer APD immer gleich groß wäre, dann würde deren Faktor $G$ in Zähler und Nenner des SNR gleichermaßen eingehen und sich kürzen. Das Problem sind Fluktuationen in $G$, also die Varianz $\sigma_G$. Man beschreibt das über einen 'excess noise factor' F
```math
 F = 1+ \frac{\sigma_g^2}{\left< G \right> ^2}
```

Das SNR wird damit
```math
\text{SNR} = \sqrt{\frac{R \, P}{2  e B \,F}}
```

Typische Werte von $F$ liegen zwischen kurz über 1 und 2.


"""

# ╔═╡ 1593544d-0984-4927-bd5c-c3034beab2b1
md"""
## Elektronisches Rauschen

Elektronische Bauteile rauschen. Thermisches Johnson-Rauschen am Shunt-Widerstand parallel zur Photodiode führt zu 
```math
\sigma_{Johnson}  =  \sqrt{\frac{4 kT}{R_{shunt}} \, B}
```
Der Dunkelstrom  der Diode führt zu 
```math
\sigma_{dunkel}  = \sqrt{2 I_{dunkel} \, e B}
```
"""

# ╔═╡ e79722c5-f674-4292-9161-b49a4a935610
md"""
Für obige Diode ist ein Dunkelstrom von $I_{dunkel} = 1$ nA angegeben.
"""

# ╔═╡ ca9fcc00-558b-4008-b9f9-7321e6115731
begin
	I_dunkel = 1u"nA"
	σ_dunkel = sqrt(2 * I_dunkel * e) |> u"fA/Hz^0.5"
end

# ╔═╡ 9dc7d2e9-8515-4d3f-aa85-27f23d323edd
begin
	R900 = 0.6u"A/W"
	NEP900 = σ_dunkel / R900|> u"fW/Hz^0.5"
end

# ╔═╡ ed5ba03b-15ad-4100-b338-6c5ea1261d3d
md"""
Angegeben sind im Datenblatt NEP = $12 \,fW/\sqrt{Hz}$. Das scheint nicht ganz mit dem Dunkelstrom zusammenzupassen. Zusätzliches Johnson-Rauschen würde dies nur schlechter machen.
"""

# ╔═╡ 434da4bd-17d2-4c3e-9acf-b6714250dfe5
md"""
# Photodetektor OE-200 von Femto

Wir betrachten als Beispiel diesen Photodetektor bestehend aus Diode und Verstärker.

- [website](https://www.femto.de/en/products/photoreceivers/variable-gain-up-to-500-khz-oe-200.html)
- [Datenblatt](https://www.femto.de/images/pdf-dokumente/de-oe-200-si.pdf)
"""

# ╔═╡ 4cfc69b4-2b69-48ba-a161-78b76396a746
md"""

## Q1
Licht (Wellenlänge 532 nm, Leistung 100 µW) fällt auf den Detektor, der im niedrigsten Verstärkungsbereich eingestellt ist.
Wie groß ist die Spannung des Ausgangssignals ?

"""

# ╔═╡ 21f83198-bbd1-494d-a22a-7ca5fc2aa4b4
md"""
## Q2

Licht der Wellenlänge 850 nm wird mit $f_m$ = 300 kHz moduliert.
Welche Eingangsleistung wird mindestens benötigt, um ein Signal bei $f_m$ am Ausgang mit der Amplitude von 10 V zu erhalten?

"""

# ╔═╡ ea85ed7a-5c9c-4259-abde-ef6c9c0a89b3
md"""
## Q3
Es wird Licht der Leistung P = 1 µW bei einer Wellenlänge von 850 nm detektiert. Wie groß ist die zu erwartende spektrale Rausch-Leistungsdichte durch Schrotrauschen?
In welcher Einstellung ist das Rauschen des Detektors kleiner als dieser Wert? 

"""

# ╔═╡ 522ce802-3c99-483a-8515-7fd071509069
TableOfContents(title="Inhalt")

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
Downloads = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
PhysicalConstants = "5ad8b20f-a522-5ce9-bfc9-ddf1d5bda6ab"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Unitful = "1986cc42-f94f-5a68-af5c-568840ba703d"
XLSX = "fdbf4ff8-1666-58a4-91e7-1b58723a45e0"

[compat]
DataFrames = "~1.4.4"
PhysicalConstants = "~0.2.3"
Plots = "~1.38.3"
PlutoUI = "~0.7.49"
Unitful = "~1.12.2"
XLSX = "~0.8.4"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.5"
manifest_format = "2.0"
project_hash = "b796f4c996540e08c7a3ea25920fe328a181f7ed"

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

[[deps.CommonSolve]]
git-tree-sha1 = "9441451ee712d1aec22edad62db1a9af3dc8d852"
uuid = "38540f10-b2f7-11e9-35d8-d573e4eb0ff2"
version = "0.2.3"

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

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.DataAPI]]
git-tree-sha1 = "e8119c1a33d267e16108be441a287a6981ba1630"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.14.0"

[[deps.DataFrames]]
deps = ["Compat", "DataAPI", "Future", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrettyTables", "Printf", "REPL", "Random", "Reexport", "SnoopPrecompile", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "d4f69885afa5e6149d0cab3818491565cf41446d"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.4.4"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "d1fff3a548102f48987a52a2e0d114fa97d730f0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.13"

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

[[deps.EzXML]]
deps = ["Printf", "XML2_jll"]
git-tree-sha1 = "0fa3b52a04a4e210aeb1626def9c90df3ae65268"
uuid = "8f5d6c58-4d21-5cfd-889c-e3ad7ee6a615"
version = "1.1.0"

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

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "49510dfcb407e572524ba94aeae2fced1f3feb0f"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.8"

[[deps.InvertedIndices]]
git-tree-sha1 = "82aec7a3dd64f4d9584659dc0b62ef7db2ef3e19"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.2.0"

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

[[deps.Measurements]]
deps = ["Calculus", "LinearAlgebra", "Printf", "RecipesBase", "Requires"]
git-tree-sha1 = "12950d646ce04fb2e89ba5bd890205882c3592d7"
uuid = "eff96d63-e80a-5855-80a2-b1b0885c5ab7"
version = "2.8.0"

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

[[deps.PhysicalConstants]]
deps = ["Measurements", "Roots", "Unitful"]
git-tree-sha1 = "cd4da9d1890bc2204b08fe95ebafa55e9366ae4e"
uuid = "5ad8b20f-a522-5ce9-bfc9-ddf1d5bda6ab"
version = "0.2.3"

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

[[deps.PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "a6062fe4063cdafe78f4a0a81cfffb89721b30e7"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.2"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.PrettyTables]]
deps = ["Crayons", "Formatting", "LaTeXStrings", "Markdown", "Reexport", "StringManipulation", "Tables"]
git-tree-sha1 = "96f6db03ab535bdb901300f88335257b0018689d"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "2.2.2"

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

[[deps.Roots]]
deps = ["ChainRulesCore", "CommonSolve", "Printf", "Setfield"]
git-tree-sha1 = "a3db467ce768343235032a1ca0830fc64158dadf"
uuid = "f2b01f46-fcfa-551c-844a-d8ac1e96c665"
version = "2.0.8"

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

[[deps.Setfield]]
deps = ["ConstructionBase", "Future", "MacroTools", "StaticArraysCore"]
git-tree-sha1 = "e2cc6d8c88613c05e1defb55170bf5ff211fbeac"
uuid = "efcf1570-3423-57d1-acb7-fd33fddbac46"
version = "1.1.1"

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

[[deps.StringManipulation]]
git-tree-sha1 = "46da2434b41f41ac3594ee9816ce5541c6096123"
uuid = "892a3eda-7b42-436c-8928-eab12a02cf0e"
version = "0.3.0"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.0"

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

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unitful]]
deps = ["ConstructionBase", "Dates", "LinearAlgebra", "Random"]
git-tree-sha1 = "d670a70dd3cdbe1c1186f2f17c9a68a7ec24838c"
uuid = "1986cc42-f94f-5a68-af5c-568840ba703d"
version = "1.12.2"

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

[[deps.XLSX]]
deps = ["Artifacts", "Dates", "EzXML", "Printf", "Tables", "ZipFile"]
git-tree-sha1 = "ccd1adf7d0b22f762e1058a8d73677e7bd2a7274"
uuid = "fdbf4ff8-1666-58a4-91e7-1b58723a45e0"
version = "0.8.4"

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

[[deps.ZipFile]]
deps = ["Libdl", "Printf", "Zlib_jll"]
git-tree-sha1 = "f492b7fe1698e623024e873244f10d89c95c340a"
uuid = "a5390f91-8eb1-5f08-bee0-b1d1ffed6cea"
version = "0.10.1"

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
# ╟─0e6b72ce-38e4-4212-921e-1221d0740b7a
# ╟─4580e946-96f3-11ec-38d9-bbfb594fb979
# ╟─0254558d-a260-4763-a761-629a78e0d8dd
# ╟─29db8930-3faa-4099-babc-67f942d5b276
# ╟─02923951-dce2-4941-be90-3b3cc0f764bb
# ╟─870cc18a-e47e-490a-9d23-b13211bb3f5f
# ╟─d740d9cf-e23f-498e-a80e-316adbab448c
# ╟─d450fd59-076b-42a1-a8f8-57c769f017b2
# ╟─6ef1f1e8-7db9-4636-811a-0bd18303358d
# ╟─e99c3b8a-1942-4e07-ab27-2a44ff24eb96
# ╠═8a6359c4-5064-45fb-89c3-8d9bd799e04e
# ╠═f0d38cf3-b3ed-49ef-a3ab-a4a3acb3ca18
# ╠═f5313df1-f07c-4407-ac37-8e9a8b667414
# ╠═bf5e9bb0-1f21-4576-905d-b134b8c2762c
# ╠═a880e78b-6a35-479b-ae53-6269347f1f70
# ╟─11d95dd8-dc96-4317-981b-b4c8bbeb6362
# ╟─8006880f-9f33-4a9b-9433-d4a31ab8502b
# ╠═46cf25e2-f549-4997-95bf-fec87f6f3ced
# ╟─41bd75ea-907c-4db3-aac4-cffea61b6730
# ╟─fdb400fb-d193-4fc4-8951-1d1d92741f08
# ╠═1b091521-955d-4972-adb6-1d6e43a67e53
# ╟─185633a7-584b-4da0-83b1-5621446596f3
# ╟─d8bb6f1c-e9c8-4001-aed2-6c8fe7ae38f6
# ╟─572ef31f-fa6f-4edd-a308-de5120d425ad
# ╟─ac7a11b1-ef92-4990-abd5-4abbc09664ec
# ╟─ad0d49ac-47b4-47fd-b64a-cab4a6052bca
# ╟─b6d4bf33-5e7b-42ae-8652-4c1992a38d5a
# ╟─8aa0f3f3-c57c-43c0-870c-1421a65dc252
# ╠═ed23907d-8627-40c4-8ebf-cb8879ffe3fd
# ╟─e31bd36e-6857-4bfb-a592-172515731ba4
# ╟─6f0580a1-71a9-4553-bce2-3bd116599644
# ╠═b0227416-4706-4444-a716-dd4a440f845e
# ╟─cd024817-566b-450f-a7f5-f4c26616cdd6
# ╟─e05eb9eb-cfb3-4ccb-bd0b-43d9da0d792a
# ╠═8314e09e-65da-4515-a62d-3041ad102cb6
# ╟─7d7ce080-6e9c-46d4-9cdd-3f6e65ccc06e
# ╟─1593544d-0984-4927-bd5c-c3034beab2b1
# ╟─e79722c5-f674-4292-9161-b49a4a935610
# ╠═ca9fcc00-558b-4008-b9f9-7321e6115731
# ╠═9dc7d2e9-8515-4d3f-aa85-27f23d323edd
# ╟─ed5ba03b-15ad-4100-b338-6c5ea1261d3d
# ╟─434da4bd-17d2-4c3e-9acf-b6714250dfe5
# ╟─4cfc69b4-2b69-48ba-a161-78b76396a746
# ╟─21f83198-bbd1-494d-a22a-7ca5fc2aa4b4
# ╟─ea85ed7a-5c9c-4259-abde-ef6c9c0a89b3
# ╠═b5bcc95c-05c5-4e9c-84ab-a04dc0cef191
# ╠═87c27d3d-a773-4fa6-b193-5e274c1cd733
# ╠═522ce802-3c99-483a-8515-7fd071509069
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
