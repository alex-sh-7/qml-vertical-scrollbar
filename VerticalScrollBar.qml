import QtQuick 6.0

Item {
    id: root

    // The Flickable this scrollbar controls.
    required property var targetFlickable

    // Visual settings.
    property int thickness: 10
    property int trackMargin: 8

    // Optional fixed track height. If left at -1, the component uses available space automatically.
    property int trackHeight: -1
    property int minTrackHeight: 120

    // Placement relative to the anchor container.
    property int horizontalOffset: 0
    property int verticalOffset: 0
    property string side: "right"
    property string alignment: "outside"
    property var anchorItem: parent
    property color trackColor: "#1F1F1F"
    property color handleColor: "#8C8C8C"
    property color handleHoverColor: "#DADADA"
    property color handleBorderColor: "#F3F3F3"
    property int minHandleHeight: 38

    // The scrollbar is hidden when the content does not overflow.
    width: thickness
    visible: targetFlickable && targetFlickable.contentHeight > targetFlickable.height
    opacity: root.hovered || root.dragActive ? 1.0 : 0.55
    height: {
        if (trackHeight > 0)
            return Math.max(minTrackHeight, Math.min(trackHeight, anchorItem ? anchorItem.height - trackMargin * 2 : trackHeight))

        if (!targetFlickable || !anchorItem)
            return 0

        return Math.max(minTrackHeight, Math.min(targetFlickable.height - trackMargin * 2, anchorItem.height - trackMargin * 2))
    }
    z: 10
    x: 0
    y: 0

    // Maps the Flickable position into the coordinate system of the anchor item.
    function resolveAnchorPosition() {
        if (!targetFlickable || !anchorItem)
            return { x: 0, y: 0 }

        var mapped = targetFlickable.mapToItem(anchorItem, 0, 0)
        return { x: mapped.x, y: mapped.y }
    }

    property bool hovered: false
    property bool dragActive: false
    property real dragOffset: 0
    readonly property real maxContentY: targetFlickable ? Math.max(0, targetFlickable.contentHeight - targetFlickable.height) : 0

    // Synchronizes the handle position with the current Flickable contentY.
    function syncHandlePosition() {
        if (root.dragActive || root.maxContentY <= 0) {
            return
        }

        var maxY = root.height - vbarHandle.height
        var newY = maxY > 0 ? (targetFlickable.contentY / root.maxContentY) * maxY : 0
        vbarHandle.y = Math.max(0, Math.min(newY, maxY))
    }

    // Converts the handle position back into the Flickable contentY.
    function setContentYFromHandle() {
        if (root.maxContentY <= 0) {
            targetFlickable.contentY = 0
            return
        }

        var maxY = root.height - vbarHandle.height
        var ratio = maxY > 0 ? vbarHandle.y / maxY : 0
        targetFlickable.contentY = ratio * root.maxContentY
    }

    Component.onCompleted: {
        root.syncHandlePosition()
        root.updatePosition()
    }

    onHeightChanged: {
        root.syncHandlePosition()
        root.updatePosition()
    }
    onVisibleChanged: {
        root.syncHandlePosition()
        root.updatePosition()
    }
    onTargetFlickableChanged: root.updatePosition()
    onAnchorItemChanged: root.updatePosition()
    onParentChanged: root.updatePosition()
    onSideChanged: root.updatePosition()
    onAlignmentChanged: root.updatePosition()
    onHorizontalOffsetChanged: root.updatePosition()
    onVerticalOffsetChanged: root.updatePosition()
    onThicknessChanged: root.updatePosition()

    // Places the scrollbar next to the flickable, respecting the chosen side and alignment.
    function updatePosition() {
        if (!targetFlickable || !root.parent)
            return

        var position = resolveAnchorPosition()
        var edgeX = position.x
        var rightEdgeX = position.x + targetFlickable.width

        if (side === "left") {
            x = alignment === "inside"
                ? edgeX + horizontalOffset
                : edgeX - width - horizontalOffset
        } else {
            x = alignment === "inside"
                ? rightEdgeX - width + horizontalOffset
                : rightEdgeX + horizontalOffset
        }

        var availableTop = position.y + trackMargin + verticalOffset
        var availableBottom = position.y + (anchorItem ? anchorItem.height : targetFlickable.height) - height - trackMargin + verticalOffset
        y = availableBottom < availableTop ? availableBottom : availableTop
    }

    Connections {
        target: targetFlickable
        enabled: !!targetFlickable
        ignoreUnknownSignals: true

        function onXChanged() {
            root.updatePosition()
        }
        function onYChanged() {
            root.updatePosition()
        }
        function onWidthChanged() {
            root.updatePosition()
            root.syncHandlePosition()
        }
        function onHeightChanged() {
            root.updatePosition()
            root.syncHandlePosition()
        }
        function onContentYChanged() {
            root.syncHandlePosition()
        }
        function onContentHeightChanged() {
            root.syncHandlePosition()
        }
    }

    Connections {
        target: root.parent
        enabled: !!root.parent
        ignoreUnknownSignals: true

        function onWidthChanged() {
            root.updatePosition()
        }
        function onHeightChanged() {
            root.updatePosition()
        }
    }

    // Track background.
    Rectangle {
        anchors.fill: parent
        radius: width / 2
        color: root.trackColor
        opacity: 0.75
    }

    // Draggable handle.
    Rectangle {
        id: vbarHandle
        width: parent.width
        height: {
            var trackHeight = parent.height
            var ratio = targetFlickable && targetFlickable.contentHeight > 0 ? targetFlickable.height / targetFlickable.contentHeight : 1
            var handleHeight = trackHeight * Math.max(0.1, Math.min(1, ratio))
            return Math.max(root.minHandleHeight, Math.min(trackHeight - 8, handleHeight))
        }
        radius: width / 2
        color: root.hovered || root.dragActive ? root.handleHoverColor : root.handleColor
        border.color: root.handleBorderColor
        border.width: 0.5
        y: 0

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: root.hovered = true
            onExited: root.hovered = false
            onPressed: {
                root.dragActive = true
                root.dragOffset = mouseY
            }
            onReleased: {
                root.dragActive = false
                root.setContentYFromHandle()
                root.syncHandlePosition()
            }
            onPositionChanged: {
                if (!pressed)
                    return

                var maxY = root.height - vbarHandle.height
                var cursorY = vbarHandle.y + mouseY
                var newY = Math.max(0, Math.min(cursorY - root.dragOffset, maxY))
                vbarHandle.y = newY
                root.setContentYFromHandle()
            }
            onWheel: {
                wheel.accepted = true
                var step = Math.max(28, targetFlickable.height * 0.18)
                targetFlickable.contentY = Math.max(0, Math.min(root.maxContentY, targetFlickable.contentY - wheel.angleDelta.y / 120 * step))
                root.syncHandlePosition()
            }
        }
    }
}
