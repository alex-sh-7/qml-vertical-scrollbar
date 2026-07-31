# qml-vertical-scrollbar

A reliable custom vertical `ScrollBar` component for QML (Qt 6) — a **drop-in replacement** for the buggy built-in `ScrollBar` from `QtQuick.Controls`.

## Why not the built-in ScrollBar?

The standard `ScrollBar` from `QtQuick.Controls` breaks when you customize its `contentItem` — the handle jumps, freezes at the top, or splits apart when dragged with the mouse. This component replaces it entirely by managing all positioning math manually, so drag, mouse wheel, and touch swipe all work correctly.

## Features

- Smooth drag with correct handle positioning
- Mouse wheel support directly on the handle
- Auto-hides when content does not overflow
- Dims to `0.55` opacity at rest, fully opaque on hover or drag
- Fully customizable colors, size, and placement
- Works as a sibling of `Flickable`, not a child
- Supports `inside` and `outside` alignment
- Supports `left` and `right` side placement
- Renders above other content (`z: 10`)

## Requirements

- Qt 6.0+
- QtQuick 6.0

## Installation

1. Copy `VerticalScrollBar.qml` into your project, for example: `ui/components/Scrollbars/`
2. Import the folder in your QML file:

```qml
import "path/to/Scrollbars"
```

## Basic Usage

```qml
import QtQuick 6.0
import "path/to/Scrollbars"

Rectangle {
    id: container
    width: 400
    height: 300

    Flickable {
        id: flickArea
        anchors.fill: parent
        anchors.rightMargin: 26
        clip: true
        contentWidth: width
        contentHeight: contentColumn.implicitHeight
        flickableDirection: Flickable.VerticalFlick
        boundsBehavior: Flickable.StopAtBounds

        onContentYChanged:      vbar.syncHandlePosition()
        onContentHeightChanged: vbar.syncHandlePosition()
        onHeightChanged:        vbar.syncHandlePosition()

        Column {
            id: contentColumn
            width: parent.width
            spacing: 12
            // your content here
        }
    }

    VerticalScrollBar {
        id: vbar
        targetFlickable: flickArea
        anchorItem: container
    }
}
```

> **Important:** Add `onContentYChanged`, `onContentHeightChanged`, and `onHeightChanged` to your `Flickable` pointing to `vbar.syncHandlePosition()` — this keeps the handle in sync when scrolling with the mouse wheel or touch.

## Properties

| Property | Type | Default | Description |
|---|---|---|---|
| `targetFlickable` | `var` | **required** | The `Flickable` this scrollbar controls |
| `anchorItem` | `var` | `parent` | The container to position the scrollbar relative to |
| `thickness` | `int` | `10` | Width of the scrollbar in pixels |
| `trackMargin` | `int` | `8` | Vertical margin at top and bottom of the track |
| `trackHeight` | `int` | `-1` | Fixed track height. `-1` = auto (fills available space) |
| `minTrackHeight` | `int` | `120` | Minimum track height in pixels |
| `minHandleHeight` | `int` | `38` | Minimum handle height in pixels |
| `side` | `string` | `"right"` | Which side to place the bar: `"right"` or `"left"` |
| `alignment` | `string` | `"outside"` | `"outside"` places bar outside the Flickable, `"inside"` overlaps it |
| `horizontalOffset` | `int` | `0` | Additional horizontal offset in pixels |
| `verticalOffset` | `int` | `0` | Additional vertical offset in pixels |
| `trackColor` | `color` | `#1F1F1F` | Background track color |
| `handleColor` | `color` | `#8C8C8C` | Handle color in idle state |
| `handleHoverColor` | `color` | `#DADADA` | Handle color on hover or drag |
| `handleBorderColor` | `color` | `#F3F3F3` | Handle border color. Set to `"transparent"` to remove the border |

## Public Methods

| Method | Description |
|---|---|
| `syncHandlePosition()` | Manually syncs the handle position with the current `Flickable` scroll state. Call this from `onContentYChanged`, `onContentHeightChanged`, and `onHeightChanged` on your `Flickable`. |

## Notes

- The scrollbar automatically hides when the content height does not exceed the container height
- Opacity is `0.55` at rest and `1.0` on hover or drag
- The scrollbar renders above other elements (`z: 10`)
- The handle border (`border.width: 0.5`) is always present — set `handleBorderColor: "transparent"` to hide it

## Customization Examples

### Thin minimal scrollbar on the left

```qml
VerticalScrollBar {
    id: vbar
    targetFlickable: flickArea
    anchorItem: container
    thickness: 6
    side: "left"
    alignment: "inside"
    trackColor: "transparent"
    handleColor: "#555555"
    handleHoverColor: "#AAAAAA"
    handleBorderColor: "transparent"
}
```

### Accent color scrollbar

```qml
VerticalScrollBar {
    id: vbar
    targetFlickable: flickArea
    anchorItem: container
    thickness: 10
    trackColor: "#1A1A2E"
    handleColor: "#4FA3FF"
    handleHoverColor: "#357DBD"
    handleBorderColor: "transparent"
}
```

### Outside placement with offset

```qml
VerticalScrollBar {
    id: vbar
    targetFlickable: flickArea
    anchorItem: container
    side: "right"
    alignment: "outside"
    horizontalOffset: 8
    verticalOffset: 4
}
```

## License

MIT

---

# qml-vertical-scrollbar (Русский)

Надёжный кастомный вертикальный скроллбар для QML (Qt 6) — **замена стандартного `ScrollBar`** из `QtQuick.Controls`.

## Почему не стандартный ScrollBar?

Стандартный `ScrollBar` из `QtQuick.Controls` ломается при кастомизации `contentItem` — ползунок прыгает, залипает вверху или разрывается при перетаскивании мышью. Этот компонент полностью заменяет его, управляя всей математикой позиционирования самостоятельно. Перетаскивание мышью, колёсико и тач-свайп работают корректно.

## Возможности

- Плавное перетаскивание с корректным позиционированием ползунка
- Поддержка колёсика мыши прямо на ползунке
- Автоскрытие когда контент не переполняет контейнер
- Прозрачность `0.55` в покое, полностью непрозрачный при наведении или перетаскивании
- Полная кастомизация цветов, размера и расположения
- Работает как сосед `Flickable`, а не дочерний элемент
- Поддержка выравнивания `inside` и `outside`
- Поддержка расположения слева и справа
- Отображается поверх других элементов (`z: 10`)

## Требования

- Qt 6.0+
- QtQuick 6.0

## Установка

1. Скопируй `VerticalScrollBar.qml` в свой проект, например: `ui/components/Scrollbars/`
2. Подключи папку в своём QML файле:

```qml
import "path/to/Scrollbars"
```

## Базовое использование

```qml
import QtQuick 6.0
import "path/to/Scrollbars"

Rectangle {
    id: container
    width: 400
    height: 300

    Flickable {
        id: flickArea
        anchors.fill: parent
        anchors.rightMargin: 26
        clip: true
        contentWidth: width
        contentHeight: contentColumn.implicitHeight
        flickableDirection: Flickable.VerticalFlick
        boundsBehavior: Flickable.StopAtBounds

        onContentYChanged:      vbar.syncHandlePosition()
        onContentHeightChanged: vbar.syncHandlePosition()
        onHeightChanged:        vbar.syncHandlePosition()

        Column {
            id: contentColumn
            width: parent.width
            spacing: 12
            // твой контент здесь
        }
    }

    VerticalScrollBar {
        id: vbar
        targetFlickable: flickArea
        anchorItem: container
    }
}
```

> **Важно:** Добавь `onContentYChanged`, `onContentHeightChanged` и `onHeightChanged` в свой `Flickable` с вызовом `vbar.syncHandlePosition()` — это синхронизирует ползунок при скролле колёсиком или тачем.

## Свойства

| Свойство | Тип | По умолчанию | Описание |
|---|---|---|---|
| `targetFlickable` | `var` | **обязательно** | `Flickable` которым управляет скроллбар |
| `anchorItem` | `var` | `parent` | Контейнер относительно которого позиционируется скроллбар |
| `thickness` | `int` | `10` | Ширина скроллбара в пикселях |
| `trackMargin` | `int` | `8` | Вертикальный отступ сверху и снизу трека |
| `trackHeight` | `int` | `-1` | Фиксированная высота трека. `-1` = авто |
| `minTrackHeight` | `int` | `120` | Минимальная высота трека в пикселях |
| `minHandleHeight` | `int` | `38` | Минимальная высота ползунка в пикселях |
| `side` | `string` | `"right"` | Сторона: `"right"` или `"left"` |
| `alignment` | `string` | `"outside"` | `"outside"` — снаружи Flickable, `"inside"` — поверх |
| `horizontalOffset` | `int` | `0` | Дополнительное горизонтальное смещение |
| `verticalOffset` | `int` | `0` | Дополнительное вертикальное смещение |
| `trackColor` | `color` | `#1F1F1F` | Цвет фона трека |
| `handleColor` | `color` | `#8C8C8C` | Цвет ползунка в обычном состоянии |
| `handleHoverColor` | `color` | `#DADADA` | Цвет ползунка при наведении или перетаскивании |
| `handleBorderColor` | `color` | `#F3F3F3` | Цвет обводки ползунка. Укажи `"transparent"` чтобы убрать |

## Публичные методы

| Метод | Описание |
|---|---|
| `syncHandlePosition()` | Вручную синхронизирует позицию ползунка с текущим состоянием скролла `Flickable`. Вызывай из `onContentYChanged`, `onContentHeightChanged` и `onHeightChanged` своего `Flickable`. |

## Примечания

- Скроллбар автоматически скрывается когда высота контента не превышает высоту контейнера
- Прозрачность `0.55` в покое и `1.0` при наведении или перетаскивании
- Скроллбар отображается поверх других элементов (`z: 10`)
- Обводка ползунка (`border.width: 0.5`) присутствует всегда — укажи `handleBorderColor: "transparent"` чтобы скрыть её

## Примеры кастомизации

### Тонкий минималистичный скроллбар слева

```qml
VerticalScrollBar {
    id: vbar
    targetFlickable: flickArea
    anchorItem: container
    thickness: 6
    side: "left"
    alignment: "inside"
    trackColor: "transparent"
    handleColor: "#555555"
    handleHoverColor: "#AAAAAA"
    handleBorderColor: "transparent"
}
```

### Акцентный цвет

```qml
VerticalScrollBar {
    id: vbar
    targetFlickable: flickArea
    anchorItem: container
    thickness: 10
    trackColor: "#1A1A2E"
    handleColor: "#4FA3FF"
    handleHoverColor: "#357DBD"
    handleBorderColor: "transparent"
}
```

### Расположение снаружи со смещением

```qml
VerticalScrollBar {
    id: vbar
    targetFlickable: flickArea
    anchorItem: container
    side: "right"
    alignment: "outside"
    horizontalOffset: 8
    verticalOffset: 4
}
```

## Лицензия

MIT
