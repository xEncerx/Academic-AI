#let gost-bibliography-title() = {
  pagebreak(weak: true)

  // Главный заголовок "СПИСОК ИСПОЛЬЗОВАННЫХ ИСТОЧНИКОВ"
  // Форматируется как Заголовок 1 уровня: 18пт, полужирный, все прописные, по центру, интервал после 10мм
  align(center)[
    #block(
      above: 0mm,
      below: 10mm,
      sticky: true,
      {
        // Убираем красную строку, чтобы заголовок был ровно по центру
        set par(first-line-indent: 0cm)
        text(font: "Times New Roman", size: 18pt, weight: "bold")[СПИСОК ИСПОЛЬЗОВАННЫХ ИСТОЧНИКОВ]
      }
    )
  ]
}

#let gost-bib-section(num, title) = {
  // Заголовок раздела внутри списка литературы
  // 14пт, обычный шрифт (не полужирный), все прописные, по центру, отступ слева 1.25 см
  // Интервал перед 6 мм, после 6 мм, не отрывать от следующего (sticky: true)
  align(center)[
    #block(
      above: 6mm,
      below: 6mm,
      sticky: true,
      {
        set par(first-line-indent: 0cm)
        pad(
          left: 1.25cm,
          text(font: "Times New Roman", size: 14pt, weight: "regular", upper(str(num) + ". " + title))
        )
      }
    )
  ]
}

#let gost-bib-item(num, body) = {
  // Выравнивание по ширине, отступ слева 0, все строки текста после первой сдвинуты (hanging indent)
  // Реализуем через сетку: первая колонка 1.25 см для номера, вторая для текста
  set par(first-line-indent: 0cm, leading: 1.5em, justify: true)
  
  // Добавляем отступ над блоком, чтобы между источниками сохранялся полуторный интервал
  block(
    width: 100%,
    above: 1.5em,
    below: 0mm,
    grid(
      columns: (1.25cm, 1fr),
      align: (left, left),
      text(font: "Times New Roman", size: 14pt, weight: "regular", num),
      text(font: "Times New Roman", size: 14pt, weight: "regular", body)
    )
  )
}