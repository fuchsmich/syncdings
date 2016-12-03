import QtQuick 2.0
import org.nemomobile.dbus 2.0

DBusInterface {
    id: syncthingService

    service: "org.freedesktop.systemd1"
    path: "/org/freedesktop/systemd1/unit/syncthing_2eservice"
    iface: "org.freedesktop.systemd1.Unit"

    property string state: getProperty("ActiveState")
    property bool autorun: settings.autorun
    property bool readyToRun:
        (!settings.startStopWithWifi || (settings.startStopWithWifi && systemMonitor.wifiConnected)) &&
        (!settings.startStopWithCharging || (settings.startStopWithCharging && systemMonitor.dcOnline))
//    property bool startMeUp: true //?
    property bool active: state === "active"
    property bool inactive: state === "inactive"

    onReadyToRunChanged: {
        console.log("ready", readyToRun)
        runOnPropertyChange();
    }

    onAutorunChanged: {
        console.log(autorun);
        runOnPropertyChange();
    }


    function refreshState() {
        state = getProperty("ActiveState")
    }

    function runOnPropertyChange() {
        if (autorun && readyToRun) start();
        else stop();
    }

    function start() {
        console.log("Starting", autorun)
        syncthingService.call("Start", ["replace"]);
        refreshState()
    }

    function stop() {
        syncthingService.call("Stop", ["replace"]);
        refreshState()
    }

//    function toggle() {
//        syncthingService.call(
//                    syncthingService.state != "active" ? "Start" : "Stop"
//                    , ["replace"]);
//        refreshState()
//    }

//    function toggleServiceDueToState(active, state) {
//        if (active) {
//            if (!state) {
//                syncthingService.stop()
//            }
//            if (state) {
//                syncthingService.start()
//            }
//        }
//    }

        Component.onCompleted: {
            console.log("los gehts", settings.enableAutorunOnStartOfApp);
            if (settings.enableAutorunOnStartOfApp) settings.autorun = true;
            if (settings.disableAutorunOnStartOfApp) settings.autorun = false;
        }
        Component.onDestruction: {
            console.log("und tschü");
            if (settings.stopWithApp) stop();
        }
}
