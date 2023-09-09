### A Pluto.jl notebook ###
# v0.19.26

using Markdown
using InteractiveUtils

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

# ╔═╡ 4869c4e2-99ab-48a1-95fe-3ef1218286fb
using PlutoUI

# ╔═╡ 53363b87-fd19-43d4-acc0-36ad6242217c
TableOfContents(title="Inhalt")

# ╔═╡ Cell order:
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
