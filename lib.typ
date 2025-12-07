#import "@preview/theorion:0.4.0": make-frame, showybox, use-state

// Workaround for the lack of an `std` scope.
#let std-bibliography = bibliography
#let std-smallcaps = smallcaps
#let std-upper = upper

// Overwrite the default `smallcaps` and `upper` functions with increased spacing between
// characters. Default tracking is 0pt.
#let smallcaps(body) = std-smallcaps(text(tracking: 0.6pt, body))
#let upper(body) = std-upper(text(tracking: 0.6pt, body))

// Colors used across the template.
#let stroke-color = luma(200)
#let fill-color = luma(250)

// This function gets your whole document as its `body`.
#let ilm(
  // The title for your work.
  title: [Your Title],
  // Author's name.
  author: "Author",
  // The paper size to use.
  paper-size: "a4",
  // Date that will be displayed on cover page.
  // The value needs to be of the 'datetime' type.
  // More info: https://typst.app/docs/reference/foundations/datetime/
  // Example: datetime(year: 2024, month: 03, day: 17)
  date: none,
  // Format in which the date will be displayed on cover page.
  // More info: https://typst.app/docs/reference/foundations/datetime/#format
  // The default format will display date as: MMMM DD, YYYY
  date-format: "[month repr:long] [day padding:zero], [year repr:full]",
  // An abstract for your work. Can be omitted if you don't have one.
  abstract: none,
  // An image to show between title and abstract
  imagePath: none,
  // The contents for the preface page. This will be displayed after the cover page. Can
  // be omitted if you don't have one.
  preface: none,
  appendix: (
    enabled: false,
    title: "",
    heading-numbering-format: "",
    body: none,
  ),
  // The result of a call to the `bibliography` function or `none`.
  // Example: bibliography("refs.bib")
  // More info: https://typst.app/docs/reference/model/bibliography/
  bibliography: none,
  // Whether to start a chapter on a new page.
  chapter-pagebreak: true,
  // Whether to display a maroon circle next to external links.
  external-link-circle: true,
  // The content of your work.
  body,
) = {
  // Set the document's metadata.
  set document(title: title, author: author)

  // Set the body font.
  set text(size: 12pt) // default is 11pt

  // Set raw text font.
  // Default is Fira Mono at 8.8pt
  // show raw: set text(font: ("Iosevka", "Fira Mono"), size: 9pt)

  // Configure page size and margins.
  set page(
    paper: paper-size,
    margin: (bottom: 1.75cm, top: 2.25cm),
  )

  // Cover page.
  page(
    align(
      center + horizon,
      block(width: 100%)[
        #let v-space = v(2em, weak: true)

        #text(3em)[*#title*]
        #v-space

        #if image != none {
          align(center)[
            #image(imagePath, width: 65%)
          ]
        }

        #text(1.6em, author)
        #if abstract != none {
          v-space
          block(width: 100%)[
            // Default leading is 0.65em.
            #par(leading: 0.78em, justify: true, linebreaks: "optimized", abstract)
          ]
        }

        #if date != none {
          v-space
          text(date.display(date-format))
        }
      ],
    ),
  )

  // Configure paragraph properties.
  // Default leading is 0.65em.
  // Default spacing is 1.2em.
  set par(leading: 0.7em, spacing: 1.35em, justify: true, linebreaks: "optimized")
  set list(indent: 2em, body-indent: 0.7em)
  set enum(indent: 2em, body-indent: 0.7em)


  // Add vertical space after headings.
  show heading: it => {
    it
    v(2%, weak: true)
  }
  // Do not hyphenate headings.
  show heading: set text(hyphenate: false)

  // Show a small maroon circle next to external links.
  show link: it => {
    it
    // Workaround for ctheorems package so that its labels keep the default link styling.
    if external-link-circle and type(it.dest) != label {
      sym.wj
      h(1.6pt)
      sym.wj
      super(box(height: 3.8pt, circle(radius: 1.2pt, stroke: 0.7pt + rgb("#993333"))))
    }
  }

  // Display preface as the second page.
  if preface != none {
    page(preface)
  }

  // Configure page numbering and footer.
  set page(
    footer: context {
      // Get current page number.
      let i = counter(page).at(here()).first()

      // Align right for even pages and left for odd.
      let is-odd = calc.odd(i)
      let aln = if is-odd {
        right
      } else {
        left
      }

      // Are we on a page that starts a chapter?
      let target = heading.where(level: 1)
      if query(target).any(it => it.location().page() == i) {
        return align(aln)[#i]
      }

      // Find the chapter of the section we are currently in.
      let before = query(target.before(here()))
      if before.len() > 0 {
        let current = before.last()
        let gap = 1.75em
        let chapter = upper(text(size: 0.68em, current.body))
        if current.numbering != none {
          if is-odd {
            align(aln)[#chapter #h(gap) #i]
          } else {
            align(aln)[#i #h(gap) #chapter]
          }
        }
      }
    },
  )

  // Configure equation numbering.
  set math.equation(numbering: "(1)")

  // Display inline code in a small box that retains the correct baseline.
  show raw.where(block: false): box.with(
    fill: fill-color.darken(2%),
    inset: (x: 3pt, y: 0pt),
    outset: (y: 3pt),
    radius: 2pt,
  )

  // Display block code with padding.
  show raw.where(block: true): block.with(inset: (x: 5pt))

  // Break large tables across pages.
  show figure.where(kind: table): set block(breakable: true)
  set table(
    // Increase the table cell's padding
    inset: 7pt, // default is 5pt
    stroke: (0.5pt + stroke-color),
  )
  // Use smallcaps for table header row.
  show table.cell.where(y: 0): smallcaps

  // Wrap `body` in curly braces so that it has its own context. This way show/set rules
  // will only apply to body.
  {
    // Configure heading numbering.
    set heading(numbering: "1.")

    // Start chapters on a new page.
    show heading.where(level: 1): it => {
      if chapter-pagebreak {
        pagebreak(weak: true)
      }
      it
    }
    body
  }
}

// This function formats its `body` (content) into a blockquote.
#let blockquote(body) = {
  block(
    width: 100%,
    fill: fill-color,
    inset: 2em,
    stroke: (y: 0.5pt + stroke-color),
    body,
  )
}


#import "@preview/theorion:0.4.0": language-aware-start, theorion-i18n, theorion-i18n-map
#let example-box(
  fill: rgb("#acb2bf"),
  ..args,
  title,
  body,
) = context {
  let title-i18n = theorion-i18n(theorion-i18n-map.at("example"))
  // Main rendering
  block(
    stroke: language-aware-start(.25em + fill),
    inset: language-aware-start(1em) + (top: .5em, bottom: .75em),
    width: 100%,
    ..args,
    {
      block(sticky: true, text(
        fill: fill,
        weight: "semibold",
        title-i18n + ": " + title,
      ))
      body
    },
  )
}

#let enum_twocols(body) = context {
  let items = body
    .children
    .filter(x => x.func() == enum.item)
    .enumerate()
    .map(((i, x)) => [#numbering(enum.numbering, i + 1) #x.body])
  set raw(lang: "r")
  grid(columns: 2, column-gutter: 1.65em, row-gutter: par.leading, ..items)
}

#let list_twocols(body) = context {
  let items = body.children.filter(x => x.func() == list.item).map(x => [#symbol("•") #x.body]) // add bullet + small horizontal space
  grid(
    columns: 2,
    column-gutter: 2em,
    row-gutter: par.leading,
    ..items
  )
}

#let fancy-box(
  get-border-color: loc => orange.darken(0%),
  get-body-color: loc => orange.lighten(95%),
  get-symbol: loc => sym.suit.heart.stroked,
  prefix: none,
  title: "",
  full-title: auto,
  breakable: true,
  html-width: 720pt,
  ..args,
  body,
) = context {
  // Main rendering
  let rendered = showybox(
    frame: (
      thickness: .05em,
      radius: .3em,
      inset: (x: 1.2em, top: if full-title != "" { .7em } else { 1.2em }, bottom: 1.2em),
      border-color: get-border-color(here()),
      title-color: get-border-color(here()),
      body-color: get-body-color(here()),
      title-inset: (x: 1em, y: .5em),
    ),
    title-style: (
      boxed-style: (
        anchor: (x: start, y: horizon),
        radius: 0em,
      ),
      color: white,
      weight: "semibold",
    ),
    breakable: breakable,
    title: {
      if full-title == auto {
        if prefix != none {
          [#prefix (#title)]
        } else {
          title
        }
      } else {
        full-title
      }
    },
    ..args,
    {
      body
      if get-symbol(here()) != none {
        place(end + bottom, dy: .8em, dx: .9em, text(size: .6em, fill: get-border-color(here()), get-symbol(here())))
      }
    },
  )
  if "html" in dictionary(std) and target() == "html" {
    html.elem("div", attrs: (style: "margin-bottom: .5em;"), html.frame(block(width: html-width, rendered)))
  } else {
    rendered
  }
}

/// Register global colors.
#let (get-primary-border-color, set-primary-border-color) = use-state("fancy-primary-border-color", green.darken(30%))
#let (get-primary-body-color, set-primary-body-color) = use-state("fancy-primary-body-color", green.lighten(95%))
#let (get-secondary-border-color, set-secondary-border-color) = use-state(
  "fancy-secondary-border-color",
  orange.darken(
    0%,
  ),
)
#let (get-secondary-body-color, set-secondary-body-color) = use-state("fancy-secondary-body-color", orange.lighten(95%))
#let (get-tertiary-border-color, set-tertiary-border-color) = use-state("fancy-tertiary-border-color", blue.darken(30%))
#let (get-tertiary-body-color, set-tertiary-body-color) = use-state("fancy-tertiary-body-color", blue.lighten(95%))

/// Register global symbols.
#let (get-primary-symbol, set-primary-symbol) = use-state(
  "fancy-primary-symbol",
  sym.suit.club.filled,
)
#let (get-secondary-symbol, set-secondary-symbol) = use-state(
  "fancy-secondary-symbol",
  sym.suit.heart.stroked,
)
#let (get-tertiary-symbol, set-tertiary-symbol) = use-state(
  "fancy-tertiary-symbol",
  sym.suit.spade.filled,
)

#let (theorem-counter, theorem-box, theorem, show-theorem) = make-frame(
  "theorem",
  theorion-i18n-map.at("theorem"),
  inherited-levels: 2,
  render: fancy-box.with(
    get-border-color: get-secondary-border-color,
    get-body-color: get-secondary-body-color,
    get-symbol: get-secondary-symbol,
  ),
)

#let (lemma-counter, lemma-box, lemma, show-lemma) = make-frame(
  "lemma",
  theorion-i18n-map.at("lemma"),
  inherited-levels: 2, // Add this to match theorem's section numbering
  render: fancy-box.with(
    get-border-color: get-secondary-border-color,
    get-body-color: get-secondary-body-color,
    get-symbol: get-secondary-symbol,
  ),
)

#let (corollary-counter, corollary-box, corollary, show-corollary) = make-frame(
  "corollary",
  theorion-i18n-map.at("corollary"),
  inherited-from: theorem-counter,
  render: fancy-box.with(
    get-border-color: get-secondary-border-color,
    get-symbol: get-secondary-symbol,
    get-body-color: get-secondary-body-color,
  ),
)

#let (axiom-counter, axiom-box, axiom, show-axiom) = make-frame(
  "axiom",
  theorion-i18n-map.at("axiom"),
  inherited-levels: 1,
  render: fancy-box.with(
    get-border-color: get-secondary-border-color,
    get-body-color: get-secondary-body-color,
    get-symbol: get-secondary-symbol,
  ),
)

#let (postulate-counter, postulate-box, postulate, show-postulate) = make-frame(
  "postulate",
  theorion-i18n-map.at("postulate"),
  inherited-levels: 2,
  render: fancy-box.with(
    get-border-color: get-secondary-border-color,
    get-body-color: get-secondary-body-color,
    get-symbol: get-secondary-symbol,
  ),
)

#let (definition-counter, definition-box, definition, show-definition) = make-frame(
  "definition",
  theorion-i18n-map.at("definition"),
  inherited-levels: 1,
  render: fancy-box.with(
    get-border-color: get-primary-border-color,
    get-body-color: get-primary-body-color,
    get-symbol: get-primary-symbol,
  ),
)

#let (proposition-counter, proposition-box, proposition, show-proposition) = make-frame(
  "proposition",
  theorion-i18n-map.at("proposition"),
  inherited-levels: 2,
  render: fancy-box.with(
    get-border-color: get-tertiary-border-color,
    get-body-color: get-tertiary-body-color,
    get-symbol: get-tertiary-symbol,
  ),
)

#let (assumption-counter, assumption-box, assumption, show-assumption) = make-frame(
  "assumption",
  theorion-i18n-map.at("assumption"),
  inherited-levels: 2,
  render: fancy-box.with(
    get-border-color: get-secondary-border-color,
    get-body-color: get-secondary-body-color,
    get-symbol: get-secondary-symbol,
  ),
)

#let (property-counter, property-box, property, show-property) = make-frame(
  "property",
  theorion-i18n-map.at("property"),
  inherited-levels: 2,
  render: fancy-box.with(
    get-border-color: get-tertiary-border-color,
    get-body-color: get-tertiary-body-color,
    get-symbol: get-tertiary-symbol,
  ),
)

#let (conjecture-counter, conjecture-box, conjecture, show-conjecture) = make-frame(
  "conjecture",
  theorion-i18n-map.at("conjecture"),
  counter: theorem-counter,
  render: fancy-box.with(
    get-border-color: get-secondary-border-color,
    get-body-color: get-secondary-body-color,
    get-symbol: get-secondary-symbol,
  ),
)

/// Collection of show rules for all theorem environments
/// Applies all theorion-related show rules to the document
///
/// - body (content): Content to apply the rules to
/// -> content
#let show-theorion(body) = {
  show: show-theorem
  show: show-lemma
  show: show-corollary
  show: show-axiom
  show: show-postulate
  show: show-definition
  show: show-proposition
  show: show-assumption
  show: show-property
  show: show-conjecture
  body
}

#let prob(expr) = $bb(P)[|#expr|]$
#let exp(expr) = $bb(E)[|#expr|]$
#let var(expr) = $"Var"{#expr}$
#let cov(v1, v2) = $"Cov"{#v1, v2}$
#let rhs(body) = {
  box()
  h(1fr)
  sym.wj
  box(body)
}


#let coleq(color, x) = text(fill: color)[$#x$]
