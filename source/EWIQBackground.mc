import Toybox.Background;
import Toybox.System;
import Toybox.Application;
import Toybox.Lang;

(:background)
class EWIQBackground extends System.ServiceDelegate {

    function initialize() {
        ServiceDelegate.initialize();
    }

    function onTemporalEvent() as Void {
        var hour = Application.Properties.getValue("TriggerHour") as Number;
        var minute = Application.Properties.getValue("TriggerMinute") as Number;
        var now = System.getClockTime();

        var nowMinutes = now.hour * 60 + now.min;
        var triggerMinutes = hour * 60 + minute;
        var diff = nowMinutes - triggerMinutes;

        if (diff >= 0 && diff < 5) {
            Background.requestApplicationWake("Votre rapport du soir est disponible");
        }
        Background.exit(null);
    }
}
