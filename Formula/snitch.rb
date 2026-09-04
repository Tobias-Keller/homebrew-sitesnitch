# Homebrew-Formel für die CLI. Quelle der Wahrheit ist diese Datei; das
# öffentliche Tap-Repository bekommt sie beim Release als Kopie
# (Scripts/aktualisiere-formel.sh). Zwei gepflegte Fassungen liefen sonst
# auseinander, sobald ein Release einmal schnell gehen muss.
#
# Warum überhaupt Homebrew: Sparkle aktualisiert Bundles, keine nackten
# Binaries, und `brew upgrade` ist für diese Zielgruppe der erwartete Weg
# (UPDATES-SPARKLE.md §8, CONCEPT.md §8.3).
class Snitch < Formula
  desc "Website-Crawler für technische SEO-Audits und Relaunch-Redirect-Maps"
  homepage "https://sitesnitch.de"
  url "https://sitesnitch.de/download/snitch-1.0.1.tar.gz"
  sha256 "f39332ba878317283a1925fd3ae0c5f4fc8ccc316713ca34ce518fdb20fdb3f0"
  # Kein `version`: Homebrew liest sie aus dem Dateinamen der URL, und eine
  # zweite Angabe daneben ist eine zweite Stelle, die beim nächsten Release
  # vergessen werden kann (`brew audit` beanstandet sie ausdrücklich).
  # Kein Open-Source-Lizenztext: SiteSnitch ist proprietär, die CLI wird als
  # signiertes Universal-Binary ausgeliefert.
  license :cannot_represent

  # Dasselbe Deployment-Target wie die App (macOS 14). Ohne diese Zeile
  # installiert brew auf älteren Systemen ein Binary, das beim Start mit einer
  # dyld-Meldung abbricht, die niemandem sagt, was los ist.
  depends_on macos: :sonoma

  def install
    # Binary und Ressourcen-Bundle gehören ins selbe Verzeichnis: Der von
    # SwiftPM erzeugte `Bundle.module`-Zugriff sucht neben der ausführbaren
    # Datei. Heute fasst die CLI das Vokabular nie an — kein Pfad setzt
    # `validatesStructuredData` (gemessen 04.09.2026) —, aber sobald einer es
    # tut, ist der Fehler ein `fatalError` auf dem Kundenrechner.
    libexec.install "snitch", "SiteSnitchKit_SnitchSchema.bundle"

    # **exec-Skript und nicht `bin.install_symlink`.** Gemessen am 04.09.2026:
    # Startet man ein Binary über einen Symlink in `bin/`, meldet
    # `Bundle.main.bundleURL` das Verzeichnis des Symlinks — macOS löst ihn
    # nicht auf. Die Ressourcensuche liefe dann in `bin/`, wo das Bundle nicht
    # liegt. Das exec-Skript startet das echte Binary in `libexec/`, und dort
    # stimmt der Pfad.
    bin.write_exec_script libexec/"snitch"
  end

  test do
    # Die eigentliche Frage einer Formel: Ist das installierte Binary das, was
    # die URL versprochen hat? `version` kommt aus dem Dateinamen der URL, die
    # Ausgabe aus dem Binary — stimmen sie überein, kann kein Tarball unter
    # falschem Namen ausgeliefert worden sein.
    assert_equal "snitch #{version}", shell_output("#{bin}/snitch --version").strip

    # `snitch` ohne Befehl ist ein Bedienfehler: Ausgabe auf **stderr**, Exit 1.
    # Beides gehört ins Kommando — `shell_output` fängt nur stdout, und ohne
    # das `2>&1` verglich der Test gegen eine leere Zeichenkette und war
    # trotzdem rot, ohne zu sagen warum (gemessen 04.09.2026 mit `brew test`).
    assert_match "snitch — SiteSnitch-CLI", shell_output("#{bin}/snitch 2>&1", 1)

    # Und ein echter Unterbefehl, damit der Test nicht nur die Begrüssung sieht.
    # `--help` geht auf stdout und endet mit 0 — hier also ohne Umleitung.
    assert_match "Der Relaunch-Vergleich", shell_output("#{bin}/snitch diff --help")
  end
end
