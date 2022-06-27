# Swift Charts Examples
This repo aims to provide sample code for lots of different chart types for you to use as inspiration for your own projects. We start by recreating the sample charts Apple uses in their sessions related to Swift Charts. The goal is to make each chart type customizable, accessible and flexible so that you can easily change it to your needs.

<img width="1511" alt="image" src="https://user-images.githubusercontent.com/170948/173253882-1a80b934-a0b9-4acb-a290-a299ae3fdd7d.png">

## Todo
- [ ] Other Charts
- [ ] Multi-language Support
- [ ] Screen time like bar chart with stacked colors
- [ ] First row, second bar with the lines with blocks in the middle
- [ ] Sleep stages chart
- [ ] iPhone battery percentage screen with different colors and overlaid bar
- [ ] Make all charts accessible

See the [open issues](https://github.com/jordibruin/SwiftChartExamples/issues) if you think anything is missing from this list. You can also contact me on [Twitter](https://www.twitter.com/jordibruin) if you have any suggestions or feedback.

## How to add a new chart

Each chart needs a preview chart as well as a detail view. The preview chart is used in the home screen of the app for easier navigation. Look at the Simple Line Chart code to see what the format should be for the preview charts. On the detail view, make sure you add some customisation options in a separate section from the chart. If you have any questions feel free to create an [issue](https://github.com/jordibruin/SwiftChartExamples/issues).

<img src="images/charts_wwdc_slide.png">
Source: https://developer.apple.com/videos/play/wwdc2022/10137/


## Chart Types

### [Line Charts](https://github.com/jordibruin/SwiftChartExamples/tree/main/Swift%20Charts%20Examples/Charts/LineCharts)

Line Chart

<img src="images/charts/line/singleLine.png" width="380">

Line Chart with Lollipop

<img src="images/charts/line/singleLineLollipop.png" width="380">

Heart Beat / ECG Chart

<img src="images/charts/line/heartBeat.png" width="380">

Animating Line

<img src="images/charts/line/animatingLine.png" width="380">

Line with changing gradient

<img src="images/charts/line/gradientLine.png" width="380">

Line Charts

<img src="images/charts/line/multiLine.png" width="380">

Line Point

<img src="images/charts/line/linePoint.png" width="380">

### [Bar Charts](https://github.com/jordibruin/SwiftChartExamples/tree/main/Swift%20Charts%20Examples/Charts/BarCharts)

Single Bar

<img src="images/charts/bar/singleBar.png" width="380">

Single Bar with Threshold Rule Mark

<img src="images/charts/bar/singleBarThreshold.png" width="380">

Two Bars

<img src="images/charts/bar/twoBars.png" width="380">

Pyramid

<img src="images/charts/bar/pyramid.png" width="380">

One Dimensional Bar

<img src="images/charts/bar/oneDimensionalBar.png" width="380">

Time Sheet Bar

<img src="images/charts/bar/timeSheetBar.png" width="380">

Sound Bar

<img src="images/charts/bar/soundBar.png" width="380">

### [Area Charts](https://github.com/jordibruin/SwiftChartExamples/tree/main/Swift%20Charts%20Examples/Charts/AreaCharts)

Area Chart

<img src="images/charts/area/areaSimple.png" width="380">

Stacked Area Chart

<img src="images/charts/area/stackedArea.png" width="380">

### [Range Charts](https://github.com/jordibruin/SwiftChartExamples/tree/main/Swift%20Charts%20Examples/Charts/RangeCharts)

Range Chart

<img src="images/charts/range/rangeSimple.png" width="380">

Heart Rate Range Chart

<img src="images/charts/range/rangeHeartRate.png" width="380">

Candle Stick Chart

<img src="images/charts/range/candleStick.png" width="380">

### [Heat Maps](https://github.com/jordibruin/SwiftChartExamples/tree/main/Swift%20Charts%20Examples/Charts/HeatMap)

Customizable Heat Map

<img src="images/charts/heatMap/customizeableHeatMap.png" width="380">

GitHub Contributions Graph

<img src="images/charts/heatMap/gitContributions.png" width="380">

### [Point Charts](https://github.com/jordibruin/SwiftChartExamples/tree/main/Swift%20Charts%20Examples/Charts/PointCharts)

Scatter Chart

<img src="images/charts/point/scatter.png" width="380">

Vector Field

<img src="images/charts/point/vectorField.png" width="380">

