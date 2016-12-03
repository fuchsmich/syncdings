
import QtQuick 2.0
import Sailfish.Silica 1.0


Page {
    id: page

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(Qt.resolvedUrl("Settings.qml"))
            }
            MenuItem {
                text: qsTr("Open Web UI")
                onClicked: Qt.openUrlExternally(settings.wuiUrl)
            }
        }

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("SyncDings")
            }

            SectionHeader {
                text: qsTr("Run service...")
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: Theme.paddingLarge
                IconButton {
//                    id: pause
                    icon.source: "image://theme/icon-l-pause"
                    onClicked: settings.autorun = false
                    enabled: settings.autorun
                }

                IconButton {
//                    id: play
                    icon.source: "image://theme/icon-l-play"
                    onClicked: settings.autorun = true
                    enabled: !settings.autorun
                }

            }
//            Label {
//                anchors.horizontalCenter: parent.horizontalCenter
//                text: qsTr("Syncthing Service State: ") + syncthingService.state
//                font.pixelSize: Theme.fontSizeTiny
//            }
            DetailItem {
//                anchors.horizontalCenter: parent.horizontalCenter
                label: qsTr("syncthing state: ")
                value: syncthingService.state
//                font.pixelSize: Theme.fontSizeTiny
            }

            SectionHeader {
                text: qsTr("...depending on following connections:")
            }

            Column {
//                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                spacing: Theme.paddingLarge
                IconTextSwitch {
                    checked: settings.startStopWithWifi
                    icon.source: "image://theme/icon-m-wlan?" +
                                 (systemMonitor.wifiConnected
                                  ? Theme.highlightColor
                                  : Theme.primaryColor)
                    text: qsTr("Wifi")
                    description: (systemMonitor.wifiConnected
                                  ? "online"
                                  : "offline")
                    onClicked: settings.startStopWithWifi = !settings.startStopWithWifi

                }

//                Switch {
//                    checked: settings.startStopWithWifi
//                    icon.source: "image://theme/icon-m-wlan?" +
//                                 (systemMonitor.wifiConnected
//                                  ? Theme.highlightColor
//                                  : Theme.primaryColor)

//                    onClicked: settings.startStopWithWifi = !settings.startStopWithWifi
//                }

                IconTextSwitch {
                    checked: settings.startStopWithCharging
                    icon.source: "image://theme/icon-m-charging?" +
                                 (systemMonitor.dcOnline
                                  ? Theme.highlightColor
                                  : Theme.primaryColor)
                    text: qsTr("Power Supply")
                    description: (systemMonitor.dcOnline
                                  ? "online"
                                  : "offline")
                    onClicked: settings.startStopWithCharging = !settings.startStopWithCharging
                }

            }            

        }
    }
}


