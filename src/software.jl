### A Pluto.jl notebook ###
# v0.18.1

using Markdown
using InteractiveUtils

# ╔═╡ 4869c4e2-99ab-48a1-95fe-3ef1218286fb
using PlutoUI

# ╔═╡ f5450eab-0f9f-4b7f-9b80-992d3c553ba9
# DO NOT MODIFY, will be updated by update_navbar.jl
HTML("    <nav >\n    Vorbereitungen:\n\n<a class=\"sidebar-nav-item {{ispage /index}}active{{end}}\" href=\"index\"><em>Intro</em></a> / \n<a class=\"sidebar-nav-item {{ispage /software}}active{{end}}\" href=\"software\"><em>Software</em></a> / \n<a class=\"sidebar-nav-item {{ispage /links}}active{{end}}\" href=\"links\"><em>Hints</em></a> / \n<a class=\"sidebar-nav-item {{ispage /01-basic_syntax}}active{{end}}\" href=\"01-basic_syntax\"><em>Julia Basics</em></a> / \n\n<br>\nStatistik:\n\n<a class=\"sidebar-nav-item {{ispage /02-beschreibende-statistik}}active{{end}}\" href=\"02-beschreibende-statistik\"><em>Beschreibende Statistik</em></a> / \n<a class=\"sidebar-nav-item {{ispage /03-wahrscheinlichkeit}}active{{end}}\" href=\"03-wahrscheinlichkeit\"><em>Wahrscheinlichkeit</em></a> / \n<a class=\"sidebar-nav-item {{ispage /04-messunsicherheit}}active{{end}}\" href=\"04-messunsicherheit\"><em>Messunsicherheit</em></a> / \n<a class=\"sidebar-nav-item {{ispage /05-schaetzung}}active{{end}}\" href=\"05-schaetzung\"><em>Schätzung</em></a> / \n\n<br>\nFourier-Transformation:\n\n<a class=\"sidebar-nav-item {{ispage /06-Fourier-Transformation}}active{{end}}\" href=\"06-Fourier-Transformation\"><em>Fourier-Transformation</em></a> / \n<a class=\"sidebar-nav-item {{ispage /07-Frequenzraum}}active{{end}}\" href=\"07-Frequenzraum\"><em>Frequenzraum</em></a> / \n<a class=\"sidebar-nav-item {{ispage /08-Filter}}active{{end}}\" href=\"08-Filter\"><em>Filter</em></a> / \n\n<br>\nMesstechnik:\n\n<a class=\"sidebar-nav-item {{ispage /09-Rauschen}}active{{end}}\" href=\"09-Rauschen\"><em>Rauschen</em></a> / \n<a class=\"sidebar-nav-item {{ispage /10-Detektoren}}active{{end}}\" href=\"10-Detektoren\"><em>Detektoren</em></a> / \n<a class=\"sidebar-nav-item {{ispage /11-Lock-In}}active{{end}}\" href=\"11-Lock-In\"><em>Lock-In-Verstärler</em></a> / \n<a class=\"sidebar-nav-item {{ispage /12-heterodyn}}active{{end}}\" href=\"12-heterodyn\"><em>Heterodyn-Detektrion</em></a> / \n\n<br>\nReste:\n\n<a class=\"sidebar-nav-item {{ispage /99-newton_method}}active{{end}}\" href=\"99-newton_method\"><em>Newton Method</em></a> / \n\n<br>\n\n\n    </nav>\n\t")

# ╔═╡ 309dbb64-37a3-4f8c-975c-d16e7ae1a8d1
md"""
# Erstmalige Einrichtung: Installieren Sie Julia & Pluto
"""

# ╔═╡ 6ed88b23-3297-49b6-a485-efef79ab5d67
md"""
> **Acknowledgement** 
> This material is translated from _**Computational Thinking**, a live online Julia/Pluto textbook._ [(computationalthinking.mit.edu)](https://computationalthinking.mit.edu)

"""

# ╔═╡ bf0af2de-193d-4327-9bd3-91347934cac1
md"""
## Schritt 1: Julia 1.7.2 installieren

Von [https://julialang.org/downloads](https://julialang.org/downloads) die aktuelle stabile Version, Julia 1.7.2 herunterladen, in der passenden Version für Ihr Betriebssystem (Linux x86, Mac, Windows, etc.).

*Mac-Benutzer aufgepasst!* Laden Sie **nicht** die ARM/M-Serienversion von Julia herunter! Sie ist noch experimentell und einige Pakete werden nicht funktionieren.
"""

# ╔═╡ bc92a414-7d91-43ed-9152-6a6ef24e3991
md"""
## Schritt 2: Julia ausführen


Nach der Installation müssen Sie **sicherstellen, dass Sie Julia ausführen können**. Auf einigen Systemen bedeutet dies, dass Sie nach dem Programm "Julia 1.7.2" suchen müssen, das auf Ihrem Computer installiert ist; auf anderen bedeutet es, dass Sie den Befehl "Julia" in einem Terminal ausführen müssen. Stellen Sie sicher, dass Sie Folgendes ausführen können: `1 + 1`
"""

# ╔═╡ 0221cdc7-6433-4b53-a7bf-723dde46e778
md"""
![image](https://user-images.githubusercontent.com/6933510/91439734-c573c780-e86d-11ea-8169-0c97a7013e8d.png)
"""

# ╔═╡ 67298b17-feeb-43e4-a2fe-5d881f08480f
md"""
*Vergewissern Sie sich, dass Sie in der Lage sind, Julia zu starten und `1+1` zu berechnen, bevor Sie fortfahren!*
"""

# ╔═╡ f11b1419-7c7a-4b17-ba58-f5bc48a79371
md"""
## Schritt 3: Installieren Sie [`Pluto`](https://github.com/fonsp/Pluto.jl)

Als nächstes installieren wir das [**Pluto Notebook**](https://github.com/fonsp/Pluto.jl/blob/master/README.md) das wir während des Kurses benutzen werden. Pluto ist eine Julia _Programmierumgebung_, die für Interaktivität und schnelle Experimente konzipiert ist.

Öffnen Sie die **Julia REPL**. Dies ist die Kommandozeilen-Schnittstelle zu Julia, ähnlich wie auf dem vorherigen Screenshot.

Hier geben Sie _Julia-Befehle_ ein, und wenn Sie ENTER drücken, wird das Programm ausgeführt, und Sie sehen das Ergebnis.
"""

# ╔═╡ 4f9511fd-8c6f-4f1f-9c48-6fee0c5bbf81
md"""
Um Pluto zu installieren, müssen wir einen _Paketmanager-Befehl_ ausführen. Um vom _Julia_ Modus in den _Pkg_ Modus zu wechseln, geben Sie `]` (schließende eckige Klammer) an der `julia>` Eingabeaufforderung ein:
```julia
julia> ]

(@v1.7) pkg>
```
"""

# ╔═╡ 0ea77d58-d77f-4995-9404-5ca7cd29c464
md"""
Die Zeile wird blau und die Eingabeaufforderung ändert sich zu `pkg>`, was Ihnen mitteilt, dass Sie sich jetzt im _Paketverwaltungsmodus_ befinden. Dieser Modus erlaubt es Ihnen, Operationen mit **Paketen** (auch Bibliotheken genannt) durchzuführen.
"""

# ╔═╡ d0b14351-175a-43f8-9360-899e2df19758
md"""
Um Pluto zu installieren, führen Sie den folgenden Befehl (Groß-/Kleinschreibung beachten) aus, um das Paket zu Ihrem System *hinzufügen* (installieren), indem Sie es aus dem Internet herunterladen.
Sie sollten dies nur *einmal* für jede Installation von Julia tun müssen:

```julia
(@v1.7) pkg> add Pluto
```

Das kann ein paar Minuten dauern, daher können Sie sich eine Tasse Tee holen!
"""

# ╔═╡ d3e489c6-3e49-4aa3-9ffb-d425f22b554c
md"""
![image](https://user-images.githubusercontent.com/6933510/91440380-ceb16400-e86e-11ea-9352-d164911774cf.png)

Sie können nun das Terminal schließen.
"""

# ╔═╡ 125c3d4d-dc7c-40f1-9f26-578f6d8a1034
md"""
## Schritt 4: Verwenden Sie einen modernen Browser: Mozilla Firefox oder Google Chrome
Wir brauchen einen modernen Browser, um die Pluto-Notebooks anzusehen. Firefox und Chrome funktionieren am besten.

"""

# ╔═╡ 326c34e8-f829-4e5f-9660-0fed523372b9
md"""
# Das zweite Mal: _Pluto starten & ein Notebook öffnen_
Wiederholen Sie die folgenden Schritte, wenn Sie an einem Projekt oder einer Hausaufgabe arbeiten möchten.
"""

# ╔═╡ 451bbd1d-b08a-4ee1-ac85-4a6866ad43b8
md"""
## Schritt 1: Pluto starten
"""

# ╔═╡ 66289406-8b97-4fb5-88f2-208e52519e79
md"""
Starten Sie die Julia-REPL, wie Sie es bei der Einrichtung getan haben. Geben Sie in der REPL ein:
```julia
julia> using Pluto

julia> Pluto.run()
```
"""

# ╔═╡ c9b30d5b-626a-4351-ae04-026ef00cd9b5
md"""
![image](https://user-images.githubusercontent.com/6933510/91441094-eb01d080-e86f-11ea-856f-e667fdd9b85c.png)

Das Terminal sagt uns, dass wir zu `http://localhost:1234/` (oder einer ähnlichen URL) gehen sollen. Wir öffnen Firefox oder Chrome und geben diese Adresse in die Adressleiste ein.
"""

# ╔═╡ baa1f5fb-283f-495d-aeff-78ad5085dbf0
md"""
![image](https://user-images.githubusercontent.com/6933510/91441391-6a8f9f80-e870-11ea-94d0-4ef91b4e2242.png)
"""

# ╔═╡ aefcdd49-fd5f-4802-ac35-bdd824744ac0
md"""
> Wenn Sie wissen wollen, wie ein _Pluto-Notebook_ aussieht, schauen Sie sich die **Beispiel-Notebooks** an. Die Beispiele 1, 2 und 6 können nützlich sein, um einige Grundlagen der Julia-Programmierung zu lernen. 
> 
> Wenn Sie die Geschichte von Pluto hören wollen, schauen Sie sich die[JuliaCon Präsentation](https://www.youtube.com/watch?v=IAF8DjrQSSk) an.
"""

# ╔═╡ 953b66f0-8c3a-4045-bc8e-ab3b7b8ec4ea
md"""
Wenn beim ersten Mal im Browser nichts passiert, schließen Sie Julia und versuchen Sie es erneut. Und bitte geben Sie mir Bescheid!
"""

# ╔═╡ e9da724b-05cc-4837-819c-600da72aac9a
md"""
## Schritt 2a: Öffnen eines Notebooks aus dem Internet

Dies ist das Hauptmenü - hier können Sie neue Notizbücher erstellen oder bestehende öffnen. Jede Seite des Skripts ist ein Pluto-Notebook. Oben rechts finde Sie die Schaltfläche "Dieses Notizbuch bearbeiten oder ausführen". Kopieren Sie den Link zum Notizbuch aus diesen Anweisungen und fügen Sie ihn bei 'open file from' ein. Drücken Sie die Eingabetaste, und wählen Sie im Bestätigungsfeld OK.
"""

# ╔═╡ b74509c5-768c-41d5-a622-8eee3bf53300
md"""
![image](https://user-images.githubusercontent.com/6933510/91441968-6b750100-e871-11ea-974e-3a6dfd80234a.png)
"""

# ╔═╡ fe51c422-6053-492f-950c-24e725df0008
md"""
**Als Erstes müssen wir das Notizbuch irgendwo auf unserem eigenen Computer speichern; siehe unten** 
"""

# ╔═╡ 1ad53084-bd03-45e0-9054-dc7c405951f4
md"""
## Schritt 2b: Öffnen eines bestehenden Notebooks
Wenn Sie Pluto zum zweiten Mal starten, werden Ihre letzten Notizbücher im Hauptmenü angezeigt. Sie können sie anklicken, um dort fortzufahren, wo Sie aufgehört haben.
"""

# ╔═╡ 36bdfa0d-6974-4ca3-9bc9-e2723f7217f0
md"""
Wenn Sie eine lokale Notizbuchdatei ausführen möchten, die Sie noch nicht geöffnet haben, müssen Sie den _vollständigen Pfad_ in das blaue Feld im Hauptmenü eingeben. Mehr zur Suche nach vollständigen Pfaden in Schritt 3.
"""

# ╔═╡ da1ca730-b3e3-4bac-983f-d17183255617
md"""
## Schritt 3: Ein Notebook abspeichern
Zunächst brauchen wir einen Ordner, in dem wir unsere Dateien speichern. Öffnen Sie Ihren Datei-Explorer und erstellen Sie einen. 
"""

# ╔═╡ cfc6b9dc-bae2-4d81-b674-f641618a436a
md"""
Als nächstes müssen wir den _absoluten Pfad_ dieses Ordners kennen. Hier steht, wie Sie das herausfinden unter [Windows](https://www.top-password.com/blog/copy-full-path-of-a-folder-file-in-windows/), [MacOS](https://www.josharcher.uk/code/find-path-to-folder-on-mac/) und [Ubuntu]().
"""

# ╔═╡ e0185c49-01f9-4327-9ec2-cbf2daf36735
md"""
Sie könnten zum Beispiel haben:

- `C:\\Users\\fonsi\\Documents\\18S191_assignments\\` unter Windows

- `/Users/fonsi/Documents/18S191_assignments/` unter MacOS

- `/home/fonsi/Documents/18S191_assignments/` unter Ubuntu

Da wir nun den absoluten Pfad kennen, gehen Sie zurück zu Ihrem Pluto-Notebook und klicken Sie oben auf der Seite auf _"Save Notebook ..."_. 
"""

# ╔═╡ 3f829caa-bcf9-44c2-a562-dc9cb88dd8b6
md"""
![image](https://user-images.githubusercontent.com/6933510/91444741-77fb5880-e875-11ea-8f6b-02c1c319e7f3.png)
"""

# ╔═╡ 1ca0b616-8f9a-4833-bfce-e9d1dcd4e9a3
md"""
Hier geben Sie den **neuen Pfad+Dateinamen für Ihr Notebook** ein:

![image](https://user-images.githubusercontent.com/6933510/91444565-366aad80-e875-11ea-8ed6-1265ded78f11.png)
"""

# ╔═╡ 623eff12-1c4b-4e1d-b29a-b6de931b2088
md"""
Klicken Sie auf _Choose_.
"""

# ╔═╡ 375f615e-9c4a-4bae-924b-fef2761c90e5
md"""
## Schritt 4: Ein Notebook teilen
"""

# ╔═╡ 928d3338-ccb9-4b12-ad17-c65af85bbef1
md"""
Nachdem Sie an Ihrem Notebook gearbeitet haben (Ihr Code wird automatisch gespeichert, wenn Sie ihn ausführen), finden Sie Ihre Notebook in dem Ordner, den wir in Schritt 3 erstellt haben. Diese Datei können Sie mit anderen teilen oder als Aufgabe im elearning-system einreichen.

"""

# ╔═╡ 53363b87-fd19-43d4-acc0-36ad6242217c
TableOfContents(title="Inhalt")

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.37"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.2"
manifest_format = "2.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

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

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

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

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "85b5da0fa43588c75bb1ff986493443f821c70b7"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.2.3"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "bf0a1121af131d9974241ba53f601211e9303a9e"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.37"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╟─f5450eab-0f9f-4b7f-9b80-992d3c553ba9
# ╟─309dbb64-37a3-4f8c-975c-d16e7ae1a8d1
# ╟─6ed88b23-3297-49b6-a485-efef79ab5d67
# ╟─bf0af2de-193d-4327-9bd3-91347934cac1
# ╟─bc92a414-7d91-43ed-9152-6a6ef24e3991
# ╟─0221cdc7-6433-4b53-a7bf-723dde46e778
# ╟─67298b17-feeb-43e4-a2fe-5d881f08480f
# ╟─f11b1419-7c7a-4b17-ba58-f5bc48a79371
# ╟─4f9511fd-8c6f-4f1f-9c48-6fee0c5bbf81
# ╟─0ea77d58-d77f-4995-9404-5ca7cd29c464
# ╟─d0b14351-175a-43f8-9360-899e2df19758
# ╟─d3e489c6-3e49-4aa3-9ffb-d425f22b554c
# ╟─125c3d4d-dc7c-40f1-9f26-578f6d8a1034
# ╟─326c34e8-f829-4e5f-9660-0fed523372b9
# ╟─451bbd1d-b08a-4ee1-ac85-4a6866ad43b8
# ╟─66289406-8b97-4fb5-88f2-208e52519e79
# ╟─c9b30d5b-626a-4351-ae04-026ef00cd9b5
# ╟─baa1f5fb-283f-495d-aeff-78ad5085dbf0
# ╟─aefcdd49-fd5f-4802-ac35-bdd824744ac0
# ╟─953b66f0-8c3a-4045-bc8e-ab3b7b8ec4ea
# ╟─e9da724b-05cc-4837-819c-600da72aac9a
# ╟─b74509c5-768c-41d5-a622-8eee3bf53300
# ╟─fe51c422-6053-492f-950c-24e725df0008
# ╟─1ad53084-bd03-45e0-9054-dc7c405951f4
# ╟─36bdfa0d-6974-4ca3-9bc9-e2723f7217f0
# ╟─da1ca730-b3e3-4bac-983f-d17183255617
# ╟─cfc6b9dc-bae2-4d81-b674-f641618a436a
# ╟─e0185c49-01f9-4327-9ec2-cbf2daf36735
# ╟─3f829caa-bcf9-44c2-a562-dc9cb88dd8b6
# ╟─1ca0b616-8f9a-4833-bfce-e9d1dcd4e9a3
# ╟─623eff12-1c4b-4e1d-b29a-b6de931b2088
# ╟─375f615e-9c4a-4bae-924b-fef2761c90e5
# ╟─928d3338-ccb9-4b12-ad17-c65af85bbef1
# ╟─4869c4e2-99ab-48a1-95fe-3ef1218286fb
# ╟─53363b87-fd19-43d4-acc0-36ad6242217c
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
