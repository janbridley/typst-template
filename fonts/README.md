# Fonts

Iosevka SS07, SIL OFL 1.1 (`OFL.txt`), from <https://github.com/be5invis/Iosevka>. Run
from the repo root (pinned to v34.9.0 — bump for upgrades):

```sh
curl -fL -o /tmp/iosevka.zip https://github.com/be5invis/Iosevka/releases/download/v34.9.0/SuperTTC-IosevkaSS07-34.9.0.zip
unzip -jo /tmp/iosevka.zip IosevkaSS07.ttc -d fonts
rm /tmp/iosevka.zip
```

`IosevkaSS07.ttc` is a single TrueType collection covering all weights and italics of
SS07 (plus the Term/Fixed spacings as extra families), and is gitignored: re-run the
block after cloning. Typst reads .ttc collections via its font database.

Compile with this directory on the font path:
`typst compile --font-path fonts main.typ`.
