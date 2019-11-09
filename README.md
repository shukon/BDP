# BDP goes digital

Hi!
In der letzten Freizeitenevaluation kam von Teamer\*innen-Seite der Wunsch nach einer BDP-App auf.  
Seither ist viel geschehen und auch der Vorstand und das Büro haben ihre Vorstellungen mit in den Topf geworfen.  
Es hat sich jetzt sowas wie ein BDP-Cyber-AK ;) gegründet, der die Wünsche geordnet, zusammengelegt und auf technische Umsetzbarkeit untersucht hat. Wir sind aktuell zu drei-ein-halbt: Thorsten, Stefan, Shuki, Rene, Sanja und Marian.  

Zur Zeit können wir ziemlich gut noch Hilfe jeder Art gebrauchen - Programmierung, Design, Konzept und auch Wünsche. Jede Resonanz hilft - wir wollen die App nicht für, sondern mit euch entwickeln!  

Wenn du das grade liest, hast du unser GitHub-Repository schon gefunden. Hier entsteht der Quelltext für das Projekt - kollaborativ, offen, frei! GitHub ist eine Plattform, die den Quelltext für uns speichert. Das hat einige Vorteile:
- falls uns mal das Laptop verlustig geht, sind die Daten alle noch da!
- GitHub nutzt *versioning* - das bedeutet, wir können auf beliebige vorherige Versionen der App zurückgreifen. Wenn also durch ein Update schwere Fehler entstehen, dann lässt sich das leicht wieder rückgängig machen.
- git wird für viele Software-Projekte genutzt - es ergibt sich also ein gewisser professioneller Standard.

Mehr Infos zu GitHub: https://git-scm.com/book/de/v1/Los-geht%E2%80%99s-Git-Grundlagen oder https://rogerdudler.github.io/git-guide/index.de.html.

## Fahrplan:
- SDK: Flutter
- MatterMost aufsetzen
- Nextcloud aufsetzen
- DokuWiki aufsetzen
- Alles zusammenmmixen und in eure Smartphones schütten

## Links:
- ~~Etherpad: https://pad.riseup.net/p/bdpgoesdigital-keep~~ nicht aktiv gewartet, schreibt uns lieber eine Mail.
- Github: https://github.com/shukon/BDP/
- Bisheriger Intern-Bereich: https://www.bawue.bdp.org/intern/
- Freizeiten: https://www.ak-freizeiten.de/freizeiten/jugendfreizeiten/

## Wünsche an den AK:

### Funktionen:

- Live-Chatfunktion
- Forumsfunktion
- Datenbanken/Lexika: Freizeitenberichte, Essenlisten etc., Anleitungen, Kochbuch, ...
- Benutzerrechteverwaltung
- Freizeitenberichte
- Galerie
- Verteilung von Infos
- Eckbrief ("Push")

### Passive Ansprüche:

- Nutzbar ohne Smartphone
- getrennter Bereich nur für Teamer
- DSGVO-konform
- offline nutzbar
- Registrier-/Einladefunktion für Teilis

_____________________________________________________________________________________________________________________________

## Funktionen-Teilbereiche

- Chat
- Freizeiten, Seminare und Veranstaltungen
- Newsfeed
- Wiki

_________________________________________________________________________________________________________

Die App hat zwei (drei?) verschiedene Layouts/Funktionalitäten: eine für Teamer\*innen, eine für Teilis(, eine für Büro?). Kursive Bereiche sind nur für Teamer\*innen verfügbar  
Die App hat einen Login.  
Die App muss auf Android, iOS und im Browser laufen --> Web App einfachste Lösung? Flutter? 

```
 _____________________               _____________________
/          |          \             /              |_lo___\    --> lo = Logout
|          |          |             |                     |
|          | (Meine)  |             |                     |
|  Chat    | Seminare |             |                     |
|   (1)    |Freizeiten|             |     Schwarzes       |
|          |   (2)    |             |        Brett        |
|          |          |             |                     |
|__________|__________|  Neue Idee  |                     |
|          |          |             |                     |  
| Newsfeed |   Wiki   |             |                     |  
| (3)      |    (4)   |             |                     |  
|          |          |             |_____________________|  
|          |          |             |    |N|      | Kalen-|   --> N = Neue Nachricht
|          |          |             | Chat | Wiki |  der  |  
\__________|__________/             \______|______|_______/ 
```
Für Teilis müsste das Layout anders aussehen, da für sie nur der Chat und der Galerieordner ihnrer Freizeit relevant ist.

### (1) Chat
Chatroom mit MatterMost mit automatischen Gruppen für alles, für das ich angemeldet bin, z.B:  
    - Gruppe mit Teilis und Teamis einer Freizeit  
    - Gruppenchat für Team zur Planung  

### (2) Seminare/Freizeiten
Tabs: (wie bei flixbus)  

|Freizeiten   |Seminare   |Sonstiges  |  
_______Alle___________Meine____________    # Meine = die wo ich angemeldet bin  

Hier werden auch Einladungen zu Seminaren untergebracht  

Eventuell gibt es hier auch eine Kalenderansicht  

Über "Meine Freizeiten" kann man auch in den Chatroom zu der entsprechenden Freizeit gelangen  

### (2 Neu) Kalender
Im Kalender sollten alle BDP-Termine stehen. Termine zu denen man sich angemeldet hat werden herforgehoben. 
Der Kalender ist an die Verschieden BdP-Rollen (Teamer, Teili, gVo, eVo und Büro) angepasst

Im Kalender könnten weitere Dokumente wie Einladungen verlinkt sein.

### (3) Newsfeed / Eckbrief / Zeug
Newsfeed evtl auch mit Tabs, unterteilen in  

- allgemeine News vom BDP  
- Infos für Teamer*innen  


Die Grundidee hier ist, den Eckbrief attraktiv zu ersetzen.  

### (4) Wiki / Datenbank
Nur für Teamende!  
Hier gibt es eine ordentliche Datenbank für  

- Spielekartei
- Kochbuch
- Anleitungen (Zelte, Gaskocher,...)

## Sachen die wir (vielleicht) einkaufen können:  
- User Management (Login etc.)
- Chatfunktion
- Wiki
- Newsfeed?
- Kalender
- Galerie <-- niedrige Priorität
