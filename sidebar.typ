// sidebar.typ
//
// The SVG viewBox is 4800 x 2700 units, i.e. a 16:9 slide at 300 units per inch.
// The sidebar graphic spans x = 0 .. 210.585, which is exactly 0.70" of the 16" wide
// page, so the deck uses a 16in x 9in page and the art is placed as a full-page
// background at 100%.
//
// Usage:
//   #import "@preview/touying:0.8.0": *
//   #import "sidebar.typ": *
//   #show: sidebar-theme.with(config-info(title: [...], author: [...]))
//
// Requires typst >= 0.15 (touying 0.8.0).

#import "@preview/touying:0.8.0": *
#import "palette.typ": palette

// Width of the sidebar art on a 16in-wide page (210.585 / 4800 * 16in).
#let sidebar-width = 16in * (210.585 / 4800)

/// Regular slide: slide title (+ optional logo) and an orange rule in the header
#let slide(
  title: auto,
  config: (:),
  repeat: auto,
  setting: body => body,
  composer: auto,
  ..bodies,
) = touying-slide-wrapper(self => {
  let header(self) = {
    set align(top)
    set text(fill: self.colors.neutral-darkest)
    pad(
      top: 0.05in,
      {
        v(0.35in)
        components.left-and-right(
          block(width: 100%, {
            // slide title (explicit `title:` argument, else the current heading)
            set text(size: 1.6em, weight: "bold", tracking: 0.02em)
            utils.fit-to-width(
              grow: false,
              100%,
              if title != auto {
                utils.call-or-display(self, title)
              } else {
                utils.display-current-heading(depth: self.slide-level)
              },
            )
          }),
          utils.call-or-display(self, self.store.header-right),
        )
        v(0.5em, weak: true)
        line(length: 100%, stroke: 1.5pt + self.colors.primary)
      },
    )
  }
  let footer(self) = {
    set align(bottom)
    set text(size: 0.7em, fill: self.colors.neutral-light)
    pad(
      bottom: 0.15in,
      components.left-and-right(
        utils.call-or-display(self, self.store.footer),
        context utils.slide-counter.display()
          + " / "
          + utils.last-slide-number,
      ),
    )
  }
  let self = utils.merge-dicts(
    self,
    config-page(header: header, footer: footer),
  )
  let new-setting = body => {
    set text(fill: self.colors.neutral-darkest)
    show: setting
    body
  }
  touying-slide(
    self: self,
    config: config,
    repeat: repeat,
    setting: new-setting,
    composer: composer,
    ..bodies,
  )
})


/// Title slide. Fill the details via `config-info(..)` or pass them here:
///   #title-slide(subtitle: [..], author: [..], date: [..])
#let title-slide(config: (:), ..args) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config-common(freeze-slide-counter: true),
    config,
  )
  let info = self.info + args.named()
  // invisible heading so the title is discoverable in the notes panel
  if info.title != none {
    place(hide(heading(
      level: self.slide-level,
      info.title,
      bookmarked: false,
      outlined: false,
      numbering: none,
    )))
  }
  let body = {
    set align(horizon)
    block(width: 100%, {
      set text(size: 2.1em, weight: "bold", fill: self.colors.neutral-darkest)
      block(info.title)
      if info.subtitle != none {
        v(0.6em)
        set text(size: 1em, fill: self.colors.neutral-light)
        block(info.subtitle)
      }
      v(1.3em)
      // orange bar echoing the sidebar
      block(width: 3in, height: 4pt, fill: self.colors.primary, spacing: 0pt)
      v(1.3em)
      set text(size: 0.75em, fill: self.colors.neutral-darkest)
      if info.author != none {
        block(spacing: 0.6em, info.author)
      }
      if info.date != none {
        block(spacing: 0.6em, utils.display-info-date(self))
      }
      if info.institution != none {
        block(spacing: 0.6em, info.institution)
      }
      if info.contact != none {
        block(spacing: 0.6em, info.contact)
      }
    })
  }
  touying-slide(self: self, setting: align.with(left + horizon), body)
})


/// Section divider, shown automatically for every level-1 heading.
#let new-section-slide(config: (:), body) = touying-slide-wrapper(self => {
  let setting(body) = {
    set align(horizon)
    block(width: 100%, {
      set text(size: 1.9em, weight: "bold", fill: self.colors.neutral-darkest)
      utils.display-current-heading(level: 1)
      v(0.8em)
      block(width: 2.2in, height: 4pt, fill: self.colors.primary, spacing: 0pt)
      if body != none {
        v(0.8em)
        set text(size: 0.8em, fill: self.colors.neutral-light)
        body
      }
    })
  }
  touying-slide(self: self, config: config, setting: setting, body)
})


/// Big centered statement. Keeps the sidebar background.
#let focus-slide(
  config: (:),
  alignment: horizon + center,
  body,
) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config,
    config-common(freeze-slide-counter: true),
  )
  touying-slide(
    self: self,
    config: config,
    setting: it => align(
      alignment,
      text(fill: self.colors.primary-dark, size: 1.6em, weight: "bold", it),
    ),
    body,
  )
})


/// Table of contents (sections only).
#let outline-slide(config: (:), title: [Outline], depth: 1) = {
  slide(config: config, title: title)[
    #set text(size: 0.8em)
    #outline(title: none, depth: depth)
  ]
}


/// Speaker-note panel styled to match (orange header strip).
#let notes(self: none, ..args) = touying-notes(
  self: self,
  header: self => pad(
    x: 24pt,
    y: 12pt,
    text(fill: self.colors.neutral-lightest, utils.display-current-heading(depth: self.slide-level)),
  ),
  header-fill: self.colors.primary,
  fill: self.colors.neutral-lightest,
  ..args,
)


/// Register the theme. Example:
///
/// ```typst
/// #show: sidebar-theme.with(
///   config-info(
///     title: [Deck title],
///     author: [You],
///     date: datetime.today(),
///   ),
/// )
/// ```
///
/// - footer (content, function, auto): bottom-left of every slide.
///   `auto` shows the current section title (nothing before the first
///   `= heading`).
/// - header-right (content, function): top-right of every slide.
///   Default is `self.info.logo`.
/// - margin (dictionary): page margins; the left margin keeps content
///   clear of the 0.7" sidebar.
/// - background (content, str, auto): full-page background. `auto` uses
///   `template.svg` next to this file; a string is an image path (relative
///   to this file); pass `none` for a plain white deck.
#let sidebar-theme(
  footer: auto,
  header-right: self => self.info.logo,
  margin: (left: 1.25in, right: 0.85in, top: 1.6in, bottom: 0.95in),
  background: auto,
  ..args,
  body,
) = {
  set text(size: 26pt)

  let background = {
    if background == auto {
      image("template.svg", width: 100%)
    } else if type(background) == str {
      image(background, width: 100%)
    } else {
      background
    }
  }
  let footer = if footer == auto {
    // current section title (empty before the first `= heading`)
    self => utils.display-current-heading(level: 1)
  } else {
    footer
  }

  show: touying-slides.with(
    // 16in x 9in so the SVG lands at its designed scale (sidebar = 0.7").
    // Explicit width/height override touying's default 10in "presentation-16-9".
    config-page(
      width: 16in,
      height: 9in,
      margin: margin,
      fill: white,
      background: background,
    ),
    config-common(
      slide-fn: slide,
      new-section-slide-fn: new-section-slide,
      notes-fn: notes,
      // keep header/footer inside the margins so they don't run over the sidebar
      zero-margin-header: false,
      zero-margin-footer: false,
      // `*bold*` stays ink-colored text; use `#alert[..]` for orange emphasis
      show-strong-with-alert: false,
    ),
    config-methods(
      alert: (self: none, it) => text(
        fill: self.colors.primary-dark,
        weight: "semibold",
        it,
      ),
    ),
    config-colors(
      // roles mapped from the brand palette (palette.typ)
      primary: palette.orange,          // sidebar / accents
      primary-dark: rgb("#C6552E"),     // readable darkened orange for text
                                        // (derived; not in the SVG palette)
      secondary: palette.purple,        // the palette's anchor color
      neutral-light: palette.gray-dark, // meta text (footer, …)
      neutral-lightest: rgb("#FFFFFF"),
      neutral-darkest: palette.ink,     // body text
    ),
    config-store(
      footer: footer,
      header-right: header-right,
    ),
    ..args,
  )

  body
}
