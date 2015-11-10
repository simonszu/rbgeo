rbgeo
=====

Ein Statistikgenerator für Geocacher, ähnlich dem mittlerweile mehr oder weniger eingeschlafenen [geolog](http://geolog.sourceforge.net/geolog_de.html)

Nutzung
-------
1. Installiere dir Ruby. Wie das bei deinem Betriebssystem geht, bleibt dir (noch) selbst überlassen. Du benötigst mindestens Ruby 2.1.5.
2. Installiere dir das Gem `bundler`: `gem install bundler` 
3. Klone dieses Repository. `git clone https://github.com/simonszu/rbgeo`. Windowsnutzer nutzen hierfür bitte die [Github for Windows](http://windows.github.com/) Applikation.
4. Benenne die `config.yaml.example` in `config.yaml` um. Fülle die Werte aus.
  - `username`: Dein Username auf geocaching.com
  - `password`: Dein Passwort auf geocaching.com
  - `path`: Der Pfad, wo die generierten Statistikseiten gespeichert werden sollen
5. Installiere alle Abhängigkeiten automatisch: `bundle install`
6. Führe das Script aus: `ruby rbgeo.rb`. Der ausführende User muss Schreibrechte im rbgeo-Verzeichnis, sowie im `path` haben.

Mitmachen
---------
Ich freue mich über jegliche Beteiligung. Einfach forken, und Push-Requests schicken. Eine Diskussion über das Script erfolgt momentan im [Geolog-Forum](http://forum.geoclub.de/viewtopic.php?f=103&t=73627)

Lizenz
------
GPLv2
