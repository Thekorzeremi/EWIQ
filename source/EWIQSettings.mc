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

import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Application;
import Toybox.Lang;

class RangeFactory extends WatchUi.PickerFactory {

    private var _min as Number;
    private var _max as Number;

    function initialize(minVal as Number, maxVal as Number) {
        PickerFactory.initialize();
        _min = minVal;
        _max = maxVal;
    }

    function getSize() as Number {
        return _max - _min + 1;
    }

    function getValue(item as Number) as Object? {
       return _min + item;
    }

    function getDrawable(item as Number, isSelected as Boolean) as WatchUi.Drawable? {
        var value = _min + item;
        return new WatchUi.Text({
            :text => value.format("%02d"),
            :color => isSelected ? Graphics.COLOR_WHITE : Graphics.COLOR_LT_GRAY,
            :font => Graphics.FONT_NUMBER_MEDIUM,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => WatchUi.LAYOUT_VALIGN_CENTER
        });
      }
      
}

class HourPickerDelegate extends WatchUi.PickerDelegate {

    function initialize() {
        PickerDelegate.initialize();
    }

    function onAccept(values as Array) as Boolean {
        var hour = values[0] as Number;
        Application.Properties.setValue("TriggerHour", hour);
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }

    function onCancel() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }
}

class MinutePickerDelegate extends WatchUi.PickerDelegate {

    function initialize() {
        PickerDelegate.initialize();
    }

    function onAccept(values as Array) as Boolean {
        var minute = values[0] as Number;
        Application.Properties.setValue("TriggerMinute", minute);
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }

    function onCancel() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }
}

class SettingsMenuDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        var id = item.getId();

        if (id == :item_hour) {
            var current = Application.Properties.getValue("TriggerHour") as Number;
            var picker = new WatchUi.Picker({
                :title => new WatchUi.Text({
                    :text => "Heure",
                    :color => Graphics.COLOR_WHITE,
                    :font => Graphics.FONT_TINY,
                    :locX => WatchUi.LAYOUT_HALIGN_CENTER,
                    :locY => WatchUi.LAYOUT_VALIGN_TOP
                }),
                :pattern => [new RangeFactory(0, 23)],
                :defaults => [current]
            });
            WatchUi.pushView(picker, new HourPickerDelegate(), WatchUi.SLIDE_IMMEDIATE);

        } else if (id == :item_minute) {
            var current = Application.Properties.getValue("TriggerMinute") as Number;
            var picker = new WatchUi.Picker({
                :title => new WatchUi.Text({
                    :text => "Minute",
                    :color => Graphics.COLOR_WHITE,
                    :font => Graphics.FONT_TINY,
                    :locX => WatchUi.LAYOUT_HALIGN_CENTER,
                    :locY => WatchUi.LAYOUT_VALIGN_TOP
                }),
                :pattern => [new RangeFactory(0, 59)],
                :defaults => [current]
            });
            WatchUi.pushView(picker, new MinutePickerDelegate(), WatchUi.SLIDE_IMMEDIATE);
        }
    }
}

function showSettingsMenu() as Void {
    var menu = new WatchUi.Menu2({ :title => "Reglages EWIQ" });
    menu.addItem(new WatchUi.MenuItem("Heure rapport", null, :item_hour, null));
    menu.addItem(new WatchUi.MenuItem("Minute rapport", null, :item_minute, null));
    WatchUi.pushView(menu, new SettingsMenuDelegate(), WatchUi.SLIDE_IMMEDIATE);
}
