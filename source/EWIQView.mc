import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.ActivityMonitor;
import Toybox.UserProfile;
import Toybox.System;
import Toybox.Lang;
import Toybox.Time;
import Toybox.Time.Gregorian;

class EWIQView extends WatchUi.View {

    public var showReport as Boolean = false;

    function initialize() {
        View.initialize();
    }

    function onUpdate(dc as Graphics.Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        if (!showReport) {
            drawNotification(dc);
        } else {
            drawReport(dc);
        }
    }

    function drawNotification(dc as Graphics.Dc) as Void {
        dc.drawText(
            dc.getWidth() / 2,
            dc.getHeight() / 2,
            Graphics.FONT_SMALL,
            "Votre rapport\ndu soir est\ndisponible",
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }

    function drawReport(dc as Graphics.Dc) as Void {
        var info = ActivityMonitor.getInfo();
        var profile = UserProfile.getProfile();

        var steps = (info.steps != null) ? info.steps : 0;
        var stepGoal = (info.stepGoal != null) ? info.stepGoal : 0;
        var floors = (info.floorsClimbed != null) ? info.floorsClimbed : 0;

        var y = 20;
        dc.drawText(dc.getWidth() / 2, y, Graphics.FONT_TINY,
            steps + " / " + stepGoal + " pas", Graphics.TEXT_JUSTIFY_CENTER);
        y += 30;
        dc.drawText(dc.getWidth() / 2, y, Graphics.FONT_TINY,
            floors + " etages", Graphics.TEXT_JUSTIFY_CENTER);
        y += 30;

        var sleepTime = profile.sleepTime;
        if (sleepTime != null) {
            var secs = sleepTime.value();
            var sleepHour = (secs / 3600) % 24;
            var sleepMin = (secs % 3600) / 60;
            dc.drawText(dc.getWidth() / 2, y, Graphics.FONT_TINY,
                "Coucher: " + sleepHour + "h" + sleepMin.format("%02d"),
                Graphics.TEXT_JUSTIFY_CENTER);
        }
    }
}

class EWIQDelegate extends WatchUi.BehaviorDelegate {

    private var _view as EWIQView;

    function initialize(view as EWIQView) {
        BehaviorDelegate.initialize();
        _view = view;
    }

    function onSelect() as Boolean {
        if (!_view.showReport) {
            _view.showReport = true;
            WatchUi.requestUpdate();
            return true;
        }
        return false;
    }
}
