import Toybox.Application;
import Toybox.Background;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time;
import Toybox.WatchUi;

class EWIQApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    function getInitialView() as [WatchUi.Views] or [WatchUi.Views, WatchUi.InputDelegates] {
        Background.registerForTemporalEvent(new Time.Duration(5 * 60));
        var view = new EWIQView();
        return [view, new EWIQDelegate(view)];
    }

    function getServiceDelegate() as [System.ServiceDelegate] {
        return [new EWIQBackground()];
    }
}
