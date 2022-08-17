// SPDX-FileCopyrightText: 2014 Aaron Seigo <aseigo@kde.org>
// SPDX-FileCopyrightText: 2014 Marco Martin <mart@kde.org>
// SPDX-FileCopyrightText: 2021 Alexey Andreyev <aa13q@ya.ru>
// SPDX-License-Identifier: LGPL-2.0-or-later

import QtQuick 2.3
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.1
import QtQuick.LocalStorage 2.0

import org.kde.kirigami 2.19 as Kirigami

import org.kde.telephony 1.0

import "call"

Kirigami.ApplicationWindow {
    FontLoader { id: webFont; source: "qrc:/font-manrope" }

    wideScreen: false
    id: root

    pageStack.globalToolBar.preferredHeight : 0

    contextDrawer: Kirigami.ContextDrawer {}

    readonly property bool smallMode: applicationWindow().height < Kirigami.Units.gridUnit * 28

    // pop pages when not in use
    Connections {
        target: applicationWindow().pageStack
        function onCurrentIndexChanged() {
            // wait for animation to finish before popping pages
            timer.restart();
        }
    }
    
    Timer {
        id: timer
        interval: 300
        onTriggered: {
            let currentIndex = applicationWindow().pageStack.currentIndex;
            while (applicationWindow().pageStack.depth > (currentIndex + 1) && currentIndex >= 0) {
                applicationWindow().pageStack.pop();
            }
        }
    }

    Kirigami.PagePool { id: pagePool }

    function getContactIcon(name) {

        const contactIconIds = {
          "А": ":Contact-id-1",
          "Б": ":Contact-id-2",
          "В": ":Contact-id-3",
          "Г": ":Contact-id-4",
          "Д": ":Contact-id-5",
          "Е": ":Contact-id-6",
          "Ё": ":Contact-id-7",
          "Ж": ":Contact-id-8",
          "З": ":Contact-id-9",
          "И": ":Contact-id-10",
          "Й": ":Contact-id-11",
          "К": ":Contact-id-12",
          "Л": ":Contact-id-13",
          "М": ":Contact-id-14",
          "Н": ":Contact-id-15",
          "О": ":Contact-id-16",
          "П": ":Contact-id-17",
          "Р": ":Contact-id-18",
          "С": ":Contact-id-19",
          "Т": ":Contact-id-20",
          "У": ":Contact-id-21",
          "Ф": ":Contact-id-22",
          "Х": ":Contact-id-23",
          "Ц": ":Contact-id-24",
          "Ч": ":Contact-id-25",
          "Ш": ":Contact-id-26",
          "Щ": ":Contact-id-27",
          "Ъ": ":Contact-id-28",
          "Ь": ":Contact-id-29",
          "Ы": ":Contact-id-30",
          "Э": ":Contact-id-31",
          "Ю": ":Contact-id-32",
          "Я": ":Contact-id-33"
        }

        const iconId = contactIconIds[name.substr(0, 1).toUpperCase()]
        if (iconId){
            return iconId
        } else {
            return ":Contact-id-noname"
        }
    }

    function getPage(name) {
        switch (name) {
        case "History": return pagePool.loadPage("qrc:/HistoryPage.qml");
        case "Contacts": return pagePool.loadPage("qrc:/ContactsPage.qml");
        case "Dialer": return pagePool.loadPage("qrc:/DialerPage.qml");
        case "Call": return pagePool.loadPage("qrc:/call/CallPage.qml");
        case "Settings": return pagePool.loadPage("qrc:/SettingsPage.qml");
        case "About": return pagePool.loadPage("qrc:/AboutPage.qml");
        case "Incoming": return pagePool.loadPage("qrc:/call/IncomingPage.qml");
        }
    }

    property bool isWidescreen: root.width >= root.height

    function switchToPage(page, depth) {
        while (pageStack.depth > depth) pageStack.pop()
        pageStack.push(page)
        page.forceActiveFocus()
    }

    function selectModem() {
        const deviceUniList = DeviceUtils.deviceUniList()
        if (deviceUniList.length === 0) {
            console.warn("Modem devices not found")
            return ""
        }

        if (deviceUniList.length === 1) {
            return deviceUniList[0]
        }
        console.log("TODO: select device uni")
    }

    function call(number) {
        getPage("Dialer").pad.number = number
        switchToPage(getPage("Dialer"), 0)
    }

    Component.onCompleted: {
        // initial page and nav type
        switchToPage(getPage("Dialer"), 1);
    }

    Loader {
        id: sidebarLoader
        source: "qrc:/components/Sidebar.qml"
        active: false
    }

    USSDSheet {
        id: ussdSheet
        onResponseReady: {
            // TODO: debug
            // USSDUtils.respond(response)
        }
    }

    ImeiSheet {
        id: imeiSheet
        function show() {
            imeiSheet.imeis = DeviceUtils.equipmentIdentifiers()
            imeiSheet.open()
        }
    }

    Connections {
        target: CallUtils

        function onMissedCallsActionTriggered() {
            root.visible = true;
        }

        function onCallStateChanged(state) {
            if (CallUtils.callState === DialerTypes.CallState.Active) {
                getPage("Dialer").pad.number = ""
            }
            // TODO: also activate on Dialing state
        }
    }

    Connections {
        target: UssdUtils

        function onNotificationReceived(deviceUni, message) {
            ussdSheet.showNotification(message)
        }

        function onRequestReceived(deviceUni, message) {
            ussdSheet.showNotification(message, true)
        }

        function onInitiated(deviceUni, command) {
            ussdSheet.open()
        }
    }
}
