# Vendored fonts

Iosevka SS07, SIL OFL 1.1 (`OFL.txt`), from <https://github.com/be5invis/Iosevka>. To
fetch (pinned to v34.9.0):

```sh
cd ./fonts
curl -fLO https://github.com/be5invis/Iosevka/releases/download/v34.9.0/SuperTTC-IosevkaSS07-34.9.0.zip
unzip -jo SuperTTC-IosevkaSS07-34.9.0.zip IosevkaSS07.ttc
rm SuperTTC-IosevkaSS07-34.9.0.zip
```

This vendors the single-file TrueType collection (`IosevkaSS07.ttc`, the same file
Homebrew's `font-iosevka-ss07` cask installs) covering all weights and italics, plus the
Term and Fixed spacings as extra families. Typst reads .ttc collections via its font
database.

Compile with this directory on the font path: `make` (repo root) or
`typst compile --font-path fonts main.typ`.
