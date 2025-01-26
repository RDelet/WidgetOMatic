import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Activity;
using Toybox.ActivityMonitor as Act;
using Toybox.WatchUi as Ui;


class Widget {

    private static var info;
    private var type;
    private var centerX;
    private var centerY;
    private var textColor = Graphics.COLOR_WHITE;
    private var fontSize = Graphics.FONT_XTINY;
    public var value = 0;
    public var icon = defaultIcon;
    public var text = "--";
    
    function initialize(_type as WidgetType) {
        type = _type;
        getInfo();
    }

    public function getInfo() as Void {
        if (isSystemStats()) {
            info = System.getSystemStats();
        } else {
            info = Act.getInfo();
        }
    }

    private function getDistance() as Number { return info.distance; }
    private function getFloorsClimbed() as Number { return info.floorsClimbed; }
    private function getCalories() as Number { return info.calories;}
    private function getRespirationRate() as Number { return info.respirationRate;}
    private function getSteps() as Number { return info.steps; }
    private function getStressScore() as Number { return info.stressScore; }
    private function getBattery() as Float { return info.battery; }
    private function getSolarIntensity() as Float or Null { return info.solarIntensity; }
    private function getDefault() as Number { return 0; }
    public function setPosition(pos as Vector2) as Void { centerX = pos.x; centerY = pos.y; }
    public function setTextColor(color as Number) as Void{ textColor = color; }
    public function setFontSize(size as Number) as Void{ fontSize = size; }
    public function isSystemStats() as Boolean { return type == BATTERY || type == SOLAR_INTENSITY; }

    private function getHeartRate() as Number {
        var heartRate = Activity.getActivityInfo().currentHeartRate;
        if (heartRate == null && heartRate == 255) {
            if (ActivityMonitor has :getHeartRateHistory) {
                var hrHist =  ActivityMonitor.getHeartRateHistory(1, true);
                heartRate = hrHist.next().heartRate;
            }
        }
        return heartRate;
    }

    private function getValue() {
        // Switch case dno't works...
        if (type == HEART_RATE) { value = getHeartRate();}
        else if (type == CLIMBED) { value = getFloorsClimbed(); }
        else if (type == DISTANCE) { value = getDistance(); }
        else if (type == CALORIES) { value = getCalories(); }
        else if (type == STEPS) { value = getSteps(); }
        else if (type == RESPIRATION_RATE) { value = getRespirationRate(); }
        else if (type == STRESS_SCORE) { value = getStressScore(); }
        else if (type == BATTERY) { value = getBattery() as Number; }
        else if (type == SOLAR_INTENSITY) { value = getSolarIntensity() as Number; }
        else { value = 0; }

        if (value == null) { value = 0; }
    }

    private function getIcon() as Graphics.BitmapReference {
        switch (type) {
            case HEART_RATE:
                return heartIcon;
            case CLIMBED:
                return climbedIcon;
            case DISTANCE:
                return distanceIcon;
            case CALORIES:
                return caloriesIcon;
            case STEPS:
                return stepsIcon;
            case RESPIRATION_RATE:
                return breathIcon;
            case STRESS_SCORE:
                return stressIcon;
            case BATTERY:
                return batteryIcon;
            case SOLAR_INTENSITY:
                return sunIcon;
            default:
                return defaultIcon;
        }
    }

    private function getTextFormat() as String {
        if (value == 100) {
            return "%03d";
        } else {
            return "%02d";
        }
    }

    private function getText() as String {
        getValue();
        if (value == null) {
            return "--";
        } else {
            if (isSystemStats()) {
                var txtF = value.format(getTextFormat());
                if (type == BATTERY) {
                    return txtF + "%";
                } else {
                    return txtF;
                }
            } else if (type == DISTANCE){
                if (value < 100000) {
                    return toMeters(value).toString() + "m";
                }
                else {
                    return toKiloMeters(value).format("%.2f") + "km";
                }
            } else {
                return value.toString();
            }
        }
    }

    public function update() as Void {
        getInfo();
        icon = getIcon();
        text = getText();
    }
    
    public function draw(dc as Dc) {
        var txtDim = dc.getTextDimensions(text, fontSize);
        dc.setColor(textColor, Graphics.COLOR_TRANSPARENT);
        dc.drawBitmap(centerX - icon.getWidth() * 0.5, centerY - icon.getHeight() * 0.75, icon);
        dc.drawText(centerX, centerY + txtDim[1] * 0.25, fontSize, text, Graphics.TEXT_JUSTIFY_CENTER);
    }

}