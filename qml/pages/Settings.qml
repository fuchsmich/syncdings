import QtQuick 2.0
import Sailfish.Silica 1.0


Page {
    id: page
    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("Settings")
            }
            Label {
                text: "On App-Startup..."
                x: Theme.horizontalPageMargin
            }
            Column {
                width: parent.width - x
                spacing: Theme.paddingLarge
                x: Theme.horizontalPageMargin

                TextSwitch {
                    id: restoreChk
                    text: qsTr("...restore autostart state.")
                    automaticCheck: false
                    onClicked: {
                        checked = true;
                        disableChk.checked = enableChk.checked =
                                settings.enableAutorunOnStartOfApp = settings.disableAutorunOnStartOfApp = false;
                    }
                    Component.onCompleted: checked = !settings.enableAutorunOnStartOfApp && !settings.disableAutorunOnStartOfApp
                }
                TextSwitch {
                    id: enableChk
                    text: qsTr("...enable autostart.")
                    automaticCheck: false
                    Component.onCompleted: checked = settings.enableAutorunOnStartOfApp
                    onClicked: {
                        checked = settings.enableAutorunOnStartOfApp = true;
                        disableChk.checked = restoreChk.checked =
                                settings.disableAutorunOnStartOfApp = false;
                    }
                }
                TextSwitch {
                    id: disableChk
                    text: qsTr("...disable autostart.")
                    automaticCheck: false
                    checked: settings.disableAutorunOnStartOfApp
                    onClicked: {
                        checked = settings.disableAutorunOnStartOfApp = true;
                        restoreChk.checked = enableChk.checked =
                                settings.enableAutorunOnStartOfApp = false;
                    }
                }
            }
            TextSwitch {
                text: qsTr("Stop syncthing service with app-shutdown.")
                checked: settings.stopWithApp
                onClicked: settings.stopWithApp = checked
            }
            TextField {
                x: Theme.horizontalPageMargin
                width: parent.width - 2*Theme.horizontalPageMargin
                text: settings.wuiUrl
                label: qsTr("URL Web UI")
                onActiveFocusChanged: settings.wuiUrl = text
            }

            Label {
                width: parent.width
                //                readOnly: true
                text: "About SyncDings\nMichael Fuchs <michfu@gmx.at> \n(c) 2016"
                horizontalAlignment: Text.AlignHCenter
                //                anchors {
                //                            left: parent.left
                //                            leftMargin: Theme.horizontalPageMargin
                //                            right: parent.right
                //                            rightMargin: Theme.horizontalPageMargin
                //                            verticalCenter: parent.verticalCenter
                //                        }
            }
        }

        VerticalScrollDecorator {}
    }
}





