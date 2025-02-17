
import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Math;
import Toybox.Sensor;
using Toybox.ActivityMonitor as Act;
import Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.WatchUi as Ui;


class View extends WatchUi.WatchFace {

    private var clockWidget;
    private var dateWidget;
    private var widgets as Array<Widget> = [];
    private var drawableWidgets = [];
    private var numWidgets;
    private var angleStep;
    private var WidgetsRadius;
    public var bluetoothTimer = 0;

    function initialize() {
        WatchFace.initialize();
    }

    function onLayout(dc as Dc) as Void {
        dc.setAntiAlias(true);
        setLayout(Rez.Layouts.WatchFace(dc));

        centerX = dc.getWidth() / 2;
        centerY = dc.getHeight() / 2;

        clockWidget = new ClockWidget();
        clockWidget.setPosition(centerX, centerY);
        dateWidget = new DateWidget();
        dateWidget.setPosition(centerX, centerY);
        createWidgets();
    }

    function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);
        updateSettings();
        clockWidget.draw(dc);
        drawDate(dc);
        drawWidgets(dc);
    }

    function onPartialUpdate(dc as Dc) {
        WatchUi.requestUpdate();
    }

    private function drawDate(dc as Dc) as Void {
        dateWidget.update(dc);
        dateWidget.setPosition(centerX, centerY);
        dateWidget.draw(dc);
    }

    private function drawWidgets(dc as Dc) as Void {
        for (var i = 0; i < numWidgets; i++) {
            var widget = widgets[i];
            widget.update();
            widget.draw(dc);
        }
    }

    private function createWidgets(){
        widgets = [];
        for (var i = 0; i < drawableWidgets.size(); i++) {
            var widget = new Widget(drawableWidgets[i]); // ToDo: find solution to avoid warning
            widget.setPosition(computeRadialPosition(i, angleStep, WidgetsRadius));
            widgets.add(widget);
        }
    }

    public function getDrawableWidgets() as Array {
        var widgets = [];
        var alreadyUsedWidget = [];
        for (var i = 0; i < 8; i++) {
            var widgetValue = getSetting("Widget_" + (i + 1).toString());
            if (widgetValue != 0 && alreadyUsedWidget.indexOf(widgetValue) == -1) {
                widgets.add(widgetValue);
                alreadyUsedWidget.add(widgetValue);
            }
        }
        
        return widgets;
    }

    private function updateSettings() {
        if (updateViewSettings) {
            WidgetsRadius = getSetting("WidgetsRadius");
            drawableWidgets = getDrawableWidgets();
            numWidgets = drawableWidgets.size();
            if (numWidgets == 0) {
                angleStep = 0;
            } else {
                angleStep = Math.toRadians(360 / numWidgets);
            }
            createWidgets();
            updateViewSettings = false;
        }
    }

}
