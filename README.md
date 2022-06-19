# Swift Charts Examples
An overview of the different types of charts you can make with Swift Charts

<img width="1511" alt="image" src="https://user-images.githubusercontent.com/170948/173253882-1a80b934-a0b9-4acb-a290-a299ae3fdd7d.png">

Let's start by recreating the different chart examples that Apple gave in these session screenshots.

## Included Charts

- [x] Basis project setup
- [x] Simple Line chart
- [x] Line chart with lollipop
- [x] Heartbeat Chart
- [x] Simple Bar chart
- [x] Simple dual bar chart
- [x] Range Chart
- [x] Pyramid Chart
- [x] Area Chart
- [x] Range with Max and Min Chart
- [x] One dimensional bar
- [x] Heatmap Block Chart
- [x] Scatter Chart
- [x] Heartbeat range Chart
- [x] Vector Field

## Todo
- [ ] Cumulative line Chart
- [ ] Distribution line + Point Chart
- [ ] Funky Gradient Chart
- [ ] Other Charts
- [ ] Multi-language Support
- [ ] Make all charts accessible

See the [open issues](https://github.com/jordibruin/SwiftChartExamples/issues) if you think anything is missing from this list. You can also contact me on [Twitter](https://www.twitter.com/jordibruin) if you have any suggestions or feedback.

## Chart Types

### [Line Charts](https://github.com/jordibruin/SwiftChartExamples/tree/main/Swift%20Charts%20Examples/Charts/LineCharts)

Line Chart

![](images/charts/line/singleLine.png)

Line Chart with Lollipop

![](images/charts/line/singleLineLollipop.png)

Heart Beat / ECG Chart

![](images/charts/line/heartBeat.png)

### [Bar Charts](https://github.com/jordibruin/SwiftChartExamples/tree/main/Swift%20Charts%20Examples/Charts/BarCharts)

Single Bar

![](images/charts/bar/singleBar.png)

Single Bar with Threshold Rule Mark

![](images/charts/bar/singleBarThreshold.png)

Two Bars

![](images/charts/bar/twoBars.png)

Pyramid

![](images/charts/bar/pyramid.png)

One Dimensional Bar

![](images/charts/bar/oneDimensionalBar.png)

Time Sheet Bar

![](images/charts/bar/timeSheetBar.png)

### [Area Charts](https://github.com/jordibruin/SwiftChartExamples/tree/main/Swift%20Charts%20Examples/Charts/AreaCharts)

Area Chart

![](images/charts/area/areaSimple.png)

### [Range Charts](https://github.com/jordibruin/SwiftChartExamples/tree/main/Swift%20Charts%20Examples/Charts/RangeCharts)

Range Chart

![](images/charts/range/rangeSimple.png)

Heart Rate Range Chart

![](images/charts/range/rangeHeartRate.png)

### [Heat Maps](https://github.com/jordibruin/SwiftChartExamples/tree/main/Swift%20Charts%20Examples/Charts/HeatMap)

Customizable Heat Map

![](images/charts/heatMap/customizeableHeatMap.png)

### [Point Charts](https://github.com/jordibruin/SwiftChartExamples/tree/main/Swift%20Charts%20Examples/Charts/PointCharts)

Scatter Chart

![](images/charts/point/scatter.png)

Vector Field

![](images/charts/point/vectorField.png)

## How to add a new chart

Each chart needs a preview chart as well as a detail view. The preview chart is used in the home screen of the app for easier navigation. Look at the Simple Chart Simple code to see what the format should be for the preview charts. On the detail view, make sure you add some customisation options in a separate section from the chart.

<img src="images/charts_wwdc_slide.png">
Source: https://developer.apple.com/videos/play/wwdc2022/10137/
