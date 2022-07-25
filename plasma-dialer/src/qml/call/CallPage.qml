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
    id: callPage

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
    property int callDuration: ActiveCallModel.callDuration
    
    title: i18n("Active call list")

    function secondsToTimeString(seconds) {
        var h = Math.floor(seconds / 3600);
        var m = Math.floor((seconds - (h * 3600)) / 60);
        var s = seconds - h * 3600 - m * 60;
        if(m < 10) m = '0' + m;
        if(s < 10) s = '0' + s;
        if(h === 0) return '' + m + ':' + s;
        return '' + h + ':' + m + ':' + s;
    }

    Connections {
        target: DialerUtils
        function onMuteChanged(muted) {
            muteButton.toggledOn = muted
        }
        function onSpeakerModeChanged(enabled) {
            speakerButton.toggledOn = enabled
        }
    }

    ColumnLayout {
        id: activeCallUi

        anchors {
            fill: parent
            //margins: Kirigami.Units.largeSpacing
        }

        Rectangle {
            id: info
            Layout.fillWidth: true
            height: 690

            Rectangle {
                color: "#437431"
                y: 87
                width: 172
                height: 172

                anchors.horizontalCenter: info.horizontalCenter
                Controls.Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    font.family: "Manrope"
                    font.pixelSize: 120
                    color: "#FFFFFF"
                    text: {
                        return contact.text.substr(0, 1).toUpperCase();
                    }
                }
            }
            // time spent on call
            Controls.Label {
                Layout.fillWidth: true
                Layout.minimumHeight: implicitHeight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                text: {
                        return i18n("Calling...");
                }
                font.family: "Manrope"
                font.pixelSize: 26
                color: "#444444"
                y: 312
                anchors.horizontalCenter: info.horizontalCenter
            }
            // phone number/alias
            Controls.Label {
                id: phone
                Layout.fillWidth: true
                Layout.minimumHeight: implicitHeight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                font.family: "Manrope"
                font.pixelSize: 56
                lineHeight: 48
                minimumPixelSize: 56
                maximumLineCount: 3
                text: getPage("Dialer").pad.number
                color: "#444444"
                width: 620
                height: 120
                y: 402
                anchors.horizontalCenter: info.horizontalCenter
            }
            // contact name
            Controls.Label {
                id: contact
                //Layout.fillWidth: true
                Layout.minimumHeight: implicitHeight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                maximumLineCount: 3

                width: 620
                height: 120

                font.family: "Manrope"
                font.pixelSize: 40
                color: "#444444"

                text: ContactUtils.displayString(phone.text)
                y: 503
                anchors.horizontalCenter: info.horizontalCenter
                wrapMode: Text.WordWrap
                elide: Text.ElideMiddle
            }
        }

        // controls
        Rectangle {
            color: "#437431"

            Layout.fillWidth: true
            Layout.fillHeight: true

            CallPageButton {
                id: speakerButton
                width: 296
                height: 164
                x: 50
                y: 75
                
                iconSource: ":icons-vol-mute"
                text: i18n("Speaker")
                
                onClicked: {
                    const speakerMode = !toggledOn;
                    DialerUtils.setSpeakerMode(speakerMode);
                    iconSource = toggledOn ? ":icons-vol-mute" : ":icons-vol-up";
                }
            }
            CallPageButton {
                id: muteButton

                width: 296
                height: 164
                x: 374
                y: 75

                iconSource: ":icons-mic-off"
                text: i18n("Mute")

                onClicked: {
                    const micMute = !toggledOn;
                    DialerUtils.setMute(micMute);
                    iconSource = toggledOn ? ":icons-mic-off" : ":icons-mic";
                }
            }
            CallPageButton {
                id: dialerButton

                width: 187
                height: 164
                x: 50
                y: 481

                iconSource: ":icon-dialer"
                text: i18n("Keypad")

                onClicked: switchToogle()
                toggledOn: false

                function switchToogle() {
                    // activeCallSwipeView: 0 is ActiveCallView, 1 is Dialpad
                    if (toggledOn) {
                        activeCallSwipeView.currentIndex = 0
                    } else {
                        activeCallSwipeView.currentIndex = 1
                    }
                }
            }
            CallPageButton {
                id: endCallButton

                width: 404
                height: 164
                x: 266
                y: 481

                iconSource: ":icon-handset-hangup"
                visible: callActive
                
                onClicked: {
                    CallUtils.hangUp(activeDeviceUni(), activeCallUni());
                }
            }
        }
    }
}
