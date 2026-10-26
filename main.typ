// ИМПОРТ БАЗОВЫХ СТИЛЕЙ
#import "settings/gost_core.typ": gost-core
#import "settings/gost_title.typ": gost-title-page
#import "settings/gost_figures.typ": gost-figures
#import "settings/gost_tables.typ": gost-tables
#import "settings/gost_math.typ": gost-math
#import "settings/gost_listings.typ": gost-listings

// 1. Титульный лист с вымышленными данными для демонстрации
#gost-title-page(
  title: [ОТЧЁТ ПО ПРАКТИЧЕСКОМУ ЗАНЯТИЮ № ?],
  discipline: [Создание шаблонов на Typst],
  group: [НАНО-99-26],
  student: [Примеров А. Б.],
  teacher: [Образцова В. Г.],
)

// 2. Включение глобальных стилей по ГОСТу
#show: gost-core

// Включение нумерации по разделам (Глава.Рисунок) для элементов
#show: gost-figures.with(chapter-numbering: true)
#show: gost-tables.with(chapter-numbering: true)
#show: gost-math.with(chapter-numbering: true)
#show: gost-listings.with(chapter-numbering: true)

// ----------------------------------------------------
// СБОРКА ДОКУМЕНТА
// ----------------------------------------------------

// 3. Оглавление (СОДЕРЖАНИЕ)
#include "chapters/01_toc.typ"

// Последняя страница без видимого номера. Оставляйте метку после титульного
// листа, содержания и других предварительных страниц, но перед основным текстом.
// Сквозной номер начнет отображаться со следующей страницы.
#metadata("start-numbering") <start-numbering>

// 4. ОСНОВНОЙ ТЕКСТ (Введение, Разделы, Заключение)
#include "chapters/02_main_text.typ"

// 5. СПИСОК ИСПОЛЬЗОВАННЫХ ИСТОЧНИКОВ
#include "chapters/03_references.typ"

// 6. ПРИЛОЖЕНИЯ
#include "chapters/04_appendix.typ"
