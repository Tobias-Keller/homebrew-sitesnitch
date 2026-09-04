# homebrew-sitesnitch

Homebrew-Tap für **`snitch`**, die Kommandozeilenfassung von
[SiteSnitch](https://sitesnitch.de) — dem nativen Website-Crawler für macOS.

```bash
brew install tobias-keller/sitesnitch/snitch
```

`snitch` crawlt, vergleicht zwei Stände und erzeugt Redirect-Maps, kopflos und
für die CI gedacht. Ohne Lizenz sind Crawls auf 300 URLs begrenzt; alles andere
steht offen.

## Was hier liegt

Nur die Formel. Der Quelltext von SiteSnitch ist nicht öffentlich; ausgeliefert
wird ein signiertes, notarisiertes Universal-Binary (Apple Silicon und Intel,
macOS 14 oder neuer) von `sitesnitch.de`.

Die Formel wird beim Release aus dem Programm-Repo hierher kopiert
(`Scripts/aktualisiere-formel.sh`) — Änderungen von Hand gehen beim nächsten
Release verloren.

## Die App

`snitch` und die App teilen sich denselben Kern. Die App gibt es unter
[sitesnitch.de](https://sitesnitch.de); sie aktualisiert sich über Sparkle,
die CLI über `brew upgrade`.
