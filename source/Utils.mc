import Toybox.Application;
import Toybox.Graphics;
import Toybox.Math;
import Toybox.Lang;
using Toybox.WatchUi as Ui;


public var distanceIcon = Ui.loadResource(Rez.Drawables.Distance);
public var climbedIcon = Ui.loadResource(Rez.Drawables.Climbed);
public var caloriesIcon =  Ui.loadResource(Rez.Drawables.Calories);
public var heartIcon = Ui.loadResource(Rez.Drawables.HeartIcon);
public var stepsIcon = Ui.loadResource(Rez.Drawables.Steps);
public var breathIcon = Ui.loadResource(Rez.Drawables.Breath);
public var stressIcon = Ui.loadResource(Rez.Drawables.Stress);
public var batteryIcon = Ui.loadResource(Rez.Drawables.Battery);
public var sunIcon = Ui.loadResource(Rez.Drawables.Sun);
public var defaultIcon = Ui.loadResource(Rez.Drawables.Default);


// Constants
public enum WidgetType {NO_WIDGET = 0,
                        DISTANCE,
                        CLIMBED,
                        HEART_RATE,
                        CALORIES,
                        STEPS,
                        RESPIRATION_RATE,
                        STRESS_SCORE,
                        BATTERY,
                        SOLAR_INTENSITY,
                        DEFAULT}

public var settingColor = {0 => Graphics.COLOR_WHITE,
                           1 => Graphics.COLOR_RED,
                           2 => Graphics.COLOR_DK_RED,
                           3 => Graphics.COLOR_ORANGE,
                           4 => Graphics.COLOR_YELLOW,
                           5 => Graphics.createColor(255, 0, 255, 255), // Light Blue
                           6 => Graphics.COLOR_BLUE,
                           7 => Graphics.COLOR_DK_BLUE,
                           8 => Graphics.COLOR_GREEN,
                           9 => Graphics.COLOR_DK_GREEN,
                           10 => Graphics.COLOR_PURPLE,
                           11 => Graphics.COLOR_PINK};

public function getSetting(settingName as String) {
    return Application.Properties.getValue(settingName);
}

public function getSettingColor(settingName as String) as Number {
    var color = settingColor.get(getSetting(settingName));
    if (color == null) {
        color = Graphics.COLOR_WHITE;
    }

    return color;
}

public class Vector2 {
    public var x;
    public var y;
    function initialize(_x as Number, _y as Number) { x = _x; y = _y; }
}

public function toMeters(value as Number) as Number {
    return value / 100;
}

public function toKiloMeters(value as Number) as Float {
    return value.toFloat() * 1e-5;
}

public var borderOffset = 2;
public var radiusOffset = 10;
public var angleOffset = Math.toRadians(-90);
public var updateViewSettings = true;
public var updateClockSettings = true;
public var updateDateSettings = true;
public var showLines = true;
public var showAnalog = true;