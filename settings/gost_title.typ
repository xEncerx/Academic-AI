#import "gost_fonts.typ": gost-serif

#let _gost-title-date(value) = {
  if type(value) == datetime {
    let months = (
      "января", "февраля", "марта", "апреля", "мая", "июня",
      "июля", "августа", "сентября", "октября", "ноября", "декабря",
    )
    [«#value.display("[day]")» #months.at(value.month() - 1) #value.year() г.]
  } else {
    value
  }
}

// Самостоятельная страница: вызывается до подключения gost-core.
#let gost-title-page(
  title: none,
  discipline: none,
  group: none,
  student: none,
  teacher: none,
  date: datetime.today(),
  student-date: auto,
  teacher-date: auto,
  year: datetime.today().year(),
  ministry: [МИНОБРНАУКИ РОССИИ],
  university-type: [Федеральное государственное бюджетное образовательное учреждение \ высшего образования],
  university: [«МИРЭА — Российский технологический университет»],
  university-short: [РТУ МИРЭА],
  institute: [Институт кибербезопасности и цифровых технологий],
  department: [Кафедра КБ-9 «Предметно-ориентированные информационные системы»],
  city: [Москва],
  emblem: "/assets/images/mirea-emblem.png",
  discipline-label: [по дисциплине],
  report-note: [Отчёт представлен к \ рассмотрению:],
  student-label: [Студент группы],
  teacher-label: [Преподаватель],
  signature-caption: [(подпись)],
  footer: auto,
  date-format: _gost-title-date,
  paper: "a4",
  margin: (top: 20mm, bottom: 30mm, left: 30mm, right: 10mm),
  font: gost-serif,
  font-size: 12pt,
  header-size: 11pt,
  institution-size: 12pt,
  university-short-size: 16pt,
  title-size: 16pt,
  discipline-size: 14pt,
  footer-size: 14pt,
  signature-caption-size: 11pt,
  emblem-height: 30mm,
  emblem-gap: 2mm,
  header-line-gap: 1mm,
  institution-gap: 9mm,
  title-gap: 25mm,
  signatures-gap: 28mm,
  note-gap: 1mm,
  signature-row-gap: 12mm,
  signature-columns: (1.8fr, 1.25fr, 1fr, 1fr),
  signature-column-gutter: 3mm,
  signature-stroke: 0.5pt,
) = {
  let student-date = if student-date == auto { date } else { student-date }
  let teacher-date = if teacher-date == auto { date } else { teacher-date }
  for (name, value) in (
    ("title", title), ("discipline", discipline), ("group", group),
    ("student", student), ("teacher", teacher),
    ("student-date", student-date), ("teacher-date", teacher-date),
  ) {
    assert(value != none and value != "" and value != [], message: "Заполните обязательное поле " + name)
  }

  page(paper, margin: margin, header: none, footer: none, numbering: none)[
    #set text(font: font, size: font-size, lang: "ru", hyphenate: false, top-edge: "ascender", bottom-edge: "descender")
    #set par(first-line-indent: 0pt, leading: 1pt, spacing: 0pt, justify: false)
    #set block(above: 0pt, below: 0pt)

    #let header-line(value, size: header-size, weight: "regular") = {
      if value != none { block(above: header-line-gap, text(size: size, weight: weight, value)) }
    }

    #align(center, {
      if emblem != none {
        image(emblem, height: emblem-height, alt: "Герб вуза")
        v(emblem-gap)
      }
      header-line(ministry)
      header-line(university-type, size: institution-size)
      header-line(university, size: institution-size, weight: "bold")
      header-line(university-short, size: university-short-size, weight: "bold")
      v(institution-gap)
      header-line(institute, size: institution-size, weight: "bold")
      header-line(department, size: institution-size, weight: "bold")
    })

    #v(title-gap)
    #align(center)[
      #block(text(size: title-size, weight: "bold", title))
      #block(text(size: discipline-size, weight: "bold", [#discipline-label «#discipline»]))
    ]

    #v(signatures-gap)
    #if report-note != none {
      block(report-note)
      v(note-gap)
    }

    #let signature = stack(
      spacing: 1mm,
      block(width: 100%, height: 0.9em, align(bottom, line(length: 100%, stroke: signature-stroke))),
      align(center, text(size: signature-caption-size, signature-caption)),
    )
    #grid(
      columns: signature-columns,
      column-gutter: signature-column-gutter,
      row-gutter: signature-row-gap,
      align: left + top,
      [#student-label #group], date-format(student-date), signature, student,
      teacher-label, date-format(teacher-date), signature, teacher,
    )

    #v(1fr)
    #align(center, text(size: footer-size, if footer == auto {
      [#if city != none { city; if year != none { [, ] } }#if year != none { [#year г.] }]
    } else {
      footer
    }))
  ]
}
