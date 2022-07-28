/*
 *   SPDX-FileCopyrightText: 2014 Aaron Seigo <aseigo@kde.org>
 *   SPDX-FileCopyrightText: 2015 Marco Martin <mart@kde.org>
 *   SPDX-FileCopyrightText: 2020 Devin Lin <espidev@gmail.com>
 *
 *   SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.0
import QtQuick.Controls 2.7 as Controls
import QtQuick.Layouts 1.1

import org.kde.kirigami 2.12 as Kirigami

import org.kde.telephony 1.0

import "../dialpad"

Kirigami.Page {
    id: incomingPage
    leftPadding: 0
    rightPadding: 0
    topPadding: 0
    bottomPadding: 0


    function activeDeviceUni() {
        return applicationWindow().selectModem()
    }
    function activeCallUni() {
        return ActiveCallModel.activeCallUni()
    }

    property bool callActive: ActiveCallModel.active


    Rectangle{
        id:mainRect
        anchors.fill: parent

    Rectangle {
        id: topSide
        color: "#C4C4C4"
        parent: mainRect
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.left: parent.left
        height: parent.height / 2
        width: parent.width

        // phone number/alias
        Controls.Label {
            id: callingLabel
            parent: topSide
            anchors.centerIn: parent
            anchors.left: parent.left
            anchors.right: parent.right
            font.family: "Manrope"
            font.pixelSize: 26
            color: "#999999"
            text: "Вызов от..."
        }

        Rectangle {
            id: personIcon
            color: "#999999"
            parent: callingLabel
            anchors.bottom: parent.top
            width: 172
            height: 172
            radius: 10

            Kirigami.Icon {
            id: icon
            parent: personIcon
            color: "#C4C4C4"
            source: ":icon-person"
            anchors.centerIn: parent
            anchors.fill: parent
            
            }
        }
    }

    Rectangle{
        id: bottomSide
        parent: mainRect
        color: "#437431"
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        height: parent.height / 2
        width: parent.width


        
    Item {
        id: acceptCallButton
        parent: bottomSide
        anchors.centerIn: parent
        height: 164
        width: 404

        Kirigami.Icon {
            id: acceptIcon
            source: acceptAbatractButton.pressed ? ":btn-callgr" : ":btn-call"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            width: 404
            height: 164
        }

        Controls.AbstractButton {
            id: acceptAbatractButton
            anchors.fill: parent
            enabled: statusLabel.text.length > 0
            onClicked: CallUtils.accept(activeDeviceUni(), activeCallUni())
        }
    }

    Item {
        id: declineCallButton
        anchors.top: acceptCallButton.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: 5
        height: 164
        width: 404

        Kirigami.Icon {
            id: declineIcon
            source: declineAbstractButton.pressed ? ":btn-call-hangupgr" : ":btn-call-hangup"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            width: 404
            height: 164
        }

        Controls.AbstractButton {
            id: declineAbstractButton
            anchors.fill: parent
            enabled: statusLabel.text.length > 0
            onClicked: {
                CallUtils.hangUp(activeDeviceUni(), activeCallUni());
                Qt.quit()
            } 
        }
    }
        /*
        DialerRosaButton { 
            id: declineCallButton
            anchors.top: acceptCallButton.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: 5
            height: 164
            width: 404
            iconSource: ":btn-call-hangup"; 
            iconSourcePressed: ":btn-call-hangupgr"; 
            onPressed: {
                CallUtils.hangUp(activeDeviceUni(), activeCallUni());
                Qt.quit()
           }
        }
        */
        
    } //rectangle
    }
} //page
