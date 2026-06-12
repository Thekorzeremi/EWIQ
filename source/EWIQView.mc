import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.ActivityMonitor;
import Toybox.UserProfile;
import Toybox.System;
import Toybox.Lang;

class EWIQView extends WatchUi.View {

    public var page as Number = 0;

    const COLOR_STEPS  = 0x00AAFF;
    const COLOR_FLOORS = 0xFF0099;
    const COLOR_SLEEP  = 0x00AAFF;

    function initialize() {
        View.initialize();
    }

    function onUpdate(dc as Graphics.Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        if (page == 0) {
            drawNotification(dc);
        } else if (page == 1) {
            drawStepsPage(dc);
        } else if (page == 2) {
            drawFloorsPage(dc);
        } else {
            drawSleepPage(dc);
        }
    }

    function drawNotification(dc as Graphics.Dc) as Void {
        var cx = dc.getWidth() / 2;
        var cy = dc.getHeight() / 2;

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(cx, cy, Graphics.FONT_SMALL,
            "Votre rapport\ndu soir est\ndisponible",
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    function drawMetricPage(dc as Graphics.Dc, label as String,
                            bigValue as String, subText as String,
                            progress as Float, color as Number) as Void {
        var w = dc.getWidth();
        var h = dc.getHeight();
        var cx = w / 2;
        var cy = h / 2;
        var radius = (w < h ? w : h) / 2 - 8;

        if (progress > 1.0) { progress = 1.0; }
        if (progress < 0.0) { progress = 0.0; }

        dc.setPenWidth(10);
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(cx, cy, radius, Graphics.ARC_CLOCKWISE, 210, -30);

        if (progress > 0.0) {
            var sweep = 240.0 * progress;
            var endAngle = 210 - sweep.toNumber();
            dc.setColor(color, Graphics.COLOR_TRANSPARENT);
            dc.drawArc(cx, cy, radius, Graphics.ARC_CLOCKWISE, 210, endAngle);
        }
        dc.setPenWidth(1);

        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(cx, h * 15 / 100, Graphics.FONT_XTINY, label,
            Graphics.TEXT_JUSTIFY_CENTER);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(cx, cy, Graphics.FONT_NUMBER_HOT, bigValue,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.drawText(cx, h * 68 / 100, Graphics.FONT_TINY, subText,
            Graphics.TEXT_JUSTIFY_CENTER);
    }

    function drawStepsPage(dc as Graphics.Dc) as Void {
        var info = ActivityMonitor.getInfo();
        var steps = (info.steps != null) ? info.steps : 0;
        var goal = (info.stepGoal != null && info.stepGoal > 0) ? info.stepGoal : 1;
        var pct = (steps * 100 / goal);

        drawMetricPage(dc, "PAS",
            steps.toString(),
            pct + "% de " + goal,
            steps.toFloat() / goal,
            COLOR_STEPS);
    }

    function drawFloorsPage(dc as Graphics.Dc) as Void {
        var info = ActivityMonitor.getInfo();
        var floors = (info.floorsClimbed != null) ? info.floorsClimbed : 0;
        var goal = (info.floorsClimbedGoal != null && info.floorsClimbedGoal > 0)
            ? info.floorsClimbedGoal : 1;

        drawMetricPage(dc, "ETAGES",
            floors.toString(),
            "objectif " + goal,
            floors.toFloat() / goal,
            COLOR_FLOORS);
    }

    function drawSleepPage(dc as Graphics.Dc) as Void {
        var profile = UserProfile.getProfile();
        var now = System.getClockTime();
        var sleepTime = profile.sleepTime;

        var value = "--:--";
        var reco = "Bonne nuit !";

        if (sleepTime != null) {
            var secs = sleepTime.value();
            var hh = (secs / 3600) % 24;
            var mm = (secs % 3600) / 60;

            value = hh + ":" + mm.format("%02d");

            var nowMinutes = now.hour * 60 + now.min;
            var sleepMinutes = hh * 60 + mm;
            if (nowMinutes > sleepMinutes) {
                reco = "Hors objectif !";
            }
        }

        drawMetricPage(dc, "COUCHER",
            value,
            reco,
            1.0,
            COLOR_SLEEP);
    }
}

class EWIQDelegate extends WatchUi.BehaviorDelegate {

    private var _view as EWIQView;

    function initialize(view as EWIQView) {
        BehaviorDelegate.initialize();
        _view = view;
    }

    function onSelect() as Boolean {
        if (_view.page == 0) {
            _view.page = 1;
            WatchUi.requestUpdate();
            return true;
        }
        return false;
    }

    function onNextPage() as Boolean {
        if (_view.page >= 1 && _view.page < 3) {
            _view.page++;
            WatchUi.requestUpdate();
            return true;
        }
        return false;
    }

    function onPreviousPage() as Boolean {
        if (_view.page > 1) {
            _view.page--;
            WatchUi.requestUpdate();
            return true;
        }
        return false;
    }
}
