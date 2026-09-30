// palette.typ
//
//   #import "palette.typ": palette
//   #text(fill: palette.teal)[...]

#let palette = (
  // anchor purple (opens every row in the SVG)
  purple: rgb("#71618D"),
  purple-light: rgb("#A594C3"),
  lilac: rgb("#DCD4E6"),
  mauve: rgb("#AFA8BA"),
  // warm row
  orange: rgb("#FF9B7D"),   // the sidebar orange (template.svg rgb(255,155,125))
  peach: rgb("#FFCEB1"),
  pink: rgb("#C76E96"),
  yellow: rgb("#F9F871"),
  cream: rgb("#FEFEDF"),
  // earthy accents
  rust: rgb("#925A4F"),
  clay: rgb("#CA8D80"),
  taupe: rgb("#BEA6A1"),
  // cool row
  sage: rgb("#4D8075"),
  teal: rgb("#00C9A4"),
  mint: rgb("#53FBDD"),
  deep-teal: rgb("#007897"),
  blue: rgb("#5594CB"),
  cyan: rgb("#00CAE9"),
  // neutrals row
  ink: rgb("#030519"),
  gray-dark: rgb("#6C6575"),
  gray: rgb("#8F8899"),
  gray-darker: rgb("#4A4453"),
)
