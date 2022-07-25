/*
 *   SPDX-FileCopyrightText: 2020 Devin Lin <espidev@gmail.com>
 *
 *   SPDX-License-Identifier: LGPL-2.0-or-later
 */ 

import QtQuick 2.0
import QtQuick.Controls 2.7 
import QtQuick.Layouts 1.1

import org.kde.kirigami 2.13 as Kirigami

Rectangle {
    id: buttonRoot
    
    property bool toggledOn: false
    property string text
    property string iconSource
    
    signal clicked
    
    radius: 25
    opacity: mouseArea.pressed ? 0.4 : 1
    gradient: Gradient {
        GradientStop { position: 0.0; color: "#E3E3E4" }
        GradientStop { position: 1.0; color: "#FFFFFF" }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        
        onClicked: buttonRoot.clicked()
    }
    
    ColumnLayout {
        anchors.fill: parent
        spacing: Kirigami.Units.smallSpacing
        Kirigami.Icon {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
            Layout.preferredHeight: Kirigami.Units.gridUnit * 1.5
            Layout.preferredWidth: Kirigami.Units.gridUnit * 1.5
            source: buttonRoot.iconSource
        }
        Label {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideMiddle
            text: buttonRoot.text
            font.pointSize: Kirigami.Theme.defaultFont.pointSize * 1.05
        }
    }
}
