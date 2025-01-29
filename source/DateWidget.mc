import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
using Toybox.Time.Gregorian;
using Toybox.WatchUi as Ui;

class DateWidget {

    private var centerX;
    private var centerY;
    private var text;
    private var textDimension as Array<Number> = [0, 0];
    private var dateColor = Graphics.COLOR_WHITE;
    public var today = Gregorian.info(Time.now(), Time.FORMAT_LONG);

    function initialize() {
        today = Gregorian.info(Time.now(), Time.FORMAT_LONG);
        text = Lang.format("$1$ $2$", [today.day, today.month]);
    }

    public function setPosition(x as Number, y as Number) as Void {
        centerX = x;
        centerY = y;
    }

    public function update(dc as Dc) as Void {
        today = Gregorian.info(Time.now(), Time.FORMAT_LONG);
        text = Lang.format("$1$$2$", [today.month, today.day]);
        textDimension = dc.getTextDimensions(text, dateSize);
    }

    public function height() as Number {
        return textDimension[1];
    }

    public function width() as Number {
        return textDimension[0];
    }

    public function draw(dc as Dc) {
        updateSettings();
        var posY = centerY;
        if (showAnalog){
            posY -= dc.getTextDimensions(text, dateSize)[1] * 0.5;
        }
        dc.setColor(dateColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX, posY, dateSize, text,
                    Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    private function updateSettings() {
        if (updateDateSettings) {
            dateColor = getSettingColor("DateColor");
            dateSize = getSetting("DateSize");
            updateDateSettings = false;
        }
    }

}