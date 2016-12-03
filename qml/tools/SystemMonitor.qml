import QtQuick 2.0
import org.nemomobile.dbus 2.0

Item {
    property alias wifiConnected: connmanWifi.wifiConnected
    property alias dcOnline: dc.online
    readonly property bool emulator: false

    function refresh() {
       connmanWifi.getProperties();
        dc.readState();
    }

    DBusInterface {
        id: connmanWifi
        bus: DBus.SystemBus
        service: "net.connman"
        path: (emulator ? "/net/connman/technology/ethernet" : //Emulator hat kein Wifi
                          "/net/connman/technology/wifi") //<--- richtiger Pfad am Jolla
        iface: "net.connman.Technology"

        property bool wifiConnected

        signalsEnabled: true
        function propertyChanged(name, value) {
//            console.log(name, value)
            if (name === "Connected") {
                wifiConnected = value
            }
        }

        function getProperties() {
            typedCall('GetProperties', undefined,
                      function(result) {wifiConnected = result['Connected']})
        }
        Component.onCompleted: getProperties();
    }

    Item {
        id: dc
        property string dcStateFile: (emulator ? "/sys/class/power_supply/AC/online" : //->SailEmu
                                                 "/sys/class/power_supply/pm8921-dc/online") //->Jolla
        readonly property string usbStateFile: "/sys/class/power_supply/usb/online" //->Jolla
        property bool dcOnline: false
        property bool usbOnline: false
        property bool online: dcOnline || usbOnline

        function readState() {
            var dcRequest =  new XMLHttpRequest();
            dcRequest.open('GET', dcStateFile);
            dcRequest.onreadystatechange = function(event) {
                if (dcRequest.readyState === XMLHttpRequest.DONE) {
    //                console.log("AC state file", (dcRequest.responseText.trim() === "1"), online);
                    if (dcOnline !== (dcRequest.responseText.trim() === "1")) {
                        dcOnline = (dcRequest.responseText.trim() === "1");
                    }
                }
            }
            dcRequest.send()

            var usbRequest =  new XMLHttpRequest();
            usbRequest.open('GET', usbStateFile);
            usbRequest.onreadystatechange = function(event) {
                if (usbRequest.readyState === XMLHttpRequest.DONE) {
    //                console.log("AC state file", (usbRequest.responseText.trim() === "1"), online);
                    if (usbOnline !== (usbRequest.responseText.trim() === "1")) {
                        usbOnline = (usbRequest.responseText.trim() === "1");
                    }
                }
            }
            usbRequest.send()
        }

        Component.onCompleted: readState();
    }
}
