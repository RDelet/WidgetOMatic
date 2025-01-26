import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
using Toybox.Background;


class App extends Application.AppBase {

    function initialize() { AppBase.initialize(); }
    function getInitialView() as [Views] or [Views, InputDelegates] { return [ new View() ]; }
    function onSettingsChanged() as Void {
        updateViewSettings = true;
        updateClockSettings = true;
        updateDateSettings = true;
        WatchUi.requestUpdate();
    }
}

function getApp() as App {
    return Application.getApp() as App;
}