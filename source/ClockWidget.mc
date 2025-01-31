import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
using Toybox.Time.Gregorian;
using Toybox.WatchUi as Ui;

class ClockWidget {

    private var maxRadius;
    private var minRadius;
    private var today;
    private var penWidth;
    private var hoursColor = Graphics.COLOR_WHITE;
    private var analogHoursColor = Graphics.COLOR_WHITE;
    private var minutesColor = Graphics.COLOR_WHITE;
    private var analogMinutesColor = Graphics.COLOR_WHITE;
    private var secondsColor = Graphics.COLOR_WHITE;
    private var angleStep = Math.toRadians(360 / 60);

    function initialize() {}

    public function setPosition(x as Number, y as Number) {
        maxRadius = centerX - borderOffset;
        minRadius = maxRadius - radiusOffset;
        penWidth = maxRadius - minRadius;
    }

    private function drawMarkers(dc as Dc) {
        dc.setPenWidth(1);
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
        for (var i = 0; i < 60; i += 5) {
            var angle = (i / 60.0) * 2 * Math.PI;
            var startX = centerX + maxRadius * Math.cos(angle);
            var startY = centerY + maxRadius * Math.sin(angle);
            var endX = centerX + (minRadius - 3) * Math.cos(angle);
            var endY = centerY + (minRadius - 3) * Math.sin(angle);
            dc.drawLine(startX, startY, endX, endY);
        }
    }

    private function drawSeconds(dc as Dc) {
        var startAngle = Math.toDegrees(Math.PI / 2.0);
        var radius = minRadius + radiusOffset * 0.75;
        dc.setPenWidth(penWidth / 2);
        dc.setColor(secondsColor, Graphics.COLOR_TRANSPARENT);
        for (var i = 0; i < 60; i++) {
            var pos = computeRadialPosition(i, angleStep, radius);
            if (today.min % 2 == 0) {
                if (i < today.sec) {
                    dc.drawCircle(pos.x, pos.y, penWidth * 0.1);
                }
            } else {
                if (i >= today.sec) {
                    dc.drawCircle(pos.x, pos.y, penWidth * 0.1);
                }
            }
            startAngle -= angleStep;
        }
    }

    private function drawMinutes(dc as Dc) {
        var startAngle = Math.toDegrees(Math.PI / 2.0);
        dc.setPenWidth(penWidth / 2);
        dc.setColor(minutesColor, Graphics.COLOR_TRANSPARENT);
        for (var i = 0; i < 60; i++) {
            var pos = computeRadialPosition(i, angleStep, minRadius);
            if (today.hour % 2 == 0) {
                if (i < today.min) {
                    dc.drawCircle(pos.x, pos.y, penWidth * 0.1);
                }
            } else {
                if (i >= today.min) {
                    dc.drawCircle(pos.x, pos.y, penWidth * 0.1);
                }
            }
            startAngle -= angleStep;
        }
    }

    private function drawHours(dc as Dc) {
        var angleStep = 360.0 / 12.0;
        var startAngle = Math.toDegrees(Math.PI / 2.0) + -angleStep * today.hour;
        var direction = Graphics.ARC_CLOCKWISE;
        var endAngle = startAngle - angleStep;

        dc.setPenWidth(penWidth / 2);
        dc.setColor(hoursColor, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(centerX, centerY, minRadius + (radiusOffset * 0.75), direction, startAngle, endAngle);
    }

    private function drawAnalog(dc as Dc) as Void {
        if (showAnalog) {
            var today = Time.Gregorian.info(Time.now(), Time.FORMAT_LONG);
            var hourTxt = today.hour.format("%02d");
            var colonTxt = ":";
            var minTxt = today.min.format("%02d");
            // Settings
            var justify = Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER;
            var hourWidth = dc.getTextDimensions(hourTxt, timeSize)[0];
            var colonWidth = dc.getTextDimensions(colonTxt, timeSize)[0];
            var minWidth = dc.getTextDimensions(minTxt, timeSize)[0];
            var height = dc.getTextDimensions(hourTxt, timeSize)[1];
            var totalWidth = hourWidth + colonWidth + minWidth + 4;
            var startX = centerX - (totalWidth / 2);
            var posY = centerY + height * 0.25;
            // Hour
            dc.setColor(analogHoursColor, Graphics.COLOR_TRANSPARENT);
            dc.drawText(startX, posY, timeSize, hourTxt, justify);
            // Separator
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            startX += hourWidth + 2;
            dc.drawText(startX, posY, timeSize, colonTxt, justify);
            // Minutes
            startX += colonWidth + 2;
            dc.setColor(analogMinutesColor, Graphics.COLOR_TRANSPARENT);
            dc.drawText(startX, posY, timeSize, minTxt, justify);
        }
    }

    public function draw(dc as Dc) {
        today = Gregorian.info(Time.now(), Time.FORMAT_LONG);
        updateSettings();
        drawMarkers(dc);
        drawHours(dc);
        drawSeconds(dc);
        drawMinutes(dc);
        drawAnalog(dc);
    }

    private function updateSettings() {
        if (updateClockSettings) {
            showAnalog = getSetting("DrawAnalogClock");
            hoursColor = getSettingColor("HourColor");
            analogHoursColor = getSettingColor("AnalogHourColor");
            minutesColor = getSettingColor("MinColor");
            analogMinutesColor = getSettingColor("AnalogMinColor");
            secondsColor = getSettingColor("SecColor");
            timeSize = getSetting("TimeSize");
            updateClockSettings = false;
        }
    }
}