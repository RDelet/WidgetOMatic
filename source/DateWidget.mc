import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
using Toybox.Time.Gregorian;
using Toybox.WatchUi as Ui;

class DateWidget {

    private var centerX;
    private var centerY;
    private var fontSize = Graphics.FONT_XTINY;
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

    public function setFontSize(size as Number) as Void{
        fontSize = size;
    }

    public function update(dc as Dc) as Void {
        today = Gregorian.info(Time.now(), Time.FORMAT_LONG);
        text = Lang.format("$1$$2$", [today.month, today.day]);
        textDimension = dc.getTextDimensions(text, fontSize);
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
            posY -= dc.getTextDimensions(text, fontSize)[1] * 0.5;
        }
        dc.setColor(dateColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX, posY, fontSize, text,
                    Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    private function updateSettings() {
        if (updateDateSettings) {
            dateColor = getSettingColor("DateColor");
            updateDateSettings = false;
        }
    }

}