#import "lib.typ": *
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()

#import "@preview/theorion:0.4.1": *
#import cosmos.fancy: *

#set text(
  lang: "en",
)

#show: ilm.with(
  title: [Applied Probability for Computer Science],
  author: "Federico Segala",
  imagePath: "unilogo.png",
  abstract: [ Academic Year: 2025-2026#linebreak()
    Lecture Notes
    #linebreak()
    prof. Isadora Antoniano Villalobos
  ],
)


// 1. Change the counters and numbering:
#set-inherited-levels(1)
#set-zero-fill(true)
#set-leading-zero(true)
#set-theorion-numbering("1.1")


#show heading.where(level: 1): set text(size: 22pt)
#show heading.where(level: 2): set text(size: 17pt)
#show heading.where(level: 3): set text(size: 14pt)
#show heading.where(level: 4): set text(size: 14pt)
#show heading.where(level: 5): set text(size: 12pt)

#outline(
  title: "Table of Contents",
  depth: 3,
)

#pagebreak()

#include "chapters/chapter01/chapter.typ"
#pagebreak()
#include "chapters/chapter02/chapter.typ"
#pagebreak()
#include "chapters/chapter03/chapter.typ"
#pagebreak()
#include "chapters/chapter04/chapter.typ"
#pagebreak()


#pagebreak()

#outline(
  title: "Figures Index",
  target: figure.where(kind: image),
)


// keep this stuff down here to avoid numbering toc and stuff like that


// only apply numbering to figures with captions
#show figure: it => {
  if it.caption != none {
    numbering("Figure 1")
  }
  it
}

