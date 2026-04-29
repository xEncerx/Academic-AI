// GOST Listings Settings
#let gost-listings(chapter-numbering: false, body) = {
  // Устанавливаем префикс по умолчанию
  set figure(supplement: "Листинг")

  // Сброс счетчика листингов при начале новой главы
  show heading.where(level: 1): it => {
    if chapter-numbering {
      counter(figure.where(kind: "listing")).update(0)
    }
    it
  }

  // Перекрестные ссылки на листинги
  show ref: it => context {
    if it.element != none and it.element.func() == figure and it.element.kind == "listing" {
      let loc = it.element.location()
      let h-num = counter(heading).at(loc).first()
      let l-num = counter(figure.where(kind: "listing")).at(loc).first()

      let sup = it.supplement
      if sup == auto { sup = "Листинг" }

      let app-letter = state("gost-app-letter", none).at(loc)
      let num-str = if app-letter != none { app-letter + "." + str(l-num) } else if chapter-numbering and h-num > 0 {
        str(h-num) + "." + str(l-num)
      } else { str(l-num) }

      link(it.target)[#sup #num-str]
    } else {
      it
    }
  }

  // Оформление подписи (заголовка) листинга
  show figure.where(kind: "listing"): it => context {
    set align(left)

    let caption-text = if it.caption != none {
      set text(font: "Times New Roman", size: 12pt, weight: "regular", style: "italic")
      // Одинарный межстрочный интервал и выравнивание по левому краю, убираем абзацный отступ
      set par(first-line-indent: 0cm, leading: 0.65em, justify: false)

      // Вычисляем номер
      let h-num = counter(heading).get().first()
      let l-num = it.counter.get().first()

      let app-letter = state("gost-app-letter", none).get()
      let num-str = if app-letter != none {
        app-letter + "." + str(l-num)
      } else if chapter-numbering and h-num > 0 {
        str(h-num) + "." + str(l-num)
      } else {
        str(l-num)
      }

      block(
        width: 100%,
        above: 6mm, // Отступ перед подписью (6 мм)
        below: 1mm, // Прилегает к листингу
        sticky: true, // Не отрывать от следующего
        // Выводим "Листинг N --- Текст подписи"
        align(left)[#it.supplement #num-str --- #it.caption.body],
      )
    } else {
      none
    }

    // Размещаем подпись НАД листингом, а затем сам листинг
    block(
      width: 100%,
      below: 6mm, // Отступ после листинга (6 мм)
      {
        caption-text
        it.body
      },
    )
  }

  // Оформление содержимого внутри рамки (шрифт, отступы, рамка)
  show raw.where(block: true): it => {
    set text(font: "Courier New", size: 10pt)
    set par(first-line-indent: 0cm, leading: 0.65em, justify: false)

    // По ГОСТу листинги обведены тонкой рамкой
    block(
      width: 100%,
      stroke: 0.5pt + black,
      inset: 6pt, // Небольшой внутренний отступ для красоты
      breakable: true, // Разрешаем перенос листинга на следующую страницу
      it,
    )
  }

  body
}

// Макрос для вставки листинга с автоматической нумерацией строк шагом 10
#let gost-listing(
  file: none,
  code: none,
  caption: none,
  lang: none, // Язык для подсветки синтаксиса, например "python" или "delphi"
  numbers: false, // Включить нумерацию строк с шагом 10
  new-page: false, // Начинать листинг с новой страницы (согласно правилам разрывов)
) = {
  if new-page {
    pagebreak(weak: true)
  }

  let content = if file != none {
    read(file)
  } else if code != none {
    code
  } else {
    ""
  }

  let body = if numbers {
    // Разбиваем текст на строки и добавляем нумерацию с шагом 10
    let lines = content.split("\n")
    let numbered-lines = ()
    let n = 10

    // Форматируем, чтобы номера были ровными
    for line in lines {
      let num-str = str(n)
      if n < 100 { num-str = num-str + "  " } else if n < 1000 { num-str = num-str + " " }

      numbered-lines.push(num-str + " " + line)
      n += 10
    }
    // Восстанавливаем в единый блок кода
    raw(numbered-lines.join("\n"), lang: lang, block: true)
  } else {
    raw(content, lang: lang, block: true)
  }

  figure(
    caption: caption,
    kind: "listing",
    supplement: "Листинг",
    body,
  )
}
