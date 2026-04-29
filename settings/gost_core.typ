#let gost-core(body) = {
  // Страницы
  set page(
    paper: "a4",
    margin: (left: 30mm, right: 10mm, top: 20mm, bottom: 20mm),
  footer: context {
    // Нумерация страниц: по центру внизу, арабскими цифрами
    // Номерация начинается со страницы, следующей за меткой <start-numbering>
    let page-num = counter(page).get().first()
    
    // Ищем метку начала нумерации
    let start-label = query(<start-numbering>).first()
    let start-page = if start-label != none {
      start-label.location().page()
    } else {
      3 // fallback: если метка не найдена, начинаем с 3-й страницы
    }
    
    // Показываем номер только на страницах после метки
    if page-num > start-page {
      align(center, text(font: "Times New Roman", size: 12pt, weight: "regular", str(page-num)))
    }
  },
  )

  // Основной текст
  set text(
    font: "Times New Roman",
    size: 14pt,
    weight: "regular",
    lang: "ru",
  )

  // Абзацы
  set par(
    justify: true,
    first-line-indent: (amount: 1.25cm, all: true),
    leading: 1.5em, // полуторный интервал
    spacing: 1.5em, // интервал между абзацами
  )

  // Заголовки
  set heading(numbering: (..nums) => {
    let n = nums.pos()
    if n.len() == 1 {
      str(n.first()) // Level 1: "1" (без точки)
    } else {
      n.map(str).join(".") + "." // Level 2+: "1.1." (с точкой)
    }
  })

  show heading: it => {
    // Формирование номера (если он включен)
    let number = if it.numbering != none {
      counter(heading).display(it.numbering)
      " " // Пробел после номера
    } else {
      ""
    }

    let body-text = it.body
    let result = none

    if it.level == 1 {
      // Заголовок 1 уровня: 18пт, все прописные
      result = text(size: 18pt, weight: "bold", upper(number) + upper(body-text))
    } else if it.level == 2 {
      // Заголовок 2 уровня: 16пт
      result = text(size: 16pt, weight: "bold", number + body-text)
    } else {
      // Заголовок 3+ уровня: 14пт
      result = text(size: 14pt, weight: "bold", number + body-text)
    }

    let above-space = if it.level == 1 { 0mm } else { 15mm }

    if it.level == 1 {
      pagebreak(weak: true)
    }

    // Блок заголовка: запрет висящих строк, не отрывать от следующего
    block(
      above: above-space,
      below: 10mm,
      sticky: true,
      pad(left: 1.25cm, result),
    )
  }

  // 3. Маркированные и нумерованные списки
  set list(
    indent: 1.25cm,
    body-indent: 1cm, // Отступ маркера 1.25, текст начинается на 2.25 (1.25 + 1)
    marker: "●",
  )

  set enum(
    indent: 1.25cm,
    body-indent: 1cm,
    numbering: "1", // Без точки в конце
  )

  body
}
