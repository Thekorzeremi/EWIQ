// EWIQ - Evening Widget IQ
// Copyright (C) 2026 Thekorzeremi
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.

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
