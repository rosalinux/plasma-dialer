// SPDX-FileCopyrightText: 2020 Devin Lin <espidev@gmail.com>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick 2.0
import QtQuick.Controls 2.7 
import QtQuick.Layouts 1.1

import org.kde.kirigami 2.13 as Kirigami
import org.kde.telephony 1.0

Kirigami.InlineMessage {
    type: Kirigami.MessageType.Information
    visible: ActiveCallModel.active
    text: i18n("Active call list")
    actions: [
        Kirigami.Action {
            icon.name: "call-start"
            text: i18n("View")
            onTriggered: applicationWindow().pageStack.layers.push(getPage("Call"))
        }
    ]
    Layout.fillWidth: true
    Layout.leftMargin: Kirigami.Units.smallSpacing
    Layout.rightMargin: Kirigami.Units.smallSpacing
}
